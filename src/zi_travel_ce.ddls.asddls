@EndUserText.label: 'Custom entity for unmanaged travel query'
@ObjectModel.query.implementedBy:'ABAP:ZCL_TRAVEL_DPC' 
@UI: {
  headerInfo: {
    typeName: 'Travel',
    typeNamePlural: 'Travels',
    title: { value: 'Travel_ID' }
  }
}
define root custom entity ZI_TRAVEL_CE
{
      @UI.facet   : [{
        position  : 10,
        label     : 'Travels',
        type      : #IDENTIFICATION_REFERENCE
      }]
  
  @EndUserText.label: 'Travel ID'
  @UI.lineItem: [{ position: 10 },
  { type: #FOR_ACTION, dataAction: 'approveTravel', label: 'Approve' },
  { type: #FOR_ACTION, dataAction: 'resetSelected', label: 'Reset (based on selection)' } ]
  @UI.selectionField: [{ position: 10 }]
  @UI.identification: [{ position: 10 }]
  key Travel_ID     : abap.numc( 8 );
  @EndUserText.label: 'Agency ID'
  @UI.lineItem: [{ position: 20 } ]
  @UI.selectionField: [{ position: 20 }]
  @UI.identification: [{ position: 20 }]
      Agency_ID     : abap.numc( 6 );
  @EndUserText.label: 'Customer ID'
  @UI.lineItem: [{ position: 30 } ]
  @UI.selectionField: [{ position: 30 }]
  @UI.identification: [{ position: 30 }]
      Customer_ID   : abap.numc( 6 );
  @EndUserText.label: 'Begin Date'
  @UI.lineItem: [{ position: 40 } ]
  @UI.selectionField: [{ position: 40 }]
  @UI.identification: [{ position: 40 }]
      Begin_Date    : abap.dats;
  @EndUserText.label: 'End Date'
  @UI.lineItem: [{ position: 50 } ]
  @UI.selectionField: [{ position: 50 }]
  @UI.identification: [{ position: 50 }]
      End_Date      : abap.dats;
  @EndUserText.label: 'Booking Fee'
  @UI.lineItem: [{ position: 60 } ]
  @UI.identification: [{ position: 60 }]
      Booking_Fee   : abap.dec( 17, 3 );
  @EndUserText.label: 'Total Price'
  @UI.lineItem: [{ position: 70 } ]
  @UI.identification: [{ position: 70 }]
      Total_Price   : abap.dec( 17, 3 );
  @EndUserText.label: 'Currency'
  @UI.lineItem: [{ position: 80 } ]
  @UI.identification: [{ position: 80 }]
      Currency_Code : abap.cuky;
  @EndUserText.label: 'Approved'
  @UI.lineItem: [{ position: 90 } ]
  @UI.selectionField: [{ position: 90 }]
  @UI.identification: [{ position: 90 }]
      Approved        : abap_boolean;
      LastChangedAt : timestampl;
}
