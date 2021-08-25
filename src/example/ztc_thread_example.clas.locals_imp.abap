class lcl_sum_numbers definition create public.

  public section.
    types:
        tty_numbers type standard table of i
        with non-unique default key.
    interfaces: zif_runnable, zif_runnable_result.
    methods:
      constructor
        importing
          it_numbers type tty_numbers,
      get_sum
        returning value(rv_result) type i.
  protected section.
  private section.
    data t_numbers type lcl_sum_numbers=>tty_numbers.
    data v_result type i.

endclass.

class lcl_sum_numbers implementation.

  method constructor.
    t_numbers = it_numbers.
  endmethod.
  method zif_runnable~run.
    v_result = reduce #(
        init result type i
        for number in t_numbers
        next result = result + number
    ).
    ro_result = me.
  endmethod.

  method get_sum.
    rv_result = v_result.
  endmethod.

endclass.
