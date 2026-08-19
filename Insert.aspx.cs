using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.Text;
using System.Drawing;

public partial class Insert : System.Web.UI.Page
{
    string strCon = "Data Source=sckcimdwh.world; User ID=moldpcsd;Pwd=pcsdmold!";
    //string strConMC = "Data Source=sckmes.world; User ID=sch_it;Pwd=mesdw";

    protected void Page_Load(object sender, EventArgs e)
    {

        if (Session["ID"] == null)
        {
            Response.Redirect("Default.aspx");
        }

        lbloperator.Text = Session["ID"].ToString();
        lblname.Text = Session["name"].ToString();
    }

    protected void btninput_Click(object sender, EventArgs e)
    {
        if (txtSerial.Text == "")
        {
            ClientScript.RegisterStartupScript(this.GetType(), "register", "alert('Serial 값을 입력하세요.');", true);
            txtSerial.Focus();
            return;
        }
        if (txtCap.Text == "")
        {
            ClientScript.RegisterStartupScript(this.GetType(), "register", "alert('Cap 값을 입력하세요');", true);
            txtCap.Focus();
            return;
        }
        if (txtNO.Text == "")
        {
            ClientScript.RegisterStartupScript(this.GetType(), "register", "alert('NO를 입력하세요');", true);
            txtNO.Focus();
            return;
        }
        if (txtBtmType.Text == "")
        {
            ClientScript.RegisterStartupScript(this.GetType(), "register", "alert('BTM_TYPE 입력하세요');", true);
            txtNO.Focus();
            return;
        }

        try
        {
            int mold;
            StringBuilder sql1 = new StringBuilder();

            sql1.Append("insert into TBL_MOLD_CONVERSION_SERIAL_CAP(SERIAL, CAP, OPERATOR, NO,BTM_TYPE) VALUES(");
            sql1.Append(" '" + txtSerial.Text + "','" + txtCap.Text + "', '" + lbloperator.Text + "', '" + txtNO.Text + "','"+txtBtmType.Text+ "')");

            mold = SQL_HELPER.SqlHelper.ExecuteNonQuery(strCon, CommandType.Text, sql1.ToString());

            if (mold > 0)
            {
                Page.RegisterClientScriptBlock("alert", "<script language='javascript'>alert('입력이 완료 되었습니다. ');location.href='Insert.aspx';</script>");
            }

            else
            {
                ClientScript.RegisterStartupScript(
                           this.GetType(), "register",
                           "alert('입력되지 않았습니다');", true);
                return;
            }

        }

        catch (Exception ex)
        {

            Response.Write("<script>alert('" + ex.Message.Substring(0, ex.Message.Length - 2) + "');</script>");

        }
    }

    protected void btnLogout_Click(object sender, EventArgs e)
    {
        Session["ID"] = "";
        Session["NAME"] = "";
        Response.Redirect("Default.aspx");
    }
}
