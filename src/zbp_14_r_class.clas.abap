CLASS zbp_14_r_class DEFINITION PUBLIC ABSTRACT FINAL FOR BEHAVIOR OF z14_r_class.
  PUBLIC SECTION.
    TYPES:
        BEGIN OF ty_delete,
            class_id TYPE z14_flclass-class_id,
        END OF ty_delete.

    CLASS-DATA:
        gt_create_buffer TYPE TABLE OF z14_s_class,
        gt_update_buffer TYPE TABLE OF z14_s_class,
        gt_delete_buffer TYPE TABLE OF ty_delete.
ENDCLASS.

CLASS zbp_14_r_class IMPLEMENTATION.
ENDCLASS.
