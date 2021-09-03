class ltc_thread_future definition final for testing
  duration short
  risk level harmless
  inheriting from zcl_assert.

  private section.
    data:
        o_cut type ref to zif_future,
        o_dummy_runnable type ref to zcl_runnable_dummy,
        o_thread type ref to zcl_thread.
    methods:
      setup,
      it_returns_is_done for testing,
      it_waits_and_returns_result for testing,
      it_raises_error for testing,
      it_passes_timeout for testing.
endclass.


class ltc_thread_future implementation.


  method setup.
    o_dummy_runnable = new zcl_runnable_dummy( '1' ).
    o_thread = new zcl_thread( o_dummy_runnable ).
    o_cut = new zcl_thread_future( o_thread ).
  endmethod.

  method it_returns_is_done.


    o_thread->start(  ).
    assert_false( o_cut->is_done( ) ).
    o_thread->join(  ).
    assert_true( o_cut->is_done(  ) ).


  endmethod.

  method it_waits_and_returns_result.

    o_thread->start(  ).
    data(lo_result) = o_cut->get(  ).
    assert_bound( lo_result ).
    assert_true( cast zcl_runnable_dummy( lo_result )->was_run_called(  ) ).


  endmethod.

  method it_raises_error.

    o_dummy_runnable->raise_on_run(  ).
    o_thread->start(  ).
    try.
      o_cut->get(  ).
    catch zcx_thread_execution into data(lo_failure).
        assert_bound( lo_failure ).
    endtry.
    assert_bound( lo_failure ).


  endmethod.

  method it_passes_timeout.

    o_dummy_runnable = new zcl_runnable_dummy( '0.2' ).
    o_thread->start(  ).
    try.
      o_cut->get( '0.1' ).
    catch zcx_wait_timeout into data(lo_failure).
        assert_bound( lo_failure ).
    endtry.
    assert_bound( lo_failure ).


  endmethod.


endclass.
