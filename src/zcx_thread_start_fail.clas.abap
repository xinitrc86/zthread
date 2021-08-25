class zcx_thread_start_fail definition
  public
  inheriting from cx_no_check
  final
  create public .

  public section.

    interfaces if_t100_dyn_msg .
    interfaces if_t100_message .
  constants:
    begin of zcx_message,
        msgid type symsgid value 'ZTHREAD',
        msgno type symsgno value '003',
        attr1 type scx_attrname value '',
        attr2 type scx_attrname value '',
        attr3 type scx_attrname value '',
        attr4 type scx_attrname value '',
      end of zcx_message .

    methods constructor
      importing
        !textid   like if_t100_message=>t100key optional
        !previous like previous optional .
  protected section.
  private section.
endclass.



class zcx_thread_start_fail implementation.


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
  endmethod.
endclass.
