"! <p>Class for Executor services factory methods.</p>
class zcl_executors definition
  public
  final
  create public .

  public section.
    class-methods:
        new_single_thread_executor
            importing
                io_callback type ref to zif_thread_callback optional
                io_thread_factory type ref to zif_thread_factory optional
            returning value(ro_result) type ref to zif_executor_service,
        new_fixed_thread_pool
            importing
                iv_threads type i
                io_callback type ref to zif_thread_callback optional
                io_thread_factory type ref to zif_thread_factory optional
            returning value(ro_result) type ref to zif_executor_service.
  protected section.
  private section.
endclass.



class zcl_executors implementation.

  method new_fixed_thread_pool.
    ro_result = new zcl_thread_pool_executor(
        iv_pool_size      = iv_threads
        io_callback       = io_callback
        io_thread_factory = io_thread_factory
    ).
  endmethod.

  method new_single_thread_executor.
    ro_result = new zcl_thread_pool_executor(
        iv_pool_size      = 1
        io_callback       = io_callback
        io_thread_factory = io_thread_factory
    ).
  endmethod.

endclass.
