*&---------------------------------------------------------------------*
*& Include zspfli_report_top
*&---------------------------------------------------------------------*


DATA : go_alvgrid_100   TYPE REF TO cl_gui_alv_grid,
       go_alvgrid_sbook TYPE REF TO cl_gui_alv_grid,
       gt_spfli         TYPE STANDARD TABLE OF spfli,
       gt_sbook         TYPE STANDARD TABLE OF sbook,
       gv_okcode        TYPE syucomm.
