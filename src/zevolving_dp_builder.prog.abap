REPORT zevolving_dp_builder.

" https://zevolving.com/2013/04/abap-objects-design-patterns-builder/

INTERFACE lif_pizza.
  DATA: dough   TYPE string,
        sauce   TYPE string,
        topping TYPE string.
ENDINTERFACE.                    "lif_pizza
*
CLASS lcl_pizza DEFINITION.
  PUBLIC SECTION.
    INTERFACES: lif_pizza.
ENDCLASS.                    "lcl_pizza DEFINITION
* abstract builder
CLASS pizzabuilder DEFINITION ABSTRACT.
  PUBLIC SECTION.
    METHODS: createnewpizza
      RETURNING VALUE(ro_pizza) TYPE REF TO lif_pizza.
    METHODS: builddough ABSTRACT,
      buildsauce ABSTRACT,
             buildtopping ABSTRACT.
  PROTECTED SECTION.
    DATA: pizza TYPE REF TO lif_pizza.
ENDCLASS.                    "pizzabuilder DEFINITION
*
CLASS pizzabuilder IMPLEMENTATION.
  METHOD createnewpizza.
    CREATE OBJECT pizza TYPE lcl_pizza.
    ro_pizza = pizza.
  ENDMETHOD.                    "createnewpizza
ENDCLASS.                    "pizzabuilder IMPLEMENTATION
*
* concreate builder - Veggie Pizza
CLASS vegpizzabuilder DEFINITION INHERITING FROM pizzabuilder.
  PUBLIC SECTION.
    METHODS: builddough REDEFINITION,
      buildsauce REDEFINITION,
                   buildtopping REDEFINITION.
ENDCLASS.                    "vegpizzabuilder DEFINITION
*
CLASS vegpizzabuilder IMPLEMENTATION.
  METHOD builddough.
    pizza->dough = 'Thin Crust'.
  ENDMETHOD.                    "builddough
  METHOD buildsauce.
    pizza->sauce = 'Mild'.
  ENDMETHOD.                    "buildsauce
  METHOD buildtopping.
    pizza->topping = 'Olives, Pineapples, Jalapenos'.
  ENDMETHOD.                    "buildtopping
ENDCLASS.                    "vegpizzabuilder IMPLEMENTATION
*
* concrete builder - Cheese Pizza
CLASS cheesepizzabuilder DEFINITION INHERITING FROM pizzabuilder.
  PUBLIC SECTION.
    METHODS: builddough REDEFINITION,
      buildsauce REDEFINITION,
                   buildtopping REDEFINITION.
ENDCLASS.                    "cheesepizzabuilder DEFINITION
*
CLASS cheesepizzabuilder IMPLEMENTATION.
  METHOD builddough.
    pizza->dough = 'Thick Crust'.
  ENDMETHOD.                    "builddough
  METHOD buildsauce.
    pizza->sauce = 'Mild Hot'.
  ENDMETHOD.                    "buildsauce
  METHOD buildtopping.
    pizza->topping = 'Cheese, Cheese, Cheese, more Cheese'.
  ENDMETHOD.                    "buildtopping
ENDCLASS.                    "cheesepizzabuilder IMPLEMENTATION
*
* Director
CLASS cook DEFINITION.
  PUBLIC SECTION.
    METHODS: constructpizza
      IMPORTING io_builder      TYPE REF TO pizzabuilder
      RETURNING VALUE(ro_pizza) TYPE REF TO lif_pizza.
  PRIVATE SECTION.
    DATA: pizzabuilder TYPE REF TO pizzabuilder.
ENDCLASS.                    "cook DEFINITION
*
CLASS cook IMPLEMENTATION.
  METHOD constructpizza.
    pizzabuilder = io_builder.
    ro_pizza = pizzabuilder->createnewpizza( ).
    pizzabuilder->builddough( ).
    pizzabuilder->buildsauce( ).
    pizzabuilder->buildtopping( ).
  ENDMETHOD.                    "constructpizza
ENDCLASS.                    "cook IMPLEMENTATION
*
START-OF-SELECTION.
  DATA: o_cook         TYPE REF TO cook,
        o_pizzabuilder TYPE REF TO pizzabuilder,
        o_pizza        TYPE REF TO lif_pizza.
  CREATE OBJECT o_cook.
*
  "first pizza - Veggie
  CREATE OBJECT o_pizzabuilder TYPE vegpizzabuilder.
  o_pizza = o_cook->constructpizza( o_pizzabuilder ).
  " Just to understand what values are there
  WRITE: / o_pizza->dough, o_pizza->sauce, o_pizza->topping.
*
  "Second pizza - Cheese Lovers
  CREATE OBJECT o_pizzabuilder TYPE cheesepizzabuilder.
  o_pizza = o_cook->constructpizza( o_pizzabuilder ).
  WRITE: / o_pizza->dough, o_pizza->sauce, o_pizza->topping.
