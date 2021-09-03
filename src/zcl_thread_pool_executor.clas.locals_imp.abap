class lcl_thread_pool implementation.

  method constructor.
    v_threads_running = 0.
    o_callback = io_callback.
  endmethod.

  method get_size.
    rv_result = v_threads_running.
  endmethod.

  method start.
    v_threads_running = v_threads_running + 1.
    io_thread->start(  ).
  endmethod.

  method zif_thread_callback~on_error.
    v_threads_running = v_threads_running - 1.
    check o_callback is bound.
    o_callback->on_error(
        io_error = io_error
        iv_taskname = iv_taskname ).
  endmethod.

  method zif_thread_callback~on_result.
    v_threads_running = v_threads_running - 1.
    check o_callback is bound.
    o_callback->on_result(
        io_result = io_result
        iv_taskname = iv_taskname ).

  endmethod.

endclass.
