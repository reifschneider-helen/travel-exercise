extend view entity Z14_C_TRAVELITEM with {
    @Consumption.valueHelpDefinition: [{
    entity: { name:    '/LRN/437_I_ClassStdVH',
              element: 'ClassID' }
    }
    ]
    Item.ZZClassZ14
}
