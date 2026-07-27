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

    MODIFY ENTITIES OF Z14_r_travellog
    ENTITY TravelLog
    CREATE AUTO FILL CID
    FIELDS ( AgencyId TravelId Origin )
    WITH CORRESPONDING #( new_travels ).

ENDMETHOD.
ENDCLASS.
