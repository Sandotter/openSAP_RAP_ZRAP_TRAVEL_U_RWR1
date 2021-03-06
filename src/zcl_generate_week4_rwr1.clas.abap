CLASS zcl_generate_week4_rwr1 DEFINITION
  PUBLIC
  INHERITING FROM cl_xco_cp_adt_simple_classrun
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

  PROTECTED SECTION.
    METHODS main REDEFINITION.



  PRIVATE SECTION.

    METHODS get_json_string RETURNING VALUE(json_string) TYPE string.

    DATA package_name  TYPE sxco_package VALUE  'ZRAP_TRAVEL_U_RWR1'.
    DATA unique_number TYPE string VALUE 'RWR1'.
    DATA dev_system_environment TYPE REF TO if_xco_cp_gen_env_dev_system.
    DATA transport TYPE    sxco_transport .

    TYPES: BEGIN OF t_table_fields,
             field         TYPE sxco_ad_field_name,
             data_element  TYPE sxco_ad_object_name,
             is_key        TYPE abap_bool,
             not_null      TYPE abap_bool,
             currencyCode  TYPE sxco_cds_field_name,
             unitOfMeasure TYPE sxco_cds_field_name,
           END OF t_table_fields.

    ENDCLASS.



CLASS zcl_generate_week4_rwr1 IMPLEMENTATION.

  METHOD main.

  package_name = to_upper( package_name ).

    DATA(lo_package) = xco_cp_abap_repository=>object->devc->for( package_name ).
    DATA(lv_package_software_component) = lo_package->read( )-property-software_component->name.
    DATA(lo_transport_layer) = lo_package->read(  )-property-transport_layer.
    DATA(lo_transport_target) = lo_transport_layer->get_transport_target( ).
    DATA(lv_transport_target) = lo_transport_target->value.
    DATA(lo_transport_request) = xco_cp_cts=>transports->workbench( lo_transport_target->value  )->create_request( | create tables |  ).
    DATA(lv_transport) = lo_transport_request->value.
    transport = lv_transport.
    dev_system_environment = xco_cp_generation=>environment->dev_system( lv_transport ).

    IF NOT lo_package->exists( ).

      RAISE EXCEPTION TYPE zcx_rap_generator
        EXPORTING
          textid   = zcx_rap_generator=>package_does_not_exist
          mv_value = CONV #( package_name ).

    ENDIF.

    DATA(json_string) = get_json_string(  ).

    "create RAP BO

    DATA(xco_api) = NEW zcl_rap_xco_cloud_lib( ).
    "DATA(xco_api) = NEW zcl_rap_xco_on_prem_lib(  ).

    DATA(root_node) = NEW zcl_rap_node(  ).
    root_node->set_is_root_node( ).
    root_node->set_xco_lib( xco_api ).

    DATA(rap_bo_visitor) = NEW zcl_rap_xco_json_visitor( root_node ).
    DATA(json_data) = xco_cp_json=>data->from_string( json_string ).
    json_data->traverse( rap_bo_visitor ).

    DATA(rap_bo_generator) = NEW zcl_rap_bo_generator( root_node ).
    DATA(lt_todos) = rap_bo_generator->generate_bo(  ).


    out->write( | RAP BO { root_node->rap_root_node_objects-behavior_definition_i  } generated successfully | ).



  ENDMETHOD.

  METHOD get_json_string.

    json_string = '{' && |\r\n|  &&
                  '  "implementationType": "unmanaged_semantic",' && |\r\n|  &&
                  '  "namespace": "Z",' && |\r\n|  &&
                  |  "suffix": "_U_{ unique_number }",| && |\r\n|  &&
                  '  "prefix": "RAP_",' && |\r\n|  &&
                  |  "package": "{ package_name }",| && |\r\n|  &&
                  '  "datasourcetype": "table",' && |\r\n|  &&
                  '  "hierarchy": {' && |\r\n|  &&
                  '    "entityName": "Travel",' && |\r\n|  &&
                  '    "dataSource": "/dmo/travel",' && |\r\n|  &&
                  '    "objectId": "travel_id", ' && |\r\n|  &&
                  '    "createdat": "createdat",' && |\r\n|  &&
                  '    "lastchangedat": "lastchangedat",' && |\r\n|  &&
                  '    "createdby": "createdby",' && |\r\n|  &&
                  '    "lastchangedby": "lastchangedby",    ' && |\r\n|  &&
                  '    "valueHelps": [' && |\r\n|  &&
                  '      {' && |\r\n|  &&
                  '        "alias": "Agency",' && |\r\n|  &&
                  '        "name": "/DMO/I_Agency",' && |\r\n|  &&
                  '        "localElement": "AgencyID",' && |\r\n|  &&
                  '        "element": "AgencyID"' && |\r\n|  &&
                  '      },' && |\r\n|  &&
                  '      {' && |\r\n|  &&
                  '        "alias": "Customer",' && |\r\n|  &&
                  '        "name": "/DMO/I_Customer",' && |\r\n|  &&
                  '        "localElement": "CustomerID",' && |\r\n|  &&
                  '        "element": "CustomerID"' && |\r\n|  &&
                  '      },' && |\r\n|  &&
                  '      {' && |\r\n|  &&
                  '        "alias": "Currency",' && |\r\n|  &&
                  '        "name": "I_Currency",' && |\r\n|  &&
                  '        "localElement": "CurrencyCode",' && |\r\n|  &&
                  '        "element": "Currency"' && |\r\n|  &&
                  '      }' && |\r\n|  &&
                  '    ],' && |\r\n|  &&
                  '    "associations": [' && |\r\n|  &&
                  '      {' && |\r\n|  &&
                  '        "name": "_Agency",' && |\r\n|  &&
                  '        "target": "/DMO/I_Agency",' && |\r\n|  &&
                  '        "cardinality": "zero_to_one",' && |\r\n|  &&
                  '        "conditions": [' && |\r\n|  &&
                  '          {' && |\r\n|  &&
                  '            "projectionField": "AgencyID",' && |\r\n|  &&
                  '            "associationField": "AgencyID"' && |\r\n|  &&
                  '          }' && |\r\n|  &&
                  '        ]' && |\r\n|  &&
                  '      },' && |\r\n|  &&
                  '      {' && |\r\n|  &&
                  '        "name": "_Currency",' && |\r\n|  &&
                  '        "target": "I_Currency",' && |\r\n|  &&
                  '        "cardinality": "zero_to_one",' && |\r\n|  &&
                  '        "conditions": [' && |\r\n|  &&
                  '          {' && |\r\n|  &&
                  '            "projectionField": "CurrencyCode",' && |\r\n|  &&
                  '            "associationField": "Currency"' && |\r\n|  &&
                  '          }' && |\r\n|  &&
                  '        ]' && |\r\n|  &&
                  '      },' && |\r\n|  &&
                  '      {' && |\r\n|  &&
                  '        "name": "_Customer",' && |\r\n|  &&
                  '        "target": "/DMO/I_Customer",' && |\r\n|  &&
                  '        "cardinality": "zero_to_one",' && |\r\n|  &&
                  '        "conditions": [' && |\r\n|  &&
                  '          {' && |\r\n|  &&
                  '            "projectionField": "CustomerID",' && |\r\n|  &&
                  '            "associationField": "CustomerID"' && |\r\n|  &&
                  '          }' && |\r\n|  &&
                  '        ]' && |\r\n|  &&
                  '      }' && |\r\n|  &&
                  '    ],' && |\r\n|  &&
                  '    "children": [' && |\r\n|  &&
                  '      {' && |\r\n|  &&
                  '        "entityName": "Booking",' && |\r\n|  &&
                  '        "dataSource": "/dmo/booking",' && |\r\n|  &&
                  '        "objectId": "booking_id",' && |\r\n|  &&
                  '        "valueHelps": [' && |\r\n|  &&
                  '          {' && |\r\n|  &&
                  '            "alias": "Flight",' && |\r\n|  &&
                  '            "name": "/DMO/I_Flight",' && |\r\n|  &&
                  '            "localElement": "ConnectionID",' && |\r\n|  &&
                  '            "element": "ConnectionID",' && |\r\n|  &&
                  '            "additionalBinding": [' && |\r\n|  &&
                  '              {' && |\r\n|  &&
                  '                "localElement": "FlightDate",' && |\r\n|  &&
                  '                "element": "FlightDate"' && |\r\n|  &&
                  '              },' && |\r\n|  &&
                  '              {' && |\r\n|  &&
                  '                "localElement": "CarrierID",' && |\r\n|  &&
                  '                "element": "AirlineID"' && |\r\n|  &&
                  '              },' && |\r\n|  &&
                  '              {' && |\r\n|  &&
                  '                "localElement": "FlightPrice",' && |\r\n|  &&
                  '                "element": "Price"' && |\r\n|  &&
                  '              },' && |\r\n|  &&
                  '              {' && |\r\n|  &&
                  '                "localElement": "CurrencyCode",' && |\r\n|  &&
                  '                "element": "CurrencyCode"' && |\r\n|  &&
                  '              }' && |\r\n|  &&
                  '            ]' && |\r\n|  &&
                  '          },' && |\r\n|  &&
                  '          {' && |\r\n|  &&
                  '            "alias": "Currency",' && |\r\n|  &&
                  '            "name": "I_Currency",' && |\r\n|  &&
                  '            "localElement": "CurrencyCode",' && |\r\n|  &&
                  '            "element": "Currency"' && |\r\n|  &&
                  '          },' && |\r\n|  &&
                  '          {' && |\r\n|  &&
                  '            "alias": "Airline",' && |\r\n|  &&
                  '            "name": "/DMO/I_Carrier",' && |\r\n|  &&
                  '            "localElement": "CarrierID",' && |\r\n|  &&
                  '            "element": "AirlineID"' && |\r\n|  &&
                  '          },' && |\r\n|  &&
                  '          {' && |\r\n|  &&
                  '            "alias": "Customer",' && |\r\n|  &&
                  '            "name": "/DMO/I_Customer",' && |\r\n|  &&
                  '            "localElement": "CustomerID",' && |\r\n|  &&
                  '            "element": "CustomerID"' && |\r\n|  &&
                  '          }' && |\r\n|  &&
                  '        ],' && |\r\n|  &&
                  '        "associations": [' && |\r\n|  &&
                  '          {' && |\r\n|  &&
                  '            "name": "_Connection",' && |\r\n|  &&
                  '            "target": "/DMO/I_Connection",' && |\r\n|  &&
                  '            "cardinality": "one_to_one",' && |\r\n|  &&
                  '            "conditions": [' && |\r\n|  &&
                  '              {' && |\r\n|  &&
                  '                "projectionField": "CarrierID",' && |\r\n|  &&
                  '                "associationField": "AirlineID"' && |\r\n|  &&
                  '              },' && |\r\n|  &&
                  '              {' && |\r\n|  &&
                  '                "projectionField": "ConnectionID",' && |\r\n|  &&
                  '                "associationField": "ConnectionID"' && |\r\n|  &&
                  '              }' && |\r\n|  &&
                  '            ]' && |\r\n|  &&
                  '          },' && |\r\n|  &&
                  '          {' && |\r\n|  &&
                  '            "name": "_Flight",' && |\r\n|  &&
                  '            "target": "/DMO/I_Flight",' && |\r\n|  &&
                  '            "cardinality": "one_to_one",' && |\r\n|  &&
                  '            "conditions": [' && |\r\n|  &&
                  '              {' && |\r\n|  &&
                  '                "projectionField": "CarrierID",' && |\r\n|  &&
                  '                "associationField": "AirlineID"' && |\r\n|  &&
                  '              },' && |\r\n|  &&
                  '              {' && |\r\n|  &&
                  '                "projectionField": "ConnectionID",' && |\r\n|  &&
                  '                "associationField": "ConnectionID"' && |\r\n|  &&
                  '              },' && |\r\n|  &&
                  '              {' && |\r\n|  &&
                  '                "projectionField": "FlightDate",' && |\r\n|  &&
                  '                "associationField": "FlightDate"' && |\r\n|  &&
                  '              }' && |\r\n|  &&
                  '            ]' && |\r\n|  &&
                  '          },' && |\r\n|  &&
                  '          {' && |\r\n|  &&
                  '            "name": "_Carrier",' && |\r\n|  &&
                  '            "target": "/DMO/I_Carrier",' && |\r\n|  &&
                  '            "cardinality": "one_to_one",' && |\r\n|  &&
                  '            "conditions": [' && |\r\n|  &&
                  '              {' && |\r\n|  &&
                  '                "projectionField": "CarrierID",' && |\r\n|  &&
                  '                "associationField": "AirlineID"' && |\r\n|  &&
                  '              }' && |\r\n|  &&
                  '            ]' && |\r\n|  &&
                  '          },' && |\r\n|  &&
                  '          {' && |\r\n|  &&
                  '            "name": "_Currency",' && |\r\n|  &&
                  '            "target": "I_Currency",' && |\r\n|  &&
                  '            "cardinality": "zero_to_one",' && |\r\n|  &&
                  '            "conditions": [' && |\r\n|  &&
                  '              {' && |\r\n|  &&
                  '                "projectionField": "CurrencyCode",' && |\r\n|  &&
                  '                "associationField": "Currency"' && |\r\n|  &&
                  '              }' && |\r\n|  &&
                  '            ]' && |\r\n|  &&
                  '          },' && |\r\n|  &&
                  '          {' && |\r\n|  &&
                  '            "name": "_Customer",' && |\r\n|  &&
                  '            "target": "/DMO/I_Customer",' && |\r\n|  &&
                  '            "cardinality": "one_to_one",' && |\r\n|  &&
                  '            "conditions": [' && |\r\n|  &&
                  '              {' && |\r\n|  &&
                  '                "projectionField": "CustomerID",' && |\r\n|  &&
                  '                "associationField": "CustomerID"' && |\r\n|  &&
                  '              }' && |\r\n|  &&
                  '            ]' && |\r\n|  &&
                  '          }' && |\r\n|  &&
                  '        ]' && |\r\n|  &&
                  '      }' && |\r\n|  &&
                  '    ]' && |\r\n|  &&
                  '  }' && |\r\n|  &&
                  '}'.


  ENDMETHOD.

ENDCLASS.

