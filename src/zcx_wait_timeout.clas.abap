class zcx_wait_timeout definition
  public
  inheriting from cx_no_check
  final
  create public .

  public section.

    interfaces if_t100_dyn_msg .
    interfaces if_t100_message .
    data waited type zethread_wait_time.
    constants:
      begin of zcx_message,
        msgid type symsgid value 'ZTHREAD',
        msgno type symsgno value '007',
        attr1 type scx_attrname value 'WAITED',
        attr2 type scx_attrname value '',
        attr3 type scx_attrname value '',
        attr4 type scx_attrname value '',
      end of zcx_message .
    methods constructor
      importing
        !textid   like if_t100_message=>t100key optional
        !previous like previous optional
        !waited type zethread_wait_time optional.
  protected section.
  private section.
endclass.



class zcx_wait_timeout implementation.


  method constructor ##ADT_SUPPRESS_GENERATION.
    call method super->constructor
      exporting
        previous = previous.
    clear me->textid.
    if textid is initial.
      if_t100_message~t100key = zcx_message.
    else.
      if_t100_message~t100key = textid.
    endif.
    me->waited = waited.
  endmethod.
endclass.
