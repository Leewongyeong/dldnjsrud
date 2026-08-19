<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Insert.aspx.cs" Inherits="Insert" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
<link rel = "stylesheet" href="./style/main.css" />
    <title></title>

</head>

<body>
<form id="form1" runat="server"


    style="font-family: 'Verdana'; font-style: normal; color: Gray; height: 540px; width: auto;">

        <img alt="" src="image/Header.jpg" style="height: 61px; width:1176px" />
        <div id="menu">
                <ul>
                   <li><a href="./change.aspx">Conversion change</a></li>

		            <li><a href="./search.aspx">Conversion Search</a></li>
		            <li><a href="./Serial_Search.aspx">Serial Search</a></li>
		            <li><a href="./Insert.aspx">Insert Serial & Cap</a></li>

		            <li><a href="./MoldCap_PCB_Insert.aspx">Insert Mold Cap or PCB Thickness</a></li>

                </ul>
        </div>
        <br />

            <table style="border-collapse:collapse; width: 992px;" border="1" bordercolor="palegoldenrod" align="center" bgcolor="floralwhite">
                <tr>
                    <td colspan="3">
                        <asp:Label ID="lbloperator" runat="server"></asp:Label>
&nbsp;<asp:Label ID="lblname" runat="server" ForeColor="#404040"></asp:Label>
                        &nbsp;����
                        <asp:Label ID="lbloper" runat="server" Text="Mold Conversion"></asp:Label>
                        &nbsp; �� �α��� �ϼ̽��ϴ�
                    </td>
                </tr>
                <tr>
                    <td colspan="3" style="vertical-align: middle; text-align: right;">
                        <asp:Button ID="btnLogout" runat="server" Font-Size="9pt" OnClick="btnLogout_Click"
                            Text="�α׾ƿ�" />&nbsp;</td>
                </tr>
                <tr>
                    <td colspan="3" style="height: 18px">
                        <asp:Label ID="Label2" runat="server" ForeColor="#0000C0"
                            Text="Insert Serial & Cap"></asp:Label></td>
                </tr>
                <tr>
                    <td style="width: 28px; height: 27px">
                        No.</td>
                    <td style="width: 20px; height: 27px">
                        <asp:TextBox ID="txtNO" runat="server" Width="130px"></asp:TextBox></td>
                    <td rowspan="3" style="width: 76px">
                        &nbsp;<asp:Button ID="btninput" runat="server" Height="24px"
                        onclick="btninput_Click" Text="�Է�" Width="104px" Font-Size="9pt" /></td>
                </tr>
                <tr>
                    <td style="width: 28px; height: 27px;">
                        Serial</td>
                    <td style="width: 20px; height: 27px;">
                        <asp:TextBox ID="txtSerial" runat="server" Width="130px"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td style="width: 28px; height: 27px;">
                        Cap</td>
                    <td style="width: 20px; height: 27px;">
                        <asp:TextBox ID="txtCap" runat="server" Width="130px"></asp:TextBox></td>
                </tr>
                <tr>
                    <td style="width: 28px; height: 27px;">
                        BTM_TYPE</td>
                    <td style="width: 20px; height: 27px;">
                        <asp:TextBox ID="txtBtmType" runat="server" Width="130px"></asp:TextBox></td>
                </tr>
                <tr>
                    <td colspan="3" style="height: 21px">
                    </td>
                </tr>
                <tr>
                    <td colspan="3" style="height: 21px">
                        <asp:Label ID="Label1" runat="server" ForeColor="#0000C0" Text="���� ����� Serial & Cap"></asp:Label></td>
                </tr>
            </table>
    <table style="border-collapse:collapse; width: 1200px; height: 208px;" border="1" bordercolor="palegoldenrod" align="center" bgcolor="floralwhite">
        <tr>
            <td colspan="7">
                <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False" BackColor="White" BorderColor="#DEDFDE" BorderStyle="None" BorderWidth="1px" CellPadding="4" DataKeyNames="SERIAL" DataSourceID="SqlDataSource1" EnableModelValidation="True" ForeColor="Black" GridLines="Vertical">
                    <AlternatingRowStyle BackColor="White" />
                    <Columns>
                        <asp:CommandField CancelText="Cancle" DeleteText="Delete" EditText="Edit" InsertText="Insert" ShowDeleteButton="True" ShowEditButton="True" UpdateText="Update" />
                        <asp:BoundField DataField="SERIAL" HeaderText="SERIAL" ReadOnly="True" SortExpression="SERIAL" />
                        <asp:BoundField DataField="CAP" HeaderText="CAP" SortExpression="CAP" />
                        <asp:BoundField DataField="OPERATOR" HeaderText="OPERATOR" SortExpression="OPERATOR" />
                        <asp:BoundField DataField="NO" HeaderText="NO" SortExpression="NO" />
                        <asp:BoundField DataField="BTM_TYPE" HeaderText="BTM_TYPE" SortExpression="BTM_TYPE" />
                        <asp:TemplateField HeaderText="&#51077;&#44256;&#51068;">
                            <ItemTemplate>
                                <%# Eval("IPO_DATE") %>
                            </ItemTemplate>
                            <EditItemTemplate>
                                <input type="date" id="txtEditIpoDate" runat="server"
                                    value='<%# Bind("IPO_DATE") %>' style="width:120px;" />
                            </EditItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Re-coating&#51068;">
                            <ItemTemplate>
                                <%# Eval("RECOATING_DATE") %>
                            </ItemTemplate>
                            <EditItemTemplate>
                                <input type="date" id="txtEditRecoatingDate" runat="server"
                                    value='<%# Bind("RECOATING_DATE") %>' style="width:120px;" />
                            </EditItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                    <FooterStyle BackColor="#CCCC99" />
                    <HeaderStyle BackColor="#6B696B" Font-Bold="True" ForeColor="White" />
                    <PagerStyle BackColor="#F7F7DE" ForeColor="Black" HorizontalAlign="Right" />
                    <RowStyle BackColor="#F7F7DE" />
                    <SelectedRowStyle BackColor="#CE5D5A" Font-Bold="True" ForeColor="White" />
                </asp:GridView>
                <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:MoldConnectionString %>"
                    DeleteCommand='DELETE FROM "TBL_MOLD_CONVERSION_SERIAL_CAP" WHERE "SERIAL" = :original_SERIAL AND (("CAP" = :original_CAP) OR ("CAP" IS NULL AND :original_CAP IS NULL)) AND (("OPERATOR" = :original_OPERATOR) OR ("OPERATOR" IS NULL AND :original_OPERATOR IS NULL)) AND (("NO" = :original_NO) OR ("NO" IS NULL AND :original_NO IS NULL)) AND (("BTM_TYPE" = :original_BTM_TYPE) OR ("BTM_TYPE" IS NULL AND :original_BTM_TYPE IS NULL)) AND (("IPO_DATE" = :original_IPO_DATE) OR ("IPO_DATE" IS NULL AND :original_IPO_DATE IS NULL)) AND (("RECOATING_DATE" = :original_RECOATING_DATE) OR ("RECOATING_DATE" IS NULL AND :original_RECOATING_DATE IS NULL))'
                    InsertCommand='INSERT INTO "TBL_MOLD_CONVERSION_SERIAL_CAP" ("SERIAL", "CAP", "OPERATOR", "NO", "BTM_TYPE") VALUES (:SERIAL, :CAP, :OPERATOR, :NO, :BTM_TYPE)'
                    ProviderName="<%$ ConnectionStrings:MoldConnectionString.ProviderName %>" SelectCommand='SELECT * FROM "TBL_MOLD_CONVERSION_SERIAL_CAP"'
                    UpdateCommand='UPDATE "TBL_MOLD_CONVERSION_SERIAL_CAP" SET "CAP" = :CAP, "OPERATOR" = :OPERATOR, "NO" = :NO, "BTM_TYPE" = :BTM_TYPE, "IPO_DATE" = :IPO_DATE, "RECOATING_DATE" = :RECOATING_DATE WHERE "SERIAL" = :original_SERIAL AND (("CAP" = :original_CAP) OR ("CAP" IS NULL AND :original_CAP IS NULL)) AND (("OPERATOR" = :original_OPERATOR) OR ("OPERATOR" IS NULL AND :original_OPERATOR IS NULL)) AND (("NO" = :original_NO) OR ("NO" IS NULL AND :original_NO IS NULL)) AND (("BTM_TYPE" = :original_BTM_TYPE) OR ("BTM_TYPE" IS NULL AND :original_BTM_TYPE IS NULL)) AND (("IPO_DATE" = :original_IPO_DATE) OR ("IPO_DATE" IS NULL AND :original_IPO_DATE IS NULL)) AND (("RECOATING_DATE" = :original_RECOATING_DATE) OR ("RECOATING_DATE" IS NULL AND :original_RECOATING_DATE IS NULL))' ConflictDetection="CompareAllValues" OldValuesParameterFormatString="original_{0}">
                    <DeleteParameters>
                        <asp:Parameter Name="original_SERIAL" Type="String" />
                        <asp:Parameter Name="original_CAP" Type="String" />
                        <asp:Parameter Name="original_OPERATOR" Type="String" />
                        <asp:Parameter Name="original_NO" Type="String" />
                        <asp:Parameter Name="original_BTM_TYPE" Type="String" />
                        <asp:Parameter Name="original_IPO_DATE" Type="String" />
                        <asp:Parameter Name="original_RECOATING_DATE" Type="String" />
                    </DeleteParameters>
                    <InsertParameters>
                        <asp:Parameter Name="SERIAL" Type="String" />
                        <asp:Parameter Name="CAP" Type="String" />
                        <asp:Parameter Name="OPERATOR" Type="String" />
                        <asp:Parameter Name="NO" Type="String" />
                        <asp:Parameter Name="BTM_TYPE" Type="String" />
                    </InsertParameters>
                    <UpdateParameters>
                        <asp:Parameter Name="CAP" Type="String" />
                        <asp:Parameter Name="OPERATOR" Type="String" />
                        <asp:Parameter Name="NO" Type="String" />
                        <asp:Parameter Name="BTM_TYPE" Type="String" />
                        <asp:Parameter Name="IPO_DATE" Type="String" />
                        <asp:Parameter Name="RECOATING_DATE" Type="String" />
                        <asp:Parameter Name="original_SERIAL" Type="String" />
                        <asp:Parameter Name="original_CAP" Type="String" />
                        <asp:Parameter Name="original_OPERATOR" Type="String" />
                        <asp:Parameter Name="original_NO" Type="String" />
                        <asp:Parameter Name="original_BTM_TYPE" Type="String" />
                        <asp:Parameter Name="original_IPO_DATE" Type="String" />
                        <asp:Parameter Name="original_RECOATING_DATE" Type="String" />
                    </UpdateParameters>
                </asp:SqlDataSource>
            </td>
        </tr>
    </table>
    &nbsp;

    </form>
</body>
</html>
