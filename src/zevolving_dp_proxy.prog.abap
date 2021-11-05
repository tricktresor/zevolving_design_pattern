REPORT ZEVOLVING_DP_PROXY.
" https://zevolving.com/2012/01/abap-objects-design-patterns-proxy/


INTERFACE lif_data.
  DATA: t_t100 TYPE tt_t100.
  METHODS: get_data
    IMPORTING iv_spras TYPE spras OPTIONAL
    CHANGING ct_data TYPE tt_t100.
  METHODS: write_data.
ENDINTERFACE.                    "lif_data
*
CLASS lcl_proxy_data DEFINITION.
  PUBLIC SECTION.
    INTERFACES: lif_data.
  PRIVATE SECTION.
    DATA: o_t100_data TYPE REF TO lif_data.
ENDCLASS.                    "lcl_proxy_Data DEFINITION
*
CLASS lcl_t100_data DEFINITION.
  PUBLIC SECTION.
    INTERFACES: lif_data.
ENDCLASS.                    "lcl_t100_Data DEFINITION
*
CLASS lcl_proxy_data IMPLEMENTATION.
  METHOD lif_data~get_data.
*   validations
    IF iv_spras NE sy-langu.
      EXIT.
    ENDIF.

*   Authority check
*   some other check

*   instantiate "Real" Object
    CREATE OBJECT o_t100_data TYPE lcl_t100_data.
    o_t100_data->get_data(
      EXPORTING
        iv_spras = iv_spras
      CHANGING
        ct_data = ct_data ).

  ENDMETHOD.                    "lif_data~get_data
  METHOD lif_data~write_data.
    IF o_t100_data IS NOT BOUND.
      WRITE:/ 'No data to display'.
    ELSE.
      o_t100_data->write_data( ).
    ENDIF.
  ENDMETHOD.                    "lif_data~write_Data
ENDCLASS.                    "lcl_proxy_Data IMPLEMENTATION
*
CLASS lcl_t100_data IMPLEMENTATION.
  METHOD lif_data~get_data.
*   This process takes very long time to
*   get the data. You can imagine this happening
*   when accessing big tables without index.
    SELECT * FROM t100
      INTO TABLE lif_data~t_t100
      UP TO 20 ROWS
      WHERE sprsl = iv_spras.
    ct_data = lif_data~t_t100.
  ENDMETHOD.                    "lif_data~get_data
  METHOD lif_data~write_data.
    DATA: lv_lines TYPE i.
    lv_lines = LINES( lif_data~t_t100 ).
    WRITE: / 'Total lines',lv_lines.
  ENDMETHOD.                    "lif_data~write_Data
ENDCLASS.                    "lcl_t100_Data IMPLEMENTATION
*
CLASS lcl_main_app DEFINITION.
  PUBLIC SECTION.
    CLASS-METHODS: run.
ENDCLASS.                    "lcl_main_app DEFINITION
*
CLASS lcl_main_app IMPLEMENTATION.
  METHOD run.
    DATA: lo_proxy TYPE REF TO lif_data.
    DATA: lt_data TYPE tt_t100.

*
    CREATE OBJECT lo_proxy TYPE lcl_proxy_data.
    lo_proxy->get_data( EXPORTING iv_spras = 'x'
                        CHANGING ct_data = lt_data ).
    lo_proxy->write_data( ).

*
    CREATE OBJECT lo_proxy TYPE lcl_proxy_data.
    lo_proxy->get_data( EXPORTING iv_spras = sy-langu
                        CHANGING ct_data = lt_data ).
    lo_proxy->write_data( ).


  ENDMETHOD.                    "run
ENDCLASS.                    "lcl_main_app IMPLEMENTATION
*
START-OF-SELECTION.
  lcl_main_app=>run( ).
