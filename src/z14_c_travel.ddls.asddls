@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Consumption view'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define root view entity Z14_C_Travel
  provider contract transactional_query
  as projection on Z14_R_Travel

{
  key AgencyId,
  key TravelId,
      Description,
      @Consumption.valueHelpDefinition:
        [ { entity:
            { name: '/DMO/I_Customer_StdVH',
              element: 'CustomerID' }
        } ]
      CustomerId,
      BeginDate,
      EndDate,
      @EndUserText.label: 'Duration (days)'
      Duration,
      Status,
      ChangedAt,
      ChangedBy,
      LocChangedAt,

      _Item : redirected to composition child Z14_C_TRAVELITEM
}
