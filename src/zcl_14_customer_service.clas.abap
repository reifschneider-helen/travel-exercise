CLASS zcl_14_customer_service DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    TYPES:
        tt_customer_ids TYPE STANDARD TABLE OF /dmo/customer_id WITH DEFAULT KEY.

    METHODS:
      filter_existing_customers IMPORTING it_customer_ids     TYPE tt_customer_ids
                                RETURNING VALUE(rt_valid_ids) TYPE tt_customer_ids.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_14_customer_service IMPLEMENTATION.

  METHOD filter_existing_customers.
    SELECT
    FROM /dmo/customer
    FIELDS ( customer_id )
    FOR ALL ENTRIES IN @it_customer_ids
    WHERE customer_id = @it_customer_ids-table_line
    INTO TABLE @rt_valid_ids.

  ENDMETHOD.

ENDCLASS.
