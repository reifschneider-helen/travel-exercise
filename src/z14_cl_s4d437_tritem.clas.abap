CLASS z14_cl_s4d437_tritem DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    METHODS constructor
      IMPORTING
        i_table_name TYPE tabname
      RAISING
        cx_sy_dynamic_osql_error.

    METHODS delete_item
      IMPORTING
        i_uuid           TYPE z14_s_tritem-item_uuid
      RETURNING
        VALUE(r_message) TYPE symsg.

    METHODS create_item
      IMPORTING
        i_item           TYPE z14_s_tritem
      RETURNING
        VALUE(r_message) TYPE symsg.

    METHODS update_item
      IMPORTING
        i_item           TYPE z14_s_tritem
        i_itemx          TYPE z14_s_tritemx
      RETURNING
        VALUE(r_message) TYPE symsg.

  PROTECTED SECTION.

  PRIVATE SECTION.

    CONSTANTS offset_booking_id TYPE /dmo/booking_id VALUE '1000'.

    DATA table_name TYPE tabname.
    DATA item TYPE REF TO data.
    DATA max_booking_id TYPE /dmo/booking_id.

    METHODS get_next_booking_id
      RETURNING VALUE(r_result) TYPE /dmo/booking_id.

ENDCLASS.

CLASS z14_cl_s4d437_tritem IMPLEMENTATION.

  METHOD constructor.
    me->table_name = i_table_name.
    CREATE DATA item TYPE (table_name).

    SELECT
    FROM (table_name)
    FIELDS MAX( booking_id )
    INTO @max_booking_id.

    IF sy-subrc <> 0.
      max_booking_id = offset_booking_id.
    ENDIF.
  ENDMETHOD.

  METHOD create_item.

    ASSIGN item->* TO FIELD-SYMBOL(<item>).
    CLEAR <item>.
    <item> = CORRESPONDING #( i_item ).

    ASSIGN COMPONENT 'BOOKING_ID' OF STRUCTURE <item> TO FIELD-SYMBOL(<booking_id>).
    IF sy-subrc = 0.
      <booking_id> = get_next_booking_id( ).
    ENDIF.

    INSERT (table_name)
    FROM @<item>.

    IF sy-subrc <> 0.
      r_message = VALUE #( msgid = 'Z14_MESSAGES'
                           msgno =  '710'
                           msgty = 'E'
                           msgv1 = i_item-item_uuid
                         ).
    ELSE.
      r_message = VALUE #( msgid = 'Z14_MESSAGES'
                           msgno =  '711'
                           msgty = 'S'
                           msgv1 = i_item-item_uuid
                          ).
    ENDIF.

  ENDMETHOD.

  METHOD delete_item.

    DELETE FROM (table_name)
    WHERE item_uuid = @i_uuid.

    IF sy-subrc <> 0.
      r_message = VALUE #( msgid = 'Z14_MESSAGES'
                           msgno = '700'
                           msgty = 'E'
                           msgv1 = i_uuid
                          ).
    ELSE.
      r_message = VALUE #( msgid = 'Z14_MESSAGES'
                           msgno = '701'
                           msgty = 'S'
                           msgv1 = i_uuid
                         ).
    ENDIF.
  ENDMETHOD.

  METHOD get_next_booking_id.

    max_booking_id += 1.
    r_result = max_booking_id.

  ENDMETHOD.


  METHOD update_item.

    ASSIGN item->* TO FIELD-SYMBOL(<item>).
    CLEAR <item>.

    SELECT SINGLE *
    FROM (table_name)
    WHERE item_uuid = @i_item-item_uuid
    INTO @<item>.

    IF sy-subrc <> 0.

    ENDIF.

    LOOP AT CAST cl_abap_structdescr(
                             cl_abap_typedescr=>describe_by_name( table_name )
                           )->components
            INTO DATA(component).

      ASSIGN COMPONENT component-name OF STRUCTURE <item>  TO FIELD-SYMBOL(<field>).
      ASSIGN COMPONENT component-name OF STRUCTURE i_item  TO FIELD-SYMBOL(<comp>).
      ASSIGN COMPONENT component-name OF STRUCTURE i_itemx TO FIELD-SYMBOL(<compx>).

      IF sy-subrc = 0.
        IF <compx> = abap_true.
          <field> = <comp>.
        ENDIF.
      ENDIF.
    ENDLOOP.

    UPDATE (table_name)
    FROM @<item>.

    IF sy-subrc <> 0.
      r_message = VALUE #( msgid = 'Z14_MESSAGES'
                           msgno =  '720'
                           msgty = 'E'
                           msgv1 = i_item-item_uuid
                         ).
    ELSE.
      r_message = VALUE #( msgid = 'Z14_MESSAGES'
                           msgno =  '721'
                           msgty = 'S'
                           msgv1 = i_item-item_uuid
                          ).
    ENDIF.

  ENDMETHOD.
ENDCLASS.
