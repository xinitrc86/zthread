"! <p>TODO, how to achieve this...<br>
"! We want a pool that can receive, for example, 50 threads but runs only 3 at a time. <br>
"! Not blocking the main process. </p>
class zcl_thread_pool_executor definition
  public
  final
  create public.

  public section.
    interfaces zif_executor_service .
    methods:
        constructor
            importing
                iv_maximum_pool_size type i.
  protected section.
  private section.
    DATA v_max_pool_size TYPE i.
endclass.



class zcl_thread_pool_executor implementation.


  method constructor.
    v_max_pool_size = iv_maximum_pool_size.
  endmethod.

  method zif_executor_service~awaittermination.
    "await all of my threads
    "how to, considering mem area class
  endmethod.

  method zif_executor_service~shutdown.
    "how to kill my threads
  endmethod.

  method zif_executor_service~submit.

    "Need a way to not block execution of current code,
    "yet not allow more than v_max_pool_size to be submitted simultaneously.
    "can only think of mem area class with a threaded loop on execution
    new zcl_thread(
        io_runnable = io_runnable
        io_callback = io_callback
    )->start(  ).

  endmethod.


endclass.
