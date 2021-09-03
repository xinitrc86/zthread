"! <p>Thread pool executor...<br>
"! Limits concurrent thread execution to a predefined thread pool size. <br>
"! <strong>Current implementation blocks main thread!</strong><br>
"!
"!  </p>
class zcl_thread_pool_executor definition
  public
  create public.

  public section.
    constants gc_pool_wait_interval type decfloat16 value '0.1'.

    interfaces: zif_executor_service.
    methods:
      constructor
        importing
          iv_pool_size      type i
          io_callback       type ref to zif_thread_callback optional
          io_thread_factory type ref to zif_thread_factory optional,
      get_default_thread_factory
        returning value(ro_result) type ref to zif_thread_factory.
  protected section.
  private section.

    data v_pool_size type i.
    data t_threads_to_start type zif_executor_service=>tty_threads.
    data v_shutdown type abap_bool.
    data o_thread_factory type ref to zif_thread_factory.
    data o_thread_pool type ref to lcl_thread_pool.
    data t_futures type zif_executor_service=>tty_futures.
    methods get_next
      returning
        value(ro_to_run) type ref to zcl_thread.
    methods has_next
      returning
        value(rv_has_next) type xsdboolean.
    methods is_pool_full
      returning
        value(rv_pool_is_full) type xsdboolean.
    methods start_thread_in_pool
      importing
        io_thread type ref to zcl_thread
      returning value(ro_thread) type ref to zcl_thread.
    methods thread_factory_lookup
      importing
        io_thread_factory type ref to zif_thread_factory.
    methods start_thread_queue.
    methods check_is_shutdown.
    methods new_thread
      importing
        io_runnable          type ref to zif_runnable
      returning
        value(ro_new_thread) type ref to zcl_thread.
    methods create_threads_return_futures
      importing
        it_runnables type zif_executor_service=>tty_runnables
      returning value(rt_futures) type zif_executor_service=>tty_futures.
endclass.



class zcl_thread_pool_executor implementation.


  method constructor.
    v_pool_size = iv_pool_size.
    thread_factory_lookup( io_thread_factory ).
    o_thread_pool = new lcl_thread_pool( io_callback ).

  endmethod.

  method zif_executor_service~await_termination.
    zcl_thread=>join_all( iv_timeout ).
  endmethod.

  method zif_executor_service~shutdown.
    v_shutdown = abap_true.
  endmethod.

  method zif_executor_service~shutdown_now.
    v_shutdown = abap_true.
    rt_not_ran = t_threads_to_start.
  endmethod.


  method zif_executor_service~submit.
    check_is_shutdown( ).
    data(lt_futures) = create_threads_return_futures( value #( ( io_runnable ) ) ).
    start_thread_queue( ).
    ro_future = value #( lt_futures[ 1 ] optional ).
  endmethod.


  method zif_executor_service~invoke_all.
    check_is_shutdown( ).
    rt_futures = create_threads_return_futures( it_runnables ).
    start_thread_queue( ).
  endmethod.

  method get_default_thread_factory.
    ro_result = new zcl_default_thread_factory(  ).
  endmethod.

  method get_next.

    ro_to_run  = t_threads_to_start[ 1 ].
    delete t_threads_to_start index 1.

  endmethod.


  method has_next.

    rv_has_next  = xsdbool( lines( t_threads_to_start ) > 0 ).

  endmethod.


  method is_pool_full.

    rv_pool_is_full  = xsdbool( o_thread_pool->get_size(  ) >= v_pool_size  ).

  endmethod.


  method thread_factory_lookup.

    o_thread_factory = cond #(
        when io_thread_factory is bound
        then io_thread_factory
        else get_default_thread_factory( ) ).

  endmethod.

  method start_thread_queue.
    "todo: return futures
    "also: this is the piece of code that should run inside a memory area class
    "with a thread->callback->thread loop to itself so we don't block the execution of the main thread
    while has_next( ).

      while is_pool_full(  ).
        wait up to gc_pool_wait_interval seconds.
      endwhile.

      while not is_pool_full( )
      and has_next( ).

        data(lo_next) = get_next( ).
        append
            new zcl_thread_future(
                start_thread_in_pool( lo_next )
            )
        to t_futures.

      endwhile.

    endwhile.

  endmethod.

  method start_thread_in_pool.

    o_thread_pool->start( io_thread ).

  endmethod.


  method check_is_shutdown.

    if v_shutdown = abap_true.
      raise exception type zcx_rejected_execution.
    endif.

  endmethod.

  method create_threads_return_futures.

    loop at it_runnables into data(lo_runnable).
        data(lo_thread) = new_thread( lo_runnable ).
        append new zcl_thread_future( lo_thread ) to rt_futures.
        append lo_thread to t_threads_to_start.

    endloop.

  endmethod.

  method new_thread.

    ro_new_thread  = o_thread_factory->new_thread(
        io_runnable = io_runnable
        io_callback = o_thread_pool
    ).

  endmethod.


endclass.
