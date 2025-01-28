CLASS zcl_bs_demo_intf_func DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_aco_proxy .

    TYPES:
      _g_000008                      TYPE string ##TYPSHADOW .
    TYPES:
      string_table TYPE STANDARD TABLE OF _g_000008                      WITH DEFAULT KEY ##TYPSHADOW .
    TYPES:
      sysuuid_x16 TYPE x LENGTH 000016 ##TYPSHADOW .
    TYPES:
      BEGIN OF zbs_dmo_perf                  ,
        client           TYPE c LENGTH 000003,
        identifier       TYPE sysuuid_x16,
        item_description TYPE c LENGTH 000040,
        description      TYPE c LENGTH 000150,
        amount           TYPE p LENGTH 15  DECIMALS 000002,
        currency         TYPE c LENGTH 000005,
        blob             TYPE string,
        ndate            TYPE d,
        ntime            TYPE t,
        utc              TYPE int4,
      END OF zbs_dmo_perf                   ##TYPSHADOW .
    TYPES:
      zbs_t_demo_performance         TYPE STANDARD TABLE OF zbs_dmo_perf                   WITH DEFAULT KEY ##TYPSHADOW .

    METHODS constructor
      IMPORTING
        !destination TYPE REF TO if_rfc_dest
      RAISING
        cx_rfc_dest_provider_error .
    METHODS z_bs_demo_get_performance_data
      IMPORTING
        !selection_fields TYPE string_table
        !skip             TYPE i
        !top              TYPE i
      EXPORTING
        !performance_data TYPE zbs_t_demo_performance
      RAISING
        cx_aco_application_exception
        cx_aco_communication_failure
        cx_aco_system_failure .
  PROTECTED SECTION.

    DATA destination TYPE rfcdest .
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_bs_demo_intf_func IMPLEMENTATION.


  METHOD constructor.
    me->destination = destination->get_destination_name( ).
  ENDMETHOD.


  METHOD z_bs_demo_get_performance_data.
    DATA: _rfc_message_ TYPE aco_proxy_msg_type.
    CALL FUNCTION 'Z_BS_DEMO_GET_PERFORMANCE_DATA' DESTINATION me->destination
      EXPORTING
        selection_fields      = selection_fields
        skip                  = skip
        top                   = top
      IMPORTING
        performance_data      = performance_data
      EXCEPTIONS
        communication_failure = 1 MESSAGE _rfc_message_
        system_failure        = 2 MESSAGE _rfc_message_
        OTHERS                = 3.
    IF sy-subrc NE 0.
      DATA __sysubrc TYPE sy-subrc.
      DATA __textid TYPE aco_proxy_textid_type.
      __sysubrc = sy-subrc.
      __textid-msgid = sy-msgid.
      __textid-msgno = sy-msgno.
      __textid-attr1 = sy-msgv1.
      __textid-attr2 = sy-msgv2.
      __textid-attr3 = sy-msgv3.
      __textid-attr4 = sy-msgv4.
      CASE __sysubrc.
        WHEN 1 .
          RAISE EXCEPTION TYPE cx_aco_communication_failure
            EXPORTING
              rfc_msg = _rfc_message_.
        WHEN 2 .
          RAISE EXCEPTION TYPE cx_aco_system_failure
            EXPORTING
              rfc_msg = _rfc_message_.
        WHEN 3 .
          RAISE EXCEPTION TYPE cx_aco_application_exception
            EXPORTING
              exception_id = 'OTHERS'
              textid       = __textid.
      ENDCASE.
    ENDIF.

  ENDMETHOD.
ENDCLASS.
