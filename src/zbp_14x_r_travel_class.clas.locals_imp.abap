CLASS lhc_item DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.
    CONSTANTS c_state_area_class TYPE string VALUE 'VALIDATE_CLASS'.

    METHODS ZZvalidateClass FOR VALIDATE ON SAVE
      IMPORTING keys FOR Item~ZZvalidateClass.

ENDCLASS.

CLASS lhc_item IMPLEMENTATION.

  METHOD ZZvalidateClass.
    READ ENTITIES OF Z14_R_Travel IN LOCAL MODE
    ENTITY Item
    FIELDS ( AgencyId TravelId ZZClassZ14 )
    WITH CORRESPONDING #( keys )
    RESULT DATA(lt_result).

    SELECT class_id
    FROM z14_flclass
    INTO TABLE @DATA(lt_class_ids).

    LOOP AT lt_result ASSIGNING FIELD-SYMBOL(<ls_result>).
      APPEND VALUE #( %tky = <ls_result>-%tky
                      %state_area = c_state_area_class
                      %path = CORRESPONDING #( <ls_result> ) ) TO reported-item.

      IF <ls_result>-ZZClassZ14 IS INITIAL.
        APPEND VALUE #( %tky = <ls_result>-%tky ) TO failed-item.
        APPEND VALUE #( %tky = <ls_result>-%tky
                        %state_area = c_state_area_class
                        %msg = NEW zcm_14_travel( textid = zcm_14_travel=>class_is_initial )
                        %element-ZZClassZ14 = if_abap_behv=>mk-on
                        %path-travel = CORRESPONDING #( <ls_result> ) ) TO reported-item.
      ENDIF.

      IF NOT line_exists( lt_class_ids[ class_id = <ls_result>-ZZClassZ14  ] ).
        APPEND VALUE #( %tky = <ls_result>-%tky ) TO failed-item.
        APPEND VALUE #( %tky = <ls_result>-%tky
                        %state_area = c_state_area_class
                        %msg = NEW zcm_14_travel( textid = zcm_14_travel=>class_not_found
                                                  v1 = CONV #( <ls_result>-ZZClassZ14 ) )
                        %element-ZZClassZ14 = if_abap_behv=>mk-on
                        %path-travel = CORRESPONDING #( <ls_result> ) ) TO reported-item.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

ENDCLASS.

CLASS lsc_Z14_R_TRAVEL DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS save_modified REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_Z14_R_TRAVEL IMPLEMENTATION.

  METHOD save_modified.
    LOOP AT update-item ASSIGNING FIELD-SYMBOL(<ls_u_item>)
    WHERE %control-ZZClassZ14 = if_abap_behv=>mk-on.
      UPDATE z14_tritem
      SET zzclassz14 = @<ls_u_item>-ZZClassZ14
      WHERE item_uuid = @<ls_u_item>-ItemUuid.
    ENDLOOP.

    LOOP AT create-item ASSIGNING FIELD-SYMBOL(<ls_c_item>)
    WHERE %control-ZZClassZ14 = if_abap_behv=>mk-on.
      UPDATE z14_tritem
      SET zzclassz14 = @<ls_c_item>-ZZClassZ14
      WHERE item_uuid = @<ls_c_item>-ItemUuid.
    ENDLOOP.
  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.
