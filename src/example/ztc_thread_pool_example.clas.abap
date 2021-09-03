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


    "this the fixed pool executor will ensure that now matter how many threads are submitted/involed
    "only iv_threads will be running in parallel at the same time

    data lt_runnables type zif_executor_service=>tty_runnables.
    data(lo_fixed_pool) = zcl_executors=>new_fixed_thread_pool(
                          iv_threads        = 3
                          io_callback       = me ).


    "using submit
    do 20 times.
        data(lo_runnable1) = new lcl_sum_numbers( value #(
            ( 10 ) ( 20 ) ( 30 )
        ) ).

        "a future represents the result of an async computation
        data(lo_future) = lo_fixed_pool->submit( lo_runnable1 ).

        append lo_runnable1 to lt_runnables.


    enddo.

    "using invoke_all
    "a future represents the result of an async computation
    data(lt_futures) = lo_fixed_pool->invoke_all( lt_runnables ).
    "by this point 40 threads are created


    "a get in a future will make the program wait for that
    "specific thread to complete
    data(lo_result) = cast lcl_sum_numbers( lo_future->get(  ) ).
    assert_equals(
        exp = 60
        act = lo_result->get_sum(  )
    ).

    "a get in a future will make the program wait for that
    "specific thread to complete
    lo_future = lt_futures[ 1 ].
    lo_result = cast lcl_sum_numbers( lo_future->get( ) ).
    assert_equals(
        exp = 60
        act = lo_result->get_sum(  )
    ).

    "awaits termination of all threads in the pool
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
