class ztc_thread_example definition
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



class ztc_thread_example implementation.

  method it_sums_numbers.
    "creates three runnables,
    "have a look on the "local types"  for the definition of the runnable and the result



    "10 + 20 + 30 + 40 + 50 + 60 + 70 + 80 + 90 = 450

    data(lo_runnable1) = new lcl_sum_numbers( value #(
        ( 10 ) ( 20 ) ( 30 )
    ) ).

    data(lo_runnable2) = new lcl_sum_numbers( value #(
        ( 40 ) ( 50 ) ( 60 )
    ) ).

    data(lo_runnable3) = new lcl_sum_numbers( value #(
        ( 70 ) ( 80 ) ( 90 )
    ) ).


    data lo_thread_factory type ref to zif_thread_factory.
    lo_thread_factory = new zcl_default_thread_factory(  ).

    "thread (fork) their execution,
    "here I'm just passing myself as callback,
    "check zif_thread_callback~on_callback below
    lo_thread_factory->new_thread(
        io_runnable = lo_runnable1
        io_callback = me
    )->start(  ).


    "other way of creating threasd
    new zcl_thread(
        io_runnable = lo_runnable2
        io_callback = me
    )->start(  ).

    lo_thread_factory->new_thread(
        io_runnable = lo_runnable3
        io_callback = me
    )->start(  ).


    "wait (join) them and check the sum done by the callback
    zcl_thread=>join_all(  ).
    assert_equals(
        exp = 450
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
