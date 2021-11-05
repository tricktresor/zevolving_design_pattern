REPORT zevolving_dp_factory.

" http://zevolving.com/2011/10/abap-objects-design-patterns-factory-method/

*=====
CLASS ophandler DEFINITION ABSTRACT.
  PUBLIC SECTION.
    CLASS-METHODS: factory
      IMPORTING iv_output_type TYPE kschl
      RETURNING VALUE(ro_obj)  TYPE REF TO ophandler.
    METHODS: process_output ABSTRACT.
ENDCLASS.                    "ophandler DEFINITION

*=====
CLASS ophandler_zabc DEFINITION INHERITING FROM ophandler.
  PUBLIC SECTION.
    METHODS: process_output REDEFINITION.
ENDCLASS.                    "ophandler_zabc DEFINITION
*
CLASS ophandler_zabc IMPLEMENTATION.
  METHOD process_output.
    WRITE: / 'Processing ZABC'.
  ENDMETHOD.                    "process_output
ENDCLASS.                    "ophandler_zabc IMPLEMENTATION

*
CLASS ophandler IMPLEMENTATION.
  METHOD factory.
    CASE iv_output_type.
      WHEN 'ZABC'.
*       This could be very complex logic to instantiate the object
*       so, this wrapper will make sure all that complexity is
*       hidden from the consumer.
        CREATE OBJECT ro_obj TYPE ophandler_zabc.
      WHEN 'ZXYZ'.
        "create another object
      WHEN OTHERS.
        " raise exception
    ENDCASE.
  ENDMETHOD.                    "factory
ENDCLASS.                    "ophandler IMPLEMENTATION

*=====
CLASS lcl_main_app DEFINITION.
  PUBLIC SECTION.
    CLASS-METHODS: run.
ENDCLASS.                    "lcl_main_app DEFINITION
*
CLASS lcl_main_app IMPLEMENTATION.
  METHOD run.
    DATA: lo_output TYPE REF TO ophandler.
    lo_output = ophandler=>factory( 'ZABC' ).
    lo_output->process_output( ).
  ENDMETHOD.                    "run
ENDCLASS.                    "lcl_main_app IMPLEMENTATION


START-OF-SELECTION.
  lcl_main_app=>run( ).
