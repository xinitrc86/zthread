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
      it_submits_runnables for testing,
      it_invokes_all_and_waits for testing,
      it_shutsdown for testing,
      it_returns_futures for testing.
endclass.


class ltc_thread_pool_executor implementation.


  method setup.
    v_calledback = 0.
    o_cut = new zcl_thread_pool_executor(
        iv_pool_size = 3
        io_callback = me ).
  endmethod.

  method zif_thread_callback~on_result.
     v_calledback = v_calledback + 1.
  endmethod.

  method zif_thread_callback~on_error.
    v_calledback = v_calledback + 1.
  endmethod.


  method it_submits_runnables.

    data(lo_dummy) = new zcl_runnable_dummy( ).
    o_cut->submit( lo_dummy ).
    wait up to '0.2' seconds.

    assert_equals(
        exp = 1
        act = v_calledback
        msg = 'Should have executed the runnable in a new Thread'
    ).


  endmethod.

  method it_invokes_all_and_waits.

    data(lt_runnables) = value zif_executor_service=>tty_runnables(  ).
    do 30 times.
        append new zcl_runnable_dummy( ) to lt_runnables.
    enddo.

    o_cut->invoke_all( lt_runnables ).
    o_cut->invoke_all( lt_runnables ).

    o_cut->await_termination(  ).

    assert_equals(
        exp = 60
        act = v_calledback
    ).

  endmethod.

  method it_shutsdown.

    data(lo_dummy) = new zcl_runnable_dummy( ).
    o_cut->submit( lo_dummy ).
    wait up to '0.2' seconds.

    assert_equals(
        exp = 1
        act = v_calledback
        msg = 'Should have executed the runnable in a new Thread'
    ).


    o_cut->shutdown(  ).

    try.
        o_cut->submit( lo_dummy ).
    catch zcx_rejected_execution into data(lo_submit_failure).
        assert_bound( lo_submit_failure ).
    endtry.
    assert_bound( lo_submit_failure ).


    try.
        o_cut->invoke_all( value #( ( lo_dummy ) ) ).
    catch zcx_rejected_execution into data(lo_invoke_failure).
        assert_bound( lo_invoke_failure ).
    endtry.
    assert_bound( lo_invoke_failure ).


  endmethod.

  method it_returns_futures.

      data(lo_dummy) = new zcl_runnable_dummy( ).

      "submit
      data(lo_future) = o_cut->submit( lo_dummy ).
      assert_bound( lo_future ).
      assert_true( cast zcl_runnable_dummy( lo_future->get(  ) )->was_run_called( ) ).

      "invoke_all
      data(lt_futures) = o_cut->invoke_all( value #( ( lo_dummy ) ( lo_dummy ) ) ).
      loop at lt_futures into lo_future.
        assert_true( cast zcl_runnable_dummy( lo_future->get(  ) )->was_run_called( ) ).
      endloop.


  endmethod.


endclass.
