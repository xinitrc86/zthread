FUNCTION ZTHREAD_START.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(IV_RUNNABLE) TYPE  STRING
*"  EXPORTING
*"     VALUE(EV_RESULT) TYPE  STRING
*"     VALUE(EV_ERROR) TYPE  STRING
*"----------------------------------------------------------------------

  data lo_runnable type ref to zif_runnable.

  call transformation id
  source xml iv_runnable
  result runnable = lo_runnable.

  try.

      data(lo_result) = lo_runnable->run(  ).

    catch cx_root into data(lo_failure).
      "all exceptions are serializable by default
      call transformation id
          source error = lo_failure
          result xml ev_error.
      return.

  endtry.

  if lo_result is not bound.
    lo_result = new zcl_dummy_runnable_result(  ).
  endif.

  call transformation id
    source result = lo_result
    result xml ev_result.


endfunction.
