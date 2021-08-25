"! <p>A service executor for Threads<br>
"! A service executor provides the methods to manage termination and tracking of Threads results
"! </p>
interface zif_executor_service
  public .

  methods:
    "! <p>Submits the runnable to run asynchronously in a new thread.<br>
    "! If a callback is provided, it is called when the runnable finishes its execution</p>
    "! @parameter io_runnable | <p>The runnable to submit</p>
    "! @parameter io_callback | <p>Callback</p>
    submit
      importing
        io_runnable type ref to zif_runnable
        io_callback type ref to zif_thread_callback optional,
    "! <p>Awaits for all submitted tasks to finish their execution. <br>
    "! Similarly to a thread.join( ), this can be used to wait join back forked worked. <br>
    "! <strong>TODO: set wait limit, raise something if it is reached</strong>
    "! </p>
    awaittermination,
    "! <p>Initiates an orderly shutdown in which previously submitted tasks are executed, but no new tasks will be accepted.
    "! </p>
    shutdown.

endinterface.
