"! <p class="shorttext synchronized">Consumption model for client proxy - generated</p>
"! This class has been generated based on the metadata with namespace
"! <em>cds_zbs_demo_perfromance_data</em>
CLASS zcl_bs_demo_intf_o2 DEFINITION
  PUBLIC
  INHERITING FROM /iwbep/cl_v4_abs_pm_model_prov
  CREATE PUBLIC.

  PUBLIC SECTION.

    TYPES:
      "! <p class="shorttext synchronized">PerfromanceType</p>
      BEGIN OF tys_perfromance_type,
        "! <em>Key property</em> Identifier
        identifier         TYPE sysuuid_x16,
        "! ItemDescription
        item_description   TYPE c LENGTH 40,
        "! RandomDescription
        random_description TYPE c LENGTH 150,
        "! Amount
        amount             TYPE p LENGTH 8 DECIMALS 3,
        "! Currency
        currency           TYPE c LENGTH 5,
        "! BlobObject
        blob_object        TYPE string,
        "! NewDate
        new_date           TYPE datn,
        "! NewTime
        new_time           TYPE timn,
        "! UTCTimestamp
        utctimestamp       TYPE timestampl,
      END OF tys_perfromance_type,
      "! <p class="shorttext synchronized">List of PerfromanceType</p>
      tyt_perfromance_type TYPE STANDARD TABLE OF tys_perfromance_type WITH DEFAULT KEY.


    CONSTANTS:
      "! <p class="shorttext synchronized">Internal Names of the entity sets</p>
      BEGIN OF gcs_entity_set,
        "! Perfromance
        "! <br/> Collection of type 'PerfromanceType'
        perfromance TYPE /iwbep/if_cp_runtime_types=>ty_entity_set_name VALUE 'PERFROMANCE',
      END OF gcs_entity_set .

    CONSTANTS:
      "! <p class="shorttext synchronized">Internal names for entity types</p>
      BEGIN OF gcs_entity_type,
        "! <p class="shorttext synchronized">Internal names for PerfromanceType</p>
        "! See also structure type {@link ..tys_perfromance_type}
        BEGIN OF perfromance_type,
          "! <p class="shorttext synchronized">Navigation properties</p>
          BEGIN OF navigation,
            "! Dummy field - Structure must not be empty
            dummy TYPE int1 VALUE 0,
          END OF navigation,
        END OF perfromance_type,
      END OF gcs_entity_type.


    METHODS /iwbep/if_v4_mp_basic_pm~define REDEFINITION.


  PRIVATE SECTION.

    "! <p class="shorttext synchronized">Model</p>
    DATA mo_model TYPE REF TO /iwbep/if_v4_pm_model.


    "! <p class="shorttext synchronized">Define PerfromanceType</p>
    "! @raising /iwbep/cx_gateway | <p class="shorttext synchronized">Gateway Exception</p>
    METHODS def_perfromance_type RAISING /iwbep/cx_gateway.

ENDCLASS.


CLASS zcl_bs_demo_intf_o2 IMPLEMENTATION.

  METHOD /iwbep/if_v4_mp_basic_pm~define.

    mo_model = io_model.
    mo_model->set_schema_namespace( 'cds_zbs_demo_perfromance_data' ) ##NO_TEXT.

    def_perfromance_type( ).

  ENDMETHOD.


  METHOD def_perfromance_type.

    DATA:
      lo_complex_property    TYPE REF TO /iwbep/if_v4_pm_cplx_prop,
      lo_entity_type         TYPE REF TO /iwbep/if_v4_pm_entity_type,
      lo_entity_set          TYPE REF TO /iwbep/if_v4_pm_entity_set,
      lo_navigation_property TYPE REF TO /iwbep/if_v4_pm_nav_prop,
      lo_primitive_property  TYPE REF TO /iwbep/if_v4_pm_prim_prop.


    lo_entity_type = mo_model->create_entity_type_by_struct(
                                    iv_entity_type_name       = 'PERFROMANCE_TYPE'
                                    is_structure              = VALUE tys_perfromance_type( )
                                    iv_do_gen_prim_props         = abap_true
                                    iv_do_gen_prim_prop_colls    = abap_true
                                    iv_do_add_conv_to_prim_props = abap_true ).

    lo_entity_type->set_edm_name( 'PerfromanceType' ) ##NO_TEXT.


    lo_entity_set = lo_entity_type->create_entity_set( 'PERFROMANCE' ).
    lo_entity_set->set_edm_name( 'Perfromance' ) ##NO_TEXT.


    lo_primitive_property = lo_entity_type->get_primitive_property( 'IDENTIFIER' ).
    lo_primitive_property->set_edm_name( 'Identifier' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'Guid' ) ##NO_TEXT.
    lo_primitive_property->set_is_key( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'ITEM_DESCRIPTION' ).
    lo_primitive_property->set_edm_name( 'ItemDescription' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 40 ) ##NUMBER_OK.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'RANDOM_DESCRIPTION' ).
    lo_primitive_property->set_edm_name( 'RandomDescription' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 150 ) ##NUMBER_OK.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'AMOUNT' ).
    lo_primitive_property->set_edm_name( 'Amount' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'Decimal' ) ##NO_TEXT.
    lo_primitive_property->set_precision( 15 ) ##NUMBER_OK.
    lo_primitive_property->set_scale( 3 ) ##NUMBER_OK.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'CURRENCY' ).
    lo_primitive_property->set_edm_name( 'Currency' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 5 ) ##NUMBER_OK.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'BLOB_OBJECT' ).
    lo_primitive_property->set_edm_name( 'BlobObject' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'NEW_DATE' ).
    lo_primitive_property->set_edm_name( 'NewDate' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'Date' ) ##NO_TEXT.
    lo_primitive_property->set_is_nullable( ).
    lo_primitive_property->set_edm_type_v2( 'DateTime' ) ##NO_TEXT.

    lo_primitive_property = lo_entity_type->get_primitive_property( 'NEW_TIME' ).
    lo_primitive_property->set_edm_name( 'NewTime' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'TimeOfDay' ) ##NO_TEXT.
    lo_primitive_property->set_is_nullable( ).
    lo_primitive_property->set_edm_type_v2( 'Time' ) ##NO_TEXT.

    lo_primitive_property = lo_entity_type->get_primitive_property( 'UTCTIMESTAMP' ).
    lo_primitive_property->set_edm_name( 'UTCTimestamp' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'DateTimeOffset' ) ##NO_TEXT.
    lo_primitive_property->set_precision( 7 ) ##NUMBER_OK.
    lo_primitive_property->set_is_nullable( ).

  ENDMETHOD.


ENDCLASS.
