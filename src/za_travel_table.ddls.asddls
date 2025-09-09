@EndUserText.label: 'za_travel_table'
define abstract entity za_travel_table
{
  key operator       : abap.char( 20 );
  key travel_id_low  : abap.numc( 8 );
  key travel_id_high : abap.numc( 8 );
  key dummy          : abap.char(1);
      _root          : association to parent ZA_TRAVEL_FILTER on $projection.dummy = _root.dummy;

}
