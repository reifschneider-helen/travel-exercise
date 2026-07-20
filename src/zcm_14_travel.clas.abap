CLASS zcm_14_travel DEFINITION
  PUBLIC
  INHERITING FROM cx_static_check
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_abap_behv_message .
    INTERFACES if_t100_message .
    INTERFACES if_t100_dyn_msg .

    METHODS constructor
      IMPORTING
        !textid  LIKE if_t100_message=>t100key OPTIONAL
*        !previous LIKE previous OPTIONAL .
        severity LIKE if_abap_behv_message~m_severity OPTIONAL.

    CONSTANTS:
      BEGIN OF already_canceled,
        msgid TYPE symsgid VALUE '/LRN/S4D437',
        msgno TYPE symsgno VALUE '130',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF already_canceled,

      BEGIN OF customer_not_found,
        msgid TYPE symsgid VALUE '/LRN/S4D437',
        msgno TYPE symsgno VALUE '210',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF customer_not_found,

      BEGIN OF start_date_in_the_past,
        msgid TYPE symsgid VALUE '/LRN/S4D437',
        msgno TYPE symsgno VALUE '230',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF start_date_in_the_past,

      BEGIN OF end_date_in_the_past,
        msgid TYPE symsgid VALUE '/LRN/S4D437',
        msgno TYPE symsgno VALUE '240',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF end_date_in_the_past,

      BEGIN OF wrong_date_sequence,
        msgid TYPE symsgid VALUE '/LRN/S4D437',
        msgno TYPE symsgno VALUE '220',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF wrong_date_sequence.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcm_14_travel IMPLEMENTATION.
  METHOD constructor ##ADT_SUPPRESS_GENERATION.
    super->constructor(
    ).
    CLEAR me->textid.
    IF textid IS INITIAL.
      if_t100_message~t100key = if_t100_message=>default_textid.
    ELSE.
      if_t100_message~t100key = textid.
    ENDIF.

    IF severity IS INITIAL.
      if_abap_behv_message~m_severity = if_abap_behv_message~severity-error.
    ELSE.
      if_abap_behv_message~m_severity = severity.
    ENDIF.

  ENDMETHOD.

ENDCLASS.
