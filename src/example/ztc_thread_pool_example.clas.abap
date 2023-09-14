class ztc_thread_pool_example definition
  public
  final
  create public
  for testing
  inheriting from zcl_assert
  risk level harmless
  duration short.

  public section.
    interfaces zif_thread_callback.
  protected section.
  private section.
    data v_final_sum type i.
    methods:
      it_sums_numbers for testing.
endclass.



class ztc_thread_pool_example implementation.

  method it_sums_numbers.


    "The fixed pool executor will ensure that: no matter how many threads are submitted/invoked
    "only <iv_threads> number of threads will be running in parallel at the same time

    data lt_runnables type zif_executor_service=>tty_runnables.
    data(lo_fixed_pool) = zcl_executors=>new_fixed_thread_pool(
                          iv_threads        = 3
                          io_callback       = me ).


    "you can use submit( )...
    do 20 times.
        data(lo_runnable1) = new lcl_sum_numbers( value #(
            ( 10 ) ( 20 ) ( 30 )
        ) ).

        "A future represents the result of an async computation
        data(lo_future) = lo_fixed_pool->submit( lo_runnable1 ).

        append lo_runnable1 to lt_runnables.


    enddo.

    "...or you can use invoke all.
    data(lt_futures) = lo_fixed_pool->invoke_all( lt_runnables ).

    "A get in a future will make the running code to wait for the thread to finish
    data(lo_result) = cast lcl_sum_numbers( lo_future->get(  ) ).
    assert_equals(
        exp = 60
        act = lo_result->get_sum(  )
    ).

    "Waiting for a specific thread to complete
    lo_future = lt_futures[ 1 ].
    lo_result = cast lcl_sum_numbers( lo_future->get( ) ).
    assert_equals(
        exp = 60
        act = lo_result->get_sum(  )
    ).

    "Waiting for all threads to complete
    lo_fixed_pool->await_termination(  ).

    assert_equals(
        exp = 2400
        act = v_final_sum
    ).


  endmethod.

  method zif_thread_callback~on_result.
    data(lv_thread_sum) = cast lcl_sum_numbers( io_result )->get_sum( ).
    v_final_sum = v_final_sum + lv_thread_sum.
  endmethod.

  method zif_thread_callback~on_error.
    fail( 'not expected' ).
  endmethod.

endclass.
