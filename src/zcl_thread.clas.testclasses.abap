"! Tests Thread functionality. Coverage is not correct as on_end/handle_if_success/handle_if_error methods
"! are executed as callback from the FM. The AUNIT framework doesn't detect that these methods were called
"! during the test execution.
class ltc_thread definition final for testing
  duration short
  risk level harmless
  inheriting from zcl_assert.

  public section.
    interfaces zif_thread_callback.
  private section.
    data:
      o_cut            type ref to zcl_thread,
      o_runnable       type ref to zcl_runnable_dummy,
      v_collected      type i,
      v_last_collected type char32,
      v_last_failed    type char32.
    methods:
      setup,
      it_has_name for testing,
      it_raises_not_a_runnable for testing,
      it_aruns_runnables_returns_res for testing,
      it_raises_still_running for testing,
      it_limits_threads for testing,
      it_allows_for_callbacks for testing,
      it_callsback_with_error for testing,
      it_returns_error for testing,
      it_joins_started_thread for testing,
      it_joins_all_threads for testing,
      it_times_out_join for testing.
endclass.


class ltc_thread implementation.


  method setup.
    clear:
      v_collected,
      v_last_collected,
      v_last_failed.

    o_runnable = new zcl_runnable_dummy(  ).
    o_cut = new zcl_thread( o_runnable ).
  endmethod.

  method it_has_name.

    "given name
    o_cut = new zcl_thread(
        iv_taskname = 'MyTestThread'
        io_runnable = o_runnable
        io_callback = me ).

    assert_equals(
        exp = 'MyTestThread'
        act = o_cut->get_taskname( )
        msg = 'Should have stored task name'
    ).

    o_cut->start(  ).
    o_cut->join(  ).

    assert_equals(
        exp = 'MyTestThread'
        act = v_last_collected
        msg = 'Should inform task name on callbacks'
    ).

    "no name given,  unique id is generated
    o_cut = new zcl_thread( o_runnable ).
    assert_not_initial( o_cut->get_taskname(  ) ).

  endmethod.

  method it_raises_not_a_runnable.

    try.
        o_cut = new zcl_thread( value #( ) ).
      catch zcx_not_a_runnable into data(lo_failure).
        ##NO_HANDLER
    endtry.

    assert_bound( lo_failure ).

  endmethod.

  method it_aruns_runnables_returns_res.
    "runs runnable and return results
    "ZCL_RUNNABLE_DUMMY is also implementing zif_runnable_result
    o_cut->start(  ).
    assert_true( o_cut->is_running(  ) ).

    o_cut->join(  ).
    assert_false( o_cut->is_running(  ) ).

    data(lo_result) = cast zcl_runnable_dummy( o_cut->get_result(  ) ).
    assert_true( lo_result->was_run_called(  ) ).


  endmethod.


  method it_allows_for_callbacks.
    "test class is implementing the zif_thread_callback interface
    "counting each time a thread finishes
    do 10 times.

      o_cut = new zcl_thread(
        io_runnable = o_runnable
        io_callback = me ).
      o_cut->start(  ).


    enddo.

    zcl_thread=>join_all(  ).

    assert_equals(
        exp = 10
        act = v_collected
        msg = 'Join should wait for all to complete'
    ).


  endmethod.

  method it_callsback_with_error.
    "the test class is implementing the callback interface

    o_runnable->raise_on_run(  ).
    o_cut = new zcl_thread(
        io_runnable = o_runnable
        io_callback = me
        iv_taskname = 'MyTest' ).
    o_cut->start(  ).
    o_cut->join(  ).


    assert_equals(
        exp = 'MyTest'
        act = v_last_failed
        msg = 'Error should provide task name'
    ).


  endmethod.


  method it_returns_error.

    o_runnable->raise_on_run(  ).

    o_cut = new zcl_thread(
        io_runnable = o_runnable
        iv_taskname = 'MyTest' ).

    o_cut->start(  ).
    o_cut->join(  ).


    assert_bound(
        act = o_cut->get_error(  )
        msg = 'Should return error.'
    ).



  endmethod.


  method it_raises_still_running.


    try.
        o_cut = new zcl_thread( o_runnable ).
        o_cut->start(  ).
        o_cut->get_result(  ).
      catch zcx_still_running into data(lo_failure).
        ##NO_HANDLER
    endtry.

    assert_bound( lo_failure ).

  endmethod.

  method it_limits_threads.
    "should not raise any run time error, as it will wait
    "for workers to be available
    "tested for max mp dia = 25
    do 50 times.

      o_cut = new zcl_thread( new zcl_runnable_dummy( '0.1' ) ).
      o_cut->start(  ).

    enddo.

  endmethod.

  method it_joins_started_thread.
    "join allows for joining back threads to the main execution
    "here we are setting the runnable to wait for a second
    "the join call will wait for the thread to finish

    o_cut = new zcl_thread( new zcl_runnable_dummy( '1' ) ).

    o_cut->start(  ).
    assert_true( o_cut->is_running(  ) ).

    o_cut->join(  ).
    assert_false( o_cut->is_running(  ) ).

  endmethod.

  method it_joins_all_threads.
    "Join all allows for the wait of all executed threads
    do 10 times.

      o_cut = new zcl_thread(
        io_runnable = o_runnable
        io_callback = me ).
      o_cut->start(  ).


    enddo.

    zcl_thread=>join_all(  ).

    assert_equals(
        exp = 10
        act = v_collected
        msg = 'Join should wait for all to complete'
    ).



  endmethod.

  method it_times_out_join.


    "to avoid flaky test, still flaky depending on system usage
    data lo_failure type ref to cx_root.
    do 5 times.
      "should raise
      try.
          clear lo_failure.
          o_runnable = new zcl_runnable_dummy( '0.2' ).
          o_cut = new zcl_thread( o_runnable ).
          o_cut->start(  ).
          o_cut->join( '0.1' ).


        catch zcx_wait_timeout into lo_failure.
          assert_bound( lo_failure ).
      endtry.
      assert_bound( lo_failure ).

      "should not raise
      clear lo_failure.
      o_runnable = new zcl_runnable_dummy( '0.1' ).
      o_cut = new zcl_thread( o_runnable ).
      o_cut->start(  ).
      o_cut->join( '0.2' ).
      "as proof of completion
      o_cut->get_result(  ).



    enddo.

  endmethod.

  method zif_thread_callback~on_result.

    v_collected = v_collected + 1.
    v_last_collected = iv_taskname.
    assert_bound( io_result ).

  endmethod.

  method zif_thread_callback~on_error.

    v_last_failed = iv_taskname.
    assert_bound( io_error ).

  endmethod.

endclass.
