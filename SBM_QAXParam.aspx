<%@ Page Language="VB" AutoEventWireup="false" CodeFile="SBM_QAXParam.aspx.vb" Inherits="SBM_QAXParam" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
 	<meta content="Microsoft Visual Studio .NET 7.1" name="GENERATOR">
		<meta content="Visual Basic .NET 7.1" name="CODE_LANGUAGE">
		<meta content="JavaScript" name="vs_defaultClientScript">
		<meta content="http://schemas.microsoft.com/intellisense/ie5" name="vs_targetSchema">
		<link href="Styles.css" rel="stylesheet" type="text/css">
		<LINK href="Styles.css" type="text/css" rel="stylesheet">
		<script language="Javascript">
// (C) 2003 CodeLifter.com
// Source: CodeLifter.com
// Do not remove this header
// Set the message for the alert box
am = "This function is disabled!";
// do not edit below this line
// ===========================
bV  = parseInt(navigator.appVersion)
bNS = navigator.appName=="Netscape"
bIE = navigator.appName=="Microsoft Internet Explorer"
function nrc(e) {
   if (bNS && e.which > 1){
      alert(am)
      return false
   } else if (bIE && (event.button >1)) {
     alert(am)
     return false;
   }
}
document.onmousedown = nrc;
if (document.layers) window.captureEvents(Event.MOUSEDOWN);
if (bNS && bV<5) window.onmousedown = nrc;

				var count = 0;
                    var time1;
                    var time2;
                    var period;
                    function cleartime()
                    {
			                time1=0;
			                time2=0;
			                count = 0;
                    }
                    function recordtime()
                    {
                        count = count+1;
                        if(count == 1)
                        {
                            time1 = new Date().getTime();
                        }
                        else
                        {
                            time2 = new Date().getTime();
                        }
                    }
                     function lost_focus_compare(ctl_name) 
                    {
                        period=((time2-time1)/1000).toFixed(2)
                        if(period>0.5)
                        {
                            alert("Please input this informatioin with Sacnner!");
                            document.getElementById(ctl_name).innerText="";
                        }
                        else
                        {
                        
                        }
                    }
                    function lost_focus_compare2(ctl_name) 
                    {
                        period=((time2-time1)/1000).toFixed(2)
                        if(period>0.5)
                        {
			                 var returnValue=window.showModalDialog('KeyInRightsConfirm.aspx?Info='+document.getElementById(ctl_name).value ,'Confirm','dialogHeight: 210px; dialogWidth: 250px; center: Yes; help: No; resizable: No; status: No;');
			                if (returnValue>0)
			                {
				               if (returnValue>100)
							   {
				                 alert("Information is not correct!");
								 document.getElementById(ctl_name).innerText="";
				               }
				                 
			                }
			                else
			                {
								if  (returnValue<-1)
								{
									alert("Invalid user or password!");
									document.getElementById(ctl_name).innerText="";
								}
								else
								{
									alert("Reset information!");
									document.getElementById(ctl_name).innerText="";
								}
			                }
                        }
                        else
                        {
                        
                        }
                    }


		</script>
		
</head>
<body>
    <form id="form1" runat="server">
    
        <table id="Table1" border="0" cellpadding="1" cellspacing="1" style="width: 875px;
            height: 352px" width="875">
            <tr>
                <td colspan="4" style="height: 19px">
                    <font color="mediumblue" face="Tahoma" size="2"><strong>Lot Information</strong></font></td>
            </tr>
            <tr>
                <td>
                </td>
                <td style="width: 299px">
                </td>
                <td style="width: 195px">
                </td>
                <td>
                </td>
            </tr>
            <tr>
                <td>
                    <font color="royalblue" face="Tahoma" size="2">Buy-off Reason</font></td>
                <td style="width: 299px">
                    <asp:TextBox ID="txtBOReason" runat="server" BorderColor="#8080FF" BorderWidth="1px"
                        CssClass="RptTextBox_NoEdit" Font-Names="Tahoma" Font-Size="Small" ReadOnly="True"
                        Width="232px" Height="22px"></asp:TextBox></td>
                <td style="width: 195px">
                    <font color="royalblue" face="Tahoma" size="2">Package Type</font></td>
                <td>
                    <asp:TextBox ID="txtPkg" runat="server" BorderColor="#8080FF" BorderWidth="1px" CssClass="RptTextBox_NoEdit"
                        Font-Names="Tahoma" Font-Size="Small" ReadOnly="True" TabIndex="1" Width="232px"></asp:TextBox></td>
            </tr>
            <tr>
                <td>
                    <font color="royalblue" face="Tahoma" size="2">Lot ID</font></td>
                <td style="width: 299px">
                    <asp:TextBox ID="txtLotID" runat="server" BorderColor="#8080FF" BorderWidth="1px"
                        CssClass="RptTextBox_NoEdit" Font-Names="Tahoma" Font-Size="Small" ReadOnly="True"
                        TabIndex="2" Width="232px"></asp:TextBox></td>
                <td style="width: 195px">
                    <font color="royalblue" face="Tahoma" size="2"><font color="royalblue" face="Tahoma"
                        size="2"><font color="#4169e1" face="Tahoma" size="2">Equipment ID</font></font></font></td>
                <td>
                    <asp:TextBox ID="txtEquipID" runat="server" BorderColor="#8080FF" BorderWidth="1px"
                        CssClass="RptTextBox_NoEdit" Font-Names="Tahoma" Font-Size="Small" ReadOnly="True"
                        TabIndex="3" Width="232px"></asp:TextBox></td>
            </tr>
            <tr>
                <td style="width: 189px; height: 17px">
                    <font color="#4169e1" face="Tahoma" size="2"><font color="royalblue" face="Tahoma"
                        size="2"><font color="royalblue" face="Tahoma" size="2"><font color="royalblue" face="Tahoma"
                            size="2"><font color="royalblue" face="Tahoma" size="2">Customer</font></font></font></font></font></td>
                <td style="width: 299px; height: 17px">
                    <asp:TextBox ID="txtCustomer" runat="server" BorderColor="#8080FF" BorderWidth="1px"
                        CssClass="RptTextBox_NoEdit" Font-Names="Tahoma" Font-Size="Small" ReadOnly="True"
                        TabIndex="4" Width="232px"></asp:TextBox></td>
                <td style="width: 195px; height: 17px">
                    <font color="royalblue" face="Tahoma" size="2"><font color="royalblue" face="Tahoma"
                        size="2"><font color="royalblue" face="Tahoma" size="2"><font color="#4169e1" face="Tahoma"
                            size="2"><font color="royalblue" face="Tahoma" size="2">Customer Device</font></font></font></font></font></td>
                <td style="height: 17px">
                    <asp:TextBox ID="txtDevice" runat="server" BorderColor="#8080FF" BorderWidth="1px"
                        CssClass="RptTextBox_NoEdit" Font-Names="Tahoma" Font-Size="Small" ReadOnly="True"
                        TabIndex="5" Width="232px"></asp:TextBox></td>
            </tr>
            <tr>
                <td colspan="4" style="height: 19px">
                    &nbsp;
                    <asp:Label ID="lblelogsheetExist" runat="server" Enabled="False" Visible="False">Label</asp:Label></td>
            </tr>
            <tr>
                <td colspan="4" style="height: 19px">
                    <font color="mediumblue" face="Tahoma" size="2"><strong>Reflow Oven</strong></font></td>
            </tr>
            <tr>
                <td colspan="4">
                    <font color="mediumblue" face="Tahoma" size="2"><strong>
                        <asp:DropDownList ID="ddlSOPType" runat="server" AutoPostBack="True" BackColor="#FFFF80"
                            TabIndex="24">
                            <asp:ListItem>Eutectic ball</asp:ListItem>
                            <asp:ListItem>Lead free ball</asp:ListItem>
                        </asp:DropDownList></strong></font></td>
            </tr>
            <tr>
                <td style="height: 28px">
                    <font color="royalblue" face="Tahoma" size="2">
                        <asp:Label ID="lblPeakTemp" runat="server" Text="Peak Temp"></asp:Label></font></td>
                <td colspan="3" style="width: 350px; height: 28px">
                    <asp:TextBox ID="txtPeakTemp" runat="server" BorderWidth="1px" CssClass="RptTextBox"
                        Font-Names="Tahoma" Font-Size="Small" TabIndex="25" Width="232px"></asp:TextBox><asp:CustomValidator
                            ID="cvPeakTemp" runat="server" ControlToValidate="txtPeakTemp"
                            Font-Bold="True" Font-Names="Tahoma" Font-Size="X-Small" SetFocusOnError="True"
                            ValidateEmptyText="True"></asp:CustomValidator>
                </td>
            </tr>
            <tr>
                <td style="height: 16px">
                    <font color="royalblue" face="Tahoma" size="2">
                        <asp:Label ID="lblDwell" runat="server" Text="Dwell time (above>183℃)"></asp:Label></font></td>
                <td colspan="3" style="width: 350px; height: 16px">
                    <asp:TextBox ID="txtDwellTime_Eutectic" runat="server" BorderWidth="1px" CssClass="RptTextBox"
                        Font-Names="Tahoma" Font-Size="Small" TabIndex="25" Width="232px"></asp:TextBox><asp:CustomValidator
                            ID="CustomValidator5" runat="server" ControlToValidate="txtDwellTime_Eutectic"
                            Font-Bold="True" Font-Names="Tahoma" Font-Size="X-Small" SetFocusOnError="True"
                            ValidateEmptyText="True"></asp:CustomValidator>
                </td>
            </tr>
            <tr>
                <td style="height: 25px">
                    <font color="royalblue" face="Tahoma" size="2">
                        <asp:Label ID="lblSoak" runat="server" Text="Soak time(130~183℃)"></asp:Label></font></td>
                <td colspan="3" style="height: 25px">
                    <asp:TextBox ID="txtSoakTime_Eutectic" runat="server" BorderWidth="1px" CssClass="RptTextBox"
                        Font-Names="Tahoma" Font-Size="Small" TabIndex="26" Width="232px"></asp:TextBox>
                    <asp:CustomValidator ID="CustomValidator7" runat="server" ControlToValidate="txtSoakTime_Eutectic"
                        Font-Bold="True" Font-Names="Tahoma" Font-Size="X-Small" SetFocusOnError="True"
                        ValidateEmptyText="True"></asp:CustomValidator>
                </td>
            </tr>
            <tr>
                <td style="height: 25px">
                    <font color="royalblue" face="Tahoma" size="2">
                        <asp:Label ID="lblCRateEutectic" runat="server" Text="Cooling rate (222 ~ 212℃) "></asp:Label></font></td>
                <td colspan="3" style="height: 25px">
                    <asp:TextBox ID="txtCoolingRatePeak_Eutectic" runat="server" BorderWidth="1px" CssClass="RptTextBox"
                        Font-Names="Tahoma" Font-Size="Small" TabIndex="27" Width="232px"></asp:TextBox><asp:CustomValidator
                            ID="CustomValidator9" runat="server" ControlToValidate="txtCoolingRatePeak_Eutectic"
                            Font-Bold="True" Font-Names="Tahoma" Font-Size="X-Small" SetFocusOnError="True"></asp:CustomValidator>
                </td>
            </tr>
            <tr>
                <td>
                    <font color="royalblue" face="Tahoma" size="2">
                        <asp:Label ID="lblCRateExitEutectic" runat="server" Text="Cooling rate (Peak ~ Exit) "></asp:Label></font></td>
                <td colspan="3">
                    <asp:TextBox ID="txtCoolingRateExit_Eutectic" runat="server" BorderWidth="1px" CssClass="RptTextBox"
                        Font-Names="Tahoma" Font-Size="Small" TabIndex="29" Width="232px"></asp:TextBox><asp:CustomValidator
                            ID="CustomValidator13" runat="server" ControlToValidate="txtCoolingRateExit_Eutectic"
                            Font-Bold="True" Font-Names="Tahoma" Font-Size="X-Small" SetFocusOnError="True"></asp:CustomValidator></td>
            </tr>
            <tr>
                <td style="height: 25px">
                    <font color="royalblue" face="Tahoma" size="2">
                        <asp:Label ID="Label2" runat="server" Text="Cooling rate (Peak ~ 200℃) " Visible="False"></asp:Label></font></td>
                <td colspan="3" style="height: 25px">
                    <asp:TextBox ID="txtCoolingRateMid_Eutectic" runat="server" BorderWidth="1px" CssClass="RptTextBox"
                        Font-Names="Tahoma" Font-Size="Small" TabIndex="28" Visible="False" Width="232px"></asp:TextBox><asp:CustomValidator
                            ID="CustomValidator11" runat="server" ControlToValidate="txtCoolingRateMid_Eutectic"
                            Font-Bold="True" Font-Names="Tahoma" Font-Size="X-Small" SetFocusOnError="True"
                            Visible="False"></asp:CustomValidator></td>
            </tr>
            <tr>
                <td style="height: 10px">
                    <strong><span style="font-size: 10pt; color: #0000cd; font-family: Tahoma">Y Parameters</span></strong></td>
                <td colspan="3" style="height: 10px">
                </td>
            </tr>
            <tr>
                <td style="height: 17px">
                    <span style="font-size: 10pt; color: #4169e1; font-family: Tahoma"></span>
                </td>
                <td style="height: 17px">
                    <strong><span style="font-size: 10pt; color: #4169e1; font-family: Tahoma"> Sample Size</span></strong></td>
                <td style="height: 17px">
                    <strong><span style="font-size: 10pt; color: #4169e1; font-family: Tahoma">Method</span></strong></td>
                <td style="height: 17px">
                    <strong><span style="font-size: 10pt; color: #4169e1; font-family: Tahoma">Result</span></strong></td>
            </tr>
            <tr>
                <td style="height: 32px">
                    <span style="font-size: 10pt; color: #4169e1; font-family: Tahoma">Ball Discoloration</span></td>
                <td style="height: 32px">
                    <asp:TextBox ID="txtBallDiscoloration_Pass" runat="server" BackColor="#FFFF80" BorderColor="#8080FF"
                        BorderWidth="1px" Font-Names="Tahoma" Font-Size="Small" TabIndex="33" Width="80px" Visible="False"></asp:TextBox>
                    <asp:TextBox ID="txtBallDiscoloration_Sample" runat="server" BackColor="#FFFF80"
                        BorderColor="#8080FF" BorderWidth="1px" Font-Names="Tahoma" Font-Size="Small"
                        TabIndex="33" Width="80px"></asp:TextBox>
                    <br />
                    <asp:CompareValidator ID="CompareValidator4" runat="server" ControlToCompare="txtBallDiscoloration_Sample"
                        ControlToValidate="txtBallDiscoloration_Pass" ErrorMessage="Pass cannot bigger than  Sample Size"
                        Font-Bold="True" Font-Names="Tahoma" Font-Size="X-Small" Operator="LessThanEqual"
                        Type="Integer"></asp:CompareValidator></td>
                <td style="height: 32px">
                    <asp:TextBox ID="txtBallDiscoloration_Method" runat="server" BorderWidth="1px" CssClass="RptTextBox_NoEdit"
                        Font-Names="Tahoma" Font-Size="Small" ReadOnly="True" TabIndex="88"
                        Width="82px">Visual</asp:TextBox></td>
                <td style="height: 32px">
                    <asp:DropDownList ID="ddlBallDiscoloration_Result" runat="server" BackColor="#FFFF80"
                        TabIndex="35">
                        <asp:ListItem>Passed</asp:ListItem>
                        <asp:ListItem>Failed</asp:ListItem>
                    </asp:DropDownList></td>
            </tr>
            <tr>
                <td style="height: 42px">
                    <span style="font-size: 10pt; color: #4169e1; font-family: Tahoma">Ball Size</span></td>
                <td style="height: 42px">
                    <asp:TextBox ID="txtBallSize_Pass" runat="server" BackColor="#FFFF80" BorderColor="#8080FF"
                        BorderWidth="1px" Font-Names="Tahoma" Font-Size="Small" TabIndex="36" Width="80px" Visible="False"></asp:TextBox>
                    <asp:TextBox ID="txtBallSize_Sample" runat="server" BackColor="#FFFF80" BorderColor="#8080FF"
                        BorderWidth="1px" Font-Names="Tahoma" Font-Size="Small" TabIndex="36"
                        Width="80px"></asp:TextBox><br />
                    <asp:CompareValidator ID="CompareValidator5" runat="server"
                            ControlToValidate="txtBallSize_Pass" ErrorMessage="Pass must be integer type!."
                            Font-Bold="True" Font-Names="Tahoma" Font-Size="X-Small" Operator="DataTypeCheck"
                            Type="Integer"></asp:CompareValidator></td>
                <td style="height: 42px">
                   <FONT face="Tahoma" color="royalblue" size="2">  <asp:TextBox ID="txtBallSize_Method" runat="server" BorderWidth="1px" CssClass="RptTextBox_NoEdit"
                                Font-Names="Tahoma" Font-Size="Small" ReadOnly="True" TabIndex="88" Width="84px">Visual</asp:TextBox></FONT></td>
                <td style="height: 42px">
                    <asp:DropDownList ID="ddlBallSize_Result" runat="server" BackColor="#FFFF80" TabIndex="37">
                        <asp:ListItem>Passed</asp:ListItem>
                        <asp:ListItem>Failed</asp:ListItem>
                    </asp:DropDownList></td>
            </tr>
        </table>
        <div ms_positioning="FlowLayout" style="border-top-width: thin; display: inline;
            font-weight: bold; border-left-width: thin; font-size: 10px; border-left-color: gray;
            border-bottom-width: thin; border-bottom-color: gray; width: 928px; border-top-color: gray;
            font-family: Verdana; height: 24px; text-align: right; border-right-width: thin;
            border-right-color: gray">
            &nbsp;<asp:ValidationSummary ID="ValSum" runat="server" Font-Bold="True" Font-Names="Tahoma"
                Font-Size="X-Small" Height="32px" Width="367px" />
            <br />                
            <div align="right" style="width: 874px; height: 32px">
                <asp:Button ID="btnBackStep1" runat="server" BackColor="SteelBlue" BorderStyle="Solid"
                    BorderWidth="1px" Font-Names="Tahoma" Font-Size="Small" ForeColor="White" Height="30px"
                    Text="< Back" Visible="False" Width="100px" /><asp:Button ID="btnToStep3" runat="server"
                        BackColor="SteelBlue" BorderStyle="Solid" BorderWidth="1px" Font-Names="Tahoma"
                        Font-Size="Small" ForeColor="White" Height="30px" TabIndex="39" Text="Next >"
                        Width="100px" /><asp:Button ID="btnCancel" runat="server" BackColor="SteelBlue" BorderStyle="Solid"
                            BorderWidth="1px" Font-Names="Tahoma" Font-Size="Small" ForeColor="White" Height="30px"
                            TabIndex="40" Text="Cancel" Width="100px" /></div>
        </div>
    
    </form>
</body>
</html>
