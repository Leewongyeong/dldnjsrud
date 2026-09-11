<%@ Page Language="VB" AutoEventWireup="false" CodeFile="SBM_XParam.aspx.vb" Inherits="SBM_XParam" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML>
	<HEAD>
		<title>Solder Mount eLogsheet - X Parameters</title>
		<meta content="Microsoft Visual Studio .NET 7.1" name="GENERATOR">
		<meta content="Visual Basic .NET 7.1" name="CODE_LANGUAGE">
		<meta content="JavaScript" name="vs_defaultClientScript">
		<meta content="http://schemas.microsoft.com/intellisense/ie5" name="vs_targetSchema">
		<LINK href="Styles.css" type="text/css" rel="stylesheet">
		
		<script language="Javascript">
		
	
	function FNC_GET_NOW1()
    {
        var conname
        conname = document.forms[0]['_txt_Stime'];
        settime(conname)
    }
    
    function FNC_GET_NOW2()
    {
        var conname
        conname = document.forms[0]['_txt_Etime'];
        settime(conname)
    }    
		
    function FNC_GET_NOW3()
    {
        var conname
        conname = document.forms[0]['txtSTART_TIME'];
        settime(conname)
    }
    
    function FNC_GET_NOW4()
    {
        var conname
        conname = document.forms[0]['txtEND_TIME'];
        settime(conname)
    }

    function settime(val){
        d = new Date();
        var year=d.getFullYear()+"";

        var mon=d.getMonth();
        mon =make2Digit(mon);
        
        var day=d.getDate();
        day =make2Digit(day);

        var hour=d.getHours();
        hour =make2Digit(hour);

        var minute=d.getMinutes();
        minute =make2Digit(minute);

        var second=d.getSeconds();
        second =make2Digit(second);

        val.value=year+"-"+mon+"-"+day+" "+hour+":"+minute+":"+second;

    }
   
function make2Digit(val){
        if(val<10)
        return "0"+val;
        else
        return val;
    }

am = "This function is disabled!";

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
		<link href="Styles.css" rel="stylesheet" type="text/css">
	    <style type="text/css">
            .auto-style1 {
                width: 212px;
                height: 23px;
            }
            .auto-style2 {
                width: 236px;
                height: 23px;
            }
            .auto-style3 {
                width: 195px;
                height: 23px;
            }
            .auto-style4 {
                height: 23px;
            }
            .auto-style5 {
                width: 195px;
                height: 21px;
            }
            .auto-style6 {
                height: 21px;
            }
        </style>
	</HEAD>
	<body>
		<form id="Form1" method="post" runat="server">
				<DIV style="BORDER-RIGHT: gray thin solid; BORDER-TOP: gray thin solid; DISPLAY: inline; FONT-WEIGHT: bold; FONT-SIZE: 10px; BORDER-LEFT: gray thin solid; WIDTH: 100%; BORDER-BOTTOM: gray thin solid; FONT-FAMILY: Verdana; HEIGHT: 32px; BACKGROUND-COLOR: gainsboro; TEXT-ALIGN: left">
					<P><BR>
						Please enter the&nbsp;X Parameters</P>
				</DIV>
				<BR>
				<br>
				<TABLE id="Table1" style="WIDTH: 875px; HEIGHT: 352px" cellSpacing="1" cellPadding="1" width="875" border="0">
					<TR>
						<TD colSpan="4" style="HEIGHT: 19px"><FONT face="Tahoma" color="mediumblue" size="2"><STRONG>Lot 
									Information</STRONG></FONT></TD>
					</TR>
					<TR>
						<TD style="width: 212px"></TD>
						<TD style="WIDTH: 236px"></TD>
						<TD style="WIDTH: 195px"></TD>
						<TD></TD>
					</TR>
					<TR>
						<TD style="width: 212px"><FONT face="Tahoma" color="royalblue" size="2">Buy-off Reason</FONT></TD>
						<TD style="WIDTH: 236px"><asp:textbox id="txtBOReason" runat="server" BorderColor="#8080FF" BorderWidth="1px" Font-Size="X-Small" Font-Names="Tahoma" Width="232px" CssClass="RptTextBox_NoEdit" ReadOnly="True"></asp:textbox></TD>
						<TD style="WIDTH: 195px"><FONT face="Tahoma" color="royalblue" size="2">Package Type</FONT></TD>
						<TD><asp:textbox id="txtPkg" runat="server" BorderColor="#8080FF" BorderWidth="1px"
								Font-Size="X-Small" Font-Names="Tahoma" Width="232px" tabIndex="1" CssClass="RptTextBox_NoEdit" ReadOnly="True"></asp:textbox></TD>
					</TR>
					<TR>
						<TD style="height: 24px; width: 212px;"><FONT face="Tahoma" color="royalblue" size="2">Lot ID</FONT></TD>
						<TD style="WIDTH: 236px; height: 24px;"><asp:textbox id="txtLotID" runat="server" BorderColor="#8080FF" BorderWidth="1px" Font-Size="X-Small" Font-Names="Tahoma" Width="232px" tabIndex="2" CssClass="RptTextBox_NoEdit" ReadOnly="True"></asp:textbox></TD>
						<TD style="WIDTH: 195px; height: 24px;"><FONT face="Tahoma" color="royalblue" size="2"><FONT face="Tahoma" color="royalblue" size="2"><FONT face="Tahoma" color="#4169e1" size="2">Equipment 
										ID</FONT></FONT></FONT></TD>
						<TD style="height: 24px"><asp:textbox id="txtEquipID" runat="server" BorderColor="#8080FF" BorderWidth="1px"
								Font-Size="X-Small" Font-Names="Tahoma" Width="232px" tabIndex="3" CssClass="RptTextBox_NoEdit" ReadOnly="True"></asp:textbox></TD>
					</TR>
					<TR>
						<TD style="WIDTH: 212px;"><FONT face="Tahoma" color="#4169e1" size="2"><FONT face="Tahoma" color="royalblue" size="2"><FONT face="Tahoma" color="royalblue" size="2"><FONT face="Tahoma" color="royalblue" size="2"><FONT face="Tahoma" color="royalblue" size="2">Customer</FONT></FONT></FONT></FONT></FONT></TD>
						<TD style="WIDTH: 236px;">
							<asp:textbox id="txtCustomer" runat="server" Width="232px" Font-Names="Tahoma" Font-Size="X-Small" BorderWidth="1px" BorderColor="#8080FF" tabIndex="4" CssClass="RptTextBox_NoEdit" ReadOnly="True"></asp:textbox></TD>
						<TD style="WIDTH: 195px;"><FONT face="Tahoma" color="royalblue" size="2"><FONT face="Tahoma" color="royalblue" size="2"><FONT face="Tahoma" color="royalblue" size="2"><FONT face="Tahoma" color="#4169e1" size="2"><FONT face="Tahoma" color="royalblue" size="2">Customer 
												Device</FONT></FONT></FONT></FONT></FONT></TD>
						<TD><asp:textbox id="txtDevice" runat="server" BorderColor="#8080FF" BorderWidth="1px"
								Font-Size="X-Small" Font-Names="Tahoma" Width="232px" tabIndex="5" CssClass="RptTextBox_NoEdit" ReadOnly="True"></asp:textbox></TD>
					</TR>
                    <tr>
                        <td style="width: 212px">
                            <asp:TextBox ID="CUST_ID" runat="server" BorderColor="#8080FF" BorderWidth="1px"
                                CssClass="RptTextBox_NoEdit" Font-Names="Tahoma" Font-Size="X-Small" ReadOnly="True"
                                TabIndex="4" Visible="False" Width="56px"></asp:TextBox>
                            <asp:TextBox ID="PKG_ID" runat="server" BorderColor="#8080FF" BorderWidth="1px" CssClass="RptTextBox_NoEdit"
                                Font-Names="Tahoma" Font-Size="X-Small" ReadOnly="True" TabIndex="4" Visible="False"
                                Width="56px"></asp:TextBox></td>
                        <td style="width: 236px">
                            <asp:TextBox ID="CUST_DEVICE" runat="server" BorderColor="#8080FF" BorderWidth="1px"
                                CssClass="RptTextBox_NoEdit" Font-Names="Tahoma" Font-Size="X-Small" ReadOnly="True"
                                TabIndex="4" Visible="False" Width="56px"></asp:TextBox></td>
                        <td style="width: 195px">
                            <span style="font-size: 10pt; color: #4169e1; font-family: Tahoma">Mes Qty</span></td>
                        <td>
                            <asp:TextBox ID="CUR_DIE_QTY" runat="server" BorderColor="#8080FF" BorderWidth="1px"
                                CssClass="RptTextBox_NoEdit" Font-Names="Tahoma" Font-Size="X-Small" ReadOnly="True"
                                TabIndex="4" Width="232px"></asp:TextBox></td>
                    </tr>
                    <tr>
                        <td style="width: 212px; height: 21px;">
                        </td>
                        <td style="width: 236px; height: 21px;">
                        </td>
                        <td style="width: 195px; height: 21px;">
                        </td>
                        <td style="height: 21px">
                        </td>
                    </tr>
                    <tr>
                        <td style="width: 212px; height: 20px">
                            <strong><span style="font-size: 10pt; color: #ff0000; font-family: Tahoma">Visual Inspection</span></strong></td>
                        <td style="width: 236px; height: 20px">
                        </td>
                        <td style="width: 195px; height: 20px">
                        </td>
                        <td style="height: 20px">
                        </td>
                    </tr>
                    <tr>
                        <td style="width: 212px; height: 20px">
                            <span style="font-size: 10pt; color: #4169e1; font-family: Tahoma">Work Area Check<br />
                                (Clean, Shine, Sort)</span></td>
                        <td style="width: 236px; height: 20px">
                            <asp:DropDownList ID="ddlWorkAreaCheck" runat="server" Font-Names="Arial" Width="140px" CssClass="RptTextBox">
                                <asp:ListItem>Passed</asp:ListItem>
                                <asp:ListItem>Failed</asp:ListItem>
                            </asp:DropDownList></td>
                        <td style="width: 195px; height: 20px">
                            <span style="font-size: 10pt; color: #4169e1; font-family: Tahoma">Lot Check<br />
                                (T-Card, Qty, Container)</span></td>
                        <td style="height: 20px">
                            <asp:DropDownList ID="ddlLotCheck" runat="server" Font-Names="Arial" Width="140px" CssClass="RptTextBox">
                                <asp:ListItem>Passed</asp:ListItem>
                                <asp:ListItem>Failed</asp:ListItem>
                            </asp:DropDownList></td>
                    </tr>
                    <tr>
                        <td style="width: 212px">
                            <span style="font-size: 10pt; color: #4169e1; font-family: Tahoma">M/C Check<br />
                                (PKG Type, Conversion)</span></td>
                        <td style="width: 236px">
                            <asp:DropDownList ID="ddlMCCheck" runat="server" Font-Names="Arial" Width="140px" CssClass="RptTextBox">
                                <asp:ListItem>Passed</asp:ListItem>
                                <asp:ListItem>Failed</asp:ListItem>
                            </asp:DropDownList></td>
                        <td style="width: 195px">
                            <span style="font-size: 10pt; color: #4169e1; font-family: Tahoma">Safety Check(Safety
                                Door)</span></td>
                        <td>
                            <asp:DropDownList ID="ddlSafetyCheck" runat="server" Font-Names="Arial" Width="140px" CssClass="RptTextBox">
                                <asp:ListItem>Passed</asp:ListItem>
                                <asp:ListItem>Failed</asp:ListItem>
                            </asp:DropDownList></td>

                    <tr>
                        <td class="auto-style1">
                            <span style="font-size: 10pt; color: #4169e1; font-family: Tahoma">Station Block Cleaning</span></td>
                        <td class="auto-style2">
                            <asp:DropDownList ID="ddlStationBlockClean" runat="server" Font-Names="Arial" Width="140px" CssClass="RptTextBox">
                                <asp:ListItem>Passed</asp:ListItem>
                                <asp:ListItem>Failed</asp:ListItem>
                            </asp:DropDownList></td>

                           <td class="auto-style3">
                               &nbsp;</td>
                        <td class="auto-style4">
                            &nbsp;</td>
                    </tr>
                        <td class="auto-style5">
                        </td>
                        <td class="auto-style6">
                            </td>
                        <td class="auto-style5">
                        </td>
                        <td class="auto-style6">
                            &nbsp;</td>
                    </tr>
                    <tr>
                        <td style="width: 212px; height: 22px">
                        </td>
                        <td style="width: 236px; height: 22px">
                        </td>
                        <td style="width: 195px; height: 22px">
                        </td>
                        <td style="height: 22px">
                        </td>
                    </tr>
                    <tr>
                        <td style="width: 212px">
                            <strong><span style="font-size: 10pt; color: red; font-family: Tahoma">SBM eLogsheet</span></strong></td>
                        <td style="width: 236px">
                        </td>
                        <td style="width: 195px">
                        </td>
                        <td>
                        </td>
                    </tr>
					<TR>
						<TD colSpan="4" style="HEIGHT: 19px">&nbsp;
							<asp:Label id="lblelogsheetExist" runat="server" Enabled="False" Visible="False">Label</asp:Label></TD>
					</TR>
					<TR>
						<TD colSpan="4" style="HEIGHT: 19px"><FONT face="Tahoma" color="mediumblue" size="2"><STRONG>X 
									Parameters</STRONG></FONT></TD>
					</TR>
				
					<TR>
						<!--TD>
                            <span style="font-size: 10pt; color: #4169e1; font-family: Tahoma">Dotting 
									Time</span></TD>
						<TD>
							<asp:textbox id="txtDottingTime" tabIndex="21" runat="server" Width="232px" Font-Names="Tahoma"
								Font-Size="X-Small" BorderWidth="1px" BorderColor="#8080FF" CssClass="RptTextBox"></asp:textbox>
                            <asp:CustomValidator ID="CustomValidator1" runat="server" ControlToValidate="txtDottingTime"
                                ErrorMessage="CustomValidator" Font-Bold="True" Font-Names="Tahoma" Font-Size="XX-Small"></asp:CustomValidator></TD>
						<TD>
                            <span style="font-size: 10pt; color: #4169e1; font-family: Tahoma">Y,Z-Axis Flux Dotting Position</span></TD>
						<TD>
							<asp:textbox id="txtFluxPosition" runat="server" Width="232px" Font-Names="Tahoma" Font-Size="X-Small" BorderWidth="1px" BorderColor="#8080FF" tabIndex="22" CssClass="RptTextBox"></asp:textbox>
                            <asp:CustomValidator ID="CustomValidator3" runat="server" ControlToValidate="txtFluxPosition"
                                ErrorMessage="CustomValidator" Font-Bold="True" Font-Names="Tahoma" Font-Size="XX-Small"></asp:CustomValidator></TD-->
                        <TD style="width: 212px;">
                            <span style="font-size: 10pt; color: #4169e1; font-family: Tahoma">Flux Plate depth</span></TD>						
                        <TD style="width: 236px;"><asp:DropDownList ID="ddlFluxPlateDepth" runat="server" BackColor="#FFFF80" TabIndex="24" Width="70px">
                            <asp:ListItem>0.10</asp:ListItem>
                            <asp:ListItem>0.12</asp:ListItem>
                            <asp:ListItem>0.15</asp:ListItem>
                            <asp:ListItem>0.18</asp:ListItem>
                            <asp:ListItem>0.20</asp:ListItem>
                            <asp:ListItem>0.23</asp:ListItem>
                        </asp:DropDownList></TD>
                                <td>
                                    <span style="font-size: 10pt; color: #4169e1; font-family: Tahoma">Flux dipping time</span></td>
                                <td>
                            <asp:TextBox ID="txtFluxDippingTime" runat="server" BorderWidth="1px" CssClass="RptTextBox"
                                Font-Names="Tahoma" Font-Size="X-Small" TabIndex="25" Width="232px"></asp:TextBox></td>
					</TR>
					
					<!--TR>
						<TD>
                            <span style="font-size: 10pt; color: #4169e1; font-family: Tahoma">Y,Z-Axis Solder Ball Attach Position</span></TD>
						<TD>
							<asp:textbox id="txtBallAttachPosition" tabIndex="23" runat="server" Width="232px" Font-Names="Tahoma"
								Font-Size="X-Small" BorderWidth="1px" BorderColor="#8080FF" CssClass="RptTextBox"></asp:textbox>
                            <asp:CustomValidator ID="CustomValidator2" runat="server" ControlToValidate="txtBallAttachPosition"
                                ErrorMessage="CustomValidator" Font-Bold="True" Font-Names="Tahoma" Font-Size="XX-Small"></asp:CustomValidator></TD>
						<TD></TD>
						<TD>
							</TD>
					</TR-->
                    <tr>
                        <td style="width: 212px;">
                            <span style="font-size: 10pt; color: #4169e1; font-family: Tahoma">Flux dotting type</span></td>
                        <td style="width: 236px;">
                            <asp:TextBox ID="txtFluxDottingType" runat="server" BorderWidth="1px" CssClass="RptTextBox"
                                Font-Names="Tahoma" Font-Size="X-Small" TabIndex="25" Width="232px"></asp:TextBox></td>
                        <td>
                            <span style="font-size: 10pt; color: #4169e1; font-family: Tahoma">Tool Step(1step,2step)</span></td>
                        <td>
                            <asp:TextBox ID="txtToolStep" runat="server" BorderWidth="1px" CssClass="RptTextBox"
                                Font-Names="Tahoma" Font-Size="X-Small" TabIndex="25" Width="232px"></asp:TextBox></td>
                    </tr>
                    <tr>
                        <td style="width: 212px; height: 24px;">
                            <span style="font-size: 10pt; color: #4169e1; font-family: Tahoma">Flux dotting time</span></td>
                        <td style="width: 236px; height: 24px;">
                            <asp:TextBox ID="txtFluxDottingTime" runat="server" BorderWidth="1px" CssClass="RptTextBox"
                                Font-Names="Tahoma" Font-Size="X-Small" TabIndex="25" Width="232px"></asp:TextBox></td>
                        <td style="height: 24px">
                        </td>
                        <td style="height: 24px">
                        </td>
                    </tr>
					<tr>
					    <td colspan=4 style="height: 20px">&nbsp;</td>
					</tr>
					<TR>
						<TD colSpan="4" style="HEIGHT: 19px"><FONT face="Tahoma" color="mediumblue" size="2"><STRONG>Reflow Oven</STRONG></FONT></TD>
					</TR>
					<TR>
						<TD colspan=4><FONT face="Tahoma" color="mediumblue" size="2"><STRONG>
                            <asp:DropDownList ID="ddlSOPType" runat="server" BackColor="#FFFF80" TabIndex="24">
                                <asp:ListItem Value="Lead free ball">Lead free ball</asp:ListItem>
                                <asp:ListItem>Normal ball</asp:ListItem>
                                <asp:ListItem>Eutectic ball</asp:ListItem>
                            </asp:DropDownList></STRONG></FONT></TD>
						
						
					</TR>
                    <tr>
                        <td style="width: 212px">
                            <FONT face="Tahoma" color="royalblue" size="2">
                            <asp:Label ID="lblPeakTemp" runat="server" Text="Peak Temp"></asp:Label>
                                <asp:Label ID="lblPTRange" runat="server" Font-Names="Tahoma" Font-Size="X-Small"
                                    ForeColor="Red"></asp:Label></FONT></td>
                        <td colspan="3" style="width: 350px;">
                            <asp:TextBox ID="txtPeakTemp" runat="server" BorderWidth="1px" CssClass="RptTextBox"
                                Font-Names="Tahoma" Font-Size="X-Small" TabIndex="25" Width="232px"></asp:TextBox>
                            <asp:CustomValidator ID="cvPeakTemp" runat="server" ControlToValidate="txtPeakTemp"
                                Font-Bold="True" Font-Names="Tahoma" Font-Size="XX-Small" SetFocusOnError="True"
                                ValidateEmptyText="True"></asp:CustomValidator>
                            &nbsp;</td>
                    </tr>
                    <tr>
                        <td style="width: 212px">
                            <asp:Label ID="Label1" runat="server" Font-Names="Tahoma" Font-Size="X-Small" ForeColor="SteelBlue"
                                Text="O2 PPM"></asp:Label></td>
                        <td colspan="3" style="width: 350px">
                            <asp:TextBox ID="txtAutoPPM" runat="server" BorderWidth="1px" CssClass="RptTextBox"
                                Font-Names="Tahoma" Font-Size="X-Small" TabIndex="25" Width="232px"></asp:TextBox></td>
                    </tr>
					<TR>
						<TD style="width: 212px"><FONT face="Tahoma" color="royalblue" size="2">
                            <asp:Label ID="lblDwell" runat="server" Text="Dwell time"></asp:Label></FONT></TD>
						<TD style="WIDTH: 350px;" colspan=3><asp:textbox id="txtDwellTime_Eutectic" runat="server" BorderWidth="1px"
									Font-Size="X-Small" Font-Names="Tahoma" Width="232px" tabIndex="25" CssClass="RptTextBox"></asp:textbox><asp:CustomValidator ID="CustomValidator5" runat="server" ControlToValidate="txtDwellTime_Eutectic"
                                Font-Bold="True" Font-Names="Tahoma" Font-Size="XX-Small" SetFocusOnError="True"
                                ValidateEmptyText="True"></asp:CustomValidator></TD>
						
					</TR>
					<TR>
						<TD style="width: 212px"><FONT face="Tahoma" color="royalblue" size="2">
                            <asp:Label ID="lblSoak" runat="server" Text="Soak time"></asp:Label></FONT></TD>
						<TD colspan=3>
							<asp:textbox id="txtSoakTime_Eutectic" runat="server" Width="232px" Font-Names="Tahoma" Font-Size="X-Small" BorderWidth="1px" tabIndex="26" CssClass="RptTextBox"></asp:textbox><asp:CustomValidator ID="CustomValidator7" runat="server" ControlToValidate="txtSoakTime_Eutectic"
                                Font-Bold="True" Font-Names="Tahoma" Font-Size="XX-Small" SetFocusOnError="True"
                                ValidateEmptyText="True"></asp:CustomValidator></TD>
						
					</TR>
					<TR>
						<TD style="width: 212px"><FONT face="Tahoma" color="royalblue" size="2">
                            <asp:Label ID="lblCRateEutectic" runat="server" Text="Cooling rate (222 ~ 212℃) "></asp:Label></FONT></TD>
						<TD colspan=3>
							<asp:textbox id="txtCoolingRatePeak_Eutectic" runat="server" Width="232px" Font-Names="Tahoma" Font-Size="X-Small" BorderWidth="1px" tabIndex="27" CssClass="RptTextBox"></asp:textbox><asp:CustomValidator ID="CustomValidator9" runat="server" ControlToValidate="txtCoolingRatePeak_Eutectic"
                                Font-Bold="True" Font-Names="Tahoma" Font-Size="XX-Small" SetFocusOnError="True" Visible="False"></asp:CustomValidator></TD>
						
					</TR>
					<TR>
						<TD style="width: 212px"><FONT face="Tahoma" color="royalblue" size="2">
                            <asp:Label ID="lblCRateExitEutectic" runat="server" Text="Cooling rate (Peak ~ Exit) "></asp:Label></FONT></TD>
						<TD colspan=3>
							<asp:textbox id="txtCoolingRateExit_Eutectic" runat="server" Width="232px" Font-Names="Tahoma" Font-Size="X-Small" BorderWidth="1px" tabIndex="29" CssClass="RptTextBox"></asp:textbox><asp:CustomValidator ID="CustomValidator13" runat="server" ControlToValidate="txtCoolingRateExit_Eutectic"
                                Font-Bold="True" Font-Names="Tahoma" Font-Size="XX-Small" SetFocusOnError="True" Visible="False"></asp:CustomValidator></TD>
						
					</TR>
                    <tr>
                        <td style="width: 212px">
                            <span style="font-size: 10pt; color: #4169e1; font-family: Tahoma">Belt speed</span></td>
                        <td colspan="3">
                            <asp:TextBox ID="txtBeltSpeed" runat="server" BorderWidth="1px" CssClass="RptTextBox"
                                Font-Names="Tahoma" Font-Size="X-Small" TabIndex="28" Width="232px"></asp:TextBox></td>
                    </tr>
                    <tr>
                        <td style="width: 212px">
                            <span style="font-size: 10pt; color: #4169e1; font-family: Tahoma">Reflow MC Model</span></td>
                        <td colspan="3">
                            <asp:DropDownList ID="ddlReflowModel" runat="server" BackColor="#FFFF80" TabIndex="24" Width="112px">
                                <asp:ListItem>Heller</asp:ListItem>
                                <asp:ListItem>Vitronics</asp:ListItem>
                            </asp:DropDownList></td>
                    </tr>
                    <tr>
                        <td style="width: 212px">
                            <span style="font-size: 10pt; color: #4169e1; font-family: Tahoma">Reflow MC</span></td>
                        <td colspan="3">
                            <asp:TextBox ID="txtReflowMC" runat="server" BorderWidth="1px" CssClass="RptTextBox"
                                Font-Names="Tahoma" Font-Size="X-Small" TabIndex="28" Width="232px"></asp:TextBox></td>
                    </tr>
                    <tr>
                        <td style="width: 212px; height: 24px">
                            <span style="font-size: 10pt; color: #4169e1; font-family: Tahoma">X-Ray Inspection(ss:2Strip)</span></td>
                        <td style="height: 24px">
                            <asp:TextBox ID="txtXrayInspection" runat="server" BorderWidth="1px" CssClass="RptTextBox"
                                Font-Names="Tahoma" Font-Size="X-Small" TabIndex="28" Width="232px"></asp:TextBox></td>
                        <td style="width: 190px; height: 20px;">
                            <span style="font-size: 10pt; color: #4169e1; font-family: Tahoma">Remark</span></td>
                        <td style="height: 20px;">
                            <asp:TextBox ID="txtRemark" runat="server" Font-Names="Arial" Font-Size="10pt"
                                Width="232px" CssClass="RptTextBox"></asp:TextBox></td>
                    </tr>
                    <tr>
                        <td colspan="4" style="height: 24px">
                            <asp:Panel ID="pnAPL" runat="server">
                                <TABLE id="Table4" style="WIDTH: 875px" cellSpacing="1" cellPadding="1" width="875" border="0">
                                    <tr>
                                        <TD colSpan="4" style="HEIGHT: 19px">
                                            <FONT face="Tahoma" color="mediumblue" size="2"><STRONG>Quality Check(Visual)</strong></font></td>
                                    </tr>
                                    <tr>
                                        <TD style="width: 205px;">
                                            <span style="font-size: 10pt; color: #4169e1; font-family: Tahoma">Item</span></td>
                                        <TD style="width: 236px;">
                                            <span style="font-size: 10pt; color: #4169e1; font-family: Tahoma">S/S(Strip)</span></td>
                                        <td style="width: 212px;">
                                            <span style="font-size: 10pt; color: #4169e1; font-family: Tahoma">Results</span></td>
                                        <td>
                                            </td>
                                    </tr>
                                    <tr>
                                        <td style="width: 205px;">
                                            <span style="font-size: 10pt; color: #4169e1; font-family: Tahoma">Missing Ball</span></td>
                                        <td style="width: 236px;">
                                            <asp:TextBox ID="txtMissingBallStrip" runat="server" BorderWidth="1px" CssClass="RptTextBox"
                                                Font-Names="Tahoma" Font-Size="X-Small" TabIndex="25" Width="232px">1</asp:TextBox></td>
                                        <td style="width: 212px;">
                                            <span style="font-size: 10pt; color: #4169e1; font-family: Tahoma"><asp:DropDownList ID="txtMissingBallResult" runat="server" Font-Names="Arial" Width="140px" CssClass="RptTextBox">
                                                <asp:ListItem>Passed</asp:ListItem>
                                                <asp:ListItem>Failed</asp:ListItem>
                                            </asp:DropDownList></span></td>
                                        <td>
                                            </td>
                                    </tr>
                                    <tr>
                                        <td style="width: 205px;">
                                            <span style="font-size: 10pt; color: #4169e1; font-family: Tahoma">Double Ball</span></td>
                                        <td style="width: 236px;">
                                            <asp:TextBox ID="txtDoubleBallStrip" runat="server" BorderWidth="1px" CssClass="RptTextBox"
                                                Font-Names="Tahoma" Font-Size="X-Small" TabIndex="25" Width="232px">1</asp:TextBox></td>
                                        <td style="width: 212px;"><asp:DropDownList ID="txtDoubleBallResult" runat="server" Font-Names="Arial" Width="140px" CssClass="RptTextBox">
                                            <asp:ListItem>Passed</asp:ListItem>
                                            <asp:ListItem>Failed</asp:ListItem>
                                        </asp:DropDownList></td>
                                        <td>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="width: 205px">
                                            <span style="font-size: 10pt; color: #4169e1; font-family: Tahoma">None Wet</span></td>
                                        <td style="width: 236px">
                                            <asp:TextBox ID="txtNoneWetStrip" runat="server" BorderWidth="1px" CssClass="RptTextBox"
                                                Font-Names="Tahoma" Font-Size="X-Small" TabIndex="25" Width="232px">1</asp:TextBox></td>
                                        <td style="width: 212px">
                                            <asp:DropDownList ID="txtNoneWetResult" runat="server" Font-Names="Arial" Width="140px" CssClass="RptTextBox">
                                                <asp:ListItem>Passed</asp:ListItem>
                                                <asp:ListItem>Failed</asp:ListItem>
                                            </asp:DropDownList></td>
                                        <td>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="width: 205px">
                                            <span style="font-size: 10pt; color: #4169e1; font-family: Tahoma">Flux Residue</span></td>
                                        <td style="width: 236px">
                                            <asp:TextBox ID="txtFluxResidueStrip" runat="server" BorderWidth="1px" CssClass="RptTextBox"
                                                Font-Names="Tahoma" Font-Size="X-Small" TabIndex="25" Width="232px">1</asp:TextBox></td>
                                        <td style="width: 212px">
                                            <asp:DropDownList ID="txtFluxResidueResult" runat="server" Font-Names="Arial" Width="140px" CssClass="RptTextBox">
                                                <asp:ListItem>Passed</asp:ListItem>
                                                <asp:ListItem>Failed</asp:ListItem>
                                            </asp:DropDownList></td>
                                        <td>
                                        </td>
                                    </tr>
                                </table>
                            </asp:Panel>
                        </td>
                    </tr>
                </table>
            <br />
            <asp:Panel ID="FlipperPanel" runat="server" Width="872px">
                <TABLE id="Table3" style="WIDTH: 875px; HEIGHT: 352px" cellSpacing="1" cellPadding="1" width="875" border="0">
                    <tr>
                        <td style="width: 190px; height: 20px;">
                            <strong><span style="font-size: 10pt; color: red; font-family: Tahoma">Flipper eLogsheet</span></strong></td>
                        <td style="width: 236px; height: 20px;">
                        </td>
                        <td style="width: 195px; height: 20px;">
                        </td>
                        <td style="height: 20px">
                        </td>
                    </tr>
                    <tr>
                        <td style="width: 190px">
                            <span style="font-size: 10pt; color: #4169e1; font-family: Tahoma">Job File</span></td>
                        <td colspan="3">
                            <asp:TextBox ID="TXT_JOB" runat="server" Font-Names="Arial" Font-Size="10pt" Width="680px" CssClass="RptTextBox"></asp:TextBox></td>
                    </tr>
                    <tr>
                        <td style="width: 190px">
                        </td>
                        <td style="width: 236px">
                            <span style="font-size: 10pt; color: #4169e1; font-family: Tahoma">Sample Size</span></td>
                        <td style="width: 195px">
                            <span style="font-size: 10pt; color: #4169e1; font-family: Tahoma">Defect</span></td>
                        <td>
                            <span style="font-size: 10pt; color: #4169e1; font-family: Tahoma">Result</span></td>
                    </tr>
                    <tr>
                        <td style="width: 190px; height: 20px;">
                            <span style="font-size: 10pt; color: #4169e1; font-family: Tahoma">PCB Chip</span></td>
                        <td style="width: 236px; height: 20px;">
                            <asp:TextBox ID="TXT_D1_SS" runat="server" Font-Names="Arial" Font-Size="10pt" Width="232px" CssClass="RptTextBox"></asp:TextBox></td>
                        <td style="width: 195px; height: 20px;">
                            <asp:TextBox ID="TXT_D1" runat="server" Font-Names="Arial" Font-Size="10pt" Width="194px" CssClass="RptTextBox"></asp:TextBox></td>
                        <td style="height: 20px">
                            <asp:DropDownList ID="DropDown_D1_RT" runat="server" Font-Names="Arial" Width="140px" CssClass="RptTextBox">
                                <asp:ListItem>Passed</asp:ListItem>
                                <asp:ListItem>Failed</asp:ListItem>
                            </asp:DropDownList></td>
                    </tr>
                    <tr>
                        <td style="width: 190px; height: 20px">
                            <span style="font-size: 10pt; color: #4169e1; font-family: Tahoma">Die Crack</span></td>
                        <td style="width: 236px; height: 20px">
                            <asp:TextBox ID="TXT_D2_SS" runat="server" Font-Names="Arial" Font-Size="10pt" Width="232px" CssClass="RptTextBox"></asp:TextBox></td>
                        <td style="width: 195px; height: 20px">
                            <asp:TextBox ID="TXT_D2" runat="server" Font-Names="Arial" Font-Size="10pt" Width="194px" CssClass="RptTextBox"></asp:TextBox></td>
                        <td style="height: 20px">
                            <asp:DropDownList ID="DropDown_D2_RT" runat="server" Font-Names="Arial" Width="140px" CssClass="RptTextBox">
                                <asp:ListItem>Passed</asp:ListItem>
                                <asp:ListItem>Failed</asp:ListItem>
                            </asp:DropDownList></td>
                    </tr>
                    <tr>
                        <td style="width: 190px">
                            <span style="font-size: 10pt; color: #4169e1; font-family: Tahoma">Solder Ball Damage</span></td>
                        <td style="width: 236px">
                            <asp:TextBox ID="TXT_D3_SS" runat="server" Font-Names="Arial" Font-Size="10pt" Width="232px" CssClass="RptTextBox"></asp:TextBox></td>
                        <td style="width: 195px">
                            <asp:TextBox ID="TXT_D3" runat="server" Font-Names="Arial" Font-Size="10pt" Width="194px" CssClass="RptTextBox"></asp:TextBox></td>
                        <td>
                            <asp:DropDownList ID="DropDown_D3_RT" runat="server" Font-Names="Arial" Width="140px" CssClass="RptTextBox">
                                <asp:ListItem>Passed</asp:ListItem>
                                <asp:ListItem>Failed</asp:ListItem>
                            </asp:DropDownList></td>
                    </tr>
                    <tr>
                        <td style="width: 190px; height: 24px;">
                            <span style="font-size: 10pt; color: #4169e1; font-family: Tahoma">Die Chip</span></td>
                        <td style="width: 236px; height: 24px;">
                            <asp:TextBox ID="TXT_D4_SS" runat="server" Font-Names="Arial" Font-Size="10pt" Width="232px" CssClass="RptTextBox"></asp:TextBox></td>
                        <td style="width: 195px; height: 24px;">
                            <asp:TextBox ID="TXT_D4" runat="server" Font-Names="Arial" Font-Size="10pt" Width="194px" CssClass="RptTextBox"></asp:TextBox></td>
                        <td style="height: 24px">
                            <asp:DropDownList ID="DropDown_D4_RT" runat="server" Font-Names="Arial" Width="140px" CssClass="RptTextBox">
                                <asp:ListItem>Passed</asp:ListItem>
                                <asp:ListItem>Failed</asp:ListItem>
                            </asp:DropDownList></td>
                    </tr>
                    <tr>
                        <td style="width: 190px">
                        </td>
                        <td style="width: 236px">
                            <span style="font-size: 10pt; color: #4169e1; font-family: Tahoma">Boat matrix</span></td>
                        <td style="width: 195px">
                            <span style="font-size: 10pt; color: #4169e1; font-family: Tahoma">Body size</span></td>
                        <td>
                        </td>
                    </tr>
                    <tr>
                        <td style="width: 190px; height: 20px;">
                            <span style="font-size: 10pt; color: #4169e1; font-family: Tahoma">Machine parameter</span></td>
                        <td style="width: 236px; height: 20px;">
                            <asp:TextBox ID="TXT_BOAT_MT" runat="server" Font-Names="Arial" Font-Size="10pt"
                                Width="232px" CssClass="RptTextBox"></asp:TextBox></td>
                        <td style="width: 195px; height: 20px;">
                            <asp:TextBox ID="TXT_BODY_SIZE" runat="server" Font-Names="Arial" Font-Size="10pt"
                                Width="194px" CssClass="RptTextBox"></asp:TextBox></td>
                        <td style="height: 20px">
                        </td>
                    </tr>
                    <tr>
                        <td style="width: 190px; height: 20px">
                        </td>
                        <td style="width: 236px; height: 20px">
                        </td>
                        <td style="width: 195px; height: 20px">
                        </td>
                        <td style="height: 20px">
                        </td>
                    </tr>
                    <tr>
                        <td style="width: 190px">
                            <span style="font-size: 10pt; color: #4169e1; font-family: Tahoma">Start Time</span></td>
                        <td style="width: 236px">
                            <asp:TextBox ID="_txt_Stime" runat="server" Font-Names="Arial" Font-Size="10pt" ondblclick="FNC_GET_NOW1()"
                                Width="232px" CssClass="RptTextBox"></asp:TextBox></td>
                        <td style="width: 195px">
                            <span style="font-size: 10pt; color: #4169e1; font-family: Tahoma">End Time</span></td>
                        <td>
                            <asp:TextBox ID="_txt_Etime" runat="server" Font-Names="Arial" Font-Size="10pt" ondblclick="FNC_GET_NOW2()"
                                Width="232px" CssClass="RptTextBox"></asp:TextBox></td>
                    </tr>
                    <tr>
                        <td style="width: 190px; height: 20px;">
                            <span style="font-size: 10pt; color: #4169e1; font-family: Tahoma">Remark</span></td>
                        <td style="height: 20px;" colspan="3">
                            <asp:TextBox ID="_txt_Remark" runat="server" Font-Names="Arial" Font-Size="10pt"
                                Width="680px" CssClass="RptTextBox"></asp:TextBox></td>
                    </tr>
                    <tr>
                        <td style="width: 190px">
                        </td>
                        <td style="width: 236px">
                        </td>
                        <td style="width: 195px">
                        </td>
                        <td>
                        </td>
                    </tr>
                </table>
            </asp:Panel>
            <br />
            <asp:Panel ID="CTLPanel" runat="server" Width="872px">
                <TABLE id="Table2" style="WIDTH: 875px; HEIGHT: 352px" cellSpacing="1" cellPadding="1" width="875" border="0">
                    <tr>
                        <td style="height: 24px; width: 185px;">
                            <span style="font-size: 10pt; color: #0000cd; font-family: Tahoma"><strong style="color: red">
                                CTL eLogsheet</strong></span></td>
                        <td style="height: 24px; width: 236px;">
                        </td>
                        <td style="height: 24px">
                        </td>
                        <td style="height: 24px">
                        </td>
                    </tr>
                    <tr>
                        <td style="height: 24px; width: 185px;">
                            <span style="font-size: 10pt; color: #4169e1; font-family: Tahoma">Job File</span></td>
                        <td colspan="3" style="height: 24px">
                            <asp:TextBox ID="txtJOB_FILE" runat="server" Font-Names="Arial" Font-Size="10pt"
                                Width="688px" CssClass="RptTextBox"></asp:TextBox></td>
                    </tr>
                    <tr>
                        <td style="height: 24px; width: 185px;">
                        </td>
                        <td style="height: 24px; width: 236px;">
                            <span style="font-size: 10pt; color: #4169e1; font-family: Tahoma">Sample Size</span></td>
                        <td style="height: 24px">
                            <span style="font-size: 10pt; color: #4169e1; font-family: Tahoma">Defect</span></td>
                        <td style="height: 24px">
                            <span style="font-size: 10pt; color: #4169e1; font-family: Tahoma">Result</span></td>
                    </tr>
                    <tr>
                        <td style="width: 185px">
                            <span style="font-size: 10pt; color: #4169e1; font-family: Tahoma">PCB Chip</span></td>
                        <td style="width: 236px">
                            <asp:TextBox ID="txtDEF1_PCBCHIP_SS" runat="server" Font-Names="Arial" Font-Size="10pt"
                                Width="232px" CssClass="RptTextBox"></asp:TextBox></td>
                        <td>
                            <asp:TextBox ID="txtDEF1_PCBCHIP" runat="server" Font-Names="Arial" Font-Size="10pt" Width="194px" CssClass="RptTextBox"></asp:TextBox></td>
                        <td><asp:DropDownList ID="ddlDEF1_PCBCHIP_RT" runat="server" Font-Names="Arial" Width="140px" CssClass="RptTextBox">
                            <asp:ListItem>Passed</asp:ListItem>
                            <asp:ListItem>Failed</asp:ListItem>
                        </asp:DropDownList></td>
                    </tr>
                    <tr>
                        <td style="width: 185px">
                            <span style="font-size: 10pt; color: #4169e1; font-family: Tahoma">Die Crack</span></td>
                        <td style="width: 236px">
                            <asp:TextBox ID="txtDEF2_DIECRACK_SS" runat="server" Font-Names="Arial" Font-Size="10pt"
                                Width="232px" CssClass="RptTextBox"></asp:TextBox></td>
                        <td>
                            <asp:TextBox ID="txtDEF2_DIECRACK" runat="server" Font-Names="Arial" Font-Size="10pt"
                                Width="194px" CssClass="RptTextBox"></asp:TextBox></td>
                        <td><asp:DropDownList ID="ddlDEF2_DIECRACK_RT" runat="server" Font-Names="Arial" Width="140px" CssClass="RptTextBox">
                            <asp:ListItem>Passed</asp:ListItem>
                            <asp:ListItem>Failed</asp:ListItem>
                        </asp:DropDownList></td>
                    </tr>
                    <tr>
                        <td style="height: 26px; width: 185px;">
                            <span style="font-size: 10pt; color: #4169e1; font-family: Tahoma">Solder Ball Damage</span></td>
                        <td style="height: 26px; width: 236px;">
                            <asp:TextBox ID="txtDEF3_SOLDERBALL_DAMAGE_SS" runat="server" Font-Names="Arial"
                                Font-Size="10pt" Width="232px" CssClass="RptTextBox"></asp:TextBox></td>
                        <td style="height: 26px">
                            <asp:TextBox ID="txtDEF3_SOLDERBALL_DAMAGE" runat="server" Font-Names="Arial" Font-Size="10pt"
                                Width="194px" CssClass="RptTextBox"></asp:TextBox></td>
                        <td style="height: 26px"><asp:DropDownList ID="ddlDEF3_SOLDERBALL_DAMAGE_RT" runat="server" Font-Names="Arial" Width="140px" CssClass="RptTextBox">
                            <asp:ListItem>Passed</asp:ListItem>
                            <asp:ListItem>Failed</asp:ListItem>
                        </asp:DropDownList></td>
                    </tr>
                    <tr>
                        <td style="width: 185px">
                            <span style="font-size: 10pt; color: #4169e1; font-family: Tahoma">Die Chip</span></td>
                        <td style="width: 236px">
                            <asp:TextBox ID="txtDEF4_DIECHIP_SS" runat="server" Font-Names="Arial" Font-Size="10pt"
                                Width="232px" CssClass="RptTextBox"></asp:TextBox></td>
                        <td>
                            <asp:TextBox ID="txtDEF4_DIECHIP" runat="server" Font-Names="Arial" Font-Size="10pt"
                                Width="194px" CssClass="RptTextBox"></asp:TextBox></td>
                        <td><asp:DropDownList ID="ddlDEF4_DIECHIP_RT" runat="server" Font-Names="Arial" Width="140px" CssClass="RptTextBox">
                            <asp:ListItem>Passed</asp:ListItem>
                            <asp:ListItem>Failed</asp:ListItem>
                        </asp:DropDownList></td>
                    </tr>
                    <tr>
                        <td style="height: 20px; width: 185px;">
                        </td>
                        <td style="height: 20px; width: 236px;">
                            <span style="font-size: 10pt; color: #4169e1; font-family: Tahoma">Boat matrix</span></td>
                        <td style="height: 20px">
                            <span style="font-size: 10pt; color: #4169e1; font-family: Tahoma">Tray matrix</span></td>
                        <td style="height: 20px">
                            <span style="font-size: 10pt; color: #4169e1; font-family: Tahoma">Body Size</span></td>
                    </tr>
                    <tr>
                        <td style="width: 185px; height: 26px">
                            <span style="font-size: 10pt; color: #4169e1; font-family: Tahoma">Machine parameter</span></td>
                        <td style="width: 236px; height: 26px">
                            <asp:TextBox ID="txtP1_BOAT_MATRIX" runat="server" Font-Names="Arial" Font-Size="10pt"
                                Width="232px" CssClass="RptTextBox"></asp:TextBox></td>
                        <td style="height: 26px">
                            <asp:TextBox ID="txtP2_TRAY_MATRIX" runat="server" Font-Names="Arial" Font-Size="10pt"
                                Width="194px" CssClass="RptTextBox"></asp:TextBox></td>
                        <td style="height: 26px">
                            <asp:TextBox ID="txtP3_BODY_SIZE" runat="server" Font-Names="Arial" Font-Size="10pt"
                                Width="232px" CssClass="RptTextBox"></asp:TextBox></td>
                    </tr>
                    <tr>
                        <td style="width: 185px; height: 26px">
                        </td>
                        <td style="width: 236px; height: 26px">
                        </td>
                        <td style="height: 26px">
                        </td>
                        <td style="height: 26px">
                        </td>
                    </tr>
                    <tr>
                        <td style="width: 185px">
                            <span style="font-size: 10pt; color: #4169e1; font-family: Tahoma">Start Time</span></td>
                        <td style="width: 236px">
                            <asp:TextBox ID="txtSTART_TIME" runat="server" Font-Names="Arial" Font-Size="10pt"
                                Width="232px" CssClass="RptTextBox" ondblclick="FNC_GET_NOW3()"></asp:TextBox></td>
                        <td>
                            <span style="font-size: 10pt; color: #4169e1; font-family: Tahoma">End Time</span></td>
                        <td>
                            <asp:TextBox ID="txtEND_TIME" runat="server" Font-Names="Arial" Font-Size="10pt"
                                Width="232px" CssClass="RptTextBox" ondblclick="FNC_GET_NOW4()"></asp:TextBox></td>
                    </tr>
                    <tr>
                        <td style="width: 185px; height: 26px">
                            <span style="font-size: 10pt; color: #4169e1; font-family: Tahoma">Remark</span></td>
                        <td colspan="3" style="height: 26px">
                            <asp:TextBox ID="txtREMARK_CMT" runat="server" Font-Names="Arial" Font-Size="10pt"
                                Width="688px" CssClass="RptTextBox"></asp:TextBox></td>
                    </tr>
                    <tr>
                        <td style="width: 185px">
                        </td>
                        <td style="width: 236px">
                        </td>
                        <td>
                        </td>
                        <td>
                        </td>
                    </tr>
                </table>
            </asp:Panel>
				<BR>
				<asp:validationsummary id="ValSum" runat="server" Width="367px" Font-Names="Tahoma" Font-Size="XX-Small"
					Font-Bold="True" Height="32px"></asp:validationsummary><br>
				<DIV style="BORDER-TOP-WIDTH: thin; DISPLAY: inline; FONT-WEIGHT: bold; BORDER-LEFT-WIDTH: thin; FONT-SIZE: 10px; BORDER-LEFT-COLOR: gray; BORDER-BOTTOM-WIDTH: thin; BORDER-BOTTOM-COLOR: gray; WIDTH: 928px; BORDER-TOP-COLOR: gray; FONT-FAMILY: Verdana; HEIGHT: 24px; TEXT-ALIGN: right; BORDER-RIGHT-WIDTH: thin; BORDER-RIGHT-COLOR: gray">
					<P><asp:button id="btnBackStep1" runat="server" Font-Names="Tahoma" Font-Size="X-Small" BackColor="SteelBlue"
							BorderWidth="1px" BorderStyle="Solid" Text="< Back" ForeColor="White" Height="30px" Width="100px" Visible="False" TabIndex="99"></asp:button><asp:button id="btnToStep3" runat="server" Font-Names="Tahoma" Font-Size="X-Small" BackColor="SteelBlue"
							BorderWidth="1px" BorderStyle="Solid" Text="Next >" ForeColor="White" Height="30px" Width="100px" TabIndex="30"></asp:button>
						<asp:button id="btnCancel" runat="server" Font-Names="Tahoma" Font-Size="X-Small" BackColor="SteelBlue"
							BorderWidth="1px" BorderStyle="Solid" Text="Cancel" ForeColor="White" Height="30px" Width="100px" TabIndex="32"></asp:button>
					</P>
				</DIV>
				<DIV><FONT face="ËÎÌå"></FONT></DIV>
		</form>
	</body>
</HTML>