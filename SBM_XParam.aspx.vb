Imports objFactory
Imports System.Data

Partial Class SBM_XParam
    Inherits System.Web.UI.Page
    Private ObjADO As New OracleHelper
    Dim objUser1 As objUser
    Dim objLotInfo1 As objLotInfo

    Private Sub Page_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load, Me.Load
        'Put user code to initialize the page here
        objUser1 = CType(Session("User"), objUser)
        objLotInfo1 = CType(Session("LotInfo"), objLotInfo)
        If Session("User") Is Nothing Then
            Response.Write("<script language='javascript'>alert('Timeout! Please login again');</script>")
            Response.Redirect("menu.aspx")
        End If
        If Not Page.IsPostBack Then
            'TODO:Check access right based on the objUser.PageFlow, using substring and check filename
            If Not Session("OPQUL") Is Nothing Then
                If Not Session("OPQUL") = "TRUE" Then
                    Response.Write(Session("OPQUL"))
                End If
            End If
            Session("OPQUL") = Nothing
            populateLotInfo()


            If objLotInfo1.strFlipperEquip.Equals("") Then
                FlipperPanel.Visible = False
            End If

            CTLPanel.Visible = False

            'Flipper & CTL Lot info
            LOTData()

            'Populate elogsheet if have
            If objLotInfo1.strELogsheetType.ToUpper().Equals("SET-UP/CHANGE DEVICE") Then
                If ChecklogsheetExist(objLotInfo1, objUser1.strGroup) Then
                    populateELog(objLotInfo1, objUser1.strGroup)
                    disableTextbox(objUser1.strGroup)
                End If
                enableDisableTextbox(objUser1.strGroup)
            ElseIf objLotInfo1.strELogsheetType.ToUpper().Equals("SHIFT MONITOR") Or objLotInfo1.strELogsheetType.ToUpper().Equals("MATERIAL CHANGE") Or objLotInfo1.strELogsheetType.ToUpper().Equals("LOT MONITOR") Then
                If Not Session("ParamX") Is Nothing Then
                    Dim objXParam1 As New objXParam
                    objXParam1 = CType(Session("ParamX"), objXParam)
                    populateELog(objXParam1)
                    disableTextbox(objUser1.strGroup)
                    'IF elogsheet hasnt buyoff, dont insert.
                    If ChecklogsheetExist(objLotInfo1, objUser1.strGroup) Then
                        lblelogsheetExist.Text = "Y"
                    End If
                End If
            End If
            txtBOReason.Text = objLotInfo1.strELogsheetType
            peakTempRange()
            'If objLotInfo1.strELogsheetType.ToUpper().Equals("LOT # CHANGE") Then
            '    If Not Session("ParamX") Is Nothing Then
            '        Dim objXParam1 As New objXParam
            '        objXParam1 = CType(Session("ParamX"), objXParam)
            '        populateELog(objXParam1)
            '        disableTextbox(objUser1.strGroup)
            '    End If
            'Else
            '    populateELog(objLotInfo1, objUser1.strGroup)
            '    enableDisableTextbox(objUser1.strGroup)
            'End If
            '      Me.hdivision.Visible = False

            'If ddlSOPType.SelectedValue = "Lead free ball" Then
            '    lblDwell.Text = "Dwell time (above>220℃)"
            '    lblSoak.Text = "Soak time(130~220℃)"
            'Else
            '    lblDwell.Text = "Dwell time (above>183℃)"
            '    lblSoak.Text = "Soak time(130~183℃)"
            'End If
        End If
    End Sub


    Private Sub peakTempRange()
        Dim sconn As String = "User ID=rts;Password=rts4sck0; data source=skcimdwh.World"
        If Not Session("LotInfo") Is Nothing Then

            txtLotID.Text = objLotInfo1.strLotID

            Dim ssql As String

            ssql = "SELECT KSY_GET_AI_ITEM_BY_LOT ('" + objLotInfo1.strLotID + "','SBM_PEAK_TEMP') FROM DUAL "


            Dim oTbl As System.Data.DataTable = ObjADO.GetRecord(ssql, sconn)

            If oTbl.Rows.Count > 0 Then
                lblPTRange.Text = oTbl.Rows(0)(0).ToString
            End If

        End If

    End Sub



    Private Sub populateLotInfo()

        If Not Session("LotInfo") Is Nothing Then
            'objLotInfo1 = CType(Session("LotInfo"), objLotInfo)
            txtLotID.Text = objLotInfo1.strLotID
            txtCustomer.Text = objLotInfo1.strCustomer
            txtDevice.Text = objLotInfo1.strDevice
            txtEquipID.Text = objLotInfo1.strEquipID
            txtPkg.Text = objLotInfo1.strPkg
            If objLotInfo1.strCustomer = "NVIDIA" Then
                Me.lblCRateEutectic.Visible = True
                Me.lblCRateExitEutectic.Visible = True
                Me.txtCoolingRateExit_Eutectic.Visible = True
                Me.txtCoolingRatePeak_Eutectic.Visible = True
            End If

            If objLotInfo1.strCustomer = "EAGLE" Then
                Me.lblCRateEutectic.Text = "Cooling rate"
                Me.lblCRateExitEutectic.Text = "Cooling rate"
                'Me.txtCoolingRateExit_Eutectic.Text = True
                'Me.txtCoolingRatePeak_Eutectic.Text = True
            End If

            Dim ssql As String

            ssql = "select O2_PPM " _
       + " from SBM_ELOGSHEET_O2_CURR   where " _
       + " EQUIPID='" + objLotInfo1.strEquipID.ToUpper + "' " _
       + " and created_on > sysdate-1 and O2_PPM is not null "


            Dim oTbl As System.Data.DataTable = ObjADO.GetRecord(ssql)

            If oTbl.Rows.Count > 0 Then
                txtAutoPPM.Text = oTbl.Rows(0)(0).ToString
            End If







        End If

    End Sub
    Private Sub populateELog(ByVal objXParam1 As objXParam)
        'If dt.Rows.Count > 0 Then        
        'If Not IsNothing(objXParam1.strShelfLife) Then
        'txtShelfLife.Text = objXParam1.strShelfLife
        'End If
        If Not IsNothing(objXParam1.strFluxPlateDepth) Then
            ddlFluxPlateDepth.SelectedValue = objXParam1.strFluxPlateDepth
        End If
        'If Not IsNothing(objXParam1.strFluxPosition) Then
        '    txtFluxPosition.Text = objXParam1.strFluxPosition
        'End If
        'If Not IsNothing(objXParam1.strBallAttachPosition) Then
        '    txtBallAttachPosition.Text = objXParam1.strBallAttachPosition
        'End If
        If Not IsNothing(objXParam1.strSOPType) Then
            ddlSOPType.Items.FindByValue(objXParam1.strSOPType).Selected = True
        End If
        If Not IsNothing(objXParam1.strDwellTime_EU) Then
            txtDwellTime_Eutectic.Text = objXParam1.strDwellTime_EU
        End If
        If Not IsNothing(objXParam1.strSoakTime_EU) Then
            txtSoakTime_Eutectic.Text = objXParam1.strSoakTime_EU
        End If
        If Not IsNothing(objXParam1.strCoolingRate_Peak_EU) Then
            txtCoolingRatePeak_Eutectic.Text = objXParam1.strCoolingRate_Peak_EU
        End If
        'If Not IsNothing(objXParam1.strCoolingRate_Mid_EU) Then
        '    txtCoolingRateMid_Eutectic.Text = objXParam1.strCoolingRate_Mid_EU
        'End If
        If Not IsNothing(objXParam1.strCoolingRate_Exit_EU) Then
            txtCoolingRateExit_Eutectic.Text = objXParam1.strCoolingRate_Exit_EU
        End If

        If Not IsNothing(objXParam1.strFluxDottingType) Then
            txtFluxDottingType.Text = objXParam1.strFluxDottingType
        End If
        If Not IsNothing(objXParam1.strFluxDottingTime) Then
            txtFluxDottingTime.Text = objXParam1.strFluxDottingTime
        End If
        If Not IsNothing(objXParam1.strFluxDippingTime) Then
            txtFluxDippingTime.Text = objXParam1.strFluxDippingTime
        End If
        If Not IsNothing(objXParam1.strToolStep) Then
            txtToolStep.Text = objXParam1.strToolStep
        End If
        If Not IsNothing(objXParam1.strReflowMCModel) Then
            ddlReflowModel.SelectedValue = objXParam1.strReflowMCModel
        End If
        If Not IsNothing(objXParam1.strReflowMC) Then
            txtReflowMC.Text = objXParam1.strReflowMC
        End If
        If Not IsNothing(objXParam1.strBeltSpeed) Then
            txtBeltSpeed.Text = objXParam1.strBeltSpeed
        End If
        If Not IsNothing(objXParam1.strPeakTemp) Then
            txtPeakTemp.Text = objXParam1.strPeakTemp
        End If

        If Not IsNothing(objXParam1.strPeakTemp) Then
            ddlFluxPlateDepth.SelectedValue = objXParam1.strFluxPlateDepth
        End If
        If Not IsNothing(objXParam1.strPeakTemp) Then
            txtFluxDippingTime.Text = objXParam1.strFluxDippingTime
        End If
        If Not IsNothing(objXParam1.strPeakTemp) Then
            txtFluxDottingType.Text = objXParam1.strFluxDottingType
        End If
        If Not IsNothing(objXParam1.strPeakTemp) Then
            txtToolStep.Text = objXParam1.strToolStep
        End If
        If Not IsNothing(objXParam1.strPeakTemp) Then
            txtFluxDottingTime.Text = objXParam1.strFluxDottingTime
        End If

    End Sub
    'Check eLogSheet with Y Param exist or not
    Private Function ChecklogsheetExist(ByVal objLotInfo1 As objLotInfo, ByVal strGroup As String) As Boolean

        Dim result As Boolean = False

        Dim ssql As String
        If objLotInfo1.strELogsheetType.ToUpper = "SHIFT MONITOR" Then
            ssql = "select * " _
       + " from SBM_ELOGSHEET where " _
       + " LOTID='" + objLotInfo1.strLotID.ToUpper + "' " _
       + " and EQUIPID='" + objLotInfo1.strEquipID.ToUpper + "' " _
       + " and ELOGSHEETYPE='" + objLotInfo1.strELogsheetType.ToUpper + "' and Y_SUBMIT_DATE is null" _
        + " and SH_MONITOR_TYPE='OP'"
        Else
            ssql = "select * " _
       + " from SBM_ELOGSHEET where " _
       + " LOTID='" + objLotInfo1.strLotID.ToUpper + "' " _
       + " and EQUIPID='" + objLotInfo1.strEquipID.ToUpper + "' " _
       + " and ELOGSHEETYPE='" + objLotInfo1.strELogsheetType.ToUpper + "' and BUYOFF_DATE is null"
        End If

        'If (strGroup.Equals("OP")) Then
        'ssql = ssql + " and OPERATOR_DATE is not null "
        'ElseIf (strGroup.Equals("TE")) Then
        'ssql = ssql + " and TECHNICIAN_DATE is not null "
        'ElseIf (strGroup.Equals("QA")) Then
        '    ssql = ssql + " and QA_DATE is not null "
        'End If

        Dim oTbl As System.Data.DataTable = ObjADO.GetRecord(ssql)

        If oTbl.Rows.Count > 0 Then
            result = True
        End If

        Return result

    End Function
    Private Sub populateELog(ByVal objLotInfo1 As objLotInfo, ByVal strGroup As String)
        'Dim objLotInfo1 As objLotInfo
        Dim dt As DataTable = getELogsheet(objLotInfo1, strGroup)
        If dt.Rows.Count > 0 Then

            'If Not IsDBNull(dt.Rows(0)(0)) Then
            'txtShelfLife.Text = dt.Rows(0)(0)
            'End If
            If Not IsDBNull(dt.Rows(0)(1)) Then
                ddlFluxPlateDepth.SelectedValue = dt.Rows(0)(1)
            End If

            'If Not IsDBNull(dt.Rows(0)(2)) Then
            '    txtFluxPosition.Text = dt.Rows(0)(2)
            'End If

            'If Not IsDBNull(dt.Rows(0)(3)) Then
            '    txtBallAttachPosition.Text = dt.Rows(0)(3)
            'End If
            If Not IsDBNull(dt.Rows(0)(4)) Then
                ddlSOPType.Items.FindByValue(dt.Rows(0)(4)).Selected = True
            End If
            If Not IsDBNull(dt.Rows(0)(5)) Then
                txtDwellTime_Eutectic.Text = dt.Rows(0)(5)
            End If

            If Not IsDBNull(dt.Rows(0)(6)) Then
                txtSoakTime_Eutectic.Text = dt.Rows(0)(6)
            End If
            If Not IsDBNull(dt.Rows(0)(7)) Then
                txtCoolingRatePeak_Eutectic.Text = dt.Rows(0)(7)
            End If
            'If Not IsDBNull(dt.Rows(0)(8)) Then
            '    txtCoolingRateMid_Eutectic.Text = dt.Rows(0)(8)
            'End If
            If Not IsDBNull(dt.Rows(0)(9)) Then
                txtCoolingRateExit_Eutectic.Text = dt.Rows(0)(9)
            End If
            If Not IsDBNull(dt.Rows(0)(10)) Then
                txtPeakTemp.Text = dt.Rows(0)(10)
            End If

            If Not IsDBNull(dt.Rows(0)(11)) Then
                txtFluxDottingType.Text = dt.Rows(0)(11)
            End If
            If Not IsDBNull(dt.Rows(0)(12)) Then
                txtFluxDottingTime.Text = dt.Rows(0)(12)
            End If
            If Not IsDBNull(dt.Rows(0)(13)) Then
                txtFluxDippingTime.Text = dt.Rows(0)(13)
            End If
            If Not IsDBNull(dt.Rows(0)(14)) Then
                txtToolStep.Text = dt.Rows(0)(14)
            End If
            If Not IsDBNull(dt.Rows(0)(15)) Then
                txtBeltSpeed.Text = dt.Rows(0)(15)
            End If
            If Not IsDBNull(dt.Rows(0)(16)) Then
                ddlReflowModel.SelectedValue = dt.Rows(0)(16)
            End If
            If Not IsDBNull(dt.Rows(0)(17)) Then
                txtReflowMC.Text = dt.Rows(0)(17)
            End If


            lblelogsheetExist.Text = "Y"
        End If

    End Sub
    Private Function getELogsheet(ByVal objLotInfo1 As objLotInfo, ByVal strGroup As String) As DataTable

        'Dim dt As DataTable

        Dim ssql As String = "select nvl(SHELF_LIFE ,''),  " _
            + " nvl(flux_pate_depth,''),  " _
            + " nvl(FLUX_POSITION,''), " _
            + " nvl(BALL_ATTACH_POSITION,''), " _
            + " nvl(SOPTYPE,''), " _
             + " nvl(DWELL_TIME_EUTECTIC,''), " _
                + " nvl(SOAK_TIME_EUTECTIC,''), " _
                + " nvl(COOLING_RATE_PEAK_EUTECTIC,''), " _
                + " nvl(COOLING_RATE_MID_EUTECTIC,''), " _
                + " nvl(COOLING_RATE_EXIT_EUTECTIC,''), " _
                 + " nvl(PEAK_TEMP,''), " _
                   + " nvl(FLUXDOTTINGTYPE,''), " _
                   + " nvl(FLUXDOTTINGTIME,''), " _
                   + " nvl(INDEXDOTTINGTIME,''), " _
                   + " nvl(TOOLSTEP,''), " _
                   + " nvl(BELT_SPEED,''), " _
                   + " nvl(REFLOW_MC_MODEL,''), " _
                   + " nvl(REFLOW_MC,'') " _
              + " from SBM_ELOGSHEET where " _
           + " LOTID='" + objLotInfo1.strLotID.ToUpper + "' " _
           + " and EQUIPID='" + objLotInfo1.strEquipID.ToUpper + "' " _
           + " and ELOGSHEETYPE='" + objLotInfo1.strELogsheetType.ToUpper + "' "
        If objLotInfo1.strELogsheetType.ToUpper = "SHIFT MONITOR" Then
            ssql += " and SH_MONITOR_TYPE ='OP' "
        Else
            If objLotInfo1.strELogsheetType.ToUpper = "SHIFT MONITOR" Then
                ssql = ssql + " and BUYOFF_DATE is null"
            Else
                If (strGroup.Equals("OP")) Then
                    ssql = ssql + " and BUYOFF_DATE is null AND TECHNICIAN_DATE is not null"
                ElseIf (strGroup.Equals("TE")) Then
                    ssql = ssql + " and BUYOFF_DATE is null  and OPERATOR_DATE is not null "
                End If
            End If
        End If
        Dim oTbl As System.Data.DataTable = ObjADO.GetRecord(ssql)
        'If oTbl.Rows.Count > 0 Then
        Return oTbl
        'Else
        '    Return New System.Data.DataTable
        'End If

    End Function
    Private Sub enableDisableTextbox(ByVal strRole As String)

        If (strRole.Equals("OP")) Then
            ddlFluxPlateDepth.CssClass = "RptTextBox_NoEdit"
            ' txtBallAttachPosition.CssClass = "RptTextBox_NoEdit"
            '     txtFluxPosition.CssClass = "RptTextBox_NoEdit"
            ddlSOPType.CssClass = "RptTextBox_NoEdit"
            txtDwellTime_Eutectic.CssClass = "RptTextBox_NoEdit"
            txtSoakTime_Eutectic.CssClass = "RptTextBox_NoEdit"
            txtCoolingRatePeak_Eutectic.CssClass = "RptTextBox_NoEdit"
            '  txtCoolingRateMid_Eutectic.CssClass = "RptTextBox_NoEdit"
            txtCoolingRateExit_Eutectic.CssClass = "RptTextBox_NoEdit"
            txtPeakTemp.CssClass = "RptTextBox_NoEdit"

            ddlFluxPlateDepth.Enabled = False
            '    txtFluxPosition.ReadOnly = True
            ' txtBallAttachPosition.ReadOnly = True
            ddlSOPType.Enabled = False
            txtDwellTime_Eutectic.ReadOnly = True
            txtSoakTime_Eutectic.ReadOnly = True
            txtCoolingRatePeak_Eutectic.ReadOnly = True
            '  txtCoolingRateMid_Eutectic.ReadOnly = True
            txtCoolingRateExit_Eutectic.ReadOnly = True
            txtPeakTemp.ReadOnly = True

            'txtShelfLife.CssClass = "RptTextBox"

            'txtShelfLife.ReadOnly = False

            'txtBondForce.BackColor = System.Drawing.Color.Navy 'System.Drawing.Color.FromArgb(224, 224, 224)
            'txtBondDelay.BackColor = System.Drawing.Color.Navy ' System.Drawing.Color.FromArgb(224, 224, 224)

            'txtFLUXThickness.CssClass = "RptTextBox_NoEdit"

            '    txtBondForce.Enabled = False
            '    txtBondDelay.Enabled = False


            '    txtFLUXThickness.Enabled = True
        ElseIf (strRole.Equals("TE")) Then

            'txtShelfLife.CssClass = "RptTextBox_NoEdit"
            'txtShelfLife.ReadOnly = True
            ddlFluxPlateDepth.CssClass = "RptTextBox"
            '  txtBallAttachPosition.CssClass = "RptTextBox"
            '        txtFluxPosition.CssClass = "RptTextBox"
            ddlSOPType.CssClass = "RptTextBox"
            txtDwellTime_Eutectic.CssClass = "RptTextBox"
            txtSoakTime_Eutectic.CssClass = "RptTextBox"
            txtCoolingRatePeak_Eutectic.CssClass = "RptTextBox"
            '  txtCoolingRateMid_Eutectic.CssClass = "RptTextBox"
            txtCoolingRateExit_Eutectic.CssClass = "RptTextBox"
            txtPeakTemp.CssClass = "RptTextBox"

            ddlFluxPlateDepth.Enabled = True
            ' txtFluxPosition.ReadOnly = False
            '   txtBallAttachPosition.ReadOnly = False
            ddlSOPType.Enabled = True
            txtDwellTime_Eutectic.ReadOnly = False
            txtSoakTime_Eutectic.ReadOnly = False
            txtCoolingRatePeak_Eutectic.ReadOnly = False
            '   txtCoolingRateMid_Eutectic.ReadOnly = False
            txtCoolingRateExit_Eutectic.ReadOnly = False
            txtPeakTemp.ReadOnly = False

        End If

    End Sub

    Private Sub disableTextbox(ByVal strRole As String)

        'txtShelfLife.CssClass = "RptTextBox_NoEdit"
        ddlFluxPlateDepth.CssClass = "RptTextBox_NoEdit"
        '    txtFluxPosition.CssClass = "RptTextBox_NoEdit"
        '    txtBallAttachPosition.CssClass = "RptTextBox_NoEdit"
        ddlSOPType.CssClass = "RptTextBox_NoEdit"
        txtDwellTime_Eutectic.CssClass = "RptTextBox_NoEdit"
        txtSoakTime_Eutectic.CssClass = "RptTextBox_NoEdit"
        txtCoolingRatePeak_Eutectic.CssClass = "RptTextBox_NoEdit"
        '  txtCoolingRateMid_Eutectic.CssClass = "RptTextBox_NoEdit"
        txtCoolingRateExit_Eutectic.CssClass = "RptTextBox_NoEdit"

        txtPeakTemp.CssClass = "RptTextBox_NoEdit"
        'txtShelfLife.ReadOnly = True
        ddlFluxPlateDepth.Enabled = False
        '   txtFluxPosition.ReadOnly = True
        ' txtBallAttachPosition.ReadOnly = True
        txtDwellTime_Eutectic.ReadOnly = True
        ddlSOPType.Enabled = False
        txtSoakTime_Eutectic.ReadOnly = True
        txtCoolingRatePeak_Eutectic.ReadOnly = True
        ' txtCoolingRateMid_Eutectic.ReadOnly = True
        txtCoolingRateExit_Eutectic.ReadOnly = True
        txtPeakTemp.ReadOnly = True
    End Sub


    Private Function getNewURL(ByVal strPageFlow As String) As String
        Dim strCurrentURL As String
        Dim strFullPath As String
        strFullPath = System.Web.HttpContext.Current.Request.Url.AbsolutePath
        strCurrentURL = strFullPath.Substring(strFullPath.LastIndexOf("/") + 1)
        'Controller.NavigatePage(strCurrentURL, strPageFlow)

        Return Controller.NavigatePage(strCurrentURL, strPageFlow)

    End Function
    Private Function getOldURL(ByVal strPageFlow As String) As String
        'Dim strCurrentURL As String
        'Dim strFullPath As String
        'strFullPath = System.Web.HttpContext.Current.Request.Url.AbsolutePath
        'strCurrentURL = strFullPath.Substring(strFullPath.LastIndexOf("/") + 1)
        Return ""

    End Function

    Private Sub btnCancel_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnCancel.Click
        Session("User") = Nothing

        If Not Session("LotInfo") Is Nothing Then
            Session("LotInfo") = Nothing
        End If

        If Not Session("ParamX") Is Nothing Then
            Session("ParamX") = Nothing
        End If

        Dim URL As String = "MENU.aspx"
        Response.Redirect(URL)
    End Sub

    Private Sub btnToStep3_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnToStep3.Click

        'FLIPPER ADD
        Dim FlipperSql As String
        Dim CTLSql As String
        Dim ORACLEHELPER As New OracleHelper
        Dim SQL_STATUS As Boolean = True
        Dim Last_LotNo As String
        Dim Tmp_Oper, Tmp_Oper2 As String

        Dim M1_KIT As String = ""
        Dim M2_KIT As String = ""
        Dim M3_KIT As String = ""

        Tmp_Oper = "FLIPPER"
        Tmp_Oper2 = "CTL"
        Dim sconn As String = "User ID=rts;Password=rts4sck0; data source=skcimdwh.World"




        Dim strGroup As String
        Dim ssql As String = ""

        If (Page.IsValid) Then
            strGroup = objUser1.strGroup



            If objLotInfo1.strCustomer = "QUALCOMM" And objLotInfo1.strELogsheetType.ToUpper.Equals("LOT MONITOR") And txtAutoPPM.Text = "" Then
                Response.Write("<script language='javascript'>alert('Auto PPM 항목을 입력하여 주시기 바랍니다. ');</script>")
                Exit Sub
            End If


            If objLotInfo1.strCustomer = "QUALCOMM" Then

                Dim Qsql As String

                Qsql = "SELECT M1_KIT,M2_KIT,M3_KIT FROM RTS.T_SOC_TOOL_SET_HIS WHERE EQUIP_ID='" + objLotInfo1.strEquipID.ToUpper + "' AND LAST_PER_EQ='Y' "

                Dim oTblQ As System.Data.DataTable = ObjADO.GetRecord(Qsql)

                If oTblQ.Rows.Count > 0 Then
                    M1_KIT = oTblQ.Rows(0)(0).ToString
                    M2_KIT = oTblQ.Rows(0)(1).ToString
                    M3_KIT = oTblQ.Rows(0)(2).ToString
                End If

            End If

            If objLotInfo1.strCustomer = "QUALCOMM" Then
                Dim errMsg As String = ""

                If (txtCoolingRateExit_Eutectic.Text.Equals("")) Then
                    errMsg += "COOLING_RATE_EXIT_EUTECTIC,"
                End If
                If (objUser1.strUserID.Equals("")) Then
                    errMsg += "TECHNICIAN_ID,"
                End If

                If Not errMsg = "" Then
                    errMsg = errMsg.Remove(errMsg.LastIndexOf(","))
                    errMsg += " 항목은 필수 입력 항목입니다."
                    'cvAll.Text = errMsg
                    'cvAll.IsValid = False
                    'cvAll.Enabled = True
                    Response.Write("<script>alert('" + errMsg + "');</script>")
                    ' cvAll.Visible = True
                    Return
                End If
            End If


            If objLotInfo1.strELogsheetType.ToUpper.Equals("SET-UP/CHANGE DEVICE") Then
                If strGroup.Equals("OP") Then
                    '   If lblelogsheetExist.Text.Equals("Y") Then
                    'FLUXDOTTINGTYPE,FLUXDOTTINGTIME,INDEXDOTTINGTIME,TOOLSTEP
                    ssql = "update SBM_ELOGSHEET set " _
                     + " BELT_SPEED='" + txtBeltSpeed.Text + "'," _
                     + " REFLOW_MC_MODEL='" + ddlReflowModel.SelectedValue + "'," _
                     + " REFLOW_MC='" + txtReflowMC.Text + "'," _
                     + " SETUP_REMARKS='" + txtRemark.Text + "'," _
                     + " flux_pate_depth='" + ddlFluxPlateDepth.SelectedValue + "'," _
                     + " FLUXDOTTINGTYPE='" + txtFluxDottingType.Text + "'," _
                     + " FLUXDOTTINGTIME='" + txtFluxDottingTime.Text + "'," _
                     + " INDEXDOTTINGTIME='" + txtFluxDippingTime.Text + "'," _
                     + " TOOLSTEP='" + txtToolStep.Text + "'," _
                     + " SOPTYPE='" + ddlSOPType.SelectedValue + "'," _
                     + " PEAK_TEMP='" + txtPeakTemp.Text + "'," _
                     + " DWELL_TIME_EUTECTIC='" + txtDwellTime_Eutectic.Text + "'," _
                     + " SOAK_TIME_EUTECTIC='" + txtSoakTime_Eutectic.Text + "'," _
                     + " COOLING_RATE_PEAK_EUTECTIC='" + txtCoolingRatePeak_Eutectic.Text + "'," _
                     + " COOLING_RATE_EXIT_EUTECTIC='" + txtCoolingRateExit_Eutectic.Text + "'," _
                     + " AUTO_PPM='" + txtAutoPPM.Text + "'," _
                     + " OPERATOR_ID='" + objUser1.strUserID + "'," _
                     + " PROCESS='" + objLotInfo1.strProcess + "'," _
                     + " XRAY_INSPECTION='" + txtXrayInspection.Text + "'," _
                     + " OPERATOR_DATE=sysdate " _
                     + " where LOTID='" + objLotInfo1.strLotID.ToUpper + "' and " _
                     + " EQUIPID='" + objLotInfo1.strEquipID.ToUpper + "' and " _
                     + " ELOGSHEETYPE='" + objLotInfo1.strELogsheetType.ToUpper + "' and " _
                     + " BUYOFF_DATE is null "
                    '            + " SHELF_LIFE='" + txtShelfLife.Text + "'," _
                    'Else
                    '    ssql = "insert into SBM_ELOGSHEET " _
                    '    + " (SHELF_LIFE, OPERATOR_ID, OPERATOR_DATE, " _
                    '    + " LOTID, EQUIPID, ELOGSHEETYPE) values " _
                    '    + " ( '" + objUser1.strUserID + "',sysdate,'" _
                    '    + objLotInfo1.strLotID.ToUpper + "','" + objLotInfo1.strEquipID.ToUpper + "','" _
                    '    + objLotInfo1.strELogsheetType.ToUpper + "')"
                    '    '+ txtShelfLife.Text + "'," _
                    'End If
                    '   + " FLUX_POSITION='" + txtFluxPosition.Text + "'," _
                    '+ " BALL_ATTACH_POSITION='" + txtBallAttachPosition.Text + "'," _
                ElseIf strGroup.Equals("TE") Then
                    If lblelogsheetExist.Text.Equals("Y") Then

                        ssql = "update SBM_ELOGSHEET set " _
                         + " BELT_SPEED='" + txtBeltSpeed.Text + "'," _
                         + " REFLOW_MC_MODEL='" + ddlReflowModel.SelectedValue + "'," _
                         + " REFLOW_MC='" + txtReflowMC.Text + "'," _
                         + " SETUP_REMARKS='" + txtRemark.Text + "'," _
                         + " FLUXDOTTINGTYPE='" + txtFluxDottingType.Text + "'," _
                         + " FLUXDOTTINGTIME='" + txtFluxDottingTime.Text + "'," _
                         + " INDEXDOTTINGTIME='" + txtFluxDippingTime.Text + "'," _
                         + " TOOLSTEP='" + txtToolStep.Text + "'," _
                         + " flux_pate_depth='" + ddlFluxPlateDepth.SelectedValue + "'," _
                         + " SOPTYPE='" + ddlSOPType.SelectedValue + "'," _
                         + " AUTO_PPM='" + txtAutoPPM.Text + "'," _
                         + " PEAK_TEMP='" + txtPeakTemp.Text + "'," _
                         + " DWELL_TIME_EUTECTIC='" + txtDwellTime_Eutectic.Text + "'," _
                         + " SOAK_TIME_EUTECTIC='" + txtSoakTime_Eutectic.Text + "'," _
                         + " COOLING_RATE_PEAK_EUTECTIC='" + txtCoolingRatePeak_Eutectic.Text + "',"
                        '= " COOLING_RATE_MID_EUTECTIC='" + txtCoolingRateMid_Eutectic.Text + "'," _
                        ssql += " COOLING_RATE_EXIT_EUTECTIC='" + txtCoolingRateExit_Eutectic.Text + "'," _
                         + " TECHNICIAN_ID='" + objUser1.strUserID + "'," _
                         + " PROCESS='" + objLotInfo1.strProcess + "'," _
                         + " TECHNICIAN_DATE=sysdate " _
                         + " where LOTID='" + objLotInfo1.strLotID.ToUpper + "' and " _
                         + " EQUIPID='" + objLotInfo1.strEquipID.ToUpper + "' and " _
                         + " ELOGSHEETYPE='" + objLotInfo1.strELogsheetType.ToUpper + "' and " _
                         + " BUYOFF_DATE is null "
                    Else
                        '                        CUSTOMER                    VARCHAR2(30 BYTE),
                        'DEVICE                      VARCHAR2(40 BYTE),
                        'PKG                         VARCHAR2(30 BYTE),
                        'LEAD                        VARCHAR2(20 BYTE),
                        'LINK_KEY                    VARCHAR2(30 BYTE),
                        'CREATED_ON                  DATE
                        '                        BELT_SPEED VARCHAR2(30 BYTE),
                        'REFLOW_MC_MODEL VARCHAR2(30 BYTE),
                        'REFLOW_MC VARCHAR2(30 BYTE)
                        ssql = "insert into SBM_ELOGSHEET " + vbCrLf
                        ssql += " (BELT_SPEED,REFLOW_MC_MODEL,REFLOW_MC,flux_pate_depth, " + vbCrLf
                        ssql += " FLUXDOTTINGTYPE, " + vbCrLf
                        ssql += " FLUXDOTTINGTIME, " + vbCrLf
                        ssql += " INDEXDOTTINGTIME, " + vbCrLf
                        ssql += " TOOLSTEP, " + vbCrLf
                        ssql += " SOPTYPE,  " + vbCrLf
                        ssql += " PEAK_TEMP,  " + vbCrLf
                        ssql += " DWELL_TIME_EUTECTIC,  " + vbCrLf
                        ssql += " SOAK_TIME_EUTECTIC,  " + vbCrLf
                        ssql += " COOLING_RATE_PEAK_EUTECTIC,  " + vbCrLf
                        ssql += " COOLING_RATE_EXIT_EUTECTIC,  " + vbCrLf
                        ssql += " TECHNICIAN_ID, TECHNICIAN_DATE, " + vbCrLf
                        ssql += " SETUP_REMARKS, LOTID, EQUIPID, ELOGSHEETYPE,CUSTOMER,DEVICE,PKG,LEAD,PROCESS, AUTO_PPM, M1_KIT, M2_KIT, M3_KIT, CREATED_ON) values " + vbCrLf
                        ssql += " ( " + vbCrLf
                        ssql += "'" + txtBeltSpeed.Text + "'," + vbCrLf
                        ssql += "'" + ddlReflowModel.SelectedValue + "'," + vbCrLf
                        ssql += "'" + txtReflowMC.Text + "'," + vbCrLf
                        ssql += "'" + ddlFluxPlateDepth.SelectedValue + "'," + vbCrLf
                        ssql += "'" + txtFluxDottingType.Text + "'," + vbCrLf
                        ssql += "'" + txtFluxDottingTime.Text + "'," + vbCrLf
                        ssql += "'" + txtFluxDippingTime.Text + "'," + vbCrLf
                        ssql += "'" + txtToolStep.Text + "'," + vbCrLf
                        ssql += "'" + ddlSOPType.SelectedValue + "'," + vbCrLf
                        ssql += "'" + txtPeakTemp.Text + "'," + vbCrLf
                        ssql += "'" + txtDwellTime_Eutectic.Text + "'," + vbCrLf
                        ssql += "'" + txtSoakTime_Eutectic.Text + "'," + vbCrLf
                        ssql += "'" + txtCoolingRatePeak_Eutectic.Text + "'," + vbCrLf
                        ' ssql += txtCoolingRateMid_Eutectic.Text + "','" + vbCrLf
                        ssql += "'" + txtCoolingRateExit_Eutectic.Text + "'," + vbCrLf
                        ssql += "'" + objUser1.strUserID + "',sysdate," + vbCrLf
                        ssql += "'" + txtRemark.Text + "'," + vbCrLf
                        ssql += "'" + objLotInfo1.strLotID.ToUpper + "','" + objLotInfo1.strEquipID.ToUpper + "'," + vbCrLf
                        ssql += "'" + objLotInfo1.strELogsheetType.ToUpper + "'," + vbCrLf
                        ssql += "'" + objLotInfo1.strCustomer + "'," + vbCrLf
                        ssql += "'" + objLotInfo1.strDevice + "'," + vbCrLf
                        ssql += "'" + objLotInfo1.strPkg + "'," + vbCrLf
                        ssql += "'" + objLotInfo1.strLeadCnt + "'," + vbCrLf
                        ssql += "'" + objLotInfo1.strProcess + "'," + vbCrLf
                        ssql += "'" + txtAutoPPM.Text + "'," + vbCrLf
                        ssql += "'" + M1_KIT + "'," + vbCrLf
                        ssql += "'" + M2_KIT + "'," + vbCrLf
                        ssql += "'" + M3_KIT + "'," + vbCrLf
                        ssql += "SYSDATE " + vbCrLf
                        ssql += ")" + vbCrLf
                    End If
                End If
            ElseIf objLotInfo1.strELogsheetType.ToUpper.Equals("SHIFT MONITOR") Then
                If lblelogsheetExist.Text.Equals("Y") Then
                    ssql = "update SBM_ELOGSHEET set " _
                     + " BELT_SPEED='" + txtBeltSpeed.Text + "'," _
                     + " REFLOW_MC_MODEL='" + ddlReflowModel.SelectedValue + "'," _
                     + " REFLOW_MC='" + txtReflowMC.Text + "'," _
                     + " REMARKS='" + txtRemark.Text + "'," _
                     + " WORK_AREA_CHECK='" + ddlWorkAreaCheck.SelectedValue + "'," _
                     + " LOT_CHECK='" + ddlLotCheck.SelectedValue + "'," _
                     + " MC_CHECK='" + ddlMCCheck.SelectedValue + "'," _
                     + " SAFETY_CHECK='" + ddlSafetyCheck.SelectedValue + "'," _
                     + " STATIONBLOCKCLEAN='" + ddlStationBlockClean.SelectedValue + "'," _
                     + " FLUXDOTTINGTYPE='" + txtFluxDottingType.Text + "'," _
                     + " FLUXDOTTINGTIME='" + txtFluxDottingTime.Text + "'," _
                     + " INDEXDOTTINGTIME='" + txtFluxDippingTime.Text + "'," _
                     + " TOOLSTEP='" + txtToolStep.Text + "'," _
                     + " flux_pate_depth='" + ddlFluxPlateDepth.SelectedValue + "'," _
                     + " AUTO_PPM='" + txtAutoPPM.Text + "'," _
                     + " SOPTYPE='" + ddlSOPType.SelectedValue + "'," _
                     + " PEAK_TEMP='" + txtPeakTemp.Text + "'," _
                     + " DWELL_TIME_EUTECTIC='" + txtDwellTime_Eutectic.Text + "'," _
                     + " SOAK_TIME_EUTECTIC='" + txtSoakTime_Eutectic.Text + "'," _
                     + " COOLING_RATE_PEAK_EUTECTIC='" + txtCoolingRatePeak_Eutectic.Text + "',"
                    '+ " COOLING_RATE_MID_EUTECTIC='" + txtCoolingRateMid_Eutectic.Text + "'," _
                    ssql += " COOLING_RATE_EXIT_EUTECTIC='" + txtCoolingRateExit_Eutectic.Text + "'," _
                     + " TECHNICIAN_ID='" + objUser1.strUserID + "'," _
                     + " PROCESS='" + objLotInfo1.strProcess + "'," _
                     + " XRAY_INSPECTION='" + txtXrayInspection.Text + "'," _
                     + " TECHNICIAN_DATE=sysdate " _
                     + " where LOTID='" + objLotInfo1.strLotID.ToUpper + "' and " _
                     + " EQUIPID='" + objLotInfo1.strEquipID.ToUpper + "' and " _
                     + " ELOGSHEETYPE='" + objLotInfo1.strELogsheetType.ToUpper + "' and " _
                     + " SH_MONITOR_TYPE='OP' and " _
                     + " Y_SUBMIT_DATE is null "
                Else
                    ssql = "insert into SBM_ELOGSHEET " + vbCrLf
                    ssql += " ( BELT_SPEED,REFLOW_MC_MODEL,REFLOW_MC,flux_pate_depth," + vbCrLf
                    ssql += " WORK_AREA_CHECK, " + vbCrLf
                    ssql += " LOT_CHECK, " + vbCrLf
                    ssql += " MC_CHECK, " + vbCrLf
                    ssql += " SAFETY_CHECK, " + vbCrLf
                    ssql += " STATIONBLOCKCLEAN, " + vbCrLf
                    ssql += " FLUXDOTTINGTYPE, " + vbCrLf
                    ssql += " FLUXDOTTINGTIME, " + vbCrLf
                    ssql += " INDEXDOTTINGTIME, " + vbCrLf
                    ssql += " TOOLSTEP, " + vbCrLf
                    ssql += " SOPTYPE,  " + vbCrLf
                    ssql += " PEAK_TEMP,  " + vbCrLf
                    ssql += " DWELL_TIME_EUTECTIC,  " + vbCrLf
                    ssql += " SOAK_TIME_EUTECTIC,  " + vbCrLf
                    ssql += " COOLING_RATE_PEAK_EUTECTIC,  " + vbCrLf
                    ssql += " COOLING_RATE_EXIT_EUTECTIC,  " + vbCrLf
                    ssql += " OPERATOR_ID, OPERATOR_DATE, " + vbCrLf
                    ssql += " REMARKS, LOTID, EQUIPID, ELOGSHEETYPE,SH_MONITOR_TYPE,CUSTOMER,DEVICE,PKG,LEAD,PROCESS,XRAY_INSPECTION, AUTO_PPM, M1_KIT, M2_KIT, M3_KIT, CREATED_ON) values " + vbCrLf
                    ssql += " ( " + vbCrLf
                    ssql += "'" + txtBeltSpeed.Text + "'," + vbCrLf
                    ssql += "'" + ddlReflowModel.SelectedValue + "'," + vbCrLf
                    ssql += "'" + txtReflowMC.Text + "'," + vbCrLf
                    ssql += "'" + ddlFluxPlateDepth.SelectedValue + "'," + vbCrLf
                    ssql += "'" + ddlWorkAreaCheck.SelectedValue + "'," + vbCrLf
                    ssql += "'" + ddlLotCheck.SelectedValue + "'," + vbCrLf
                    ssql += "'" + ddlMCCheck.SelectedValue + "'," + vbCrLf
                    ssql += "'" + ddlSafetyCheck.SelectedValue + "'," + vbCrLf
                    ssql += "'" + ddlStationBlockClean.SelectedValue + "'," + vbCrLf
                    ssql += "'" + txtFluxDottingType.Text + "'," + vbCrLf
                    ssql += "'" + txtFluxDottingTime.Text + "'," + vbCrLf
                    ssql += "'" + txtFluxDippingTime.Text + "'," + vbCrLf
                    ssql += "'" + txtToolStep.Text + "'," + vbCrLf
                    ssql += "'" + ddlSOPType.SelectedValue + "'," + vbCrLf
                    ssql += "'" + txtPeakTemp.Text + "'," + vbCrLf
                    ssql += "'" + txtDwellTime_Eutectic.Text + "'," + vbCrLf
                    ssql += "'" + txtSoakTime_Eutectic.Text + "'," + vbCrLf
                    ssql += "'" + txtCoolingRatePeak_Eutectic.Text + "'," + vbCrLf
                    '     ssql += txtCoolingRateMid_Eutectic.Text + "','" + vbCrLf
                    ssql += "'" + txtCoolingRateExit_Eutectic.Text + "'," + vbCrLf
                    ssql += "'" + objUser1.strUserID + "',sysdate," + vbCrLf
                    ssql += "'" + txtRemark.Text + "'," + vbCrLf
                    ssql += "'" + objLotInfo1.strLotID.ToUpper + "','" + objLotInfo1.strEquipID.ToUpper + "'," + vbCrLf
                    ssql += "'" + objLotInfo1.strELogsheetType.ToUpper + "','OP',"
                    ssql += "'" + objLotInfo1.strCustomer + "'," + vbCrLf
                    ssql += "'" + objLotInfo1.strDevice + "'," + vbCrLf
                    ssql += "'" + objLotInfo1.strPkg + "'," + vbCrLf
                    ssql += "'" + objLotInfo1.strLeadCnt + "'," + vbCrLf
                    ssql += "'" + objLotInfo1.strProcess + "'," + vbCrLf
                    ssql += "'" + txtXrayInspection.Text + "'," + vbCrLf
                    ssql += "'" + txtAutoPPM.Text + "'," + vbCrLf
                    ssql += "'" + M1_KIT + "'," + vbCrLf
                    ssql += "'" + M2_KIT + "'," + vbCrLf
                    ssql += "'" + M3_KIT + "'," + vbCrLf
                    ssql += "SYSDATE " + vbCrLf
                    ssql += ")" + vbCrLf
                End If

            Else
                If Not lblelogsheetExist.Text.Equals("Y") Then
                    'TECHNICIAN DO THE SHIFT CHANGE
                    If strGroup.Equals("TE") Then
                        ssql = "insert into SBM_ELOGSHEET " _
                               + " ( BELT_SPEED,REFLOW_MC_MODEL,REFLOW_MC,flux_pate_depth,"
                        ssql += " FLUXDOTTINGTYPE, " + vbCrLf
                        ssql += " FLUXDOTTINGTIME, " + vbCrLf
                        ssql += " INDEXDOTTINGTIME, " + vbCrLf
                        ssql += " TOOLSTEP, " + vbCrLf
                        ssql += " SOPTYPE,  " + vbCrLf
                        ssql += " PEAK_TEMP,  " + vbCrLf
                        ssql += " DWELL_TIME_EUTECTIC,  " + vbCrLf
                        ssql += " SOAK_TIME_EUTECTIC,  " + vbCrLf
                        ssql += " COOLING_RATE_PEAK_EUTECTIC,  " + vbCrLf
                        ssql += " COOLING_RATE_EXIT_EUTECTIC,  " + vbCrLf
                        ssql += " TECHNICIAN_ID, TECHNICIAN_DATE, " + vbCrLf
                        ssql += " REMARKS, LOTID, EQUIPID, ELOGSHEETYPE,CUSTOMER,DEVICE,PKG,LEAD,PROCESS, AUTO_PPM, M1_KIT, M2_KIT, M3_KIT, CREATED_ON) values " + vbCrLf
                        ssql += " ( " + vbCrLf
                        ssql += "'" + txtBeltSpeed.Text + "'," + vbCrLf
                        ssql += "'" + ddlReflowModel.SelectedValue + "'," + vbCrLf
                        ssql += "'" + txtReflowMC.Text + "'," + vbCrLf
                        ssql += "'" + ddlFluxPlateDepth.SelectedValue + "'," + vbCrLf
                        ssql += "'" + txtFluxDottingType.Text + "'," + vbCrLf
                        ssql += "'" + txtFluxDottingTime.Text + "'," + vbCrLf
                        ssql += "'" + txtFluxDippingTime.Text + "'," + vbCrLf
                        ssql += "'" + txtToolStep.Text + "','" + vbCrLf
                        ssql += "'" + ddlSOPType.SelectedValue + "'," + vbCrLf
                        ssql += "'" + txtPeakTemp.Text + "','" + vbCrLf
                        ssql += "'" + txtDwellTime_Eutectic.Text + "'," + vbCrLf
                        ssql += "'" + txtSoakTime_Eutectic.Text + "'," + vbCrLf
                        ssql += "'" + txtCoolingRatePeak_Eutectic.Text + "'," + vbCrLf
                        '  ssql += txtCoolingRateMid_Eutectic.Text + "','" + vbCrLf
                        ssql += "'" + txtCoolingRateExit_Eutectic.Text + "'," + vbCrLf
                        ssql += "'" + objUser1.strUserID + "',sysdate," + vbCrLf
                        ssql += "'" + txtRemark.Text + "'," + vbCrLf
                        ssql += "'" + objLotInfo1.strLotID.ToUpper + "','" + objLotInfo1.strEquipID.ToUpper + "'," + vbCrLf
                        ssql += "'" + objLotInfo1.strELogsheetType.ToUpper + "'," + vbCrLf
                        ssql += "'" + objLotInfo1.strCustomer + "'," + vbCrLf
                        ssql += "'" + objLotInfo1.strDevice + "'," + vbCrLf
                        ssql += "'" + objLotInfo1.strPkg + "'," + vbCrLf
                        ssql += "'" + objLotInfo1.strLeadCnt + "'," + vbCrLf
                        ssql += "'" + objLotInfo1.strProcess + "'," + vbCrLf
                        ssql += "'" + txtAutoPPM.Text + "'," + vbCrLf
                        ssql += "'" + M1_KIT + "'," + vbCrLf
                        ssql += "'" + M2_KIT + "'," + vbCrLf
                        ssql += "'" + M3_KIT + "'," + vbCrLf
                        ssql += "SYSDATE " + vbCrLf
                        ssql += ")" + vbCrLf
                        'SHELF_LIFE, " _   + " // + txtShelfLife.Text + "','"
                    Else

                        ssql = "insert into SBM_ELOGSHEET "
                        ssql += " ( BELT_SPEED,REFLOW_MC_MODEL,REFLOW_MC,flux_pate_depth,"
                        ssql += " FLUXDOTTINGTYPE, " + vbCrLf
                        ssql += " FLUXDOTTINGTIME, " + vbCrLf
                        ssql += " INDEXDOTTINGTIME, " + vbCrLf
                        ssql += " TOOLSTEP, " + vbCrLf
                        ssql += " SOPTYPE, " + vbCrLf
                        ssql += " PEAK_TEMP,  " + vbCrLf
                        ssql += " DWELL_TIME_EUTECTIC, " + vbCrLf
                        ssql += " SOAK_TIME_EUTECTIC,  " + vbCrLf
                        ssql += " COOLING_RATE_PEAK_EUTECTIC,  " + vbCrLf
                        ssql += " COOLING_RATE_EXIT_EUTECTIC,  " + vbCrLf
                        ssql += " OPERATOR_ID, OPERATOR_DATE, " + vbCrLf
                        ssql += " REMARKS, LOTID, EQUIPID, ELOGSHEETYPE,CUSTOMER,DEVICE,PKG,LEAD,PROCESS,XRAY_INSPECTION, AUTO_PPM, M1_KIT, M2_KIT, M3_KIT, CREATED_ON) values " + vbCrLf
                        ssql += " ( " + vbCrLf
                        ssql += "'" + txtBeltSpeed.Text + "'," + vbCrLf
                        ssql += "'" + ddlReflowModel.SelectedValue + "'," + vbCrLf
                        ssql += "'" + txtReflowMC.Text + "'," + vbCrLf
                        ssql += "'" + ddlFluxPlateDepth.SelectedValue + "'," + vbCrLf
                        ssql += "'" + txtFluxDottingType.Text + "'," + vbCrLf
                        ssql += "'" + txtFluxDottingTime.Text + "'," + vbCrLf
                        ssql += "'" + txtFluxDippingTime.Text + "'," + vbCrLf
                        ssql += "'" + txtToolStep.Text + "'," + vbCrLf
                        ssql += "'" + ddlSOPType.SelectedValue + "'," + vbCrLf
                        ssql += "'" + txtPeakTemp.Text + "'," + vbCrLf
                        ssql += "'" + txtDwellTime_Eutectic.Text + "'," + vbCrLf
                        ssql += "'" + txtSoakTime_Eutectic.Text + "'," + vbCrLf
                        ssql += "'" + txtCoolingRatePeak_Eutectic.Text + "'," + vbCrLf
                        ' ssql += txtCoolingRateMid_Eutectic.Text + "','" + vbCrLf
                        ssql += "'" + txtCoolingRateExit_Eutectic.Text + "'," + vbCrLf
                        ssql += "'" + objUser1.strUserID + "',sysdate," + vbCrLf
                        ssql += "'" + txtRemark.Text + "'," + vbCrLf
                        ssql += "'" + objLotInfo1.strLotID.ToUpper + "','" + objLotInfo1.strEquipID.ToUpper + "'," + vbCrLf
                        ssql += "'" + objLotInfo1.strELogsheetType.ToUpper + "'," + vbCrLf
                        ssql += "'" + objLotInfo1.strCustomer + "'," + vbCrLf
                        ssql += "'" + objLotInfo1.strDevice + "'," + vbCrLf
                        ssql += "'" + objLotInfo1.strPkg + "'," + vbCrLf
                        ssql += "'" + objLotInfo1.strLeadCnt + "'," + vbCrLf
                        ssql += "'" + objLotInfo1.strProcess + "'," + vbCrLf
                        ssql += "'" + txtXrayInspection.Text + "'," + vbCrLf
                        ssql += "'" + txtAutoPPM.Text + "'," + vbCrLf
                        ssql += "'" + M1_KIT + "'," + vbCrLf
                        ssql += "'" + M2_KIT + "'," + vbCrLf
                        ssql += "'" + M3_KIT + "'," + vbCrLf
                        ssql += "SYSDATE " + vbCrLf
                        ssql += ")" + vbCrLf
                    End If
                Else
                    ssql = "update SBM_ELOGSHEET set " _
                        + " BELT_SPEED='" + txtBeltSpeed.Text + "'," _
                         + " REFLOW_MC_MODEL='" + ddlReflowModel.SelectedValue + "'," _
                         + " REFLOW_MC='" + txtReflowMC.Text + "'," _
                         + " REMARKS='" + txtRemark.Text + "'," _
                         + " FLUXDOTTINGTYPE='" + txtFluxDottingType.Text + "'," _
                         + " FLUXDOTTINGTIME='" + txtFluxDottingTime.Text + "'," _
                         + " INDEXDOTTINGTIME='" + txtFluxDippingTime.Text + "'," _
                         + " TOOLSTEP='" + txtToolStep.Text + "'," _
                         + " flux_pate_depth='" + ddlFluxPlateDepth.SelectedValue + "'," _
                         + " AUTO_PPM='" + txtAutoPPM.Text + "'," _
                         + " SOPTYPE='" + ddlSOPType.SelectedValue + "'," _
                         + " PEAK_TEMP='" + txtPeakTemp.Text + "'," _
                         + " DWELL_TIME_EUTECTIC='" + txtDwellTime_Eutectic.Text + "'," _
                         + " SOAK_TIME_EUTECTIC='" + txtSoakTime_Eutectic.Text + "'," _
                         + " COOLING_RATE_PEAK_EUTECTIC='" + txtCoolingRatePeak_Eutectic.Text + "',"
                    '   + " COOLING_RATE_MID_EUTECTIC='" + txtCoolingRateMid_Eutectic.Text + "'," _
                    ssql += " COOLING_RATE_EXIT_EUTECTIC='" + txtCoolingRateExit_Eutectic.Text + "'," _
                         + " TECHNICIAN_ID='" + objUser1.strUserID + "'," _
                         + " PROCESS='" + objLotInfo1.strProcess + "'," _
                         + " XRAY_INSPECTION='" + txtXrayInspection.Text + "'," _
                         + " TECHNICIAN_DATE=sysdate " _
                         + " where LOTID='" + objLotInfo1.strLotID.ToUpper + "' and " _
                         + " EQUIPID='" + objLotInfo1.strEquipID.ToUpper + "' and " _
                         + " ELOGSHEETYPE='" + objLotInfo1.strELogsheetType.ToUpper + "' and " _
                         + " BUYOFF_DATE is null "
                End If
            End If

            If objLotInfo1.strELogsheetType.ToUpper().Equals("SHIFT MONITOR") Or objLotInfo1.strELogsheetType.ToUpper().Equals("LOT MONITOR") Then

                FlipperSql = " INSERT INTO ELOG_SHT_FLIPPER " & vbCrLf
                FlipperSql = FlipperSql & " ( " & vbCrLf
                FlipperSql = FlipperSql & " LOT_ID,OPER,OPERATOR_ID,EQUIP_ID,BUYOFF_REASON,SUBMIT_TIME,JOB_FILE," & vbCrLf
                FlipperSql = FlipperSql & " LOT_CUST_ID,LOT_PKG_ID,LOT_DEVICE,LOT_MES_QTY, " & vbCrLf
                FlipperSql = FlipperSql & " DEF1_PCBCHIP,DEF1_PCBCHIP_SS,DEF1_PCBCHIP_RT," & vbCrLf
                FlipperSql = FlipperSql & " DEF2_DIECRACK,DEF2_DIECRACK_SS,DEF2_DIECRACK_RT," & vbCrLf
                FlipperSql = FlipperSql & " DEF3_SOLDERBALL_DAMAGE,DEF3_SOLDERBALL_DAMAGE_SS,DEF3_SOLDERBALL_DAMAGE_RT," & vbCrLf
                FlipperSql = FlipperSql & " DEF4_DIECHIP,DEF4_DIECHIP_SS,DEF4_DIECHIP_RT," & vbCrLf
                FlipperSql = FlipperSql & " P1_BOAT_MATRIX,P2_TRAY_MATRIX,P3_BODY_SIZE,P4, P5," & vbCrLf
                FlipperSql = FlipperSql & " START_TIME,END_TIME,REMARK_CMT" & vbCrLf
                FlipperSql = FlipperSql & " )" & vbCrLf
                FlipperSql = FlipperSql & " VALUES (" & vbCrLf
                FlipperSql = FlipperSql & "'" & objLotInfo1.strLotID.ToUpper & "'," & vbCrLf
                FlipperSql = FlipperSql & "'" & Tmp_Oper & "'," & vbCrLf
                FlipperSql = FlipperSql & "'" & objUser1.strUserID & "'," & vbCrLf
                FlipperSql = FlipperSql & "'" & objLotInfo1.strFlipperEquip.ToUpper & "'," & vbCrLf
                FlipperSql = FlipperSql & "'" & txtBOReason.Text & "'," & vbCrLf
                FlipperSql = FlipperSql & "'" & Now.ToString("yyyy-MM-dd HH:mm:ss") & "'," & vbCrLf
                FlipperSql = FlipperSql & "'" & TXT_JOB.Text & "'," & vbCrLf
                FlipperSql = FlipperSql & "'" & CUST_ID.Text & "'," & vbCrLf
                FlipperSql = FlipperSql & "'" & PKG_ID.Text & "'," & vbCrLf
                FlipperSql = FlipperSql & "'" & CUST_DEVICE.Text & "'," & vbCrLf
                FlipperSql = FlipperSql & "'" & CUR_DIE_QTY.Text & "'," & vbCrLf
                FlipperSql = FlipperSql & "'" & TXT_D1.Text & "'," & vbCrLf
                FlipperSql = FlipperSql & "'" & TXT_D1_SS.Text & "'," & vbCrLf
                FlipperSql = FlipperSql & "'" & DropDown_D1_RT.Text & "'," & vbCrLf
                FlipperSql = FlipperSql & "'" & TXT_D2.Text & "'," & vbCrLf
                FlipperSql = FlipperSql & "'" & TXT_D2_SS.Text & "'," & vbCrLf
                FlipperSql = FlipperSql & "'" & DropDown_D2_RT.Text & "'," & vbCrLf
                FlipperSql = FlipperSql & "'" & TXT_D3.Text & "'," & vbCrLf
                FlipperSql = FlipperSql & "'" & TXT_D3_SS.Text & "'," & vbCrLf
                FlipperSql = FlipperSql & "'" & DropDown_D3_RT.Text & "'," & vbCrLf
                FlipperSql = FlipperSql & "'" & TXT_D4.Text & "'," & vbCrLf
                FlipperSql = FlipperSql & "'" & TXT_D4_SS.Text & "'," & vbCrLf
                FlipperSql = FlipperSql & "'" & DropDown_D4_RT.Text & "'," & vbCrLf
                FlipperSql = FlipperSql & "'" & TXT_BOAT_MT.Text & "'," & vbCrLf
                FlipperSql = FlipperSql & "'" & "" & "'," & vbCrLf
                FlipperSql = FlipperSql & "'" & TXT_BODY_SIZE.Text & "'," & vbCrLf
                FlipperSql = FlipperSql & "'" & "" & "'," & vbCrLf
                FlipperSql = FlipperSql & "'" & "" & "'," & vbCrLf
                FlipperSql = FlipperSql & "'" & _txt_Stime.Text & "'," & vbCrLf
                FlipperSql = FlipperSql & "'" & _txt_Etime.Text & "'," & vbCrLf
                FlipperSql = FlipperSql & "'" & _txt_Remark.Text & "'" & vbCrLf
                FlipperSql = FlipperSql & "  )" & vbCrLf

                'CTLSql = " INSERT INTO ELOG_SHT_CTL " & vbCrLf

                'CTLSql = CTLSql & " ( " & vbCrLf
                'CTLSql = CTLSql & " LOT_ID                ,OPER                     ,OPERATOR_ID       ,EQUIP_ID    ,BUYOFF_REASON  ,SUBMIT_TIME,JOB_FILE," & vbCrLf
                'CTLSql = CTLSql & " LOT_CUST_ID           ,LOT_PKG_ID               ,LOT_DEVICE        ,LOT_MES_QTY, " & vbCrLf
                'CTLSql = CTLSql & " DEF1_PCBCHIP          ,DEF1_PCBCHIP_SS          ,DEF1_PCBCHIP_RT," & vbCrLf
                'CTLSql = CTLSql & " DEF2_DIECRACK         ,DEF2_DIECRACK_SS         ,DEF2_DIECRACK_RT," & vbCrLf
                'CTLSql = CTLSql & " DEF3_SOLDERBALL_DAMAGE,DEF3_SOLDERBALL_DAMAGE_SS,DEF3_SOLDERBALL_DAMAGE_RT," & vbCrLf
                'CTLSql = CTLSql & " DEF4_DIECHIP          ,DEF4_DIECHIP_SS          ,DEF4_DIECHIP_RT," & vbCrLf

                'CTLSql = CTLSql & " P1_BOAT_MATRIX        ,P2_TRAY_MATRIX           ,P3_BODY_SIZE   ,P4, P5,"

                'CTLSql = CTLSql & " START_TIME            ,END_TIME                 ,REMARK_CMT" & vbCrLf
                'CTLSql = CTLSql & " )" & vbCrLf

                'CTLSql = CTLSql & " VALUES (" & vbCrLf

                'CTLSql = CTLSql & "'" & objLotInfo1.strLotID.ToUpper & "'," & vbCrLf
                'CTLSql = CTLSql & "'" & Tmp_Oper2 & "'," & vbCrLf
                'CTLSql = CTLSql & "'" & objUser1.strUserID & "'," & vbCrLf
                'CTLSql = CTLSql & "'" & objLotInfo1.strCTLEquip.ToUpper & "'," & vbCrLf
                'CTLSql = CTLSql & "'" & txtBOReason.Text & "'," & vbCrLf


                'CTLSql = CTLSql & "'" & Now.ToString("yyyy-MM-dd HH:mm:ss") & "'," & vbCrLf
                'CTLSql = CTLSql & "'" & txtJOB_FILE.Text & "'," & vbCrLf

                'CTLSql = CTLSql & "'" & CUST_ID.Text & "'," & vbCrLf
                'CTLSql = CTLSql & "'" & PKG_ID.Text & "'," & vbCrLf
                'CTLSql = CTLSql & "'" & CUST_DEVICE.Text & "'," & vbCrLf
                'CTLSql = CTLSql & "'" & CUR_DIE_QTY.Text & "'," & vbCrLf

                'CTLSql = CTLSql & "'" & txtDEF1_PCBCHIP.Text & "'," & vbCrLf
                'CTLSql = CTLSql & "'" & txtDEF1_PCBCHIP_SS.Text & "'," & vbCrLf
                'CTLSql = CTLSql & "'" & ddlDEF1_PCBCHIP_RT.Text & "'," & vbCrLf

                'CTLSql = CTLSql & "'" & txtDEF2_DIECRACK.Text & "'," & vbCrLf
                'CTLSql = CTLSql & "'" & txtDEF2_DIECRACK_SS.Text & "'," & vbCrLf
                'CTLSql = CTLSql & "'" & ddlDEF2_DIECRACK_RT.Text & "'," & vbCrLf

                'CTLSql = CTLSql & "'" & txtDEF3_SOLDERBALL_DAMAGE.Text & "'," & vbCrLf
                'CTLSql = CTLSql & "'" & txtDEF3_SOLDERBALL_DAMAGE_SS.Text & "'," & vbCrLf
                'CTLSql = CTLSql & "'" & ddlDEF3_SOLDERBALL_DAMAGE_RT.Text & "'," & vbCrLf

                'CTLSql = CTLSql & "'" & txtDEF4_DIECHIP.Text & "'," & vbCrLf
                'CTLSql = CTLSql & "'" & txtDEF4_DIECHIP_SS.Text & "'," & vbCrLf
                'CTLSql = CTLSql & "'" & ddlDEF4_DIECHIP_RT.Text & "'," & vbCrLf


                'CTLSql = CTLSql & "'" & txtP1_BOAT_MATRIX.Text & "'," & vbCrLf
                'CTLSql = CTLSql & "'" & txtP2_TRAY_MATRIX.Text & "'," & vbCrLf
                'CTLSql = CTLSql & "'" & txtP3_BODY_SIZE.Text & "'," & vbCrLf
                'CTLSql = CTLSql & "'" & "" & "'," & vbCrLf
                'CTLSql = CTLSql & "'" & "" & "'," & vbCrLf


                'CTLSql = CTLSql & "'" & txtSTART_TIME.Text & "'," & vbCrLf
                'CTLSql = CTLSql & "'" & txtEND_TIME.Text & "'," & vbCrLf
                'CTLSql = CTLSql & "'" & txtREMARK_CMT.Text & "'" & vbCrLf

                'CTLSql = CTLSql & "  )" & vbCrLf

            End If


            If objLotInfo1.strELogsheetType.ToUpper().Equals("SHIFT MONITOR") Or objLotInfo1.strELogsheetType.ToUpper().Equals("LOT MONITOR") Then
                If Not objLotInfo1.strFlipperEquip.Equals("") Then
                    ObjADO.ExecuteNonQuery(FlipperSql, sconn)
                End If

                'If Not objLotInfo1.strCTLEquip.Equals("") Then
                '    ObjADO.ExecuteNonQuery(CTLSql, sconn)
                'End If


            End If

            If ObjADO.ExecuteNonQuery(ssql) Then

                Dim strPageFlow As String
                Dim strNewURL As String
                strPageFlow = objUser1.strPageFlow
                strNewURL = getNewURL(strPageFlow)

                Response.Redirect(strNewURL)
            Else
                Session("ERRMSG") = "Error inserting X Param data to Database"
                Response.Redirect("ErrorPage.aspx")
            End If
        End If
    End Sub

    Protected Sub btnBackStep1_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnBackStep1.Click
        Dim strPageFlow As String
        Dim strNewURL As String
        strPageFlow = objUser1.strPageFlow
        strNewURL = getNewURL(strPageFlow)

        Response.Redirect(strNewURL)
    End Sub

    Protected Sub CustomValidator1_ServerValidate(ByVal source As Object, ByVal args As System.Web.UI.WebControls.ServerValidateEventArgs) Handles CustomValidator1.ServerValidate
        'If Not IsNumber(Me.txtFulxPlateDepth.Text) Then
        '    args.IsValid = False
        '    CustomValidatorFlux.ErrorMessage = "Please key in number"
        '    'Me.txtFLUXThickness.Text = "0"
        'End If
    End Sub

    Protected Sub CustomValidator3_ServerValidate(ByVal source As Object, ByVal args As System.Web.UI.WebControls.ServerValidateEventArgs) Handles CustomValidator3.ServerValidate
        'If Not IsNumber(Me.txtFluxPosition.Text) Then
        '    args.IsValid = False
        '    CustomValidator3.ErrorMessage = "Please key in number"
        '    'Me.txtFLUXThickness.Text = "0"
        'End If
    End Sub

    Protected Sub CustomValidator2_ServerValidate(ByVal source As Object, ByVal args As System.Web.UI.WebControls.ServerValidateEventArgs) Handles CustomValidator2.ServerValidate
        'If Not IsNumber(Me.txtBallAttachPosition.Text) Then
        '    args.IsValid = False
        '    CustomValidator2.ErrorMessage = "Please key in number"
        '    'Me.txtFLUXThickness.Text = "0"
        'End If
    End Sub

    Protected Sub cvPeakTemp_ServerValidate(ByVal source As Object, ByVal args As System.Web.UI.WebControls.ServerValidateEventArgs) Handles cvPeakTemp.ServerValidate
        Dim strPeakTemp As String = Me.txtPeakTemp.Text.Trim()

        If strPeakTemp = "" Then
            args.IsValid = False
            cvPeakTemp.ErrorMessage = "Peak Temp 항목을 입력해 주세요."
            Exit Sub
        End If

        If Not IsNumber(strPeakTemp) Then
            args.IsValid = False
            cvPeakTemp.ErrorMessage = "Please key in number"
            Exit Sub
        End If

        If objUser1.strGroup.Equals("TE") And Not lblPTRange.Text.Equals("~") And Not lblPTRange.Text.StartsWith("ER") And lblPTRange.Text.Contains("~") Then
            Dim arr As String() = lblPTRange.Text.Split(New Char() {"~"c})
            Dim pt1 As Double
            Dim pt2 As Double
            Dim pt As Double
            If arr.Length = 2 AndAlso Double.TryParse(arr(0), pt1) AndAlso Double.TryParse(arr(1), pt2) AndAlso Double.TryParse(strPeakTemp, pt) Then
                If pt < pt1 Or pt > pt2 Then
                    args.IsValid = False
                    cvPeakTemp.ErrorMessage = "Peak Temp값이 허용 범위(" + lblPTRange.Text + ")를 벗어났습니다."
                End If
            End If
        End If
    End Sub

    Protected Sub CustomValidator5_ServerValidate(ByVal source As Object, ByVal args As System.Web.UI.WebControls.ServerValidateEventArgs) Handles CustomValidator5.ServerValidate
        If Me.txtDwellTime_Eutectic.Text.Trim() = "" Then
            args.IsValid = False
            CustomValidator5.ErrorMessage = "Dwell time 항목을 입력해 주세요."
        ElseIf Not IsNumber(Me.txtDwellTime_Eutectic.Text) Then
            args.IsValid = False
            CustomValidator5.ErrorMessage = "Please key in number"
            'Me.txtFLUXThickness.Text = "0"
        End If
    End Sub

    Protected Sub CustomValidator7_ServerValidate(ByVal source As Object, ByVal args As System.Web.UI.WebControls.ServerValidateEventArgs) Handles CustomValidator7.ServerValidate
        If Me.txtSoakTime_Eutectic.Text.Trim() = "" Then
            args.IsValid = False
            CustomValidator7.ErrorMessage = "Soak time 항목을 입력해 주세요."
        ElseIf Not IsNumber(Me.txtSoakTime_Eutectic.Text) Then
            args.IsValid = False
            CustomValidator7.ErrorMessage = "Please key in number"
            'Me.txtFLUXThickness.Text = "0"
        End If
    End Sub

    Protected Sub CustomValidator9_ServerValidate(ByVal source As Object, ByVal args As System.Web.UI.WebControls.ServerValidateEventArgs) Handles CustomValidator9.ServerValidate
        If Not IsNumber(Me.txtCoolingRatePeak_Eutectic.Text) Then
            args.IsValid = False
            CustomValidator9.ErrorMessage = "Please key in number"
            'Me.txtFLUXThickness.Text = "0"
        End If
    End Sub

    'Protected Sub CustomValidator11_ServerValidate(ByVal source As Object, ByVal args As System.Web.UI.WebControls.ServerValidateEventArgs) Handles CustomValidator11.ServerValidate
    '    If Not IsNumber(Me.txtCoolingRateMid_Eutectic.Text) Then
    '        args.IsValid = False
    '        CustomValidator11.ErrorMessage = "Please key in number"
    '        'Me.txtFLUXThickness.Text = "0"
    '    End If
    'End Sub

    Protected Sub CustomValidator13_ServerValidate(ByVal source As Object, ByVal args As System.Web.UI.WebControls.ServerValidateEventArgs) Handles CustomValidator13.ServerValidate
        If Not IsNumber(Me.txtCoolingRateExit_Eutectic.Text) Then
            args.IsValid = False
            CustomValidator13.ErrorMessage = "Please key in number"
            'Me.txtFLUXThickness.Text = "0"
        End If
    End Sub

    'Protected Sub CustomValidator6_ServerValidate(ByVal source As Object, ByVal args As System.Web.UI.WebControls.ServerValidateEventArgs) Handles CustomValidator6.ServerValidate
    '    If Not IsNumber(Me.txtDwellTime_PB.Text) Then
    '        args.IsValid = False
    '        CustomValidator6.ErrorMessage = "Please key in number"
    '        'Me.txtFLUXThickness.Text = "0"
    '    End If
    'End Sub

    'Protected Sub CustomValidator8_ServerValidate(ByVal source As Object, ByVal args As System.Web.UI.WebControls.ServerValidateEventArgs) Handles CustomValidator8.ServerValidate
    '    If Not IsNumber(Me.txtSoakTime_PB.Text) Then
    '        args.IsValid = False
    '        CustomValidator8.ErrorMessage = "Please key in number"
    '        'Me.txtFLUXThickness.Text = "0"
    '    End If
    'End Sub

    'Protected Sub CustomValidator10_ServerValidate(ByVal source As Object, ByVal args As System.Web.UI.WebControls.ServerValidateEventArgs) Handles CustomValidator10.ServerValidate
    '    If Not IsNumber(Me.txtCoolingRatePeak_PB.Text) Then
    '        args.IsValid = False
    '        CustomValidator10.ErrorMessage = "Please key in number"
    '        'Me.txtFLUXThickness.Text = "0"
    '    End If
    'End Sub

    'Protected Sub CustomValidator12_ServerValidate(ByVal source As Object, ByVal args As System.Web.UI.WebControls.ServerValidateEventArgs) Handles CustomValidator12.ServerValidate
    '    If Not IsNumber(Me.txtCoolingRateMid_PB.Text) Then
    '        args.IsValid = False
    '        CustomValidator12.ErrorMessage = "Please key in number"
    '        'Me.txtFLUXThickness.Text = "0"
    '    End If
    'End Sub

    'Protected Sub CustomValidator14_ServerValidate(ByVal source As Object, ByVal args As System.Web.UI.WebControls.ServerValidateEventArgs) Handles CustomValidator14.ServerValidate
    '    If Not IsNumber(Me.txtCoolingRateExit_PB.Text) Then
    '        args.IsValid = False
    '        CustomValidator14.ErrorMessage = "Please key in number"
    '        'Me.txtFLUXThickness.Text = "0"
    '    End If
    'End Sub




    Protected Sub ddlSOPType_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddlSOPType.SelectedIndexChanged
        If ddlSOPType.SelectedValue = "Lead free ball" Then
            lblDwell.Text = "Dwell time (above>220℃)"
            lblSoak.Text = "Soak time(130~220℃)"
        Else
            lblDwell.Text = "Dwell time (above>183℃)"
            lblSoak.Text = "Soak time(130~183℃)"
        End If
    End Sub

    Private Sub LOTData()


        Dim Act_LotNo As String
        Dim SQL As String
        Dim sconn As String = "User ID=rts;Password=rts4sck0; data source=skcimdwh.World"

        If (objLotInfo1.strLotID) <> "" Then

            Act_LotNo = objLotInfo1.strLotID

            SQL = "SELECT CUST_ID, PKG_ID, CUST_DEVICE, CUR_DIE_QTY FROM WIP_LOTINF@LINK_CPKMES1 WHERE LOT_ID ='" + Act_LotNo + "'"

            Dim oTbl As System.Data.DataTable = ObjADO.GetRecord(SQL, sconn)

            If oTbl.Rows.Count > 0 Then
                CUST_ID.Text = oTbl.Rows(0)("CUST_ID")
                PKG_ID.Text = oTbl.Rows(0)("PKG_ID")
                CUST_DEVICE.Text = oTbl.Rows(0)("CUST_DEVICE")
                CUR_DIE_QTY.Text = oTbl.Rows(0)("CUR_DIE_QTY")
            Else

            End If

        End If

    End Sub


End Class
