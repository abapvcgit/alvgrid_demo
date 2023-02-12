*&---------------------------------------------------------------------*
*& Include zspfli_report_f01
*&---------------------------------------------------------------------*


*&---------------------------------------------------------------------*
*& Form report_init
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM report_spfli_init .

  DATA : lo_container_100   TYPE REF TO cl_gui_custom_container,
         lt_spfli           TYPE STANDARD TABLE OF spfli,
         lt_field_calog_100 TYPE lvc_t_fcat,
         ls_layout_100      TYPE lvc_s_layo.
  IF go_alvgrid_100 IS NOT BOUND.
    PERFORM instance_container USING 'ALV_GRID100'    CHANGING lo_container_100.
    PERFORM build_field_cat    USING 'SPFLI'          CHANGING lt_field_calog_100.
    PERFORM build_layout       CHANGING ls_layout_100.
    PERFORM get_spfli_data     TABLES lt_spfli.
    PERFORM instance_alv       USING lo_container_100 CHANGING go_alvgrid_100.
    PERFORM set_handler        CHANGING go_alvgrid_100.
    PERFORM display_alv_spfli   CHANGING go_alvgrid_100
                                        lt_field_calog_100
                                        ls_layout_100
                                        .
  ELSE.
    PERFORM refresh_alv CHANGING go_alvgrid_100.
  ENDIF.

ENDFORM.

*&---------------------------------------------------------------------*
*& Form get_spfli_data
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM get_spfli_data TABLES pt_spfli TYPE STANDARD TABLE .

  SELECT *
  FROM spfli
  INTO TABLE gt_spfli.

ENDFORM.

*&---------------------------------------------------------------------*
*& Form instance_container_100
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM instance_container USING    pi_container_name TYPE c
                        CHANGING ci_container TYPE REF TO cl_gui_custom_container .


  CREATE OBJECT ci_container
    EXPORTING
*     parent         =                  " Parent container
      container_name = pi_container_name                 " Name of the Screen CustCtrl Name to Link Container To
*     style          =                  " Windows Style Attributes Applied to this Container
*     lifetime       = lifetime_default " Lifetime
*     repid          =                  " Screen to Which this Container is Linked
*     dynnr          =                  " Report To Which this Container is Linked
*     no_autodef_progid_dynnr     =                  " Don't Autodefined Progid and Dynnr?
*       EXCEPTIONS
*     cntl_error     = 1                " CNTL_ERROR
*     cntl_system_error           = 2                " CNTL_SYSTEM_ERROR
*     create_error   = 3                " CREATE_ERROR
*     lifetime_error = 4                " LIFETIME_ERROR
*     lifetime_dynpro_dynpro_link = 5                " LIFETIME_DYNPRO_DYNPRO_LINK
*     others         = 6
    .
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
      WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.


ENDFORM.


*&---------------------------------------------------------------------*
*& Form build_field_cat
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM build_field_cat USING pi_structure_name TYPE dd02l-tabname
                     CHANGING pc_fiel_cat TYPE lvc_t_fcat.


  CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
    EXPORTING
*     i_buffer_active        =                        " Buffer active
      i_structure_name       = pi_structure_name      " Structure name (structure, table, view)
*     i_client_never_display = 'X'              " Hide client fields
*     i_bypassing_buffer     =                  " Ignore buffer while reading
*     i_internal_tabname     =                  " Table Name
    CHANGING
      ct_fieldcat            = pc_fiel_cat                 " Field Catalog with Field Descriptions
    EXCEPTIONS
      inconsistent_interface = 1                " Call parameter combination error
      program_error          = 2                " Program Errors
      OTHERS                 = 3.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
      WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

ENDFORM.


*&---------------------------------------------------------------------*
*& Form build_layout_100
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM build_layout CHANGING pc_layout TYPE lvc_s_layo.
  pc_layout-zebra = abap_true.
*  gs_layout_100-edit  = abap_true.
  pc_layout-cwidth_opt = abap_true.
  pc_layout-sel_mode = 'D'.
  pc_layout-col_opt = 'X'.
  pc_layout-stylefname = 'FIELD_STYLE'.
ENDFORM.

*&---------------------------------------------------------------------*
*& Form instance_alv
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM instance_alv USING    pi_container TYPE REF TO cl_gui_custom_container
                  CHANGING pc_alv_grid TYPE REF TO cl_gui_alv_grid .


  CREATE OBJECT pc_alv_grid
    EXPORTING
*     i_shellstyle      = 0                " Control Style
*     i_lifetime        =                  " Lifetime
      i_parent = pi_container                 " Parent Container
*     i_appl_events     = space            " Register Events as Application Events
*     i_parentdbg       =                  " Internal, Do not Use
*     i_applogparent    =                  " Container for Application Log
*     i_graphicsparent  =                  " Container for Graphics
*     i_name   =                  " Name
*     i_fcat_complete   = space            " Boolean Variable (X=True, Space=False)
*      EXCEPTIONS
*     error_cntl_create = 1                " Error when creating the control
*     error_cntl_init   = 2                " Error While Initializing Control
*     error_cntl_link   = 3                " Error While Linking Control
*     error_dp_create   = 4                " Error While Creating DataProvider Control
*     others   = 5
    .
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
      WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.


ENDFORM.


*&---------------------------------------------------------------------*
*& Form new_form
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM set_handler  CHANGING pc_alv_grid TYPE REF TO cl_gui_alv_grid . .

  DATA : lc_handler TYPE REF TO lcl_event_alv_grid.

  CREATE OBJECT lc_handler.

  SET HANDLER : lc_handler->handle_toolbar FOR pc_alv_grid,
                lc_handler->handle_usercomand FOR pc_alv_grid.


ENDFORM.

*&---------------------------------------------------------------------*
*& Form display_alv_
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM display_alv_spfli CHANGING pc_alvgrid TYPE REF TO  cl_gui_alv_grid
                                pc_fieldcat TYPE  lvc_t_fcat
                                pc_layout TYPE lvc_s_layo.

  pc_alvgrid->set_table_for_first_display(
       EXPORTING
*         i_buffer_active               =                  " Buffering Active
*         i_bypassing_buffer            =                  " Switch Off Buffer
*         i_consistency_check           =                  " Starting Consistency Check for Interface Error Recognition
*         i_structure_name              =                  " Internal Output Table Structure Name
*         is_variant                    =                  " Layout
*         i_save                        =                  " Save Layout
*         i_default                     = 'X'              " Default Display Variant
         is_layout                     =  pc_layout        " Layout
*         is_print                      =                  " Print Control
*         it_special_groups             =                  " Field Groups
*         it_toolbar_excluding          =                  " Excluded Toolbar Standard Functions
*         it_hyperlink                  =                  " Hyperlinks
*         it_alv_graphics               =                  " Table of Structure DTC_S_TC
*         it_except_qinfo               =                  " Table for Exception Quickinfo
*         ir_salv_adapter               =                  " Interface ALV Adapter
    CHANGING
      it_outtab                     =  gt_spfli             " Output Table
      it_fieldcatalog               =  pc_fieldcat         " Field Catalog
*         it_sort                       =                  " Sort Criteria
*         it_filter                     =                  " Filter Criteria
*       EXCEPTIONS
*         invalid_parameter_combination = 1                " Wrong Parameter
*         program_error                 = 2                " Program Errors
*         too_many_lines                = 3                " Too many Rows in Ready for Input Grid
*         others                        = 4
  ).
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
      WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.
ENDFORM.

*&---------------------------------------------------------------------*
*& Form refresh_alv
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM refresh_alv CHANGING pc_alv_grid TYPE REF TO cl_gui_alv_grid.


  pc_alv_grid->refresh_table_display(
*     EXPORTING
*       is_stable      =     " With Stable Rows/Columns
*       i_soft_refresh =     " Without Sort, Filter, etc.
  EXCEPTIONS
    finished       = 1
    OTHERS         = 2
).
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
               WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

ENDFORM.


*&---------------------------------------------------------------------*
*& Form get_sbook
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM get_sbook .

  DATA : lt_index_rows TYPE lvc_t_row,
         lt_row_no     TYPE lvc_t_roid,
         lw_index      TYPE lvc_s_row.

  go_alvgrid_100->get_selected_rows(
       IMPORTING
         et_index_rows = lt_index_rows                 " Indexes of Selected Rows
         et_row_no     = lt_row_no                 " Numeric IDs of Selected Rows
  ).
  IF lt_index_rows IS NOT INITIAL.
    CLEAR   : gt_sbook.
    LOOP AT lt_index_rows INTO lw_index.
      READ TABLE gt_spfli INTO DATA(lw_spfli) INDEX lw_index-index.
      PERFORM get_sbook_data USING lw_spfli-connid lw_spfli-carrid.
    ENDLOOP.

    PERFORM report_sbook_init.
  ENDIF.
ENDFORM.

************************************************************
************************second alv *************************


*&---------------------------------------------------------------------*
*& Form report_sbook_init
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM report_sbook_init .



  DATA : lo_container_100   TYPE REF TO cl_gui_custom_container,
         lt_spfli           TYPE STANDARD TABLE OF spfli,
         lt_field_calog_100 TYPE lvc_t_fcat,
         ls_layout_100      TYPE lvc_s_layo.

  IF go_alvgrid_sbook IS NOT BOUND.

    PERFORM instance_container USING 'ALV_GRID_SBOOK'    CHANGING lo_container_100.
    PERFORM build_field_cat    USING 'SBOOK'             CHANGING lt_field_calog_100.
    PERFORM build_layout       CHANGING ls_layout_100.
    PERFORM instance_alv       USING lo_container_100 CHANGING go_alvgrid_sbook.
    PERFORM display_alv_sbook  CHANGING go_alvgrid_sbook
                                        lt_field_calog_100
                                        ls_layout_100.
  ELSE.
    PERFORM refresh_alv CHANGING go_alvgrid_sbook.
  ENDIF.

ENDFORM.

*&---------------------------------------------------------------------*
*& Form display_alv_
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM display_alv_sbook CHANGING pc_alvgrid TYPE REF TO  cl_gui_alv_grid
                                pc_fieldcat TYPE  lvc_t_fcat
                                pc_layout TYPE lvc_s_layo.

  pc_alvgrid->set_table_for_first_display(
       EXPORTING
*         i_buffer_active               =                  " Buffering Active
*         i_bypassing_buffer            =                  " Switch Off Buffer
*         i_consistency_check           =                  " Starting Consistency Check for Interface Error Recognition
*         i_structure_name              =                  " Internal Output Table Structure Name
*         is_variant                    =                  " Layout
*         i_save                        =                  " Save Layout
*         i_default                     = 'X'              " Default Display Variant
         is_layout                     =  pc_layout        " Layout
*         is_print                      =                  " Print Control
*         it_special_groups             =                  " Field Groups
*         it_toolbar_excluding          =                  " Excluded Toolbar Standard Functions
*         it_hyperlink                  =                  " Hyperlinks
*         it_alv_graphics               =                  " Table of Structure DTC_S_TC
*         it_except_qinfo               =                  " Table for Exception Quickinfo
*         ir_salv_adapter               =                  " Interface ALV Adapter
    CHANGING
      it_outtab                     =  gt_sbook             " Output Table
      it_fieldcatalog               =  pc_fieldcat         " Field Catalog
*         it_sort                       =                  " Sort Criteria
*         it_filter                     =                  " Filter Criteria
       EXCEPTIONS
         invalid_parameter_combination = 1                " Wrong Parameter
         program_error                 = 2                " Program Errors
         too_many_lines                = 3                " Too many Rows in Ready for Input Grid
         OTHERS                        = 4
  ).
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
      WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.
ENDFORM.

*&---------------------------------------------------------------------*
*& Form new_form
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM get_sbook_data USING pi_connid TYPE s_conn_id pi_carid TYPE s_carrid .

  SELECT *
  FROM sbook
  WHERE carrid EQ @pi_carid
  AND connid EQ @pi_connid
  APPENDING TABLE @gt_sbook.

ENDFORM.
