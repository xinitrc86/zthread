class zcl_thread_future definition
  public
  final
  create public .

  public section.

    interfaces zif_future .
    methods:
      constructor
        importing
          io_thread type ref to zcl_thread.
  protected section.
  private section.
    data o_thread type ref to zcl_thread.
    methods check_for_execution_error.
endclass.



class zcl_thread_future implementation.

  method constructor.
    o_thread = io_thread.
  endmethod.

  method zif_future~get.
    o_thread->join( iv_timeout ).
    check_for_execution_error( ).
    ro_result = o_thread->get_result( ).
  endmethod.

  method zif_future~is_done.
    "@todo: implement has_started to complement
    rv_result = xsdbool( o_thread->is_running(  ) = abap_false ).
  endmethod.


  method check_for_execution_error.

    data(lo_error) = o_thread->get_error(  ).
    if lo_error is bound.
      raise exception type zcx_thread_execution
        exporting
          previous = lo_error.
    endif.

  endmethod.

endclass.
