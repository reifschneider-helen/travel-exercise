@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Fllight travel item'
@Metadata.ignorePropagatedAnnotations: true
define view entity Z14_I_TRAVELITEM
  as select from z14_tritem
  association to parent Z14_R_Travel as _Travel on  $projection.TravelId = _Travel.TravelId
                                                and $projection.AgencyId = _Travel.AgencyId
{
  key item_uuid            as ItemUuid,
      agency_id            as AgencyId,
      travel_id            as TravelId,
      carrier_id           as CarrierId,
      connection_id        as ConnectionId,
      flight_date          as FlightDate,
      booking_id           as BookingId,
      passenger_first_name as PassengerFirstName,
      passenger_last_name  as PassengerLastName,
      @Semantics.systemDateTime.lastChangedAt: true
      changed_at           as ChangedAt,
      @Semantics.user.lastChangedBy: true
      changed_by           as ChangedBy,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      loc_changed_at       as LocChangedAt,

      _Travel
}
