@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
@EndUserText.label: 'Projection View forBooking'
@Search.searchable: true
define view entity ZC_RAP_BOOKING_U_RWR1
  as projection on ZI_RAP_Booking_U_RWR1
{
  @Search.defaultSearchElement: true
  key TravelID,
  
  @Search.defaultSearchElement: true
  key BookingID,
  
  BookingDate,
  
  @Consumption.valueHelpDefinition: [ {
    entity: {
      name: '/DMO/I_Customer', 
      element: 'CustomerID'
    }
  } ]
  CustomerID,
  
  @Consumption.valueHelpDefinition: [ {
    entity: {
      name: '/DMO/I_Carrier', 
      element: 'AirlineID'
    }
  } ]
  CarrierID,
  
  @Consumption.valueHelpDefinition: [ {
    entity: {
      name: '/DMO/I_Flight', 
      element: 'ConnectionID'
    }, 
    additionalBinding: [ {
      localElement: 'FlightDate', 
      element: 'FlightDate'
    }, {
      localElement: 'CarrierID', 
      element: 'AirlineID'
    }, {
      localElement: 'FlightPrice', 
      element: 'Price'
    }, {
      localElement: 'CurrencyCode', 
      element: 'CurrencyCode'
    } ]
  } ]
  ConnectionID,
  
  FlightDate,
  
  @Semantics.amount.currencyCode: 'CurrencyCode'
  FlightPrice,
  
  @Consumption.valueHelpDefinition: [ {
    entity: {
      name: 'I_Currency', 
      element: 'Currency'
    }
  } ]
  CurrencyCode,
  
  _Travel : redirected to parent ZC_RAP_Travel_U_RWR1
}
