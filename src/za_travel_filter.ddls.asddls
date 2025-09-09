@EndUserText.label: 'Deep Parameter Root'
define root abstract entity ZA_TRAVEL_FILTER
{
    key dummy: abap.char(1); 
    _travel : composition [0..*] of za_travel_table;
}
