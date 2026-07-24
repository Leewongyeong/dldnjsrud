<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="SBM_QA.aspx.cs" Inherits="Data_modify.SBM_QA" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <style type="text/css">
        .style4 {
            height: 32px;
        }

        .style3 {
            width: 226px;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <p>
        <table id="Table1" border="0" cellpadding="1" cellspacing="1"
            style="width: 875px; height: 72px" width="875">
            <tr>
                <td colspan="2" class="style4">
                    <font color="#4169e1" face="Tahoma" size="2">SBM QA Data 수정 및 삭제</font></td>
            </tr>
            <tr>
                <td class="style3" style="color: #FF0000">Lot ID</td>
                <td>
                    <asp:TextBox ID="txtLotID" runat="server" AutoPostBack="True"
                        BackColor="#FFFFCC" BorderColor="#8080FF" BorderWidth="1px"
                        CssClass="RptTextBox_NoEdit" Font-Names="Tahoma" Font-Size="Small" TabIndex="1"
                        Width="232px"></asp:TextBox>
                </td>
            </tr>
        </table>
        <asp:GridView ID="GridView1" runat="server"
            AutoGenerateColumns="False" BackColor="White" BorderColor="#DEDFDE"
            BorderStyle="None" BorderWidth="1px" CellPadding="4" DataKeyNames="LOTID,EQUIPID,ELOGSHEETYPE,QA_CREATED_ON"
            DataSourceID="SqlDataSource1" ForeColor="Black" GridLines="Vertical"
            Font-Names="Tahoma" Font-Size="X-Small">
            <AlternatingRowStyle BackColor="White" />
            <Columns>
                <asp:CommandField ShowDeleteButton="True" ShowEditButton="True" />
                <asp:BoundField DataField="LOTID" HeaderText="LOTID"
                    SortExpression="LOTID" ReadOnly="True" />
                <asp:BoundField DataField="EQUIPID" HeaderText="EQUIPID" ReadOnly="True"
                    SortExpression="EQUIPID" />
                <asp:BoundField DataField="ELOGSHEETYPE" HeaderText="ELOGSHEETYPE"
                    ReadOnly="True" SortExpression="ELOGSHEETYPE" />
                <asp:BoundField DataField="CUSTOMER" HeaderText="CUSTOMER"
                    SortExpression="CUSTOMER" />
                <asp:BoundField DataField="DEVICE" HeaderText="DEVICE"
                    SortExpression="DEVICE" />
                <asp:BoundField DataField="PKG" HeaderText="PKG" SortExpression="PKG" />
                <asp:BoundField DataField="LEAD" HeaderText="LEAD" SortExpression="LEAD" />
                <asp:BoundField DataField="SOPTYPE" HeaderText="SOPTYPE"
                    SortExpression="SOPTYPE" />
                <asp:BoundField DataField="PEAKTEMP" HeaderText="PEAKTEMP"
                    SortExpression="PEAKTEMP" />
                <asp:BoundField DataField="SOLDER_BALL_SIZE" HeaderText="SOLDER_BALL_SIZE"
                    SortExpression="SOLDER_BALL_SIZE" />
                <asp:BoundField DataField="DWELLTIME" HeaderText="DWELLTIME"
                    SortExpression="DWELLTIME" />
                <asp:BoundField DataField="SOAKTIME" HeaderText="SOAKTIME"
                    SortExpression="SOAKTIME" />
                <asp:BoundField DataField="BELTSPEED" HeaderText="BELTSPEED"
                    SortExpression="BELTSPEED" />
                <asp:BoundField DataField="COOLINGRATE" HeaderText="COOLINGRATE"
                    SortExpression="COOLINGRATE" />
                <asp:BoundField DataField="COOLINGRATE_EXIT" HeaderText="COOLINGRATE_EXIT"
                    SortExpression="COOLINGRATE_EXIT" />
                <asp:BoundField DataField="DAMAGEDBALL" HeaderText="DAMAGEDBALL"
                    SortExpression="DAMAGEDBALL" />
                <asp:BoundField DataField="FLUX_RESIDUE" HeaderText="FLUX_RESIDUE"
                    SortExpression="FLUX_RESIDUE" />
                <asp:BoundField DataField="MISSINGSOLDERBALL" HeaderText="MISSINGSOLDERBALL"
                    SortExpression="MISSINGSOLDERBALL" />
                <asp:BoundField DataField="DOUBLEBALL" HeaderText="DOUBLEBALL"
                    SortExpression="DOUBLEBALL" />
                <asp:BoundField DataField="BALLBRIDGING" HeaderText="BALLBRIDGING"
                    SortExpression="BALLBRIDGING" />
                <asp:BoundField DataField="SOLDERBALLPLACE" HeaderText="SOLDERBALLPLACE"
                    SortExpression="SOLDERBALLPLACE" />
                <asp:BoundField DataField="IPD_SBM_TYPE" HeaderText="IPD_SBM_TYPE" SortExpression="IPD_SBM_TYPE" />
                <asp:BoundField DataField="IPD_SBM_SAPCODE" HeaderText="IPD_SBM_SAPCODE" SortExpression="IPD_SBM_SAPCODE" />
                <asp:BoundField DataField="IPD_SBM_SIZE" HeaderText="IPD_SBM_SIZE" SortExpression="IPD_SBM_SIZE" />
                <asp:BoundField DataField="IPD_SBM_MF" HeaderText="IPD_SBM_MF" SortExpression="IPD_SBM_MF" />
                <asp:BoundField DataField="IPD_SBM_EXP" HeaderText="IPD_SBM_EXP" SortExpression="IPD_SBM_EXP" />
                <asp:BoundField DataField="IPD_FLUX_TYPE" HeaderText="IPD_FLUX_TYPE" SortExpression="IPD_FLUX_TYPE" />
                <asp:BoundField DataField="IPD_FLUX_SAPCODE" HeaderText="IPD_FLUX_SAPCODE" SortExpression="IPD_FLUX_SAPCODE" />
                <asp:BoundField DataField="IPD_FLUX_EXP" HeaderText="IPD_FLUX_EXP" SortExpression="IPD_FLUX_EXP" />
                <asp:BoundField DataField="IPD_FLUX_DUE" HeaderText="IPD_FLUX_DUE" SortExpression="IPD_FLUX_DUE" />
                <asp:BoundField DataField="IPD_MC_ID" HeaderText="IPD_MC_ID" SortExpression="IPD_MC_ID" />
                <asp:BoundField DataField="IPD_SAPCODE1" HeaderText="IPD_SAPCODE1" SortExpression="IPD_SAPCODE1" />
                <asp:BoundField DataField="IPD_SAPCODE2" HeaderText="IPD_SAPCODE2" SortExpression="IPD_SAPCODE2" />
                <asp:BoundField DataField="IPD_SAPCODE3" HeaderText="IPD_SAPCODE3" SortExpression="IPD_SAPCODE3" />
                <asp:BoundField DataField="PASTE_DUE" HeaderText="PASTE_DUE" SortExpression="PASTE_DUE" />
                <asp:BoundField DataField="VISUALINS_SAMPLE" HeaderText="VISUALINS_SAMPLE"
                    SortExpression="VISUALINS_SAMPLE" />
                <asp:BoundField DataField="VISUALINS_DEFECT" HeaderText="VISUALINS_DEFECT"
                    SortExpression="VISUALINS_DEFECT" />
                <asp:BoundField DataField="SOLDERBALLMISALIGN" HeaderText="SOLDERBALLMISALIGN"
                    SortExpression="SOLDERBALLMISALIGN" />
                <asp:BoundField DataField="FMONSOLDERBALL" HeaderText="FMONSOLDERBALL"
                    SortExpression="FMONSOLDERBALL" />
                <asp:BoundField DataField="OTHERS" HeaderText="OTHERS"
                    SortExpression="OTHERS" />
                <asp:BoundField DataField="OTHERS_QTY" HeaderText="OTHERS_QTY"
                    SortExpression="OTHERS_QTY" />
                <asp:BoundField DataField="SCRUBBINGTEST" HeaderText="SCRUBBINGTEST"
                    SortExpression="SCRUBBINGTEST" />
                <asp:BoundField DataField="WINDOWTIME" HeaderText="WINDOWTIME"
                    SortExpression="WINDOWTIME" />
                <asp:BoundField DataField="PMCIN" HeaderText="PMCIN" SortExpression="PMCIN" />
                <asp:BoundField DataField="SBMIN" HeaderText="SBMIN" SortExpression="SBMIN" />
                <asp:BoundField DataField="LSI_LEAD" HeaderText="LSI_LEAD"
                    SortExpression="LSI_LEAD" />
                <asp:BoundField DataField="ATI_LEAD" HeaderText="ATI_LEAD"
                    SortExpression="ATI_LEAD" />
                <asp:BoundField DataField="N2" HeaderText="N2" SortExpression="N2" />
                <asp:BoundField DataField="N2_UNIT" HeaderText="N2_UNIT"
                    SortExpression="N2_UNIT" />
                <asp:BoundField DataField="O2" HeaderText="O2" SortExpression="O2" />
                <asp:BoundField DataField="Y_SUBMIT_BY" HeaderText="Y_SUBMIT_BY"
                    SortExpression="Y_SUBMIT_BY" />
                <asp:BoundField DataField="Y_SUBMIT_DATE" HeaderText="Y_SUBMIT_DATE"
                    SortExpression="Y_SUBMIT_DATE" />
                <asp:BoundField DataField="ELOGSHEET_RESULT" HeaderText="ELOGSHEET_RESULT"
                    SortExpression="ELOGSHEET_RESULT" />
                <asp:BoundField DataField="BUYOFF_DATE" HeaderText="BUYOFF_DATE"
                    SortExpression="BUYOFF_DATE" />
                <asp:BoundField DataField="BUYOFF_BY" HeaderText="BUYOFF_BY"
                    SortExpression="BUYOFF_BY" />
                <asp:BoundField DataField="REMARKS" HeaderText="REMARKS"
                    SortExpression="REMARKS" />
                <asp:BoundField DataField="LINK_KEY" HeaderText="LINK_KEY"
                    SortExpression="LINK_KEY" />
                <asp:BoundField DataField="CREATED_ON" HeaderText="CREATED_ON"
                    SortExpression="CREATED_ON" />
                <asp:BoundField DataField="PMCOUT" HeaderText="PMCOUT"
                    SortExpression="PMCOUT" />
                <asp:BoundField DataField="SOLDER_BALL_PROCESS"
                    HeaderText="SOLDER_BALL_PROCESS" SortExpression="SOLDER_BALL_PROCESS" />
                <asp:BoundField DataField="SOLDER_BALL_MF" HeaderText="SOLDER_BALL_MF"
                    SortExpression="SOLDER_BALL_MF" />
                <asp:BoundField DataField="SOLDER_BALL_EXP" HeaderText="SOLDER_BALL_EXP"
                    SortExpression="SOLDER_BALL_EXP" />
                <asp:BoundField DataField="FLUX_TYPE" HeaderText="FLUX_TYPE"
                    SortExpression="FLUX_TYPE" />
                <asp:BoundField DataField="FLUX_USE_DUE_DATE" HeaderText="FLUX_USE_DUE_DATE"
                    SortExpression="FLUX_USE_DUE_DATE" />
                <asp:BoundField DataField="LAMP_UP_RATE" HeaderText="LAMP_UP_RATE"
                    SortExpression="LAMP_UP_RATE" />
                <asp:BoundField DataField="SDA_CURE_OUT" HeaderText="SDA_CURE_OUT"
                    SortExpression="SDA_CURE_OUT" />
                <asp:BoundField DataField="STRIP_NO" HeaderText="STRIP_NO"
                    SortExpression="STRIP_NO" />
                <asp:BoundField DataField="SBMIN2" HeaderText="SBMIN2"
                    SortExpression="SBMIN2" />
                <asp:BoundField DataField="SOLDER_BALL_S_TEST" HeaderText="SOLDER_BALL_S_TEST"
                    SortExpression="SOLDER_BALL_S_TEST" />
                <asp:BoundField DataField="SOLDER_BALL_P_TEST" HeaderText="SOLDER_BALL_P_TEST"
                    SortExpression="SOLDER_BALL_P_TEST" />
                <asp:BoundField DataField="ZONE_SHEAR_TEST" HeaderText="ZONE_SHEAR_TEST"
                    SortExpression="ZONE_SHEAR_TEST" />
                <asp:BoundField DataField="FLUX_EXPIRATION" HeaderText="FLUX_EXPIRATION"
                    SortExpression="FLUX_EXPIRATION" />
                <asp:BoundField DataField="WINDOWTIME2" HeaderText="WINDOWTIME2"
                    SortExpression="WINDOWTIME2" />
                <asp:BoundField DataField="SBMTYPE" HeaderText="SBMTYPE"
                    SortExpression="SBMTYPE" />
                <asp:BoundField DataField="PCBSAPCODE" HeaderText="PCBSAPCODE"
                    SortExpression="PCBSAPCODE" />
                <asp:BoundField DataField="RECIPENAME" HeaderText="RECIPENAME"
                    SortExpression="RECIPENAME" />
                <asp:BoundField DataField="SB_SIZE_DATA1" HeaderText="SB_SIZE_DATA1"
                    SortExpression="SB_SIZE_DATA1" />
                <asp:BoundField DataField="SB_SIZE_DATA2" HeaderText="SB_SIZE_DATA2"
                    SortExpression="SB_SIZE_DATA2" />
                <asp:BoundField DataField="SB_SIZE_DATA3" HeaderText="SB_SIZE_DATA3"
                    SortExpression="SB_SIZE_DATA3" />
                <asp:BoundField DataField="SB_SIZE_DATA4" HeaderText="SB_SIZE_DATA4"
                    SortExpression="SB_SIZE_DATA4" />
                <asp:BoundField DataField="SB_SIZE_DATA5" HeaderText="SB_SIZE_DATA5"
                    SortExpression="SB_SIZE_DATA5" />
                <asp:BoundField DataField="CONVERSION_FROM" HeaderText="CONVERSION_FROM"
                    SortExpression="CONVERSION_FROM" />
                <asp:BoundField DataField="CONVERSION_TO" HeaderText="CONVERSION_TO"
                    SortExpression="CONVERSION_TO" />
                <asp:BoundField DataField="SBM_SAPCODE" HeaderText="SBM_SAPCODE"
                    SortExpression="SBM_SAPCODE" />
                <asp:BoundField DataField="SBM_MODEL" HeaderText="SBM_MODEL"
                    SortExpression="SBM_MODEL" />
                <asp:BoundField DataField="PCB_TYPE" HeaderText="PCB_TYPE"
                    SortExpression="PCB_TYPE" />
                <asp:BoundField DataField="QA_CREATED_ON" HeaderText="QA_CREATED_ON"
                    ReadOnly="True" SortExpression="QA_CREATED_ON" />
                <asp:BoundField DataField="UNIT" HeaderText="UNIT" SortExpression="UNIT" />
                <asp:BoundField DataField="SB_SIZE_DATA6" HeaderText="SB_SIZE_DATA6"
                    SortExpression="SB_SIZE_DATA6" />
                <asp:BoundField DataField="SB_SIZE_UNIT" HeaderText="SB_SIZE_UNIT"
                    SortExpression="SB_SIZE_UNIT" />
                <asp:BoundField DataField="SB_HEIGHT_UNIT" HeaderText="SB_HEIGHT_UNIT"
                    SortExpression="SB_HEIGHT_UNIT" />
                <asp:BoundField DataField="REJ_STRIP_NO" HeaderText="REJ_STRIP_NO"
                    SortExpression="REJ_STRIP_NO" />
                <asp:BoundField DataField="REJ_UNIT_ID" HeaderText="REJ_UNIT_ID"
                    SortExpression="REJ_UNIT_ID" />
                <asp:BoundField DataField="QA_EMP_ID" HeaderText="QA_EMP_ID"
                    SortExpression="QA_EMP_ID" />
                <asp:BoundField DataField="OPERATOR_ID" HeaderText="OPERATOR_ID"
                    SortExpression="OPERATOR_ID" />
                <asp:BoundField DataField="CONV_REASON_FROM" HeaderText="CONV_REASON_FROM"
                    SortExpression="CONV_REASON_FROM" />
                <asp:BoundField DataField="CONV_REASON_TO" HeaderText="CONV_REASON_TO"
                    SortExpression="CONV_REASON_TO" />
                <asp:BoundField DataField="SOLDER_BALL_PROCESS2"
                    HeaderText="SOLDER_BALL_PROCESS2" SortExpression="SOLDER_BALL_PROCESS2" />
                <asp:BoundField DataField="SOLDER_BALL_SIZE_2" HeaderText="SOLDER_BALL_SIZE_2"
                    SortExpression="SOLDER_BALL_SIZE_2" />
                <asp:BoundField DataField="FLUX_TYPE2" HeaderText="FLUX_TYPE2"
                    SortExpression="FLUX_TYPE2" />
                <asp:BoundField DataField="FLUX_EXPIRATION2" HeaderText="FLUX_EXPIRATION2"
                    SortExpression="FLUX_EXPIRATION2" />
                <asp:BoundField DataField="FLUX_USE_DUE_DATE2" HeaderText="FLUX_USE_DUE_DATE2"
                    SortExpression="FLUX_USE_DUE_DATE2" />
                <asp:BoundField DataField="PCBTYPE2" HeaderText="PCBTYPE2"
                    SortExpression="PCBTYPE2" />
                <asp:BoundField DataField="REFLOW_MC_ID" HeaderText="REFLOW_MC_ID"
                    SortExpression="REFLOW_MC_ID" />
                <asp:BoundField DataField="SBM_MC_ID2" HeaderText="SBM_MC_ID2"
                    SortExpression="SBM_MC_ID2" />
                <asp:BoundField DataField="DEFLUX_MC_ID" HeaderText="DEFLUX_MC_ID"
                    SortExpression="DEFLUX_MC_ID" />
                <asp:BoundField DataField="WASH_PRESSURE" HeaderText="WASH_PRESSURE"
                    SortExpression="WASH_PRESSURE" />
                <asp:BoundField DataField="WASH_TEMP" HeaderText="WASH_TEMP"
                    SortExpression="WASH_TEMP" />
                <asp:BoundField DataField="RINSE_PRESSURE" HeaderText="RINSE_PRESSURE"
                    SortExpression="RINSE_PRESSURE" />
                <asp:BoundField DataField="RINSE_TEMP" HeaderText="RINSE_TEMP"
                    SortExpression="RINSE_TEMP" />
                <asp:BoundField DataField="DRY_TEMP" HeaderText="DRY_TEMP"
                    SortExpression="DRY_TEMP" />
                <asp:BoundField DataField="BELT_SPEED" HeaderText="BELT_SPEED"
                    SortExpression="BELT_SPEED" />
                <asp:BoundField DataField="DIBOTTOM" HeaderText="DIBOTTOM"
                    SortExpression="DIBOTTOM" />
                <asp:BoundField DataField="DITOP" HeaderText="DITOP" SortExpression="DITOP" />
                <asp:BoundField DataField="MK_NO_2D_UNIT" HeaderText="MK_NO_2D_UNIT"
                    SortExpression="MK_NO_2D_UNIT" />
                <asp:BoundField DataField="SBMTYPE2" HeaderText="SBMTYPE2"
                    SortExpression="SBMTYPE2" />
                <asp:BoundField DataField="SOPTYPE2" HeaderText="SOPTYPE2"
                    SortExpression="SOPTYPE2" />
                <asp:BoundField DataField="SBM_SAPCODE2" HeaderText="SBM_SAPCODE2"
                    SortExpression="SBM_SAPCODE2" />
                <asp:BoundField DataField="SBM_MODEL2" HeaderText="SBM_MODEL2"
                    SortExpression="SBM_MODEL2" />
                <asp:BoundField DataField="PCBSAPCODE2" HeaderText="PCBSAPCODE2"
                    SortExpression="PCBSAPCODE2" />
                <asp:BoundField DataField="XRF_INSPCTION" HeaderText="XRF_INSPCTION"
                    SortExpression="XRF_INSPCTION" />
                <asp:BoundField DataField="XRF_PB" HeaderText="XRF_PB"
                    SortExpression="XRF_PB" />
                <asp:BoundField DataField="XRF_CR" HeaderText="XRF_CR"
                    SortExpression="XRF_CR" />
                <asp:BoundField DataField="XRF_CD" HeaderText="XRF_CD"
                    SortExpression="XRF_CD" />
                <asp:BoundField DataField="XRF_BR" HeaderText="XRF_BR"
                    SortExpression="XRF_BR" />
                <asp:BoundField DataField="XRF_HG" HeaderText="XRF_HG"
                    SortExpression="XRF_HG" />
                <asp:BoundField DataField="XRF_CI" HeaderText="XRF_CI"
                    SortExpression="XRF_CI" />
                <asp:BoundField DataField="PRINT_MC1" HeaderText="PRINT_MC1"
                    SortExpression="PRINT_MC1" />
                <asp:BoundField DataField="PRINT_MC2" HeaderText="PRINT_MC2"
                    SortExpression="PRINT_MC2" />
                <asp:BoundField DataField="PRESSURE1" HeaderText="PRESSURE1"
                    SortExpression="PRESSURE1" />
                <asp:BoundField DataField="PRESSURE2" HeaderText="PRESSURE2"
                    SortExpression="PRESSURE2" />
                <asp:BoundField DataField="SQUEZEE_H1" HeaderText="SQUEZEE_H1"
                    SortExpression="SQUEZEE_H1" />
                <asp:BoundField DataField="SQUEZEE_H2" HeaderText="SQUEZEE_H2"
                    SortExpression="SQUEZEE_H2" />
                <asp:BoundField DataField="SQUEZEE_H3" HeaderText="SQUEZEE_H3"
                    SortExpression="SQUEZEE_H3" />
                <asp:BoundField DataField="SQUEZEE_H4" HeaderText="SQUEZEE_H4"
                    SortExpression="SQUEZEE_H4" />
                <asp:BoundField DataField="SQUEZEE_S1" HeaderText="SQUEZEE_S1"
                    SortExpression="SQUEZEE_S1" />
                <asp:BoundField DataField="SQUEZEE_S2" HeaderText="SQUEZEE_S2"
                    SortExpression="SQUEZEE_S2" />
                <asp:BoundField DataField="SQUEZEE_S3" HeaderText="SQUEZEE_S3"
                    SortExpression="SQUEZEE_S3" />
                <asp:BoundField DataField="SQUEZEE_S4" HeaderText="SQUEZEE_S4"
                    SortExpression="SQUEZEE_S4" />
                <asp:BoundField DataField="OPERATION" HeaderText="OPERATION"
                    SortExpression="OPERATION" />
                <asp:BoundField DataField="CCM_MC" HeaderText="CCM_MC"
                    SortExpression="CCM_MC" />
                <asp:BoundField DataField="VI_DEFECT" HeaderText="VI_DEFECT"
                    SortExpression="VI_DEFECT" />
                <asp:BoundField DataField="VI_SAMPLE" HeaderText="VI_SAMPLE"
                    SortExpression="VI_SAMPLE" />
                <asp:BoundField DataField="ORIENTATION" HeaderText="ORIENTATION"
                    SortExpression="ORIENTATION" />
                <asp:BoundField DataField="ALIGNMENT" HeaderText="ALIGNMENT"
                    SortExpression="ALIGNMENT" />
                <asp:BoundField DataField="PLACEMENT" HeaderText="PLACEMENT"
                    SortExpression="PLACEMENT" />
                <asp:BoundField DataField="MISSING_COMPNT" HeaderText="MISSING_COMPNT"
                    SortExpression="MISSING_COMPNT" />
                <asp:BoundField DataField="STENCIL_REV" HeaderText="STENCIL_REV"
                    SortExpression="STENCIL_REV" />
                <asp:BoundField DataField="VI_UNIT" HeaderText="VI_UNIT"
                    SortExpression="VI_UNIT" />
                <asp:BoundField DataField="SP_SAP_CODE" HeaderText="SP_SAP_CODE"
                    SortExpression="SP_SAP_CODE" />
                <asp:BoundField DataField="SP_EXPIRATION" HeaderText="SP_EXPIRATION"
                    SortExpression="SP_EXPIRATION" />
                <asp:BoundField DataField="MLCC_SAP_CODE" HeaderText="MLCC_SAP_CODE"
                    SortExpression="MLCC_SAP_CODE" />
                <asp:BoundField DataField="MLCC_SAP_CODE2" HeaderText="MLCC_SAP_CODE2"
                    SortExpression="MLCC_SAP_CODE2" />
                <asp:BoundField DataField="LAST_QA_PER_EQ" HeaderText="LAST_QA_PER_EQ"
                    SortExpression="LAST_QA_PER_EQ" />
                <asp:BoundField DataField="CONV_FROM" HeaderText="CONV_FROM"
                    SortExpression="CONV_FROM" />
                <asp:BoundField DataField="CONV_TO" HeaderText="CONV_TO"
                    SortExpression="CONV_TO" />
                <asp:BoundField DataField="PKG_HEIGHT" HeaderText="PKG_HEIGHT"
                    SortExpression="PKG_HEIGHT" />
                <asp:BoundField DataField="DAY_7" HeaderText="DAY_7" SortExpression="DAY_7" />
                <asp:BoundField DataField="SB_HEIGHT_CHARTID" HeaderText="SB_HEIGHT_CHARTID"
                    SortExpression="SB_HEIGHT_CHARTID" />
                <asp:BoundField DataField="SB_SIZE_CHARTID" HeaderText="SB_SIZE_CHARTID"
                    SortExpression="SB_SIZE_CHARTID" />
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
        <%--
            The row is uniquely identified by the GridView DataKeyNames
            (LOTID, EQUIPID, ELOGSHEETYPE, QA_CREATED_ON), so the Update/Delete
            commands only need those keys in their WHERE clause. ConflictDetection
            is left at the default (OverwriteChanges) instead of CompareAllValues,
            which avoids repeating all ~145 columns as original_* comparisons.
        --%>
        <asp:SqlDataSource ID="SqlDataSource1" runat="server"
            ConnectionString="<%$ ConnectionStrings:SBMConnectionString %>"
            ProviderName="<%$ ConnectionStrings:SBMConnectionString.ProviderName %>"
            OldValuesParameterFormatString="original_{0}"
            SelectCommand="SELECT &quot;LOTID&quot;, &quot;EQUIPID&quot;, &quot;ELOGSHEETYPE&quot;, &quot;CUSTOMER&quot;, &quot;DEVICE&quot;, &quot;PKG&quot;, &quot;LEAD&quot;, &quot;SOPTYPE&quot;, &quot;PEAKTEMP&quot;, &quot;SOLDER_BALL_SIZE&quot;, &quot;DWELLTIME&quot;, &quot;SOAKTIME&quot;, &quot;BELTSPEED&quot;, &quot;COOLINGRATE&quot;, &quot;COOLINGRATE_EXIT&quot;, &quot;DAMAGEDBALL&quot;, &quot;FLUX_RESIDUE&quot;, &quot;MISSINGSOLDERBALL&quot;, &quot;DOUBLEBALL&quot;, &quot;BALLBRIDGING&quot;, &quot;SOLDERBALLPLACE&quot;, &quot;IPD_SBM_TYPE&quot;, &quot;IPD_SBM_SAPCODE&quot;, &quot;IPD_SBM_SIZE&quot;, &quot;IPD_SBM_MF&quot;, &quot;IPD_SBM_EXP&quot;, &quot;IPD_FLUX_TYPE&quot;, &quot;IPD_FLUX_SAPCODE&quot;, &quot;IPD_FLUX_EXP&quot;, &quot;IPD_FLUX_DUE&quot;, &quot;IPD_MC_ID&quot;, &quot;IPD_SAPCODE1&quot;, &quot;IPD_SAPCODE2&quot;, &quot;IPD_SAPCODE3&quot;, &quot;PASTE_DUE&quot;, &quot;VISUALINS_SAMPLE&quot;, &quot;VISUALINS_DEFECT&quot;, &quot;SOLDERBALLMISALIGN&quot;, &quot;FMONSOLDERBALL&quot;, &quot;OTHERS&quot;, &quot;OTHERS_QTY&quot;, &quot;SCRUBBINGTEST&quot;, &quot;WINDOWTIME&quot;, &quot;PMCIN&quot;, &quot;SBMIN&quot;, &quot;LSI_LEAD&quot;, &quot;ATI_LEAD&quot;, &quot;N2&quot;, &quot;N2_UNIT&quot;, &quot;O2&quot;, &quot;Y_SUBMIT_BY&quot;, &quot;Y_SUBMIT_DATE&quot;, &quot;ELOGSHEET_RESULT&quot;, &quot;BUYOFF_DATE&quot;, &quot;BUYOFF_BY&quot;, &quot;REMARKS&quot;, &quot;LINK_KEY&quot;, &quot;CREATED_ON&quot;, &quot;PMCOUT&quot;, &quot;SOLDER_BALL_PROCESS&quot;, &quot;SOLDER_BALL_MF&quot;, &quot;SOLDER_BALL_EXP&quot;, &quot;FLUX_TYPE&quot;, &quot;FLUX_USE_DUE_DATE&quot;, &quot;LAMP_UP_RATE&quot;, &quot;SDA_CURE_OUT&quot;, &quot;STRIP_NO&quot;, &quot;SBMIN2&quot;, &quot;SOLDER_BALL_S_TEST&quot;, &quot;SOLDER_BALL_P_TEST&quot;, &quot;ZONE_SHEAR_TEST&quot;, &quot;FLUX_EXPIRATION&quot;, &quot;WINDOWTIME2&quot;, &quot;SBMTYPE&quot;, &quot;PCBSAPCODE&quot;, &quot;RECIPENAME&quot;, &quot;SB_SIZE_DATA1&quot;, &quot;SB_SIZE_DATA2&quot;, &quot;SB_SIZE_DATA3&quot;, &quot;SB_SIZE_DATA4&quot;, &quot;SB_SIZE_DATA5&quot;, &quot;CONVERSION_FROM&quot;, &quot;CONVERSION_TO&quot;, &quot;SBM_SAPCODE&quot;, &quot;SBM_MODEL&quot;, &quot;PCB_TYPE&quot;, &quot;QA_CREATED_ON&quot;, &quot;UNIT&quot;, &quot;SB_SIZE_DATA6&quot;, &quot;SB_SIZE_UNIT&quot;, &quot;SB_HEIGHT_UNIT&quot;, &quot;REJ_STRIP_NO&quot;, &quot;REJ_UNIT_ID&quot;, &quot;QA_EMP_ID&quot;, &quot;OPERATOR_ID&quot;, &quot;CONV_REASON_FROM&quot;, &quot;CONV_REASON_TO&quot;, &quot;SOLDER_BALL_PROCESS2&quot;, &quot;SOLDER_BALL_SIZE_2&quot;, &quot;FLUX_TYPE2&quot;, &quot;FLUX_EXPIRATION2&quot;, &quot;FLUX_USE_DUE_DATE2&quot;, &quot;PCBTYPE2&quot;, &quot;REFLOW_MC_ID&quot;, &quot;SBM_MC_ID2&quot;, &quot;DEFLUX_MC_ID&quot;, &quot;WASH_PRESSURE&quot;, &quot;WASH_TEMP&quot;, &quot;RINSE_PRESSURE&quot;, &quot;RINSE_TEMP&quot;, &quot;DRY_TEMP&quot;, &quot;BELT_SPEED&quot;, &quot;DIBOTTOM&quot;, &quot;DITOP&quot;, &quot;MK_NO_2D_UNIT&quot;, &quot;SBMTYPE2&quot;, &quot;SOPTYPE2&quot;, &quot;SBM_SAPCODE2&quot;, &quot;SBM_MODEL2&quot;, &quot;PCBSAPCODE2&quot;, &quot;XRF_INSPCTION&quot;, &quot;XRF_PB&quot;, &quot;XRF_CR&quot;, &quot;XRF_CD&quot;, &quot;XRF_BR&quot;, &quot;XRF_HG&quot;, &quot;XRF_CI&quot;, &quot;PRINT_MC1&quot;, &quot;PRINT_MC2&quot;, &quot;PRESSURE1&quot;, &quot;PRESSURE2&quot;, &quot;SQUEZEE_H1&quot;, &quot;SQUEZEE_H2&quot;, &quot;SQUEZEE_H3&quot;, &quot;SQUEZEE_H4&quot;, &quot;SQUEZEE_S1&quot;, &quot;SQUEZEE_S2&quot;, &quot;SQUEZEE_S3&quot;, &quot;SQUEZEE_S4&quot;, &quot;OPERATION&quot;, &quot;CCM_MC&quot;, &quot;VI_DEFECT&quot;, &quot;VI_SAMPLE&quot;, &quot;ORIENTATION&quot;, &quot;ALIGNMENT&quot;, &quot;PLACEMENT&quot;, &quot;MISSING_COMPNT&quot;, &quot;STENCIL_REV&quot;, &quot;VI_UNIT&quot;, &quot;SP_SAP_CODE&quot;, &quot;SP_EXPIRATION&quot;, &quot;MLCC_SAP_CODE&quot;, &quot;MLCC_SAP_CODE2&quot;, &quot;LAST_QA_PER_EQ&quot;, &quot;CONV_FROM&quot;, &quot;CONV_TO&quot;, &quot;PKG_HEIGHT&quot;, &quot;DAY_7&quot;, &quot;SB_HEIGHT_CHARTID&quot;, &quot;SB_SIZE_CHARTID&quot; FROM &quot;SBM_ELOGSHEET_QA&quot; WHERE (&quot;LOTID&quot; = :LOTID)"
            DeleteCommand="DELETE FROM &quot;SBM_ELOGSHEET_QA&quot; WHERE &quot;LOTID&quot; = :original_LOTID AND &quot;EQUIPID&quot; = :original_EQUIPID AND &quot;ELOGSHEETYPE&quot; = :original_ELOGSHEETYPE AND &quot;QA_CREATED_ON&quot; = :original_QA_CREATED_ON"
            InsertCommand="INSERT INTO &quot;SBM_ELOGSHEET_QA&quot; (&quot;LOTID&quot;, &quot;EQUIPID&quot;, &quot;ELOGSHEETYPE&quot;, &quot;CUSTOMER&quot;, &quot;DEVICE&quot;, &quot;PKG&quot;, &quot;LEAD&quot;, &quot;SOPTYPE&quot;, &quot;PEAKTEMP&quot;, &quot;SOLDER_BALL_SIZE&quot;, &quot;DWELLTIME&quot;, &quot;SOAKTIME&quot;, &quot;BELTSPEED&quot;, &quot;COOLINGRATE&quot;, &quot;COOLINGRATE_EXIT&quot;, &quot;DAMAGEDBALL&quot;, &quot;FLUX_RESIDUE&quot;, &quot;MISSINGSOLDERBALL&quot;, &quot;DOUBLEBALL&quot;, &quot;BALLBRIDGING&quot;, &quot;SOLDERBALLPLACE&quot;, &quot;IPD_SBM_TYPE&quot;, &quot;IPD_SBM_SAPCODE&quot;, &quot;IPD_SBM_SIZE&quot;, &quot;IPD_SBM_MF&quot;, &quot;IPD_SBM_EXP&quot;, &quot;IPD_FLUX_TYPE&quot;, &quot;IPD_FLUX_SAPCODE&quot;, &quot;IPD_FLUX_EXP&quot;, &quot;IPD_FLUX_DUE&quot;, &quot;IPD_MC_ID&quot;, &quot;IPD_SAPCODE1&quot;, &quot;IPD_SAPCODE2&quot;, &quot;IPD_SAPCODE3&quot;, &quot;PASTE_DUE&quot;, &quot;VISUALINS_SAMPLE&quot;, &quot;VISUALINS_DEFECT&quot;, &quot;SOLDERBALLMISALIGN&quot;, &quot;FMONSOLDERBALL&quot;, &quot;OTHERS&quot;, &quot;OTHERS_QTY&quot;, &quot;SCRUBBINGTEST&quot;, &quot;WINDOWTIME&quot;, &quot;PMCIN&quot;, &quot;SBMIN&quot;, &quot;LSI_LEAD&quot;, &quot;ATI_LEAD&quot;, &quot;N2&quot;, &quot;N2_UNIT&quot;, &quot;O2&quot;, &quot;Y_SUBMIT_BY&quot;, &quot;Y_SUBMIT_DATE&quot;, &quot;ELOGSHEET_RESULT&quot;, &quot;BUYOFF_DATE&quot;, &quot;BUYOFF_BY&quot;, &quot;REMARKS&quot;, &quot;LINK_KEY&quot;, &quot;CREATED_ON&quot;, &quot;PMCOUT&quot;, &quot;SOLDER_BALL_PROCESS&quot;, &quot;SOLDER_BALL_MF&quot;, &quot;SOLDER_BALL_EXP&quot;, &quot;FLUX_TYPE&quot;, &quot;FLUX_USE_DUE_DATE&quot;, &quot;LAMP_UP_RATE&quot;, &quot;SDA_CURE_OUT&quot;, &quot;STRIP_NO&quot;, &quot;SBMIN2&quot;, &quot;SOLDER_BALL_S_TEST&quot;, &quot;SOLDER_BALL_P_TEST&quot;, &quot;ZONE_SHEAR_TEST&quot;, &quot;FLUX_EXPIRATION&quot;, &quot;WINDOWTIME2&quot;, &quot;SBMTYPE&quot;, &quot;PCBSAPCODE&quot;, &quot;RECIPENAME&quot;, &quot;SB_SIZE_DATA1&quot;, &quot;SB_SIZE_DATA2&quot;, &quot;SB_SIZE_DATA3&quot;, &quot;SB_SIZE_DATA4&quot;, &quot;SB_SIZE_DATA5&quot;, &quot;CONVERSION_FROM&quot;, &quot;CONVERSION_TO&quot;, &quot;SBM_SAPCODE&quot;, &quot;SBM_MODEL&quot;, &quot;PCB_TYPE&quot;, &quot;QA_CREATED_ON&quot;, &quot;UNIT&quot;, &quot;SB_SIZE_DATA6&quot;, &quot;SB_SIZE_UNIT&quot;, &quot;SB_HEIGHT_UNIT&quot;, &quot;REJ_STRIP_NO&quot;, &quot;REJ_UNIT_ID&quot;, &quot;QA_EMP_ID&quot;, &quot;OPERATOR_ID&quot;, &quot;CONV_REASON_FROM&quot;, &quot;CONV_REASON_TO&quot;, &quot;SOLDER_BALL_PROCESS2&quot;, &quot;SOLDER_BALL_SIZE_2&quot;, &quot;FLUX_TYPE2&quot;, &quot;FLUX_EXPIRATION2&quot;, &quot;FLUX_USE_DUE_DATE2&quot;, &quot;PCBTYPE2&quot;, &quot;REFLOW_MC_ID&quot;, &quot;SBM_MC_ID2&quot;, &quot;DEFLUX_MC_ID&quot;, &quot;WASH_PRESSURE&quot;, &quot;WASH_TEMP&quot;, &quot;RINSE_PRESSURE&quot;, &quot;RINSE_TEMP&quot;, &quot;DRY_TEMP&quot;, &quot;BELT_SPEED&quot;, &quot;DIBOTTOM&quot;, &quot;DITOP&quot;, &quot;MK_NO_2D_UNIT&quot;, &quot;SBMTYPE2&quot;, &quot;SOPTYPE2&quot;, &quot;SBM_SAPCODE2&quot;, &quot;SBM_MODEL2&quot;, &quot;PCBSAPCODE2&quot;, &quot;XRF_INSPCTION&quot;, &quot;XRF_PB&quot;, &quot;XRF_CR&quot;, &quot;XRF_CD&quot;, &quot;XRF_BR&quot;, &quot;XRF_HG&quot;, &quot;XRF_CI&quot;, &quot;PRINT_MC1&quot;, &quot;PRINT_MC2&quot;, &quot;PRESSURE1&quot;, &quot;PRESSURE2&quot;, &quot;SQUEZEE_H1&quot;, &quot;SQUEZEE_H2&quot;, &quot;SQUEZEE_H3&quot;, &quot;SQUEZEE_H4&quot;, &quot;SQUEZEE_S1&quot;, &quot;SQUEZEE_S2&quot;, &quot;SQUEZEE_S3&quot;, &quot;SQUEZEE_S4&quot;, &quot;OPERATION&quot;, &quot;CCM_MC&quot;, &quot;VI_DEFECT&quot;, &quot;VI_SAMPLE&quot;, &quot;ORIENTATION&quot;, &quot;ALIGNMENT&quot;, &quot;PLACEMENT&quot;, &quot;MISSING_COMPNT&quot;, &quot;STENCIL_REV&quot;, &quot;VI_UNIT&quot;, &quot;SP_SAP_CODE&quot;, &quot;SP_EXPIRATION&quot;, &quot;MLCC_SAP_CODE&quot;, &quot;MLCC_SAP_CODE2&quot;, &quot;LAST_QA_PER_EQ&quot;, &quot;CONV_FROM&quot;, &quot;CONV_TO&quot;, &quot;PKG_HEIGHT&quot;, &quot;DAY_7&quot;, &quot;SB_HEIGHT_CHARTID&quot;, &quot;SB_SIZE_CHARTID&quot;) VALUES (:LOTID, :EQUIPID, :ELOGSHEETYPE, :CUSTOMER, :DEVICE, :PKG, :LEAD, :SOPTYPE, :PEAKTEMP, :SOLDER_BALL_SIZE, :DWELLTIME, :SOAKTIME, :BELTSPEED, :COOLINGRATE, :COOLINGRATE_EXIT, :DAMAGEDBALL, :FLUX_RESIDUE, :MISSINGSOLDERBALL, :DOUBLEBALL, :BALLBRIDGING, :SOLDERBALLPLACE, :IPD_SBM_TYPE, :IPD_SBM_SAPCODE, :IPD_SBM_SIZE, :IPD_SBM_MF, :IPD_SBM_EXP, :IPD_FLUX_TYPE, :IPD_FLUX_SAPCODE, :IPD_FLUX_EXP, :IPD_FLUX_DUE, :IPD_MC_ID, :IPD_SAPCODE1, :IPD_SAPCODE2, :IPD_SAPCODE3, :PASTE_DUE, :VISUALINS_SAMPLE, :VISUALINS_DEFECT, :SOLDERBALLMISALIGN, :FMONSOLDERBALL, :OTHERS, :OTHERS_QTY, :SCRUBBINGTEST, :WINDOWTIME, :PMCIN, :SBMIN, :LSI_LEAD, :ATI_LEAD, :N2, :N2_UNIT, :O2, :Y_SUBMIT_BY, :Y_SUBMIT_DATE, :ELOGSHEET_RESULT, :BUYOFF_DATE, :BUYOFF_BY, :REMARKS, :LINK_KEY, :CREATED_ON, :PMCOUT, :SOLDER_BALL_PROCESS, :SOLDER_BALL_MF, :SOLDER_BALL_EXP, :FLUX_TYPE, :FLUX_USE_DUE_DATE, :LAMP_UP_RATE, :SDA_CURE_OUT, :STRIP_NO, :SBMIN2, :SOLDER_BALL_S_TEST, :SOLDER_BALL_P_TEST, :ZONE_SHEAR_TEST, :FLUX_EXPIRATION, :WINDOWTIME2, :SBMTYPE, :PCBSAPCODE, :RECIPENAME, :SB_SIZE_DATA1, :SB_SIZE_DATA2, :SB_SIZE_DATA3, :SB_SIZE_DATA4, :SB_SIZE_DATA5, :CONVERSION_FROM, :CONVERSION_TO, :SBM_SAPCODE, :SBM_MODEL, :PCB_TYPE, :QA_CREATED_ON, :UNIT, :SB_SIZE_DATA6, :SB_SIZE_UNIT, :SB_HEIGHT_UNIT, :REJ_STRIP_NO, :REJ_UNIT_ID, :QA_EMP_ID, :OPERATOR_ID, :CONV_REASON_FROM, :CONV_REASON_TO, :SOLDER_BALL_PROCESS2, :SOLDER_BALL_SIZE_2, :FLUX_TYPE2, :FLUX_EXPIRATION2, :FLUX_USE_DUE_DATE2, :PCBTYPE2, :REFLOW_MC_ID, :SBM_MC_ID2, :DEFLUX_MC_ID, :WASH_PRESSURE, :WASH_TEMP, :RINSE_PRESSURE, :RINSE_TEMP, :DRY_TEMP, :BELT_SPEED, :DIBOTTOM, :DITOP, :MK_NO_2D_UNIT, :SBMTYPE2, :SOPTYPE2, :SBM_SAPCODE2, :SBM_MODEL2, :PCBSAPCODE2, :XRF_INSPCTION, :XRF_PB, :XRF_CR, :XRF_CD, :XRF_BR, :XRF_HG, :XRF_CI, :PRINT_MC1, :PRINT_MC2, :PRESSURE1, :PRESSURE2, :SQUEZEE_H1, :SQUEZEE_H2, :SQUEZEE_H3, :SQUEZEE_H4, :SQUEZEE_S1, :SQUEZEE_S2, :SQUEZEE_S3, :SQUEZEE_S4, :OPERATION, :CCM_MC, :VI_DEFECT, :VI_SAMPLE, :ORIENTATION, :ALIGNMENT, :PLACEMENT, :MISSING_COMPNT, :STENCIL_REV, :VI_UNIT, :SP_SAP_CODE, :SP_EXPIRATION, :MLCC_SAP_CODE, :MLCC_SAP_CODE2, :LAST_QA_PER_EQ, :CONV_FROM, :CONV_TO, :PKG_HEIGHT, :DAY_7, :SB_HEIGHT_CHARTID, :SB_SIZE_CHARTID)"
            UpdateCommand="UPDATE &quot;SBM_ELOGSHEET_QA&quot; SET &quot;CUSTOMER&quot; = :CUSTOMER, &quot;DEVICE&quot; = :DEVICE, &quot;PKG&quot; = :PKG, &quot;LEAD&quot; = :LEAD, &quot;SOPTYPE&quot; = :SOPTYPE, &quot;PEAKTEMP&quot; = :PEAKTEMP, &quot;SOLDER_BALL_SIZE&quot; = :SOLDER_BALL_SIZE, &quot;DWELLTIME&quot; = :DWELLTIME, &quot;SOAKTIME&quot; = :SOAKTIME, &quot;BELTSPEED&quot; = :BELTSPEED, &quot;COOLINGRATE&quot; = :COOLINGRATE, &quot;COOLINGRATE_EXIT&quot; = :COOLINGRATE_EXIT, &quot;DAMAGEDBALL&quot; = :DAMAGEDBALL, &quot;FLUX_RESIDUE&quot; = :FLUX_RESIDUE, &quot;MISSINGSOLDERBALL&quot; = :MISSINGSOLDERBALL, &quot;DOUBLEBALL&quot; = :DOUBLEBALL, &quot;BALLBRIDGING&quot; = :BALLBRIDGING, &quot;SOLDERBALLPLACE&quot; = :SOLDERBALLPLACE, &quot;IPD_SBM_TYPE&quot; = :IPD_SBM_TYPE, &quot;IPD_SBM_SAPCODE&quot; = :IPD_SBM_SAPCODE, &quot;IPD_SBM_SIZE&quot; = :IPD_SBM_SIZE, &quot;IPD_SBM_MF&quot; = :IPD_SBM_MF, &quot;IPD_SBM_EXP&quot; = :IPD_SBM_EXP, &quot;IPD_FLUX_TYPE&quot; = :IPD_FLUX_TYPE, &quot;IPD_FLUX_SAPCODE&quot; = :IPD_FLUX_SAPCODE, &quot;IPD_FLUX_EXP&quot; = :IPD_FLUX_EXP, &quot;IPD_FLUX_DUE&quot; = :IPD_FLUX_DUE, &quot;IPD_MC_ID&quot; = :IPD_MC_ID, &quot;IPD_SAPCODE1&quot; = :IPD_SAPCODE1, &quot;IPD_SAPCODE2&quot; = :IPD_SAPCODE2, &quot;IPD_SAPCODE3&quot; = :IPD_SAPCODE3, &quot;PASTE_DUE&quot; = :PASTE_DUE, &quot;VISUALINS_SAMPLE&quot; = :VISUALINS_SAMPLE, &quot;VISUALINS_DEFECT&quot; = :VISUALINS_DEFECT, &quot;SOLDERBALLMISALIGN&quot; = :SOLDERBALLMISALIGN, &quot;FMONSOLDERBALL&quot; = :FMONSOLDERBALL, &quot;OTHERS&quot; = :OTHERS, &quot;OTHERS_QTY&quot; = :OTHERS_QTY, &quot;SCRUBBINGTEST&quot; = :SCRUBBINGTEST, &quot;WINDOWTIME&quot; = :WINDOWTIME, &quot;PMCIN&quot; = :PMCIN, &quot;SBMIN&quot; = :SBMIN, &quot;LSI_LEAD&quot; = :LSI_LEAD, &quot;ATI_LEAD&quot; = :ATI_LEAD, &quot;N2&quot; = :N2, &quot;N2_UNIT&quot; = :N2_UNIT, &quot;O2&quot; = :O2, &quot;Y_SUBMIT_BY&quot; = :Y_SUBMIT_BY, &quot;Y_SUBMIT_DATE&quot; = :Y_SUBMIT_DATE, &quot;ELOGSHEET_RESULT&quot; = :ELOGSHEET_RESULT, &quot;BUYOFF_DATE&quot; = :BUYOFF_DATE, &quot;BUYOFF_BY&quot; = :BUYOFF_BY, &quot;REMARKS&quot; = :REMARKS, &quot;LINK_KEY&quot; = :LINK_KEY, &quot;CREATED_ON&quot; = :CREATED_ON, &quot;PMCOUT&quot; = :PMCOUT, &quot;SOLDER_BALL_PROCESS&quot; = :SOLDER_BALL_PROCESS, &quot;SOLDER_BALL_MF&quot; = :SOLDER_BALL_MF, &quot;SOLDER_BALL_EXP&quot; = :SOLDER_BALL_EXP, &quot;FLUX_TYPE&quot; = :FLUX_TYPE, &quot;FLUX_USE_DUE_DATE&quot; = :FLUX_USE_DUE_DATE, &quot;LAMP_UP_RATE&quot; = :LAMP_UP_RATE, &quot;SDA_CURE_OUT&quot; = :SDA_CURE_OUT, &quot;STRIP_NO&quot; = :STRIP_NO, &quot;SBMIN2&quot; = :SBMIN2, &quot;SOLDER_BALL_S_TEST&quot; = :SOLDER_BALL_S_TEST, &quot;SOLDER_BALL_P_TEST&quot; = :SOLDER_BALL_P_TEST, &quot;ZONE_SHEAR_TEST&quot; = :ZONE_SHEAR_TEST, &quot;FLUX_EXPIRATION&quot; = :FLUX_EXPIRATION, &quot;WINDOWTIME2&quot; = :WINDOWTIME2, &quot;SBMTYPE&quot; = :SBMTYPE, &quot;PCBSAPCODE&quot; = :PCBSAPCODE, &quot;RECIPENAME&quot; = :RECIPENAME, &quot;SB_SIZE_DATA1&quot; = :SB_SIZE_DATA1, &quot;SB_SIZE_DATA2&quot; = :SB_SIZE_DATA2, &quot;SB_SIZE_DATA3&quot; = :SB_SIZE_DATA3, &quot;SB_SIZE_DATA4&quot; = :SB_SIZE_DATA4, &quot;SB_SIZE_DATA5&quot; = :SB_SIZE_DATA5, &quot;CONVERSION_FROM&quot; = :CONVERSION_FROM, &quot;CONVERSION_TO&quot; = :CONVERSION_TO, &quot;SBM_SAPCODE&quot; = :SBM_SAPCODE, &quot;SBM_MODEL&quot; = :SBM_MODEL, &quot;PCB_TYPE&quot; = :PCB_TYPE, &quot;UNIT&quot; = :UNIT, &quot;SB_SIZE_DATA6&quot; = :SB_SIZE_DATA6, &quot;SB_SIZE_UNIT&quot; = :SB_SIZE_UNIT, &quot;SB_HEIGHT_UNIT&quot; = :SB_HEIGHT_UNIT, &quot;REJ_STRIP_NO&quot; = :REJ_STRIP_NO, &quot;REJ_UNIT_ID&quot; = :REJ_UNIT_ID, &quot;QA_EMP_ID&quot; = :QA_EMP_ID, &quot;OPERATOR_ID&quot; = :OPERATOR_ID, &quot;CONV_REASON_FROM&quot; = :CONV_REASON_FROM, &quot;CONV_REASON_TO&quot; = :CONV_REASON_TO, &quot;SOLDER_BALL_PROCESS2&quot; = :SOLDER_BALL_PROCESS2, &quot;SOLDER_BALL_SIZE_2&quot; = :SOLDER_BALL_SIZE_2, &quot;FLUX_TYPE2&quot; = :FLUX_TYPE2, &quot;FLUX_EXPIRATION2&quot; = :FLUX_EXPIRATION2, &quot;FLUX_USE_DUE_DATE2&quot; = :FLUX_USE_DUE_DATE2, &quot;PCBTYPE2&quot; = :PCBTYPE2, &quot;REFLOW_MC_ID&quot; = :REFLOW_MC_ID, &quot;SBM_MC_ID2&quot; = :SBM_MC_ID2, &quot;DEFLUX_MC_ID&quot; = :DEFLUX_MC_ID, &quot;WASH_PRESSURE&quot; = :WASH_PRESSURE, &quot;WASH_TEMP&quot; = :WASH_TEMP, &quot;RINSE_PRESSURE&quot; = :RINSE_PRESSURE, &quot;RINSE_TEMP&quot; = :RINSE_TEMP, &quot;DRY_TEMP&quot; = :DRY_TEMP, &quot;BELT_SPEED&quot; = :BELT_SPEED, &quot;DIBOTTOM&quot; = :DIBOTTOM, &quot;DITOP&quot; = :DITOP, &quot;MK_NO_2D_UNIT&quot; = :MK_NO_2D_UNIT, &quot;SBMTYPE2&quot; = :SBMTYPE2, &quot;SOPTYPE2&quot; = :SOPTYPE2, &quot;SBM_SAPCODE2&quot; = :SBM_SAPCODE2, &quot;SBM_MODEL2&quot; = :SBM_MODEL2, &quot;PCBSAPCODE2&quot; = :PCBSAPCODE2, &quot;XRF_INSPCTION&quot; = :XRF_INSPCTION, &quot;XRF_PB&quot; = :XRF_PB, &quot;XRF_CR&quot; = :XRF_CR, &quot;XRF_CD&quot; = :XRF_CD, &quot;XRF_BR&quot; = :XRF_BR, &quot;XRF_HG&quot; = :XRF_HG, &quot;XRF_CI&quot; = :XRF_CI, &quot;PRINT_MC1&quot; = :PRINT_MC1, &quot;PRINT_MC2&quot; = :PRINT_MC2, &quot;PRESSURE1&quot; = :PRESSURE1, &quot;PRESSURE2&quot; = :PRESSURE2, &quot;SQUEZEE_H1&quot; = :SQUEZEE_H1, &quot;SQUEZEE_H2&quot; = :SQUEZEE_H2, &quot;SQUEZEE_H3&quot; = :SQUEZEE_H3, &quot;SQUEZEE_H4&quot; = :SQUEZEE_H4, &quot;SQUEZEE_S1&quot; = :SQUEZEE_S1, &quot;SQUEZEE_S2&quot; = :SQUEZEE_S2, &quot;SQUEZEE_S3&quot; = :SQUEZEE_S3, &quot;SQUEZEE_S4&quot; = :SQUEZEE_S4, &quot;OPERATION&quot; = :OPERATION, &quot;CCM_MC&quot; = :CCM_MC, &quot;VI_DEFECT&quot; = :VI_DEFECT, &quot;VI_SAMPLE&quot; = :VI_SAMPLE, &quot;ORIENTATION&quot; = :ORIENTATION, &quot;ALIGNMENT&quot; = :ALIGNMENT, &quot;PLACEMENT&quot; = :PLACEMENT, &quot;MISSING_COMPNT&quot; = :MISSING_COMPNT, &quot;STENCIL_REV&quot; = :STENCIL_REV, &quot;VI_UNIT&quot; = :VI_UNIT, &quot;SP_SAP_CODE&quot; = :SP_SAP_CODE, &quot;SP_EXPIRATION&quot; = :SP_EXPIRATION, &quot;MLCC_SAP_CODE&quot; = :MLCC_SAP_CODE, &quot;MLCC_SAP_CODE2&quot; = :MLCC_SAP_CODE2, &quot;LAST_QA_PER_EQ&quot; = :LAST_QA_PER_EQ, &quot;CONV_FROM&quot; = :CONV_FROM, &quot;CONV_TO&quot; = :CONV_TO, &quot;PKG_HEIGHT&quot; = :PKG_HEIGHT, &quot;DAY_7&quot; = :DAY_7, &quot;SB_HEIGHT_CHARTID&quot; = :SB_HEIGHT_CHARTID, &quot;SB_SIZE_CHARTID&quot; = :SB_SIZE_CHARTID WHERE &quot;LOTID&quot; = :original_LOTID AND &quot;EQUIPID&quot; = :original_EQUIPID AND &quot;ELOGSHEETYPE&quot; = :original_ELOGSHEETYPE AND &quot;QA_CREATED_ON&quot; = :original_QA_CREATED_ON">
            <DeleteParameters>
                <asp:Parameter Name="original_LOTID" Type="String" />
                <asp:Parameter Name="original_EQUIPID" Type="String" />
                <asp:Parameter Name="original_ELOGSHEETYPE" Type="String" />
                <asp:Parameter Name="original_QA_CREATED_ON" Type="DateTime" />
            </DeleteParameters>
            <InsertParameters>
                <asp:Parameter Name="LOTID" Type="String" />
                <asp:Parameter Name="EQUIPID" Type="String" />
                <asp:Parameter Name="ELOGSHEETYPE" Type="String" />
                <asp:Parameter Name="CUSTOMER" Type="String" />
                <asp:Parameter Name="DEVICE" Type="String" />
                <asp:Parameter Name="PKG" Type="String" />
                <asp:Parameter Name="LEAD" Type="String" />
                <asp:Parameter Name="SOPTYPE" Type="String" />
                <asp:Parameter Name="PEAKTEMP" Type="String" />
                <asp:Parameter Name="SOLDER_BALL_SIZE" Type="String" />
                <asp:Parameter Name="DWELLTIME" Type="String" />
                <asp:Parameter Name="SOAKTIME" Type="String" />
                <asp:Parameter Name="BELTSPEED" Type="String" />
                <asp:Parameter Name="COOLINGRATE" Type="String" />
                <asp:Parameter Name="COOLINGRATE_EXIT" Type="String" />
                <asp:Parameter Name="DAMAGEDBALL" Type="String" />
                <asp:Parameter Name="FLUX_RESIDUE" Type="String" />
                <asp:Parameter Name="MISSINGSOLDERBALL" Type="String" />
                <asp:Parameter Name="DOUBLEBALL" Type="String" />
                <asp:Parameter Name="BALLBRIDGING" Type="String" />
                <asp:Parameter Name="SOLDERBALLPLACE" Type="String" />
                <asp:Parameter Name="IPD_SBM_TYPE" Type="String" />
                <asp:Parameter Name="IPD_SBM_SAPCODE" Type="String" />
                <asp:Parameter Name="IPD_SBM_SIZE" Type="String" />
                <asp:Parameter Name="IPD_SBM_MF" Type="String" />
                <asp:Parameter Name="IPD_SBM_EXP" Type="String" />
                <asp:Parameter Name="IPD_FLUX_TYPE" Type="String" />
                <asp:Parameter Name="IPD_FLUX_SAPCODE" Type="String" />
                <asp:Parameter Name="IPD_FLUX_EXP" Type="String" />
                <asp:Parameter Name="IPD_FLUX_DUE" Type="String" />
                <asp:Parameter Name="IPD_MC_ID" Type="String" />
                <asp:Parameter Name="IPD_SAPCODE1" Type="String" />
                <asp:Parameter Name="IPD_SAPCODE2" Type="String" />
                <asp:Parameter Name="IPD_SAPCODE3" Type="String" />
                <asp:Parameter Name="PASTE_DUE" Type="String" />
                <asp:Parameter Name="VISUALINS_SAMPLE" Type="String" />
                <asp:Parameter Name="VISUALINS_DEFECT" Type="String" />
                <asp:Parameter Name="SOLDERBALLMISALIGN" Type="String" />
                <asp:Parameter Name="FMONSOLDERBALL" Type="String" />
                <asp:Parameter Name="OTHERS" Type="String" />
                <asp:Parameter Name="OTHERS_QTY" Type="String" />
                <asp:Parameter Name="SCRUBBINGTEST" Type="String" />
                <asp:Parameter Name="WINDOWTIME" Type="String" />
                <asp:Parameter Name="PMCIN" Type="String" />
                <asp:Parameter Name="SBMIN" Type="String" />
                <asp:Parameter Name="LSI_LEAD" Type="String" />
                <asp:Parameter Name="ATI_LEAD" Type="String" />
                <asp:Parameter Name="N2" Type="String" />
                <asp:Parameter Name="N2_UNIT" Type="String" />
                <asp:Parameter Name="O2" Type="String" />
                <asp:Parameter Name="Y_SUBMIT_BY" Type="String" />
                <asp:Parameter Name="Y_SUBMIT_DATE" Type="DateTime" />
                <asp:Parameter Name="ELOGSHEET_RESULT" Type="String" />
                <asp:Parameter Name="BUYOFF_DATE" Type="DateTime" />
                <asp:Parameter Name="BUYOFF_BY" Type="String" />
                <asp:Parameter Name="REMARKS" Type="String" />
                <asp:Parameter Name="LINK_KEY" Type="String" />
                <asp:Parameter Name="CREATED_ON" Type="DateTime" />
                <asp:Parameter Name="PMCOUT" Type="String" />
                <asp:Parameter Name="SOLDER_BALL_PROCESS" Type="String" />
                <asp:Parameter Name="SOLDER_BALL_MF" Type="String" />
                <asp:Parameter Name="SOLDER_BALL_EXP" Type="String" />
                <asp:Parameter Name="FLUX_TYPE" Type="String" />
                <asp:Parameter Name="FLUX_USE_DUE_DATE" Type="String" />
                <asp:Parameter Name="LAMP_UP_RATE" Type="String" />
                <asp:Parameter Name="SDA_CURE_OUT" Type="String" />
                <asp:Parameter Name="STRIP_NO" Type="String" />
                <asp:Parameter Name="SBMIN2" Type="String" />
                <asp:Parameter Name="SOLDER_BALL_S_TEST" Type="String" />
                <asp:Parameter Name="SOLDER_BALL_P_TEST" Type="String" />
                <asp:Parameter Name="ZONE_SHEAR_TEST" Type="String" />
                <asp:Parameter Name="FLUX_EXPIRATION" Type="String" />
                <asp:Parameter Name="WINDOWTIME2" Type="String" />
                <asp:Parameter Name="SBMTYPE" Type="String" />
                <asp:Parameter Name="PCBSAPCODE" Type="String" />
                <asp:Parameter Name="RECIPENAME" Type="String" />
                <asp:Parameter Name="SB_SIZE_DATA1" Type="String" />
                <asp:Parameter Name="SB_SIZE_DATA2" Type="String" />
                <asp:Parameter Name="SB_SIZE_DATA3" Type="String" />
                <asp:Parameter Name="SB_SIZE_DATA4" Type="String" />
                <asp:Parameter Name="SB_SIZE_DATA5" Type="String" />
                <asp:Parameter Name="CONVERSION_FROM" Type="String" />
                <asp:Parameter Name="CONVERSION_TO" Type="String" />
                <asp:Parameter Name="SBM_SAPCODE" Type="String" />
                <asp:Parameter Name="SBM_MODEL" Type="String" />
                <asp:Parameter Name="PCB_TYPE" Type="String" />
                <asp:Parameter Name="QA_CREATED_ON" Type="DateTime" />
                <asp:Parameter Name="UNIT" Type="String" />
                <asp:Parameter Name="SB_SIZE_DATA6" Type="String" />
                <asp:Parameter Name="SB_SIZE_UNIT" Type="String" />
                <asp:Parameter Name="SB_HEIGHT_UNIT" Type="String" />
                <asp:Parameter Name="REJ_STRIP_NO" Type="String" />
                <asp:Parameter Name="REJ_UNIT_ID" Type="String" />
                <asp:Parameter Name="QA_EMP_ID" Type="String" />
                <asp:Parameter Name="OPERATOR_ID" Type="String" />
                <asp:Parameter Name="CONV_REASON_FROM" Type="String" />
                <asp:Parameter Name="CONV_REASON_TO" Type="String" />
                <asp:Parameter Name="SOLDER_BALL_PROCESS2" Type="String" />
                <asp:Parameter Name="SOLDER_BALL_SIZE_2" Type="String" />
                <asp:Parameter Name="FLUX_TYPE2" Type="String" />
                <asp:Parameter Name="FLUX_EXPIRATION2" Type="String" />
                <asp:Parameter Name="FLUX_USE_DUE_DATE2" Type="String" />
                <asp:Parameter Name="PCBTYPE2" Type="String" />
                <asp:Parameter Name="REFLOW_MC_ID" Type="String" />
                <asp:Parameter Name="SBM_MC_ID2" Type="String" />
                <asp:Parameter Name="DEFLUX_MC_ID" Type="String" />
                <asp:Parameter Name="WASH_PRESSURE" Type="String" />
                <asp:Parameter Name="WASH_TEMP" Type="String" />
                <asp:Parameter Name="RINSE_PRESSURE" Type="String" />
                <asp:Parameter Name="RINSE_TEMP" Type="String" />
                <asp:Parameter Name="DRY_TEMP" Type="String" />
                <asp:Parameter Name="BELT_SPEED" Type="String" />
                <asp:Parameter Name="DIBOTTOM" Type="String" />
                <asp:Parameter Name="DITOP" Type="String" />
                <asp:Parameter Name="MK_NO_2D_UNIT" Type="String" />
                <asp:Parameter Name="SBMTYPE2" Type="String" />
                <asp:Parameter Name="SOPTYPE2" Type="String" />
                <asp:Parameter Name="SBM_SAPCODE2" Type="String" />
                <asp:Parameter Name="SBM_MODEL2" Type="String" />
                <asp:Parameter Name="PCBSAPCODE2" Type="String" />
                <asp:Parameter Name="XRF_INSPCTION" Type="String" />
                <asp:Parameter Name="XRF_PB" Type="String" />
                <asp:Parameter Name="XRF_CR" Type="String" />
                <asp:Parameter Name="XRF_CD" Type="String" />
                <asp:Parameter Name="XRF_BR" Type="String" />
                <asp:Parameter Name="XRF_HG" Type="String" />
                <asp:Parameter Name="XRF_CI" Type="String" />
                <asp:Parameter Name="PRINT_MC1" Type="String" />
                <asp:Parameter Name="PRINT_MC2" Type="String" />
                <asp:Parameter Name="PRESSURE1" Type="String" />
                <asp:Parameter Name="PRESSURE2" Type="String" />
                <asp:Parameter Name="SQUEZEE_H1" Type="String" />
                <asp:Parameter Name="SQUEZEE_H2" Type="String" />
                <asp:Parameter Name="SQUEZEE_H3" Type="String" />
                <asp:Parameter Name="SQUEZEE_H4" Type="String" />
                <asp:Parameter Name="SQUEZEE_S1" Type="String" />
                <asp:Parameter Name="SQUEZEE_S2" Type="String" />
                <asp:Parameter Name="SQUEZEE_S3" Type="String" />
                <asp:Parameter Name="SQUEZEE_S4" Type="String" />
                <asp:Parameter Name="OPERATION" Type="String" />
                <asp:Parameter Name="CCM_MC" Type="String" />
                <asp:Parameter Name="VI_DEFECT" Type="String" />
                <asp:Parameter Name="VI_SAMPLE" Type="String" />
                <asp:Parameter Name="ORIENTATION" Type="String" />
                <asp:Parameter Name="ALIGNMENT" Type="String" />
                <asp:Parameter Name="PLACEMENT" Type="String" />
                <asp:Parameter Name="MISSING_COMPNT" Type="String" />
                <asp:Parameter Name="STENCIL_REV" Type="String" />
                <asp:Parameter Name="VI_UNIT" Type="String" />
                <asp:Parameter Name="SP_SAP_CODE" Type="String" />
                <asp:Parameter Name="SP_EXPIRATION" Type="String" />
                <asp:Parameter Name="MLCC_SAP_CODE" Type="String" />
                <asp:Parameter Name="MLCC_SAP_CODE2" Type="String" />
                <asp:Parameter Name="LAST_QA_PER_EQ" Type="String" />
                <asp:Parameter Name="CONV_FROM" Type="String" />
                <asp:Parameter Name="CONV_TO" Type="String" />
                <asp:Parameter Name="PKG_HEIGHT" Type="String" />
                <asp:Parameter Name="DAY_7" Type="String" />
                <asp:Parameter Name="SB_HEIGHT_CHARTID" Type="String" />
                <asp:Parameter Name="SB_SIZE_CHARTID" Type="String" />
            </InsertParameters>
            <SelectParameters>
                <asp:ControlParameter ControlID="txtLotID" Name="LOTID" PropertyName="Text"
                    Type="String" />
            </SelectParameters>
            <UpdateParameters>
                <asp:Parameter Name="CUSTOMER" Type="String" />
                <asp:Parameter Name="DEVICE" Type="String" />
                <asp:Parameter Name="PKG" Type="String" />
                <asp:Parameter Name="LEAD" Type="String" />
                <asp:Parameter Name="SOPTYPE" Type="String" />
                <asp:Parameter Name="PEAKTEMP" Type="String" />
                <asp:Parameter Name="SOLDER_BALL_SIZE" Type="String" />
                <asp:Parameter Name="DWELLTIME" Type="String" />
                <asp:Parameter Name="SOAKTIME" Type="String" />
                <asp:Parameter Name="BELTSPEED" Type="String" />
                <asp:Parameter Name="COOLINGRATE" Type="String" />
                <asp:Parameter Name="COOLINGRATE_EXIT" Type="String" />
                <asp:Parameter Name="DAMAGEDBALL" Type="String" />
                <asp:Parameter Name="FLUX_RESIDUE" Type="String" />
                <asp:Parameter Name="MISSINGSOLDERBALL" Type="String" />
                <asp:Parameter Name="DOUBLEBALL" Type="String" />
                <asp:Parameter Name="BALLBRIDGING" Type="String" />
                <asp:Parameter Name="SOLDERBALLPLACE" Type="String" />
                <asp:Parameter Name="IPD_SBM_TYPE" Type="String" />
                <asp:Parameter Name="IPD_SBM_SAPCODE" Type="String" />
                <asp:Parameter Name="IPD_SBM_SIZE" Type="String" />
                <asp:Parameter Name="IPD_SBM_MF" Type="String" />
                <asp:Parameter Name="IPD_SBM_EXP" Type="String" />
                <asp:Parameter Name="IPD_FLUX_TYPE" Type="String" />
                <asp:Parameter Name="IPD_FLUX_SAPCODE" Type="String" />
                <asp:Parameter Name="IPD_FLUX_EXP" Type="String" />
                <asp:Parameter Name="IPD_FLUX_DUE" Type="String" />
                <asp:Parameter Name="IPD_MC_ID" Type="String" />
                <asp:Parameter Name="IPD_SAPCODE1" Type="String" />
                <asp:Parameter Name="IPD_SAPCODE2" Type="String" />
                <asp:Parameter Name="IPD_SAPCODE3" Type="String" />
                <asp:Parameter Name="PASTE_DUE" Type="String" />
                <asp:Parameter Name="VISUALINS_SAMPLE" Type="String" />
                <asp:Parameter Name="VISUALINS_DEFECT" Type="String" />
                <asp:Parameter Name="SOLDERBALLMISALIGN" Type="String" />
                <asp:Parameter Name="FMONSOLDERBALL" Type="String" />
                <asp:Parameter Name="OTHERS" Type="String" />
                <asp:Parameter Name="OTHERS_QTY" Type="String" />
                <asp:Parameter Name="SCRUBBINGTEST" Type="String" />
                <asp:Parameter Name="WINDOWTIME" Type="String" />
                <asp:Parameter Name="PMCIN" Type="String" />
                <asp:Parameter Name="SBMIN" Type="String" />
                <asp:Parameter Name="LSI_LEAD" Type="String" />
                <asp:Parameter Name="ATI_LEAD" Type="String" />
                <asp:Parameter Name="N2" Type="String" />
                <asp:Parameter Name="N2_UNIT" Type="String" />
                <asp:Parameter Name="O2" Type="String" />
                <asp:Parameter Name="Y_SUBMIT_BY" Type="String" />
                <asp:Parameter Name="Y_SUBMIT_DATE" Type="DateTime" />
                <asp:Parameter Name="ELOGSHEET_RESULT" Type="String" />
                <asp:Parameter Name="BUYOFF_DATE" Type="DateTime" />
                <asp:Parameter Name="BUYOFF_BY" Type="String" />
                <asp:Parameter Name="REMARKS" Type="String" />
                <asp:Parameter Name="LINK_KEY" Type="String" />
                <asp:Parameter Name="CREATED_ON" Type="DateTime" />
                <asp:Parameter Name="PMCOUT" Type="String" />
                <asp:Parameter Name="SOLDER_BALL_PROCESS" Type="String" />
                <asp:Parameter Name="SOLDER_BALL_MF" Type="String" />
                <asp:Parameter Name="SOLDER_BALL_EXP" Type="String" />
                <asp:Parameter Name="FLUX_TYPE" Type="String" />
                <asp:Parameter Name="FLUX_USE_DUE_DATE" Type="String" />
                <asp:Parameter Name="LAMP_UP_RATE" Type="String" />
                <asp:Parameter Name="SDA_CURE_OUT" Type="String" />
                <asp:Parameter Name="STRIP_NO" Type="String" />
                <asp:Parameter Name="SBMIN2" Type="String" />
                <asp:Parameter Name="SOLDER_BALL_S_TEST" Type="String" />
                <asp:Parameter Name="SOLDER_BALL_P_TEST" Type="String" />
                <asp:Parameter Name="ZONE_SHEAR_TEST" Type="String" />
                <asp:Parameter Name="FLUX_EXPIRATION" Type="String" />
                <asp:Parameter Name="WINDOWTIME2" Type="String" />
                <asp:Parameter Name="SBMTYPE" Type="String" />
                <asp:Parameter Name="PCBSAPCODE" Type="String" />
                <asp:Parameter Name="RECIPENAME" Type="String" />
                <asp:Parameter Name="SB_SIZE_DATA1" Type="String" />
                <asp:Parameter Name="SB_SIZE_DATA2" Type="String" />
                <asp:Parameter Name="SB_SIZE_DATA3" Type="String" />
                <asp:Parameter Name="SB_SIZE_DATA4" Type="String" />
                <asp:Parameter Name="SB_SIZE_DATA5" Type="String" />
                <asp:Parameter Name="CONVERSION_FROM" Type="String" />
                <asp:Parameter Name="CONVERSION_TO" Type="String" />
                <asp:Parameter Name="SBM_SAPCODE" Type="String" />
                <asp:Parameter Name="SBM_MODEL" Type="String" />
                <asp:Parameter Name="PCB_TYPE" Type="String" />
                <asp:Parameter Name="UNIT" Type="String" />
                <asp:Parameter Name="SB_SIZE_DATA6" Type="String" />
                <asp:Parameter Name="SB_SIZE_UNIT" Type="String" />
                <asp:Parameter Name="SB_HEIGHT_UNIT" Type="String" />
                <asp:Parameter Name="REJ_STRIP_NO" Type="String" />
                <asp:Parameter Name="REJ_UNIT_ID" Type="String" />
                <asp:Parameter Name="QA_EMP_ID" Type="String" />
                <asp:Parameter Name="OPERATOR_ID" Type="String" />
                <asp:Parameter Name="CONV_REASON_FROM" Type="String" />
                <asp:Parameter Name="CONV_REASON_TO" Type="String" />
                <asp:Parameter Name="SOLDER_BALL_PROCESS2" Type="String" />
                <asp:Parameter Name="SOLDER_BALL_SIZE_2" Type="String" />
                <asp:Parameter Name="FLUX_TYPE2" Type="String" />
                <asp:Parameter Name="FLUX_EXPIRATION2" Type="String" />
                <asp:Parameter Name="FLUX_USE_DUE_DATE2" Type="String" />
                <asp:Parameter Name="PCBTYPE2" Type="String" />
                <asp:Parameter Name="REFLOW_MC_ID" Type="String" />
                <asp:Parameter Name="SBM_MC_ID2" Type="String" />
                <asp:Parameter Name="DEFLUX_MC_ID" Type="String" />
                <asp:Parameter Name="WASH_PRESSURE" Type="String" />
                <asp:Parameter Name="WASH_TEMP" Type="String" />
                <asp:Parameter Name="RINSE_PRESSURE" Type="String" />
                <asp:Parameter Name="RINSE_TEMP" Type="String" />
                <asp:Parameter Name="DRY_TEMP" Type="String" />
                <asp:Parameter Name="BELT_SPEED" Type="String" />
                <asp:Parameter Name="DIBOTTOM" Type="String" />
                <asp:Parameter Name="DITOP" Type="String" />
                <asp:Parameter Name="MK_NO_2D_UNIT" Type="String" />
                <asp:Parameter Name="SBMTYPE2" Type="String" />
                <asp:Parameter Name="SOPTYPE2" Type="String" />
                <asp:Parameter Name="SBM_SAPCODE2" Type="String" />
                <asp:Parameter Name="SBM_MODEL2" Type="String" />
                <asp:Parameter Name="PCBSAPCODE2" Type="String" />
                <asp:Parameter Name="XRF_INSPCTION" Type="String" />
                <asp:Parameter Name="XRF_PB" Type="String" />
                <asp:Parameter Name="XRF_CR" Type="String" />
                <asp:Parameter Name="XRF_CD" Type="String" />
                <asp:Parameter Name="XRF_BR" Type="String" />
                <asp:Parameter Name="XRF_HG" Type="String" />
                <asp:Parameter Name="XRF_CI" Type="String" />
                <asp:Parameter Name="PRINT_MC1" Type="String" />
                <asp:Parameter Name="PRINT_MC2" Type="String" />
                <asp:Parameter Name="PRESSURE1" Type="String" />
                <asp:Parameter Name="PRESSURE2" Type="String" />
                <asp:Parameter Name="SQUEZEE_H1" Type="String" />
                <asp:Parameter Name="SQUEZEE_H2" Type="String" />
                <asp:Parameter Name="SQUEZEE_H3" Type="String" />
                <asp:Parameter Name="SQUEZEE_H4" Type="String" />
                <asp:Parameter Name="SQUEZEE_S1" Type="String" />
                <asp:Parameter Name="SQUEZEE_S2" Type="String" />
                <asp:Parameter Name="SQUEZEE_S3" Type="String" />
                <asp:Parameter Name="SQUEZEE_S4" Type="String" />
                <asp:Parameter Name="OPERATION" Type="String" />
                <asp:Parameter Name="CCM_MC" Type="String" />
                <asp:Parameter Name="VI_DEFECT" Type="String" />
                <asp:Parameter Name="VI_SAMPLE" Type="String" />
                <asp:Parameter Name="ORIENTATION" Type="String" />
                <asp:Parameter Name="ALIGNMENT" Type="String" />
                <asp:Parameter Name="PLACEMENT" Type="String" />
                <asp:Parameter Name="MISSING_COMPNT" Type="String" />
                <asp:Parameter Name="STENCIL_REV" Type="String" />
                <asp:Parameter Name="VI_UNIT" Type="String" />
                <asp:Parameter Name="SP_SAP_CODE" Type="String" />
                <asp:Parameter Name="SP_EXPIRATION" Type="String" />
                <asp:Parameter Name="MLCC_SAP_CODE" Type="String" />
                <asp:Parameter Name="MLCC_SAP_CODE2" Type="String" />
                <asp:Parameter Name="LAST_QA_PER_EQ" Type="String" />
                <asp:Parameter Name="CONV_FROM" Type="String" />
                <asp:Parameter Name="CONV_TO" Type="String" />
                <asp:Parameter Name="PKG_HEIGHT" Type="String" />
                <asp:Parameter Name="DAY_7" Type="String" />
                <asp:Parameter Name="SB_HEIGHT_CHARTID" Type="String" />
                <asp:Parameter Name="SB_SIZE_CHARTID" Type="String" />
                <asp:Parameter Name="original_LOTID" Type="String" />
                <asp:Parameter Name="original_EQUIPID" Type="String" />
                <asp:Parameter Name="original_ELOGSHEETYPE" Type="String" />
                <asp:Parameter Name="original_QA_CREATED_ON" Type="DateTime" />
            </UpdateParameters>
        </asp:SqlDataSource>
    </p>
    <p>
        &nbsp;
    </p>
</asp:Content>
