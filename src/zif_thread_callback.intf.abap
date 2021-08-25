"! <p><h2>Callback interface</h2><br>
"! A callback can be provided to threads to handle its results or errors after it finishes
"! its processing.
"! </p>
interface zif_thread_callback
  public .

  methods:
    "! <p>Callback method <br>
    "! This method is called in case of a successful execution</p>
    "! @parameter iv_taskname | <p>Task name if provided during Thread creation or its unique UID</p>
    "! @parameter io_result | <p>Result of the Thread processing</p>
    on_result
      importing
        iv_taskname type char32
        io_result   type ref to zif_runnable_result,
    "! <p>On error method</p>
    "! This method is called in case there was an error in the thread processing.
    "! For it to work properly, only no check exceptions must be raised in the Thread.
    "! @parameter iv_taskname | <p>Task name if provided during thread creation or its unique UID</p>
    "! @parameter io_error | <p>Exception raised by the thread execution</p>
    on_error
      importing
        iv_taskname type char32
        io_error    type ref to cx_root.

endinterface.
