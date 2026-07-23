@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Travel Logs Root'
@Metadata.ignorePropagatedAnnotations: true
define root view entity Z14_R_TRAVELLOG
  as select from z14_trlog
{
  key uuid           as Uuid,
      agency_id      as AgencyId,
      travel_id      as TravelId,
      origin         as Origin,
      @Semantics.systemDateTime.lastChangedAt: true
      changed_at     as ChangedAt,
      @Semantics.user.lastChangedBy: true
      changed_by     as ChangedBy,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      loc_changed_at as LocChangedAt
}
