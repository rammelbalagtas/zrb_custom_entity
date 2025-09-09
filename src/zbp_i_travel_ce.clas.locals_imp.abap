CLASS lcl_data_buffer DEFINITION.
  PUBLIC SECTION.
    CLASS-DATA updates TYPE TABLE FOR UPDATE zi_travel_ce\\Travel.
    CLASS-DATA reset   TYPE abap_boolean.
ENDCLASS.

CLASS lhc_ZI_TRAVEL_CE DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR Travel RESULT result.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR Travel RESULT result.

    METHODS create FOR MODIFY
      IMPORTING entities FOR CREATE Travel.

    METHODS update FOR MODIFY
      IMPORTING entities FOR UPDATE Travel.

    METHODS delete FOR MODIFY
      IMPORTING keys FOR DELETE Travel.

    METHODS read FOR READ
      IMPORTING keys FOR READ Travel RESULT result.

    METHODS lock FOR LOCK
      IMPORTING keys FOR LOCK Travel.

    METHODS approveAll FOR MODIFY
      IMPORTING keys FOR ACTION Travel~approveAll.

    METHODS approveTravel FOR MODIFY
      IMPORTING keys FOR ACTION Travel~approveTravel RESULT result.
    METHODS resetAll FOR MODIFY
      IMPORTING keys FOR ACTION Travel~resetAll.
    METHODS resetSelected FOR MODIFY
      IMPORTING keys FOR ACTION Travel~resetSelected RESULT result.

ENDCLASS.

CLASS lhc_ZI_TRAVEL_CE IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD get_global_authorizations.
  ENDMETHOD.

  METHOD create.
  ENDMETHOD.

  METHOD update.
    INSERT LINES OF entities INTO TABLE lcl_data_buffer=>updates.
  ENDMETHOD.

  METHOD delete.
  ENDMETHOD.

  METHOD read.
    DATA lr_travel_id TYPE RANGE OF zi_travel_ce-travel_id.
    LOOP AT keys INTO DATA(ls_key).
      APPEND INITIAL LINE TO lr_travel_id ASSIGNING FIELD-SYMBOL(<fs_travel_id>).
      <fs_travel_id>-sign = 'I'.
      <fs_travel_id>-option = 'EQ'.
      <fs_travel_id>-low = ls_key-travel_id.
    ENDLOOP.

    CHECK lr_travel_ID IS NOT INITIAL.

    DATA lt_travel  TYPE TABLE FOR READ RESULT zi_travel_ce\\travel.
    SELECT a~*, b~approved
     FROM /dmo/travel AS a
     LEFT OUTER JOIN zce_travel_db AS b
     ON ( b~travel_id = a~travel_id )
     WHERE a~travel_id IN @lr_travel_id
     INTO CORRESPONDING FIELDS OF TABLE @lt_travel.

    MOVE-CORRESPONDING lt_travel TO result.

  ENDMETHOD.

  METHOD lock.
  ENDMETHOD.

  METHOD approveAll.
    DATA lr_travel_id TYPE RANGE OF zi_travel_ce-travel_id.
    READ TABLE keys INTO DATA(ls_key) INDEX 1.
    IF sy-subrc EQ 0.
      LOOP AT ls_key-%param-_travel INTO DATA(travel).
        APPEND INITIAL LINE TO lr_travel_id ASSIGNING FIELD-SYMBOL(<fs_travel_id>).
        <fs_travel_id>-sign = 'I'.
        <fs_travel_id>-option = 'EQ'.
        <fs_travel_id>-low = travel-travel_id_low.
      ENDLOOP.

      DATA lt_travel  TYPE TABLE FOR READ RESULT zi_travel_ce\\travel.
      SELECT a~*, b~approved
       FROM /dmo/travel AS a
       LEFT OUTER JOIN zce_travel_db AS b
       ON ( b~travel_id = a~travel_id )
       WHERE a~travel_id IN @lr_travel_id
       INTO CORRESPONDING FIELDS OF TABLE @lt_travel.

      LOOP AT lt_travel INTO DATA(ls_travel).
        MODIFY ENTITIES OF zi_travel_ce IN LOCAL MODE
               ENTITY Travel
               UPDATE FROM VALUE #( ( travel_id         = ls_travel-travel_id
                                      approved          = 'X'
                                      %control-approved = if_abap_behv=>mk-on ) ).
      ENDLOOP.

    ENDIF.
  ENDMETHOD.

  METHOD approveTravel.
    READ ENTITIES OF zi_travel_ce IN LOCAL MODE
       ENTITY Travel
       FROM CORRESPONDING #( keys )
       RESULT DATA(lt_result).

    LOOP AT lt_result INTO DATA(ls_result).
      MODIFY ENTITIES OF zi_travel_ce IN LOCAL MODE
             ENTITY Travel
             UPDATE FROM VALUE #( ( travel_id         = ls_result-travel_id
                                    approved          = 'X'
                                    %control-approved = if_abap_behv=>mk-on ) ).

      INSERT VALUE #( travel_id = ls_result-travel_id
                      %param    = ls_result ) INTO TABLE result.
    ENDLOOP.

  ENDMETHOD.

  METHOD resetAll.
    DATA lr_travel_id TYPE RANGE OF zi_travel_ce-travel_id.
    READ TABLE keys INTO DATA(ls_key) INDEX 1.
    IF sy-subrc EQ 0.
      LOOP AT ls_key-%param-_travel INTO DATA(travel).
        APPEND INITIAL LINE TO lr_travel_id ASSIGNING FIELD-SYMBOL(<fs_travel_id>).
        <fs_travel_id>-sign = 'I'.
        <fs_travel_id>-option = 'EQ'.
        <fs_travel_id>-low = travel-travel_id_low.
      ENDLOOP.

      DATA lt_travel  TYPE TABLE FOR READ RESULT zi_travel_ce\\travel.
      SELECT a~*, b~approved
       FROM /dmo/travel AS a
       LEFT OUTER JOIN zce_travel_db AS b
       ON ( b~travel_id = a~travel_id )
       WHERE a~travel_id IN @lr_travel_id
       INTO CORRESPONDING FIELDS OF TABLE @lt_travel.

      LOOP AT lt_travel INTO DATA(ls_travel).
        MODIFY ENTITIES OF zi_travel_ce IN LOCAL MODE
               ENTITY Travel
               UPDATE FROM VALUE #( ( travel_id         = ls_travel-travel_id
                                      approved          = ''
                                      %control-approved = if_abap_behv=>mk-on ) ).
      ENDLOOP.

    ENDIF.
  ENDMETHOD.

  METHOD resetSelected.
    READ ENTITIES OF zi_travel_ce IN LOCAL MODE
     ENTITY Travel
     FROM CORRESPONDING #( keys )
     RESULT DATA(lt_result).

    LOOP AT lt_result INTO DATA(ls_result).
      MODIFY ENTITIES OF zi_travel_ce IN LOCAL MODE
             ENTITY Travel
             UPDATE FROM VALUE #( ( travel_id         = ls_result-travel_id
                                    approved          = ''
                                    %control-approved = if_abap_behv=>mk-on ) ).

      INSERT VALUE #( travel_id = ls_result-travel_id
                      %param    = ls_result ) INTO TABLE result.
    ENDLOOP.
  ENDMETHOD.

ENDCLASS.

CLASS lsc_ZI_TRAVEL_CE DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS finalize REDEFINITION.

    METHODS check_before_save REDEFINITION.

    METHODS save REDEFINITION.

    METHODS cleanup REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_ZI_TRAVEL_CE IMPLEMENTATION.

  METHOD finalize.
    IF 1 = 1.
    ENDIF.
  ENDMETHOD.

  METHOD check_before_save.
  ENDMETHOD.

  METHOD save.
    LOOP AT lcl_data_buffer=>updates INTO DATA(update).
      IF update-approved = 'X'.
        INSERT zce_travel_db FROM @( VALUE #( travel_id = update-travel_id
                                               approved = 'X' ) ).
      ELSE.
        DELETE zce_travel_db FROM @( VALUE #( travel_id = update-travel_id ) ).
      ENDIF.
    ENDLOOP.

  ENDMETHOD.

  METHOD cleanup.
  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.
