@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
@EndUserText.label: 'Projection View forTravel'
@Search.searchable: true
define root view entity ZC_RAP_TRAVEL_U_RWR1
  as projection on ZI_RAP_Travel_U_RWR1
{
  @Search.defaultSearchElement: true
  key TravelID,
  
  @Consumption.valueHelpDefinition: [ {
    entity: {
      name: '/DMO/I_Agency', 
      element: 'AgencyID'
    }
  } ]
  AgencyID,
  
  @Consumption.valueHelpDefinition: [ {
    entity: {
      name: '/DMO/I_Customer', 
      element: 'CustomerID'
    }
  } ]
  CustomerID,
  
  BeginDate,
  
  EndDate,
  
  @Semantics.amount.currencyCode: 'CurrencyCode'
  BookingFee,
  
  @Semantics.amount.currencyCode: 'CurrencyCode'
  TotalPrice,
  
  @Consumption.valueHelpDefinition: [ {
    entity: {
      name: 'I_Currency', 
      element: 'Currency'
    }
  } ]
  CurrencyCode,
  
  Description,
  
  Status,
  
  Createdby,
  
  Createdat,
  
  Lastchangedby,
  
  Lastchangedat,
  
  _Booking : redirected to composition child ZC_RAP_Booking_U_RWR1
}
