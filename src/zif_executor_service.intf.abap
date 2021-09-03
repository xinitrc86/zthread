"! <p>A service executor for Threads<br>
"! A service executor provides the methods to manage termination and tracking of Threads results.
"! Please refer to class Executor for factory methods.
"! </p>
interface zif_executor_service
  public .

  types:
        tty_threads type standard table of ref to zcl_thread with non-unique default key,
        tty_runnables type standard table of ref to zif_runnable with non-unique default key,
        tty_futures type standard table of ref to zif_future with non-unique default key.
  methods:
    "! <p>Submits all runnables for execution according to executor rules and return a list of futures for each started thread.<br>
    "! If a callback is provided, it is called when the runnable finishes its execution<br>
    "! The thread result can be retrieved with the get method of a future. This awaits for the Thread to complete.</p>
    "! @parameter it_runnables | <p class="shorttext synchronized" lang="en">Runnables to execute</p>
    "! @parameter rt_futures | <p class="shorttext synchronized" lang="en">Futures</p>
    invoke_All
      importing
        it_runnables type tty_runnables
      returning value(rt_futures) type tty_futures,
    "! <p>Submits the runnable to run asynchronously in a new thread.<br>
    "! If a callback is provided, it is called when the runnable finishes its execution<br>
    "! The thread result can be retrieved with the get method of a future. This awaits for the Thread to complete.</p>
    "! @parameter io_runnable | <p>The runnable to submit</p>
    submit
      importing
        io_runnable type ref to zif_runnable
        returning value(ro_future) type ref to zif_future,
    "! <p>Awaits for all submitted tasks to finish their execution. <br>
    "! Similarly to a thread.join( ), this can be used to wait join back forked worked. <br>
    "! @parameter iv_timeout | <p>Timeout for the wait</p>
    await_termination
        importing
            iv_timeout type zethread_wait_time optional,
    "! <p>Initiates an orderly shutdown in which previously submitted tasks are executed, but no new tasks will be accepted. <br>
    "! <strong>Does not wait previously submitted tasks to end. Use await_termination for that. </strong>
    "! </p>
    shutdown,
    "! <p>Attempts to stop all actively executing tasks, halts the processing of waiting tasks,
    "! and returns a list of the tasks that were awaiting execution. <br>
    "! <strong>Does not wait previously submitted tasks to end. Use await_termination for that. </strong>
    "! @parameter rt_not_ran | <p>A list of all the runnables that were not executed</p>
    shutdown_Now
    returning value(rt_not_ran) type tty_runnables.

endinterface.
