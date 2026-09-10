<%--
/* ======================================================================================================
 * File Name:   cim_LDAElog.aspx
 * Description: LDA ElogSheet 페이지 (SDA 기반)
 * DATE        AUTHOR       DESCRIPTION
 * ----------  -----------  ---------------------------------
 * 2025.xx.xx  jechan.na    Init
======================================================================================================= */
--%>

<%@ Page Title="" Language="C#" MasterPageFile="~/assets/masterLayout/masterLayout.master"
    AutoEventWireup="true" CodeFile="cim_LDAElog.aspx.cs"
    Inherits="sources_soc_cim_prod_assembly_cim_LDAElog" %>

<asp:Content ID="con_head" ContentPlaceHolderID="contentHead" runat="Server">
    <style type="text/css">
        #gv_list th {
            text-align: center;
            background-color: #dbd4d4;
        }

        .bg-sck {
            background-color: #f6f6f6;
        }

        .table-lotInfo.use-head {
            border-top: 2px solid #dadada;
            border-bottom: 2px solid #dadada;
        }

        /* 공통 4컬럼 폼 테이블 colgroup */
        .col-label { width: 20%; background-color: #f6f6f6; }
        .col-value { width: 30%; }
    </style>
</asp:Content>

<asp:Content ID="con_body" ContentPlaceHolderID="contentBody" runat="Server">

    <%-- 조회 결과 그리드는 code-behind 의 rgv_List_NeedDataSource 에서 바인딩한다.
         (기존 ObjectDataSource 는 TypeName 이 실제 조회 메서드가 있는 페이지 클래스가 아니라
          clsSocTran 을 가리키고 있어 조회가 되지 않았다) --%>

    <form id="form1" runat="server">
        <telerik:RadScriptManager ID="radSm_script" runat="server" />
        <telerik:RadWindowManager ID="radWm_window" runat="server"></telerik:RadWindowManager>

        <div class="page-content">
            <div class="page-header" style="margin-left: 10px; margin-bottom: 30px;">
                <h3>[ LDA ELog Sheet ]</h3>

                <telerik:RadTabStrip RenderMode="Lightweight" runat="server" ID="RadTabStrip1"
                    MultiPageID="RadMultiPage1" ResolvedRenderMode="Classic" SelectedIndex="0">
                    <Tabs>
                        <telerik:RadTab Text="Prod" Width="200px" PageViewID="RadPageView1" Selected="True" />
                        <telerik:RadTab Text="Tech" Width="200px" PageViewID="RadPageView2" />
                        <telerik:RadTab Text="QA" Width="200px" PageViewID="RadPageView3" />
                        <telerik:RadTab Text="Searching" Width="200px" PageViewID="RadPageView4" />
                    </Tabs>
                </telerik:RadTabStrip>

                <telerik:RadMultiPage runat="server" ID="RadMultiPage1" SelectedIndex="0">

                    <%-- ==================== PRD ==================== --%>
                    <telerik:RadPageView runat="server" ID="RadPageView1">
                        <asp:UpdatePanel ID="UpdatePanel4" runat="server">
                            <ContentTemplate>
                                <div class="panel panel-default" style="margin-top: 20px;">
                                    <div class="panel-body">
                                        <h5 style="color: #438EB9">PROD Page</h5>
                                        <div class="row" style="margin-top: 10px;">
                                            <table class="table table-listbox-tight table-valign-middle">
                                                <colgroup>
                                                    <col class="col-label" />
                                                    <col class="col-value" />
                                                    <col class="col-label" />
                                                    <col class="col-value" />
                                                </colgroup>
                                                <tbody>
                                                    <tr>
                                                        <th>Sheet Type<span class="asterisk"> *</span></th>
                                                        <td>
                                                            <asp:DropDownList ID="ddl_SheetType_prd" class="form-control" runat="server"
                                                                Style="height: 34px;"
                                                                AutoPostBack="True"
                                                                OnSelectedIndexChanged="ddl_SheetType_prd_SelectedIndexChanged">
                                                                <asp:ListItem Value="0">Set-Up</asp:ListItem>
                                                                <asp:ListItem Value="1">Visual Monitor</asp:ListItem>
                                                            </asp:DropDownList>
                                                        </td>
                                                        <th>Shift<span class="asterisk"> *</span></th>
                                                        <td>
                                                            <asp:DropDownList ID="ddl_Shift_prd" class="form-control" runat="server" Style="height: 34px;">
                                                                <asp:ListItem Value="0">A</asp:ListItem>
                                                                <asp:ListItem Value="1">B</asp:ListItem>
                                                                <asp:ListItem Value="2">C</asp:ListItem>
                                                            </asp:DropDownList>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <th>Operator ID<span class="asterisk"> *</span></th>
                                                        <td colspan="3">
                                                            <input type="text" id="txt_Oper_Id_prd" style="height: 34px;" value="<%=Session["USER_NAME"] %>" readonly />
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <th>작성 시간<span class="asterisk"> *</span></th>
                                                        <td colspan="3">
                                                            <telerik:RadDateTimePicker ID="tp_InputTime_prod" runat="server" TodayButtonVisibility="Visible"
                                                                class="form-control" DateInput-DateFormat="yyyy-MM-dd HH:mm:ss" Style="width: 50%" />
                                                            <input type="button" class="btn btn-add btn-xs btn-inverse m-r-5" id="setInNowTime_prod" value="현재시간" />
                                                        </td>
                                                    </tr>
                                                </tbody>
                                            </table>
                                        </div>

                                        <h5 style="color: #438EB9">Lot Information</h5>
                                        <div class="row" style="margin-top: 10px;">
                                            <table class="table table-listbox-tight table-valign-middle">
                                                <colgroup>
                                                    <col class="col-label" />
                                                    <col class="col-value" />
                                                    <col class="col-label" />
                                                    <col class="col-value" />
                                                </colgroup>
                                                <tbody>
                                                    <tr>
                                                        <th>Lot ID<span class="asterisk"> *</span></th>
                                                        <td>
                                                            <asp:TextBox ID="txt_LotId_prd" runat="server" class="form-control" Style="text-transform: uppercase;"
                                                                OnTextChanged="txt_LotId_prd_TextChanged" AutoPostBack="True" />
                                                            <asp:RequiredFieldValidator ID="rfv_lda_001" runat="server" ErrorMessage="LOT ID를 입력하세요" ForeColor="Red"
                                                                ValidationGroup="val_chk_prd" Display="Dynamic" ControlToValidate="txt_LotId_prd" />
                                                        </td>
                                                        <th>Customer<span class="asterisk"> *</span></th>
                                                        <td>
                                                            <asp:TextBox ID="txt_Cust_prd" runat="server" class="form-control" ReadOnly="True" placeholder="LOT ID 입력시 자동생성" />
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <th>PKG<span class="asterisk"> *</span></th>
                                                        <td>
                                                            <asp:TextBox ID="txt_Pkg_prd" runat="server" class="form-control" ReadOnly="True" placeholder="LOT ID 입력시 자동생성" />
                                                        </td>
                                                        <th>Lead<span class="asterisk"> *</span></th>
                                                        <td>
                                                            <asp:TextBox ID="txt_Lead_prd" runat="server" class="form-control" ReadOnly="True" placeholder="LOT ID 입력시 자동생성" />
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <th>Cust Device<span class="asterisk"> *</span></th>
                                                        <td>
                                                            <asp:TextBox ID="txt_Device_prd" runat="server" class="form-control" ReadOnly="True" placeholder="LOT ID 입력시 자동생성" />
                                                        </td>
                                                        <th>Nick<span class="asterisk"> *</span></th>
                                                        <td>
                                                            <asp:TextBox ID="txt_Nick_prd" runat="server" class="form-control" ReadOnly="True" placeholder="LOT ID 입력시 자동생성" />
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <th>Qty<span class="asterisk"> *</span></th>
                                                        <td>
                                                            <asp:TextBox ID="txt_Qty_prd" runat="server" class="form-control" ReadOnly="True" placeholder="LOT ID 입력시 자동생성" />
                                                        </td>
                                                        <th>Recipe Name<span class="asterisk"> *</span></th>
                                                        <td>
                                                            <asp:TextBox ID="txt_RecipeName_prd" runat="server" class="form-control" />
                                                            <asp:RequiredFieldValidator ID="rfv_lda_002" runat="server" ErrorMessage="항목 누락" ForeColor="Red"
                                                                ValidationGroup="val_chk_prd" Display="Dynamic" ControlToValidate="txt_RecipeName_prd" />
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <th>AI<span class="asterisk"> *</span></th>
                                                        <td colspan="3">
                                                            <asp:TextBox ID="txt_ai_prd" runat="server" class="form-control" ReadOnly="True" placeholder="LOT ID 입력시 자동생성" />
                                                        </td>
                                                    </tr>
                                                </tbody>
                                            </table>
                                        </div>

                                        <h5 style="color: #438EB9">Machine Information</h5>
                                        <div class="row" style="margin-top: 10px;">
                                            <table class="table table-listbox-tight table-valign-middle">
                                                <colgroup>
                                                    <col class="col-label" />
                                                    <col class="col-value" />
                                                    <col class="col-label" />
                                                    <col class="col-value" />
                                                </colgroup>
                                                <tbody>
                                                    <tr>
                                                        <th>M/C No<span class="asterisk"> *</span></th>
                                                        <td colspan="3">
                                                            <asp:DropDownList ID="ddl_McNo_prd" class="form-control" runat="server" Style="height: 34px; width: 50%;" />
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <th>Oper Code<span class="asterisk"> *</span></th>
                                                        <td colspan="3">
                                                            <asp:TextBox ID="txt_OperCode_prd" runat="server" class="form-control" Text="LDA" Style="width: 50%;" />
                                                        </td>
                                                    </tr>
                                                </tbody>
                                            </table>
                                        </div>

                                        <h5 style="color: #438EB9">Material Information</h5>
 <%-- Needle rows: Set-Up 일 때만 표시 --%>
                                        <asp:Panel ID="pnl_needle_prd" runat="server" Visible="true">
                                        <div class="row" style="margin-top: 5px;">
                                            <table class="table table-listbox-tight table-valign-middle">
                                                <colgroup>
                                                    <col class="col-label" />
                                                    <col class="col-value" />
                                                    <col class="col-label" />
                                                    <col class="col-value" />
                                                </colgroup>
                                                <tbody>
                                                    <tr>
                                                        <th>TIM Needle S/N<span class="asterisk"> *</span></th>
                                                        <td>
                                                            <asp:TextBox ID="txt_tim_needle_sn_prd" runat="server" class="form-control" Style="text-transform: uppercase;" />
                                                            <asp:RequiredFieldValidator ID="rfv_lda_prd_needle_sn" runat="server" ErrorMessage="항목 누락" ForeColor="Red"
                                                                ValidationGroup="val_chk_prd" Display="Dynamic" ControlToValidate="txt_tim_needle_sn_prd" />
                                                        </td>
                                                        <th>TIM Needle Size<span class="asterisk"> *</span></th>
                                                        <td>
                                                            <asp:TextBox ID="txt_tim_needle_size_prd" runat="server" class="form-control" Style="text-transform: uppercase;" />
                                                            <asp:RequiredFieldValidator ID="rfv_lda_prd_needle_size" runat="server" ErrorMessage="항목 누락" ForeColor="Red"
                                                                ValidationGroup="val_chk_prd" Display="Dynamic" ControlToValidate="txt_tim_needle_size_prd" />
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <th>Glue Needle S/N<span class="asterisk"> *</span></th>
                                                        <td>
                                                            <asp:TextBox ID="txt_glue_needle_sn_prd" runat="server" class="form-control" Style="text-transform: uppercase;" />
                                                            <asp:RequiredFieldValidator ID="rfv_lda_prd_glue_sn" runat="server" ErrorMessage="항목 누락" ForeColor="Red"
                                                                ValidationGroup="val_chk_prd" Display="Dynamic" ControlToValidate="txt_glue_needle_sn_prd" />
                                                        </td>
                                                        <th>Glue Needle Size<span class="asterisk"> *</span></th>
                                                        <td>
                                                            <asp:TextBox ID="txt_glue_needle_size_prd" runat="server" class="form-control" Style="text-transform: uppercase;" />
                                                            <asp:RequiredFieldValidator ID="rfv_lda_prd_glue_size" runat="server" ErrorMessage="항목 누락" ForeColor="Red"
                                                                ValidationGroup="val_chk_prd" Display="Dynamic" ControlToValidate="txt_glue_needle_size_prd" />
                                                        </td>
                                                    </tr>
                                                </tbody>
                                            </table>
                                        </div>
                                        </asp:Panel>
                                        <div class="row" style="margin-top: 10px;">
                                            <%-- System1~4 + Lid 6열 매트릭스 --%>
                                            <table class="table table-lotInfo use-head">
                                                <colgroup>
                                                    <col style="width: 14%; background-color: #f6f6f6;" />
                                                    <col style="width: 17.2%;" />
                                                    <col style="width: 17.2%;" />
                                                    <col style="width: 17.2%;" />
                                                    <col style="width: 17.2%;" />
                                                    <col style="width: 17.2%;" />
                                                </colgroup>
                                                <tbody>
                                                    <tr>
                                                        <th></th>
                                                        <th style="text-align:center;">System1</th>
                                                        <th style="text-align:center;">System2</th>
                                                        <th style="text-align:center;">System3</th>
                                                        <th style="text-align:center;">System4</th>
                                                        <th style="text-align:center;">Lid</th>
                                                    </tr>
                                                    <tr>
                                                        <th>Information</th>
                                                        <td><asp:TextBox ID="txt_sys1_info_prd" runat="server" class="form-control" placeholder="자동생성" ReadOnly="True" /></td>
                                                        <td><asp:TextBox ID="txt_sys2_info_prd" runat="server" class="form-control" placeholder="자동생성" ReadOnly="True" /></td>
                                                        <td><asp:TextBox ID="txt_sys3_info_prd" runat="server" class="form-control" placeholder="자동생성" ReadOnly="True" /></td>
                                                        <td><asp:TextBox ID="txt_sys4_info_prd" runat="server" class="form-control" placeholder="자동생성" ReadOnly="True" /></td>
                                                        <td><asp:TextBox ID="txt_lid_info_prd" runat="server" class="form-control" placeholder="자동생성" ReadOnly="True" /></td>
                                                    </tr>
                                                    <tr>
                                                        <th>Batch No</th>
                                                        <td>
                                                            <asp:TextBox ID="txt_sys1_batch_prd" runat="server" class="form-control"
                                                                Style="width:65%;display:inline-block;text-transform:uppercase;"
                                                                AutoPostBack="True" OnTextChanged="txt_sys1_batch_prd_TextChanged" />
                                                            <asp:Button class="btn btn-add btn-xs btn-inverse" ID="btn_sys1_na_prd" runat="server" Width="30%" Text="N/A" OnClick="btn_sys1_na_prd_Click" />
                                                        </td>
                                                        <td>
                                                            <asp:TextBox ID="txt_sys2_batch_prd" runat="server" class="form-control"
                                                                Style="width:65%;display:inline-block;text-transform:uppercase;"
                                                                AutoPostBack="True" OnTextChanged="txt_sys2_batch_prd_TextChanged" />
                                                            <asp:Button class="btn btn-add btn-xs btn-inverse" ID="btn_sys2_na_prd" runat="server" Width="30%" Text="N/A" OnClick="btn_sys2_na_prd_Click" />
                                                        </td>
                                                        <td>
                                                            <asp:TextBox ID="txt_sys3_batch_prd" runat="server" class="form-control"
                                                                Style="width:65%;display:inline-block;text-transform:uppercase;"
                                                                AutoPostBack="True" OnTextChanged="txt_sys3_batch_prd_TextChanged" />
                                                            <asp:Button class="btn btn-add btn-xs btn-inverse" ID="btn_sys3_na_prd" runat="server" Width="30%" Text="N/A" OnClick="btn_sys3_na_prd_Click" />
                                                        </td>
                                                        <td>
                                                            <asp:TextBox ID="txt_sys4_batch_prd" runat="server" class="form-control"
                                                                Style="width:65%;display:inline-block;text-transform:uppercase;"
                                                                AutoPostBack="True" OnTextChanged="txt_sys4_batch_prd_TextChanged" />
                                                            <asp:Button class="btn btn-add btn-xs btn-inverse" ID="btn_sys4_na_prd" runat="server" Width="30%" Text="N/A" OnClick="btn_sys4_na_prd_Click" />
                                                        </td>
                                                        <td>
                                                            <asp:TextBox ID="txt_lid_batch_prd" runat="server" class="form-control"
                                                                Style="text-transform: uppercase;"
                                                                AutoPostBack="True" OnTextChanged="txt_lid_batch_prd_TextChanged" />
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <th>SAP Code</th>
                                                        <td><asp:TextBox ID="txt_sys1_sap_prd" runat="server" class="form-control" placeholder="자동생성" ReadOnly="True" /></td>
                                                        <td><asp:TextBox ID="txt_sys2_sap_prd" runat="server" class="form-control" placeholder="자동생성" ReadOnly="True" /></td>
                                                        <td><asp:TextBox ID="txt_sys3_sap_prd" runat="server" class="form-control" placeholder="자동생성" ReadOnly="True" /></td>
                                                        <td><asp:TextBox ID="txt_sys4_sap_prd" runat="server" class="form-control" placeholder="자동생성" ReadOnly="True" /></td>
                                                        <td></td>
                                                    </tr>
                                                    <tr>
                                                        <th>Expire Time</th>
                                                        <td><telerik:RadDateTimePicker ID="tp_sys1_expire_prd" runat="server" TodayButtonVisibility="Visible" class="form-control" DateInput-DateFormat="yyyy-MM-dd HH:mm:ss" Style="width: 100%" /></td>
                                                        <td><telerik:RadDateTimePicker ID="tp_sys2_expire_prd" runat="server" TodayButtonVisibility="Visible" class="form-control" DateInput-DateFormat="yyyy-MM-dd HH:mm:ss" Style="width: 100%" /></td>
                                                        <td><telerik:RadDateTimePicker ID="tp_sys3_expire_prd" runat="server" TodayButtonVisibility="Visible" class="form-control" DateInput-DateFormat="yyyy-MM-dd HH:mm:ss" Style="width: 100%" /></td>
                                                        <td><telerik:RadDateTimePicker ID="tp_sys4_expire_prd" runat="server" TodayButtonVisibility="Visible" class="form-control" DateInput-DateFormat="yyyy-MM-dd HH:mm:ss" Style="width: 100%" /></td>
                                                        <td></td>
                                                    </tr>
                                                </tbody>
                                            </table>
                                        </div>

                                        <h5 style="color: #438EB9">Visual Defect Q'ty</h5>
                                        <div class="row" style="margin-top: 10px;">
                                            <table class="table table-listbox-tight table-valign-middle">
                                                <colgroup>
                                                    <col class="col-label" />
                                                    <col class="col-value" />
                                                    <col class="col-label" />
                                                    <col class="col-value" />
                                                </colgroup>
                                                <tbody>
                                                    <tr>
                                                        <th>Tim Dispensing Pattern</th>
                                                        <td colspan="3">
                                                            <asp:DropDownList ID="ddl_tim_dispensing_pattern" class="form-control" runat="server" Style="height: 34px; width: 50%;">
                                                                <asp:ListItem Value="0">OK</asp:ListItem>
                                                                <asp:ListItem Value="1">NG</asp:ListItem>
                                                            </asp:DropDownList>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <th>Epoxy Dispensing Pattern</th>
                                                        <td colspan="3">
                                                            <asp:DropDownList ID="ddl_epoxy_dispensing_pattern" class="form-control" runat="server" Style="height: 34px; width: 50%;">
                                                                <asp:ListItem Value="0">OK</asp:ListItem>
                                                                <asp:ListItem Value="1">NG</asp:ListItem>
                                                            </asp:DropDownList>
                                                        </td>
                                                    </tr>
                                                    <tr id="tr_coverage_prd" runat="server">
                                                        <th>Dummy Coverage (Detach)</th>
                                                        <td colspan="3">
                                                            <asp:DropDownList ID="ddl_coverage_detach" class="form-control" runat="server" Style="height: 34px; width: 50%;">
                                                                <asp:ListItem Value="0">OK</asp:ListItem>
                                                                <asp:ListItem Value="1">NG</asp:ListItem>
                                                            </asp:DropDownList>
                                                        </td>
                                                    </tr>
                                                    <tr id="tr_tilt_prd" runat="server">
                                                        <th>Tilt</th>
                                                        <td colspan="3">
                                                            <asp:DropDownList ID="ddl_mesurement_tilt_prd" class="form-control" runat="server" Style="height: 34px; width: 50%;">
                                                                <asp:ListItem Value="0">OK</asp:ListItem>
                                                                <asp:ListItem Value="1">NG</asp:ListItem>
                                                            </asp:DropDownList>
                                                        </td>
                                                    </tr>
                                                    <tr id="tr_position_prd" runat="server">
                                                        <th>Position</th>
                                                        <td colspan="3">
                                                            <asp:DropDownList ID="ddl_mesurement_position_prd" class="form-control" runat="server" Style="height: 34px; width: 50%;">
                                                                <asp:ListItem Value="0">OK</asp:ListItem>
                                                                <asp:ListItem Value="1">NG</asp:ListItem>
                                                            </asp:DropDownList>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <th>Remark</th>
                                                        <td colspan="3">
                                                            <asp:TextBox ID="txt_mesurement_remark_prd" runat="server" class="form-control" Style="text-transform: uppercase;" AutoPostBack="True" />
                                                        </td>
                                                    </tr>
                                                </tbody>
                                            </table>
                                        </div>
                                        <div class="row" style="margin-bottom: 30px;">
                                            <div class="col-xs-12">
                                                <div class="text-center">
                                                    <button type="button" id="btn_save_prd" class="btn btn-primary" runat="server" onserverclick="btn_save_prd_Click" validationgroup="val_chk_prd">
                                                        <span class="glyphicon glyphicon-ok"></span>&nbsp;&nbsp;등 록
                                                    </button>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </ContentTemplate>
                            <Triggers>
                                <asp:PostBackTrigger ControlID="btn_save_prd" />
                            </Triggers>
                        </asp:UpdatePanel>
                    </telerik:RadPageView>

                    <%-- ==================== TECH ==================== --%>
                    <telerik:RadPageView runat="server" ID="RadPageView2">
                        <asp:UpdatePanel ID="UpdatePanel2" runat="server">
                            <ContentTemplate>
                                <div class="panel panel-default" style="margin-top: 20px;">
                                    <div class="panel-body">
                                        <h5 style="color: #438EB9">TECH Page</h5>
                                        <div class="row" style="margin-top: 10px;">
                                            <table class="table table-listbox-tight table-valign-middle">
                                                <colgroup>
                                                    <col class="col-label" />
                                                    <col class="col-value" />
                                                    <col class="col-label" />
                                                    <col class="col-value" />
                                                </colgroup>
                                                <tbody>
                                                    <tr>
                                                        <th>작성 시간<span class="asterisk"> *</span></th>
                                                        <td>
                                                            <telerik:RadDateTimePicker ID="tp_InputTime_tech" runat="server" TodayButtonVisibility="Visible" class="form-control" DateInput-DateFormat="yyyy-MM-dd HH:mm:ss" Style="width: 100%" />
                                                            <input type="button" class="btn btn-add btn-xs btn-inverse m-r-5" id="setInNowTime_tech" value="현재시간" />
                                                        </td>
                                                        <th>Shift<span class="asterisk"> *</span></th>
                                                        <td>
                                                            <asp:DropDownList ID="ddl_Shift_tech" class="form-control" runat="server" Style="height: 34px;">
                                                                <asp:ListItem Value="0">A</asp:ListItem>
                                                                <asp:ListItem Value="1">B</asp:ListItem>
                                                                <asp:ListItem Value="2">C</asp:ListItem>
                                                            </asp:DropDownList>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <th>User ID<span class="asterisk"> *</span></th>
                                                        <td>
                                                            <input type="text" id="txt_Oper_Id_tech" style="height: 34px;" value="<%=Session["USER_NAME"] %>" readonly />
                                                        </td>
                                                        <th>Name<span class="asterisk"> *</span></th>
                                                        <td>
                                                            <input type="text" id="txt_Oper_desc_tech" style="height: 34px;" value="<%=Session["USER_DESC"] %>" readonly />
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <th>Recipe Name<span class="asterisk"> *</span></th>
                                                        <td>
                                                            <asp:TextBox ID="txt_recipe_name_tech" runat="server" class="form-control" AutoPostBack="True" />
                                                            <asp:RequiredFieldValidator ID="rfv_lda_003" runat="server" ErrorMessage="항목 누락" ForeColor="Red" ValidationGroup="val_chk_tech" Display="Dynamic" ControlToValidate="txt_recipe_name_tech" />
                                                        </td>
                                                        <th>Equipment ID<span class="asterisk"> *</span></th>
                                                        <td>
                                                            <asp:DropDownList ID="ddl_eq_id_tech" class="form-control" runat="server" Style="height: 34px;" />
                                                        </td>
                                                    </tr>
                                                </tbody>
                                            </table>
                                        </div>

                                        <h5 style="color: #438EB9">Lot Information</h5>
                                        <div class="row" style="margin-top: 10px;">
                                            <table class="table table-listbox-tight table-valign-middle">
                                                <colgroup>
                                                    <col class="col-label" />
                                                    <col class="col-value" />
                                                    <col class="col-label" />
                                                    <col class="col-value" />
                                                </colgroup>
                                                <tbody>
                                                    <tr>
                                                        <th>Lot ID<span class="asterisk"> *</span></th>
                                                        <td colspan="3">
                                                            <asp:TextBox ID="txt_LotId_tech" runat="server" class="form-control" Style="text-transform: uppercase;" OnTextChanged="txt_LotId_tech_TextChanged" AutoPostBack="True" />
                                                            <asp:RequiredFieldValidator ID="rfv_lda_004" runat="server" ErrorMessage="LOT ID를 입력하세요" ForeColor="Red" ValidationGroup="val_chk_tech" Display="Dynamic" ControlToValidate="txt_LotId_tech" />
                                                        </td>
                                                    </tr>
                                                    <tr id="lotIdInfo" runat="server" visible="false">
                                                        <td colspan="4">
                                                            <table class="table-lotInfo m-b-0" style="text-align: center; width: 100%">
                                                                <colgroup>
                                                                    <col style="width: 25%" />
                                                                    <col style="width: 25%" />
                                                                    <col style="width: 25%" />
                                                                    <col style="width: 25%" />
                                                                </colgroup>
                                                                <tbody>
                                                                    <tr>
                                                                        <th>CUST ID</th>
                                                                        <th>PKG ID</th>
                                                                        <th>DEVICE ID</th>
                                                                        <th>LEAD ID</th>
                                                                    </tr>
                                                                    <tr>
                                                                        <td id="custId" runat="server"></td>
                                                                        <td id="pkgId" runat="server"></td>
                                                                        <td id="deviceId" runat="server"></td>
                                                                        <td id="leadId" runat="server"></td>
                                                                    </tr>
                                                                </tbody>
                                                            </table>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <th>T-card &amp; A/I check<span class="asterisk"> *</span></th>
                                                        <td colspan="3">
                                                            <asp:DropDownList ID="ddl_tcard_aicheck_tech" class="form-control" runat="server" Style="height: 34px; width: 50%;">
                                                                <asp:ListItem Value="" Text=" " />
                                                                <asp:ListItem Value="1">YES</asp:ListItem>
                                                                <asp:ListItem Value="2">NO</asp:ListItem>
                                                            </asp:DropDownList>
                                                            <asp:RequiredFieldValidator ID="rfv_lda_005" runat="server" ErrorMessage="항목 누락" ForeColor="Red" ValidationGroup="val_chk_tech" Display="Dynamic" ControlToValidate="ddl_tcard_aicheck_tech" />
                                                        </td>
                                                    </tr>
                                                </tbody>
                                            </table>
                                        </div>

                                        <h5 style="color: #438EB9">Tool Kit</h5>
                                        <div class="row" style="margin-top: 10px;">
                                            <table class="table table-listbox-tight table-valign-middle">
                                                <colgroup>
                                                    <col class="col-label" />
                                                    <col class="col-value" />
                                                    <col class="col-label" />
                                                    <col class="col-value" />
                                                </colgroup>
                                                <tbody>
                                                    <tr>
                                                        <th>Pick up tool<span class="asterisk"> *</span></th>
                                                        <td colspan="3">
                                                            <asp:TextBox ID="txt_pickup_tool_tech" runat="server" class="form-control" Style="text-transform: uppercase;" AutoPostBack="True" />
                                                            <asp:RequiredFieldValidator ID="rfv_lda_014" runat="server" ErrorMessage="항목 누락" ForeColor="Red" ValidationGroup="val_chk_tech" Display="Dynamic" ControlToValidate="txt_pickup_tool_tech" />
                                                        </td>
                                                    </tr>
                                                </tbody>
                                            </table>
                                        </div>

                                        <h5 style="color: #438EB9">Check Data</h5>
                                        <div class="row" style="margin-top: 10px;">
                                            <table class="table table-lotInfo use-head">
                                                <colgroup>
                                                    <col class="col-label" />
                                                    <col class="col-value" />
                                                    <col class="col-label" />
                                                    <col class="col-value" />
                                                </colgroup>
                                                <tbody>
                                                    <tr>
                                                        <th>PCB reverse detect check<span class="asterisk"> *</span></th>
                                                        <td>
                                                            <asp:DropDownList ID="ddl_pcb_reverse_detect_check_tech" class="form-control" runat="server" Style="height: 34px;">
                                                                <asp:ListItem Value="" Text=" " />
                                                                <asp:ListItem Value="1">OK</asp:ListItem>
                                                                <asp:ListItem Value="2">N/A</asp:ListItem>
                                                            </asp:DropDownList>
                                                            <asp:RequiredFieldValidator ID="rfv_lda_020" runat="server" ErrorMessage="항목 누락" ForeColor="Red" ValidationGroup="val_chk_tech" Display="Dynamic" ControlToValidate="ddl_pcb_reverse_detect_check_tech" />
                                                        </td>
                                                        <th>Bonding Force [g]<span class="asterisk"> *</span></th>
                                                        <td>
                                                            <asp:TextBox ID="txt_bonding_force_tech" runat="server" class="form-control" Style="text-transform: uppercase;" AutoPostBack="True" />
                                                            <asp:RequiredFieldValidator ID="rfv_lda_021" runat="server" ErrorMessage="항목 누락" ForeColor="Red" ValidationGroup="val_chk_tech" Display="Dynamic" ControlToValidate="txt_bonding_force_tech" />
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <th>PCB magazine load/unload check<span class="asterisk"> *</span></th>
                                                        <td>
                                                            <asp:DropDownList ID="ddl_pcb_magazine_load_unload_check_tech" class="form-control" runat="server" Style="height: 34px;">
                                                                <asp:ListItem Value="" Text=" " />
                                                                <asp:ListItem Value="1">OK</asp:ListItem>
                                                                <asp:ListItem Value="2">N/A</asp:ListItem>
                                                            </asp:DropDownList>
                                                            <asp:RequiredFieldValidator ID="rfv_lda_022" runat="server" ErrorMessage="항목 누락" ForeColor="Red" ValidationGroup="val_chk_tech" Display="Dynamic" ControlToValidate="ddl_pcb_magazine_load_unload_check_tech" />
                                                        </td>
                                                        <th>Delay Time [ms]<span class="asterisk"> *</span></th>
                                                        <td>
                                                            <asp:TextBox ID="txt_delay_time_tech" runat="server" class="form-control" Style="text-transform: uppercase;" AutoPostBack="True" />
                                                            <asp:RequiredFieldValidator ID="rfv_lda_023" runat="server" ErrorMessage="항목 누락" ForeColor="Red" ValidationGroup="val_chk_tech" Display="Dynamic" ControlToValidate="txt_delay_time_tech" />
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <th>PCB back side scratch check<span class="asterisk"> *</span></th>
                                                        <td colspan="3">
                                                            <asp:DropDownList ID="ddl_pcb_back_side_scratch_check_tech" class="form-control" runat="server" Style="height: 34px; width: 50%;">
                                                                <asp:ListItem Value="" Text=" " />
                                                                <asp:ListItem Value="1">OK</asp:ListItem>
                                                                <asp:ListItem Value="2">N/A</asp:ListItem>
                                                            </asp:DropDownList>
                                                            <asp:RequiredFieldValidator ID="rfv_lda_024" runat="server" ErrorMessage="항목 누락" ForeColor="Red" ValidationGroup="val_chk_tech" Display="Dynamic" ControlToValidate="ddl_pcb_back_side_scratch_check_tech" />
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <th>Pusher Position Check</th>
                                                        <td colspan="3">
                                                            <asp:DropDownList ID="ddl_pusher_position_check_tech" class="form-control" runat="server" Style="height: 34px; width: 50%;">
                                                                <asp:ListItem Value="" Text=" " />
                                                                <asp:ListItem Value="1">OK</asp:ListItem>
                                                                <asp:ListItem Value="2">N/A</asp:ListItem>
                                                            </asp:DropDownList>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <th>2DID mode<span class="asterisk"> *</span></th>
                                                        <td colspan="3">
                                                            <asp:DropDownList ID="ddl_2did_mode_tech" class="form-control" runat="server" Style="height: 34px; width: 50%;">
                                                                <asp:ListItem Value="" Text=" " />
                                                                <asp:ListItem Value="1">OK</asp:ListItem>
                                                                <asp:ListItem Value="2">N/A</asp:ListItem>
                                                            </asp:DropDownList>
                                                            <asp:RequiredFieldValidator ID="rfv_lda_026" runat="server" ErrorMessage="항목 누락" ForeColor="Red" ValidationGroup="val_chk_tech" Display="Dynamic" ControlToValidate="ddl_2did_mode_tech" />
                                                        </td>
                                                    </tr>
                                                </tbody>
                                            </table>
                                        </div>

                                        <div class="row" style="margin-bottom: 30px;">
                                            <div class="col-xs-12">
                                                <div class="text-center">
                                                    <button type="button" id="btn_save_tech" class="btn btn-primary" runat="server" onserverclick="btn_save_tech_Click" validationgroup="val_chk_tech">
                                                        <span class="glyphicon glyphicon-ok"></span>&nbsp;&nbsp;등 록
                                                    </button>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </ContentTemplate>
                            <Triggers>
                                <asp:PostBackTrigger ControlID="btn_save_tech" />
                            </Triggers>
                        </asp:UpdatePanel>
                    </telerik:RadPageView>

                    <%-- ==================== QA ==================== --%>
                    <telerik:RadPageView runat="server" ID="RadPageView3">
                        <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                            <ContentTemplate>
                                <div class="panel panel-default" style="margin-top: 20px;">
                                    <div class="panel-body">
                                        <h5 style="color: #438EB9">QA Page</h5>
                                        <div class="row" style="margin-top: 10px;">
                                            <table class="table table-listbox-tight table-valign-middle">
                                                <colgroup>
                                                    <col class="col-label" />
                                                    <col class="col-value" />
                                                    <col class="col-label" />
                                                    <col class="col-value" />
                                                </colgroup>
                                                <tbody>
                                                    <tr>
                                                        <th>Sheet Type<span class="asterisk"> *</span></th>
                                                        <td>
                                                            <telerik:RadDropDownList ID="ddl_SheetType_qa" runat="server" AutoPostBack="true" BackColor="#f0f0f0" OnSelectedIndexChanged="ddl_SheetType_qa_SelectedIndexChanged">
                                                                <Items>
                                                                    <telerik:DropDownListItem Text="Set-Up" Value="0" />
                                                                    <telerik:DropDownListItem Text="Visual Monitor" Value="1" />
                                                                </Items>
                                                            </telerik:RadDropDownList>
                                                        </td>
                                                        <th>Shift<span class="asterisk"> *</span></th>
                                                        <td>
                                                            <asp:DropDownList ID="ddl_Shift_qa" class="form-control" runat="server" Style="height: 34px;">
                                                                <asp:ListItem Value="0">A</asp:ListItem>
                                                                <asp:ListItem Value="1">B</asp:ListItem>
                                                                <asp:ListItem Value="2">C</asp:ListItem>
                                                            </asp:DropDownList>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <th>Operator ID<span class="asterisk"> *</span></th>
                                                        <td colspan="3">
                                                            <input type="text" id="txt_Oper_Id_qa" style="height: 34px;" value="<%=Session["USER_NAME"] %>" readonly />
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <th>작성 시간<span class="asterisk"> *</span></th>
                                                        <td colspan="3">
                                                            <telerik:RadDateTimePicker ID="tp_InputTime_qa" runat="server" TodayButtonVisibility="Visible" class="form-control" DateInput-DateFormat="yyyy-MM-dd HH:mm:ss" Style="width: 50%" />
                                                            <input type="button" class="btn btn-add btn-xs btn-inverse m-r-5" id="setInNowTime_qa" value="현재시간" />
                                                        </td>
                                                    </tr>
                                                </tbody>
                                            </table>
                                        </div>

                                        <h5 style="color: #438EB9">Lot Information</h5>
                                        <div class="row" style="margin-top: 10px;">
                                            <table class="table table-listbox-tight table-valign-middle">
                                                <colgroup>
                                                    <col class="col-label" />
                                                    <col class="col-value" />
                                                    <col class="col-label" />
                                                    <col class="col-value" />
                                                </colgroup>
                                                <tbody>
                                                    <tr>
                                                        <th>Lot ID<span class="asterisk"> *</span></th>
                                                        <td>
                                                            <asp:TextBox ID="txt_LotId_qa" runat="server" class="form-control" Style="text-transform: uppercase;" OnTextChanged="txt_LotId_qa_TextChanged" AutoPostBack="True" />
                                                            <asp:RequiredFieldValidator ID="rfv_lda_030" runat="server" ErrorMessage="LOT ID를 입력하세요" ForeColor="Red" ValidationGroup="val_chk_qa" Display="Dynamic" ControlToValidate="txt_LotId_qa" />
                                                        </td>
                                                        <th>Customer<span class="asterisk"> *</span></th>
                                                        <td>
                                                            <asp:TextBox ID="txt_Cust_qa" runat="server" class="form-control" ReadOnly="True" placeholder="Lot No 입력시 자동생성" />
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <th>PKG<span class="asterisk"> *</span></th>
                                                        <td>
                                                            <asp:TextBox ID="txt_Pkg_qa" runat="server" class="form-control" ReadOnly="True" placeholder="Lot No 입력시 자동생성" />
                                                        </td>
                                                        <th>Lead<span class="asterisk"> *</span></th>
                                                        <td>
                                                            <asp:TextBox ID="txt_Lead_qa" runat="server" class="form-control" ReadOnly="True" placeholder="Lot No 입력시 자동생성" />
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <th>Cust Device<span class="asterisk"> *</span></th>
                                                        <td>
                                                            <asp:TextBox ID="txt_Device_qa" runat="server" class="form-control" ReadOnly="True" placeholder="Lot No 입력시 자동생성" />
                                                        </td>
                                                        <th>Nick<span class="asterisk"> *</span></th>
                                                        <td>
                                                            <asp:TextBox ID="txt_Nick_qa" runat="server" class="form-control" ReadOnly="True" placeholder="Lot No 입력시 자동생성" />
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <th>Qty<span class="asterisk"> *</span></th>
                                                        <td colspan="3">
                                                            <asp:TextBox ID="txt_Qty_qa" runat="server" class="form-control" ReadOnly="True" placeholder="Lot No 입력시 자동생성" />
                                                        </td>
                                                    </tr>
                                                </tbody>
                                            </table>
                                        </div>

                                        <h5 style="color: #438EB9">Machine Information</h5>
                                        <div class="row" style="margin-top: 10px;">
                                            <table class="table table-listbox-tight table-valign-middle">
                                                <colgroup>
                                                    <col class="col-label" />
                                                    <col class="col-value" />
                                                    <col class="col-label" />
                                                    <col class="col-value" />
                                                </colgroup>
                                                <tbody>
                                                    <tr>
                                                        <th>M/C No<span class="asterisk"> *</span></th>
                                                        <td colspan="3">
                                                            <asp:TextBox ID="txt_McNo_qa" runat="server" class="form-control" AutoPostBack="True" />
                                                            <asp:RequiredFieldValidator ID="rfv_lda_031" runat="server" ErrorMessage="항목 누락" ForeColor="Red" ValidationGroup="val_chk_qa" Display="Dynamic" ControlToValidate="txt_McNo_qa" />
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <th>Oper Code<span class="asterisk"> *</span></th>
                                                        <td colspan="3">
                                                            <asp:TextBox ID="txt_OperCode_qa" runat="server" class="form-control" Text="LDA" />
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <th>Recipe Name<span class="asterisk"> *</span></th>
                                                        <td colspan="3">
                                                            <asp:TextBox ID="txt_Recipe_Name_qa" runat="server" Width="80%" />
                                                            <asp:Button class="btn btn-add btn-xs btn-inverse m-r-5" ID="btn_Recipe_Name_NA_qa" runat="server" Width="15%" Text="N/A" OnClick="Recipe_Name_NA_Click" />
                                                            <asp:RequiredFieldValidator ID="rfv_lda_032" runat="server" ErrorMessage="항목 누락" ForeColor="Red" ValidationGroup="val_chk_qa" Display="Dynamic" ControlToValidate="txt_Recipe_Name_qa" />
                                                        </td>
                                                    </tr>
                                                </tbody>
                                            </table>
                                        </div>

                                        <h5 style="color: #438EB9" id="title_material_information_qa" runat="server">Material Information</h5>
                                        <div class="row" style="margin-top: 10px;">
                                            <table class="table table-lotInfo use-head" id="tb_material_information_qa" runat="server">
                                                <colgroup>
                                                    <col style="width: 14%; background-color: #f6f6f6;" />
                                                    <col style="width: 17.2%;" />
                                                    <col style="width: 17.2%;" />
                                                    <col style="width: 17.2%;" />
                                                    <col style="width: 17.2%;" />
                                                    <col style="width: 17.2%;" />
                                                </colgroup>
                                                <tbody>
                                                    <tr>
                                                        <th></th>
                                                        <th style="text-align:center;">System1</th>
                                                        <th style="text-align:center;">System2</th>
                                                        <th style="text-align:center;">System3</th>
                                                        <th style="text-align:center;">System4</th>
                                                        <th style="text-align:center;">Lid</th>
                                                    </tr>
                                                    <tr>
                                                        <th>Information</th>
                                                        <td><asp:TextBox ID="txt_sys1_information_qa" runat="server" class="form-control" placeholder="자동생성" ReadOnly="True" /></td>
                                                        <td><asp:TextBox ID="txt_sys2_information_qa" runat="server" class="form-control" placeholder="자동생성" ReadOnly="True" /></td>
                                                        <td><asp:TextBox ID="txt_sys3_information_qa" runat="server" class="form-control" placeholder="자동생성" ReadOnly="True" /></td>
                                                        <td><asp:TextBox ID="txt_sys4_information_qa" runat="server" class="form-control" placeholder="자동생성" ReadOnly="True" /></td>
                                                        <td><asp:TextBox ID="txt_lid_information_qa" runat="server" class="form-control" placeholder="자동생성" ReadOnly="True" /></td>
                                                    </tr>
                                                    <tr>
                                                        <th>Batch No</th>
                                                        <td>
                                                            <asp:TextBox ID="txt_sys1_batch_no_qa" runat="server" class="form-control" Style="width:65%;display:inline-block;text-transform:uppercase;" AutoPostBack="True" OnTextChanged="txt_sys1_batch_no_qa_TextChanged" />
                                                            <asp:Button class="btn btn-add btn-xs btn-inverse" ID="btn_sys1_na_qa" runat="server" Width="30%" Text="N/A" OnClick="btn_sys1_na_qa_Click" />
                                                        </td>
                                                        <td>
                                                            <asp:TextBox ID="txt_sys2_batch_no_qa" runat="server" class="form-control" Style="width:65%;display:inline-block;text-transform:uppercase;" AutoPostBack="True" OnTextChanged="txt_sys2_batch_no_qa_TextChanged" />
                                                            <asp:Button class="btn btn-add btn-xs btn-inverse" ID="btn_sys2_na_qa" runat="server" Width="30%" Text="N/A" OnClick="btn_sys2_na_qa_Click" />
                                                        </td>
                                                        <td>
                                                            <asp:TextBox ID="txt_sys3_batch_no_qa" runat="server" class="form-control" Style="width:65%;display:inline-block;text-transform:uppercase;" AutoPostBack="True" OnTextChanged="txt_sys3_batch_no_qa_TextChanged" />
                                                            <asp:Button class="btn btn-add btn-xs btn-inverse" ID="btn_sys3_na_qa" runat="server" Width="30%" Text="N/A" OnClick="btn_sys3_na_qa_Click" />
                                                        </td>
                                                        <td>
                                                            <asp:TextBox ID="txt_sys4_batch_no_qa" runat="server" class="form-control" Style="width:65%;display:inline-block;text-transform:uppercase;" AutoPostBack="True" OnTextChanged="txt_sys4_batch_no_qa_TextChanged" />
                                                            <asp:Button class="btn btn-add btn-xs btn-inverse" ID="btn_sys4_na_qa" runat="server" Width="30%" Text="N/A" OnClick="btn_sys4_na_qa_Click" />
                                                        </td>
                                                        <td>
                                                            <asp:TextBox ID="txt_lid_batch_no_qa" runat="server" class="form-control" Style="text-transform: uppercase;" AutoPostBack="True" OnTextChanged="txt_lid_batch_no_qa_TextChanged" />
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <th>SAP Code</th>
                                                        <td><asp:TextBox ID="txt_sys1_sap_code_qa" runat="server" class="form-control" placeholder="자동생성" ReadOnly="True" /></td>
                                                        <td><asp:TextBox ID="txt_sys2_sap_code_qa" runat="server" class="form-control" placeholder="자동생성" ReadOnly="True" /></td>
                                                        <td><asp:TextBox ID="txt_sys3_sap_code_qa" runat="server" class="form-control" placeholder="자동생성" ReadOnly="True" /></td>
                                                        <td><asp:TextBox ID="txt_sys4_sap_code_qa" runat="server" class="form-control" placeholder="자동생성" ReadOnly="True" /></td>
                                                        <td></td>
                                                    </tr>
                                                    <tr>
                                                        <th>Expire Time</th>
                                                        <td><telerik:RadDateTimePicker ID="tp_sys1_expire_time_qa" runat="server" TodayButtonVisibility="Visible" class="form-control" DateInput-DateFormat="yyyy-MM-dd HH:mm:ss" Style="width: 100%" /></td>
                                                        <td><telerik:RadDateTimePicker ID="tp_sys2_expire_time_qa" runat="server" TodayButtonVisibility="Visible" class="form-control" DateInput-DateFormat="yyyy-MM-dd HH:mm:ss" Style="width: 100%" /></td>
                                                        <td><telerik:RadDateTimePicker ID="tp_sys3_expire_time_qa" runat="server" TodayButtonVisibility="Visible" class="form-control" DateInput-DateFormat="yyyy-MM-dd HH:mm:ss" Style="width: 100%" /></td>
                                                        <td><telerik:RadDateTimePicker ID="tp_sys4_expire_time_qa" runat="server" TodayButtonVisibility="Visible" class="form-control" DateInput-DateFormat="yyyy-MM-dd HH:mm:ss" Style="width: 100%" /></td>
                                                        <td></td>
                                                    </tr>
                                                </tbody>
                                            </table>
                                        </div>

                                        <h5 style="color: #438EB9">Measurement Information</h5>

                                        <%-- Set-Up Measurement Panel --%>
                                        <asp:Panel ID="pnl_measure_setup_qa" runat="server" Visible="true">
                                        <div class="row" style="margin-top: 10px;">
                                            <table class="table table-lotInfo use-head">
                                                <colgroup>
                                                    <col class="col-label" />
                                                    <col class="col-value" />
                                                    <col class="col-label" />
                                                    <col class="col-value" />
                                                </colgroup>
                                                <tbody>
                                                    <tr>
                                                        <th>TIM Pattern</th>
                                                        <td colspan="3">
                                                            <telerik:RadDropDownList ID="ddl_tim_pattern_setup_qa" runat="server" BackColor="#f0f0f0">
                                                                <Items>
                                                                    <telerik:DropDownListItem Text="OK" Value="OK" />
                                                                    <telerik:DropDownListItem Text="N/A" Value="N/A" />
                                                                </Items>
                                                            </telerik:RadDropDownList>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <th>Glue Pattern</th>
                                                        <td colspan="3">
                                                            <telerik:RadDropDownList ID="ddl_glue_pattern_setup_qa" runat="server" BackColor="#f0f0f0">
                                                                <Items>
                                                                    <telerik:DropDownListItem Text="OK" Value="OK" />
                                                                    <telerik:DropDownListItem Text="N/A" Value="N/A" />
                                                                </Items>
                                                            </telerik:RadDropDownList>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <th>Dummy Coverage</th>
                                                        <td colspan="3">
                                                            <asp:TextBox ID="txt_dummy_coverage_qa" runat="server" class="form-control" Style="width:30%;display:inline-block;" />
                                                            <span style="margin: 0 5px;">UNIT</span>
                                                            <telerik:RadDropDownList ID="ddl_detach_qa" runat="server" BackColor="#f0f0f0">
                                                                <Items>
                                                                    <telerik:DropDownListItem Text="Detach" Value="Detach" />
                                                                    <telerik:DropDownListItem Text="Non-Detach" Value="Non-Detach" />
                                                                </Items>
                                                            </telerik:RadDropDownList>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <th>Buy-off Result</th>
                                                        <td colspan="3">
                                                            <telerik:RadDropDownList ID="ddl_buyoff_result_setup_qa" runat="server" BackColor="#f0f0f0">
                                                                <Items>
                                                                    <telerik:DropDownListItem Text="PASS" Value="PASS" />
                                                                    <telerik:DropDownListItem Text="FAIL" Value="FAIL" />
                                                                </Items>
                                                            </telerik:RadDropDownList>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <th>Remark</th>
                                                        <td colspan="3">
                                                            <asp:TextBox ID="txt_remark_setup_qa" runat="server" class="form-control" />
                                                        </td>
                                                    </tr>
                                                </tbody>
                                            </table>
                                        </div>
                                        </asp:Panel>

                                        <%-- Visual Monitor Measurement Panel --%>
                                        <asp:Panel ID="pnl_measure_vm_qa" runat="server" Visible="false">
                                        <div class="row" style="margin-top: 10px;">
                                            <table class="table table-lotInfo use-head">
                                                <colgroup>
                                                    <col class="col-label" />
                                                    <col class="col-value" />
                                                    <col class="col-label" />
                                                    <col class="col-value" />
                                                </colgroup>
                                                <tbody>
                                                    <tr>
                                                        <th>TIM Pattern</th>
                                                        <td colspan="3">
                                                            <telerik:RadDropDownList ID="ddl_tim_pattern_vm_qa" runat="server" BackColor="#f0f0f0">
                                                                <Items>
                                                                    <telerik:DropDownListItem Text="OK" Value="OK" />
                                                                    <telerik:DropDownListItem Text="N/A" Value="N/A" />
                                                                </Items>
                                                            </telerik:RadDropDownList>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <th>Glue Pattern</th>
                                                        <td colspan="3">
                                                            <telerik:RadDropDownList ID="ddl_glue_pattern_vm_qa" runat="server" BackColor="#f0f0f0">
                                                                <Items>
                                                                    <telerik:DropDownListItem Text="OK" Value="OK" />
                                                                    <telerik:DropDownListItem Text="N/A" Value="N/A" />
                                                                </Items>
                                                            </telerik:RadDropDownList>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <th>Strip No</th>
                                                        <td colspan="3">
                                                            <asp:TextBox ID="txt_strip_no_qa" runat="server" class="form-control" />
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <th>Visual</th>
                                                        <td colspan="3">
                                                            <asp:TextBox ID="txt_visual_qa" runat="server" class="form-control" Style="width:30%;display:inline-block;" />
                                                            <telerik:RadDropDownList ID="ddl_visual_type_qa" runat="server" BackColor="#f0f0f0">
                                                                <Items>
                                                                    <telerik:DropDownListItem Text="Strip" Value="Strip" />
                                                                </Items>
                                                            </telerik:RadDropDownList>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <th>Buy-off Result</th>
                                                        <td colspan="3">
                                                            <telerik:RadDropDownList ID="ddl_buyoff_result_vm_qa" runat="server" BackColor="#f0f0f0">
                                                                <Items>
                                                                    <telerik:DropDownListItem Text="PASS" Value="PASS" />
                                                                    <telerik:DropDownListItem Text="FAIL" Value="FAIL" />
                                                                </Items>
                                                            </telerik:RadDropDownList>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <th>Remark</th>
                                                        <td colspan="3">
                                                            <asp:TextBox ID="txt_remark_vm_qa" runat="server" class="form-control" />
                                                        </td>
                                                    </tr>
                                                </tbody>
                                            </table>
                                        </div>
                                        </asp:Panel>

                                        <div class="row" style="margin-bottom: 30px;">
                                            <div class="col-xs-12">
                                                <div class="text-center">
                                                    <button type="submit" id="btn_save_qa" class="btn btn-primary" runat="server" onserverclick="btn_save_qa_Click">
                                                        <span class="glyphicon glyphicon-ok"></span>&nbsp;&nbsp;등 록
                                                    </button>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </ContentTemplate>
                            <Triggers>
                                <asp:PostBackTrigger ControlID="btn_save_qa" />
                            </Triggers>
                        </asp:UpdatePanel>
                    </telerik:RadPageView>

                    <%-- ==================== Searching ==================== --%>
                    <telerik:RadPageView runat="server" ID="RadPageView4">
                        <asp:UpdatePanel ID="UpdatePanel3" runat="server">
                            <ContentTemplate>
                                <div class="panel panel-default" style="margin-top: 20px;">
                                    <div class="panel-body">
                                        <h4 style="color: #438EB9">조회</h4>
                                        <div class="row" style="margin-top: 10px;">
                                            <table class="table table-lotInfo use-head">
                                                <colgroup>
                                                    <col class="col-label" />
                                                    <col class="col-value" />
                                                    <col class="col-label" />
                                                    <col class="col-value" />
                                                </colgroup>
                                                <tbody>
                                                    <tr>
                                                        <th>E-Log Sheet</th>
                                                        <td>
                                                            <asp:RadioButton ID="rb_prd" runat="server" Text="PRD" AutoPostBack="True" Checked="True" GroupName="ELog_Select" OnCheckedChanged="rb_prd_CheckedChanged" />
                                                            <asp:RadioButton ID="rb_tech" runat="server" Text="TECH" AutoPostBack="True" GroupName="ELog_Select" OnCheckedChanged="rb_tech_CheckedChanged" />
                                                            <asp:RadioButton ID="rb_qa" runat="server" Text="QA" AutoPostBack="True" GroupName="ELog_Select" OnCheckedChanged="rb_qa_CheckedChanged" />
                                                        </td>
                                                        <th></th>
                                                        <td>
                                                            <asp:HiddenField ID="HiddenField1" runat="server" />
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <th>From</th>
                                                        <td>
                                                            <telerik:RadDatePicker ID="date_from" Style="width: 100%" runat="server" />
                                                        </td>
                                                        <th>To</th>
                                                        <td>
                                                            <telerik:RadDatePicker ID="date_to" Style="width: 100%" runat="server" />
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <th>LOT ID</th>
                                                        <td>
                                                            <asp:TextBox ID="txt_LotId_Search" runat="server" class="form-control" Style="text-transform: uppercase;" />
                                                        </td>
                                                        <th>MC NO.</th>
                                                        <td>
                                                            <asp:TextBox ID="txt_McNo_Search" runat="server" class="form-control" Style="text-transform: uppercase;" />
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <th>User ID</th>
                                                        <td>
                                                            <asp:TextBox ID="txt_userId_Search" runat="server" class="form-control" Style="text-transform: uppercase;" />
                                                        </td>
                                                        <th>Recipe name</th>
                                                        <td>
                                                            <asp:TextBox ID="txt_recipe_name_Search" runat="server" class="form-control" Style="text-transform: uppercase;" />
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <th>Customer</th>
                                                        <td>
                                                            <asp:TextBox ID="txt_custormer_Search" runat="server" class="form-control" Style="text-transform: uppercase;" />
                                                        </td>
                                                        <th>Device</th>
                                                        <td>
                                                            <asp:TextBox ID="txt_device_Search" runat="server" class="form-control" Style="text-transform: uppercase;" />
                                                        </td>
                                                    </tr>
                                                </tbody>
                                            </table>
                                            <div class="row" style="margin-top: 20px;">
                                                <div class="col-xs-12">
                                                    <div class="text-center">
                                                        <button type="button" id="btn_option_reset" class="btn btn-success" runat="server" onserverclick="btn_option_reset_Click">
                                                            <span class="glyphicon glyphicon-ok"></span>&nbsp;&nbsp;조건 초기화
                                                        </button>
                                                        <button type="button" id="btn_find" class="btn btn-primary" runat="server" onserverclick="btn_find_Click">
                                                            <span class="glyphicon glyphicon-ok"></span>&nbsp;&nbsp;조 회
                                                        </button>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="panel panel-default">
                                    <div class="panel-body">
                                        <div class="widget-box">
                                            <div class="widget-header widget-header-flat">
                                                <h4 class="widget-title">Search Result</h4>
                                                <div class="widget-toolbar">
                                                    <asp:LinkButton ID="lBtn_excel" runat="server" Text='<i class="menu-icon fa fa-file-excel-o fa-lg"></i>' OnClick="LinkButton_Click" />
                                                </div>
                                            </div>
                                            <div class="widget-body">
                                                <div class="widget-main">
                                                    <telerik:RadGrid runat="server" ID="rgv_List"
                                                        OnDeleteCommand="rgv_List_DeleteCommand"
                                                        AllowSorting="True" Culture="ko-KR" AllowPaging="True" Skin="Metro"
                                                        AutoGenerateColumns="False"
                                                        OnNeedDataSource="rgv_List_NeedDataSource"
                                                        GroupPanelPosition="Top" CellSpacing="-1" GridLines="Both">
                                                        <ExportSettings>
                                                            <Excel Format="Xlsx" />
                                                        </ExportSettings>
                                                        <ClientSettings>
                                                            <Selecting AllowRowSelect="True" />
                                                            <Scrolling AllowScroll="True" UseStaticHeaders="True" />
                                                        </ClientSettings>
                                                        <MasterTableView DataKeyNames="SEQ">
                                                            <Columns>
                                                                <telerik:GridButtonColumn CommandName="Delete" Text="Detail" ButtonType="ImageButton"
                                                                    UniqueName="DeleteColumn" HeaderText="Delete"
                                                                    ConfirmText="정말 삭제하시겠습니까?" ConfirmTitle="Delete" ConfirmDialogType="Classic">
                                                                    <ItemStyle HorizontalAlign="Center" CssClass="MyImageButton" />
                                                                </telerik:GridButtonColumn>
                                                            </Columns>
                                                        </MasterTableView>
                                                        <HeaderStyle Width="10em" />
                                                    </telerik:RadGrid>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </ContentTemplate>
                            <Triggers>
                                <asp:PostBackTrigger ControlID="btn_option_reset" />
                                <asp:PostBackTrigger ControlID="btn_find" />
                                <asp:PostBackTrigger ControlID="lBtn_excel" />
                            </Triggers>
                        </asp:UpdatePanel>
                    </telerik:RadPageView>
                </telerik:RadMultiPage>
            </div>
        </div>
    </form>
</asp:Content>

<asp:Content ID="Content1" ContentPlaceHolderID="contentScript" runat="Server">
    <script type="text/javascript">
        function formatDate(dt) {
            var pad = function (n) { return (n < 10 ? '0' + n : '' + n); };
            return dt.getFullYear() + '-' + pad(dt.getMonth() + 1) + '-' + pad(dt.getDate())
                + ' ' + pad(dt.getHours()) + ':' + pad(dt.getMinutes()) + ':' + pad(dt.getSeconds());
        }
        function wireHandlers() {
            if ($.fn.button) {
                $("#setInNowTime_qa, #setInNowTime_tech, #setInNowTime_prod").button();
            }
            $("#setInNowTime_qa").off("click.setnow").on("click.setnow", function () {
                var picker = $find("<%= tp_InputTime_qa.ClientID %>");
                if (picker && picker.set_selectedDate) picker.set_selectedDate(new Date());
                else $("#<%= tp_InputTime_qa.ClientID %>").val(formatDate(new Date()));
            });
            $("#setInNowTime_tech").off("click.setnow").on("click.setnow", function () {
                var picker = $find("<%= tp_InputTime_tech.ClientID %>");
                if (picker && picker.set_selectedDate) picker.set_selectedDate(new Date());
                else $("#<%= tp_InputTime_tech.ClientID %>").val(formatDate(new Date()));
            });
            $("#setInNowTime_prod").off("click.setnow").on("click.setnow", function () {
                var picker = $find("<%= tp_InputTime_prod.ClientID %>");
                if (picker && picker.set_selectedDate) picker.set_selectedDate(new Date());
                else $("#<%= tp_InputTime_prod.ClientID %>").val(formatDate(new Date()));
            });
        }
        if (window.Sys && Sys.Application) {
            Sys.Application.add_load(wireHandlers);
        } else {
            $(wireHandlers);
        }
    </script>
</asp:Content>
