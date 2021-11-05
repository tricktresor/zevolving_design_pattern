REPORT ZEVOLVING_DP_FACADE.
" https://zevolving.com/2012/01/abap-objects-design-patterns-facade/

*
CLASS lcl_data DEFINITION.
  PUBLIC SECTION.
    METHODS: constructor.
ENDCLASS.                    "lcl_Data DEFINITION
*
INTERFACE lif_write.
  METHODS: write_data.
ENDINTERFACE.                    "lif_write DEFINITION
*
CLASS lcl_write_alv DEFINITION.
  PUBLIC SECTION.
    INTERFACES: lif_write.
ENDCLASS.                    "lcl_write_alv DEFINITION
*
CLASS lcl_write_log DEFINITION.
  PUBLIC SECTION.
    INTERFACES: lif_write.
ENDCLASS.                    "lcl_write_log DEFINITION
*
CLASS lcl_facade DEFINITION.
  PUBLIC SECTION.
    METHODS: process_report IMPORTING iv_write_type TYPE char1.
ENDCLASS.                    "lcl_facade DEFINITION
*
CLASS lcl_data IMPLEMENTATION.
  METHOD constructor.
    WRITE: / 'Getting Data'.
  ENDMETHOD.                    "constructor
ENDCLASS.                    "lcl_Data IMPLEMENTATION
*
CLASS lcl_write_alv IMPLEMENTATION.
  METHOD lif_write~write_data.
    WRITE: / 'Writing data in ALV'.
  ENDMETHOD.                    "lif_write~write_Data
ENDCLASS.                    "lcl_write_alv IMPLEMENTATION
*
CLASS lcl_write_log IMPLEMENTATION.
  METHOD lif_write~write_data.
    WRITE: / 'writing data in Log'.
  ENDMETHOD.                    "lif_write~write_Data
ENDCLASS.                    "lcl_write_log IMPLEMENTATION
*
CLASS lcl_facade IMPLEMENTATION.
  METHOD process_report.
    DATA: lo_data TYPE REF TO lcl_data.
    CREATE OBJECT lo_data.

    DATA: lo_write TYPE REF TO lif_write.
    IF iv_write_type = 'A'.
      CREATE OBJECT lo_write TYPE lcl_write_alv.
    ELSE.
      CREATE OBJECT lo_write TYPE lcl_write_log.
    ENDIF.
    lo_write->write_data( ).
  ENDMETHOD.                    "process_report
ENDCLASS.                    "lcl_facade IMPLEMENTATION

PARAMETERS p_alv RADIOBUTTON GROUP out DEFAULT 'X'.
PARAMETERS p_log RADIOBUTTON GROUP out.

START-OF-SELECTION.
  DATA: lo_facade TYPE REF TO lcl_facade.
  CREATE OBJECT lo_facade.
  lo_facade->process_report( iv_write_type = switch #( p_alv when abap_true then 'A' else space ) ).
