REPORT zevolving_dp_prototype.

" https://zevolving.com/2012/02/abap-objects-design-patterns-prototype/

CLASS lcl_report_data DEFINITION ABSTRACT.
  PUBLIC SECTION.
    METHODS: clone ABSTRACT
      RETURNING VALUE(ro_object) TYPE REF TO lcl_report_data.
    METHODS: select_data ABSTRACT.
ENDCLASS.                    "lcl_report_data DEFINITION
*
CLASS lcl_detail_report_data DEFINITION INHERITING FROM lcl_report_data.
  PUBLIC SECTION.
    METHODS: clone REDEFINITION.
    METHODS: select_data REDEFINITION.
    DATA: t_data TYPE STANDARD TABLE OF t100.
ENDCLASS.                    "lcl_detail_report_data DEFINITION
*
CLASS lcl_detail_report_data IMPLEMENTATION.
  METHOD select_data.
    SELECT * FROM t100
      INTO TABLE t_data
      UP TO 20 ROWS
      WHERE sprsl = sy-langu.
  ENDMETHOD.                    "select_Data
  METHOD clone.
*   instantiate a new object
*   Declaring a temp variable helps to set all the attributes
*   by its name and allows to call the methods of the subclass
*   itself as RO_OBJECT is defined wrt to Super class
    DATA: lo_object TYPE REF TO lcl_detail_report_data.
    CREATE OBJECT lo_object.
*   list down all the attributes which needs to be copied over
    lo_object->t_data = me->t_data.

*   Set it to return object
    ro_object = lo_object.

  ENDMETHOD.                    "clone
ENDCLASS.                    "lcl_detail_report_data IMPLEMENTATION
*
CLASS lcl_main DEFINITION.
  PUBLIC SECTION.
    CLASS-METHODS: run.
ENDCLASS.                    "lcl_main DEFINITION
*
CLASS lcl_main IMPLEMENTATION.
  METHOD run.
    DATA: lo_report TYPE REF TO lcl_report_data.
    CREATE OBJECT lo_report TYPE lcl_detail_report_data.
    lo_report->select_data( ).

    DATA: lo_rep_2 TYPE REF TO lcl_report_data.
    lo_rep_2 = lo_report->clone( ).

  ENDMETHOD.                    "run
ENDCLASS.                    "lcl_main IMPLEMENTATION
*
START-OF-SELECTION.
  lcl_main=>run( ).
