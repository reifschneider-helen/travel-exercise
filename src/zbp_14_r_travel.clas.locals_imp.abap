
CLASS lhc_Travel DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR Travel RESULT result.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR Travel RESULT result.

    METHODS earlynumbering_create FOR NUMBERING
      IMPORTING entities FOR CREATE Travel.

    METHODS cancel_travel FOR MODIFY
      IMPORTING keys FOR ACTION Travel~cancel_travel.

    METHODS determineStatus FOR DETERMINE ON MODIFY
      IMPORTING keys FOR Travel~determineStatus.

    METHODS determineDuration FOR DETERMINE ON SAVE
      IMPORTING keys FOR Travel~determineDuration.

    METHODS validateCustomer FOR VALIDATE ON SAVE
      IMPORTING keys FOR Travel~validateCustomer.

    METHODS validateBeginDate FOR VALIDATE ON SAVE
      IMPORTING keys FOR Travel~validateBeginDate.

    METHODS validateEndDate FOR VALIDATE ON SAVE
      IMPORTING keys FOR Travel~validateEndDate.

    METHODS validateDateSequence FOR VALIDATE ON SAVE
      IMPORTING keys FOR Travel~validateDateSequence.

ENDCLASS.

CLASS lhc_Travel IMPLEMENTATION.

  METHOD get_instance_authorizations.
*    result = CORRESPONDING #( keys ).
*
*    LOOP AT result ASSIGNING FIELD-SYMBOL(<ls_result>).
*      DATA(rc) = /lrn/cl_s4d437_model=>authority_check(
*                  i_agencyid = <ls_result>-AgencyId
*                  i_actvt = '02' ).
*      IF rc <> 0.
*        <ls_result>-%action-cancel_travel = if_abap_behv=>auth-unauthorized.
*        <ls_result>-%update = if_abap_behv=>auth-unauthorized.
*      ELSE.
*        <ls_result>-%action-cancel_travel = if_abap_behv=>auth-allowed.
*        <ls_result>-%update = if_abap_behv=>auth-allowed.
*      ENDIF.
*    ENDLOOP.
  ENDMETHOD.

  METHOD get_global_authorizations.
  ENDMETHOD.

  METHOD earlynumbering_create.
    DATA(agencyid) = /lrn/cl_s4d437_model=>get_agency_by_user(  ).

    mapped-travel = CORRESPONDING #( entities ).

    LOOP AT mapped-travel ASSIGNING FIELD-SYMBOL(<ls_travel>).
      <ls_travel>-agencyId = agencyid.
      <ls_travel>-travelId = /lrn/cl_s4d437_model=>get_next_travelid(  ).
    ENDLOOP.
  ENDMETHOD.

  METHOD cancel_travel.
    READ ENTITIES OF Z14_R_Travel IN LOCAL MODE
    ENTITY travel
    ALL FIELDS
    WITH CORRESPONDING #( keys )
    RESULT DATA(ls_travels).

    LOOP AT ls_travels ASSIGNING FIELD-SYMBOL(<lv_travel>).
      IF <lv_travel>-status <> 'C'.
        MODIFY ENTITIES OF Z14_R_Travel IN LOCAL MODE
        ENTITY travel
        UPDATE
        FIELDS ( Status )
        WITH VALUE #( ( %tky =  <lv_travel>-%tky
                      status = 'C' )
                       ).
      ELSE.
        APPEND VALUE #( %tky =  <lv_travel>-%tky ) TO failed-travel.

        APPEND VALUE #(  %tky =  <lv_travel>-%tky
                           %msg = NEW zcm_14_travel(
                                         textid = zcm_14_travel=>already_canceled
                                         )
                         )   TO reported-travel.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD determineStatus.
    READ ENTITIES OF z14_r_travel IN LOCAL MODE
    ENTITY travel
    FIELDS ( status )
    WITH CORRESPONDING #( keys )
    RESULT DATA(lt_travels).

    DELETE lt_travels WHERE status IS NOT INITIAL.

    CHECK lt_travels IS NOT INITIAL.

    MODIFY ENTITIES OF z14_r_travel IN LOCAL MODE
    ENTITY travel
    UPDATE FIELDS ( status )
        WITH VALUE #( FOR ls_travel IN lt_travels (
                       %tky = ls_travel-%tky
                       status = 'N' ) )
    REPORTED DATA(lt_reported).

    reported-travel = CORRESPONDING #( lt_reported-travel ).

  ENDMETHOD.

  METHOD determineDuration.
    READ ENTITIES OF z14_r_travel IN LOCAL MODE
    ENTITY Travel
    FIELDS ( BeginDate EndDate )
    WITH CORRESPONDING #( keys )
    RESULT DATA(lt_travels).

    LOOP AT lt_travels ASSIGNING FIELD-SYMBOL(<ls_travel>).
      <ls_travel>-duration = <ls_travel>-EndDate - <ls_travel>-BeginDate.
    ENDLOOP.

    MODIFY ENTITIES OF z14_r_travel IN LOCAL MODE
    ENTITY Travel
    UPDATE FIELDS ( Duration ) WITH CORRESPONDING #( lt_travels ).
  ENDMETHOD.

  METHOD validateCustomer.
    READ ENTITIES OF  z14_r_travel IN LOCAL MODE
    ENTITY Travel
    FIELDS ( CustomerId )
    WITH CORRESPONDING #( keys )
    RESULT DATA(lt_travels).

    DATA(lo_customer) = NEW zcl_14_customer_service(  ).


    LOOP AT lt_travels ASSIGNING FIELD-SYMBOL(<ls_travel>).
      IF lo_customer->customer_exists( <ls_travel>-CustomerId ) = abap_false.

        APPEND VALUE #( %tky = <ls_travel>-%tky ) TO failed-travel.

        APPEND VALUE #( %tky = <ls_travel>-%tky
                        %msg = NEW zcm_14_travel(
                                    textid = zcm_14_travel=>customer_not_found )
                        %element-CustomerId = if_abap_behv=>mk-on
                         ) TO reported-travel.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD validateBeginDate.
    READ ENTITIES OF z14_r_travel IN LOCAL MODE
    ENTITY travel
    FIELDS ( BeginDate )
    WITH CORRESPONDING #( keys )
    RESULT DATA(lt_travels).

    DATA(lv_today) = cl_abap_context_info=>get_system_date( ).

    LOOP AT lt_travels ASSIGNING FIELD-SYMBOL(<ls_travel>).
      IF <ls_travel>-BeginDate < lv_today.
        APPEND VALUE #( %tky = <ls_travel>-%tky ) TO failed-travel.
        APPEND VALUE #( %tky = <ls_travel>-%tky
                        %msg = NEW zcm_14_travel(
                                textid = zcm_14_travel=>start_date_in_the_past )
                        %element-BeginDate = if_abap_behv=>mk-on ) TO reported-travel.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.

  METHOD validateEndDate.
    READ ENTITIES OF z14_r_travel IN LOCAL MODE
      ENTITY travel
      FIELDS ( EndDate )
      WITH CORRESPONDING #( keys )
      RESULT DATA(lt_travels).

    DATA(lv_today) = cl_abap_context_info=>get_system_date( ).

    LOOP AT lt_travels ASSIGNING FIELD-SYMBOL(<ls_travel>).
      IF <ls_travel>-EndDate < lv_today.
        APPEND VALUE #( %tky = <ls_travel>-%tky ) TO failed-travel.
        APPEND VALUE #( %tky = <ls_travel>-%tky
                        %msg = NEW zcm_14_travel(
                                textid = zcm_14_travel=>end_date_in_the_past )
                        %element-EndDate = if_abap_behv=>mk-on ) TO reported-travel.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD validateDateSequence.
    READ ENTITIES OF z14_r_travel IN LOCAL MODE
    ENTITY Travel
    FIELDS ( BeginDate EndDate )
    WITH CORRESPONDING #( keys )
    RESULT DATA(lt_travels).

    LOOP AT lt_travels ASSIGNING FIELD-SYMBOL(<ls_travel>).
      IF <ls_travel>-BeginDate > <ls_travel>-EndDate.
        APPEND VALUE #( %tky = <ls_travel>-%tky  ) TO failed-travel.
        APPEND VALUE #( %tky = <ls_travel>-%tky
                        %msg = NEW zcm_14_travel(
                            textid = zcm_14_travel=>wrong_date_sequence )
                        %element-BeginDate = if_abap_behv=>mk-on
                        %element-EndDate = if_abap_behv=>mk-on
                         ) TO reported-travel.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

ENDCLASS.

CLASS lhc_item DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS validateFlightDate FOR VALIDATE ON SAVE
      IMPORTING keys FOR Item~validateFlightDate.

ENDCLASS.

CLASS lhc_item IMPLEMENTATION.

  METHOD validateFlightDate.
    READ ENTITIES OF Z14_R_Travel IN LOCAL MODE
    ENTITY Item
    FIELDS ( FlightDate )
    WITH CORRESPONDING #( keys )
    RESULT DATA(lt_items).

    DATA(lv_today) = cl_abap_context_info=>get_system_date( ).

    LOOP AT lt_items ASSIGNING FIELD-SYMBOL(<ls_item>).
    APPEND VALUE #( %tky = <ls_item>-%tky
                  %state_area = 'FLIGHT_DATE' ) TO reported-item.


      IF <ls_item>-FlightDate < lv_today.
        APPEND VALUE #( %tky = <ls_item>-%tky ) TO failed-item.

        APPEND VALUE #( %tky = <ls_item>-%tky
                        %msg = NEW zcm_14_TRAVEL( textid = zcm_14_travel=>flight_date_in_the_past )
                        %element-FlightDate = if_abap_behv=>mk-on
                        ) TO reported-Item.

      ELSEIF <ls_item>-FlightDate IS INITIAL.
       APPEND VALUE #( %tky = <ls_item>-%tky ) TO failed-item.

        APPEND VALUE #( %tky = <ls_item>-%tky
                        %msg = NEW zcm_14_TRAVEL( textid = zcm_14_travel=>flight_date_empty )
                        %element-FlightDate = if_abap_behv=>mk-on
                        ) TO reported-Item.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

ENDCLASS.

