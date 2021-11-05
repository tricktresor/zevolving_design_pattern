REPORT zevolving_dp_adapter.

" https://zevolving.com/2012/01/abap-objects-design-patterns-%e2%80%93-adapter/

INTERFACE lif_output.
  METHODS: generate_output.
ENDINTERFACE.                    "lif_output
*
CLASS simple_op DEFINITION.
  PUBLIC SECTION.
    INTERFACES: lif_output.
ENDCLASS.                    "simple_op DEFINITION
*
CLASS simple_op IMPLEMENTATION.
  METHOD lif_output~generate_output.
    WRITE: / 'Simple Output - just using WRITE'.
  ENDMETHOD.                    "lif_output~generate_output
ENDCLASS.                    "simple_op IMPLEMENTATION
*
CLASS tree_output DEFINITION.
  PUBLIC SECTION.
    METHODS: generate_tree.
ENDCLASS.                    "tree_output DEFINITION
*
CLASS tree_output IMPLEMENTATION.
  METHOD generate_tree.
    WRITE: / 'Creating Tree ... using CL_GUI_ALV_TREE'.
  ENDMETHOD.                    "generate_tree
ENDCLASS.                    "tree_output IMPLEMENTATION
*
CLASS new_complex_op DEFINITION.
  PUBLIC SECTION.
    INTERFACES: lif_output.
ENDCLASS.                    "new_complex_op DEFINITION
*
CLASS new_complex_op IMPLEMENTATION.
  METHOD lif_output~generate_output.
    DATA: o_tree_op TYPE REF TO tree_output.
    CREATE OBJECT o_tree_op.
    o_tree_op->generate_tree( ).
  ENDMETHOD.                    "lif_output~generate_output
ENDCLASS.                    "new_complex_op IMPLEMENTATION
*
START-OF-SELECTION.
  DATA: o_op TYPE REF TO lif_output.
  CREATE OBJECT o_op TYPE simple_op.
  o_op->generate_output( ).

* using the same "simple" Interface to perform the "complex",
* Since Client only wants to use Simple interface ..
  CREATE OBJECT o_op TYPE new_complex_op.
  o_op->generate_output( ).
