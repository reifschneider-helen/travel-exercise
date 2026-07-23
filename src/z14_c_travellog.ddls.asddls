@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Travel Logs Projection'
@Metadata.allowExtensions: true
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.semanticKey: [ 'UUID' ]
define root view entity Z14_C_TRAVELLOG
  provider contract transactional_query
  as projection on Z14_R_TRAVELLOG
{
  key Uuid,
      AgencyId,
      TravelId,
      Origin,
      ChangedAt,
      ChangedBy,
      LocChangedAt
}
