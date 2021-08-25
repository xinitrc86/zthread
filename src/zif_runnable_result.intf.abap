"! <p><h3>Interface for runnable result.</h3><br>
"! Results from runnables must implement this interface. The result can be taken from the thread after it is finished or in
"! the callback routine, if defined in the Thread creation. <br>
"! <strong>Whoever fetches this result must now its concrete type so it can access its data.</strong> <br>
"! <em><strong>for example:</strong> <br>
"! class zcl_a_result...interfaces zif_runnable_result <br>
"! methods: <br>
"! set_some_result importing iv_a_result type something. <br>
"! get_some_result returning value(rv_result) type something. <br>
"! ... <br>
"! <strong>on the runnable-run: </strong><br>
"! data(lo_result) = new zcl_a_result( ). <br>
"! lo_result->set_some_result( ... ) <br>
"! ro_result = lo_result. <br>
"! ... <br>
"! <strong>on your callback: </strong><br>
"! data(lo_result) = cast zcl_a_result( io_result ). <br>
"! data(lv_real_result) = lo_result->get_some_result( ) <br>
"! ... <br>
"! <strong>after a thread finishes: </strong><br>
"! lo_thread->join( ). <br>
"! data(lo_result) = cast zcl_a_result( lo_thread->get_result( ) ). <br>
"! data(lv_real_result) = lo_result->get_some_result( ) <br>
"! </em>
"! </p>
interface ZIF_RUNNABLE_RESULT
  public .

  interfaces if_serializable_object.

endinterface.
