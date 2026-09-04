<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Mold.aspx.cs" Inherits="Data_modify.Mold" %>
<%@ Import Namespace="System" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Web" %>
<%@ Import Namespace="System.Web.UI.WebControls" %>
<%@ Import Namespace="System.Configuration" %>
<%@ Import Namespace="System.Data.OracleClient" %>
<script runat="server">

    // ------------------------------------------------------------------
    //  .aspx.cs 원본 소스가 없어(구버전 배포) 코드비하인드를 수정할 수 없어
    //  마크업(.aspx) 안에 인라인 서버 스크립트로 삭제 알림메일 기능을 추가한다.
    //  ASP.NET 은 CodeBehind 방식이어도 요청 시 이 .aspx 를
    //  Inherits="Data_modify.Mold" 를 상속하는 클래스로 동적 컴파일하므로,
    //  여기 작성한 메서드가 그 파생 클래스의 멤버로 그대로 포함된다.
    //  (기존 배포된 Mold.aspx.cs/DLL 은 전혀 건드리지 않는다)
    //
    //  실제 web.config 를 확인한 결과 이 사이트는 System.Data.OracleClient(구 MS 내장 드라이버)
    //  + <connectionStrings> 방식을 쓴다 (appSettings 아님). MoldConnectionString 등과 동일한 방식.
    // ------------------------------------------------------------------

    private const string MAIL_CONSTR_KEY = "rtsConnectionString";
    private const string MAIL_MODE = "MOLD_DEL:";

    protected void GridView1_RowDeleted(object sender, GridViewDeletedEventArgs e)
    {
        if (e.Exception != null || e.AffectedRows <= 0)
        {
            return;
        }

        string equipId = GetDeletedValue(e, "MACHINE_ID");
        string lotId = GetDeletedValue(e, "LOTID");

        if (equipId.Length == 0 && lotId.Length == 0)
        {
            return;
        }

        try
        {
            SendDeletedMoldMail(equipId, lotId);
        }
        catch (Exception ex)
        {
            System.Diagnostics.Trace.Write("RTS.KSY_SEND_MAIL(MOLD_DEL) FAIL : " + ex.Message);
        }
    }

    private static string GetDeletedValue(GridViewDeletedEventArgs e, string fieldName)
    {
        object value = null;

        if (e.Keys != null)
        {
            value = e.Keys[fieldName];
        }

        if (value == null && e.Values != null)
        {
            value = e.Values[fieldName];
        }

        if (value == null)
        {
            return string.Empty;
        }

        return HttpUtility.HtmlDecode(Convert.ToString(value)).Replace('\u00A0', ' ').Trim();
    }

    private static void SendDeletedMoldMail(string equipId, string lotId)
    {
        ConnectionStringSettings setting = ConfigurationManager.ConnectionStrings[MAIL_CONSTR_KEY];

        if (setting == null)
        {
            throw new ConfigurationErrorsException(MAIL_CONSTR_KEY + " 가 web.config <connectionStrings> 에 없습니다.");
        }

        string pMode = MAIL_MODE
                     + equipId.Replace("|", "").Replace(";", "")
                     + "|"
                     + lotId.Replace("|", "").Replace(";", "");

        using (OracleConnection conn = new OracleConnection(setting.ConnectionString))
        using (OracleCommand cmd = new OracleCommand("RTS.KSY_SEND_MAIL", conn))
        {
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add(new OracleParameter("P_MODE", pMode));

            conn.Open();
            cmd.ExecuteNonQuery();
        }
    }

</script>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <style type="text/css">

        .style4
        {
            height: 32px;
        }
        .style3
        {
            width: 226px;
        }
        </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <p>
        <table id="Table1" border="0" cellpadding="1" cellspacing="1" 
            style="WIDTH: 875px; HEIGHT: 72px" width="875">
            <tr>
                <td colspan="2" class="style4">
                    <font color="#4169e1" face="Tahoma" size="2">Mold Data 수정 및 삭제</font></td>
            </tr>
            <tr>
                <td class="style3" style="color: #FF0000">
                    Lot ID</td>
                <td>
                    <asp:TextBox ID="txtLotID" runat="server" AutoPostBack="True" 
                        BackColor="#FFFFCC" BorderColor="#8080FF" BorderWidth="1px" 
                        CssClass="RptTextBox_NoEdit" Font-Names="Tahoma" Font-Size="Small" tabIndex="1" 
                        Width="232px"></asp:TextBox>
                </td>
            </tr>
            </table>
        <asp:GridView ID="GridView1" runat="server" 
            AutoGenerateColumns="False" BackColor="White" BorderColor="#DEDFDE" 
            BorderStyle="None" BorderWidth="1px" CellPadding="4" DataKeyNames="SEQ" 
            DataSourceID="SqlDataSource1" ForeColor="Black" GridLines="Vertical" 
            Font-Names="Tahoma" Font-Size="X-Small" 
            OnRowDeleted="GridView1_RowDeleted">
            <AlternatingRowStyle BackColor="White" />
            <Columns>
                <asp:CommandField CancelText="Cancel" DeleteText="Delete" EditText="Edit" 
                    InsertText="Insert" NewText="New" SelectText="Select" ShowDeleteButton="True" 
                    ShowEditButton="True" UpdateText="Update" />
                <asp:BoundField DataField="SITENAME" HeaderText="SITENAME" 
                    SortExpression="SITENAME" />
                <asp:BoundField DataField="ELOGSHEET_TYPE" HeaderText="ELOGSHEET_TYPE" 
                    SortExpression="ELOGSHEET_TYPE" />
                <asp:BoundField DataField="MACHINE_ID" HeaderText="MACHINE_ID" 
                    SortExpression="MACHINE_ID" />
                <asp:BoundField DataField="LOTID" HeaderText="LOTID" 
                    SortExpression="LOTID" />
                <asp:BoundField DataField="PKG_TYPE" HeaderText="PKG_TYPE" 
                    SortExpression="PKG_TYPE" />
                <asp:BoundField DataField="PKG_BODY_SIZE" HeaderText="PKG_BODY_SIZE" 
                    SortExpression="PKG_BODY_SIZE" />
                <asp:BoundField DataField="CUST_NAME" HeaderText="CUST_NAME" 
                    SortExpression="CUST_NAME" />
                <asp:BoundField DataField="DEVICE_NO" HeaderText="DEVICE_NO" 
                    SortExpression="DEVICE_NO" />
                <asp:BoundField DataField="LOT_QTY" HeaderText="LOT_QTY" 
                    SortExpression="LOT_QTY" />
                <asp:BoundField DataField="MCOMP_PART_NO" HeaderText="MCOMP_PART_NO" 
                    SortExpression="MCOMP_PART_NO" />
                <asp:BoundField DataField="MCOMP_BATCH_LOT" HeaderText="MCOMP_BATCH_LOT" 
                    SortExpression="MCOMP_BATCH_LOT" />
                <asp:BoundField DataField="MCOMP_EXP_DATE" HeaderText="MCOMP_EXP_DATE" 
                    SortExpression="MCOMP_EXP_DATE" />
                <asp:BoundField DataField="MOLD_CHASE_NO1" HeaderText="MOLD_CHASE_NO1" 
                    SortExpression="MOLD_CHASE_NO1" />
                <asp:BoundField DataField="MOLD_CHASE_NO2" HeaderText="MOLD_CHASE_NO2" 
                    SortExpression="MOLD_CHASE_NO2" />
                <asp:BoundField DataField="MOLD_CHASE_NO3" HeaderText="MOLD_CHASE_NO3" 
                    SortExpression="MOLD_CHASE_NO3" />
                <asp:BoundField DataField="MOLD_CHASE_NO4" HeaderText="MOLD_CHASE_NO4" 
                    SortExpression="MOLD_CHASE_NO4" />
                <asp:BoundField DataField="STRIPS_QTY" HeaderText="STRIPS_QTY" 
                    SortExpression="STRIPS_QTY" />
                <asp:BoundField DataField="TIME_CHECKED" HeaderText="TIME_CHECKED" 
                    SortExpression="TIME_CHECKED" />
                <asp:BoundField DataField="EMPID" HeaderText="EMPID" 
                    SortExpression="EMPID" />
                <asp:BoundField DataField="CHASE1_SHEET_CLEAN" HeaderText="CHASE1_SHEET_CLEAN" 
                    SortExpression="CHASE1_SHEET_CLEAN" />
                <asp:BoundField DataField="CHASE2_SHEET_CLEAN" HeaderText="CHASE2_SHEET_CLEAN" 
                    SortExpression="CHASE2_SHEET_CLEAN" />
                <asp:BoundField DataField="CHASE3_SHEET_CLEAN" HeaderText="CHASE3_SHEET_CLEAN" 
                    SortExpression="CHASE3_SHEET_CLEAN" />
                <asp:BoundField DataField="CHASE4_SHEET_CLEAN" HeaderText="CHASE4_SHEET_CLEAN" 
                    SortExpression="CHASE4_SHEET_CLEAN" />
                <asp:BoundField DataField="CHASE1_DUMMY" HeaderText="CHASE1_DUMMY" 
                    SortExpression="CHASE1_DUMMY" />
                <asp:BoundField DataField="CHASE2_DUMMY" HeaderText="CHASE2_DUMMY" 
                    SortExpression="CHASE2_DUMMY" />
                <asp:BoundField DataField="CHASE3_DUMMY" HeaderText="CHASE3_DUMMY" 
                    SortExpression="CHASE3_DUMMY" />
                <asp:BoundField DataField="CHASE4_DUMMY" HeaderText="CHASE4_DUMMY" 
                    SortExpression="CHASE4_DUMMY" />
                <asp:BoundField DataField="MOLD_CLEAN_START" HeaderText="MOLD_CLEAN_START" 
                    SortExpression="MOLD_CLEAN_START" />
                <asp:BoundField DataField="MOLD_CLEAN_END" HeaderText="MOLD_CLEAN_END" 
                    SortExpression="MOLD_CLEAN_END" />
                <asp:BoundField DataField="MOLD_CLEAN_TIME" HeaderText="MOLD_CLEAN_TIME" 
                    SortExpression="MOLD_CLEAN_TIME" />
                <asp:BoundField DataField="PPID" HeaderText="PPID" 
                    SortExpression="PPID" />
                <asp:BoundField DataField="TRANSFER_TIME" HeaderText="TRANSFER_TIME" 
                    SortExpression="TRANSFER_TIME" />
                <asp:BoundField DataField="CURE_TIME" HeaderText="CURE_TIME" 
                    SortExpression="CURE_TIME" />
                <asp:BoundField DataField="VMI_FLASH_BLEED" HeaderText="VMI_FLASH_BLEED" 
                    SortExpression="VMI_FLASH_BLEED" />
                <asp:BoundField DataField="VMI_INCOMPLETE_FILL" HeaderText="VMI_INCOMPLETE_FILL" 
                    SortExpression="VMI_INCOMPLETE_FILL" />
                <asp:BoundField DataField="VMI_CONTAMINATION" 
                    HeaderText="VMI_CONTAMINATION" SortExpression="VMI_CONTAMINATION" />
                <asp:BoundField DataField="VMI_VOIDS" HeaderText="VMI_VOIDS" 
                    SortExpression="VMI_VOIDS" />
                <asp:BoundField DataField="VMI_DENT" HeaderText="VMI_DENT" 
                    SortExpression="VMI_DENT" />
                <asp:BoundField DataField="VMI_PKG_CRACK" HeaderText="VMI_PKG_CRACK" 
                    SortExpression="VMI_PKG_CRACK" />
                <asp:BoundField DataField="VMI_GATE_REMAIN" HeaderText="VMI_GATE_REMAIN" 
                    SortExpression="VMI_GATE_REMAIN" />
                <asp:BoundField DataField="VMI_PKG_OFFSET" HeaderText="VMI_PKG_OFFSET" 
                    SortExpression="VMI_PKG_OFFSET" />
                <asp:BoundField DataField="VMI_WIRE_DEFFECTS" HeaderText="VMI_WIRE_DEFFECTS" 
                    SortExpression="VMI_WIRE_DEFFECTS" />
                <asp:BoundField DataField="VMI_MISALIGN" HeaderText="VMI_MISALIGN" 
                    SortExpression="VMI_MISALIGN" />
                <asp:BoundField DataField="VMI_FOL_REJECT" HeaderText="VMI_FOL_REJECT" 
                    SortExpression="VMI_FOL_REJECT" />
                <asp:BoundField DataField="VMI_OTHERS" HeaderText="VMI_OTHERS" 
                    SortExpression="VMI_OTHERS" />
                <asp:BoundField DataField="VMI_DEFECTS_QTY" HeaderText="VMI_DEFECTS_QTY" 
                    SortExpression="VMI_DEFECTS_QTY" />
                <asp:BoundField DataField="VMI_STATUS" HeaderText="VMI_STATUS" 
                    SortExpression="VMI_STATUS" />
                <asp:BoundField DataField="VMI_SAMPLE_SIZE" HeaderText="VMI_SAMPLE_SIZE" 
                    SortExpression="VMI_SAMPLE_SIZE" />
                <asp:BoundField DataField="BO" HeaderText="BO" 
                    SortExpression="BO" />
                <asp:BoundField DataField="REMARKS" HeaderText="REMARKS" 
                    SortExpression="REMARKS" />
                <asp:BoundField DataField="CHASE1_NOT_USED" HeaderText="CHASE1_NOT_USED" 
                    SortExpression="CHASE1_NOT_USED" />
                <asp:BoundField DataField="CHASE2_NOT_USED" HeaderText="CHASE2_NOT_USED" 
                    SortExpression="CHASE2_NOT_USED" />
                <asp:BoundField DataField="CHASE3_NOT_USED" HeaderText="CHASE3_NOT_USED" 
                    SortExpression="CHASE3_NOT_USED" />
                <asp:BoundField DataField="CHASE4_NOT_USED" HeaderText="CHASE4_NOT_USED" 
                    SortExpression="CHASE4_NOT_USED" />
                <asp:BoundField DataField="VMI_DELAMINATION" HeaderText="VMI_DELAMINATION" 
                    SortExpression="VMI_DELAMINATION" />
                <asp:BoundField DataField="EMC_USAGE_END" HeaderText="EMC_USAGE_END" 
                    SortExpression="EMC_USAGE_END" />
                <asp:BoundField DataField="LOT_END_TIME" HeaderText="LOT_END_TIME" 
                    SortExpression="LOT_END_TIME" />
                <asp:BoundField DataField="EMC_USAGE_START" HeaderText="EMC_USAGE_START" 
                    SortExpression="EMC_USAGE_START" />
                <asp:BoundField DataField="WIRE_SWEEPING2" HeaderText="WIRE_SWEEPING2" 
                    SortExpression="WIRE_SWEEPING2" />
                <asp:BoundField DataField="WIRE_SWEEPING3" HeaderText="WIRE_SWEEPING3" 
                    SortExpression="WIRE_SWEEPING3" />
                <asp:BoundField DataField="WIRE_SWEEPING4" HeaderText="WIRE_SWEEPING4" 
                    SortExpression="WIRE_SWEEPING4" />
                <asp:BoundField DataField="WIRE_SWEEPING1" HeaderText="WIRE_SWEEPING1" 
                    SortExpression="WIRE_SWEEPING1" />
                <asp:BoundField DataField="WIRE_SWEEPING5" HeaderText="WIRE_SWEEPING5" 
                    SortExpression="WIRE_SWEEPING5" />
                <asp:BoundField DataField="DAMAGED_WIRE" HeaderText="DAMAGED_WIRE" 
                    SortExpression="DAMAGED_WIRE" />
                <asp:BoundField DataField="SAGGING_WIRE" HeaderText="SAGGING_WIRE" 
                    SortExpression="SAGGING_WIRE" />
                <asp:BoundField DataField="OPEN_WIRE" HeaderText="OPEN_WIRE" 
                    SortExpression="OPEN_WIRE" />
                <asp:BoundField DataField="SHORT_WIRE" HeaderText="SHORT_WIRE" 
                    SortExpression="SHORT_WIRE" />
                <asp:BoundField DataField="ACTUAL_CLEANING_TIME" HeaderText="ACTUAL_CLEANING_TIME" 
                    SortExpression="ACTUAL_CLEANING_TIME" />
                <asp:BoundField DataField="CLEANING_REASON" HeaderText="CLEANING_REASON" 
                    SortExpression="CLEANING_REASON" />
                <asp:BoundField DataField="BRIDGE_BALL" HeaderText="BRIDGE_BALL" 
                    SortExpression="BRIDGE_BALL" />
                <asp:BoundField DataField="MISSING_BALL" HeaderText="MISSING_BALL" 
                    SortExpression="MISSING_BALL" />
                <asp:BoundField DataField="MOLD_TOP_NO1" HeaderText="MOLD_TOP_NO1" 
                    SortExpression="MOLD_TOP_NO1" />
                <asp:BoundField DataField="MOLD_TOP_NO2" HeaderText="MOLD_TOP_NO2" 
                    SortExpression="MOLD_TOP_NO2" />
                <asp:BoundField DataField="MOLD_TOP_NO4" HeaderText="MOLD_TOP_NO4" 
                    SortExpression="MOLD_TOP_NO4" />
                <asp:BoundField DataField="MOLD_BTM_NO1" HeaderText="MOLD_BTM_NO1" 
                    SortExpression="MOLD_BTM_NO1" />
                <asp:BoundField DataField="MOLD_BTM_NO2" HeaderText="MOLD_BTM_NO2" 
                    SortExpression="MOLD_BTM_NO2" />
                <asp:BoundField DataField="MOLD_BTM_NO3" HeaderText="MOLD_BTM_NO3" 
                    SortExpression="MOLD_BTM_NO3" />
                <asp:BoundField DataField="MOLD_TOP_NO3" HeaderText="MOLD_TOP_NO3" 
                    SortExpression="MOLD_TOP_NO3" />
                <asp:BoundField DataField="MOLD_BTM_NO4" HeaderText="MOLD_BTM_NO4" 
                    SortExpression="MOLD_BTM_NO4" />
                <asp:BoundField DataField="PIT" HeaderText="PIT" SortExpression="PIT" />
                <asp:BoundField DataField="BUBBLE" HeaderText="BUBBLE" 
                    SortExpression="BUBBLE" />
                <asp:BoundField DataField="MOLD_CAB" HeaderText="MOLD_CAB" 
                    SortExpression="MOLD_CAB" />
                <asp:BoundField DataField="PCB" HeaderText="PCB" SortExpression="PCB" />
                <asp:BoundField DataField="VACUUM_MONITOR1" HeaderText="VACUUM_MONITOR1" 
                    SortExpression="VACUUM_MONITOR1" />
                <asp:BoundField DataField="VACUUM_MONITOR3" HeaderText="VACUUM_MONITOR3" 
                    SortExpression="VACUUM_MONITOR3" />
                <asp:BoundField DataField="VACUUM_MONITOR2" HeaderText="VACUUM_MONITOR2" 
                    SortExpression="VACUUM_MONITOR2" />
                <asp:BoundField DataField="VACUUM_MONITOR4" HeaderText="VACUUM_MONITOR4" 
                    SortExpression="VACUUM_MONITOR4" />
                <asp:BoundField DataField="MCOMP_IQA" HeaderText="MCOMP_IQA" 
                    SortExpression="MCOMP_IQA" />
                <asp:BoundField DataField="CHASE1_RUBBER_WAX" HeaderText="CHASE1_RUBBER_WAX" 
                    SortExpression="CHASE1_RUBBER_WAX" />
                <asp:BoundField DataField="CHASE2_RUBBER_WAX" HeaderText="CHASE2_RUBBER_WAX" 
                    SortExpression="CHASE2_RUBBER_WAX" />
                <asp:BoundField DataField="CHASE3_RUBBER_WAX" HeaderText="CHASE3_RUBBER_WAX" 
                    SortExpression="CHASE3_RUBBER_WAX" />
                <asp:BoundField DataField="CHASE4_RUBBER_WAX" HeaderText="CHASE4_RUBBER_WAX" 
                    SortExpression="CHASE4_RUBBER_WAX" />
                <asp:BoundField DataField="AGING_TIME" HeaderText="AGING_TIME" 
                    SortExpression="AGING_TIME" />
                <asp:BoundField DataField="COMPOUND_TYPE" HeaderText="COMPOUND_TYPE" 
                    SortExpression="COMPOUND_TYPE" />
                <asp:BoundField DataField="PRE_HEAT_TIME" HeaderText="PRE_HEAT_TIME" 
                    SortExpression="PRE_HEAT_TIME" />
                <asp:BoundField DataField="VACCUM_PRESSURE" HeaderText="VACCUM_PRESSURE" 
                    SortExpression="VACCUM_PRESSURE" />
                <asp:BoundField DataField="FILM_BATCH1" HeaderText="FILM_BATCH1" 
                    SortExpression="FILM_BATCH1" />
                <asp:BoundField DataField="FILM_BATCH2" HeaderText="FILM_BATCH2" 
                    SortExpression="FILM_BATCH2" />
                <asp:BoundField DataField="FILM_BATCH3" HeaderText="FILM_BATCH3" 
                    SortExpression="FILM_BATCH3" />
                <asp:BoundField DataField="FILM_SAP1" HeaderText="FILM_SAP1" 
                    SortExpression="FILM_SAP1" />
                <asp:BoundField DataField="FILM_SAP2" HeaderText="FILM_SAP2" 
                    SortExpression="FILM_SAP2" />
                <asp:BoundField DataField="FILM_BATCH4" HeaderText="FILM_BATCH4" 
                    SortExpression="FILM_BATCH4" />
                <asp:BoundField DataField="FILM_SAP3" HeaderText="FILM_SAP3" 
                    SortExpression="FILM_SAP3" />
                <asp:BoundField DataField="FILM_SAP4" HeaderText="FILM_SAP4" 
                    SortExpression="FILM_SAP4" />
                <asp:BoundField DataField="PCB_THICKNESS2" HeaderText="PCB_THICKNESS2" 
                    SortExpression="PCB_THICKNESS2" />
                <asp:BoundField DataField="PCB_THICKNESS3" HeaderText="PCB_THICKNESS3" 
                    SortExpression="PCB_THICKNESS3" />
                <asp:BoundField DataField="PCB_THICKNESS4" HeaderText="PCB_THICKNESS4" 
                    SortExpression="PCB_THICKNESS4" />
                <asp:BoundField DataField="PCB_THICKNESS1" HeaderText="PCB_THICKNESS1" 
                    SortExpression="PCB_THICKNESS1" />
                <asp:BoundField DataField="MCOMP_BATCH_LOT2" HeaderText="MCOMP_BATCH_LOT2" 
                    SortExpression="MCOMP_BATCH_LOT2" />
                <asp:BoundField DataField="CLEANING_OPER_ID" HeaderText="CLEANING_OPER_ID" 
                    SortExpression="CLEANING_OPER_ID" />
                <asp:BoundField DataField="SEQ" HeaderText="SEQ" ReadOnly="True" 
                    SortExpression="SEQ" />
            </Columns>
            <FooterStyle BackColor="#CCCC99" />
            <HeaderStyle BackColor="#6B696B" Font-Bold="True" ForeColor="White" />
            <PagerStyle BackColor="#F7F7DE" ForeColor="Black" HorizontalAlign="Right" />
            <RowStyle BackColor="#F7F7DE" Wrap="False" />
            <SelectedRowStyle BackColor="#CE5D5A" Font-Bold="True" ForeColor="White" />
            <SortedAscendingCellStyle BackColor="#FBFBF2" />
            <SortedAscendingHeaderStyle BackColor="#848384" />
            <SortedDescendingCellStyle BackColor="#EAEAD3" />
            <SortedDescendingHeaderStyle BackColor="#575357" />
        </asp:GridView>
        <asp:SqlDataSource ID="SqlDataSource1" runat="server" 
            ConnectionString="<%$ ConnectionStrings:MoldConnectionString %>" 
            OldValuesParameterFormatString="original_{0}" 
            ProviderName="<%$ ConnectionStrings:MoldConnectionString.ProviderName %>" 
            SelectCommand="SELECT &quot;SITENAME&quot;, &quot;ELOGSHEET_TYPE&quot;, &quot;MACHINE_ID&quot;, &quot;LOTID&quot;, &quot;PKG_TYPE&quot;, &quot;PKG_BODY_SIZE&quot;, &quot;CUST_NAME&quot;, &quot;DEVICE_NO&quot;, &quot;LOT_QTY&quot;, &quot;MCOMP_PART_NO&quot;, &quot;MCOMP_BATCH_LOT&quot;, &quot;MCOMP_EXP_DATE&quot;, &quot;MOLD_CHASE_NO1&quot;, &quot;MOLD_CHASE_NO2&quot;, &quot;MOLD_CHASE_NO3&quot;, &quot;MOLD_CHASE_NO4&quot;, &quot;STRIPS_QTY&quot;, &quot;TIME_CHECKED&quot;, &quot;EMPID&quot;, &quot;CHASE1_SHEET_CLEAN&quot;, &quot;CHASE2_SHEET_CLEAN&quot;, &quot;CHASE3_SHEET_CLEAN&quot;, &quot;CHASE4_SHEET_CLEAN&quot;, &quot;CHASE1_DUMMY&quot;, &quot;CHASE2_DUMMY&quot;, &quot;CHASE3_DUMMY&quot;, &quot;CHASE4_DUMMY&quot;, &quot;MOLD_CLEAN_START&quot;, &quot;MOLD_CLEAN_END&quot;, &quot;MOLD_CLEAN_TIME&quot;, &quot;PPID&quot;, &quot;TRANSFER_TIME&quot;, &quot;CURE_TIME&quot;, &quot;VMI_FLASH_BLEED&quot;, &quot;VMI_INCOMPLETE_FILL&quot;, &quot;VMI_CONTAMINATION&quot;, &quot;VMI_VOIDS&quot;, &quot;VMI_DENT&quot;, &quot;VMI_PKG_CRACK&quot;, &quot;VMI_GATE_REMAIN&quot;, &quot;VMI_PKG_OFFSET&quot;, &quot;VMI_WIRE_DEFFECTS&quot;, &quot;VMI_MISALIGN&quot;, &quot;VMI_FOL_REJECT&quot;, &quot;VMI_OTHERS&quot;, &quot;VMI_DEFECTS_QTY&quot;, &quot;VMI_STATUS&quot;, &quot;VMI_SAMPLE_SIZE&quot;, &quot;BO&quot;, &quot;REMARKS&quot;, &quot;CHASE1_NOT_USED&quot;, &quot;CHASE2_NOT_USED&quot;, &quot;CHASE3_NOT_USED&quot;, &quot;CHASE4_NOT_USED&quot;, &quot;VMI_DELAMINATION&quot;, &quot;EMC_USAGE_END&quot;, &quot;LOT_END_TIME&quot;, &quot;EMC_USAGE_START&quot;, &quot;WIRE_SWEEPING2&quot;, &quot;WIRE_SWEEPING3&quot;, &quot;WIRE_SWEEPING4&quot;, &quot;WIRE_SWEEPING1&quot;, &quot;WIRE_SWEEPING5&quot;, &quot;DAMAGED_WIRE&quot;, &quot;SAGGING_WIRE&quot;, &quot;OPEN_WIRE&quot;, &quot;SHORT_WIRE&quot;, &quot;ACTUAL_CLEANING_TIME&quot;, &quot;CLEANING_REASON&quot;, &quot;BRIDGE_BALL&quot;, &quot;MISSING_BALL&quot;, &quot;MOLD_TOP_NO1&quot;, &quot;MOLD_TOP_NO2&quot;, &quot;MOLD_TOP_NO4&quot;, &quot;MOLD_BTM_NO1&quot;, &quot;MOLD_BTM_NO2&quot;, &quot;MOLD_BTM_NO3&quot;, &quot;MOLD_TOP_NO3&quot;, &quot;MOLD_BTM_NO4&quot;, &quot;PIT&quot;, &quot;BUBBLE&quot;, &quot;MOLD_CAB&quot;, &quot;PCB&quot;, &quot;VACUUM_MONITOR1&quot;, &quot;VACUUM_MONITOR3&quot;, &quot;VACUUM_MONITOR2&quot;, &quot;VACUUM_MONITOR4&quot;, &quot;MCOMP_IQA&quot;, &quot;CHASE1_RUBBER_WAX&quot;, &quot;CHASE2_RUBBER_WAX&quot;, &quot;CHASE3_RUBBER_WAX&quot;, &quot;CHASE4_RUBBER_WAX&quot;, &quot;AGING_TIME&quot;, &quot;COMPOUND_TYPE&quot;, &quot;PRE_HEAT_TIME&quot;, &quot;VACCUM_PRESSURE&quot;, &quot;FILM_BATCH1&quot;, &quot;FILM_BATCH2&quot;, &quot;FILM_BATCH3&quot;, &quot;FILM_SAP1&quot;, &quot;FILM_SAP2&quot;, &quot;FILM_BATCH4&quot;, &quot;FILM_SAP3&quot;, &quot;FILM_SAP4&quot;, &quot;PCB_THICKNESS2&quot;, &quot;PCB_THICKNESS3&quot;, &quot;PCB_THICKNESS4&quot;, &quot;PCB_THICKNESS1&quot;, &quot;MCOMP_BATCH_LOT2&quot;, &quot;CLEANING_OPER_ID&quot;, &quot;SEQ&quot; FROM &quot;PCSD_MOLD_ELOGSHEET&quot; WHERE (&quot;LOTID&quot; = :LOTID)" 
            ConflictDetection="CompareAllValues" 
            DeleteCommand="DELETE FROM &quot;PCSD_MOLD_ELOGSHEET&quot; WHERE &quot;SEQ&quot; = :original_SEQ AND ((&quot;SITENAME&quot; = :original_SITENAME) OR (&quot;SITENAME&quot; IS NULL AND :original_SITENAME IS NULL)) AND ((&quot;ELOGSHEET_TYPE&quot; = :original_ELOGSHEET_TYPE) OR (&quot;ELOGSHEET_TYPE&quot; IS NULL AND :original_ELOGSHEET_TYPE IS NULL)) AND ((&quot;MACHINE_ID&quot; = :original_MACHINE_ID) OR (&quot;MACHINE_ID&quot; IS NULL AND :original_MACHINE_ID IS NULL)) AND ((&quot;LOTID&quot; = :original_LOTID) OR (&quot;LOTID&quot; IS NULL AND :original_LOTID IS NULL)) AND ((&quot;PKG_TYPE&quot; = :original_PKG_TYPE) OR (&quot;PKG_TYPE&quot; IS NULL AND :original_PKG_TYPE IS NULL)) AND ((&quot;PKG_BODY_SIZE&quot; = :original_PKG_BODY_SIZE) OR (&quot;PKG_BODY_SIZE&quot; IS NULL AND :original_PKG_BODY_SIZE IS NULL)) AND ((&quot;CUST_NAME&quot; = :original_CUST_NAME) OR (&quot;CUST_NAME&quot; IS NULL AND :original_CUST_NAME IS NULL)) AND ((&quot;DEVICE_NO&quot; = :original_DEVICE_NO) OR (&quot;DEVICE_NO&quot; IS NULL AND :original_DEVICE_NO IS NULL)) AND ((&quot;LOT_QTY&quot; = :original_LOT_QTY) OR (&quot;LOT_QTY&quot; IS NULL AND :original_LOT_QTY IS NULL)) AND ((&quot;MCOMP_PART_NO&quot; = :original_MCOMP_PART_NO) OR (&quot;MCOMP_PART_NO&quot; IS NULL AND :original_MCOMP_PART_NO IS NULL)) AND ((&quot;MCOMP_BATCH_LOT&quot; = :original_MCOMP_BATCH_LOT) OR (&quot;MCOMP_BATCH_LOT&quot; IS NULL AND :original_MCOMP_BATCH_LOT IS NULL)) AND ((&quot;MCOMP_EXP_DATE&quot; = :original_MCOMP_EXP_DATE) OR (&quot;MCOMP_EXP_DATE&quot; IS NULL AND :original_MCOMP_EXP_DATE IS NULL)) AND ((&quot;MOLD_CHASE_NO1&quot; = :original_MOLD_CHASE_NO1) OR (&quot;MOLD_CHASE_NO1&quot; IS NULL AND :original_MOLD_CHASE_NO1 IS NULL)) AND ((&quot;MOLD_CHASE_NO2&quot; = :original_MOLD_CHASE_NO2) OR (&quot;MOLD_CHASE_NO2&quot; IS NULL AND :original_MOLD_CHASE_NO2 IS NULL)) AND ((&quot;MOLD_CHASE_NO3&quot; = :original_MOLD_CHASE_NO3) OR (&quot;MOLD_CHASE_NO3&quot; IS NULL AND :original_MOLD_CHASE_NO3 IS NULL)) AND ((&quot;MOLD_CHASE_NO4&quot; = :original_MOLD_CHASE_NO4) OR (&quot;MOLD_CHASE_NO4&quot; IS NULL AND :original_MOLD_CHASE_NO4 IS NULL)) AND ((&quot;STRIPS_QTY&quot; = :original_STRIPS_QTY) OR (&quot;STRIPS_QTY&quot; IS NULL AND :original_STRIPS_QTY IS NULL)) AND ((&quot;TIME_CHECKED&quot; = :original_TIME_CHECKED) OR (&quot;TIME_CHECKED&quot; IS NULL AND :original_TIME_CHECKED IS NULL)) AND ((&quot;EMPID&quot; = :original_EMPID) OR (&quot;EMPID&quot; IS NULL AND :original_EMPID IS NULL)) AND ((&quot;CHASE1_SHEET_CLEAN&quot; = :original_CHASE1_SHEET_CLEAN) OR (&quot;CHASE1_SHEET_CLEAN&quot; IS NULL AND :original_CHASE1_SHEET_CLEAN IS NULL)) AND ((&quot;CHASE2_SHEET_CLEAN&quot; = :original_CHASE2_SHEET_CLEAN) OR (&quot;CHASE2_SHEET_CLEAN&quot; IS NULL AND :original_CHASE2_SHEET_CLEAN IS NULL)) AND ((&quot;CHASE3_SHEET_CLEAN&quot; = :original_CHASE3_SHEET_CLEAN) OR (&quot;CHASE3_SHEET_CLEAN&quot; IS NULL AND :original_CHASE3_SHEET_CLEAN IS NULL)) AND ((&quot;CHASE4_SHEET_CLEAN&quot; = :original_CHASE4_SHEET_CLEAN) OR (&quot;CHASE4_SHEET_CLEAN&quot; IS NULL AND :original_CHASE4_SHEET_CLEAN IS NULL)) AND ((&quot;CHASE1_DUMMY&quot; = :original_CHASE1_DUMMY) OR (&quot;CHASE1_DUMMY&quot; IS NULL AND :original_CHASE1_DUMMY IS NULL)) AND ((&quot;CHASE2_DUMMY&quot; = :original_CHASE2_DUMMY) OR (&quot;CHASE2_DUMMY&quot; IS NULL AND :original_CHASE2_DUMMY IS NULL)) AND ((&quot;CHASE3_DUMMY&quot; = :original_CHASE3_DUMMY) OR (&quot;CHASE3_DUMMY&quot; IS NULL AND :original_CHASE3_DUMMY IS NULL)) AND ((&quot;CHASE4_DUMMY&quot; = :original_CHASE4_DUMMY) OR (&quot;CHASE4_DUMMY&quot; IS NULL AND :original_CHASE4_DUMMY IS NULL)) AND ((&quot;MOLD_CLEAN_START&quot; = :original_MOLD_CLEAN_START) OR (&quot;MOLD_CLEAN_START&quot; IS NULL AND :original_MOLD_CLEAN_START IS NULL)) AND ((&quot;MOLD_CLEAN_END&quot; = :original_MOLD_CLEAN_END) OR (&quot;MOLD_CLEAN_END&quot; IS NULL AND :original_MOLD_CLEAN_END IS NULL)) AND ((&quot;MOLD_CLEAN_TIME&quot; = :original_MOLD_CLEAN_TIME) OR (&quot;MOLD_CLEAN_TIME&quot; IS NULL AND :original_MOLD_CLEAN_TIME IS NULL)) AND ((&quot;PPID&quot; = :original_PPID) OR (&quot;PPID&quot; IS NULL AND :original_PPID IS NULL)) AND ((&quot;TRANSFER_TIME&quot; = :original_TRANSFER_TIME) OR (&quot;TRANSFER_TIME&quot; IS NULL AND :original_TRANSFER_TIME IS NULL)) AND ((&quot;CURE_TIME&quot; = :original_CURE_TIME) OR (&quot;CURE_TIME&quot; IS NULL AND :original_CURE_TIME IS NULL)) AND ((&quot;VMI_FLASH_BLEED&quot; = :original_VMI_FLASH_BLEED) OR (&quot;VMI_FLASH_BLEED&quot; IS NULL AND :original_VMI_FLASH_BLEED IS NULL)) AND ((&quot;VMI_INCOMPLETE_FILL&quot; = :original_VMI_INCOMPLETE_FILL) OR (&quot;VMI_INCOMPLETE_FILL&quot; IS NULL AND :original_VMI_INCOMPLETE_FILL IS NULL)) AND ((&quot;VMI_CONTAMINATION&quot; = :original_VMI_CONTAMINATION) OR (&quot;VMI_CONTAMINATION&quot; IS NULL AND :original_VMI_CONTAMINATION IS NULL)) AND ((&quot;VMI_VOIDS&quot; = :original_VMI_VOIDS) OR (&quot;VMI_VOIDS&quot; IS NULL AND :original_VMI_VOIDS IS NULL)) AND ((&quot;VMI_DENT&quot; = :original_VMI_DENT) OR (&quot;VMI_DENT&quot; IS NULL AND :original_VMI_DENT IS NULL)) AND ((&quot;VMI_PKG_CRACK&quot; = :original_VMI_PKG_CRACK) OR (&quot;VMI_PKG_CRACK&quot; IS NULL AND :original_VMI_PKG_CRACK IS NULL)) AND ((&quot;VMI_GATE_REMAIN&quot; = :original_VMI_GATE_REMAIN) OR (&quot;VMI_GATE_REMAIN&quot; IS NULL AND :original_VMI_GATE_REMAIN IS NULL)) AND ((&quot;VMI_PKG_OFFSET&quot; = :original_VMI_PKG_OFFSET) OR (&quot;VMI_PKG_OFFSET&quot; IS NULL AND :original_VMI_PKG_OFFSET IS NULL)) AND ((&quot;VMI_WIRE_DEFFECTS&quot; = :original_VMI_WIRE_DEFFECTS) OR (&quot;VMI_WIRE_DEFFECTS&quot; IS NULL AND :original_VMI_WIRE_DEFFECTS IS NULL)) AND ((&quot;VMI_MISALIGN&quot; = :original_VMI_MISALIGN) OR (&quot;VMI_MISALIGN&quot; IS NULL AND :original_VMI_MISALIGN IS NULL)) AND ((&quot;VMI_FOL_REJECT&quot; = :original_VMI_FOL_REJECT) OR (&quot;VMI_FOL_REJECT&quot; IS NULL AND :original_VMI_FOL_REJECT IS NULL)) AND ((&quot;VMI_OTHERS&quot; = :original_VMI_OTHERS) OR (&quot;VMI_OTHERS&quot; IS NULL AND :original_VMI_OTHERS IS NULL)) AND ((&quot;VMI_DEFECTS_QTY&quot; = :original_VMI_DEFECTS_QTY) OR (&quot;VMI_DEFECTS_QTY&quot; IS NULL AND :original_VMI_DEFECTS_QTY IS NULL)) AND ((&quot;VMI_STATUS&quot; = :original_VMI_STATUS) OR (&quot;VMI_STATUS&quot; IS NULL AND :original_VMI_STATUS IS NULL)) AND ((&quot;VMI_SAMPLE_SIZE&quot; = :original_VMI_SAMPLE_SIZE) OR (&quot;VMI_SAMPLE_SIZE&quot; IS NULL AND :original_VMI_SAMPLE_SIZE IS NULL)) AND ((&quot;BO&quot; = :original_BO) OR (&quot;BO&quot; IS NULL AND :original_BO IS NULL)) AND ((&quot;REMARKS&quot; = :original_REMARKS) OR (&quot;REMARKS&quot; IS NULL AND :original_REMARKS IS NULL)) AND ((&quot;CHASE1_NOT_USED&quot; = :original_CHASE1_NOT_USED) OR (&quot;CHASE1_NOT_USED&quot; IS NULL AND :original_CHASE1_NOT_USED IS NULL)) AND ((&quot;CHASE2_NOT_USED&quot; = :original_CHASE2_NOT_USED) OR (&quot;CHASE2_NOT_USED&quot; IS NULL AND :original_CHASE2_NOT_USED IS NULL)) AND ((&quot;CHASE3_NOT_USED&quot; = :original_CHASE3_NOT_USED) OR (&quot;CHASE3_NOT_USED&quot; IS NULL AND :original_CHASE3_NOT_USED IS NULL)) AND ((&quot;CHASE4_NOT_USED&quot; = :original_CHASE4_NOT_USED) OR (&quot;CHASE4_NOT_USED&quot; IS NULL AND :original_CHASE4_NOT_USED IS NULL)) AND ((&quot;VMI_DELAMINATION&quot; = :original_VMI_DELAMINATION) OR (&quot;VMI_DELAMINATION&quot; IS NULL AND :original_VMI_DELAMINATION IS NULL)) AND ((&quot;EMC_USAGE_END&quot; = :original_EMC_USAGE_END) OR (&quot;EMC_USAGE_END&quot; IS NULL AND :original_EMC_USAGE_END IS NULL)) AND ((&quot;LOT_END_TIME&quot; = :original_LOT_END_TIME) OR (&quot;LOT_END_TIME&quot; IS NULL AND :original_LOT_END_TIME IS NULL)) AND ((&quot;EMC_USAGE_START&quot; = :original_EMC_USAGE_START) OR (&quot;EMC_USAGE_START&quot; IS NULL AND :original_EMC_USAGE_START IS NULL)) AND ((&quot;WIRE_SWEEPING2&quot; = :original_WIRE_SWEEPING2) OR (&quot;WIRE_SWEEPING2&quot; IS NULL AND :original_WIRE_SWEEPING2 IS NULL)) AND ((&quot;WIRE_SWEEPING3&quot; = :original_WIRE_SWEEPING3) OR (&quot;WIRE_SWEEPING3&quot; IS NULL AND :original_WIRE_SWEEPING3 IS NULL)) AND ((&quot;WIRE_SWEEPING4&quot; = :original_WIRE_SWEEPING4) OR (&quot;WIRE_SWEEPING4&quot; IS NULL AND :original_WIRE_SWEEPING4 IS NULL)) AND ((&quot;WIRE_SWEEPING1&quot; = :original_WIRE_SWEEPING1) OR (&quot;WIRE_SWEEPING1&quot; IS NULL AND :original_WIRE_SWEEPING1 IS NULL)) AND ((&quot;WIRE_SWEEPING5&quot; = :original_WIRE_SWEEPING5) OR (&quot;WIRE_SWEEPING5&quot; IS NULL AND :original_WIRE_SWEEPING5 IS NULL)) AND ((&quot;DAMAGED_WIRE&quot; = :original_DAMAGED_WIRE) OR (&quot;DAMAGED_WIRE&quot; IS NULL AND :original_DAMAGED_WIRE IS NULL)) AND ((&quot;SAGGING_WIRE&quot; = :original_SAGGING_WIRE) OR (&quot;SAGGING_WIRE&quot; IS NULL AND :original_SAGGING_WIRE IS NULL)) AND ((&quot;OPEN_WIRE&quot; = :original_OPEN_WIRE) OR (&quot;OPEN_WIRE&quot; IS NULL AND :original_OPEN_WIRE IS NULL)) AND ((&quot;SHORT_WIRE&quot; = :original_SHORT_WIRE) OR (&quot;SHORT_WIRE&quot; IS NULL AND :original_SHORT_WIRE IS NULL)) AND ((&quot;ACTUAL_CLEANING_TIME&quot; = :original_ACTUAL_CLEANING_TIME) OR (&quot;ACTUAL_CLEANING_TIME&quot; IS NULL AND :original_ACTUAL_CLEANING_TIME IS NULL)) AND ((&quot;CLEANING_REASON&quot; = :original_CLEANING_REASON) OR (&quot;CLEANING_REASON&quot; IS NULL AND :original_CLEANING_REASON IS NULL)) AND ((&quot;BRIDGE_BALL&quot; = :original_BRIDGE_BALL) OR (&quot;BRIDGE_BALL&quot; IS NULL AND :original_BRIDGE_BALL IS NULL)) AND ((&quot;MISSING_BALL&quot; = :original_MISSING_BALL) OR (&quot;MISSING_BALL&quot; IS NULL AND :original_MISSING_BALL IS NULL)) AND ((&quot;MOLD_TOP_NO1&quot; = :original_MOLD_TOP_NO1) OR (&quot;MOLD_TOP_NO1&quot; IS NULL AND :original_MOLD_TOP_NO1 IS NULL)) AND ((&quot;MOLD_TOP_NO2&quot; = :original_MOLD_TOP_NO2) OR (&quot;MOLD_TOP_NO2&quot; IS NULL AND :original_MOLD_TOP_NO2 IS NULL)) AND ((&quot;MOLD_TOP_NO4&quot; = :original_MOLD_TOP_NO4) OR (&quot;MOLD_TOP_NO4&quot; IS NULL AND :original_MOLD_TOP_NO4 IS NULL)) AND ((&quot;MOLD_BTM_NO1&quot; = :original_MOLD_BTM_NO1) OR (&quot;MOLD_BTM_NO1&quot; IS NULL AND :original_MOLD_BTM_NO1 IS NULL)) AND ((&quot;MOLD_BTM_NO2&quot; = :original_MOLD_BTM_NO2) OR (&quot;MOLD_BTM_NO2&quot; IS NULL AND :original_MOLD_BTM_NO2 IS NULL)) AND ((&quot;MOLD_BTM_NO3&quot; = :original_MOLD_BTM_NO3) OR (&quot;MOLD_BTM_NO3&quot; IS NULL AND :original_MOLD_BTM_NO3 IS NULL)) AND ((&quot;MOLD_TOP_NO3&quot; = :original_MOLD_TOP_NO3) OR (&quot;MOLD_TOP_NO3&quot; IS NULL AND :original_MOLD_TOP_NO3 IS NULL)) AND ((&quot;MOLD_BTM_NO4&quot; = :original_MOLD_BTM_NO4) OR (&quot;MOLD_BTM_NO4&quot; IS NULL AND :original_MOLD_BTM_NO4 IS NULL)) AND ((&quot;PIT&quot; = :original_PIT) OR (&quot;PIT&quot; IS NULL AND :original_PIT IS NULL)) AND ((&quot;BUBBLE&quot; = :original_BUBBLE) OR (&quot;BUBBLE&quot; IS NULL AND :original_BUBBLE IS NULL)) AND ((&quot;MOLD_CAB&quot; = :original_MOLD_CAB) OR (&quot;MOLD_CAB&quot; IS NULL AND :original_MOLD_CAB IS NULL)) AND ((&quot;PCB&quot; = :original_PCB) OR (&quot;PCB&quot; IS NULL AND :original_PCB IS NULL)) AND ((&quot;VACUUM_MONITOR1&quot; = :original_VACUUM_MONITOR1) OR (&quot;VACUUM_MONITOR1&quot; IS NULL AND :original_VACUUM_MONITOR1 IS NULL)) AND ((&quot;VACUUM_MONITOR3&quot; = :original_VACUUM_MONITOR3) OR (&quot;VACUUM_MONITOR3&quot; IS NULL AND :original_VACUUM_MONITOR3 IS NULL)) AND ((&quot;VACUUM_MONITOR2&quot; = :original_VACUUM_MONITOR2) OR (&quot;VACUUM_MONITOR2&quot; IS NULL AND :original_VACUUM_MONITOR2 IS NULL)) AND ((&quot;VACUUM_MONITOR4&quot; = :original_VACUUM_MONITOR4) OR (&quot;VACUUM_MONITOR4&quot; IS NULL AND :original_VACUUM_MONITOR4 IS NULL)) AND ((&quot;MCOMP_IQA&quot; = :original_MCOMP_IQA) OR (&quot;MCOMP_IQA&quot; IS NULL AND :original_MCOMP_IQA IS NULL)) AND ((&quot;CHASE1_RUBBER_WAX&quot; = :original_CHASE1_RUBBER_WAX) OR (&quot;CHASE1_RUBBER_WAX&quot; IS NULL AND :original_CHASE1_RUBBER_WAX IS NULL)) AND ((&quot;CHASE2_RUBBER_WAX&quot; = :original_CHASE2_RUBBER_WAX) OR (&quot;CHASE2_RUBBER_WAX&quot; IS NULL AND :original_CHASE2_RUBBER_WAX IS NULL)) AND ((&quot;CHASE3_RUBBER_WAX&quot; = :original_CHASE3_RUBBER_WAX) OR (&quot;CHASE3_RUBBER_WAX&quot; IS NULL AND :original_CHASE3_RUBBER_WAX IS NULL)) AND ((&quot;CHASE4_RUBBER_WAX&quot; = :original_CHASE4_RUBBER_WAX) OR (&quot;CHASE4_RUBBER_WAX&quot; IS NULL AND :original_CHASE4_RUBBER_WAX IS NULL)) AND ((&quot;AGING_TIME&quot; = :original_AGING_TIME) OR (&quot;AGING_TIME&quot; IS NULL AND :original_AGING_TIME IS NULL)) AND ((&quot;COMPOUND_TYPE&quot; = :original_COMPOUND_TYPE) OR (&quot;COMPOUND_TYPE&quot; IS NULL AND :original_COMPOUND_TYPE IS NULL)) AND ((&quot;PRE_HEAT_TIME&quot; = :original_PRE_HEAT_TIME) OR (&quot;PRE_HEAT_TIME&quot; IS NULL AND :original_PRE_HEAT_TIME IS NULL)) AND ((&quot;VACCUM_PRESSURE&quot; = :original_VACCUM_PRESSURE) OR (&quot;VACCUM_PRESSURE&quot; IS NULL AND :original_VACCUM_PRESSURE IS NULL)) AND ((&quot;FILM_BATCH1&quot; = :original_FILM_BATCH1) OR (&quot;FILM_BATCH1&quot; IS NULL AND :original_FILM_BATCH1 IS NULL)) AND ((&quot;FILM_BATCH2&quot; = :original_FILM_BATCH2) OR (&quot;FILM_BATCH2&quot; IS NULL AND :original_FILM_BATCH2 IS NULL)) AND ((&quot;FILM_BATCH3&quot; = :original_FILM_BATCH3) OR (&quot;FILM_BATCH3&quot; IS NULL AND :original_FILM_BATCH3 IS NULL)) AND ((&quot;FILM_SAP1&quot; = :original_FILM_SAP1) OR (&quot;FILM_SAP1&quot; IS NULL AND :original_FILM_SAP1 IS NULL)) AND ((&quot;FILM_SAP2&quot; = :original_FILM_SAP2) OR (&quot;FILM_SAP2&quot; IS NULL AND :original_FILM_SAP2 IS NULL)) AND ((&quot;FILM_BATCH4&quot; = :original_FILM_BATCH4) OR (&quot;FILM_BATCH4&quot; IS NULL AND :original_FILM_BATCH4 IS NULL)) AND ((&quot;FILM_SAP3&quot; = :original_FILM_SAP3) OR (&quot;FILM_SAP3&quot; IS NULL AND :original_FILM_SAP3 IS NULL)) AND ((&quot;FILM_SAP4&quot; = :original_FILM_SAP4) OR (&quot;FILM_SAP4&quot; IS NULL AND :original_FILM_SAP4 IS NULL)) AND ((&quot;PCB_THICKNESS2&quot; = :original_PCB_THICKNESS2) OR (&quot;PCB_THICKNESS2&quot; IS NULL AND :original_PCB_THICKNESS2 IS NULL)) AND ((&quot;PCB_THICKNESS3&quot; = :original_PCB_THICKNESS3) OR (&quot;PCB_THICKNESS3&quot; IS NULL AND :original_PCB_THICKNESS3 IS NULL)) AND ((&quot;PCB_THICKNESS4&quot; = :original_PCB_THICKNESS4) OR (&quot;PCB_THICKNESS4&quot; IS NULL AND :original_PCB_THICKNESS4 IS NULL)) AND ((&quot;PCB_THICKNESS1&quot; = :original_PCB_THICKNESS1) OR (&quot;PCB_THICKNESS1&quot; IS NULL AND :original_PCB_THICKNESS1 IS NULL)) AND ((&quot;MCOMP_BATCH_LOT2&quot; = :original_MCOMP_BATCH_LOT2) OR (&quot;MCOMP_BATCH_LOT2&quot; IS NULL AND :original_MCOMP_BATCH_LOT2 IS NULL)) AND ((&quot;CLEANING_OPER_ID&quot; = :original_CLEANING_OPER_ID) OR (&quot;CLEANING_OPER_ID&quot; IS NULL AND :original_CLEANING_OPER_ID IS NULL))" 
            InsertCommand="INSERT INTO &quot;PCSD_MOLD_ELOGSHEET&quot; (&quot;SITENAME&quot;, &quot;ELOGSHEET_TYPE&quot;, &quot;MACHINE_ID&quot;, &quot;LOTID&quot;, &quot;PKG_TYPE&quot;, &quot;PKG_BODY_SIZE&quot;, &quot;CUST_NAME&quot;, &quot;DEVICE_NO&quot;, &quot;LOT_QTY&quot;, &quot;MCOMP_PART_NO&quot;, &quot;MCOMP_BATCH_LOT&quot;, &quot;MCOMP_EXP_DATE&quot;, &quot;MOLD_CHASE_NO1&quot;, &quot;MOLD_CHASE_NO2&quot;, &quot;MOLD_CHASE_NO3&quot;, &quot;MOLD_CHASE_NO4&quot;, &quot;STRIPS_QTY&quot;, &quot;TIME_CHECKED&quot;, &quot;EMPID&quot;, &quot;CHASE1_SHEET_CLEAN&quot;, &quot;CHASE2_SHEET_CLEAN&quot;, &quot;CHASE3_SHEET_CLEAN&quot;, &quot;CHASE4_SHEET_CLEAN&quot;, &quot;CHASE1_DUMMY&quot;, &quot;CHASE2_DUMMY&quot;, &quot;CHASE3_DUMMY&quot;, &quot;CHASE4_DUMMY&quot;, &quot;MOLD_CLEAN_START&quot;, &quot;MOLD_CLEAN_END&quot;, &quot;MOLD_CLEAN_TIME&quot;, &quot;PPID&quot;, &quot;TRANSFER_TIME&quot;, &quot;CURE_TIME&quot;, &quot;VMI_FLASH_BLEED&quot;, &quot;VMI_INCOMPLETE_FILL&quot;, &quot;VMI_CONTAMINATION&quot;, &quot;VMI_VOIDS&quot;, &quot;VMI_DENT&quot;, &quot;VMI_PKG_CRACK&quot;, &quot;VMI_GATE_REMAIN&quot;, &quot;VMI_PKG_OFFSET&quot;, &quot;VMI_WIRE_DEFFECTS&quot;, &quot;VMI_MISALIGN&quot;, &quot;VMI_FOL_REJECT&quot;, &quot;VMI_OTHERS&quot;, &quot;VMI_DEFECTS_QTY&quot;, &quot;VMI_STATUS&quot;, &quot;VMI_SAMPLE_SIZE&quot;, &quot;BO&quot;, &quot;REMARKS&quot;, &quot;CHASE1_NOT_USED&quot;, &quot;CHASE2_NOT_USED&quot;, &quot;CHASE3_NOT_USED&quot;, &quot;CHASE4_NOT_USED&quot;, &quot;VMI_DELAMINATION&quot;, &quot;EMC_USAGE_END&quot;, &quot;LOT_END_TIME&quot;, &quot;EMC_USAGE_START&quot;, &quot;WIRE_SWEEPING2&quot;, &quot;WIRE_SWEEPING3&quot;, &quot;WIRE_SWEEPING4&quot;, &quot;WIRE_SWEEPING1&quot;, &quot;WIRE_SWEEPING5&quot;, &quot;DAMAGED_WIRE&quot;, &quot;SAGGING_WIRE&quot;, &quot;OPEN_WIRE&quot;, &quot;SHORT_WIRE&quot;, &quot;ACTUAL_CLEANING_TIME&quot;, &quot;CLEANING_REASON&quot;, &quot;BRIDGE_BALL&quot;, &quot;MISSING_BALL&quot;, &quot;MOLD_TOP_NO1&quot;, &quot;MOLD_TOP_NO2&quot;, &quot;MOLD_TOP_NO4&quot;, &quot;MOLD_BTM_NO1&quot;, &quot;MOLD_BTM_NO2&quot;, &quot;MOLD_BTM_NO3&quot;, &quot;MOLD_TOP_NO3&quot;, &quot;MOLD_BTM_NO4&quot;, &quot;PIT&quot;, &quot;BUBBLE&quot;, &quot;MOLD_CAB&quot;, &quot;PCB&quot;, &quot;VACUUM_MONITOR1&quot;, &quot;VACUUM_MONITOR3&quot;, &quot;VACUUM_MONITOR2&quot;, &quot;VACUUM_MONITOR4&quot;, &quot;MCOMP_IQA&quot;, &quot;CHASE1_RUBBER_WAX&quot;, &quot;CHASE2_RUBBER_WAX&quot;, &quot;CHASE3_RUBBER_WAX&quot;, &quot;CHASE4_RUBBER_WAX&quot;, &quot;AGING_TIME&quot;, &quot;COMPOUND_TYPE&quot;, &quot;PRE_HEAT_TIME&quot;, &quot;VACCUM_PRESSURE&quot;, &quot;FILM_BATCH1&quot;, &quot;FILM_BATCH2&quot;, &quot;FILM_BATCH3&quot;, &quot;FILM_SAP1&quot;, &quot;FILM_SAP2&quot;, &quot;FILM_BATCH4&quot;, &quot;FILM_SAP3&quot;, &quot;FILM_SAP4&quot;, &quot;PCB_THICKNESS2&quot;, &quot;PCB_THICKNESS3&quot;, &quot;PCB_THICKNESS4&quot;, &quot;PCB_THICKNESS1&quot;, &quot;MCOMP_BATCH_LOT2&quot;, &quot;CLEANING_OPER_ID&quot;, &quot;SEQ&quot;) VALUES (:SITENAME, :ELOGSHEET_TYPE, :MACHINE_ID, :LOTID, :PKG_TYPE, :PKG_BODY_SIZE, :CUST_NAME, :DEVICE_NO, :LOT_QTY, :MCOMP_PART_NO, :MCOMP_BATCH_LOT, :MCOMP_EXP_DATE, :MOLD_CHASE_NO1, :MOLD_CHASE_NO2, :MOLD_CHASE_NO3, :MOLD_CHASE_NO4, :STRIPS_QTY, :TIME_CHECKED, :EMPID, :CHASE1_SHEET_CLEAN, :CHASE2_SHEET_CLEAN, :CHASE3_SHEET_CLEAN, :CHASE4_SHEET_CLEAN, :CHASE1_DUMMY, :CHASE2_DUMMY, :CHASE3_DUMMY, :CHASE4_DUMMY, :MOLD_CLEAN_START, :MOLD_CLEAN_END, :MOLD_CLEAN_TIME, :PPID, :TRANSFER_TIME, :CURE_TIME, :VMI_FLASH_BLEED, :VMI_INCOMPLETE_FILL, :VMI_CONTAMINATION, :VMI_VOIDS, :VMI_DENT, :VMI_PKG_CRACK, :VMI_GATE_REMAIN, :VMI_PKG_OFFSET, :VMI_WIRE_DEFFECTS, :VMI_MISALIGN, :VMI_FOL_REJECT, :VMI_OTHERS, :VMI_DEFECTS_QTY, :VMI_STATUS, :VMI_SAMPLE_SIZE, :BO, :REMARKS, :CHASE1_NOT_USED, :CHASE2_NOT_USED, :CHASE3_NOT_USED, :CHASE4_NOT_USED, :VMI_DELAMINATION, :EMC_USAGE_END, :LOT_END_TIME, :EMC_USAGE_START, :WIRE_SWEEPING2, :WIRE_SWEEPING3, :WIRE_SWEEPING4, :WIRE_SWEEPING1, :WIRE_SWEEPING5, :DAMAGED_WIRE, :SAGGING_WIRE, :OPEN_WIRE, :SHORT_WIRE, :ACTUAL_CLEANING_TIME, :CLEANING_REASON, :BRIDGE_BALL, :MISSING_BALL, :MOLD_TOP_NO1, :MOLD_TOP_NO2, :MOLD_TOP_NO4, :MOLD_BTM_NO1, :MOLD_BTM_NO2, :MOLD_BTM_NO3, :MOLD_TOP_NO3, :MOLD_BTM_NO4, :PIT, :BUBBLE, :MOLD_CAB, :PCB, :VACUUM_MONITOR1, :VACUUM_MONITOR3, :VACUUM_MONITOR2, :VACUUM_MONITOR4, :MCOMP_IQA, :CHASE1_RUBBER_WAX, :CHASE2_RUBBER_WAX, :CHASE3_RUBBER_WAX, :CHASE4_RUBBER_WAX, :AGING_TIME, :COMPOUND_TYPE, :PRE_HEAT_TIME, :VACCUM_PRESSURE, :FILM_BATCH1, :FILM_BATCH2, :FILM_BATCH3, :FILM_SAP1, :FILM_SAP2, :FILM_BATCH4, :FILM_SAP3, :FILM_SAP4, :PCB_THICKNESS2, :PCB_THICKNESS3, :PCB_THICKNESS4, :PCB_THICKNESS1, :MCOMP_BATCH_LOT2, :CLEANING_OPER_ID, :SEQ)" 
            
            
            
            
            
            
            UpdateCommand="UPDATE &quot;PCSD_MOLD_ELOGSHEET&quot; SET &quot;SITENAME&quot; = :SITENAME, &quot;ELOGSHEET_TYPE&quot; = :ELOGSHEET_TYPE, &quot;MACHINE_ID&quot; = :MACHINE_ID, &quot;LOTID&quot; = :LOTID, &quot;PKG_TYPE&quot; = :PKG_TYPE, &quot;PKG_BODY_SIZE&quot; = :PKG_BODY_SIZE, &quot;CUST_NAME&quot; = :CUST_NAME, &quot;DEVICE_NO&quot; = :DEVICE_NO, &quot;LOT_QTY&quot; = :LOT_QTY, &quot;MCOMP_PART_NO&quot; = :MCOMP_PART_NO, &quot;MCOMP_BATCH_LOT&quot; = :MCOMP_BATCH_LOT, &quot;MCOMP_EXP_DATE&quot; = :MCOMP_EXP_DATE, &quot;MOLD_CHASE_NO1&quot; = :MOLD_CHASE_NO1, &quot;MOLD_CHASE_NO2&quot; = :MOLD_CHASE_NO2, &quot;MOLD_CHASE_NO3&quot; = :MOLD_CHASE_NO3, &quot;MOLD_CHASE_NO4&quot; = :MOLD_CHASE_NO4, &quot;STRIPS_QTY&quot; = :STRIPS_QTY, &quot;TIME_CHECKED&quot; = :TIME_CHECKED, &quot;EMPID&quot; = :EMPID, &quot;CHASE1_SHEET_CLEAN&quot; = :CHASE1_SHEET_CLEAN, &quot;CHASE2_SHEET_CLEAN&quot; = :CHASE2_SHEET_CLEAN, &quot;CHASE3_SHEET_CLEAN&quot; = :CHASE3_SHEET_CLEAN, &quot;CHASE4_SHEET_CLEAN&quot; = :CHASE4_SHEET_CLEAN, &quot;CHASE1_DUMMY&quot; = :CHASE1_DUMMY, &quot;CHASE2_DUMMY&quot; = :CHASE2_DUMMY, &quot;CHASE3_DUMMY&quot; = :CHASE3_DUMMY, &quot;CHASE4_DUMMY&quot; = :CHASE4_DUMMY, &quot;MOLD_CLEAN_START&quot; = :MOLD_CLEAN_START, &quot;MOLD_CLEAN_END&quot; = :MOLD_CLEAN_END, &quot;MOLD_CLEAN_TIME&quot; = :MOLD_CLEAN_TIME, &quot;PPID&quot; = :PPID, &quot;TRANSFER_TIME&quot; = :TRANSFER_TIME, &quot;CURE_TIME&quot; = :CURE_TIME, &quot;VMI_FLASH_BLEED&quot; = :VMI_FLASH_BLEED, &quot;VMI_INCOMPLETE_FILL&quot; = :VMI_INCOMPLETE_FILL, &quot;VMI_CONTAMINATION&quot; = :VMI_CONTAMINATION, &quot;VMI_VOIDS&quot; = :VMI_VOIDS, &quot;VMI_DENT&quot; = :VMI_DENT, &quot;VMI_PKG_CRACK&quot; = :VMI_PKG_CRACK, &quot;VMI_GATE_REMAIN&quot; = :VMI_GATE_REMAIN, &quot;VMI_PKG_OFFSET&quot; = :VMI_PKG_OFFSET, &quot;VMI_WIRE_DEFFECTS&quot; = :VMI_WIRE_DEFFECTS, &quot;VMI_MISALIGN&quot; = :VMI_MISALIGN, &quot;VMI_FOL_REJECT&quot; = :VMI_FOL_REJECT, &quot;VMI_OTHERS&quot; = :VMI_OTHERS, &quot;VMI_DEFECTS_QTY&quot; = :VMI_DEFECTS_QTY, &quot;VMI_STATUS&quot; = :VMI_STATUS, &quot;VMI_SAMPLE_SIZE&quot; = :VMI_SAMPLE_SIZE, &quot;BO&quot; = :BO, &quot;REMARKS&quot; = :REMARKS, &quot;CHASE1_NOT_USED&quot; = :CHASE1_NOT_USED, &quot;CHASE2_NOT_USED&quot; = :CHASE2_NOT_USED, &quot;CHASE3_NOT_USED&quot; = :CHASE3_NOT_USED, &quot;CHASE4_NOT_USED&quot; = :CHASE4_NOT_USED, &quot;VMI_DELAMINATION&quot; = :VMI_DELAMINATION, &quot;EMC_USAGE_END&quot; = :EMC_USAGE_END, &quot;LOT_END_TIME&quot; = :LOT_END_TIME, &quot;EMC_USAGE_START&quot; = :EMC_USAGE_START, &quot;WIRE_SWEEPING2&quot; = :WIRE_SWEEPING2, &quot;WIRE_SWEEPING3&quot; = :WIRE_SWEEPING3, &quot;WIRE_SWEEPING4&quot; = :WIRE_SWEEPING4, &quot;WIRE_SWEEPING1&quot; = :WIRE_SWEEPING1, &quot;WIRE_SWEEPING5&quot; = :WIRE_SWEEPING5, &quot;DAMAGED_WIRE&quot; = :DAMAGED_WIRE, &quot;SAGGING_WIRE&quot; = :SAGGING_WIRE, &quot;OPEN_WIRE&quot; = :OPEN_WIRE, &quot;SHORT_WIRE&quot; = :SHORT_WIRE, &quot;ACTUAL_CLEANING_TIME&quot; = :ACTUAL_CLEANING_TIME, &quot;CLEANING_REASON&quot; = :CLEANING_REASON, &quot;BRIDGE_BALL&quot; = :BRIDGE_BALL, &quot;MISSING_BALL&quot; = :MISSING_BALL, &quot;MOLD_TOP_NO1&quot; = :MOLD_TOP_NO1, &quot;MOLD_TOP_NO2&quot; = :MOLD_TOP_NO2, &quot;MOLD_TOP_NO4&quot; = :MOLD_TOP_NO4, &quot;MOLD_BTM_NO1&quot; = :MOLD_BTM_NO1, &quot;MOLD_BTM_NO2&quot; = :MOLD_BTM_NO2, &quot;MOLD_BTM_NO3&quot; = :MOLD_BTM_NO3, &quot;MOLD_TOP_NO3&quot; = :MOLD_TOP_NO3, &quot;MOLD_BTM_NO4&quot; = :MOLD_BTM_NO4, &quot;PIT&quot; = :PIT, &quot;BUBBLE&quot; = :BUBBLE, &quot;MOLD_CAB&quot; = :MOLD_CAB, &quot;PCB&quot; = :PCB, &quot;VACUUM_MONITOR1&quot; = :VACUUM_MONITOR1, &quot;VACUUM_MONITOR3&quot; = :VACUUM_MONITOR3, &quot;VACUUM_MONITOR2&quot; = :VACUUM_MONITOR2, &quot;VACUUM_MONITOR4&quot; = :VACUUM_MONITOR4, &quot;MCOMP_IQA&quot; = :MCOMP_IQA, &quot;CHASE1_RUBBER_WAX&quot; = :CHASE1_RUBBER_WAX, &quot;CHASE2_RUBBER_WAX&quot; = :CHASE2_RUBBER_WAX, &quot;CHASE3_RUBBER_WAX&quot; = :CHASE3_RUBBER_WAX, &quot;CHASE4_RUBBER_WAX&quot; = :CHASE4_RUBBER_WAX, &quot;AGING_TIME&quot; = :AGING_TIME, &quot;COMPOUND_TYPE&quot; = :COMPOUND_TYPE, &quot;PRE_HEAT_TIME&quot; = :PRE_HEAT_TIME, &quot;VACCUM_PRESSURE&quot; = :VACCUM_PRESSURE, &quot;FILM_BATCH1&quot; = :FILM_BATCH1, &quot;FILM_BATCH2&quot; = :FILM_BATCH2, &quot;FILM_BATCH3&quot; = :FILM_BATCH3, &quot;FILM_SAP1&quot; = :FILM_SAP1, &quot;FILM_SAP2&quot; = :FILM_SAP2, &quot;FILM_BATCH4&quot; = :FILM_BATCH4, &quot;FILM_SAP3&quot; = :FILM_SAP3, &quot;FILM_SAP4&quot; = :FILM_SAP4, &quot;PCB_THICKNESS2&quot; = :PCB_THICKNESS2, &quot;PCB_THICKNESS3&quot; = :PCB_THICKNESS3, &quot;PCB_THICKNESS4&quot; = :PCB_THICKNESS4, &quot;PCB_THICKNESS1&quot; = :PCB_THICKNESS1, &quot;MCOMP_BATCH_LOT2&quot; = :MCOMP_BATCH_LOT2, &quot;CLEANING_OPER_ID&quot; = :CLEANING_OPER_ID WHERE &quot;SEQ&quot; = :original_SEQ AND ((&quot;SITENAME&quot; = :original_SITENAME) OR (&quot;SITENAME&quot; IS NULL AND :original_SITENAME IS NULL)) AND ((&quot;ELOGSHEET_TYPE&quot; = :original_ELOGSHEET_TYPE) OR (&quot;ELOGSHEET_TYPE&quot; IS NULL AND :original_ELOGSHEET_TYPE IS NULL)) AND ((&quot;MACHINE_ID&quot; = :original_MACHINE_ID) OR (&quot;MACHINE_ID&quot; IS NULL AND :original_MACHINE_ID IS NULL)) AND ((&quot;LOTID&quot; = :original_LOTID) OR (&quot;LOTID&quot; IS NULL AND :original_LOTID IS NULL)) AND ((&quot;PKG_TYPE&quot; = :original_PKG_TYPE) OR (&quot;PKG_TYPE&quot; IS NULL AND :original_PKG_TYPE IS NULL)) AND ((&quot;PKG_BODY_SIZE&quot; = :original_PKG_BODY_SIZE) OR (&quot;PKG_BODY_SIZE&quot; IS NULL AND :original_PKG_BODY_SIZE IS NULL)) AND ((&quot;CUST_NAME&quot; = :original_CUST_NAME) OR (&quot;CUST_NAME&quot; IS NULL AND :original_CUST_NAME IS NULL)) AND ((&quot;DEVICE_NO&quot; = :original_DEVICE_NO) OR (&quot;DEVICE_NO&quot; IS NULL AND :original_DEVICE_NO IS NULL)) AND ((&quot;LOT_QTY&quot; = :original_LOT_QTY) OR (&quot;LOT_QTY&quot; IS NULL AND :original_LOT_QTY IS NULL)) AND ((&quot;MCOMP_PART_NO&quot; = :original_MCOMP_PART_NO) OR (&quot;MCOMP_PART_NO&quot; IS NULL AND :original_MCOMP_PART_NO IS NULL)) AND ((&quot;MCOMP_BATCH_LOT&quot; = :original_MCOMP_BATCH_LOT) OR (&quot;MCOMP_BATCH_LOT&quot; IS NULL AND :original_MCOMP_BATCH_LOT IS NULL)) AND ((&quot;MCOMP_EXP_DATE&quot; = :original_MCOMP_EXP_DATE) OR (&quot;MCOMP_EXP_DATE&quot; IS NULL AND :original_MCOMP_EXP_DATE IS NULL)) AND ((&quot;MOLD_CHASE_NO1&quot; = :original_MOLD_CHASE_NO1) OR (&quot;MOLD_CHASE_NO1&quot; IS NULL AND :original_MOLD_CHASE_NO1 IS NULL)) AND ((&quot;MOLD_CHASE_NO2&quot; = :original_MOLD_CHASE_NO2) OR (&quot;MOLD_CHASE_NO2&quot; IS NULL AND :original_MOLD_CHASE_NO2 IS NULL)) AND ((&quot;MOLD_CHASE_NO3&quot; = :original_MOLD_CHASE_NO3) OR (&quot;MOLD_CHASE_NO3&quot; IS NULL AND :original_MOLD_CHASE_NO3 IS NULL)) AND ((&quot;MOLD_CHASE_NO4&quot; = :original_MOLD_CHASE_NO4) OR (&quot;MOLD_CHASE_NO4&quot; IS NULL AND :original_MOLD_CHASE_NO4 IS NULL)) AND ((&quot;STRIPS_QTY&quot; = :original_STRIPS_QTY) OR (&quot;STRIPS_QTY&quot; IS NULL AND :original_STRIPS_QTY IS NULL)) AND ((&quot;TIME_CHECKED&quot; = :original_TIME_CHECKED) OR (&quot;TIME_CHECKED&quot; IS NULL AND :original_TIME_CHECKED IS NULL)) AND ((&quot;EMPID&quot; = :original_EMPID) OR (&quot;EMPID&quot; IS NULL AND :original_EMPID IS NULL)) AND ((&quot;CHASE1_SHEET_CLEAN&quot; = :original_CHASE1_SHEET_CLEAN) OR (&quot;CHASE1_SHEET_CLEAN&quot; IS NULL AND :original_CHASE1_SHEET_CLEAN IS NULL)) AND ((&quot;CHASE2_SHEET_CLEAN&quot; = :original_CHASE2_SHEET_CLEAN) OR (&quot;CHASE2_SHEET_CLEAN&quot; IS NULL AND :original_CHASE2_SHEET_CLEAN IS NULL)) AND ((&quot;CHASE3_SHEET_CLEAN&quot; = :original_CHASE3_SHEET_CLEAN) OR (&quot;CHASE3_SHEET_CLEAN&quot; IS NULL AND :original_CHASE3_SHEET_CLEAN IS NULL)) AND ((&quot;CHASE4_SHEET_CLEAN&quot; = :original_CHASE4_SHEET_CLEAN) OR (&quot;CHASE4_SHEET_CLEAN&quot; IS NULL AND :original_CHASE4_SHEET_CLEAN IS NULL)) AND ((&quot;CHASE1_DUMMY&quot; = :original_CHASE1_DUMMY) OR (&quot;CHASE1_DUMMY&quot; IS NULL AND :original_CHASE1_DUMMY IS NULL)) AND ((&quot;CHASE2_DUMMY&quot; = :original_CHASE2_DUMMY) OR (&quot;CHASE2_DUMMY&quot; IS NULL AND :original_CHASE2_DUMMY IS NULL)) AND ((&quot;CHASE3_DUMMY&quot; = :original_CHASE3_DUMMY) OR (&quot;CHASE3_DUMMY&quot; IS NULL AND :original_CHASE3_DUMMY IS NULL)) AND ((&quot;CHASE4_DUMMY&quot; = :original_CHASE4_DUMMY) OR (&quot;CHASE4_DUMMY&quot; IS NULL AND :original_CHASE4_DUMMY IS NULL)) AND ((&quot;MOLD_CLEAN_START&quot; = :original_MOLD_CLEAN_START) OR (&quot;MOLD_CLEAN_START&quot; IS NULL AND :original_MOLD_CLEAN_START IS NULL)) AND ((&quot;MOLD_CLEAN_END&quot; = :original_MOLD_CLEAN_END) OR (&quot;MOLD_CLEAN_END&quot; IS NULL AND :original_MOLD_CLEAN_END IS NULL)) AND ((&quot;MOLD_CLEAN_TIME&quot; = :original_MOLD_CLEAN_TIME) OR (&quot;MOLD_CLEAN_TIME&quot; IS NULL AND :original_MOLD_CLEAN_TIME IS NULL)) AND ((&quot;PPID&quot; = :original_PPID) OR (&quot;PPID&quot; IS NULL AND :original_PPID IS NULL)) AND ((&quot;TRANSFER_TIME&quot; = :original_TRANSFER_TIME) OR (&quot;TRANSFER_TIME&quot; IS NULL AND :original_TRANSFER_TIME IS NULL)) AND ((&quot;CURE_TIME&quot; = :original_CURE_TIME) OR (&quot;CURE_TIME&quot; IS NULL AND :original_CURE_TIME IS NULL)) AND ((&quot;VMI_FLASH_BLEED&quot; = :original_VMI_FLASH_BLEED) OR (&quot;VMI_FLASH_BLEED&quot; IS NULL AND :original_VMI_FLASH_BLEED IS NULL)) AND ((&quot;VMI_INCOMPLETE_FILL&quot; = :original_VMI_INCOMPLETE_FILL) OR (&quot;VMI_INCOMPLETE_FILL&quot; IS NULL AND :original_VMI_INCOMPLETE_FILL IS NULL)) AND ((&quot;VMI_CONTAMINATION&quot; = :original_VMI_CONTAMINATION) OR (&quot;VMI_CONTAMINATION&quot; IS NULL AND :original_VMI_CONTAMINATION IS NULL)) AND ((&quot;VMI_VOIDS&quot; = :original_VMI_VOIDS) OR (&quot;VMI_VOIDS&quot; IS NULL AND :original_VMI_VOIDS IS NULL)) AND ((&quot;VMI_DENT&quot; = :original_VMI_DENT) OR (&quot;VMI_DENT&quot; IS NULL AND :original_VMI_DENT IS NULL)) AND ((&quot;VMI_PKG_CRACK&quot; = :original_VMI_PKG_CRACK) OR (&quot;VMI_PKG_CRACK&quot; IS NULL AND :original_VMI_PKG_CRACK IS NULL)) AND ((&quot;VMI_GATE_REMAIN&quot; = :original_VMI_GATE_REMAIN) OR (&quot;VMI_GATE_REMAIN&quot; IS NULL AND :original_VMI_GATE_REMAIN IS NULL)) AND ((&quot;VMI_PKG_OFFSET&quot; = :original_VMI_PKG_OFFSET) OR (&quot;VMI_PKG_OFFSET&quot; IS NULL AND :original_VMI_PKG_OFFSET IS NULL)) AND ((&quot;VMI_WIRE_DEFFECTS&quot; = :original_VMI_WIRE_DEFFECTS) OR (&quot;VMI_WIRE_DEFFECTS&quot; IS NULL AND :original_VMI_WIRE_DEFFECTS IS NULL)) AND ((&quot;VMI_MISALIGN&quot; = :original_VMI_MISALIGN) OR (&quot;VMI_MISALIGN&quot; IS NULL AND :original_VMI_MISALIGN IS NULL)) AND ((&quot;VMI_FOL_REJECT&quot; = :original_VMI_FOL_REJECT) OR (&quot;VMI_FOL_REJECT&quot; IS NULL AND :original_VMI_FOL_REJECT IS NULL)) AND ((&quot;VMI_OTHERS&quot; = :original_VMI_OTHERS) OR (&quot;VMI_OTHERS&quot; IS NULL AND :original_VMI_OTHERS IS NULL)) AND ((&quot;VMI_DEFECTS_QTY&quot; = :original_VMI_DEFECTS_QTY) OR (&quot;VMI_DEFECTS_QTY&quot; IS NULL AND :original_VMI_DEFECTS_QTY IS NULL)) AND ((&quot;VMI_STATUS&quot; = :original_VMI_STATUS) OR (&quot;VMI_STATUS&quot; IS NULL AND :original_VMI_STATUS IS NULL)) AND ((&quot;VMI_SAMPLE_SIZE&quot; = :original_VMI_SAMPLE_SIZE) OR (&quot;VMI_SAMPLE_SIZE&quot; IS NULL AND :original_VMI_SAMPLE_SIZE IS NULL)) AND ((&quot;BO&quot; = :original_BO) OR (&quot;BO&quot; IS NULL AND :original_BO IS NULL)) AND ((&quot;REMARKS&quot; = :original_REMARKS) OR (&quot;REMARKS&quot; IS NULL AND :original_REMARKS IS NULL)) AND ((&quot;CHASE1_NOT_USED&quot; = :original_CHASE1_NOT_USED) OR (&quot;CHASE1_NOT_USED&quot; IS NULL AND :original_CHASE1_NOT_USED IS NULL)) AND ((&quot;CHASE2_NOT_USED&quot; = :original_CHASE2_NOT_USED) OR (&quot;CHASE2_NOT_USED&quot; IS NULL AND :original_CHASE2_NOT_USED IS NULL)) AND ((&quot;CHASE3_NOT_USED&quot; = :original_CHASE3_NOT_USED) OR (&quot;CHASE3_NOT_USED&quot; IS NULL AND :original_CHASE3_NOT_USED IS NULL)) AND ((&quot;CHASE4_NOT_USED&quot; = :original_CHASE4_NOT_USED) OR (&quot;CHASE4_NOT_USED&quot; IS NULL AND :original_CHASE4_NOT_USED IS NULL)) AND ((&quot;VMI_DELAMINATION&quot; = :original_VMI_DELAMINATION) OR (&quot;VMI_DELAMINATION&quot; IS NULL AND :original_VMI_DELAMINATION IS NULL)) AND ((&quot;EMC_USAGE_END&quot; = :original_EMC_USAGE_END) OR (&quot;EMC_USAGE_END&quot; IS NULL AND :original_EMC_USAGE_END IS NULL)) AND ((&quot;LOT_END_TIME&quot; = :original_LOT_END_TIME) OR (&quot;LOT_END_TIME&quot; IS NULL AND :original_LOT_END_TIME IS NULL)) AND ((&quot;EMC_USAGE_START&quot; = :original_EMC_USAGE_START) OR (&quot;EMC_USAGE_START&quot; IS NULL AND :original_EMC_USAGE_START IS NULL)) AND ((&quot;WIRE_SWEEPING2&quot; = :original_WIRE_SWEEPING2) OR (&quot;WIRE_SWEEPING2&quot; IS NULL AND :original_WIRE_SWEEPING2 IS NULL)) AND ((&quot;WIRE_SWEEPING3&quot; = :original_WIRE_SWEEPING3) OR (&quot;WIRE_SWEEPING3&quot; IS NULL AND :original_WIRE_SWEEPING3 IS NULL)) AND ((&quot;WIRE_SWEEPING4&quot; = :original_WIRE_SWEEPING4) OR (&quot;WIRE_SWEEPING4&quot; IS NULL AND :original_WIRE_SWEEPING4 IS NULL)) AND ((&quot;WIRE_SWEEPING1&quot; = :original_WIRE_SWEEPING1) OR (&quot;WIRE_SWEEPING1&quot; IS NULL AND :original_WIRE_SWEEPING1 IS NULL)) AND ((&quot;WIRE_SWEEPING5&quot; = :original_WIRE_SWEEPING5) OR (&quot;WIRE_SWEEPING5&quot; IS NULL AND :original_WIRE_SWEEPING5 IS NULL)) AND ((&quot;DAMAGED_WIRE&quot; = :original_DAMAGED_WIRE) OR (&quot;DAMAGED_WIRE&quot; IS NULL AND :original_DAMAGED_WIRE IS NULL)) AND ((&quot;SAGGING_WIRE&quot; = :original_SAGGING_WIRE) OR (&quot;SAGGING_WIRE&quot; IS NULL AND :original_SAGGING_WIRE IS NULL)) AND ((&quot;OPEN_WIRE&quot; = :original_OPEN_WIRE) OR (&quot;OPEN_WIRE&quot; IS NULL AND :original_OPEN_WIRE IS NULL)) AND ((&quot;SHORT_WIRE&quot; = :original_SHORT_WIRE) OR (&quot;SHORT_WIRE&quot; IS NULL AND :original_SHORT_WIRE IS NULL)) AND ((&quot;ACTUAL_CLEANING_TIME&quot; = :original_ACTUAL_CLEANING_TIME) OR (&quot;ACTUAL_CLEANING_TIME&quot; IS NULL AND :original_ACTUAL_CLEANING_TIME IS NULL)) AND ((&quot;CLEANING_REASON&quot; = :original_CLEANING_REASON) OR (&quot;CLEANING_REASON&quot; IS NULL AND :original_CLEANING_REASON IS NULL)) AND ((&quot;BRIDGE_BALL&quot; = :original_BRIDGE_BALL) OR (&quot;BRIDGE_BALL&quot; IS NULL AND :original_BRIDGE_BALL IS NULL)) AND ((&quot;MISSING_BALL&quot; = :original_MISSING_BALL) OR (&quot;MISSING_BALL&quot; IS NULL AND :original_MISSING_BALL IS NULL)) AND ((&quot;MOLD_TOP_NO1&quot; = :original_MOLD_TOP_NO1) OR (&quot;MOLD_TOP_NO1&quot; IS NULL AND :original_MOLD_TOP_NO1 IS NULL)) AND ((&quot;MOLD_TOP_NO2&quot; = :original_MOLD_TOP_NO2) OR (&quot;MOLD_TOP_NO2&quot; IS NULL AND :original_MOLD_TOP_NO2 IS NULL)) AND ((&quot;MOLD_TOP_NO4&quot; = :original_MOLD_TOP_NO4) OR (&quot;MOLD_TOP_NO4&quot; IS NULL AND :original_MOLD_TOP_NO4 IS NULL)) AND ((&quot;MOLD_BTM_NO1&quot; = :original_MOLD_BTM_NO1) OR (&quot;MOLD_BTM_NO1&quot; IS NULL AND :original_MOLD_BTM_NO1 IS NULL)) AND ((&quot;MOLD_BTM_NO2&quot; = :original_MOLD_BTM_NO2) OR (&quot;MOLD_BTM_NO2&quot; IS NULL AND :original_MOLD_BTM_NO2 IS NULL)) AND ((&quot;MOLD_BTM_NO3&quot; = :original_MOLD_BTM_NO3) OR (&quot;MOLD_BTM_NO3&quot; IS NULL AND :original_MOLD_BTM_NO3 IS NULL)) AND ((&quot;MOLD_TOP_NO3&quot; = :original_MOLD_TOP_NO3) OR (&quot;MOLD_TOP_NO3&quot; IS NULL AND :original_MOLD_TOP_NO3 IS NULL)) AND ((&quot;MOLD_BTM_NO4&quot; = :original_MOLD_BTM_NO4) OR (&quot;MOLD_BTM_NO4&quot; IS NULL AND :original_MOLD_BTM_NO4 IS NULL)) AND ((&quot;PIT&quot; = :original_PIT) OR (&quot;PIT&quot; IS NULL AND :original_PIT IS NULL)) AND ((&quot;BUBBLE&quot; = :original_BUBBLE) OR (&quot;BUBBLE&quot; IS NULL AND :original_BUBBLE IS NULL)) AND ((&quot;MOLD_CAB&quot; = :original_MOLD_CAB) OR (&quot;MOLD_CAB&quot; IS NULL AND :original_MOLD_CAB IS NULL)) AND ((&quot;PCB&quot; = :original_PCB) OR (&quot;PCB&quot; IS NULL AND :original_PCB IS NULL)) AND ((&quot;VACUUM_MONITOR1&quot; = :original_VACUUM_MONITOR1) OR (&quot;VACUUM_MONITOR1&quot; IS NULL AND :original_VACUUM_MONITOR1 IS NULL)) AND ((&quot;VACUUM_MONITOR3&quot; = :original_VACUUM_MONITOR3) OR (&quot;VACUUM_MONITOR3&quot; IS NULL AND :original_VACUUM_MONITOR3 IS NULL)) AND ((&quot;VACUUM_MONITOR2&quot; = :original_VACUUM_MONITOR2) OR (&quot;VACUUM_MONITOR2&quot; IS NULL AND :original_VACUUM_MONITOR2 IS NULL)) AND ((&quot;VACUUM_MONITOR4&quot; = :original_VACUUM_MONITOR4) OR (&quot;VACUUM_MONITOR4&quot; IS NULL AND :original_VACUUM_MONITOR4 IS NULL)) AND ((&quot;MCOMP_IQA&quot; = :original_MCOMP_IQA) OR (&quot;MCOMP_IQA&quot; IS NULL AND :original_MCOMP_IQA IS NULL)) AND ((&quot;CHASE1_RUBBER_WAX&quot; = :original_CHASE1_RUBBER_WAX) OR (&quot;CHASE1_RUBBER_WAX&quot; IS NULL AND :original_CHASE1_RUBBER_WAX IS NULL)) AND ((&quot;CHASE2_RUBBER_WAX&quot; = :original_CHASE2_RUBBER_WAX) OR (&quot;CHASE2_RUBBER_WAX&quot; IS NULL AND :original_CHASE2_RUBBER_WAX IS NULL)) AND ((&quot;CHASE3_RUBBER_WAX&quot; = :original_CHASE3_RUBBER_WAX) OR (&quot;CHASE3_RUBBER_WAX&quot; IS NULL AND :original_CHASE3_RUBBER_WAX IS NULL)) AND ((&quot;CHASE4_RUBBER_WAX&quot; = :original_CHASE4_RUBBER_WAX) OR (&quot;CHASE4_RUBBER_WAX&quot; IS NULL AND :original_CHASE4_RUBBER_WAX IS NULL)) AND ((&quot;AGING_TIME&quot; = :original_AGING_TIME) OR (&quot;AGING_TIME&quot; IS NULL AND :original_AGING_TIME IS NULL)) AND ((&quot;COMPOUND_TYPE&quot; = :original_COMPOUND_TYPE) OR (&quot;COMPOUND_TYPE&quot; IS NULL AND :original_COMPOUND_TYPE IS NULL)) AND ((&quot;PRE_HEAT_TIME&quot; = :original_PRE_HEAT_TIME) OR (&quot;PRE_HEAT_TIME&quot; IS NULL AND :original_PRE_HEAT_TIME IS NULL)) AND ((&quot;VACCUM_PRESSURE&quot; = :original_VACCUM_PRESSURE) OR (&quot;VACCUM_PRESSURE&quot; IS NULL AND :original_VACCUM_PRESSURE IS NULL)) AND ((&quot;FILM_BATCH1&quot; = :original_FILM_BATCH1) OR (&quot;FILM_BATCH1&quot; IS NULL AND :original_FILM_BATCH1 IS NULL)) AND ((&quot;FILM_BATCH2&quot; = :original_FILM_BATCH2) OR (&quot;FILM_BATCH2&quot; IS NULL AND :original_FILM_BATCH2 IS NULL)) AND ((&quot;FILM_BATCH3&quot; = :original_FILM_BATCH3) OR (&quot;FILM_BATCH3&quot; IS NULL AND :original_FILM_BATCH3 IS NULL)) AND ((&quot;FILM_SAP1&quot; = :original_FILM_SAP1) OR (&quot;FILM_SAP1&quot; IS NULL AND :original_FILM_SAP1 IS NULL)) AND ((&quot;FILM_SAP2&quot; = :original_FILM_SAP2) OR (&quot;FILM_SAP2&quot; IS NULL AND :original_FILM_SAP2 IS NULL)) AND ((&quot;FILM_BATCH4&quot; = :original_FILM_BATCH4) OR (&quot;FILM_BATCH4&quot; IS NULL AND :original_FILM_BATCH4 IS NULL)) AND ((&quot;FILM_SAP3&quot; = :original_FILM_SAP3) OR (&quot;FILM_SAP3&quot; IS NULL AND :original_FILM_SAP3 IS NULL)) AND ((&quot;FILM_SAP4&quot; = :original_FILM_SAP4) OR (&quot;FILM_SAP4&quot; IS NULL AND :original_FILM_SAP4 IS NULL)) AND ((&quot;PCB_THICKNESS2&quot; = :original_PCB_THICKNESS2) OR (&quot;PCB_THICKNESS2&quot; IS NULL AND :original_PCB_THICKNESS2 IS NULL)) AND ((&quot;PCB_THICKNESS3&quot; = :original_PCB_THICKNESS3) OR (&quot;PCB_THICKNESS3&quot; IS NULL AND :original_PCB_THICKNESS3 IS NULL)) AND ((&quot;PCB_THICKNESS4&quot; = :original_PCB_THICKNESS4) OR (&quot;PCB_THICKNESS4&quot; IS NULL AND :original_PCB_THICKNESS4 IS NULL)) AND ((&quot;PCB_THICKNESS1&quot; = :original_PCB_THICKNESS1) OR (&quot;PCB_THICKNESS1&quot; IS NULL AND :original_PCB_THICKNESS1 IS NULL)) AND ((&quot;MCOMP_BATCH_LOT2&quot; = :original_MCOMP_BATCH_LOT2) OR (&quot;MCOMP_BATCH_LOT2&quot; IS NULL AND :original_MCOMP_BATCH_LOT2 IS NULL)) AND ((&quot;CLEANING_OPER_ID&quot; = :original_CLEANING_OPER_ID) OR (&quot;CLEANING_OPER_ID&quot; IS NULL AND :original_CLEANING_OPER_ID IS NULL))">
            <DeleteParameters>
                <asp:Parameter Name="original_SEQ" Type="Decimal" />
                <asp:Parameter Name="original_SITENAME" Type="String" />
                <asp:Parameter Name="original_ELOGSHEET_TYPE" Type="String" />
                <asp:Parameter Name="original_MACHINE_ID" Type="String" />
                <asp:Parameter Name="original_LOTID" Type="String" />
                <asp:Parameter Name="original_PKG_TYPE" Type="String" />
                <asp:Parameter Name="original_PKG_BODY_SIZE" Type="String" />
                <asp:Parameter Name="original_CUST_NAME" Type="String" />
                <asp:Parameter Name="original_DEVICE_NO" Type="String" />
                <asp:Parameter Name="original_LOT_QTY" Type="Decimal" />
                <asp:Parameter Name="original_MCOMP_PART_NO" Type="String" />
                <asp:Parameter Name="original_MCOMP_BATCH_LOT" Type="String" />
                <asp:Parameter Name="original_MCOMP_EXP_DATE" Type="DateTime" />
                <asp:Parameter Name="original_MOLD_CHASE_NO1" Type="String" />
                <asp:Parameter Name="original_MOLD_CHASE_NO2" Type="String" />
                <asp:Parameter Name="original_MOLD_CHASE_NO3" Type="String" />
                <asp:Parameter Name="original_MOLD_CHASE_NO4" Type="String" />
                <asp:Parameter Name="original_STRIPS_QTY" Type="Decimal" />
                <asp:Parameter Name="original_TIME_CHECKED" Type="DateTime" />
                <asp:Parameter Name="original_EMPID" Type="String" />
                <asp:Parameter Name="original_CHASE1_SHEET_CLEAN" Type="Decimal" />
                <asp:Parameter Name="original_CHASE2_SHEET_CLEAN" Type="Decimal" />
                <asp:Parameter Name="original_CHASE3_SHEET_CLEAN" Type="Decimal" />
                <asp:Parameter Name="original_CHASE4_SHEET_CLEAN" Type="Decimal" />
                <asp:Parameter Name="original_CHASE1_DUMMY" Type="Decimal" />
                <asp:Parameter Name="original_CHASE2_DUMMY" Type="Decimal" />
                <asp:Parameter Name="original_CHASE3_DUMMY" Type="Decimal" />
                <asp:Parameter Name="original_CHASE4_DUMMY" Type="Decimal" />
                <asp:Parameter Name="original_MOLD_CLEAN_START" Type="DateTime" />
                <asp:Parameter Name="original_MOLD_CLEAN_END" Type="DateTime" />
                <asp:Parameter Name="original_MOLD_CLEAN_TIME" Type="Decimal" />
                <asp:Parameter Name="original_PPID" Type="String" />
                <asp:Parameter Name="original_TRANSFER_TIME" Type="Decimal" />
                <asp:Parameter Name="original_CURE_TIME" Type="Decimal" />
                <asp:Parameter Name="original_VMI_FLASH_BLEED" Type="Decimal" />
                <asp:Parameter Name="original_VMI_INCOMPLETE_FILL" Type="Decimal" />
                <asp:Parameter Name="original_VMI_CONTAMINATION" Type="Decimal" />
                <asp:Parameter Name="original_VMI_VOIDS" Type="Decimal" />
                <asp:Parameter Name="original_VMI_DENT" Type="Decimal" />
                <asp:Parameter Name="original_VMI_PKG_CRACK" Type="Decimal" />
                <asp:Parameter Name="original_VMI_GATE_REMAIN" Type="Decimal" />
                <asp:Parameter Name="original_VMI_PKG_OFFSET" Type="Decimal" />
                <asp:Parameter Name="original_VMI_WIRE_DEFFECTS" Type="Decimal" />
                <asp:Parameter Name="original_VMI_MISALIGN" Type="Decimal" />
                <asp:Parameter Name="original_VMI_FOL_REJECT" Type="Decimal" />
                <asp:Parameter Name="original_VMI_OTHERS" Type="Decimal" />
                <asp:Parameter Name="original_VMI_DEFECTS_QTY" Type="Decimal" />
                <asp:Parameter Name="original_VMI_STATUS" Type="String" />
                <asp:Parameter Name="original_VMI_SAMPLE_SIZE" Type="Decimal" />
                <asp:Parameter Name="original_BO" Type="String" />
                <asp:Parameter Name="original_REMARKS" Type="String" />
                <asp:Parameter Name="original_CHASE1_NOT_USED" Type="String" />
                <asp:Parameter Name="original_CHASE2_NOT_USED" Type="String" />
                <asp:Parameter Name="original_CHASE3_NOT_USED" Type="String" />
                <asp:Parameter Name="original_CHASE4_NOT_USED" Type="String" />
                <asp:Parameter Name="original_VMI_DELAMINATION" Type="Decimal" />
                <asp:Parameter Name="original_EMC_USAGE_END" Type="DateTime" />
                <asp:Parameter Name="original_LOT_END_TIME" Type="DateTime" />
                <asp:Parameter Name="original_EMC_USAGE_START" Type="DateTime" />
                <asp:Parameter Name="original_WIRE_SWEEPING2" Type="String" />
                <asp:Parameter Name="original_WIRE_SWEEPING3" Type="String" />
                <asp:Parameter Name="original_WIRE_SWEEPING4" Type="String" />
                <asp:Parameter Name="original_WIRE_SWEEPING1" Type="String" />
                <asp:Parameter Name="original_WIRE_SWEEPING5" Type="String" />
                <asp:Parameter Name="original_DAMAGED_WIRE" Type="String" />
                <asp:Parameter Name="original_SAGGING_WIRE" Type="String" />
                <asp:Parameter Name="original_OPEN_WIRE" Type="String" />
                <asp:Parameter Name="original_SHORT_WIRE" Type="String" />
                <asp:Parameter Name="original_ACTUAL_CLEANING_TIME" Type="DateTime" />
                <asp:Parameter Name="original_CLEANING_REASON" Type="String" />
                <asp:Parameter Name="original_BRIDGE_BALL" Type="String" />
                <asp:Parameter Name="original_MISSING_BALL" Type="String" />
                <asp:Parameter Name="original_MOLD_TOP_NO1" Type="String" />
                <asp:Parameter Name="original_MOLD_TOP_NO2" Type="String" />
                <asp:Parameter Name="original_MOLD_TOP_NO4" Type="String" />
                <asp:Parameter Name="original_MOLD_BTM_NO1" Type="String" />
                <asp:Parameter Name="original_MOLD_BTM_NO2" Type="String" />
                <asp:Parameter Name="original_MOLD_BTM_NO3" Type="String" />
                <asp:Parameter Name="original_MOLD_TOP_NO3" Type="String" />
                <asp:Parameter Name="original_MOLD_BTM_NO4" Type="String" />
                <asp:Parameter Name="original_PIT" Type="String" />
                <asp:Parameter Name="original_BUBBLE" Type="String" />
                <asp:Parameter Name="original_MOLD_CAB" Type="String" />
                <asp:Parameter Name="original_PCB" Type="String" />
                <asp:Parameter Name="original_VACUUM_MONITOR1" Type="String" />
                <asp:Parameter Name="original_VACUUM_MONITOR3" Type="String" />
                <asp:Parameter Name="original_VACUUM_MONITOR2" Type="String" />
                <asp:Parameter Name="original_VACUUM_MONITOR4" Type="String" />
                <asp:Parameter Name="original_MCOMP_IQA" Type="String" />
                <asp:Parameter Name="original_CHASE1_RUBBER_WAX" Type="String" />
                <asp:Parameter Name="original_CHASE2_RUBBER_WAX" Type="String" />
                <asp:Parameter Name="original_CHASE3_RUBBER_WAX" Type="String" />
                <asp:Parameter Name="original_CHASE4_RUBBER_WAX" Type="String" />
                <asp:Parameter Name="original_AGING_TIME" Type="String" />
                <asp:Parameter Name="original_COMPOUND_TYPE" Type="String" />
                <asp:Parameter Name="original_PRE_HEAT_TIME" Type="String" />
                <asp:Parameter Name="original_VACCUM_PRESSURE" Type="String" />
                <asp:Parameter Name="original_FILM_BATCH1" Type="String" />
                <asp:Parameter Name="original_FILM_BATCH2" Type="String" />
                <asp:Parameter Name="original_FILM_BATCH3" Type="String" />
                <asp:Parameter Name="original_FILM_SAP1" Type="String" />
                <asp:Parameter Name="original_FILM_SAP2" Type="String" />
                <asp:Parameter Name="original_FILM_BATCH4" Type="String" />
                <asp:Parameter Name="original_FILM_SAP3" Type="String" />
                <asp:Parameter Name="original_FILM_SAP4" Type="String" />
                <asp:Parameter Name="original_PCB_THICKNESS2" Type="String" />
                <asp:Parameter Name="original_PCB_THICKNESS3" Type="String" />
                <asp:Parameter Name="original_PCB_THICKNESS4" Type="String" />
                <asp:Parameter Name="original_PCB_THICKNESS1" Type="String" />
                <asp:Parameter Name="original_MCOMP_BATCH_LOT2" Type="String" />
                <asp:Parameter Name="original_CLEANING_OPER_ID" Type="String" />
            </DeleteParameters>
            <InsertParameters>
                <asp:Parameter Name="SITENAME" Type="String" />
                <asp:Parameter Name="ELOGSHEET_TYPE" Type="String" />
                <asp:Parameter Name="MACHINE_ID" Type="String" />
                <asp:Parameter Name="LOTID" Type="String" />
                <asp:Parameter Name="PKG_TYPE" Type="String" />
                <asp:Parameter Name="PKG_BODY_SIZE" Type="String" />
                <asp:Parameter Name="CUST_NAME" Type="String" />
                <asp:Parameter Name="DEVICE_NO" Type="String" />
                <asp:Parameter Name="LOT_QTY" Type="Decimal" />
                <asp:Parameter Name="MCOMP_PART_NO" Type="String" />
                <asp:Parameter Name="MCOMP_BATCH_LOT" Type="String" />
                <asp:Parameter Name="MCOMP_EXP_DATE" Type="DateTime" />
                <asp:Parameter Name="MOLD_CHASE_NO1" Type="String" />
                <asp:Parameter Name="MOLD_CHASE_NO2" Type="String" />
                <asp:Parameter Name="MOLD_CHASE_NO3" Type="String" />
                <asp:Parameter Name="MOLD_CHASE_NO4" Type="String" />
                <asp:Parameter Name="STRIPS_QTY" Type="Decimal" />
                <asp:Parameter Name="TIME_CHECKED" Type="DateTime" />
                <asp:Parameter Name="EMPID" Type="String" />
                <asp:Parameter Name="CHASE1_SHEET_CLEAN" Type="Decimal" />
                <asp:Parameter Name="CHASE2_SHEET_CLEAN" Type="Decimal" />
                <asp:Parameter Name="CHASE3_SHEET_CLEAN" Type="Decimal" />
                <asp:Parameter Name="CHASE4_SHEET_CLEAN" Type="Decimal" />
                <asp:Parameter Name="CHASE1_DUMMY" Type="Decimal" />
                <asp:Parameter Name="CHASE2_DUMMY" Type="Decimal" />
                <asp:Parameter Name="CHASE3_DUMMY" Type="Decimal" />
                <asp:Parameter Name="CHASE4_DUMMY" Type="Decimal" />
                <asp:Parameter Name="MOLD_CLEAN_START" Type="DateTime" />
                <asp:Parameter Name="MOLD_CLEAN_END" Type="DateTime" />
                <asp:Parameter Name="MOLD_CLEAN_TIME" Type="Decimal" />
                <asp:Parameter Name="PPID" Type="String" />
                <asp:Parameter Name="TRANSFER_TIME" Type="Decimal" />
                <asp:Parameter Name="CURE_TIME" Type="Decimal" />
                <asp:Parameter Name="VMI_FLASH_BLEED" Type="Decimal" />
                <asp:Parameter Name="VMI_INCOMPLETE_FILL" Type="Decimal" />
                <asp:Parameter Name="VMI_CONTAMINATION" Type="Decimal" />
                <asp:Parameter Name="VMI_VOIDS" Type="Decimal" />
                <asp:Parameter Name="VMI_DENT" Type="Decimal" />
                <asp:Parameter Name="VMI_PKG_CRACK" Type="Decimal" />
                <asp:Parameter Name="VMI_GATE_REMAIN" Type="Decimal" />
                <asp:Parameter Name="VMI_PKG_OFFSET" Type="Decimal" />
                <asp:Parameter Name="VMI_WIRE_DEFFECTS" Type="Decimal" />
                <asp:Parameter Name="VMI_MISALIGN" Type="Decimal" />
                <asp:Parameter Name="VMI_FOL_REJECT" Type="Decimal" />
                <asp:Parameter Name="VMI_OTHERS" Type="Decimal" />
                <asp:Parameter Name="VMI_DEFECTS_QTY" Type="Decimal" />
                <asp:Parameter Name="VMI_STATUS" Type="String" />
                <asp:Parameter Name="VMI_SAMPLE_SIZE" Type="Decimal" />
                <asp:Parameter Name="BO" Type="String" />
                <asp:Parameter Name="REMARKS" Type="String" />
                <asp:Parameter Name="CHASE1_NOT_USED" Type="String" />
                <asp:Parameter Name="CHASE2_NOT_USED" Type="String" />
                <asp:Parameter Name="CHASE3_NOT_USED" Type="String" />
                <asp:Parameter Name="CHASE4_NOT_USED" Type="String" />
                <asp:Parameter Name="VMI_DELAMINATION" Type="Decimal" />
                <asp:Parameter Name="EMC_USAGE_END" Type="DateTime" />
                <asp:Parameter Name="LOT_END_TIME" Type="DateTime" />
                <asp:Parameter Name="EMC_USAGE_START" Type="DateTime" />
                <asp:Parameter Name="WIRE_SWEEPING2" Type="String" />
                <asp:Parameter Name="WIRE_SWEEPING3" Type="String" />
                <asp:Parameter Name="WIRE_SWEEPING4" Type="String" />
                <asp:Parameter Name="WIRE_SWEEPING1" Type="String" />
                <asp:Parameter Name="WIRE_SWEEPING5" Type="String" />
                <asp:Parameter Name="DAMAGED_WIRE" Type="String" />
                <asp:Parameter Name="SAGGING_WIRE" Type="String" />
                <asp:Parameter Name="OPEN_WIRE" Type="String" />
                <asp:Parameter Name="SHORT_WIRE" Type="String" />
                <asp:Parameter Name="ACTUAL_CLEANING_TIME" Type="Datetime" />
                <asp:Parameter Name="CLEANING_REASON" Type="String" />
                <asp:Parameter Name="BRIDGE_BALL" Type="String" />
                <asp:Parameter Name="MISSING_BALL" Type="String" />
                <asp:Parameter Name="MOLD_TOP_NO1" Type="String" />
                <asp:Parameter Name="MOLD_TOP_NO2" Type="String" />
                <asp:Parameter Name="MOLD_TOP_NO4" Type="String" />
                <asp:Parameter Name="MOLD_BTM_NO1" Type="String" />
                <asp:Parameter Name="MOLD_BTM_NO2" Type="String" />
                <asp:Parameter Name="MOLD_BTM_NO3" Type="String" />
                <asp:Parameter Name="MOLD_TOP_NO3" Type="String" />
                <asp:Parameter Name="MOLD_BTM_NO4" Type="String" />
                <asp:Parameter Name="PIT" Type="String" />
                <asp:Parameter Name="BUBBLE" Type="String" />
                <asp:Parameter Name="MOLD_CAB" Type="String" />
                <asp:Parameter Name="PCB" Type="String" />
                <asp:Parameter Name="VACUUM_MONITOR1" Type="String" />
                <asp:Parameter Name="VACUUM_MONITOR3" Type="String" />
                <asp:Parameter Name="VACUUM_MONITOR2" Type="String" />
                <asp:Parameter Name="VACUUM_MONITOR4" Type="String" />
                <asp:Parameter Name="MCOMP_IQA" Type="String" />
                <asp:Parameter Name="CHASE1_RUBBER_WAX" Type="String" />
                <asp:Parameter Name="CHASE2_RUBBER_WAX" Type="String" />
                <asp:Parameter Name="CHASE3_RUBBER_WAX" Type="String" />
                <asp:Parameter Name="CHASE4_RUBBER_WAX" Type="String" />
                <asp:Parameter Name="AGING_TIME" Type="String" />
                <asp:Parameter Name="COMPOUND_TYPE" Type="String" />
                <asp:Parameter Name="PRE_HEAT_TIME" Type="String" />
                <asp:Parameter Name="VACCUM_PRESSURE" Type="String" />
                <asp:Parameter Name="FILM_BATCH1" Type="String" />
                <asp:Parameter Name="FILM_BATCH2" Type="String" />
                <asp:Parameter Name="FILM_BATCH3" Type="String" />
                <asp:Parameter Name="FILM_SAP1" Type="String" />
                <asp:Parameter Name="FILM_SAP2" Type="String" />
                <asp:Parameter Name="FILM_BATCH4" Type="String" />
                <asp:Parameter Name="FILM_SAP3" Type="String" />
                <asp:Parameter Name="FILM_SAP4" Type="String" />
                <asp:Parameter Name="PCB_THICKNESS2" Type="String" />
                <asp:Parameter Name="PCB_THICKNESS3" Type="String" />
                <asp:Parameter Name="PCB_THICKNESS4" Type="String" />
                <asp:Parameter Name="PCB_THICKNESS1" Type="String" />
                <asp:Parameter Name="MCOMP_BATCH_LOT2" Type="String" />
                <asp:Parameter Name="CLEANING_OPER_ID" Type="String" />
                <asp:Parameter Name="SEQ" Type="Decimal" />
            </InsertParameters>
            <SelectParameters>
                <asp:ControlParameter ControlID="txtLotID" Name="LOTID" PropertyName="Text" 
                    Type="String" />
            </SelectParameters>
            <UpdateParameters>
                <asp:Parameter Name="SITENAME" Type="String" />
                <asp:Parameter Name="ELOGSHEET_TYPE" Type="String" />
                <asp:Parameter Name="MACHINE_ID" Type="String" />
                <asp:Parameter Name="LOTID" Type="String" />
                <asp:Parameter Name="PKG_TYPE" Type="String" />
                <asp:Parameter Name="PKG_BODY_SIZE" Type="String" />
                <asp:Parameter Name="CUST_NAME" Type="String" />
                <asp:Parameter Name="DEVICE_NO" Type="String" />
                <asp:Parameter Name="LOT_QTY" Type="Decimal" />
                <asp:Parameter Name="MCOMP_PART_NO" Type="String" />
                <asp:Parameter Name="MCOMP_BATCH_LOT" Type="String" />
                <asp:Parameter Name="MCOMP_EXP_DATE" Type="DateTime" />
                <asp:Parameter Name="MOLD_CHASE_NO1" Type="String" />
                <asp:Parameter Name="MOLD_CHASE_NO2" Type="String" />
                <asp:Parameter Name="MOLD_CHASE_NO3" Type="String" />
                <asp:Parameter Name="MOLD_CHASE_NO4" Type="String" />
                <asp:Parameter Name="STRIPS_QTY" Type="Decimal" />
                <asp:Parameter Name="TIME_CHECKED" Type="DateTime" />
                <asp:Parameter Name="EMPID" Type="String" />
                <asp:Parameter Name="CHASE1_SHEET_CLEAN" Type="Decimal" />
                <asp:Parameter Name="CHASE2_SHEET_CLEAN" Type="Decimal" />
                <asp:Parameter Name="CHASE3_SHEET_CLEAN" Type="Decimal" />
                <asp:Parameter Name="CHASE4_SHEET_CLEAN" Type="Decimal" />
                <asp:Parameter Name="CHASE1_DUMMY" Type="Decimal" />
                <asp:Parameter Name="CHASE2_DUMMY" Type="Decimal" />
                <asp:Parameter Name="CHASE3_DUMMY" Type="Decimal" />
                <asp:Parameter Name="CHASE4_DUMMY" Type="Decimal" />
                <asp:Parameter Name="MOLD_CLEAN_START" Type="DateTime" />
                <asp:Parameter Name="MOLD_CLEAN_END" Type="DateTime" />
                <asp:Parameter Name="MOLD_CLEAN_TIME" Type="Decimal" />
                <asp:Parameter Name="PPID" Type="String" />
                <asp:Parameter Name="TRANSFER_TIME" Type="Decimal" />
                <asp:Parameter Name="CURE_TIME" Type="Decimal" />
                <asp:Parameter Name="VMI_FLASH_BLEED" Type="Decimal" />
                <asp:Parameter Name="VMI_INCOMPLETE_FILL" Type="Decimal" />
                <asp:Parameter Name="VMI_CONTAMINATION" Type="Decimal" />
                <asp:Parameter Name="VMI_VOIDS" Type="Decimal" />
                <asp:Parameter Name="VMI_DENT" Type="Decimal" />
                <asp:Parameter Name="VMI_PKG_CRACK" Type="Decimal" />
                <asp:Parameter Name="VMI_GATE_REMAIN" Type="Decimal" />
                <asp:Parameter Name="VMI_PKG_OFFSET" Type="Decimal" />
                <asp:Parameter Name="VMI_WIRE_DEFFECTS" Type="Decimal" />
                <asp:Parameter Name="VMI_MISALIGN" Type="Decimal" />
                <asp:Parameter Name="VMI_FOL_REJECT" Type="Decimal" />
                <asp:Parameter Name="VMI_OTHERS" Type="Decimal" />
                <asp:Parameter Name="VMI_DEFECTS_QTY" Type="Decimal" />
                <asp:Parameter Name="VMI_STATUS" Type="String" />
                <asp:Parameter Name="VMI_SAMPLE_SIZE" Type="Decimal" />
                <asp:Parameter Name="BO" Type="String" />
                <asp:Parameter Name="REMARKS" Type="String" />
                <asp:Parameter Name="CHASE1_NOT_USED" Type="String" />
                <asp:Parameter Name="CHASE2_NOT_USED" Type="String" />
                <asp:Parameter Name="CHASE3_NOT_USED" Type="String" />
                <asp:Parameter Name="CHASE4_NOT_USED" Type="String" />
                <asp:Parameter Name="VMI_DELAMINATION" Type="Decimal" />
                <asp:Parameter Name="EMC_USAGE_END" Type="DateTime" />
                <asp:Parameter Name="LOT_END_TIME" Type="DateTime" />
                <asp:Parameter Name="EMC_USAGE_START" Type="DateTime" />
                <asp:Parameter Name="WIRE_SWEEPING2" Type="String" />
                <asp:Parameter Name="WIRE_SWEEPING3" Type="String" />
                <asp:Parameter Name="WIRE_SWEEPING4" Type="String" />
                <asp:Parameter Name="WIRE_SWEEPING1" Type="String" />
                <asp:Parameter Name="WIRE_SWEEPING5" Type="String" />
                <asp:Parameter Name="DAMAGED_WIRE" Type="String" />
                <asp:Parameter Name="SAGGING_WIRE" Type="String" />
                <asp:Parameter Name="OPEN_WIRE" Type="String" />
                <asp:Parameter Name="SHORT_WIRE" Type="String" />
                <asp:Parameter Name="ACTUAL_CLEANING_TIME" Type="Datetime" />
                <asp:Parameter Name="CLEANING_REASON" Type="String" />
                <asp:Parameter Name="BRIDGE_BALL" Type="String" />
                <asp:Parameter Name="MISSING_BALL" Type="String" />
                <asp:Parameter Name="MOLD_TOP_NO1" Type="String" />
                <asp:Parameter Name="MOLD_TOP_NO2" Type="String" />
                <asp:Parameter Name="MOLD_TOP_NO4" Type="String" />
                <asp:Parameter Name="MOLD_BTM_NO1" Type="String" />
                <asp:Parameter Name="MOLD_BTM_NO2" Type="String" />
                <asp:Parameter Name="MOLD_BTM_NO3" Type="String" />
                <asp:Parameter Name="MOLD_TOP_NO3" Type="String" />
                <asp:Parameter Name="MOLD_BTM_NO4" Type="String" />
                <asp:Parameter Name="PIT" Type="String" />
                <asp:Parameter Name="BUBBLE" Type="String" />
                <asp:Parameter Name="MOLD_CAB" Type="String" />
                <asp:Parameter Name="PCB" Type="String" />
                <asp:Parameter Name="VACUUM_MONITOR1" Type="String" />
                <asp:Parameter Name="VACUUM_MONITOR3" Type="String" />
                <asp:Parameter Name="VACUUM_MONITOR2" Type="String" />
                <asp:Parameter Name="VACUUM_MONITOR4" Type="String" />
                <asp:Parameter Name="MCOMP_IQA" Type="String" />
                <asp:Parameter Name="CHASE1_RUBBER_WAX" Type="String" />
                <asp:Parameter Name="CHASE2_RUBBER_WAX" Type="String" />
                <asp:Parameter Name="CHASE3_RUBBER_WAX" Type="String" />
                <asp:Parameter Name="CHASE4_RUBBER_WAX" Type="String" />
                <asp:Parameter Name="AGING_TIME" Type="String" />
                <asp:Parameter Name="COMPOUND_TYPE" Type="String" />
                <asp:Parameter Name="PRE_HEAT_TIME" Type="String" />
                <asp:Parameter Name="VACCUM_PRESSURE" Type="String" />
                <asp:Parameter Name="FILM_BATCH1" Type="String" />
                <asp:Parameter Name="FILM_BATCH2" Type="String" />
                <asp:Parameter Name="FILM_BATCH3" Type="String" />
                <asp:Parameter Name="FILM_SAP1" Type="String" />
                <asp:Parameter Name="FILM_SAP2" Type="String" />
                <asp:Parameter Name="FILM_BATCH4" Type="String" />
                <asp:Parameter Name="FILM_SAP3" Type="String" />
                <asp:Parameter Name="FILM_SAP4" Type="String" />
                <asp:Parameter Name="PCB_THICKNESS2" Type="String" />
                <asp:Parameter Name="PCB_THICKNESS3" Type="String" />
                <asp:Parameter Name="PCB_THICKNESS4" Type="String" />
                <asp:Parameter Name="PCB_THICKNESS1" Type="String" />
                <asp:Parameter Name="MCOMP_BATCH_LOT2" Type="String" />
                <asp:Parameter Name="CLEANING_OPER_ID" Type="String" />
                <asp:Parameter Name="original_SEQ" Type="Decimal" />
                <asp:Parameter Name="original_SITENAME" Type="String" />
                <asp:Parameter Name="original_ELOGSHEET_TYPE" Type="String" />
                <asp:Parameter Name="original_MACHINE_ID" Type="String" />
                <asp:Parameter Name="original_LOTID" Type="String" />
                <asp:Parameter Name="original_PKG_TYPE" Type="String" />
                <asp:Parameter Name="original_PKG_BODY_SIZE" Type="String" />
                <asp:Parameter Name="original_CUST_NAME" Type="String" />
                <asp:Parameter Name="original_DEVICE_NO" Type="String" />
                <asp:Parameter Name="original_LOT_QTY" Type="Decimal" />
                <asp:Parameter Name="original_MCOMP_PART_NO" Type="String" />
                <asp:Parameter Name="original_MCOMP_BATCH_LOT" Type="String" />
                <asp:Parameter Name="original_MCOMP_EXP_DATE" Type="DateTime" />
                <asp:Parameter Name="original_MOLD_CHASE_NO1" Type="String" />
                <asp:Parameter Name="original_MOLD_CHASE_NO2" Type="String" />
                <asp:Parameter Name="original_MOLD_CHASE_NO3" Type="String" />
                <asp:Parameter Name="original_MOLD_CHASE_NO4" Type="String" />
                <asp:Parameter Name="original_STRIPS_QTY" Type="Decimal" />
                <asp:Parameter Name="original_TIME_CHECKED" Type="DateTime" />
                <asp:Parameter Name="original_EMPID" Type="String" />
                <asp:Parameter Name="original_CHASE1_SHEET_CLEAN" Type="Decimal" />
                <asp:Parameter Name="original_CHASE2_SHEET_CLEAN" Type="Decimal" />
                <asp:Parameter Name="original_CHASE3_SHEET_CLEAN" Type="Decimal" />
                <asp:Parameter Name="original_CHASE4_SHEET_CLEAN" Type="Decimal" />
                <asp:Parameter Name="original_CHASE1_DUMMY" Type="Decimal" />
                <asp:Parameter Name="original_CHASE2_DUMMY" Type="Decimal" />
                <asp:Parameter Name="original_CHASE3_DUMMY" Type="Decimal" />
                <asp:Parameter Name="original_CHASE4_DUMMY" Type="Decimal" />
                <asp:Parameter Name="original_MOLD_CLEAN_START" Type="DateTime" />
                <asp:Parameter Name="original_MOLD_CLEAN_END" Type="DateTime" />
                <asp:Parameter Name="original_MOLD_CLEAN_TIME" Type="Decimal" />
                <asp:Parameter Name="original_PPID" Type="String" />
                <asp:Parameter Name="original_TRANSFER_TIME" Type="Decimal" />
                <asp:Parameter Name="original_CURE_TIME" Type="Decimal" />
                <asp:Parameter Name="original_VMI_FLASH_BLEED" Type="Decimal" />
                <asp:Parameter Name="original_VMI_INCOMPLETE_FILL" Type="Decimal" />
                <asp:Parameter Name="original_VMI_CONTAMINATION" Type="Decimal" />
                <asp:Parameter Name="original_VMI_VOIDS" Type="Decimal" />
                <asp:Parameter Name="original_VMI_DENT" Type="Decimal" />
                <asp:Parameter Name="original_VMI_PKG_CRACK" Type="Decimal" />
                <asp:Parameter Name="original_VMI_GATE_REMAIN" Type="Decimal" />
                <asp:Parameter Name="original_VMI_PKG_OFFSET" Type="Decimal" />
                <asp:Parameter Name="original_VMI_WIRE_DEFFECTS" Type="Decimal" />
                <asp:Parameter Name="original_VMI_MISALIGN" Type="Decimal" />
                <asp:Parameter Name="original_VMI_FOL_REJECT" Type="Decimal" />
                <asp:Parameter Name="original_VMI_OTHERS" Type="Decimal" />
                <asp:Parameter Name="original_VMI_DEFECTS_QTY" Type="Decimal" />
                <asp:Parameter Name="original_VMI_STATUS" Type="String" />
                <asp:Parameter Name="original_VMI_SAMPLE_SIZE" Type="Decimal" />
                <asp:Parameter Name="original_BO" Type="String" />
                <asp:Parameter Name="original_REMARKS" Type="String" />
                <asp:Parameter Name="original_CHASE1_NOT_USED" Type="String" />
                <asp:Parameter Name="original_CHASE2_NOT_USED" Type="String" />
                <asp:Parameter Name="original_CHASE3_NOT_USED" Type="String" />
                <asp:Parameter Name="original_CHASE4_NOT_USED" Type="String" />
                <asp:Parameter Name="original_VMI_DELAMINATION" Type="Decimal" />
                <asp:Parameter Name="original_EMC_USAGE_END" Type="DateTime" />
                <asp:Parameter Name="original_LOT_END_TIME" Type="DateTime" />
                <asp:Parameter Name="original_EMC_USAGE_START" Type="DateTime" />
                <asp:Parameter Name="original_WIRE_SWEEPING2" Type="String" />
                <asp:Parameter Name="original_WIRE_SWEEPING3" Type="String" />
                <asp:Parameter Name="original_WIRE_SWEEPING4" Type="String" />
                <asp:Parameter Name="original_WIRE_SWEEPING1" Type="String" />
                <asp:Parameter Name="original_WIRE_SWEEPING5" Type="String" />
                <asp:Parameter Name="original_DAMAGED_WIRE" Type="String" />
                <asp:Parameter Name="original_SAGGING_WIRE" Type="String" />
                <asp:Parameter Name="original_OPEN_WIRE" Type="String" />
                <asp:Parameter Name="original_SHORT_WIRE" Type="String" />
                <asp:Parameter Name="original_ACTUAL_CLEANING_TIME" Type="Datetime" />
                <asp:Parameter Name="original_CLEANING_REASON" Type="String" />
                <asp:Parameter Name="original_BRIDGE_BALL" Type="String" />
                <asp:Parameter Name="original_MISSING_BALL" Type="String" />
                <asp:Parameter Name="original_MOLD_TOP_NO1" Type="String" />
                <asp:Parameter Name="original_MOLD_TOP_NO2" Type="String" />
                <asp:Parameter Name="original_MOLD_TOP_NO4" Type="String" />
                <asp:Parameter Name="original_MOLD_BTM_NO1" Type="String" />
                <asp:Parameter Name="original_MOLD_BTM_NO2" Type="String" />
                <asp:Parameter Name="original_MOLD_BTM_NO3" Type="String" />
                <asp:Parameter Name="original_MOLD_TOP_NO3" Type="String" />
                <asp:Parameter Name="original_MOLD_BTM_NO4" Type="String" />
                <asp:Parameter Name="original_PIT" Type="String" />
                <asp:Parameter Name="original_BUBBLE" Type="String" />
                <asp:Parameter Name="original_MOLD_CAB" Type="String" />
                <asp:Parameter Name="original_PCB" Type="String" />
                <asp:Parameter Name="original_VACUUM_MONITOR1" Type="String" />
                <asp:Parameter Name="original_VACUUM_MONITOR3" Type="String" />
                <asp:Parameter Name="original_VACUUM_MONITOR2" Type="String" />
                <asp:Parameter Name="original_VACUUM_MONITOR4" Type="String" />
                <asp:Parameter Name="original_MCOMP_IQA" Type="String" />
                <asp:Parameter Name="original_CHASE1_RUBBER_WAX" Type="String" />
                <asp:Parameter Name="original_CHASE2_RUBBER_WAX" Type="String" />
                <asp:Parameter Name="original_CHASE3_RUBBER_WAX" Type="String" />
                <asp:Parameter Name="original_CHASE4_RUBBER_WAX" Type="String" />
                <asp:Parameter Name="original_AGING_TIME" Type="String" />
                <asp:Parameter Name="original_COMPOUND_TYPE" Type="String" />
                <asp:Parameter Name="original_PRE_HEAT_TIME" Type="String" />
                <asp:Parameter Name="original_VACCUM_PRESSURE" Type="String" />
                <asp:Parameter Name="original_FILM_BATCH1" Type="String" />
                <asp:Parameter Name="original_FILM_BATCH2" Type="String" />
                <asp:Parameter Name="original_FILM_BATCH3" Type="String" />
                <asp:Parameter Name="original_FILM_SAP1" Type="String" />
                <asp:Parameter Name="original_FILM_SAP2" Type="String" />
                <asp:Parameter Name="original_FILM_BATCH4" Type="String" />
                <asp:Parameter Name="original_FILM_SAP3" Type="String" />
                <asp:Parameter Name="original_FILM_SAP4" Type="String" />
                <asp:Parameter Name="original_PCB_THICKNESS2" Type="String" />
                <asp:Parameter Name="original_PCB_THICKNESS3" Type="String" />
                <asp:Parameter Name="original_PCB_THICKNESS4" Type="String" />
                <asp:Parameter Name="original_PCB_THICKNESS1" Type="String" />
                <asp:Parameter Name="original_MCOMP_BATCH_LOT2" Type="String" />
                <asp:Parameter Name="original_CLEANING_OPER_ID" Type="String" />
            </UpdateParameters>
        </asp:SqlDataSource>
    </p>
<p>
    &nbsp;</p>
</asp:Content>
