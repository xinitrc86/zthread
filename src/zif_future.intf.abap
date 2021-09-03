"! <p>A future representing thre result of asynchronous computation</p>
interface zif_future
  public .

  methods:
    "! <p class="shorttext synchronized" lang="en">Returns true in case future is resolved.</p>
    "!
    "! @parameter rv_result | <p class="shorttext synchronized" lang="en">is done</p>
    is_done returning value(rv_result) type abap_bool,
    "! <p>Get the future result.<br>
    "! This will make the relevant thread to wait for its completion. <br>
    "! Raises zcx_execution_error in case thread ends in error.</p>
    "!
    "! @parameter iv_timeout | <p class="shorttext synchronized" lang="en">Maximum time for wait for resolution.</p>
    "! @parameter ro_result | <p class="shorttext synchronized" lang="en">Thread result</p>
    get
      importing
                iv_timeout       type zethread_wait_time optional
      returning value(ro_result) type ref to zif_runnable_result.



endinterface.
