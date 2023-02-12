*&---------------------------------------------------------------------*
*& Include zspfli_report_cls
*&---------------------------------------------------------------------*

CLASS lcl_event_alv_grid DEFINITION.

  PUBLIC SECTION.
    METHODS: handle_toolbar FOR EVENT toolbar OF cl_gui_alv_grid IMPORTING e_interactive e_object,
      handle_usercomand FOR EVENT user_command OF cl_gui_alv_grid IMPORTING e_ucomm sender.
ENDCLASS.

CLASS lcl_event_alv_grid IMPLEMENTATION.

  METHOD handle_toolbar.
    DATA: ls_toolbar TYPE stb_button.


    ls_toolbar-text     = 'Bookings'.
    ls_toolbar-function = 'S_BOOKINGS'.
    ls_toolbar-icon     = '@13@'.

    APPEND ls_toolbar TO e_object->mt_toolbar.

  ENDMETHOD.

  METHOD handle_usercomand.


    CASE e_ucomm.
      WHEN 'S_BOOKINGS'.
        PERFORM get_sbook.
      WHEN OTHERS.
    ENDCASE.
  ENDMETHOD.

ENDCLASS.
