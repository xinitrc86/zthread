"! <p>Default implementation for thread factories<br>
"! The default thread factory creates normal thread objects. If no task name is provided, the factory will create a unique one. @TODO
"! Currently the thread creates its own task name if none provided
"! </p>
class zcl_default_thread_factory definition
  public
  final
  create public .

  public section.

    interfaces zif_thread_factory .
  protected section.
  private section.
endclass.



class zcl_default_thread_factory implementation.

  method zif_thread_factory~new_thread.

    ro_result = new zcl_thread(
        io_runnable = io_runnable
        io_callback = io_callback
        iv_taskname = iv_taskname
    ).
  endmethod.

endclass.
