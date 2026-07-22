@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Booking Class'
@Metadata.allowExtensions: true
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity Z14_R_Class
  as select from    z14_flclass  as class
    left outer join z14_flclasst as text
      on  class.class_id = text.class_id
      and text.language = $session.system_language
  {
    key class.class_id    as ClassID,
        class.priority    as Priority,
        text.description as Description,
        concat( class.priority,
                text.description
               )      as AllElements
  }
