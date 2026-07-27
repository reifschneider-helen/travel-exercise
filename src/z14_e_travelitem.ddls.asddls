@AbapCatalog.extensibility: {
    extensible: true,
    allowNewDatasources: false,
    dataSources: ['Item'],
    elementSuffix: 'Z14'
    }
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Extension include view'
@Metadata.ignorePropagatedAnnotations: true
define view entity Z14_E_TravelItem
  as select from z14_tritem as Item
{
  key item_uuid as ItemUuid
}
