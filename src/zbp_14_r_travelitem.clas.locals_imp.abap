CLASS lhc_Item DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    CONSTANTS: c_state_area_item_flight_date TYPE string VALUE 'ITEM_VALIDATE_FLIGHT_DATE'.

    METHODS determineTravelDates FOR DETERMINE ON SAVE
      IMPORTING keys FOR Item~determineTravelDates.

    METHODS validateFlightDate FOR VALIDATE ON SAVE
      IMPORTING keys FOR Item~validateFlightDate.

ENDCLASS.

CLASS lhc_Item IMPLEMENTATION.

  METHOD determineTravelDates.
    READ ENTITIES OF Z14_R_Travel IN LOCAL MODE
    ENTITY Item
    FIELDS ( FlightDate )
    WITH CORRESPONDING #( keys )
    RESULT DATA(lt_items)

    BY \_Travel
    FIELDS ( BeginDate EndDate )
    WITH CORRESPONDING #( keys )
    RESULT DATA(lt_travels)
    LINK DATA(link).

    LOOP AT lt_items ASSIGNING FIELD-SYMBOL(<ls_item>).
      ASSIGN lt_travels[ KEY id %tky =
          link[ KEY id source-%tky =  <ls_item>-%tky ]-target-%tky ]
          TO FIELD-SYMBOL(<ls_travel>).

      IF <ls_travel>-EndDate < <ls_item>-FlightDate.
        <ls_travel>-EndDate = <ls_item>-FlightDate.
      ENDIF.

      IF <ls_item>-FlightDate > cl_abap_context_info=>get_system_date( )
          AND <ls_item>-FlightDate  < <ls_travel>-BeginDate.
        <ls_travel>-BeginDate = <ls_item>-FlightDate.
      ENDIF.
    ENDLOOP.

    MODIFY ENTITIES OF Z14_R_Travel IN LOCAL MODE
    ENTITY Travel
    UPDATE
    FIELDS ( BeginDate EndDate )
    WITH CORRESPONDING #( lt_travels ).
  ENDMETHOD.

  METHOD validateFlightDate.
    READ ENTITIES OF Z14_R_Travel IN LOCAL MODE
    ENTITY Item
    FIELDS ( TravelId AgencyId FlightDate )
    WITH CORRESPONDING #( keys )
    RESULT DATA(lt_items).

    DATA(lv_today) = cl_abap_context_info=>get_system_date( ).

    LOOP AT lt_items ASSIGNING FIELD-SYMBOL(<ls_item>).
      APPEND VALUE #( %tky = <ls_item>-%tky
                      %state_area = c_state_area_item_flight_date
                      %path = CORRESPONDING #(  <ls_item> ) ) TO reported-item.

      IF <ls_item>-FlightDate IS INITIAL.
        APPEND VALUE #( %tky = <ls_item>-%tky ) TO failed-item.

        APPEND VALUE #( %tky = <ls_item>-%tky
                        %state_area = c_state_area_item_flight_date
                        %msg = NEW zcm_14_TRAVEL( textid = zcm_14_travel=>flight_date_empty )
                        %element-FlightDate = if_abap_behv=>mk-on
                        %path-travel        = CORRESPONDING #( <ls_item> )
                        ) TO reported-Item.

      ELSEIF <ls_item>-FlightDate < lv_today.
        APPEND VALUE #( %tky = <ls_item>-%tky ) TO failed-item.

        APPEND VALUE #( %tky = <ls_item>-%tky
                        %state_area = c_state_area_item_flight_date
                        %msg = NEW zcm_14_TRAVEL( textid = zcm_14_travel=>flight_date_in_the_past )
                        %element-FlightDate = if_abap_behv=>mk-on
                        %path-travel        = CORRESPONDING #( <ls_item> )
                        ) TO reported-Item.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.
ENDCLASS.
