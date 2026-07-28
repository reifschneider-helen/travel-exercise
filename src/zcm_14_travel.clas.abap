CLASS zcm_14_travel DEFINITION
  PUBLIC
  INHERITING FROM cx_static_check
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.

    INTERFACES if_abap_behv_message.
    INTERFACES if_t100_message.
    INTERFACES if_t100_dyn_msg.

    DATA v1 TYPE string.
    DATA v2 TYPE string.
    DATA v3 TYPE string.
    DATA v4 TYPE string.

    METHODS constructor
      IMPORTING
        !textid  LIKE if_t100_message=>t100key OPTIONAL
        !previous LIKE previous OPTIONAL
        severity LIKE if_abap_behv_message~m_severity OPTIONAL
        v1        TYPE string OPTIONAL
        v2        TYPE string OPTIONAL
        v3        TYPE string OPTIONAL
        v4        TYPE string OPTIONAL .

    CONSTANTS:
      BEGIN OF already_canceled,
        msgid TYPE symsgid VALUE 'Z14_MESSAGES',
        msgno TYPE symsgno VALUE '130',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF already_canceled,

      BEGIN OF customer_not_found,
        msgid TYPE symsgid VALUE 'Z14_MESSAGES',
        msgno TYPE symsgno VALUE '210',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF customer_not_found,

      BEGIN OF flight_date_in_the_past,
        msgid TYPE symsgid VALUE 'Z14_MESSAGES',
        msgno TYPE symsgno VALUE '310',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF flight_date_in_the_past,

        BEGIN OF flight_date_empty,
        msgid TYPE symsgid VALUE 'Z14_MESSAGES',
        msgno TYPE symsgno VALUE '311',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF flight_date_empty,

      BEGIN OF start_date_in_the_past,
        msgid TYPE symsgid VALUE 'Z14_MESSAGES',
        msgno TYPE symsgno VALUE '230',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF start_date_in_the_past,

      BEGIN OF end_date_in_the_past,
        msgid TYPE symsgid VALUE 'Z14_MESSAGES',
        msgno TYPE symsgno VALUE '240',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF end_date_in_the_past,

      BEGIN OF wrong_date_sequence,
        msgid TYPE symsgid VALUE 'Z14_MESSAGES',
        msgno TYPE symsgno VALUE '220',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF wrong_date_sequence,

      BEGIN OF class_is_initial,
        msgid TYPE symsgid VALUE 'Z14_MESSAGES',
        msgno TYPE symsgno VALUE '504',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF class_is_initial,

      BEGIN OF class_not_found,
        msgid TYPE symsgid VALUE 'Z14_MESSAGES',
        msgno TYPE symsgno VALUE '500',
        attr1 TYPE scx_attrname VALUE 'V1',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF class_not_found.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcm_14_travel IMPLEMENTATION.
  METHOD constructor ##ADT_SUPPRESS_GENERATION.
    super->constructor( ).

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

    me->v1 = v1.
    me->v2 = v2.
    me->v3 = v3.
    me->v4 = v4.

  ENDMETHOD.

ENDCLASS.
