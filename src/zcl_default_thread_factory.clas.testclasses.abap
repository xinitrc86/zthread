class ltc_thread_factory definition final for testing
  duration short
  risk level harmless
  inheriting from zcl_assert.

  public section.
    interfaces zif_thread_callback.

  private section.
    data:
        o_cut type ref to zif_thread_factory,
        v_called_back type abap_bool.
    methods:
      setup,
      it_creates_threads for testing.
endclass.


class ltc_thread_factory implementation.


  method setup.
    clear v_called_back.
    o_cut = new ZCL_DEFAULT_THREAD_FACTORY( ).
  endmethod.

  method it_creates_threads.

    data(lo_thread) = o_cut->new_thread(
                      io_runnable = new zcl_runnable_dummy(  )
                      io_callback = me
                      iv_taskname = 'TestThread'
    ).

    lo_thread->start(  ).
    lo_thread->join(  ).

    assert_equals(
        exp = 'TestThread'
        act = lo_thread->get_taskname( )
    ).
    assert_true( v_called_back ).

  endmethod.

  method zif_thread_callback~on_result.
    v_called_Back = abap_true.
  endmethod.

  method zif_thread_callback~on_error.

  endmethod.

endclass.
