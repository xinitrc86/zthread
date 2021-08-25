class ltc_thread_pool_executor definition final for testing
  duration short
  risk level harmless
  inheriting from zcl_assert.

  public section.
    interfaces zif_thread_callback.
  private section.
    data:
      o_cut        type ref to zif_executor_service,
      v_calledback type i.
    methods:
      setup,
      it_submits_runnables for testing.
endclass.


class ltc_thread_pool_executor implementation.


  method setup.
    v_calledback = 0.
    o_cut = new zcl_thread_pool_executor( 3 ).
  endmethod.

  method zif_thread_callback~on_result.
     v_calledback = v_calledback + 1.
  endmethod.


  method it_submits_runnables.

    data(lo_dummy) = new zcl_runnable_dummy( ).
    o_cut->submit(
        io_callback = me
        io_runnable = lo_dummy
    ).
    wait up to '0.2' seconds.

    assert_equals(
        exp = 1
        act = v_calledback
        msg = 'Should have executed the runnable in a new Thread'
    ).


  endmethod.


endclass.
