CLASS zcl_14_eml_ DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun .

    CONSTANTS c_agency_id TYPE /dmo/agency_id VALUE '070000'.
    CONSTANTS c_travel_id TYPE /dmo/travel_id VALUE '0004138'.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_14_eml_ IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.
    READ ENTITIES OF Z14_R_travel
    ENTITY Travel
    ALL FIELDS
    WITH VALUE #( ( AgencyId =  c_agency_id
                    TravelId = c_travel_id ) )
    RESULT DATA(travels)
    FAILED DATA(failed).

    IF failed IS NOT INITIAL.
      out->write( 'something went wrong with reading' ).
    ELSE.
      MODIFY ENTITIES OF Z14_R_Travel
      ENTITY travel
      UPDATE FIELDS ( Description )
      WITH VALUE #( ( AgencyId = c_agency_id
                      TravelId = c_travel_id
                      Description = 'new description' ) )
      FAILED failed.

      IF failed IS INITIAL.
        COMMIT ENTITIES.
        out->write( 'New description was added' ).

      ELSE.
        ROLLBACK ENTITIES.
      ENDIF.

    ENDIF.



  ENDMETHOD.
ENDCLASS.
