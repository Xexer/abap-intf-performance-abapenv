CLASS zcl_bs_demo_intf_performance DEFINITION
  PUBLIC FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.

    METHODS main_extern
      RETURNING VALUE(result) TYPE string.

  PRIVATE SECTION.
    TYPES: BEGIN OF request_data,
             fields TYPE string_table,
             top    TYPE i,
             skip   TYPE i,
           END OF request_data.

    TYPES: BEGIN OF http_line,
             Identifier        TYPE string,
             ItemDescription   TYPE c LENGTH 150,
             RandomDescription TYPE string,
             Amount            TYPE p LENGTH 15 DECIMALS 2,
             Currency          TYPE string,
             BlobObject        TYPE string,
             NewDate           TYPE d,
             NewTime           TYPE t,
           END OF http_line.

    TYPES http_lines TYPE STANDARD TABLE OF http_line WITH EMPTY KEY.

    TYPES: BEGIN OF json_payload,
             value TYPE http_lines,
           END OF json_payload.

    TYPES: BEGIN OF result,
             subrc         TYPE i,
             error_message TYPE string,
             data_rfc      TYPE zcl_bs_demo_intf_func=>zbs_t_demo_performance,
             data_o2       TYPE zcl_bs_demo_intf_o2=>tyt_perfromance_type,
             data_o4       TYPE zcl_bs_demo_intf_o4=>tyt_perfromance_type,
             http_payload  TYPE http_lines,
           END OF result.

    CONSTANTS: BEGIN OF destinations,
                 http TYPE string VALUE ``,
                 rfc  TYPE string VALUE ``,
               END OF destinations.

    DATA output_to_show TYPE string.

    METHODS out
      IMPORTING content TYPE string.

    METHODS iterate_configuration
      IMPORTING configuration TYPE zcl_bs_demo_intf_performance=>request_data
                iterate       TYPE abap_bool
      RETURNING VALUE(result) TYPE zcl_bs_demo_intf_performance=>request_data.

    METHODS execute_scenario
      IMPORTING !description  TYPE string
                excute_times  TYPE i
                iterate       TYPE abap_bool
                configuration TYPE request_data.

    METHODS convert_configuration_to_rfc
      IMPORTING request_data  TYPE request_data
      RETURNING VALUE(result) TYPE request_data.

    METHODS convert_configuration_to_http
      IMPORTING request_data  TYPE request_data
      RETURNING VALUE(result) TYPE request_data.

    METHODS read_rfc
      IMPORTING request_data  TYPE request_data
      RETURNING VALUE(result) TYPE result.

    METHODS read_odata_v2
      IMPORTING request_data  TYPE request_data
      RETURNING VALUE(result) TYPE result.

    METHODS read_odata_v4
      IMPORTING request_data  TYPE request_data
      RETURNING VALUE(result) TYPE result.

    METHODS read_plain_http
      IMPORTING request_data  TYPE request_data
      RETURNING VALUE(result) TYPE result.
ENDCLASS.


CLASS zcl_bs_demo_intf_performance IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.
    main_extern( ).
    out->write( output_to_show ).
  ENDMETHOD.


  METHOD main_extern.
    DATA(all_fields) = VALUE string_table( ( `IDENTIFIER` )
                                           ( `ITEM_DESCRIPTION` )
                                           ( `RANDOM_DESCRIPTION` )
                                           ( `AMOUNT` )
                                           ( `CURRENCY` )
                                           ( `BLOB_OBJECT` )
                                           ( `NEW_DATE` )
                                           ( `NEW_TIME` ) ).

    DATA(no_blob_fields) = VALUE string_table( ( `IDENTIFIER` )
                                               ( `ITEM_DESCRIPTION` )
                                               ( `AMOUNT` )
                                               ( `CURRENCY` )
                                               ( `NEW_DATE` )
                                               ( `NEW_TIME` ) ).

    DATA(vh_fields) = VALUE string_table( ( `IDENTIFIER` )
                                          ( `ITEM_DESCRIPTION` ) ).

    execute_scenario( description   = `1) All fields, 100 entries`
                      excute_times  = 1
                      iterate       = abap_false
                      configuration = VALUE #( fields = all_fields
                                               skip   = 0
                                               top    = 100 ) ).

    execute_scenario( description   = `2) All fields, 5000 entries`
                      excute_times  = 1
                      iterate       = abap_false
                      configuration = VALUE #( fields = all_fields
                                               skip   = 0
                                               top    = 5000 ) ).

    execute_scenario( description   = `3) No BLOB, 5000 entries`
                      excute_times  = 1
                      iterate       = abap_false
                      configuration = VALUE #( fields = no_blob_fields
                                               skip   = 0
                                               top    = 5000 ) ).

    execute_scenario( description   = `4) No BLOB, Many executions, 200 entries`
                      excute_times  = 50
                      iterate       = abap_false
                      configuration = VALUE #( fields = no_blob_fields
                                               skip   = 0
                                               top    = 200 ) ).

    execute_scenario( description   = `5) No BLOB, Many executions, Iterate`
                      excute_times  = 50
                      iterate       = abap_true
                      configuration = VALUE #( fields = no_blob_fields
                                               skip   = 0
                                               top    = 200 ) ).

    execute_scenario( description   = `6) Value Help, 500 entries`
                      excute_times  = 1
                      iterate       = abap_false
                      configuration = VALUE #( fields = vh_fields
                                               skip   = 500
                                               top    = 500 ) ).

    execute_scenario( description   = `7) Value Help, Many executions`
                      excute_times  = 75
                      iterate       = abap_false
                      configuration = VALUE #( fields = vh_fields
                                               skip   = 0
                                               top    = 20 ) ).

    execute_scenario( description   = `8) Value Help, Many executions, Iterate`
                      excute_times  = 75
                      iterate       = abap_true
                      configuration = VALUE #( fields = vh_fields
                                               skip   = 0
                                               top    = 20 ) ).

    result = output_to_show.
  ENDMETHOD.


  METHOD execute_scenario.
    out( `` ).
    out( description ).

    DATA(rfc_configuration) = convert_configuration_to_rfc( configuration  ).
    DATA(ov2_configuration) = configuration.
    DATA(ov4_configuration) = configuration.
    DATA(http_configuration) = convert_configuration_to_http( configuration  ).

    DATA(lo_run) = NEW zcl_bs_demo_runtime( ).
    DO excute_times TIMES.
      rfc_configuration = iterate_configuration( configuration = rfc_configuration
                                                 iterate       = iterate ).
      read_rfc( rfc_configuration ).
    ENDDO.
    out( |RFC     : { lo_run->get_diff( ) }| ).

    lo_run = NEW zcl_bs_demo_runtime( ).
    DO excute_times TIMES.
      ov2_configuration = iterate_configuration( configuration = ov2_configuration
                                                 iterate       = iterate ).
      read_odata_v2( ov2_configuration ).
    ENDDO.
    out( |OData v2: { lo_run->get_diff( ) }| ).

    lo_run = NEW zcl_bs_demo_runtime( ).
    DO excute_times TIMES.
      ov4_configuration = iterate_configuration( configuration = ov4_configuration
                                                 iterate       = iterate ).
      read_odata_v4( ov4_configuration ).
    ENDDO.
    out( |OData v4: { lo_run->get_diff( ) }| ).

    lo_run = NEW zcl_bs_demo_runtime( ).
    DO excute_times TIMES.
      http_configuration = iterate_configuration( configuration = http_configuration
                                                  iterate       = iterate ).
      read_plain_http( http_configuration ).
    ENDDO.
    out( |P-HTTP  : { lo_run->get_diff( ) }| ).
  ENDMETHOD.


  METHOD read_rfc.
    TRY.
        DATA(destination) = cl_rfc_destination_provider=>create_by_cloud_destination( destinations-rfc ).

        DATA(consumption_model) = NEW zcl_bs_demo_intf_func( destination = destination ).

        consumption_model->z_bs_demo_get_performance_data( EXPORTING selection_fields = request_data-fields
                                                                     skip             = request_data-skip
                                                                     top              = request_data-top
                                                           IMPORTING performance_data = result-data_rfc ).
      CATCH cx_root INTO DATA(rfc_error).
        result-error_message = rfc_error->get_text( ).
    ENDTRY.
  ENDMETHOD.


  METHOD read_odata_v2.
    TRY.
        DATA(destination) = cl_http_destination_provider=>create_by_cloud_destination( destinations-http ).
        DATA(http_client) = cl_web_http_client_manager=>create_by_http_destination( destination ).

        DATA(client_proxy) = /iwbep/cl_cp_factory_remote=>create_v2_remote_proxy(
            is_proxy_model_key       = VALUE #( repository_id       = 'DEFAULT'
                                                proxy_model_id      = 'ZBS_DEMO_INTF_O2'
                                                proxy_model_version = '0001' )
            io_http_client           = http_client
            iv_relative_service_root = '/sap/opu/odata/sap/ZBS_API_PERFROMANCE_O2/' ).

        DATA(request) = client_proxy->create_resource_for_entity_set( 'PERFROMANCE' )->create_request_for_read( ).
        request->set_top( request_data-top )->set_skip( request_data-skip ).
        request->set_select_properties( request_data-fields ).

        DATA(response) = request->execute( ).
        response->get_business_data( IMPORTING et_business_data = result-data_o2 ).

      CATCH cx_root INTO DATA(odata_error).
        result-error_message = odata_error->get_text( ).
    ENDTRY.
  ENDMETHOD.


  METHOD read_odata_v4.
    TRY.
        DATA(destination) = cl_http_destination_provider=>create_by_cloud_destination( destinations-http ).
        DATA(http_client) = cl_web_http_client_manager=>create_by_http_destination( destination ).

        DATA(client_proxy) = /iwbep/cl_cp_factory_remote=>create_v4_remote_proxy(
            is_proxy_model_key       = VALUE #( repository_id       = 'DEFAULT'
                                                proxy_model_id      = 'ZBS_DEMO_INTF_O4'
                                                proxy_model_version = '0001' )
            io_http_client           = http_client
            iv_relative_service_root = '/sap/opu/odata4/sap/zbs_api_perfromance_o4/srvd_a2x/sap/zbs_demo_perfromance_data/0001/' ).

        DATA(request) = client_proxy->create_resource_for_entity_set( 'PERFROMANCE' )->create_request_for_read( ).
        request->set_top( request_data-top )->set_skip( request_data-skip ).
        request->set_select_properties( request_data-fields ).

        DATA(response) = request->execute( ).
        response->get_business_data( IMPORTING et_business_data = result-data_o4 ).

      CATCH cx_root INTO DATA(odata_error).
        result-error_message = odata_error->get_text( ).
    ENDTRY.
  ENDMETHOD.


  METHOD read_plain_http.
    DATA json_payload TYPE json_payload.

    TRY.
        DATA(destination) = cl_http_destination_provider=>create_by_cloud_destination( destinations-http ).
        DATA(http_client) = cl_web_http_client_manager=>create_by_http_destination( destination ).

        DATA(fields_for_select) = ``.
        LOOP AT request_data-fields REFERENCE INTO DATA(field_name).
          IF fields_for_select <> ``.
            fields_for_select &&= `,`.
          ENDIF.
          fields_for_select &&= field_name->*.
        ENDLOOP.

        DATA(uri) = `/sap/opu/odata4/sap/zbs_api_perfromance_o4/srvd_a2x/sap/zbs_demo_perfromance_data/0001/Perfromance?`.
        uri &&= |$select={ fields_for_select }&$top={ request_data-top }&$skip={ request_data-skip }|.

        DATA(request) = http_client->get_http_request( ).
        request->set_uri_path( i_uri_path = uri ).

        DATA(response) = http_client->execute( if_web_http_client=>get ).
        DATA(status) = response->get_status( ).

        IF status-code = 200.
          /ui2/cl_json=>deserialize( EXPORTING json = response->get_text( )
                                     CHANGING  data = json_payload ).

          result-http_payload = json_payload-value.
        ENDIF.

      CATCH cx_root INTO DATA(odata_error).
        result-error_message = odata_error->get_text( ).
    ENDTRY.
  ENDMETHOD.


  METHOD out.
*    output_to_show &&= cl_abap_char_utilities=>cr_lf && content.
    output_to_show &&= |<br>{ content }|.
  ENDMETHOD.


  METHOD convert_configuration_to_rfc.
    result = request_data.

    LOOP AT result-fields REFERENCE INTO DATA(field).
      field->* = SWITCH #( field->*
                           WHEN 'RANDOM_DESCRIPTION' THEN 'DESCRIPTION'
                           WHEN 'NEW_DATE'           THEN 'NDATE'
                           WHEN 'NEW_TIME'           THEN 'NTIME'
                           WHEN 'UTCTIMESTAMP'       THEN 'UTC'
                           ELSE                           field->* ).
    ENDLOOP.
  ENDMETHOD.


  METHOD convert_configuration_to_http.
    result = request_data.

    LOOP AT result-fields REFERENCE INTO DATA(field).
      field->* = SWITCH #( field->*
                           WHEN 'IDENTIFIER'         THEN 'Identifier'
                           WHEN 'ITEM_DESCRIPTION'   THEN 'ItemDescription'
                           WHEN 'RANDOM_DESCRIPTION' THEN 'RandomDescription'
                           WHEN 'AMOUNT'             THEN 'Amount'
                           WHEN 'CURRENCY'           THEN 'Currency'
                           WHEN 'BLOB_OBJECT'        THEN 'BlobObject'
                           WHEN 'NEW_DATE'           THEN 'NewDate'
                           WHEN 'NEW_TIME'           THEN 'NewTime'
                           WHEN 'UTCTIMESTAMP'       THEN 'UTCTimestamp'
                           ELSE                           field->* ).
    ENDLOOP.
  ENDMETHOD.


  METHOD iterate_configuration.
    result = configuration.

    IF iterate = abap_true.
      result-skip += result-top.
    ENDIF.
  ENDMETHOD.
ENDCLASS.
