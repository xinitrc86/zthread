"! <p><h1>Thread for ABAP</h1><br>
"! You can use threads in ABAP by either: <br>
"!  <ul>
"!  <li>extending the ZCL_THREAD class and redefining the method zif_runnable~run <br>
"! <em>class zcl_prime_numbers inheriting from zcl_thread ... <br>
"!  data(lo_thread) = new zcl_prime_numbers( 1 )->start( ). </em>
"!  </li>
"!  <li>implementing the zif_runnable interface and pass it to a thread. <br>
"! <em>
"! class zcl_prime_numbers...interfaces zif_runnable<br>
"! data(lo_thread) = new zcl_thread( new zcl_prime_numbers( 1 ) )->start( )
"! </em>
"! </li>
"! </ul>
"! <br>
"! <strong> Threads will always execute using a dialog work process. </strong>
"! </p>
class zcl_thread definition
  public
  create public .

  public section.
    interfaces zif_runnable.
    class-methods:
      "! <p>Waits for all asynchronous work to finish for the calling program.</p>
      join_all.
    methods:
      "! <p>Creates a new Thread</p>
      "! @parameter io_runnable | <p>The runnable to execute asynchronously.</p>
      "! @parameter io_callback | <p>A callback for when the thread has finished.</p>
      "! @parameter iv_taskname | <p>An optional unique task name</p>
      constructor
        importing
          io_runnable type ref to zif_runnable optional
          io_callback type ref to zif_thread_callback optional
          iv_taskname type char32 optional
            preferred parameter io_runnable,

      "! <p>Returns its given name or the uniquely generated one, in case none provided.</p>
      "! @parameter rv_result | <p>Task name</p>
      get_taskname
        returning value(rv_result) type char32,
      "! <p>Starts the thread. In case there are no available work process, it waits</p>
      start,
      "! <p>Returns if a thread is currently running or not</p>
      "! @parameter rv_result | <p>result</p>
      is_running
        returning value(rv_result) type abap_bool,
      "! <p>Returns the thread result. In case the thread is still running it raises zcx_still_running
      "! </p>
      "! @parameter ro_result | <p class="shorttext synchronized" lang="en"></p>
      get_result
        returning value(ro_result) type ref to zif_runnable_result,

      "! <p>Returns error occurred during a thread run. </p>
      "! @parameter ro_result | <p>The error</p>
      get_error
        returning value(ro_result) type ref to cx_root,
      "! <p>Waits for the thread to finish</p>
      join,
      "! <p>Used internally to receive thread result.</p>
      "! @parameter p_task | <p>task id</p>
      on_end
        importing
          p_task type clike.
  protected section.
  private section.
    data o_runnable type ref to zif_runnable.
    data v_is_running type abap_bool.
    data o_result type ref to zif_runnable_result.
    data o_callback type ref to zif_thread_callback.
    data v_taskname type char32.
    data o_error type ref to cx_root.
    methods:
      is_runnable
        returning
          value(rv_is_runnable) type xsdboolean,
      serialize_runnable
        returning
          value(rv_serialized) type string,
      wait_for_free_dialog,
      new_task_id
        returning
          value(rv_task_id) type char32,
      start_asynchronously
        importing
          iv_serialized type string,
      callback_on_callback
        importing
          iv_task   type clike
          iv_result type string,
      callback_on_error
        importing
          iv_task  type clike
          iv_error type string,
    check_still_running.
endclass.



class zcl_thread implementation.

  method join_all.
    data(lv_joined) = abap_false.
    while lv_joined = abap_false.
      "not sure how wait works without up to seconds
      "fearing CPU time eating by this, I'm waiting relatively long for the next check
      wait for asynchronous tasks
      until abap_true = abap_false up to '0.2' seconds.
      "4 = The logical expression log_exp is false.
      "Also the current program does not contain any asynchronous function calls with callback routines,
      "and no receiver is registered for AMC messages or APC messages for the use of the additions
      "MESSAGING CHANNELS or PUSH CHANNELS.
      lv_joined = xsdbool( sy-subrc = 4 ).
    endwhile.
  endmethod.

  method constructor.
    v_taskname = cond #(
        when iv_taskname is initial
        then new_task_id( )
        else iv_taskname
    ).
    o_runnable = cond #(
        when io_runnable is bound
        then io_runnable
        else me ).

    o_callback = io_callback.
    if not is_runnable( ).
      raise exception type zcx_not_a_runnable.
    endif.
  endmethod.

  method zif_runnable~run.
    "implement on extending thread classes
    "or create default thread with a runnable
    raise exception type zcx_not_a_runnable.
  endmethod.

  method get_taskname.
    rv_result = v_taskname.
  endmethod.

  method start.

    v_is_running = abap_true.

    data(lv_serialized) = serialize_runnable( ).

    wait_for_free_dialog( ).

    start_asynchronously( lv_serialized ).

  endmethod.

  method is_running.
    rv_result = v_is_running.
  endmethod.

  method get_result.
    check_still_running( ).
    ro_result = o_result.
  endmethod.

  method get_error.
    check_still_running( ).
    ro_result = o_error.
  endmethod.

  method join.
    wait for asynchronous tasks
    until is_running( ) = abap_false.
  endmethod.

  method on_end.


    data(lv_result) = value string(  ).
    data(lv_error) = value string(  ).
    receive results from function 'ZTHREAD_START'
        importing
            ev_result =  lv_result
            ev_error  =  lv_error.

    v_is_running = abap_false.

    callback_on_callback(
          iv_task   = p_task
          iv_result = lv_result ).

    callback_on_error(
       iv_task  = p_task
       iv_error = lv_error ).



  endmethod.

  method is_runnable.

    check o_runnable is bound.

    data(lo_describer) = cast cl_abap_objectdescr( cl_abap_typedescr=>describe_by_object_ref( o_runnable ) ).
    data(lv_name) = lo_describer->absolute_name.
    rv_is_runnable  = xsdbool(
      o_runnable is instance of zif_runnable
      "root thread class has empty run and cannot be started
      and lv_name <> '\CLASS=ZCL_THREAD'
    ).

  endmethod.

  method serialize_runnable.

    call transformation id
      source runnable = o_runnable
      result xml rv_serialized.

  endmethod.


  method wait_for_free_dialog.
    "hardcoded 3 on purpose. Less than that and systems get weird.
    data num_free_dia_wps            type i.
    data num_wps                     type i.
    constants opcode_wp_get_info     type x value 25.

    call 'ThWpInfo'
      id 'OPCODE' field opcode_wp_get_info
      id 'WP' field num_wps
      id 'FREE_DIAWP' field num_free_dia_wps.


    while num_free_dia_wps < 3.
      "can lead to starvation if server usage is too high for too long
      wait up to '0.2' seconds.
      call 'ThWpInfo'
      id 'OPCODE' field opcode_wp_get_info
      id 'WP' field num_wps
      id 'FREE_DIAWP' field num_free_dia_wps.
    endwhile.

  endmethod.

  method start_asynchronously.

    call function 'ZTHREAD_START'
      starting new task v_taskname
      "destination in group DEFAULT
      destination 'NONE'
      calling on_end on end of task
      exporting
        iv_runnable = iv_serialized
      exceptions
        others      = 1.

    if sy-subrc = 1.
      raise exception type zcx_thread_start_fail.
    endif.

  endmethod.

  method new_task_id.

    try.
        rv_task_id  = cl_system_uuid=>create_uuid_x16_static( ).
      catch cx_uuid_error.
        "not unique task ids has slightly different behavior.
        "most of the cases leading to errors in execution!
        rv_task_id =  'NOT_UNIQUE'.
    endtry.

  endmethod.

  method callback_on_callback.

    check iv_result is not initial.


    call transformation id
    source xml iv_result
    result result = o_result.

    check o_callback is bound.
    o_callback->on_result(
        iv_taskname = iv_task
        io_result = o_result
    ).


  endmethod.


  method callback_on_error.

    check iv_error is not initial.


    call transformation id
    source xml iv_error
    result error = o_error.


    check o_callback is bound.
    o_callback->on_error(
        iv_taskname = iv_task
        io_error = o_error
    ).


  endmethod.


  method check_still_running.

    if is_running(  ).
      raise exception type zcx_still_running.
    endif.

  endmethod.

endclass.
