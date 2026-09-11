Imports objFactory
Imports System.Data
Partial Class SBM_QAXParam
    Inherits System.Web.UI.Page
    Private ObjADO As New OracleHelper
    Dim objUser1 As objUser
    Dim objLotInfo1 As objLotInfo

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        objUser1 = CType(Session("User"), objUser)
        objLotInfo1 = CType(Session("LotInfo"), objLotInfo)
        If Session("User") Is Nothing Then
            Response.Write("<script language='javascript'>alert('Timeout! Please login again');</script>")
            Response.Redirect("menu.aspx")
        End If
        If Not Page.IsPostBack Then

            populateLotInfo()
            'Populate elogsheet if have
            
            If Not Session("ParamX") Is Nothing Then
                Dim objXParam1 As New objXParam
                objXParam1 = CType(Session("ParamX"), objXParam)
                populateELog(objXParam1)                
                'IF elogsheet hasnt buyoff, dont insert.
                If ChecklogsheetExist(objLotInfo1, objUser1.strGroup) Then
                    lblelogsheetExist.Text = "Y"
                End If
            End If
        End If
        txtBOReason.Text = objLotInfo1.strELogsheetType        
        If ddlSOPType.SelectedValue = "Lead free ball" Then
            lblDwell.Text = "Dwell time (above>220℃)"
            lblSoak.Text = "Soak time(130~220℃)"
        Else
            lblDwell.Text = "Dwell time (above>183℃)"
            lblSoak.Text = "Soak time(130~183℃)"
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
        End If

    End Sub
    Private Sub populateELog(ByVal objXParam1 As objXParam)
        'If dt.Rows.Count > 0 Then        
        'If Not IsNothing(objXParam1.strShelfLife) Then
        'txtShelfLife.Text = objXParam1.strShelfLife
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
        If Not IsNothing(objXParam1.strCoolingRate_Mid_EU) Then
            txtCoolingRateMid_Eutectic.Text = objXParam1.strCoolingRate_Mid_EU
        End If
        If Not IsNothing(objXParam1.strCoolingRate_Exit_EU) Then
            txtCoolingRateExit_Eutectic.Text = objXParam1.strCoolingRate_Exit_EU
        End If
        If Not IsNothing(objXParam1.strPeakTemp) Then
            txtPeakTemp.Text = objXParam1.strPeakTemp
        End If

    End Sub
    Private Function ChecklogsheetExist(ByVal objLotInfo1 As objLotInfo, ByVal strGroup As String) As Boolean

        Dim result As Boolean = False

        Dim ssql As String
        If objLotInfo1.strELogsheetType.ToUpper = "SHIFT MONITOR" Then
            ssql = "select * " _
       + " from SBM_ELOGSHEET where " _
       + " LOTID='" + objLotInfo1.strLotID.ToUpper + "' " _
       + " and EQUIPID='" + objLotInfo1.strEquipID.ToUpper + "' " _
       + " and ELOGSHEETYPE='" + objLotInfo1.strELogsheetType.ToUpper + "' and Y_SUBMIT_DATE is null" _
        + " and SH_MONITOR_TYPE='QA'"
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

    Protected Sub ddlSOPType_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddlSOPType.SelectedIndexChanged
        If ddlSOPType.SelectedValue = "Lead free ball" Then
            lblDwell.Text = "Dwell time (above>220℃)"
            lblSoak.Text = "Soak time(130~220℃)"
        Else
            lblDwell.Text = "Dwell time (above>183℃)"
            lblSoak.Text = "Soak time(130~183℃)"
        End If
    End Sub

    Protected Sub cvPeakTemp_ServerValidate(ByVal source As Object, ByVal args As System.Web.UI.WebControls.ServerValidateEventArgs) Handles cvPeakTemp.ServerValidate
        If Me.txtPeakTemp.Text.Trim() = "" Then
            args.IsValid = False
            cvPeakTemp.ErrorMessage = "Peak Temp 항목을 입력해 주세요."
        ElseIf Not IsNumber(Me.txtPeakTemp.Text) Then
            args.IsValid = False
            cvPeakTemp.ErrorMessage = "Please key in number"
        End If
    End Sub

    Protected Sub CustomValidator5_ServerValidate(ByVal source As Object, ByVal args As System.Web.UI.WebControls.ServerValidateEventArgs) Handles CustomValidator5.ServerValidate
        If Me.txtDwellTime_Eutectic.Text.Trim() = "" Then
            args.IsValid = False
            CustomValidator5.ErrorMessage = "Dwell time 항목을 입력해 주세요."
        ElseIf Not IsNumber(Me.txtDwellTime_Eutectic.Text) Then
            args.IsValid = False
            CustomValidator5.ErrorMessage = "Please key in number"
        End If
    End Sub

    Protected Sub CustomValidator7_ServerValidate(ByVal source As Object, ByVal args As System.Web.UI.WebControls.ServerValidateEventArgs) Handles CustomValidator7.ServerValidate
        If Me.txtSoakTime_Eutectic.Text.Trim() = "" Then
            args.IsValid = False
            CustomValidator7.ErrorMessage = "Soak time 항목을 입력해 주세요."
        ElseIf Not IsNumber(Me.txtSoakTime_Eutectic.Text) Then
            args.IsValid = False
            CustomValidator7.ErrorMessage = "Please key in number"
        End If
    End Sub

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
    Protected Sub btnBackStep1_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnBackStep1.Click
        Dim strPageFlow As String
        Dim strNewURL As String
        strPageFlow = objUser1.strPageFlow
        strNewURL = getNewURL(strPageFlow)

        Response.Redirect(strNewURL)
    End Sub
    Private Function getNewURL(ByVal strPageFlow As String) As String
        Dim strCurrentURL As String
        Dim strFullPath As String
        strFullPath = System.Web.HttpContext.Current.Request.Url.AbsolutePath
        strCurrentURL = strFullPath.Substring(strFullPath.LastIndexOf("/") + 1)
        'Controller.NavigatePage(strCurrentURL, strPageFlow)

        Return Controller.NavigatePage(strCurrentURL, strPageFlow)

    End Function

    Protected Sub btnToStep3_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnToStep3.Click
        Dim strGroup As String
        Dim ssql As String = ""
        Dim errMsg As String = ""
        
        If (Page.IsValid) Then
            If objLotInfo1.strCustomer = "QUALCOMM" Then
                If (txtCoolingRateExit_Eutectic.Text.Equals("")) Then
                    errMsg += "COOLING_RATE_EXIT_EUTECTIC,"
                End If
                If (objUser1.strUserID.Equals("")) Then
                    errMsg += "TECHNICIAN_ID,"
                End If

                If Not errMsg = "" Then
                    errMsg = errMsg.Remove(errMsg.LastIndexOf(","))
                    errMsg += " 항목은 필수 입력 항목입니다."
                    Response.Write("<script>alert('" + errMsg + "');</script>")
                    Return
                End If
            End If
        
            strGroup = objUser1.strGroup
            If lblelogsheetExist.Text.Equals("Y") Then
                ssql = "update SBM_ELOGSHEET set " _
                  + " BALL_DISCOLORATION_SAMPLE='" + txtBallDiscoloration_Sample.Text + "'," _
              + " BALL_DISCOLORATION_PASS='" + txtBallDiscoloration_Pass.Text + "'," _
              + " BALL_DISCOLORATION_METHOD='" + txtBallDiscoloration_Method.Text + "'," _
              + " BALL_DISCOLORATION_RESULT='" + ddlBallDiscoloration_Result.SelectedValue + "'," _
              + " BALL_SIZE_SAMPLE='" + IIf(txtBallSize_Sample.Text = "", " ", txtBallSize_Sample.Text) + "'," _
                + " BALL_SIZE_PASS='" + txtBallSize_Pass.Text + "'," _
                + " BALL_SIZE_METHOD='" + txtBallSize_Method.Text + "'," _
                + " BALL_SIZE_RESULT='" + ddlBallSize_Result.SelectedValue + "'," _
                 + " SOPTYPE='" + ddlSOPType.SelectedValue + "'," _
                 + " PEAK_TEMP='" + txtPeakTemp.Text + "'," _
                 + " DWELL_TIME_EUTECTIC='" + txtDwellTime_Eutectic.Text + "'," _
                 + " SOAK_TIME_EUTECTIC='" + txtSoakTime_Eutectic.Text + "'," _
                 + " COOLING_RATE_PEAK_EUTECTIC='" + txtCoolingRatePeak_Eutectic.Text + "'," _
                 + " COOLING_RATE_MID_EUTECTIC='" + txtCoolingRateMid_Eutectic.Text + "'," _
                 + " COOLING_RATE_EXIT_EUTECTIC='" + txtCoolingRateExit_Eutectic.Text + "'," _
                 + " TECHNICIAN_ID='" + objUser1.strUserID + "'," _
                 + " TECHNICIAN_DATE=sysdate " _
                 + " where LOTID='" + objLotInfo1.strLotID.ToUpper + "' and " _
                 + " EQUIPID='" + objLotInfo1.strEquipID.ToUpper + "' and " _
                 + " ELOGSHEETYPE='" + objLotInfo1.strELogsheetType.ToUpper + "' and " _
                 + " SH_MONITOR_TYPE='QA' and " _
                 + " Y_SUBMIT_DATE is null "
            Else
                'ssql = "insert into SBM_ELOGSHEET(SHELF_LIFE,FLUX_LIFE,BALL_DISCOLORATION_SAMPLE,BALL_DISCOLORATION_PASS," _
                '             + "BALL_DISCOLORATION_METHOD,BALL_DISCOLORATION_RESULT,BALL_SIZE_SAMPLE,BALL_SIZE_PASS,BALL_SIZE_METHOD,BALL_SIZE_RESULT,SOLDER_BALL_PART_NO," _
                '             + "SOLDER_BALL_BATCH_NO,SOLDERBALL_IQANO,FLUX_PART_NO,FLUX_BATCH_NO,Y_SUBMIT_BY,Y_SUBMIT_DATE,LOTID,EQUIPID,ELOGSHEETYPE" _
                '             + ",SH_MONITOR_TYPE)" _
                '             + "VALUES(" _
                '             + "'" + txtShelfLife.Text + "'," _
                '             + "'" + txtFluxLife.Text + "'," _
                '             + "'" + txtBallDiscoloration_Sample.Text + "'," _
                '             + "'" + txtBallDiscoloration_Pass.Text + "'," _
                '             + "'" + txtBallDiscoloration_Method.Text + "'," _
                '             + "'" + ddlBallDiscoloration_Result.SelectedValue + "'," _
                '             + "'" + IIf(txtBallSize_Sample.Text = "", " ", txtBallSize_Sample.Text) + "'," _
                '             + "'" + txtBallSize_Pass.Text + "'," _
                '             + "'" + txtBallSize_Method.Text + "'," _
                '             + "'" + ddlBallSize_Result.SelectedValue + "'," _
                ssql = "insert into SBM_ELOGSHEET " _
                + " (BALL_DISCOLORATION_SAMPLE,BALL_DISCOLORATION_PASS, " _
                + " BALL_DISCOLORATION_METHOD,BALL_DISCOLORATION_RESULT,BALL_SIZE_SAMPLE,BALL_SIZE_PASS,BALL_SIZE_METHOD,BALL_SIZE_RESULT, " _
                + " SOPTYPE,  " _
                + " PEAK_TEMP,  " _
                + " DWELL_TIME_EUTECTIC,  " _
                + " SOAK_TIME_EUTECTIC,  " _
                + " COOLING_RATE_PEAK_EUTECTIC,  " _
                + " COOLING_RATE_MID_EUTECTIC,  " _
                + " COOLING_RATE_EXIT_EUTECTIC,  " _
                + " OPERATOR_ID, OPERATOR_DATE, " _
                + " LOTID, EQUIPID, ELOGSHEETYPE,SH_MONITOR_TYPE) values " _
                + " ( " _
                + "'" + txtBallDiscoloration_Sample.Text + "'," _
                + "'" + txtBallDiscoloration_Pass.Text + "'," _
                + "'" + txtBallDiscoloration_Method.Text + "'," _
                + "'" + ddlBallDiscoloration_Result.SelectedValue + "'," _
                + "'" + IIf(txtBallSize_Sample.Text = "", " ", txtBallSize_Sample.Text) + "'," _
                + "'" + txtBallSize_Pass.Text + "'," _
                + "'" + txtBallSize_Method.Text + "'," _
                + "'" + ddlBallSize_Result.SelectedValue + "','" _
                + ddlSOPType.SelectedValue + "','" _
                + txtPeakTemp.Text + "','" _
                + txtDwellTime_Eutectic.Text + "','" _
                + txtSoakTime_Eutectic.Text + "','" _
                + txtCoolingRatePeak_Eutectic.Text + "','" _
                + txtCoolingRateMid_Eutectic.Text + "','" _
                + txtCoolingRateExit_Eutectic.Text + "','" _
                + objUser1.strUserID + "',sysdate,'" _
                + objLotInfo1.strLotID.ToUpper + "','" + objLotInfo1.strEquipID.ToUpper + "','" _
                + objLotInfo1.strELogsheetType.ToUpper + "','QA')"
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
End Class
