"! <p>A thread for tests.<br>
"! You can use deactivated threads in conjunction with the
"! deactivated thread factory. <br>
"! This thread allows for setting of results or errors, as well as
"! returning the runnable for which it was called. <br>
"! <strong>This deactivated thread does not call the runnable.</strong>
"! <strong>This deactivated thread immediately calls the callback object upon start. </strong>
"! </p>
class zcl_deactivated_thread definition
  public
  inheriting from zcl_thread
  final
  create public
  for testing.

  public section.
    methods:
      "! <p>Returns the runnable for which the Thread was created</p>
      "! @parameter ro_result | <p>Thread's runnable</p>
      get_runnable
        returning value(ro_result) type ref to zif_runnable,
      "! <p>Set the result which will be sent to the callback routine</p>
      "! @parameter io_result | <p>the result to be sent back</p>
      set_result
        importing
          io_result type ref to zif_runnable_result,
      "! <p>Set the error which will be sent to the callback routine</p>
      "! @parameter io_error | <p>the error to be sent back</p>
      set_error
        importing
          io_error type ref to cx_root,
      "! <p>Allows the verification if the thread was started</p>
      "! @parameter r_result | <p>ABAP_TRUE/ABAP_FALSE</p>
      was_started
        returning value(r_result) type abap_bool,
      "! <p>Deactivated thread constructor.</p>
      "!
      "! @parameter io_runnable | <p>Runnable</p>
      "! @parameter io_callback | <p>Callback routine</p>
      "! @parameter iv_taskname | <p>Task name</p>
      constructor
        importing
          io_runnable type ref to zif_runnable
          io_callback type ref to zif_thread_callback optional
          iv_taskname type char32,
      get_result redefinition,
      on_end redefinition,
      start redefinition.

  protected section.
  private section.
    data:
      v_started  type abap_bool,
      o_callback type ref to zif_thread_callback,
      o_runnable type ref to zif_runnable,
      o_result   type ref to zif_runnable_result,
      o_error    type ref to cx_root,
      v_taskname type char32.
endclass.



class zcl_deactivated_thread implementation.

  method get_runnable.
    ro_result = o_runnable.
  endmethod.
  method set_result.
    o_result = io_result.
  endmethod.

  method set_error.
    o_error = io_error.
  endmethod.

  method constructor.
    super->constructor(
        io_callback = io_callback
        io_runnable = io_runnable
        iv_taskname = iv_taskname
    ).

    o_callback = io_callback.
    o_runnable = io_runnable.
    v_taskname = iv_taskname.

  endmethod.


  method start.
    v_started = abap_true.
    on_end( v_taskname ).
  endmethod.

  method on_end.

    if o_callback is bound
    and o_result is bound.
      o_callback->on_result(
          iv_taskname = p_task
          io_result   = o_result
      ).
    endif.

    if o_callback is bound
    and o_error is bound.
      o_callback->on_error(
          iv_taskname = p_task
          io_error   = o_error
      ).
    endif.


  endmethod.

  method get_result.
    ro_result = o_result.
  endmethod.

  method was_started.
    r_result = me->v_started.
  endmethod.


endclass.
