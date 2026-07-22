CLASS z14_cl_fill_flclass DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES:
      if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
    METHODS:
      fill_tables.
ENDCLASS.


CLASS z14_cl_fill_flclass IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.
    fill_tables( ).

    out->write( 'Tables filled successfully.' ).
  ENDMETHOD.

  METHOD fill_tables.
    DATA lt_class TYPE TABLE OF /lrn/flclass.
    DATA lt_classt TYPE TABLE OF /lrn/flclasst.

    SELECT *
    FROM /lrn/flclass
    INTO TABLE @lt_class.

    INSERT z14_flclass
    FROM TABLE @lt_class.


    SELECT *
    FROM /lrn/flclasst
    INTO TABLE @lt_classt.

    INSERT z14_flclasst
    FROM TABLE @lt_classt.

  ENDMETHOD.
ENDCLASS.
