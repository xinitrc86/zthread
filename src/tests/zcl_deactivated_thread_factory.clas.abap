"! <p>A deactivated thread factory<br>
"! This factory can be used for tests of code that require threads. <br>
"! It creates deactivated threads that do not run the runnable. <br>
"! It allows: <br>
"!  <ul><li>for verification of created threads</li>
"! <li>set of threads result</li></ul>.
"! </p>
class zcl_deactivated_thread_factory definition
  public
  final
  create public
  for testing.

  public section.
    types:
        begin of sty_thread_result,
            thread_num type i,
            result type ref to zif_runnable_result,
        end of sty_thread_result,
        tty_threads_results type standard table of sty_thread_result
        with non-unique default key,
        tty_threads type standard table of ref to zcl_deactivated_thread
        with non-unique default key.
    interfaces zif_thread_factory .
    methods:
        "! <p>Sets the result to be returned by the iv_thread_num(n) created by the factory.</p>
        "!
        "! @parameter iv_thread_num | <p>The thread creation number to have the result</p>
        "! @parameter io_result | <p>The result to be returned by the nth created thread.</p>
        set_thread_call_result
            importing
                iv_thread_num type i
                io_result type ref to zif_runnable_result,
        get_created_threads
            returning value(rt_result) type tty_threads.
  protected section.
  private section.
    data:
        t_results type tty_threads_results,
        v_created_threads type i,
        t_created_threads type tty_threads.
endclass.



class zcl_deactivated_thread_factory implementation.

  method zif_thread_factory~new_thread.

    data(lo_thread) = new zcl_deactivated_thread(
        io_runnable = io_runnable
        io_callback = io_callback
        iv_taskname = iv_taskname
    ).

    ro_result = lo_thread.

    append lo_thread to t_created_threads.

    v_created_threads = v_created_threads + 1.

    try.
        data(lo_thread_result) = t_results[ thread_num = v_created_threads ]-result.
        lo_thread->set_result( lo_thread_result ).
    catch cx_sy_itab_line_not_found.
        return.
    endtry.

  endmethod.

  method set_thread_call_result.
    append value #(
        thread_num = iv_thread_num
        result = io_result ) to t_results.

  endmethod.

  method get_created_threads.
    rt_result = t_created_threads.
  endmethod.

endclass.
