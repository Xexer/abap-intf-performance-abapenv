CLASS zcl_bs_demo_http_performance DEFINITION
  PUBLIC
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_http_service_extension.

  PROTECTED SECTION.

  PRIVATE SECTION.
ENDCLASS.


CLASS zcl_bs_demo_http_performance IMPLEMENTATION.
  METHOD if_http_service_extension~handle_request.
    DATA(performance) = NEW zcl_bs_demo_intf_performance( ).
    response->set_text( performance->main_extern( ) ).
  ENDMETHOD.
ENDCLASS.
