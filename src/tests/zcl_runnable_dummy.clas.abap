class zcl_runnable_dummy definition
  public
  final
  create public
  for testing.

  public section.

    interfaces:  zif_runnable,zif_runnable_result.
    methods: constructor
        importing
            iv_wait type zethread_wait_time optional.
    methods:
        raise_on_run,
        was_run_called returning value(r_result) type abap_bool.
  protected section.
  private section.
    data v_run_called type abap_bool.
    data v_wait type zethread_wait_time.
    data v_raise_on_run type abap_bool.
endclass.



class zcl_runnable_dummy implementation.

  method constructor.
    v_wait = iv_wait.
  endmethod.

  method zif_runnable~run.
    v_run_called = abap_true.
    if v_wait is not initial.
        wait up to v_wait seconds.
    endif.
    if v_raise_on_run eq abap_true.
        "just an example, could be any no check exception
        raise exception type zcx_thread_start_fail.
    endif.
    ro_result = me.
  endmethod.

  method was_run_called.
    r_result = v_run_called.
  endmethod.

  method raise_on_run.
    v_raise_on_run = abap_true.
  endmethod.


endclass.
