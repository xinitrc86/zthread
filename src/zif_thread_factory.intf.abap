"! <p><h3>An interface for thread factories</h3><br>
"! This interface is used by thread factories to default values or return your own extensions of a thread. <br>
"! It is mostly used for dependency injection in tests. <br>
"! </p>
interface zif_thread_factory
  public .
  "! <p>Returns a new thread</p>
  "!
  "! @parameter io_runnable | <p> Runnable for the thread</p>
  "! @parameter io_callback | <p> Callback for the thread </p>
  "! @parameter iv_taskname | <p> Task name for the thread </p>
  "! @parameter ro_result | <p> The returned thread.</p>
  methods
    new_thread
      importing
                io_runnable      type ref to zif_runnable
                io_callback      type ref to zif_thread_callback optional
                iv_taskname      type char32 optional
      returning value(ro_result) type ref to zcl_thread.

endinterface.
