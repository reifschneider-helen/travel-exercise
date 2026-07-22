CLASS lhc_Class DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR Class RESULT result.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR Class RESULT result.

    METHODS read FOR READ
      IMPORTING keys FOR READ Class RESULT result.

    METHODS lock FOR LOCK
      IMPORTING keys FOR LOCK Class.

    METHODS create FOR MODIFY
      IMPORTING entities FOR CREATE Class.

    METHODS update FOR MODIFY
      IMPORTING entities FOR UPDATE Class.

    METHODS delete FOR MODIFY
      IMPORTING keys FOR DELETE Class.

ENDCLASS.

CLASS lhc_Class IMPLEMENTATION.

  METHOD get_global_authorizations.
  ENDMETHOD.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD read.
    SELECT
    FROM z14_flclass AS Class
        LEFT OUTER JOIN z14_flclasst AS Text
            ON Class~class_id = Text~class_id
    FIELDS Class~class_id,
           Class~priority,
           Text~language,
           Text~description
    FOR ALL ENTRIES IN @keys
    WHERE Class~class_id = @keys-ClassID
    INTO CORRESPONDING FIELDS OF TABLE @result.

  ENDMETHOD.

  METHOD lock.
  ENDMETHOD.

  METHOD create.
    LOOP AT entities ASSIGNING FIELD-SYMBOL(<entity>).
      APPEND VALUE z14_s_class(
        class_id    = <entity>-ClassID
        priority    = <entity>-Priority
        language    = sy-langu
        description = <entity>-Description
      ) TO zbp_14_r_class=>gt_create_buffer.

      APPEND VALUE #(
        %cid = <entity>-%cid
        ClassID = <entity>-ClassID
      ) TO mapped-class.

    ENDLOOP.
  ENDMETHOD.

  METHOD update.
    LOOP AT entities ASSIGNING FIELD-SYMBOL(<entity>).

      APPEND VALUE z14_s_class(
        class_id    = <entity>-ClassID
        priority    = <entity>-Priority
        language    = sy-langu
        description = <entity>-Description
      )
      TO zbp_14_r_class=>gt_update_buffer.
    ENDLOOP.
  ENDMETHOD.

  METHOD delete.
    LOOP AT keys ASSIGNING FIELD-SYMBOL(<key>).
      APPEND VALUE #( class_id = <key>-ClassID ) TO zbp_14_r_class=>gt_delete_buffer.
    ENDLOOP.

  ENDMETHOD.

ENDCLASS.

CLASS lsc_14_r_class DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS finalize REDEFINITION.

    METHODS check_before_save REDEFINITION.

    METHODS save REDEFINITION.

    METHODS cleanup REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_14_r_class IMPLEMENTATION.

  METHOD finalize.
    SORT zbp_14_r_class=>gt_create_buffer
    BY class_id.
  ENDMETHOD.

  METHOD check_before_save.
  ENDMETHOD.

  METHOD save.
    DATA ls_flclass TYPE z14_flclass.
    DATA ls_fltext TYPE z14_flclasst.

****CREATE BUFFER
    LOOP AT zbp_14_r_class=>gt_create_buffer ASSIGNING FIELD-SYMBOL(<create_class>).
      CLEAR ls_flclass.

      ls_flclass-class_id = <create_class>-class_id.
      ls_flclass-priority = <create_class>-priority.

      INSERT z14_flclass
      FROM @ls_flclass.

      CLEAR ls_fltext.

      ls_fltext-class_id = <create_class>-class_id.
      ls_fltext-language = <create_class>-language.
      ls_fltext-description = <create_class>-description.

      INSERT z14_flclasst
      FROM @ls_fltext.
    ENDLOOP.

****UPDATE BUFFER
    LOOP AT zbp_14_r_class=>gt_update_buffer ASSIGNING FIELD-SYMBOL(<update_class>).

      UPDATE z14_flclass
      SET priority = @<update_class>-priority
      WHERE class_id = @<update_class>-class_id.

      UPDATE Z14_flclasst
      SET language = @<update_class>-language,
          description = @<update_class>-description
      WHERE class_id = @<update_class>-class_id.

    ENDLOOP.
****DELETE BUFFER
    LOOP AT zbp_14_r_class=>gt_delete_buffer ASSIGNING FIELD-SYMBOL(<delete_class>).
      DELETE
      FROM z14_flclasst
      WHERE class_id = @<delete_class>-class_id.

      DELETE
      FROM z14_flclass
      WHERE class_id = @<delete_class>-class_id.

    ENDLOOP.

    CLEAR:
        zbp_14_r_class=>gt_create_buffer,
        zbp_14_r_class=>gt_update_buffer,
        zbp_14_r_class=>gt_delete_buffer.

  ENDMETHOD.

  METHOD cleanup.
    CLEAR:
    zbp_14_r_class=>gt_create_buffer,
    zbp_14_r_class=>gt_update_buffer,
    zbp_14_r_class=>gt_delete_buffer.
  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.
