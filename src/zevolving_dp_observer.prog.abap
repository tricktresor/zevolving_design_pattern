REPORT ZEVOLVING_DP_OBSERVER.
" https://zevolving.com/2011/10/abap-objects-design-patterns-%e2%80%93-observer/

*====
CLASS mainprocess DEFINITION.
  PUBLIC SECTION.
    METHODS: set_state IMPORTING iv_state TYPE char1.
    EVENTS: state_changed EXPORTING value(new_state) TYPE char1.
  PRIVATE SECTION.
    DATA: current_state TYPE char1.
ENDCLASS.                    "mainprocess DEFINITION
*
CLASS mainprocess IMPLEMENTATION.
  METHOD set_state.
    current_state = iv_state.
    SKIP 2.
    WRITE: / 'Main Process new state', current_state.
    RAISE EVENT state_changed EXPORTING new_state = current_state.
  ENDMETHOD.                    "set_state
ENDCLASS.                    "mainprocess IMPLEMENTATION

*====
CLASS myfunction DEFINITION ABSTRACT.
  PUBLIC SECTION.
    METHODS: on_state_changed ABSTRACT
      FOR EVENT state_changed OF mainprocess
      IMPORTING new_state.
ENDCLASS.                    "myfunction DEFINITION

*====
CLASS myalv DEFINITION INHERITING FROM myfunction.
  PUBLIC SECTION.
    METHODS: on_state_changed REDEFINITION.
ENDCLASS.                    "myalv DEFINITION
*
CLASS myalv IMPLEMENTATION.
  METHOD on_state_changed.
    WRITE: / 'New state in ALV processing', new_state.
  ENDMETHOD.                    "on_state_changed
ENDCLASS.                    "myalv IMPLEMENTATION
*====
CLASS mydb DEFINITION INHERITING FROM myfunction.
  PUBLIC SECTION.
    METHODS: on_state_changed REDEFINITION.
ENDCLASS.                    "mydb DEFINITION
*
CLASS mydb IMPLEMENTATION.
  METHOD on_state_changed.
    WRITE: / 'New State in DB processing', new_state.
  ENDMETHOD.                    "on_state_changed
ENDCLASS.                    "mydb IMPLEMENTATION

*====
CLASS mainapp DEFINITION.
  PUBLIC SECTION.
    CLASS-METHODS: run.
ENDCLASS.                    "mainapp DEFINITION
*
CLASS mainapp IMPLEMENTATION.
  METHOD run.

    DATA: lo_process TYPE REF TO mainprocess.
    DATA: lo_alv TYPE REF TO myalv.
    DATA: lo_db TYPE REF TO mydb.

*   Instantiate the objects
    CREATE OBJECT lo_process.
    CREATE OBJECT: lo_alv, lo_db.

*   Event handlers
    SET HANDLER lo_alv->on_state_changed FOR lo_process.
    SET HANDLER lo_db->on_state_changed FOR lo_process.

*   Set new state
    lo_process->set_state( 'A' ).
    lo_process->set_state( 'B' ).
    lo_process->set_state( 'C' ).

  ENDMETHOD.                    "run
ENDCLASS.                    "mainapp IMPLEMENTATION

START-OF-SELECTION.
  mainapp=>run( ).
