@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
@EndUserText.label: 'CDS View forTravel'
define root view entity ZI_RAP_TRAVEL_U_RWR1
  as select from /dmo/travel
  association [0..1] to /DMO/I_Agency as _Agency on $projection.AgencyID = _Agency.AgencyID
  association [0..1] to I_Currency as _Currency on $projection.CurrencyCode = _Currency.Currency
  association [0..1] to /DMO/I_Customer as _Customer on $projection.CustomerID = _Customer.CustomerID
  composition [0..*] of ZI_RAP_Booking_U_RWR1 as _Booking
{
  key TRAVEL_ID as TravelID,
  
  AGENCY_ID as AgencyID,
  
  CUSTOMER_ID as CustomerID,
  
  BEGIN_DATE as BeginDate,
  
  END_DATE as EndDate,
  
  @Semantics.amount.currencyCode: 'CurrencyCode'
  BOOKING_FEE as BookingFee,
  
  @Semantics.amount.currencyCode: 'CurrencyCode'
  TOTAL_PRICE as TotalPrice,
  
  CURRENCY_CODE as CurrencyCode,
  
  DESCRIPTION as Description,
  
  STATUS as Status,
  
  @Semantics.user.createdBy: true
  CREATEDBY as Createdby,
  
  @Semantics.systemDateTime.createdAt: true
  CREATEDAT as Createdat,
  
  @Semantics.user.lastChangedBy: true
  LASTCHANGEDBY as Lastchangedby,
  
  @Semantics.systemDateTime.lastChangedAt: true
  LASTCHANGEDAT as Lastchangedat,
  
  _Booking,
  
  _Agency,
  
  _Currency,
  
  _Customer
}
