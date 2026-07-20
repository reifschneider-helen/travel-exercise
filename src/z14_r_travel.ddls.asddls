@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Root view'
@Metadata.ignorePropagatedAnnotations: true
define root view entity Z14_R_Travel
  as select from z14_travel

  composition [0..*] of Z14_I_TRAVELITEM as _Item

{
  key agency_id                               as AgencyId,
  key travel_id                               as TravelId,
      description                             as Description,
      customer_id                             as CustomerId,
      begin_date                              as BeginDate,
      end_date                                as EndDate,
      dats_days_between(begin_date, end_date) as Duration,
      status                                  as Status,
      @Semantics.systemDateTime.lastChangedAt: true
      changed_at                              as ChangedAt,
      @Semantics.user.lastChangedBy: true
      changed_by                              as ChangedBy,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      loc_changed_at                          as LocChangedAt,


      _Item

}
