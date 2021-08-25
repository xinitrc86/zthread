"! <p>Runnable interface<br>
"! A class implementing this interface can be used by a thread to execute the work defined in <em>run</em>.
"! </p>
interface ZIF_RUNNABLE
  public .

    interfaces if_serializable_object.
    "! <p>Run<br>
    "! This method is called by a thread asynchronously to execute work. <br>
    "! The returned result must implement the specified interface, this result can be returned by the Thread once its finished. <br>
    "! The thread also passes this result to the callback function, if defined in its creation.
    "! </p>
    "! @parameter ro_result | <p>result of runnable</p>
    methods run
    returning value(ro_result) type ref to zif_runnable_result.

endinterface.
