class lcl_thread_pool definition create public.

  public section.
    interfaces zif_thread_callback.
    methods:
      constructor
        importing
          io_callback       type ref to zif_thread_callback optional,
      start
        importing
              io_thread      type ref to zcl_thread,
       get_size
        returning value(rv_result) type i.
  protected section.
  private section.
    data v_threads_running type i.
    data o_callback type ref to zif_thread_callback.
    data o_thread_factory type ref to zif_thread_factory.

endclass.
