class ltc_executors definition final for testing
  duration short
  risk level harmless
  inheriting from zcl_assert.

  public section.
    interfaces zif_thread_callback.
  private section.
    data:
        o_cut type ref to ZCL_EXECUTORS,
        v_collected type i.
    methods:
      setup,
      it_returns_single_thread for testing,
      it_returns_fixed_pool for testing,
      it_pass_callback_and_factory for testing.
endclass.


class ltc_executors implementation.


  method setup.
    clear v_collected.
  endmethod.

  method it_returns_single_thread.

    assert_bound( zcl_executors=>new_single_thread_executor(  ) ).

  endmethod.

  method it_returns_fixed_pool.

    assert_bound( zcl_executors=>new_fixed_thread_pool( 2 ) ).

  endmethod.

  method it_pass_callback_and_factory.

    data(lo_deactivated) = new zcl_deactivated_thread_factory(  ).
    lo_deactivated->set_thread_call_result(
        iv_thread_num = 1
        io_result     = new zcl_dummy_runnable_result( )
    ).
    lo_deactivated->set_thread_call_result(
        iv_thread_num = 2
        io_result     = new zcl_dummy_runnable_result(  )
    ).

    data(lo_executor) = zcl_executors=>new_fixed_thread_pool(
        iv_threads = 2
        io_callback = me
        io_thread_factory  = lo_deactivated ).


    lo_executor->submit( new zcl_runnable_dummy( 1 ) ).
    lo_executor->submit( new zcl_runnable_dummy( 1 ) ).
    lo_executor->await_termination(  ).

    assert_equals(
        exp = 2
        act = lines( lo_deactivated->get_created_threads(  ) )
        msg = 'Should have passed factory'
    ).

    assert_equals(
        exp = 2
        act = v_collected
        msg = 'Should have passed call back'
    ).



  endmethod.


  method zif_thread_callback~on_error.
    v_collected = v_collected + 1.
  endmethod.

  method zif_thread_callback~on_result.
    v_collected = v_collected + 1.
  endmethod.

endclass.
