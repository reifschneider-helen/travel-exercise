CLASS zcl_14_customer_service DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
  methods:
    customer_exists IMPORTING iv_customer_id TYPE /dmo/customer_id
                    RETURNING VALUE(rv_exists) TYPE abap_bool.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_14_customer_service IMPLEMENTATION.

    method customer_exists.

    select single
    from /dmo/customer
    fields customer_id
    where customer_id = @iv_customer_id
    into @data(lt_customers).

    rv_exists = xsdbool( sy-subrc = 0 ).

    endmethod.

ENDCLASS.
