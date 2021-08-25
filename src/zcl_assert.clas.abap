class zcl_assert definition
  for testing
  duration short
  risk level harmless
  public
  abstract
  create public .

  public section.
     class-methods:
      "! Abort test execution due to missing context
      "!
      "! @parameter msg    | Description
      "! @parameter detail | Further description
      "! @parameter quit   | Alter control flow/ quit test (METHOD, +++CLASS+++)
      abort
        importing   !msg                    type csequence optional
                    !detail                 type csequence optional
                    !quit                   type int1 default if_Aunit_Constants=>class
        preferred parameter msg,

      "! Ensure the validity of the reference
      "!
      "! @parameter act              | Reference variable to be checked
      "! @parameter msg              | Description
      "! @parameter level            | Severity (TOLERABLE, CRITICAL, FATAL)
      "! @parameter quit             | Alter control flow/ quit test (NO, +METHOD+, CLASS)
      "! @parameter assertion_Failed | Condition was not met (and QUIT = NO)
      assert_Bound
        importing   value(act)              type any
                    !msg                    type csequence optional
                    !level                  type int1 default if_Aunit_Constants=>severity-medium
                    !quit                   type int1 default if_Aunit_Constants=>quit-test
        returning   value(assertion_Failed) type abap_Bool,

      "! Ensure that character string fits to simple pattern
      "!
      "! @parameter act              | Actual Object
      "! @parameter exp              | Expected Template
      "! @parameter msg              | Message in Case of Error
      "! @parameter level            | Severity (TOLERABLE, CRITICAL, FATAL)
      "! @parameter quit             | Alter control flow/ quit test (NO, +METHOD+, CLASS)
      "! @parameter assertion_Failed | Condition was not met (and QUIT = NO)
      assert_Char_Cp
        importing   !act                    type csequence
                    !exp                    type csequence
                    !msg                    type csequence optional
                    !level                  type int1 default if_Aunit_Constants=>severity-medium
                    !quit                   type int1 default if_Aunit_Constants=>quit-test
        returning   value(assertion_Failed) type abap_Bool,

      "! Ensure that character string does not fit to simple pattern
      "!
      "! @parameter act              | Actual text which shall not adhere to EXP pattern
      "! @parameter exp              | Simple text pattern
      "! @parameter msg              | Description
      "! @parameter level            | Severity (TOLERABLE, CRITICAL, FATAL)
      "! @parameter quit             | Alter control flow/ quit test (NO, +METHOD+, CLASS)
      "! @parameter assertion_Failed | Condition was not met (and QUIT = NO)
      assert_Char_Np
        importing   value(act)              type csequence
                    !exp                    type csequence
                    !msg                    type csequence optional
                    !level                  type int1 default if_Aunit_Constants=>severity-medium
                    !quit                   type int1 default if_Aunit_Constants=>quit-test
        returning   value(assertion_Failed) type abap_Bool,

      "! Ensure difference between 2 elementary data objects
      "!
      "! @parameter act              | Data object with current value
      "! @parameter exp              | Compare object with unexpected value
      "! @parameter tol              | Tolerance range for floating point comparison
      "! @parameter msg              | Message in case of error
      "! @parameter level            | Severity (TOLERABLE, CRITICAL, FATAL)
      "! @parameter quit             | Alter control flow/ quit test (NO, +METHOD+, CLASS)
      "! @parameter assertion_Failed | Condition was not met (and QUIT = NO)
      assert_Differs
        importing   value(act)              type simple
                    value(exp)              type simple
                    !tol                    type f optional
                    !msg                    type csequence optional
                    !level                  type int1 default if_Aunit_Constants=>severity-medium
                    !quit                   type int1 default if_Aunit_Constants=>quit-test
        returning   value(assertion_Failed) type abap_Bool,

      "! Ensure equality of two data objects
      "!
      "! @parameter act                  | Data object with current value
      "! @parameter exp                  | Data object with expected type
      "! @parameter ignore_Hash_Sequence | Ignore sequence in hash tables
      "! @parameter tol                  | Tolerance Range (for directly passed floating numbers)
      "! @parameter msg                  | Description
      "! @parameter level                | Severity (TOLERABLE, CRITICAL, FATAL)
      "! @parameter quit                 | Alter control flow/ quit test (NO, +METHOD+, CLASS)
      "! @parameter assertion_Failed     | Condition was not met (and QUIT = NO)
      assert_Equals
        importing   value(act)              type any
                    value(exp)              type any
                    !ignore_Hash_Sequence   type abap_Bool default abap_False
                    !tol                    type f optional
                    !msg                    type csequence optional
                    !level                  type int1 default if_Aunit_Constants=>severity-medium
                    !quit                   type int1 default if_Aunit_Constants=>quit-test
        returning   value(assertion_Failed) type abap_Bool,


      "! Ensure approximate consistency of 2 floating point numbers
      "!
      "! @parameter act              | Data object with current value
      "! @parameter exp              | Data object with expected value
      "! @parameter rtol             | Relative tolerance
      "! @parameter msg              | Description
      "! @parameter level            | Severity (TOLERABLE, CRITICAL, FATAL)
      "! @parameter quit             | Alter control flow/ quit test (NO, +METHOD+, CLASS)
      "! @parameter assertion_Failed | Condition was not met (and QUIT = NO)
      assert_Equals_Float
        importing   value(act)              type numeric
                    value(exp)              type numeric
                    !rtol                   type numeric default cl_Abap_Unit_Assert=>rtol_Default
                    !msg                    type csequence optional
                    !level                  type int1 default if_Aunit_Constants=>severity-medium
                    !quit                   type int1 default if_Aunit_Constants=>quit-test
        returning   value(assertion_Failed) type abap_Bool,

      "! Ensure that boolean equals ABAP_FALSE
      "!
      "! @parameter act              | Actual data object
      "! @parameter msg              | Description
      "! @parameter level            | Severity (TOLERABLE, +CRITICAL+, FATAL)
      "! @parameter quit             | Alter control flow/ quit test (NO, +METHOD+, CLASS)
      "! @parameter assertion_Failed | Condition was not met (and QUIT = NO)
      assert_False
        importing   value(act)              type abap_Bool
                    !msg                    type csequence optional
                    !level                  type int1 default if_Aunit_Constants=>severity-medium
                    !quit                   type int1 default if_Aunit_Constants=>quit-test
        returning   value(assertion_Failed) type abap_Bool,

      "! Ensure that data object value is initial
      "!
      "! @parameter act              | Actual data object
      "! @parameter msg              | Description
      "! @parameter level            | Severity (TOLERABLE, +CRITICAL+, FATAL)
      "! @parameter quit             | Alter control flow/ quit test (NO, +METHOD+, CLASS)
      "! @parameter assertion_Failed | Condition was not met (and QUIT = NO)
      assert_Initial
        importing   value(act)              type any default sy-subrc
                    !msg                    type csequence optional
                    !level                  type int1 default if_Aunit_Constants=>severity-medium
                    !quit                   type int1 default if_Aunit_Constants=>quit-test
        preferred parameter act
        returning
                    value(assertion_Failed) type abap_Bool,

      "! Ensure invalidity of the reference of a reference variable
      "!
      "! @parameter act              | Reference variable to be checked
      "! @parameter msg              | Description
      "! @parameter level            | Severity (TOLERABLE, +CRITICAL+, FATAL)
      "! @parameter quit             | Alter control flow/ quit test (NO, +METHOD+, CLASS)
      "! @parameter assertion_Failed | Condition was not met (and QUIT = NO)
      assert_Not_Bound
        importing   value(act)              type any
                    !msg                    type csequence optional
                    !level                  type int1 default if_Aunit_Constants=>severity-medium
                    !quit                   type int1 default if_Aunit_Constants=>quit-test
        returning   value(assertion_Failed) type abap_Bool,

      "! Ensure that value of data object is not initial
      "!
      "! @parameter act              | Actual Data Object
      "! @parameter msg              | Message in Case of Error
      "! @parameter level            | Severity (TOLERABLE, +CRITICAL+, FATAL)
      "! @parameter quit             | Alter control flow/ quit test (NO, +METHOD+, CLASS)
      "! @parameter assertion_Failed | Condition was not met (and QUIT = NO)
      assert_Not_Initial
        importing   value(act)              type any
                    !msg                    type csequence optional
                    !level                  type int1 default if_Aunit_Constants=>severity-medium
                    !quit                   type int1 default if_Aunit_Constants=>quit-test
        returning
                    value(assertion_Failed) type abap_Bool,

      "! Ensure that number is in given range
      "!
      "! @parameter lower            | Upper boundary
      "! @parameter upper            | Lower boundary
      "! @parameter number           | Number expected to be within the boundaries
      "! @parameter msg              | Description
      "! @parameter level            | Alter control flow/ quit test (NO, +METHOD+, CLASS)
      "! @parameter quit             | Control flow in case of failed assertion
      "! @parameter assertion_Failed | Condition was not met (and QUIT = NO)
      assert_Number_Between
        importing   !lower                  type numeric
                    !upper                  type numeric
                    !number                 type numeric
                    !msg                    type csequence optional
                    !level                  type int1 default if_Aunit_Constants=>severity-medium
                    !quit                   type int1 default if_Aunit_Constants=>quit-test
        returning   value(assertion_Failed) type abap_Bool,

      "! Ensure specific value of return code
      "!
      "! @parameter exp              | Expected return code, optional, if not zero
      "! @parameter act              | Return code of ABAP statements
      "! @parameter msg              | Description
      "! @parameter level            | Severity (TOLERABLE, +CRITICAL+, FATAL)
      "! @parameter quit             | Alter control flow/ quit test (NO, +METHOD+, CLASS)
      "! @parameter symsg            | System message
      "! @parameter assertion_Failed | Condition was not met (and QUIT = NO)
      assert_Subrc
        importing   value(exp)              type sysubrc default 0
                    value(act)              type sysubrc default sy-subrc
                    !msg                    type csequence optional
                    !level                  type int1 default if_Aunit_Constants=>severity-medium
                    !quit                   type int1 default if_Aunit_Constants=>quit-test
                    !symsg                  type symsg optional
        preferred parameter act
        returning   value(assertion_Failed) type abap_Bool,

      "! Ensure that data is contained as line within internal table
      "!
      "! @parameter line             | Data Object that is typed like line of TABLE
      "! @parameter table            | Internal Table that shall contain LINE
      "! @parameter msg              | Description
      "! @parameter level            | Severity (TOLERABLE, +CRITICAL+, FATAL)
      "! @parameter quit             | Alter control flow/ quit test (NO, +METHOD+, CLASS)
      "! @parameter assertion_Failed | Condition was not met (and QUIT = NO)
      assert_Table_Contains
        importing   value(line)             type any
                    !table                  type any table
                    !msg                    type csequence optional
                    !level                  type int1 default if_Aunit_Constants=>severity-medium
                    !quit                   type int1 default if_Aunit_Constants=>quit-test
        returning   value(assertion_Failed) type abap_Bool,

      "! Ensure that data is not contained as line in internal table
      "!
      "! @parameter line             | Data Object that is typed like line of TABLE
      "! @parameter table            | Internal Table that must not contain LINE
      "! @parameter msg              | Description
      "! @parameter level            | Severity (TOLERABLE, +CRITICAL+, FATAL)
      "! @parameter quit             | Alter control flow/ quit test (NO, +METHOD+, CLASS)
      "! @parameter assertion_Failed | Condition was not met (and QUIT = NO)
      assert_Table_Not_Contains
        importing   value(line)             type any
                    !table                  type any table
                    !msg                    type csequence optional
                    !level                  type int1 default if_Aunit_Constants=>severity-medium
                    !quit                   type int1 default if_Aunit_Constants=>quit-test
        returning   value(assertion_Failed) type abap_Bool,

      "! Ensure that text matches regular expression
      "!
      "! @parameter pattern          | Regular Expression - see also TA ABAPHELP
      "! @parameter text             | Text that is assumed to met the regular expression
      "! @parameter msg              | Description
      "! @parameter level            | Severity (TOLERABLE, +CRITICAL+, FATAL)
      "! @parameter quit             | Alter control flow/ quit test (NO, +METHOD+, CLASS)
      "! @parameter assertion_Failed | Condition was not met (and QUIT = NO)
      assert_Text_Matches
        importing   value(pattern)          type csequence
                    value(text)             type csequence
                    !msg                    type csequence optional
                    !level                  type int1 default if_Aunit_Constants=>severity-medium
                    !quit                   type int1 default if_Aunit_Constants=>quit-test
        returning   value(assertion_Failed) type abap_Bool,

      "! Ensure that a constraint is met by data object
      "!
      "! @parameter act              | Data object which should adhere to constraint EXP
      "! @parameter act_As_Text      | Description for ACT that is used in alert message text
      "! @parameter exp              | Constraint to which ACT needs to adhere
      "! @parameter msg              | Description
      "! @parameter level            | Severity (TOLERABLE, +CRITICAL+, FATAL)
      "! @parameter quit             | Alter control flow/ quit test (NO, +METHOD+, CLASS)
      "! @parameter assertion_Failed | Condition was not met (and QUIT = NO)
      assert_That
        importing   value(act)              type data
                    value(act_As_Text)      type csequence optional
                    !exp                    type ref to if_Constraint
                    !msg                    type csequence optional
                    !level                  type int1 default if_Aunit_Constants=>severity-medium
                    !quit                   type int1 default if_Aunit_Constants=>quit-test
        returning   value(assertion_Failed) type abap_Bool,

      "! Ensure that boolean equals ABAP_TRUE
      "!
      "! @parameter act              | Actual value
      "! @parameter msg              | Description
      "! @parameter level            | Severity (TOLERABLE, +CRITICAL+, FATAL)
      "! @parameter quit             | Alter control flow/ quit test (NO, +METHOD+, CLASS)
      "! @parameter assertion_Failed | Condition was not met (and QUIT = NO)
      assert_True
        importing   value(act)              type abap_Bool
                    !msg                    type csequence optional
                    !level                  type int1 default if_Aunit_Constants=>severity-medium
                    !quit                   type int1 default if_Aunit_Constants=>quit-test
        returning   value(assertion_Failed) type abap_Bool,

      "! Report unconditional assertion
      "!
      "! @parameter msg    | Description
      "! @parameter level  | Severity (TOLERABLE, +CRITICAL+, FATAL)
      "! @parameter quit   | Alter control flow/ quit test (NO, +METHOD+, CLASS)
      "! @parameter detail | Further Description
      fail
        importing   !msg                type csequence optional
                    !level              type int1 default if_Aunit_Constants=>severity-medium
                    !quit               type int1 default if_Aunit_Constants=>quit-test
                    !detail             type csequence optional
        preferred parameter msg.

ENDCLASS.



CLASS zcl_assert IMPLEMENTATION.


  method abort.
    cl_abap_unit_assert=>abort(
      exporting
        msg    = msg    " Description
        detail = detail    " Further description
        quit   = quit    " Alter control flow/ quit test (METHOD, >>>CLASS<<<)
    ).
  endmethod.


  method assert_bound.
    cl_abap_unit_assert=>assert_bound(
      exporting
        act              = act    " Reference variable to be checked
        msg              = msg    " Description
        level            = level    " Severity (TOLERABLE, CRITICAL, FATAL)
        quit             = quit    " Alter control flow/ quit test (NO, >METHOD<, CLASS)
      receiving
        assertion_failed = assertion_failed    " Condition was not met (and QUIT = NO)
    ).
  endmethod.


  method assert_char_cp.
    cl_abap_unit_assert=>assert_char_cp(
      exporting
        act              =  act   " Text to match to EXP pattern
        exp              =  exp    " Expected simple text pattern
        msg              =  msg   " Description
        level            =  level   " Severity (TOLERABLE, CRITICAL, FATAL)
        quit             =  quit   " Alter control flow/ quit test (NO, >METHOD<, CLASS)
      receiving
        assertion_failed = assertion_failed    " Condition was not met (and QUIT = NO)
    ).
  endmethod.


  method assert_char_np.
    cl_abap_unit_assert=>assert_char_np(
      exporting
        act              =  act   " Actual text which shall not adhere to EXP pattern
        exp              =  exp   " Simple text pattern
        msg              =  msg   " Description
        level            =  level   " Severity (TOLERABLE, CRITICAL, FATAL)
        quit             =  quit   " Alter control flow/ quit test (NO, >METHOD<, CLASS)
      receiving
        assertion_failed = assertion_failed    " Condition was not met (and QUIT = NO)
    ).
  endmethod.


  method assert_differs.
    cl_abap_unit_assert=>assert_differs(
      exporting
        act              = act
        exp              = exp
        tol              = tol
        msg              = msg
        level            = level
        quit             = quit
      receiving
        assertion_failed = assertion_failed
    ).
  endmethod.


  method assert_equals.
    cl_abap_unit_assert=>assert_equals(
      exporting
        act                  = act    " Data object with current value
        exp                  = exp    " Data object with expected type
        ignore_hash_sequence = ignore_hash_sequence    " Ignore sequence in hash tables
        tol                  = tol    " Tolerance Range (for directly passed floating numbers)
        msg                  = msg    " Description
        level                = level    " Severity (TOLERABLE, CRITICAL, FATAL)
        quit                 = quit    " Alter control flow/ quit test (NO, >METHOD<, CLASS)
      receiving
        assertion_failed     = assertion_failed    " Condition was not met (and QUIT = NO)
    ).
  endmethod.


  method assert_equals_float.
    cl_abap_unit_assert=>assert_equals_float(
      exporting
        act              = act     " Data object with current value
        exp              = exp    " Data object with expected value
        rtol             = rtol    " Relative tolerance
        msg              = msg    " Description
        level            = level    " Severity (TOLERABLE, CRITICAL, FATAL)
        quit             = quit    " Alter control flow/ quit test (NO, >METHOD<, CLASS)
      receiving
        assertion_failed = assertion_failed    " Condition was not met (and QUIT = NO)
    ).

  endmethod.


  method assert_false.
    cl_abap_unit_assert=>assert_false(
      exporting
        act              = act    " Actual data object
        msg              = msg    " Description
        level            = level    " Severity (TOLERABLE, >CRITICAL<, FATAL)
        quit             = quit    " Alter control flow/ quit test (NO, >METHOD<, CLASS)
      receiving
        assertion_failed = assertion_failed    " Condition was not met (and QUIT = NO)
    ).

  endmethod.


  method assert_initial.
    cl_abap_unit_assert=>assert_initial(
      exporting
        act              = act    " Actual data object
        msg              = msg    " Description
        level            = level    " Severity (TOLERABLE, >CRITICAL<, FATAL)
        quit             = quit    " Alter control flow/ quit test (NO, >METHOD<, CLASS)
      receiving
        assertion_failed = assertion_failed     " Condition was not met (and QUIT = NO)
    ).
  endmethod.


  method assert_not_bound.
    cl_abap_unit_assert=>assert_not_bound(
      exporting
        act              = act    " Reference variable to be checked
        msg              = msg    " Description
        level            = level    " Severity (TOLERABLE, >CRITICAL<, FATAL)
        quit             = quit    " Alter control flow/ quit test (NO, >METHOD<, CLASS)
      receiving
        assertion_failed = assertion_failed    " Condition was not met (and QUIT = NO)
    ).
  endmethod.


  method assert_not_initial.
    cl_abap_unit_assert=>assert_not_initial(
      exporting
        act              = act     " Actual Data Object
        msg              = msg    " Message in Case of Error
        level            = level    " Severity (TOLERABLE, >CRITICAL<, FATAL)
        quit             = quit    " Alter control flow/ quit test (NO, >METHOD<, CLASS)
      receiving
        assertion_failed = assertion_failed     " Condition was not met (and QUIT = NO)
    ).
  endmethod.


  method assert_number_between.
    cl_abap_unit_assert=>assert_number_between(
      exporting
        lower            =  lower   " Upper Boundary
        upper            =  upper   " Lower Boundary
        number           =  number   " Number exepected to LOWER <= NUMBER <= UPPER
        msg              =  msg   " Description
        level            =  level    " Alter control flow/ quit test (NO, >METHOD<, CLASS)
        quit             =  quit   " Control flow in case of failed assertion
      receiving
        assertion_failed =  assertion_failed     " Condition was not met (and QUIT = NO)
    ).
  endmethod.


  method assert_subrc.
    cl_abap_unit_assert=>assert_subrc(
      exporting
        exp              = exp     " Expected return code, optional, if not zero
        act              = act    " Return code of ABAP statements
        msg              = msg    " Description
        level            = level    " Severity (TOLERABLE, >CRITICAL<, FATAL)
        quit             = quit    " Alter control flow/ quit test (NO, >METHOD<, CLASS)
        symsg            = symsg    " System message
      receiving
        assertion_failed = assertion_failed    " Condition was not met (and QUIT = NO)
    ).
  endmethod.


  method assert_table_contains.
    cl_abap_unit_assert=>assert_table_contains(
      exporting
        line             = line    " Data Object that is typed like line of TABLE
        table            = table    " Internal Table that shall contain LINE
        msg              = msg    " Description
        level            = level     " Severity (TOLERABLE, >CRITICAL<, FATAL)
        quit             = quit    " Alter control flow/ quit test (NO, >METHOD<, CLASS)
      receiving
        assertion_failed = assertion_failed    " Condition was not met (and QUIT = NO)
    ).
  endmethod.


  method assert_table_not_contains.
    cl_abap_unit_assert=>assert_table_not_contains(
      exporting
        line             = line    " Data Object that is typed like line of TABLE
        table            = table    " Internal Table that must not contain LINE
        msg              = msg    " Description
        level            = level    " Severity (TOLERABLE, >CRITICAL<, FATAL)
        quit             = quit    " Alter control flow/ quit test (NO, >METHOD<, CLASS)
      receiving
        assertion_failed = assertion_failed    " Condition was not met (and QUIT = NO)
    ).
  endmethod.


  method assert_text_matches.
    cl_abap_unit_assert=>assert_text_matches(
      exporting
        pattern          = pattern    " Regular Expression - see also TA ABAPHELP
        text             = text    " Text that is assumed to met the regular expression
        msg              = msg    " Description
        level            = level    " Severity (TOLERABLE, >CRITICAL<, FATAL)
        quit             = quit    " Alter control flow/ quit test (NO, >METHOD<, CLASS)
      receiving
        assertion_failed = assertion_failed    " Condition was not met (and QUIT = NO)
    ).

  endmethod.


  method assert_that.
    cl_abap_unit_assert=>assert_that(
      exporting
        act              = act    " Data Object which should adhere to constraint EXP
        exp              = exp    " Constraint to which ACT needs to adhere
        msg              = msg    " Description
        level            = level    " Severity (TOLERABLE, >CRITICAL<, FATAL)
        quit             = quit    " Alter control flow/ quit test (NO, >METHOD<, CLASS)
      receiving
        assertion_failed = assertion_failed    " Condition was not met (and QUIT = NO)
    ).
  endmethod.


  method assert_true.
    cl_abap_unit_assert=>assert_true(
      exporting
        act              = act     " Actual value
        msg              = msg    " Description
        level            = level    " Severity (TOLERABLE, >CRITICAL<, FATAL)
        quit             = quit    " Alter control flow/ quit test (NO, >METHOD<, CLASS)
      receiving
        assertion_failed = assertion_failed    " Condition was not met (and QUIT = NO)
    ).
  endmethod.


  method fail.
    cl_abap_unit_assert=>fail(
      exporting
        msg    = msg     " Description
        level  = level    " Severity (TOLERABLE, >CRITICAL<, FATAL)
        quit   = quit    " Alter control flow/ quit test (NO, >METHOD<, CLASS)
        detail = detail    " Further Description
    ).
  endmethod.
ENDCLASS.
