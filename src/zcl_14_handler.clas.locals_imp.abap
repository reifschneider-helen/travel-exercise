CLASS lcl_handler DEFINITION
INHERITING FROM cl_abap_behavior_event_handler.
PRIVATE SECTION.
    METHODS:
        on_travel_created FOR ENTITY EVENT
            IMPORTING new_travels
            FOR Travel~TravelCreated.
ENDCLASS.

CLASS lcl_handler IMPLEMENTATION.
Method on_travel_created.
    DATA lt_log TYPE TABLE FOR CREATE Z14_r_travellog.

    LOOP AT new_travels ASSIGNING FIELD-SYMBOL(<ls_new_travel>).
        APPEND VALUE #( AgencyId = <ls_new_travel>-AgencyId
                        TravelId = <ls_new_travel>-TravelId
                        Origin = 'Z14_R_Travel'
                 ) TO lt_log.
    ENDLOOP.

    MODIFY ENTITIES OF Z14_r_travellog
    ENTITY TravelLog
    CREATE AUTO FILL CID
    FIELDS ( AgencyId TravelId Origin )
    WITH lt_log.

ENDMETHOD.
ENDCLASS.
