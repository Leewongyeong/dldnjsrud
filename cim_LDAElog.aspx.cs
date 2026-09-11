/* ======================================================================================================
 * File Name:   cim_LDAElog.aspx.cs
 * Description: LDA ElogSheet 페이지 (단일 테이블 RTS.LDA_ELOGSHEET)
 * DATE        AUTHOR       DESCRIPTION
 * ----------  -----------  ---------------------------------
 * 2025.xx.xx  jechan.na    Init
======================================================================================================= */

using System;
using System.Collections.Generic;
using System.Data;
using Oracle.ManagedDataAccess.Client;
using System.Reflection;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;
using Telerik.Web.UI;
using Utilities;
using Webapp.Common;
using Webapp.Helper;
using Connection = Webapp.Helper.Connection;

public partial class sources_soc_cim_prod_assembly_cim_LDAElog : BasePage
{
    Connection conn;
    DataTable dtBuyoffResult = new DataTable();

    /// <summary>
    /// PRD 탭 기본 E-Log Sheet 구분.
    /// 저장(btn_save_prd_Click)이 ELOGSHEET_TYPE 에 'PROD' 로 넣으므로 조회도 'PROD' 여야 한다.
    /// (기존에는 조회 조건이 'PRD' 라서 PRD 탭이 항상 0 건이었다)
    /// </summary>
    private const string DEFAULT_ELOGSHEET_TYPE = "PROD";

    public sources_soc_cim_prod_assembly_cim_LDAElog()
    {
        conn = new Connection();
    }

    protected override void InitPage()
    {
        if (!IsPostBack)
        {
            // 그리드 구분을 먼저 초기화한다.
            // (이전 방문의 Session 값으로 컬럼을 만들면 화면은 PRD 인데 컬럼은 QA/TECH 가 되어버린다)
            HiddenField1.Value = DEFAULT_ELOGSHEET_TYPE;
            Session["LDA_ELOG_GRID_TYPE"] = DEFAULT_ELOGSHEET_TYPE;
        }

        BuildGridColumns(GetCurrentGridType());

        if (!IsPostBack)
        {
            date_from.SelectedDate = DateTime.Now.Date.AddDays(-5);
            date_to.SelectedDate = DateTime.Now.Date;

            title_material_information_qa.Visible = true;
            tb_material_information_qa.Visible = true;
            pnl_measure_setup_qa.Visible = true;
            pnl_measure_vm_qa.Visible = false;

            pnl_needle_prd.Visible = true;
            tr_coverage_prd.Visible = true;
            tr_tilt_prd.Visible = true;
            tr_position_prd.Visible = true;

            // Equipment ID 드롭다운 (TECH)
            string connStr = conn.GetConnectionString(DatabaseInfo.SCK_RTS);
            try
            {
                ddl_eq_id_tech.Items.Clear();
                ddl_eq_id_tech.Items.Add(new ListItem("HSA001", "HSA001"));
                ddl_eq_id_tech.Items.Add(new ListItem("HSA002", "HSA002"));
            }
            catch { }

            // M/C No 드롭다운 (PRD)
            try
            {
                ddl_McNo_prd.Items.Clear();
                ddl_McNo_prd.Items.Add(new ListItem("HSA001", "HSA001"));
                ddl_McNo_prd.Items.Add(new ListItem("HSA002", "HSA002"));
            }
            catch { }
        }
    }

    #region Helper
    private void ShowAlert(string message)
    {
        message = JsEscape(message);
        string script = "alert('" + message + "');";
        if (ScriptManager.GetCurrent(Page) != null)
            ScriptManager.RegisterStartupScript(Page, Page.GetType(), Guid.NewGuid().ToString(), script, true);
        else
            ClientScript.RegisterStartupScript(Page.GetType(), Guid.NewGuid().ToString(), script, true);
    }

    private static string JsEscape(string s)
    {
        if (s == null) return "";
        return s.Replace("\\", "\\\\").Replace("'", "\\'").Replace("\"", "\\\"")
                .Replace("\r", "\\r").Replace("\n", "\\n");
    }

    private string GetCurrentGridType()
    {
        object v = Session["LDA_ELOG_GRID_TYPE"];
        if (v == null) return DEFAULT_ELOGSHEET_TYPE;

        string sheetType = v.ToString().Trim();
        return sheetType.Length == 0 ? DEFAULT_ELOGSHEET_TYPE : sheetType;
    }

    private void AddGridColumn(string dataField, string headerText)
    {
        GridBoundColumn col = new GridBoundColumn();
        col.DataField = dataField;
        col.UniqueName = dataField;
        col.HeaderText = headerText;
        col.HeaderStyle.Wrap = false;
        rgv_List.MasterTableView.Columns.Add(col);
    }

    private void BuildGridColumns(string sheetType)
    {
        GridButtonColumn deleteColumn = rgv_List.MasterTableView.GetColumn("DeleteColumn") as GridButtonColumn;
        rgv_List.MasterTableView.Columns.Clear();
        if (deleteColumn != null)
            rgv_List.MasterTableView.Columns.Add(deleteColumn);

        AddGridColumn("INPUT_TIME", "INPUT_TIME");
        AddGridColumn("SHIFT", "Shift");
        // TECH 는 Sheet Type 개념이 없다 (입력 화면에도 없음, ELOGSHEET_TYPE 이 항상 'TECH' 고정)
        if (sheetType != "TECH")
            AddGridColumn("SHEET_TYPE", "Sheet Type");
        AddGridColumn("LOT_ID", "LOT ID");
        AddGridColumn("CUST_NAME", "Customer");
        AddGridColumn("PKG", "PKG");
        AddGridColumn("LEAD", "Lead");
        AddGridColumn("CUST_DEVICE", "Device");
        AddGridColumn("EQUIP_ID", "M/C No");
        AddGridColumn("OPER_CODE", "Oper Code");
        AddGridColumn("RECIPE_NAME", "Recipe Name");
        AddGridColumn("USER_ID", "User ID");

        switch (sheetType)
        {
            case "TECH":
                AddGridColumn("USER_NAME", "User Name");
                AddGridColumn("TCARD_AND_AI_CHECK", "T-card & A/I Check");
                AddGridColumn("PICKUP_TOOL", "Pick Up Tool");
                AddGridColumn("PCB_REVERSE_DETECT_CHECK", "PCB Reverse Detect Check");
                AddGridColumn("BONDING_FORCE", "Bonding Force");
                AddGridColumn("PCB_MAGAZINE_LOAD_UNLOAD_CHECK", "PCB Magazine Load/Unload Check");
                AddGridColumn("DELAY_TIME", "Delay Time");
                AddGridColumn("PCB_BACK_SIDE_SCRATCH_CHECK", "PCB Back Side Scratch Check");
                AddGridColumn("PUSHER_POSITION_CHECK", "Pusher Position Check");
                AddGridColumn("MODE_2DID", "2DID Mode");
                break;

            case "QA":
                AddGridColumn("NICK", "Nick");
                AddGridColumn("QTY", "Qty");
                AddGridColumn("SYS1_INFO", "System1 Info (Head1)");
                AddGridColumn("SYS1_BATCH_NO", "System1 Batch No (Head1)");
                AddGridColumn("SYS1_SAP_CODE", "System1 SAP Code (Head1)");
                AddGridColumn("SYS1_EXPIRE_TIME", "System1 Expire Time (Head1)");
                AddGridColumn("SYS1_INFO_2", "System1 Info (Head2)");
                AddGridColumn("SYS1_BATCH_NO_2", "System1 Batch No (Head2)");
                AddGridColumn("SYS1_SAP_CODE_2", "System1 SAP Code (Head2)");
                AddGridColumn("SYS1_EXPIRE_TIME_2", "System1 Expire Time (Head2)");
                AddGridColumn("SYS2_INFO", "System2 Info (Head1)");
                AddGridColumn("SYS2_BATCH_NO", "System2 Batch No (Head1)");
                AddGridColumn("SYS2_SAP_CODE", "System2 SAP Code (Head1)");
                AddGridColumn("SYS2_EXPIRE_TIME", "System2 Expire Time (Head1)");
                AddGridColumn("SYS2_INFO_2", "System2 Info (Head2)");
                AddGridColumn("SYS2_BATCH_NO_2", "System2 Batch No (Head2)");
                AddGridColumn("SYS2_SAP_CODE_2", "System2 SAP Code (Head2)");
                AddGridColumn("SYS2_EXPIRE_TIME_2", "System2 Expire Time (Head2)");
                AddGridColumn("SYS3_INFO", "System3 Info (Head1)");
                AddGridColumn("SYS3_BATCH_NO", "System3 Batch No (Head1)");
                AddGridColumn("SYS3_SAP_CODE", "System3 SAP Code (Head1)");
                AddGridColumn("SYS3_EXPIRE_TIME", "System3 Expire Time (Head1)");
                AddGridColumn("SYS3_INFO_2", "System3 Info (Head2)");
                AddGridColumn("SYS3_BATCH_NO_2", "System3 Batch No (Head2)");
                AddGridColumn("SYS3_SAP_CODE_2", "System3 SAP Code (Head2)");
                AddGridColumn("SYS3_EXPIRE_TIME_2", "System3 Expire Time (Head2)");
                AddGridColumn("SYS4_INFO", "System4 Info (Head1)");
                AddGridColumn("SYS4_BATCH_NO", "System4 Batch No (Head1)");
                AddGridColumn("SYS4_SAP_CODE", "System4 SAP Code (Head1)");
                AddGridColumn("SYS4_EXPIRE_TIME", "System4 Expire Time (Head1)");
                AddGridColumn("SYS4_INFO_2", "System4 Info (Head2)");
                AddGridColumn("SYS4_BATCH_NO_2", "System4 Batch No (Head2)");
                AddGridColumn("SYS4_SAP_CODE_2", "System4 SAP Code (Head2)");
                AddGridColumn("SYS4_EXPIRE_TIME_2", "System4 Expire Time (Head2)");
                AddGridColumn("SYS5_INFO", "Lid Info (Head1)");
                AddGridColumn("SYS5_BATCH_NO", "Lid Batch No (Head1)");
                AddGridColumn("SYS5_INFO_2", "Lid Info (Head2)");
                AddGridColumn("SYS5_BATCH_NO_2", "Lid Batch No (Head2)");
                AddGridColumn("SYS5_SAP_CODE", "Lid SAP Code (Head1)");
                AddGridColumn("SYS5_EXPIRE_TIME", "Lid Expire Time (Head1)");
                AddGridColumn("SYS5_SAP_CODE_2", "Lid SAP Code (Head2)");
                AddGridColumn("SYS5_EXPIRE_TIME_2", "Lid Expire Time (Head2)");
                AddGridColumn("QA_SYS1_PATTERN", "TIM Pattern");
                AddGridColumn("QA_SYS2_PATTERN", "Glue Pattern");
                AddGridColumn("QA_DUMMY_COVERAGE", "Dummy Coverage");
                AddGridColumn("QA_DUMMY_COVERAGE_TYPE", "Dummy Coverage Type");
                AddGridColumn("QA_STRIP_NO", "Strip No");
                AddGridColumn("QA_VISUAL", "Visual");
                AddGridColumn("QA_VISUAL_TYPE", "Visual Type");
                AddGridColumn("BUY_OFF_RESULT", "Buy-off Result");
                AddGridColumn("REMARK", "Remark");
                break;

            case "PROD":
            case "PRD":     // 예전 Session 값 호환
            default:
                AddGridColumn("NICK", "Nick");
                AddGridColumn("QTY", "Qty");
                AddGridColumn("AI_NO", "AI");
                AddGridColumn("SYS1_INFO", "System1 Info (Head1)");
                AddGridColumn("SYS1_BATCH_NO", "System1 Batch No (Head1)");
                AddGridColumn("SYS1_SAP_CODE", "System1 SAP Code (Head1)");
                AddGridColumn("SYS1_EXPIRE_TIME", "System1 Expire Time (Head1)");
                AddGridColumn("SYS1_INFO_2", "System1 Info (Head2)");
                AddGridColumn("SYS1_BATCH_NO_2", "System1 Batch No (Head2)");
                AddGridColumn("SYS1_SAP_CODE_2", "System1 SAP Code (Head2)");
                AddGridColumn("SYS1_EXPIRE_TIME_2", "System1 Expire Time (Head2)");
                AddGridColumn("SYS2_INFO", "System2 Info (Head1)");
                AddGridColumn("SYS2_BATCH_NO", "System2 Batch No (Head1)");
                AddGridColumn("SYS2_SAP_CODE", "System2 SAP Code (Head1)");
                AddGridColumn("SYS2_EXPIRE_TIME", "System2 Expire Time (Head1)");
                AddGridColumn("SYS2_INFO_2", "System2 Info (Head2)");
                AddGridColumn("SYS2_BATCH_NO_2", "System2 Batch No (Head2)");
                AddGridColumn("SYS2_SAP_CODE_2", "System2 SAP Code (Head2)");
                AddGridColumn("SYS2_EXPIRE_TIME_2", "System2 Expire Time (Head2)");
                AddGridColumn("SYS3_INFO", "System3 Info (Head1)");
                AddGridColumn("SYS3_BATCH_NO", "System3 Batch No (Head1)");
                AddGridColumn("SYS3_SAP_CODE", "System3 SAP Code (Head1)");
                AddGridColumn("SYS3_EXPIRE_TIME", "System3 Expire Time (Head1)");
                AddGridColumn("SYS3_INFO_2", "System3 Info (Head2)");
                AddGridColumn("SYS3_BATCH_NO_2", "System3 Batch No (Head2)");
                AddGridColumn("SYS3_SAP_CODE_2", "System3 SAP Code (Head2)");
                AddGridColumn("SYS3_EXPIRE_TIME_2", "System3 Expire Time (Head2)");
                AddGridColumn("SYS4_INFO", "System4 Info (Head1)");
                AddGridColumn("SYS4_BATCH_NO", "System4 Batch No (Head1)");
                AddGridColumn("SYS4_SAP_CODE", "System4 SAP Code (Head1)");
                AddGridColumn("SYS4_EXPIRE_TIME", "System4 Expire Time (Head1)");
                AddGridColumn("SYS4_INFO_2", "System4 Info (Head2)");
                AddGridColumn("SYS4_BATCH_NO_2", "System4 Batch No (Head2)");
                AddGridColumn("SYS4_SAP_CODE_2", "System4 SAP Code (Head2)");
                AddGridColumn("SYS4_EXPIRE_TIME_2", "System4 Expire Time (Head2)");
                AddGridColumn("SYS5_INFO", "Lid Info (Head1)");
                AddGridColumn("SYS5_BATCH_NO", "Lid Batch No (Head1)");
                AddGridColumn("SYS5_INFO_2", "Lid Info (Head2)");
                AddGridColumn("SYS5_BATCH_NO_2", "Lid Batch No (Head2)");
                AddGridColumn("SYS5_SAP_CODE", "Lid SAP Code (Head1)");
                AddGridColumn("SYS5_EXPIRE_TIME", "Lid Expire Time (Head1)");
                AddGridColumn("SYS5_SAP_CODE_2", "Lid SAP Code (Head2)");
                AddGridColumn("SYS5_EXPIRE_TIME_2", "Lid Expire Time (Head2)");
                AddGridColumn("SYS1_NEEDLE_SN", "TIM Needle S/N");
                AddGridColumn("SYS1_NEEDLE_SIZE", "TIM Needle Size");
                AddGridColumn("SYS2_NEEDLE_SN", "Glue Needle S/N");
                AddGridColumn("SYS2_NEEDLE_SIZE", "Glue Needle Size");
                AddGridColumn("SYS1_DISPENSING_PATTERN", "TIM Dispensing Pattern");
                AddGridColumn("SYS2_DISPENSING_PATTERN", "Epoxy Dispensing Pattern");
                AddGridColumn("COVERAGE_DETACH", "Dummy Coverage(Detach)");
                AddGridColumn("TILT_PROD", "Tilt");
                AddGridColumn("POSITION_PROD", "Position");
                AddGridColumn("REMARK", "Remark");
                break;
        }

        AddGridColumn("CREATED_TIME", "등록시간");
    }

    public DataSet Get_LotInfo(string strLotId)
    {
        string[] SQL = new string[2];
        string connStr = conn.GetConnectionString(DatabaseInfo.SCK_RTS);
        try
        {
            DataSet ds = new DataSet();
            using (OracleHelper oraObj = new OracleHelper(connStr))
            {
                string sql = string.Format("select ksy_get_lot_from_brc('{0}') AS LOT_NO from dual", strLotId);
                ds = oraObj.ExecuteDataset(sql);
                string lot_brc = ds.Tables[0].Rows[0]["LOT_NO"].ToString();

                sql = "SELECT PKG_TYPE, LEAD_COUNT, CUST_ID, DEVICE, QTY, NICK, AI FROM CIM_BONRCP WHERE LOT_ID='" + lot_brc + "'";
                SQL[0] = string.Format("select ksy_get_lot_from_brc('{0}') AS LOT_NO from dual", strLotId);
                SQL[1] = sql;

                ds = oraObj.MultiExecuteDataset(SQL);
                return ds;
            }
        }
        catch (Exception ex) { throw ex; }
    }

    public DataTable GetHeatSinkBatchInfo(string BatchNo)
    {
        DataTable dtReturn = new DataTable();
        OracleConnection oc = new OracleConnection(LibSys.SCK_RTS);
        try
        {
            oc.Open();
            string sql = "SELECT * FROM CIM_BATSAP WHERE BATCH_NO='" + BatchNo + "'";
            new OracleDataAdapter(sql, oc).Fill(dtReturn);
            return dtReturn;
        }
        catch { return null; }
        finally { oc.Close(); }
    }

    public DataTable GetHeatSinkSapCodeFromLotID(string lotID)
    {
        DataTable dtReturn = new DataTable();
        OracleConnection oc = new OracleConnection(LibSys.SCK_RTS);
        try
        {
            oc.Open();
            string sql = "select F_GET_AI_INTR('" + lotID + "') AS AI_INTR from dual";
            new OracleDataAdapter(sql, oc).Fill(dtReturn);
            string ai_intr = dtReturn.Rows[0][0].ToString();
            dtReturn = new DataTable();
            sql = "select * from ai_content@link_ai where ai_no_intr = '" + ai_intr + "' and OPER = '140' and ITEM_ID in ('sap_1190', 'sap_6015')";
            new OracleDataAdapter(sql, oc).Fill(dtReturn);
            return dtReturn;
        }
        catch { return null; }
        finally { oc.Close(); }
    }

    public DataTable GetSapCodeByBatchNo(string BatchNo)
    {
        DataTable dtReturn = new DataTable();
        OracleConnection oc = new OracleConnection(LibSys.SCK_RTS);
        try
        {
            oc.Open();
            string sql = "select distinct(matl_code) from wip_batinf@link_cpkmes1 where batch_no = '" + BatchNo + "' and use_flag = ' '";
            new OracleDataAdapter(sql, oc).Fill(dtReturn);
            return dtReturn;
        }
        catch { return null; }
        finally { oc.Close(); }
    }

    public DataTable GetSapInfoByLotId(string LotId, string batchId)
    {
        DataTable dtReturn = new DataTable();
        OracleConnection oc = new OracleConnection(LibSys.SCK_RTS);
        try
        {
            oc.Open();
            string sql = "select F_GET_AI_INTR('" + LotId + "') AS AI_INTR from dual";
            new OracleDataAdapter(sql, oc).Fill(dtReturn);
            string ai_intr = dtReturn.Rows[0][0].ToString();
            dtReturn = new DataTable();
            sql = "select * from ai_content@link_ai where ai_no_intr = '" + ai_intr + "' and sap_code = '" + batchId + "'";
            new OracleDataAdapter(sql, oc).Fill(dtReturn);
            return dtReturn;
        }
        catch { return null; }
        finally { oc.Close(); }
    }

    public DataTable GetMaterialInfo(string LotID, string OperCode, string BatchNo)
    {
        DataTable dtReturn = new DataTable();
        OracleConnection oc = new OracleConnection(LibSys.SCK_RTS);
        try
        {
            oc.Open();
            string sql = "SELECT RTS.KSY_CHK_AI_MATL_BY_LOT('" + LotID + "', '" + OperCode + "', '" + BatchNo + "') from dual";
            new OracleDataAdapter(sql, oc).Fill(dtReturn);
            return dtReturn;
        }
        catch { return null; }
        finally { oc.Close(); }
    }
    #endregion

    #region PRD Page

    protected void ddl_SheetType_prd_SelectedIndexChanged(object sender, EventArgs e)
    {
        bool isSetUp = ddl_SheetType_prd.SelectedItem.Text == "Set-Up";

        pnl_needle_prd.Visible = isSetUp;
        tr_coverage_prd.Visible = isSetUp;
        tr_tilt_prd.Visible = isSetUp;
        tr_position_prd.Visible = isSetUp;

        if (!isSetUp)
        {
            txt_sys1_info_prd.Text = txt_sys2_info_prd.Text = txt_sys3_info_prd.Text = txt_sys4_info_prd.Text = txt_lid_info_prd.Text = string.Empty;
            txt_sys1_batch_prd.Text = txt_sys2_batch_prd.Text = txt_sys3_batch_prd.Text = txt_sys4_batch_prd.Text = txt_lid_batch_prd.Text = string.Empty;
            txt_sys1_sap_prd.Text = txt_sys2_sap_prd.Text = txt_sys3_sap_prd.Text = txt_sys4_sap_prd.Text = txt_lid_sap_prd.Text = string.Empty;
            tp_sys1_expire_prd.SelectedDate = null;
            tp_sys2_expire_prd.SelectedDate = null;
            tp_sys3_expire_prd.SelectedDate = null;
            tp_sys4_expire_prd.SelectedDate = null;
            tp_lid_expire_prd.SelectedDate = null;

            // Head2
            txt_sys1_info_prd_h2.Text = txt_sys2_info_prd_h2.Text = txt_sys3_info_prd_h2.Text = txt_sys4_info_prd_h2.Text = txt_lid_info_prd_h2.Text = string.Empty;
            txt_sys1_batch_prd_h2.Text = txt_sys2_batch_prd_h2.Text = txt_sys3_batch_prd_h2.Text = txt_sys4_batch_prd_h2.Text = txt_lid_batch_prd_h2.Text = string.Empty;
            txt_sys1_sap_prd_h2.Text = txt_sys2_sap_prd_h2.Text = txt_sys3_sap_prd_h2.Text = txt_sys4_sap_prd_h2.Text = txt_lid_sap_prd_h2.Text = string.Empty;
            tp_sys1_expire_prd_h2.SelectedDate = null;
            tp_sys2_expire_prd_h2.SelectedDate = null;
            tp_sys3_expire_prd_h2.SelectedDate = null;
            tp_sys4_expire_prd_h2.SelectedDate = null;
            tp_lid_expire_prd_h2.SelectedDate = null;
        }
    }

    protected void txt_LotId_prd_TextChanged(object sender, EventArgs e)
    {
        try
        {
            DataSet ds = Get_LotInfo(txt_LotId_prd.Text.ToUpper());
            if (ds.Tables[0].Rows.Count > 0)
                txt_LotId_prd.Text = ds.Tables[0].Rows[0][0].ToString();

            if (ds.Tables[1].Rows.Count > 0)
            {
                DataRow r = ds.Tables[1].Rows[0];
                txt_Pkg_prd.Text = string.IsNullOrWhiteSpace(r["PKG_TYPE"].ToString()) ? "." : r["PKG_TYPE"].ToString();
                txt_Lead_prd.Text = string.IsNullOrWhiteSpace(r["LEAD_COUNT"].ToString()) ? "." : r["LEAD_COUNT"].ToString();
                txt_Cust_prd.Text = string.IsNullOrWhiteSpace(r["CUST_ID"].ToString()) ? "." : r["CUST_ID"].ToString();
                txt_Device_prd.Text = string.IsNullOrWhiteSpace(r["DEVICE"].ToString()) ? "." : r["DEVICE"].ToString();
                txt_Nick_prd.Text = string.IsNullOrWhiteSpace(r["NICK"].ToString()) ? "." : r["NICK"].ToString();
                txt_Qty_prd.Text = string.IsNullOrWhiteSpace(r["QTY"].ToString()) ? "." : r["QTY"].ToString();
                txt_ai_prd.Text = string.IsNullOrWhiteSpace(r["AI"].ToString()) ? "." : r["AI"].ToString();

                // System1 자동생성
                string CONSTR_MES = LibSys.CPKMES1;
                string SQL = "SELECT * FROM (SELECT * FROM WRK_TAIL01 WHERE PURPOSE = 'HEAT_SPREADER' AND DATA30 IS NOT NULL AND DATA1 = '" + txt_LotId_prd.Text.ToUpper().Trim() + "' ORDER BY DATA30 DESC) WHERE ROWNUM=1";
                DataSet dsWrk = SQL_HELPER.SqlHelper.ExecuteDataset(CONSTR_MES, CommandType.Text, SQL);
                if (dsWrk.Tables[0].Rows.Count > 0)
                {
                    DataRow row = dsWrk.Tables[0].Rows[0];
                    txt_sys1_sap_prd.Text = row["DATA6"].ToString();
                    txt_sys1_batch_prd.Text = row["DATA5"].ToString();

                    DateTime expDt;
                    if (DateTime.TryParse(row["DATA7"].ToString(), out expDt))
                        tp_sys1_expire_prd.SelectedDate = expDt;

                    DataTable dtResult = GetSapInfoByLotId(txt_LotId_prd.Text, row["DATA6"].ToString());
                    txt_sys1_info_prd.Text = (dtResult != null && dtResult.Rows.Count > 0)
                        ? dtResult.Rows[0][4].ToString().Split('|')[1]
                        : "ERROR";
                }
            }
            else
            {
                txt_Pkg_prd.Text = txt_Lead_prd.Text = txt_Cust_prd.Text =
                txt_Device_prd.Text = txt_Nick_prd.Text = txt_Qty_prd.Text = ".";
            }
        }
        catch { }
    }

    private void LookupSysBatchNo_Prd(string batchNo, TextBox txtInfo, TextBox txtSap)
    {
        if (txt_LotId_prd.Text == "")
        {
            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "ERROR", "alert('LOT ID를 먼저 입력하세요.');", true);
            return;
        }
        try
        {
            DataTable dtResult = GetMaterialInfo(txt_LotId_prd.Text, txt_OperCode_prd.Text, batchNo);
            if (dtResult != null && dtResult.Rows.Count == 1 && dtResult.Rows[0][0].ToString() == "Y")
            {
                DataTable dtResult2 = GetSapCodeByBatchNo(batchNo);
                DataTable dtResult3 = GetSapInfoByLotId(txt_LotId_prd.Text, dtResult2.Rows[0][0].ToString());
                if (dtResult3 != null && dtResult3.Rows.Count == 1)
                {
                    txtInfo.Text = dtResult3.Rows[0][4].ToString().Split('|')[1];
                    txtSap.Text = dtResult3.Rows[0][4].ToString().Split('|')[0];
                }
                else { txtInfo.Text = txtSap.Text = "ERROR"; }
            }
            else { txtInfo.Text = txtSap.Text = "ERROR"; }
        }
        catch { }
    }

    protected void txt_sys1_batch_prd_TextChanged(object sender, EventArgs e)
    {
        if (txt_sys1_batch_prd.Text == "") { txt_sys1_info_prd.Text = txt_sys1_sap_prd.Text = string.Empty; return; }
        LookupSysBatchNo_Prd(txt_sys1_batch_prd.Text, txt_sys1_info_prd, txt_sys1_sap_prd);
    }

    protected void txt_sys2_batch_prd_TextChanged(object sender, EventArgs e)
    {
        if (txt_sys2_batch_prd.Text == "") { txt_sys2_info_prd.Text = txt_sys2_sap_prd.Text = string.Empty; return; }
        LookupSysBatchNo_Prd(txt_sys2_batch_prd.Text, txt_sys2_info_prd, txt_sys2_sap_prd);
    }

    protected void txt_sys3_batch_prd_TextChanged(object sender, EventArgs e)
    {
        if (txt_sys3_batch_prd.Text == "") { txt_sys3_info_prd.Text = txt_sys3_sap_prd.Text = string.Empty; return; }
        LookupSysBatchNo_Prd(txt_sys3_batch_prd.Text, txt_sys3_info_prd, txt_sys3_sap_prd);
    }

    protected void txt_sys4_batch_prd_TextChanged(object sender, EventArgs e)
    {
        if (txt_sys4_batch_prd.Text == "") { txt_sys4_info_prd.Text = txt_sys4_sap_prd.Text = string.Empty; return; }
        LookupSysBatchNo_Prd(txt_sys4_batch_prd.Text, txt_sys4_info_prd, txt_sys4_sap_prd);
    }

    protected void btn_sys1_na_prd_Click(object sender, EventArgs e) { txt_sys1_batch_prd.Text = "N/A"; txt_sys1_info_prd.Text = txt_sys1_sap_prd.Text = string.Empty; }
    protected void btn_sys2_na_prd_Click(object sender, EventArgs e) { txt_sys2_batch_prd.Text = "N/A"; txt_sys2_info_prd.Text = txt_sys2_sap_prd.Text = string.Empty; }
    protected void btn_sys3_na_prd_Click(object sender, EventArgs e) { txt_sys3_batch_prd.Text = "N/A"; txt_sys3_info_prd.Text = txt_sys3_sap_prd.Text = string.Empty; }
    protected void btn_sys4_na_prd_Click(object sender, EventArgs e) { txt_sys4_batch_prd.Text = "N/A"; txt_sys4_info_prd.Text = txt_sys4_sap_prd.Text = string.Empty; }

    /// <summary>
    /// Lid Batch No 로 CIM_BATSAP 을 조회한다. System1~4 와 동일하게
    /// SAP Code = 자재 코드(MATL_CODE) 그대로, Information = ai_content 에서 찾은 설명으로 분리한다.
    /// (기존에는 MATL_CODE 를 Information 칸에 그대로 넣고 있어서 SAP Code 성격의 값이
    ///  Information 에 표시되는 문제가 있었다)
    /// </summary>
    private void LookupLidBatchNo_Prd(TextBox txtBatch, TextBox txtInfo, TextBox txtSap)
    {
        if (txt_LotId_prd.Text == "")
        {
            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "ERROR", "alert('LOT ID를 먼저 입력하세요.');", true);
            txtBatch.Text = "";
            return;
        }
        try
        {
            string BATCH = txtBatch.Text.ToUpper();
            if (BATCH.Contains("/")) BATCH = BATCH.Split('/')[1];

            DataTable batchID = GetHeatSinkBatchInfo(BATCH);
            if (batchID == null || batchID.Rows.Count == 0)
            {
                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "ERROR", "alert('잘못된 Lid BATCH NO 입니다.');", true);
                txtBatch.Text = string.Empty;
                txtInfo.Text = string.Empty;
                txtSap.Text = string.Empty;
                return;
            }
            txtBatch.Text = batchID.Rows[0]["BATCH_NO"].ToString();

            string matlCode = batchID.Rows[0]["MATL_CODE"].ToString();
            txtSap.Text = matlCode;

            DataTable dtInfo = GetSapInfoByLotId(txt_LotId_prd.Text, matlCode);
            txtInfo.Text = (dtInfo != null && dtInfo.Rows.Count > 0)
                ? dtInfo.Rows[0][4].ToString().Split('|')[1]
                : "ERROR";
        }
        catch
        {
            txtBatch.Text = string.Empty;
            txtInfo.Text = string.Empty;
            txtSap.Text = string.Empty;
        }
    }

    protected void txt_lid_batch_prd_TextChanged(object sender, EventArgs e)
    {
        LookupLidBatchNo_Prd(txt_lid_batch_prd, txt_lid_info_prd, txt_lid_sap_prd);
    }

    #region PRD Head2 (장비 1대당 Head 2개 대응)

    protected void txt_sys1_batch_prd_h2_TextChanged(object sender, EventArgs e)
    {
        if (txt_sys1_batch_prd_h2.Text == "") { txt_sys1_info_prd_h2.Text = txt_sys1_sap_prd_h2.Text = string.Empty; return; }
        LookupSysBatchNo_Prd(txt_sys1_batch_prd_h2.Text, txt_sys1_info_prd_h2, txt_sys1_sap_prd_h2);
    }

    protected void txt_sys2_batch_prd_h2_TextChanged(object sender, EventArgs e)
    {
        if (txt_sys2_batch_prd_h2.Text == "") { txt_sys2_info_prd_h2.Text = txt_sys2_sap_prd_h2.Text = string.Empty; return; }
        LookupSysBatchNo_Prd(txt_sys2_batch_prd_h2.Text, txt_sys2_info_prd_h2, txt_sys2_sap_prd_h2);
    }

    protected void txt_sys3_batch_prd_h2_TextChanged(object sender, EventArgs e)
    {
        if (txt_sys3_batch_prd_h2.Text == "") { txt_sys3_info_prd_h2.Text = txt_sys3_sap_prd_h2.Text = string.Empty; return; }
        LookupSysBatchNo_Prd(txt_sys3_batch_prd_h2.Text, txt_sys3_info_prd_h2, txt_sys3_sap_prd_h2);
    }

    protected void txt_sys4_batch_prd_h2_TextChanged(object sender, EventArgs e)
    {
        if (txt_sys4_batch_prd_h2.Text == "") { txt_sys4_info_prd_h2.Text = txt_sys4_sap_prd_h2.Text = string.Empty; return; }
        LookupSysBatchNo_Prd(txt_sys4_batch_prd_h2.Text, txt_sys4_info_prd_h2, txt_sys4_sap_prd_h2);
    }

    protected void btn_sys1_na_prd_h2_Click(object sender, EventArgs e) { txt_sys1_batch_prd_h2.Text = "N/A"; txt_sys1_info_prd_h2.Text = txt_sys1_sap_prd_h2.Text = string.Empty; }
    protected void btn_sys2_na_prd_h2_Click(object sender, EventArgs e) { txt_sys2_batch_prd_h2.Text = "N/A"; txt_sys2_info_prd_h2.Text = txt_sys2_sap_prd_h2.Text = string.Empty; }
    protected void btn_sys3_na_prd_h2_Click(object sender, EventArgs e) { txt_sys3_batch_prd_h2.Text = "N/A"; txt_sys3_info_prd_h2.Text = txt_sys3_sap_prd_h2.Text = string.Empty; }
    protected void btn_sys4_na_prd_h2_Click(object sender, EventArgs e) { txt_sys4_batch_prd_h2.Text = "N/A"; txt_sys4_info_prd_h2.Text = txt_sys4_sap_prd_h2.Text = string.Empty; }

    protected void txt_lid_batch_prd_h2_TextChanged(object sender, EventArgs e)
    {
        LookupLidBatchNo_Prd(txt_lid_batch_prd_h2, txt_lid_info_prd_h2, txt_lid_sap_prd_h2);
    }

    #endregion

    protected void btn_save_prd_Click(object sender, EventArgs e)
    {
        if (ddl_McNo_prd.SelectedItem == null || ddl_McNo_prd.SelectedItem.Value == string.Empty)
        {
            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "ERROR", "alert('저장 실패! (MC ID 확인)');", true);
            return;
        }
        try
        {
            bool isSetUp = ddl_SheetType_prd.SelectedItem.Text == "Set-Up";
            string connStr = conn.GetConnectionString(DatabaseInfo.SCK_RTS);
            using (OracleHelper oraObj = new OracleHelper(connStr))
            {
                string SQL = "INSERT INTO RTS.LDA_ELOGSHEET" +
                    " (SEQ, ELOGSHEET_TYPE, SHEET_TYPE, SHIFT, INPUT_TIME, LOT_ID, CUST_NAME, PKG, LEAD, CUST_DEVICE, NICK, QTY," +
                    "  EQUIP_ID, OPER_CODE, RECIPE_NAME, AI_NO, USER_ID," +
                    "  SYS1_INFO, SYS1_BATCH_NO, SYS1_SAP_CODE, SYS1_EXPIRE_TIME," +
                    "  SYS1_INFO_2, SYS1_BATCH_NO_2, SYS1_SAP_CODE_2, SYS1_EXPIRE_TIME_2," +
                    "  SYS2_INFO, SYS2_BATCH_NO, SYS2_SAP_CODE, SYS2_EXPIRE_TIME," +
                    "  SYS2_INFO_2, SYS2_BATCH_NO_2, SYS2_SAP_CODE_2, SYS2_EXPIRE_TIME_2," +
                    "  SYS3_INFO, SYS3_BATCH_NO, SYS3_SAP_CODE, SYS3_EXPIRE_TIME," +
                    "  SYS3_INFO_2, SYS3_BATCH_NO_2, SYS3_SAP_CODE_2, SYS3_EXPIRE_TIME_2," +
                    "  SYS4_INFO, SYS4_BATCH_NO, SYS4_SAP_CODE, SYS4_EXPIRE_TIME," +
                    "  SYS4_INFO_2, SYS4_BATCH_NO_2, SYS4_SAP_CODE_2, SYS4_EXPIRE_TIME_2," +
                    "  SYS5_INFO, SYS5_BATCH_NO, SYS5_SAP_CODE, SYS5_EXPIRE_TIME," +
                    "  SYS5_INFO_2, SYS5_BATCH_NO_2, SYS5_SAP_CODE_2, SYS5_EXPIRE_TIME_2," +
                    "  SYS1_NEEDLE_SN, SYS1_NEEDLE_SIZE, SYS2_NEEDLE_SN, SYS2_NEEDLE_SIZE," +
                    "  SYS1_DISPENSING_PATTERN, SYS2_DISPENSING_PATTERN, COVERAGE_DETACH, TILT_PROD, POSITION_PROD," +
                    "  REMARK, CREATED_TIME)" +
                    " VALUES" +
                    " (RTS.LDA_ELOGSHEET_SEQ.NEXTVAL, 'PROD', :SHEET_TYPE, :SHIFT, TO_DATE(:INPUT_TIME,'YYYY-MM-DD HH24:MI:SS')," +
                    "  :LOT_ID, :CUST_NAME, :PKG, :LEAD, :CUST_DEVICE, :NICK, :QTY," +
                    "  :EQUIP_ID, :OPER_CODE, :RECIPE_NAME, :AI_NO, :USER_ID," +
                    "  :SYS1_INFO, :SYS1_BATCH_NO, :SYS1_SAP_CODE, :SYS1_EXPIRE_TIME," +
                    "  :SYS1_INFO_2, :SYS1_BATCH_NO_2, :SYS1_SAP_CODE_2, :SYS1_EXPIRE_TIME_2," +
                    "  :SYS2_INFO, :SYS2_BATCH_NO, :SYS2_SAP_CODE, :SYS2_EXPIRE_TIME," +
                    "  :SYS2_INFO_2, :SYS2_BATCH_NO_2, :SYS2_SAP_CODE_2, :SYS2_EXPIRE_TIME_2," +
                    "  :SYS3_INFO, :SYS3_BATCH_NO, :SYS3_SAP_CODE, :SYS3_EXPIRE_TIME," +
                    "  :SYS3_INFO_2, :SYS3_BATCH_NO_2, :SYS3_SAP_CODE_2, :SYS3_EXPIRE_TIME_2," +
                    "  :SYS4_INFO, :SYS4_BATCH_NO, :SYS4_SAP_CODE, :SYS4_EXPIRE_TIME," +
                    "  :SYS4_INFO_2, :SYS4_BATCH_NO_2, :SYS4_SAP_CODE_2, :SYS4_EXPIRE_TIME_2," +
                    "  :SYS5_INFO, :SYS5_BATCH_NO, :SYS5_SAP_CODE, :SYS5_EXPIRE_TIME," +
                    "  :SYS5_INFO_2, :SYS5_BATCH_NO_2, :SYS5_SAP_CODE_2, :SYS5_EXPIRE_TIME_2," +
                    "  :SYS1_NEEDLE_SN, :SYS1_NEEDLE_SIZE, :SYS2_NEEDLE_SN, :SYS2_NEEDLE_SIZE," +
                    "  :SYS1_DISPENSING_PATTERN, :SYS2_DISPENSING_PATTERN, :COVERAGE_DETACH, :TILT_PROD, :POSITION_PROD," +
                    "  :REMARK, sysdate)";

                oraObj.setCommandText(SQL);
                oraObj.AddParameter(new OracleParameter("SHEET_TYPE", ddl_SheetType_prd.SelectedItem.Text));
                oraObj.AddParameter(new OracleParameter("SHIFT", ddl_Shift_prd.SelectedItem.Text));
                oraObj.AddParameter(new OracleParameter("INPUT_TIME", tp_InputTime_prod.DateInput.DisplayText));
                oraObj.AddParameter(new OracleParameter("LOT_ID", txt_LotId_prd.Text));
                oraObj.AddParameter(new OracleParameter("CUST_NAME", txt_Cust_prd.Text));
                oraObj.AddParameter(new OracleParameter("PKG", txt_Pkg_prd.Text));
                oraObj.AddParameter(new OracleParameter("LEAD", txt_Lead_prd.Text));
                oraObj.AddParameter(new OracleParameter("CUST_DEVICE", txt_Device_prd.Text));
                oraObj.AddParameter(new OracleParameter("NICK", txt_Nick_prd.Text));
                oraObj.AddParameter(new OracleParameter("QTY", txt_Qty_prd.Text));
                oraObj.AddParameter(new OracleParameter("EQUIP_ID", ddl_McNo_prd.SelectedItem.Value));
                oraObj.AddParameter(new OracleParameter("OPER_CODE", txt_OperCode_prd.Text));
                oraObj.AddParameter(new OracleParameter("RECIPE_NAME", txt_RecipeName_prd.Text));
                oraObj.AddParameter(new OracleParameter("AI_NO", txt_ai_prd.Text));
                oraObj.AddParameter(new OracleParameter("USER_ID", Session["USER_NAME"].ToString().Trim()));
                // System1 (Head1 / Head2)
                oraObj.AddParameter(new OracleParameter("SYS1_INFO", txt_sys1_info_prd.Text));
                oraObj.AddParameter(new OracleParameter("SYS1_BATCH_NO", txt_sys1_batch_prd.Text));
                oraObj.AddParameter(new OracleParameter("SYS1_SAP_CODE", txt_sys1_sap_prd.Text));
                oraObj.AddParameter(new OracleParameter("SYS1_EXPIRE_TIME", tp_sys1_expire_prd.DateInput.DisplayText));
                oraObj.AddParameter(new OracleParameter("SYS1_INFO_2", txt_sys1_info_prd_h2.Text));
                oraObj.AddParameter(new OracleParameter("SYS1_BATCH_NO_2", txt_sys1_batch_prd_h2.Text));
                oraObj.AddParameter(new OracleParameter("SYS1_SAP_CODE_2", txt_sys1_sap_prd_h2.Text));
                oraObj.AddParameter(new OracleParameter("SYS1_EXPIRE_TIME_2", tp_sys1_expire_prd_h2.DateInput.DisplayText));
                // System2 (Head1 / Head2)
                oraObj.AddParameter(new OracleParameter("SYS2_INFO", txt_sys2_info_prd.Text));
                oraObj.AddParameter(new OracleParameter("SYS2_BATCH_NO", txt_sys2_batch_prd.Text));
                oraObj.AddParameter(new OracleParameter("SYS2_SAP_CODE", txt_sys2_sap_prd.Text));
                oraObj.AddParameter(new OracleParameter("SYS2_EXPIRE_TIME", tp_sys2_expire_prd.DateInput.DisplayText));
                oraObj.AddParameter(new OracleParameter("SYS2_INFO_2", txt_sys2_info_prd_h2.Text));
                oraObj.AddParameter(new OracleParameter("SYS2_BATCH_NO_2", txt_sys2_batch_prd_h2.Text));
                oraObj.AddParameter(new OracleParameter("SYS2_SAP_CODE_2", txt_sys2_sap_prd_h2.Text));
                oraObj.AddParameter(new OracleParameter("SYS2_EXPIRE_TIME_2", tp_sys2_expire_prd_h2.DateInput.DisplayText));
                // System3 (Head1 / Head2)
                oraObj.AddParameter(new OracleParameter("SYS3_INFO", txt_sys3_info_prd.Text));
                oraObj.AddParameter(new OracleParameter("SYS3_BATCH_NO", txt_sys3_batch_prd.Text));
                oraObj.AddParameter(new OracleParameter("SYS3_SAP_CODE", txt_sys3_sap_prd.Text));
                oraObj.AddParameter(new OracleParameter("SYS3_EXPIRE_TIME", tp_sys3_expire_prd.DateInput.DisplayText));
                oraObj.AddParameter(new OracleParameter("SYS3_INFO_2", txt_sys3_info_prd_h2.Text));
                oraObj.AddParameter(new OracleParameter("SYS3_BATCH_NO_2", txt_sys3_batch_prd_h2.Text));
                oraObj.AddParameter(new OracleParameter("SYS3_SAP_CODE_2", txt_sys3_sap_prd_h2.Text));
                oraObj.AddParameter(new OracleParameter("SYS3_EXPIRE_TIME_2", tp_sys3_expire_prd_h2.DateInput.DisplayText));
                // System4 (Head1 / Head2)
                oraObj.AddParameter(new OracleParameter("SYS4_INFO", txt_sys4_info_prd.Text));
                oraObj.AddParameter(new OracleParameter("SYS4_BATCH_NO", txt_sys4_batch_prd.Text));
                oraObj.AddParameter(new OracleParameter("SYS4_SAP_CODE", txt_sys4_sap_prd.Text));
                oraObj.AddParameter(new OracleParameter("SYS4_EXPIRE_TIME", tp_sys4_expire_prd.DateInput.DisplayText));
                oraObj.AddParameter(new OracleParameter("SYS4_INFO_2", txt_sys4_info_prd_h2.Text));
                oraObj.AddParameter(new OracleParameter("SYS4_BATCH_NO_2", txt_sys4_batch_prd_h2.Text));
                oraObj.AddParameter(new OracleParameter("SYS4_SAP_CODE_2", txt_sys4_sap_prd_h2.Text));
                oraObj.AddParameter(new OracleParameter("SYS4_EXPIRE_TIME_2", tp_sys4_expire_prd_h2.DateInput.DisplayText));
                // Lid / System5 (Head1 / Head2) — Lid 는 SAP Code / Expire Time 항목이 원래 없다
                oraObj.AddParameter(new OracleParameter("SYS5_INFO", txt_lid_info_prd.Text));
                oraObj.AddParameter(new OracleParameter("SYS5_BATCH_NO", txt_lid_batch_prd.Text));
                oraObj.AddParameter(new OracleParameter("SYS5_SAP_CODE", txt_lid_sap_prd.Text));
                oraObj.AddParameter(new OracleParameter("SYS5_EXPIRE_TIME", tp_lid_expire_prd.DateInput.DisplayText));
                oraObj.AddParameter(new OracleParameter("SYS5_INFO_2", txt_lid_info_prd_h2.Text));
                oraObj.AddParameter(new OracleParameter("SYS5_BATCH_NO_2", txt_lid_batch_prd_h2.Text));
                oraObj.AddParameter(new OracleParameter("SYS5_SAP_CODE_2", txt_lid_sap_prd_h2.Text));
                oraObj.AddParameter(new OracleParameter("SYS5_EXPIRE_TIME_2", tp_lid_expire_prd_h2.DateInput.DisplayText));
                // Needle (Set-Up only)
                oraObj.AddParameter(new OracleParameter("SYS1_NEEDLE_SN", isSetUp ? txt_tim_needle_sn_prd.Text : string.Empty));
                oraObj.AddParameter(new OracleParameter("SYS1_NEEDLE_SIZE", isSetUp ? txt_tim_needle_size_prd.Text : string.Empty));
                oraObj.AddParameter(new OracleParameter("SYS2_NEEDLE_SN", isSetUp ? txt_glue_needle_sn_prd.Text : string.Empty));
                oraObj.AddParameter(new OracleParameter("SYS2_NEEDLE_SIZE", isSetUp ? txt_glue_needle_size_prd.Text : string.Empty));
                // Visual Defect
                oraObj.AddParameter(new OracleParameter("SYS1_DISPENSING_PATTERN", ddl_tim_dispensing_pattern.SelectedItem.Text));
                oraObj.AddParameter(new OracleParameter("SYS2_DISPENSING_PATTERN", ddl_epoxy_dispensing_pattern.SelectedItem.Text));
                oraObj.AddParameter(new OracleParameter("COVERAGE_DETACH", isSetUp ? ddl_coverage_detach.SelectedItem.Text : string.Empty));
                oraObj.AddParameter(new OracleParameter("TILT_PROD", isSetUp ? ddl_mesurement_tilt_prd.SelectedItem.Text : string.Empty));
                oraObj.AddParameter(new OracleParameter("POSITION_PROD", isSetUp ? ddl_mesurement_position_prd.SelectedItem.Text : string.Empty));
                oraObj.AddParameter(new OracleParameter("REMARK", txt_mesurement_remark_prd.Text));

                int iResult = oraObj.ExecuteNonQueryWithParams();

                // LDA_BUYOFF 동시 INSERT
                using (OracleHelper oraObj2 = new OracleHelper(connStr))
                {
                    string SQL2 = "INSERT INTO RTS.LDA_BUYOFF (SEQ, INPUT_TIME, LOT_ID, CUSTOMER, DEVICE, LEAD, PKG, AI_NO, USER_ID, SHIFT, OPER_CD, CREATED_TIME)" +
                                  " VALUES (RTS.LDA_BUYOFF_SEQ.NEXTVAL, TO_DATE(:INPUT_TIME,'YYYY-MM-DD HH24:MI:SS')," +
                                  " :LOT_ID, :CUSTOMER, :DEVICE, :LEAD, :PKG, :AI_NO, :USER_ID, :SHIFT, :OPER_CD, sysdate)";
                    oraObj2.setCommandText(SQL2);
                    oraObj2.AddParameter(new OracleParameter("INPUT_TIME", tp_InputTime_prod.DateInput.DisplayText));
                    oraObj2.AddParameter(new OracleParameter("LOT_ID", txt_LotId_prd.Text));
                    oraObj2.AddParameter(new OracleParameter("CUSTOMER", txt_Cust_prd.Text));
                    oraObj2.AddParameter(new OracleParameter("DEVICE", txt_Device_prd.Text));
                    oraObj2.AddParameter(new OracleParameter("LEAD", txt_Lead_prd.Text));
                    oraObj2.AddParameter(new OracleParameter("PKG", txt_Pkg_prd.Text));
                    oraObj2.AddParameter(new OracleParameter("AI_NO", txt_ai_prd.Text));
                    oraObj2.AddParameter(new OracleParameter("USER_ID", Session["USER_NAME"].ToString().Trim()));
                    oraObj2.AddParameter(new OracleParameter("SHIFT", ddl_Shift_prd.SelectedItem.Text));
                    oraObj2.AddParameter(new OracleParameter("OPER_CD", txt_OperCode_prd.Text));
                    iResult += oraObj2.ExecuteNonQueryWithParams();

                    if (iResult > 1) ShowAlert("저장 성공");
                    else ShowAlert("저장 실패");
                }
            }
        }
        catch (Exception ex) { ShowAlert("저장 실패: " + ex.Message); }
    }

    #endregion

    #region TECH Page

    protected void txt_LotId_tech_TextChanged(object sender, EventArgs e)
    {
        try
        {
            DataSet ds = Get_LotInfo(txt_LotId_tech.Text.ToUpper());
            if (ds.Tables[0].Rows.Count > 0)
                txt_LotId_tech.Text = ds.Tables[0].Rows[0][0].ToString();

            if (ds.Tables[1].Rows.Count > 0)
            {
                lotIdInfo.Visible = true;
                custId.InnerText = ds.Tables[1].Rows[0]["CUST_ID"].ToString();
                pkgId.InnerText = ds.Tables[1].Rows[0]["PKG_TYPE"].ToString();
                deviceId.InnerText = ds.Tables[1].Rows[0]["DEVICE"].ToString();
                leadId.InnerText = ds.Tables[1].Rows[0]["LEAD_COUNT"].ToString();
            }
            else
            {
                lotIdInfo.Visible = false;
                custId.InnerText = pkgId.InnerText = deviceId.InnerText = leadId.InnerText = string.Empty;
            }
        }
        catch { }
    }

    protected void btn_save_tech_Click(object sender, EventArgs e)
    {
        try
        {
            string connStr = conn.GetConnectionString(DatabaseInfo.SCK_RTS);
            using (OracleHelper oraObj = new OracleHelper(connStr))
            {
                string SQL = "INSERT INTO RTS.LDA_ELOGSHEET" +
                    " (SEQ, ELOGSHEET_TYPE, SHEET_TYPE, SHIFT, INPUT_TIME, LOT_ID, CUST_NAME, PKG, LEAD, CUST_DEVICE," +
                    "  EQUIP_ID, OPER_CODE, RECIPE_NAME, USER_ID, USER_NAME," +
                    "  TCARD_AND_AI_CHECK," +
                    "  PICKUP_TOOL," +
                    "  PCB_REVERSE_DETECT_CHECK, BONDING_FORCE, PCB_MAGAZINE_LOAD_UNLOAD_CHECK, DELAY_TIME," +
                    "  PCB_BACK_SIDE_SCRATCH_CHECK," +
                    "  PUSHER_POSITION_CHECK, MODE_2DID," +
                    "  CREATED_TIME)" +
                    " VALUES" +
                    " (RTS.LDA_ELOGSHEET_SEQ.NEXTVAL, 'TECH', 'TECH', :SHIFT, TO_DATE(:INPUT_TIME,'YYYY-MM-DD HH24:MI:SS')," +
                    "  :LOT_ID, :CUST_NAME, :PKG, :LEAD, :CUST_DEVICE," +
                    "  :EQUIP_ID, 'LDA', :RECIPE_NAME, :USER_ID, :USER_NAME," +
                    "  :TCARD_AND_AI_CHECK," +
                    "  :PICKUP_TOOL," +
                    "  :PCB_REVERSE_DETECT_CHECK, :BONDING_FORCE, :PCB_MAGAZINE_LOAD_UNLOAD_CHECK, :DELAY_TIME," +
                    "  :PCB_BACK_SIDE_SCRATCH_CHECK," +
                    "  :PUSHER_POSITION_CHECK, :MODE_2DID," +
                    "  sysdate)";

                oraObj.setCommandText(SQL);
                oraObj.AddParameter(new OracleParameter("SHIFT", ddl_Shift_tech.SelectedItem.Text));
                oraObj.AddParameter(new OracleParameter("INPUT_TIME", tp_InputTime_tech.DateInput.DisplayText));
                oraObj.AddParameter(new OracleParameter("LOT_ID", txt_LotId_tech.Text));
                oraObj.AddParameter(new OracleParameter("CUST_NAME", custId.InnerText));
                oraObj.AddParameter(new OracleParameter("PKG", pkgId.InnerText));
                oraObj.AddParameter(new OracleParameter("LEAD", leadId.InnerText));
                oraObj.AddParameter(new OracleParameter("CUST_DEVICE", deviceId.InnerText));
                oraObj.AddParameter(new OracleParameter("EQUIP_ID", ddl_eq_id_tech.SelectedItem == null ? "" : ddl_eq_id_tech.SelectedItem.Text));
                oraObj.AddParameter(new OracleParameter("RECIPE_NAME", txt_recipe_name_tech.Text));
                oraObj.AddParameter(new OracleParameter("USER_ID", Session["USER_NAME"].ToString().Trim()));
                oraObj.AddParameter(new OracleParameter("USER_NAME", Session["USER_DESC"].ToString().Trim()));
                oraObj.AddParameter(new OracleParameter("TCARD_AND_AI_CHECK", ddl_tcard_aicheck_tech.SelectedItem.Value));
                oraObj.AddParameter(new OracleParameter("PICKUP_TOOL", txt_pickup_tool_tech.Text));
                oraObj.AddParameter(new OracleParameter("PCB_REVERSE_DETECT_CHECK", ddl_pcb_reverse_detect_check_tech.SelectedItem.Value));
                oraObj.AddParameter(new OracleParameter("BONDING_FORCE", txt_bonding_force_tech.Text));
                oraObj.AddParameter(new OracleParameter("PCB_MAGAZINE_LOAD_UNLOAD_CHECK", ddl_pcb_magazine_load_unload_check_tech.SelectedItem.Value));
                oraObj.AddParameter(new OracleParameter("DELAY_TIME", txt_delay_time_tech.Text));
                oraObj.AddParameter(new OracleParameter("PCB_BACK_SIDE_SCRATCH_CHECK", ddl_pcb_back_side_scratch_check_tech.SelectedItem.Value));
                oraObj.AddParameter(new OracleParameter("PUSHER_POSITION_CHECK", ddl_pusher_position_check_tech.SelectedItem.Value));
                oraObj.AddParameter(new OracleParameter("MODE_2DID", ddl_2did_mode_tech.SelectedItem.Value));

                int iResult = oraObj.ExecuteNonQueryWithParams();
                if (iResult > 0) ShowAlert("저장 성공");
                else ShowAlert("저장 실패");
            }
        }
        catch (Exception ex) { ShowAlert("저장 실패: " + ex.Message); }
    }

    #endregion  

    #region QA Page

    protected void ddl_SheetType_qa_SelectedIndexChanged(object sender, DropDownListEventArgs e)
    {
        bool isSetUp = (sender as RadDropDownList).SelectedItem.Text == "Set-Up";
        title_material_information_qa.Visible = isSetUp;
        tb_material_information_qa.Visible = isSetUp;
        pnl_measure_setup_qa.Visible = isSetUp;
        pnl_measure_vm_qa.Visible = !isSetUp;

        if (!isSetUp)
        {
            txt_sys1_information_qa.Text = txt_sys2_information_qa.Text = txt_sys3_information_qa.Text = txt_sys4_information_qa.Text = txt_lid_information_qa.Text = string.Empty;
            txt_sys1_batch_no_qa.Text = txt_sys2_batch_no_qa.Text = txt_sys3_batch_no_qa.Text = txt_sys4_batch_no_qa.Text = txt_lid_batch_no_qa.Text = string.Empty;
            txt_sys1_sap_code_qa.Text = txt_sys2_sap_code_qa.Text = txt_sys3_sap_code_qa.Text = txt_sys4_sap_code_qa.Text = txt_lid_sap_code_qa.Text = string.Empty;
            tp_sys1_expire_time_qa.DateInput.DisplayText = string.Empty;
            tp_sys2_expire_time_qa.DateInput.DisplayText = string.Empty;
            tp_sys3_expire_time_qa.DateInput.DisplayText = string.Empty;
            tp_sys4_expire_time_qa.DateInput.DisplayText = string.Empty;
            tp_lid_expire_time_qa.DateInput.DisplayText = string.Empty;

            // Head2
            txt_sys1_information_qa_h2.Text = txt_sys2_information_qa_h2.Text = txt_sys3_information_qa_h2.Text = txt_sys4_information_qa_h2.Text = txt_lid_information_qa_h2.Text = string.Empty;
            txt_sys1_batch_no_qa_h2.Text = txt_sys2_batch_no_qa_h2.Text = txt_sys3_batch_no_qa_h2.Text = txt_sys4_batch_no_qa_h2.Text = txt_lid_batch_no_qa_h2.Text = string.Empty;
            txt_sys1_sap_code_qa_h2.Text = txt_sys2_sap_code_qa_h2.Text = txt_sys3_sap_code_qa_h2.Text = txt_sys4_sap_code_qa_h2.Text = txt_lid_sap_code_qa_h2.Text = string.Empty;
            tp_sys1_expire_time_qa_h2.DateInput.DisplayText = string.Empty;
            tp_sys2_expire_time_qa_h2.DateInput.DisplayText = string.Empty;
            tp_sys3_expire_time_qa_h2.DateInput.DisplayText = string.Empty;
            tp_sys4_expire_time_qa_h2.DateInput.DisplayText = string.Empty;
            tp_lid_expire_time_qa_h2.DateInput.DisplayText = string.Empty;
        }
    }

    protected void txt_LotId_qa_TextChanged(object sender, EventArgs e)
    {
        try
        {
            DataSet ds = Get_LotInfo(txt_LotId_qa.Text.ToUpper());
            if (ds.Tables[0].Rows.Count > 0)
                txt_LotId_qa.Text = ds.Tables[0].Rows[0][0].ToString();

            if (ds.Tables[1].Rows.Count > 0)
            {
                DataRow r = ds.Tables[1].Rows[0];
                txt_Pkg_qa.Text = string.IsNullOrWhiteSpace(r["PKG_TYPE"].ToString()) ? "." : r["PKG_TYPE"].ToString();
                txt_Lead_qa.Text = string.IsNullOrWhiteSpace(r["LEAD_COUNT"].ToString()) ? "." : r["LEAD_COUNT"].ToString();
                txt_Cust_qa.Text = string.IsNullOrWhiteSpace(r["CUST_ID"].ToString()) ? "." : r["CUST_ID"].ToString();
                txt_Device_qa.Text = string.IsNullOrWhiteSpace(r["DEVICE"].ToString()) ? "." : r["DEVICE"].ToString();
                txt_Nick_qa.Text = string.IsNullOrWhiteSpace(r["NICK"].ToString()) ? "." : r["NICK"].ToString();
                txt_Qty_qa.Text = string.IsNullOrWhiteSpace(r["QTY"].ToString()) ? "." : r["QTY"].ToString();
            }
            else
            {
                txt_Pkg_qa.Text = txt_Lead_qa.Text = txt_Cust_qa.Text =
                txt_Device_qa.Text = txt_Nick_qa.Text = txt_Qty_qa.Text = ".";
            }
        }
        catch { }
    }

    private void LookupSysBatchNo(string batchNo, TextBox txtInfo, TextBox txtSap)
    {
        if (txt_LotId_qa.Text == "")
        {
            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "ERROR", "alert('LOT ID를 먼저 입력하세요.');", true);
            return;
        }
        try
        {
            DataTable dtResult = GetMaterialInfo(txt_LotId_qa.Text, txt_OperCode_qa.Text, batchNo);
            if (dtResult != null && dtResult.Rows.Count == 1 && dtResult.Rows[0][0].ToString() == "Y")
            {
                DataTable dtResult2 = GetSapCodeByBatchNo(batchNo);
                DataTable dtResult3 = GetSapInfoByLotId(txt_LotId_qa.Text, dtResult2.Rows[0][0].ToString());
                if (dtResult3 != null && dtResult3.Rows.Count == 1)
                {
                    txtInfo.Text = dtResult3.Rows[0][4].ToString().Split('|')[1];
                    txtSap.Text = dtResult3.Rows[0][4].ToString().Split('|')[0];
                }
                else { txtInfo.Text = txtSap.Text = "ERROR"; }
            }
            else { txtInfo.Text = txtSap.Text = "ERROR"; }
        }
        catch { }
    }

    protected void txt_sys1_batch_no_qa_TextChanged(object sender, EventArgs e)
    {
        if (txt_sys1_batch_no_qa.Text == "") { txt_sys1_information_qa.Text = txt_sys1_sap_code_qa.Text = string.Empty; return; }
        LookupSysBatchNo(txt_sys1_batch_no_qa.Text, txt_sys1_information_qa, txt_sys1_sap_code_qa);
    }

    protected void txt_sys2_batch_no_qa_TextChanged(object sender, EventArgs e)
    {
        if (txt_sys2_batch_no_qa.Text == "") { txt_sys2_information_qa.Text = txt_sys2_sap_code_qa.Text = string.Empty; return; }
        LookupSysBatchNo(txt_sys2_batch_no_qa.Text, txt_sys2_information_qa, txt_sys2_sap_code_qa);
    }

    protected void txt_sys3_batch_no_qa_TextChanged(object sender, EventArgs e)
    {
        if (txt_sys3_batch_no_qa.Text == "") { txt_sys3_information_qa.Text = txt_sys3_sap_code_qa.Text = string.Empty; return; }
        LookupSysBatchNo(txt_sys3_batch_no_qa.Text, txt_sys3_information_qa, txt_sys3_sap_code_qa);
    }

    protected void txt_sys4_batch_no_qa_TextChanged(object sender, EventArgs e)
    {
        if (txt_sys4_batch_no_qa.Text == "") { txt_sys4_information_qa.Text = txt_sys4_sap_code_qa.Text = string.Empty; return; }
        LookupSysBatchNo(txt_sys4_batch_no_qa.Text, txt_sys4_information_qa, txt_sys4_sap_code_qa);
    }

    protected void btn_sys1_na_qa_Click(object sender, EventArgs e) { txt_sys1_batch_no_qa.Text = "N/A"; txt_sys1_information_qa.Text = txt_sys1_sap_code_qa.Text = string.Empty; }
    protected void btn_sys2_na_qa_Click(object sender, EventArgs e) { txt_sys2_batch_no_qa.Text = "N/A"; txt_sys2_information_qa.Text = txt_sys2_sap_code_qa.Text = string.Empty; }
    protected void btn_sys3_na_qa_Click(object sender, EventArgs e) { txt_sys3_batch_no_qa.Text = "N/A"; txt_sys3_information_qa.Text = txt_sys3_sap_code_qa.Text = string.Empty; }
    protected void btn_sys4_na_qa_Click(object sender, EventArgs e) { txt_sys4_batch_no_qa.Text = "N/A"; txt_sys4_information_qa.Text = txt_sys4_sap_code_qa.Text = string.Empty; }

    /// <summary>
    /// Lid Batch No 로 CIM_BATSAP 을 조회한다. System1~4 와 동일하게
    /// SAP Code = 자재 코드(MATL_CODE) 그대로, Information = ai_content 에서 찾은 설명으로 분리한다.
    /// </summary>
    private void LookupLidBatchNo_Qa(TextBox txtBatch, TextBox txtInfo, TextBox txtSap)
    {
        if (txt_LotId_qa.Text == "")
        {
            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "ERROR", "alert('LOT ID를 먼저 입력하세요.');", true);
            txtBatch.Text = "";
            return;
        }
        try
        {
            string BATCH = txtBatch.Text.ToUpper();
            if (BATCH.Contains("/")) BATCH = BATCH.Split('/')[1];

            DataTable batchID = GetHeatSinkBatchInfo(BATCH);
            if (batchID == null || batchID.Rows.Count == 0)
            {
                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "ERROR", "alert('잘못된 Lid BATCH NO 입니다.');", true);
                txtBatch.Text = string.Empty;
                txtInfo.Text = string.Empty;
                txtSap.Text = string.Empty;
                return;
            }
            txtBatch.Text = batchID.Rows[0]["BATCH_NO"].ToString();

            string matlCode = batchID.Rows[0]["MATL_CODE"].ToString();
            txtSap.Text = matlCode;

            DataTable dtInfo = GetSapInfoByLotId(txt_LotId_qa.Text, matlCode);
            txtInfo.Text = (dtInfo != null && dtInfo.Rows.Count > 0)
                ? dtInfo.Rows[0][4].ToString().Split('|')[1]
                : "ERROR";
        }
        catch
        {
            txtBatch.Text = string.Empty;
            txtInfo.Text = string.Empty;
            txtSap.Text = string.Empty;
        }
    }

    protected void txt_lid_batch_no_qa_TextChanged(object sender, EventArgs e)
    {
        LookupLidBatchNo_Qa(txt_lid_batch_no_qa, txt_lid_information_qa, txt_lid_sap_code_qa);
    }

    #region QA Head2 (장비 1대당 Head 2개 대응)

    protected void txt_sys1_batch_no_qa_h2_TextChanged(object sender, EventArgs e)
    {
        if (txt_sys1_batch_no_qa_h2.Text == "") { txt_sys1_information_qa_h2.Text = txt_sys1_sap_code_qa_h2.Text = string.Empty; return; }
        LookupSysBatchNo(txt_sys1_batch_no_qa_h2.Text, txt_sys1_information_qa_h2, txt_sys1_sap_code_qa_h2);
    }

    protected void txt_sys2_batch_no_qa_h2_TextChanged(object sender, EventArgs e)
    {
        if (txt_sys2_batch_no_qa_h2.Text == "") { txt_sys2_information_qa_h2.Text = txt_sys2_sap_code_qa_h2.Text = string.Empty; return; }
        LookupSysBatchNo(txt_sys2_batch_no_qa_h2.Text, txt_sys2_information_qa_h2, txt_sys2_sap_code_qa_h2);
    }

    protected void txt_sys3_batch_no_qa_h2_TextChanged(object sender, EventArgs e)
    {
        if (txt_sys3_batch_no_qa_h2.Text == "") { txt_sys3_information_qa_h2.Text = txt_sys3_sap_code_qa_h2.Text = string.Empty; return; }
        LookupSysBatchNo(txt_sys3_batch_no_qa_h2.Text, txt_sys3_information_qa_h2, txt_sys3_sap_code_qa_h2);
    }

    protected void txt_sys4_batch_no_qa_h2_TextChanged(object sender, EventArgs e)
    {
        if (txt_sys4_batch_no_qa_h2.Text == "") { txt_sys4_information_qa_h2.Text = txt_sys4_sap_code_qa_h2.Text = string.Empty; return; }
        LookupSysBatchNo(txt_sys4_batch_no_qa_h2.Text, txt_sys4_information_qa_h2, txt_sys4_sap_code_qa_h2);
    }

    protected void btn_sys1_na_qa_h2_Click(object sender, EventArgs e) { txt_sys1_batch_no_qa_h2.Text = "N/A"; txt_sys1_information_qa_h2.Text = txt_sys1_sap_code_qa_h2.Text = string.Empty; }
    protected void btn_sys2_na_qa_h2_Click(object sender, EventArgs e) { txt_sys2_batch_no_qa_h2.Text = "N/A"; txt_sys2_information_qa_h2.Text = txt_sys2_sap_code_qa_h2.Text = string.Empty; }
    protected void btn_sys3_na_qa_h2_Click(object sender, EventArgs e) { txt_sys3_batch_no_qa_h2.Text = "N/A"; txt_sys3_information_qa_h2.Text = txt_sys3_sap_code_qa_h2.Text = string.Empty; }
    protected void btn_sys4_na_qa_h2_Click(object sender, EventArgs e) { txt_sys4_batch_no_qa_h2.Text = "N/A"; txt_sys4_information_qa_h2.Text = txt_sys4_sap_code_qa_h2.Text = string.Empty; }

    protected void txt_lid_batch_no_qa_h2_TextChanged(object sender, EventArgs e)
    {
        LookupLidBatchNo_Qa(txt_lid_batch_no_qa_h2, txt_lid_information_qa_h2, txt_lid_sap_code_qa_h2);
    }

    #endregion

    protected void Recipe_Name_NA_Click(object sender, EventArgs e)
    {
        txt_Recipe_Name_qa.Text = "N/A";
    }

    protected void btn_save_qa_Click(object sender, EventArgs e)
    {
        try
        {
            bool isSetUp = ddl_SheetType_qa.SelectedItem.Text == "Set-Up";
            string connStr = conn.GetConnectionString(DatabaseInfo.SCK_RTS);
            using (OracleHelper oraObj = new OracleHelper(connStr))
            {
                string SQL = "INSERT INTO RTS.LDA_ELOGSHEET" +
                    " (SEQ, ELOGSHEET_TYPE, SHEET_TYPE, SHIFT, INPUT_TIME, LOT_ID, CUST_NAME, PKG, LEAD, CUST_DEVICE, NICK, QTY," +
                    "  EQUIP_ID, OPER_CODE, RECIPE_NAME, USER_ID," +
                    "  SYS1_INFO, SYS1_BATCH_NO, SYS1_SAP_CODE, SYS1_EXPIRE_TIME," +
                    "  SYS1_INFO_2, SYS1_BATCH_NO_2, SYS1_SAP_CODE_2, SYS1_EXPIRE_TIME_2," +
                    "  SYS2_INFO, SYS2_BATCH_NO, SYS2_SAP_CODE, SYS2_EXPIRE_TIME," +
                    "  SYS2_INFO_2, SYS2_BATCH_NO_2, SYS2_SAP_CODE_2, SYS2_EXPIRE_TIME_2," +
                    "  SYS3_INFO, SYS3_BATCH_NO, SYS3_SAP_CODE, SYS3_EXPIRE_TIME," +
                    "  SYS3_INFO_2, SYS3_BATCH_NO_2, SYS3_SAP_CODE_2, SYS3_EXPIRE_TIME_2," +
                    "  SYS4_INFO, SYS4_BATCH_NO, SYS4_SAP_CODE, SYS4_EXPIRE_TIME," +
                    "  SYS4_INFO_2, SYS4_BATCH_NO_2, SYS4_SAP_CODE_2, SYS4_EXPIRE_TIME_2," +
                    "  SYS5_INFO, SYS5_BATCH_NO, SYS5_SAP_CODE, SYS5_EXPIRE_TIME," +
                    "  SYS5_INFO_2, SYS5_BATCH_NO_2, SYS5_SAP_CODE_2, SYS5_EXPIRE_TIME_2," +
                    "  QA_SYS1_PATTERN, QA_SYS2_PATTERN, QA_DUMMY_COVERAGE, QA_DUMMY_COVERAGE_TYPE," +
                    "  QA_STRIP_NO, QA_VISUAL, QA_VISUAL_TYPE," +
                    "  BUY_OFF_RESULT, REMARK, CREATED_TIME)" +
                    " VALUES" +
                    " (RTS.LDA_ELOGSHEET_SEQ.NEXTVAL, 'QA', :SHEET_TYPE, :SHIFT, TO_DATE(:INPUT_TIME,'YYYY-MM-DD HH24:MI:SS')," +
                    "  :LOT_ID, :CUST_NAME, :PKG, :LEAD, :CUST_DEVICE, :NICK, :QTY," +
                    "  :EQUIP_ID, :OPER_CODE, :RECIPE_NAME, :USER_ID," +
                    "  :SYS1_INFO, :SYS1_BATCH_NO, :SYS1_SAP_CODE, :SYS1_EXPIRE_TIME," +
                    "  :SYS1_INFO_2, :SYS1_BATCH_NO_2, :SYS1_SAP_CODE_2, :SYS1_EXPIRE_TIME_2," +
                    "  :SYS2_INFO, :SYS2_BATCH_NO, :SYS2_SAP_CODE, :SYS2_EXPIRE_TIME," +
                    "  :SYS2_INFO_2, :SYS2_BATCH_NO_2, :SYS2_SAP_CODE_2, :SYS2_EXPIRE_TIME_2," +
                    "  :SYS3_INFO, :SYS3_BATCH_NO, :SYS3_SAP_CODE, :SYS3_EXPIRE_TIME," +
                    "  :SYS3_INFO_2, :SYS3_BATCH_NO_2, :SYS3_SAP_CODE_2, :SYS3_EXPIRE_TIME_2," +
                    "  :SYS4_INFO, :SYS4_BATCH_NO, :SYS4_SAP_CODE, :SYS4_EXPIRE_TIME," +
                    "  :SYS4_INFO_2, :SYS4_BATCH_NO_2, :SYS4_SAP_CODE_2, :SYS4_EXPIRE_TIME_2," +
                    "  :SYS5_INFO, :SYS5_BATCH_NO, :SYS5_SAP_CODE, :SYS5_EXPIRE_TIME," +
                    "  :SYS5_INFO_2, :SYS5_BATCH_NO_2, :SYS5_SAP_CODE_2, :SYS5_EXPIRE_TIME_2," +
                    "  :QA_SYS1_PATTERN, :QA_SYS2_PATTERN, :QA_DUMMY_COVERAGE, :QA_DUMMY_COVERAGE_TYPE," +
                    "  :QA_STRIP_NO, :QA_VISUAL, :QA_VISUAL_TYPE," +
                    "  :BUY_OFF_RESULT, :REMARK, sysdate)";

                oraObj.setCommandText(SQL);
                oraObj.AddParameter(new OracleParameter("SHEET_TYPE", ddl_SheetType_qa.SelectedItem.Text));
                oraObj.AddParameter(new OracleParameter("SHIFT", ddl_Shift_qa.SelectedItem.Text));
                oraObj.AddParameter(new OracleParameter("INPUT_TIME", tp_InputTime_qa.DateInput.DisplayText));
                oraObj.AddParameter(new OracleParameter("LOT_ID", txt_LotId_qa.Text));
                oraObj.AddParameter(new OracleParameter("CUST_NAME", txt_Cust_qa.Text));
                oraObj.AddParameter(new OracleParameter("PKG", txt_Pkg_qa.Text));
                oraObj.AddParameter(new OracleParameter("LEAD", txt_Lead_qa.Text));
                oraObj.AddParameter(new OracleParameter("CUST_DEVICE", txt_Device_qa.Text));
                oraObj.AddParameter(new OracleParameter("NICK", txt_Nick_qa.Text));
                oraObj.AddParameter(new OracleParameter("QTY", txt_Qty_qa.Text));
                oraObj.AddParameter(new OracleParameter("EQUIP_ID", txt_McNo_qa.Text));
                oraObj.AddParameter(new OracleParameter("OPER_CODE", txt_OperCode_qa.Text));
                oraObj.AddParameter(new OracleParameter("RECIPE_NAME", txt_Recipe_Name_qa.Text));
                oraObj.AddParameter(new OracleParameter("USER_ID", Session["USER_NAME"].ToString().Trim()));
                // System1 (Head1 / Head2)
                oraObj.AddParameter(new OracleParameter("SYS1_INFO", isSetUp ? txt_sys1_information_qa.Text : string.Empty));
                oraObj.AddParameter(new OracleParameter("SYS1_BATCH_NO", isSetUp ? txt_sys1_batch_no_qa.Text : string.Empty));
                oraObj.AddParameter(new OracleParameter("SYS1_SAP_CODE", isSetUp ? txt_sys1_sap_code_qa.Text : string.Empty));
                oraObj.AddParameter(new OracleParameter("SYS1_EXPIRE_TIME", isSetUp ? tp_sys1_expire_time_qa.DateInput.DisplayText : string.Empty));
                oraObj.AddParameter(new OracleParameter("SYS1_INFO_2", isSetUp ? txt_sys1_information_qa_h2.Text : string.Empty));
                oraObj.AddParameter(new OracleParameter("SYS1_BATCH_NO_2", isSetUp ? txt_sys1_batch_no_qa_h2.Text : string.Empty));
                oraObj.AddParameter(new OracleParameter("SYS1_SAP_CODE_2", isSetUp ? txt_sys1_sap_code_qa_h2.Text : string.Empty));
                oraObj.AddParameter(new OracleParameter("SYS1_EXPIRE_TIME_2", isSetUp ? tp_sys1_expire_time_qa_h2.DateInput.DisplayText : string.Empty));
                // System2 (PRD/QA 공유, Head1 / Head2)
                oraObj.AddParameter(new OracleParameter("SYS2_INFO", isSetUp ? txt_sys2_information_qa.Text : string.Empty));
                oraObj.AddParameter(new OracleParameter("SYS2_BATCH_NO", isSetUp ? txt_sys2_batch_no_qa.Text : string.Empty));
                oraObj.AddParameter(new OracleParameter("SYS2_SAP_CODE", isSetUp ? txt_sys2_sap_code_qa.Text : string.Empty));
                oraObj.AddParameter(new OracleParameter("SYS2_EXPIRE_TIME", isSetUp ? tp_sys2_expire_time_qa.DateInput.DisplayText : string.Empty));
                oraObj.AddParameter(new OracleParameter("SYS2_INFO_2", isSetUp ? txt_sys2_information_qa_h2.Text : string.Empty));
                oraObj.AddParameter(new OracleParameter("SYS2_BATCH_NO_2", isSetUp ? txt_sys2_batch_no_qa_h2.Text : string.Empty));
                oraObj.AddParameter(new OracleParameter("SYS2_SAP_CODE_2", isSetUp ? txt_sys2_sap_code_qa_h2.Text : string.Empty));
                oraObj.AddParameter(new OracleParameter("SYS2_EXPIRE_TIME_2", isSetUp ? tp_sys2_expire_time_qa_h2.DateInput.DisplayText : string.Empty));
                // System3 (Head1 / Head2)
                oraObj.AddParameter(new OracleParameter("SYS3_INFO", isSetUp ? txt_sys3_information_qa.Text : string.Empty));
                oraObj.AddParameter(new OracleParameter("SYS3_BATCH_NO", isSetUp ? txt_sys3_batch_no_qa.Text : string.Empty));
                oraObj.AddParameter(new OracleParameter("SYS3_SAP_CODE", isSetUp ? txt_sys3_sap_code_qa.Text : string.Empty));
                oraObj.AddParameter(new OracleParameter("SYS3_EXPIRE_TIME", isSetUp ? tp_sys3_expire_time_qa.DateInput.DisplayText : string.Empty));
                oraObj.AddParameter(new OracleParameter("SYS3_INFO_2", isSetUp ? txt_sys3_information_qa_h2.Text : string.Empty));
                oraObj.AddParameter(new OracleParameter("SYS3_BATCH_NO_2", isSetUp ? txt_sys3_batch_no_qa_h2.Text : string.Empty));
                oraObj.AddParameter(new OracleParameter("SYS3_SAP_CODE_2", isSetUp ? txt_sys3_sap_code_qa_h2.Text : string.Empty));
                oraObj.AddParameter(new OracleParameter("SYS3_EXPIRE_TIME_2", isSetUp ? tp_sys3_expire_time_qa_h2.DateInput.DisplayText : string.Empty));
                // System4 (Head1 / Head2)
                oraObj.AddParameter(new OracleParameter("SYS4_INFO", isSetUp ? txt_sys4_information_qa.Text : string.Empty));
                oraObj.AddParameter(new OracleParameter("SYS4_BATCH_NO", isSetUp ? txt_sys4_batch_no_qa.Text : string.Empty));
                oraObj.AddParameter(new OracleParameter("SYS4_SAP_CODE", isSetUp ? txt_sys4_sap_code_qa.Text : string.Empty));
                oraObj.AddParameter(new OracleParameter("SYS4_EXPIRE_TIME", isSetUp ? tp_sys4_expire_time_qa.DateInput.DisplayText : string.Empty));
                oraObj.AddParameter(new OracleParameter("SYS4_INFO_2", isSetUp ? txt_sys4_information_qa_h2.Text : string.Empty));
                oraObj.AddParameter(new OracleParameter("SYS4_BATCH_NO_2", isSetUp ? txt_sys4_batch_no_qa_h2.Text : string.Empty));
                oraObj.AddParameter(new OracleParameter("SYS4_SAP_CODE_2", isSetUp ? txt_sys4_sap_code_qa_h2.Text : string.Empty));
                oraObj.AddParameter(new OracleParameter("SYS4_EXPIRE_TIME_2", isSetUp ? tp_sys4_expire_time_qa_h2.DateInput.DisplayText : string.Empty));
                // Lid / System5 (Head1 / Head2) — Lid 는 SAP Code / Expire Time 항목이 원래 없다
                oraObj.AddParameter(new OracleParameter("SYS5_INFO", isSetUp ? txt_lid_information_qa.Text : string.Empty));
                oraObj.AddParameter(new OracleParameter("SYS5_BATCH_NO", isSetUp ? txt_lid_batch_no_qa.Text : string.Empty));
                oraObj.AddParameter(new OracleParameter("SYS5_SAP_CODE", isSetUp ? txt_lid_sap_code_qa.Text : string.Empty));
                oraObj.AddParameter(new OracleParameter("SYS5_EXPIRE_TIME", isSetUp ? tp_lid_expire_time_qa.DateInput.DisplayText : string.Empty));
                oraObj.AddParameter(new OracleParameter("SYS5_INFO_2", isSetUp ? txt_lid_information_qa_h2.Text : string.Empty));
                oraObj.AddParameter(new OracleParameter("SYS5_BATCH_NO_2", isSetUp ? txt_lid_batch_no_qa_h2.Text : string.Empty));
                oraObj.AddParameter(new OracleParameter("SYS5_SAP_CODE_2", isSetUp ? txt_lid_sap_code_qa_h2.Text : string.Empty));
                oraObj.AddParameter(new OracleParameter("SYS5_EXPIRE_TIME_2", isSetUp ? tp_lid_expire_time_qa_h2.DateInput.DisplayText : string.Empty));
                // Pattern / Measure
                oraObj.AddParameter(new OracleParameter("QA_SYS1_PATTERN", isSetUp ? ddl_tim_pattern_setup_qa.SelectedItem.Text : ddl_tim_pattern_vm_qa.SelectedItem.Text));
                oraObj.AddParameter(new OracleParameter("QA_SYS2_PATTERN", isSetUp ? ddl_glue_pattern_setup_qa.SelectedItem.Text : ddl_glue_pattern_vm_qa.SelectedItem.Text));
                oraObj.AddParameter(new OracleParameter("QA_DUMMY_COVERAGE", isSetUp ? txt_dummy_coverage_qa.Text : string.Empty));
                oraObj.AddParameter(new OracleParameter("QA_DUMMY_COVERAGE_TYPE", isSetUp ? ddl_detach_qa.SelectedItem.Text : string.Empty));
                oraObj.AddParameter(new OracleParameter("QA_STRIP_NO", !isSetUp ? txt_strip_no_qa.Text : string.Empty));
                oraObj.AddParameter(new OracleParameter("QA_VISUAL", !isSetUp ? txt_visual_qa.Text : string.Empty));
                oraObj.AddParameter(new OracleParameter("QA_VISUAL_TYPE", !isSetUp ? ddl_visual_type_qa.SelectedItem.Text : string.Empty));
                oraObj.AddParameter(new OracleParameter("BUY_OFF_RESULT", isSetUp ? ddl_buyoff_result_setup_qa.SelectedItem.Text : ddl_buyoff_result_vm_qa.SelectedItem.Text));
                oraObj.AddParameter(new OracleParameter("REMARK", isSetUp ? txt_remark_setup_qa.Text : txt_remark_vm_qa.Text));

                int iResult = oraObj.ExecuteNonQueryWithParams();
                if (iResult > 0) ShowAlert("저장 성공");
                else ShowAlert("저장 실패");
            }
        }
        catch (Exception ex) { ShowAlert("저장 실패: " + ex.Message); }
    }

    #endregion

    #region Searching

    protected void rb_prd_CheckedChanged(object sender, EventArgs e) { SwitchGridType("PROD"); }
    protected void rb_tech_CheckedChanged(object sender, EventArgs e) { SwitchGridType("TECH"); }
    protected void rb_qa_CheckedChanged(object sender, EventArgs e) { SwitchGridType("QA"); }

    private void SwitchGridType(string sheetType)
    {
        HiddenField1.Value = sheetType;
        Session["LDA_ELOG_GRID_TYPE"] = sheetType;
        BuildGridColumns(sheetType);
        rgv_List.MasterTableView.CurrentPageIndex = 0;
        rgv_List.Rebind();
    }

    /// <summary>조건 초기화 : 입력값을 모두 지우고 기본 기간으로 되돌린 뒤 다시 조회한다.</summary>
    protected void btn_option_reset_Click(object sender, EventArgs e)
    {
        date_from.SelectedDate = DateTime.Now.Date.AddDays(-5);
        date_to.SelectedDate = DateTime.Now.Date;

        txt_LotId_Search.Text = string.Empty;
        txt_McNo_Search.Text = string.Empty;
        txt_userId_Search.Text = string.Empty;
        txt_recipe_name_Search.Text = string.Empty;
        txt_custormer_Search.Text = string.Empty;
        txt_device_Search.Text = string.Empty;

        rgv_List.MasterTableView.CurrentPageIndex = 0;
        rgv_List.Rebind();
    }

    protected void btn_find_Click(object sender, EventArgs e)
    {
        // LOT ID 를 입력했을 때만 바코드 -> LOT ID 변환을 시도한다.
        // 미입력 상태에서 변환을 돌리면 그 결과가 LOT ID 조건으로 채워져 전체 조회가 되지 않는다.
        string lotId = txt_LotId_Search.Text.Trim().ToUpper();
        if (lotId.Length > 0)
        {
            try
            {
                DataSet ds = Get_LotInfo(lotId);
                if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
                {
                    string converted = ds.Tables[0].Rows[0][0].ToString().Trim();
                    if (converted.Length > 0) lotId = converted.ToUpper();
                }
            }
            catch { /* 변환 실패 시 입력한 값 그대로 조회한다 */ }
        }
        txt_LotId_Search.Text = lotId;

        rgv_List.MasterTableView.CurrentPageIndex = 0;
        rgv_List.Rebind();
    }

    protected void rgv_List_NeedDataSource(object source, GridNeedDataSourceEventArgs e)
    {
        try
        {
            rgv_List.DataSource = LDAElog_Open_Data(
                date_from.SelectedDate,     // 비우면 시작일 조건 없음 (전체 기간)
                date_to.SelectedDate,       // 비우면 종료일 조건 없음 (전체 기간)
                txt_LotId_Search.Text,
                txt_McNo_Search.Text,
                txt_userId_Search.Text,
                txt_recipe_name_Search.Text,
                txt_custormer_Search.Text,
                txt_device_Search.Text,
                GetCurrentGridType());
        }
        catch (Exception ex)
        {
            // 조회 실패를 조용히 삼키면 "결과 0건" 과 구분되지 않으므로 사유를 알린다.
            // 타입/InnerException 만으로 원인을 못 찾았으므로 이번엔 StackTrace 상위 몇 줄까지 보여준다
            // (StackTrace 맨 위가 실제로 예외가 던져진 지점에 가장 가깝다).
            rgv_List.DataSource = new DataTable();
            string detail = "조회 실패 [" + ex.GetType().Name + "]: " + ex.Message;
            if (ex.InnerException != null)
                detail += " / Inner[" + ex.InnerException.GetType().Name + "]: " + ex.InnerException.Message;
            if (!string.IsNullOrEmpty(ex.StackTrace))
            {
                string[] frames = ex.StackTrace.Split(new[] { "\r\n", "\n" }, StringSplitOptions.None);
                int take = Math.Min(frames.Length, 8);
                detail += "\n\n[StackTrace 상위 " + take + "줄]\n" + string.Join("\n", frames, 0, take);
            }
            ShowAlert(detail);
        }
    }

    /// <summary>
    /// 조회 조건으로 RTS.LDA_ELOGSHEET 를 검색한다.
    /// 입력하지 않은 조건은 WHERE 절에서 제외되므로, 아무것도 입력하지 않으면 전체가 조회된다.
    /// </summary>
    /// <summary>
    /// RTS.LDA_ELOGSHEET 의 전체 컬럼을 명시적으로 나열한 목록.
    /// SELECT * 를 쓰면 DbDataAdapter.Fill() 에서 IndexOutOfRangeException 이 재현되어
    /// (데이터가 0건인 상태에서도 발생 — 스키마 처리 단계의 문제로 판단) 명시적 컬럼 나열로 바꿨다.
    /// DataKeyNames="SEQ" 때문에 화면에 안 보이는 SEQ 도 반드시 포함해야 한다.
    /// 테이블에 컬럼을 추가/삭제하면 이 목록도 함께 갱신해야 한다.
    /// </summary>
    private const string SELECT_COLUMNS =
        "  SEQ, ELOGSHEET_TYPE, SHEET_TYPE, SHIFT, INPUT_TIME, LOT_ID," +
        "  CUST_NAME, PKG, LEAD, CUST_DEVICE, NICK, QTY," +
        "  EQUIP_ID, OPER_CODE, RECIPE_NAME, AI_NO, USER_ID, USER_NAME," +
        "  SYS2_INFO, SYS2_BATCH_NO, SYS2_SAP_CODE, SYS2_EXPIRE_TIME, SYS5_BATCH_NO, SYS1_DISPENSING_PATTERN," +
        "  SYS2_DISPENSING_PATTERN, COVERAGE_DETACH, TILT_PROD, POSITION_PROD, TCARD_AND_AI_CHECK, SYS1_NEEDLE_SN," +
        "  SYS1_NEEDLE_SIZE, SYS2_NEEDLE_SN, SYS2_NEEDLE_SIZE, PICKUP_TOOL, PCB_REVERSE_DETECT_CHECK, BONDING_FORCE," +
        "  DELAY_TIME, PCB_MAGAZINE_LOAD_UNLOAD_CHECK, MODE_2DID, SYS1_INFO, SYS1_BATCH_NO, SYS1_SAP_CODE," +
        "  SYS1_EXPIRE_TIME, SYS3_INFO, SYS3_BATCH_NO, SYS3_SAP_CODE, SYS3_EXPIRE_TIME, SYS4_INFO," +
        "  SYS4_BATCH_NO, SYS4_SAP_CODE, SYS4_EXPIRE_TIME, SYS5_INFO, SYS5_SAP_CODE, SYS5_EXPIRE_TIME, QA_SYS1_PATTERN, QA_SYS2_PATTERN," +
        "  QA_DUMMY_COVERAGE, QA_DUMMY_COVERAGE_TYPE, QA_STRIP_NO, QA_VISUAL, QA_VISUAL_TYPE, BUY_OFF_RESULT," +
        "  REMARK, CREATED_TIME, PCB_BACK_SIDE_SCRATCH_CHECK, PUSHER_POSITION_CHECK, SYS1_INFO_2, SYS1_BATCH_NO_2," +
        "  SYS1_SAP_CODE_2, SYS1_EXPIRE_TIME_2, SYS2_INFO_2, SYS2_BATCH_NO_2, SYS2_SAP_CODE_2, SYS2_EXPIRE_TIME_2," +
        "  SYS3_INFO_2, SYS3_BATCH_NO_2, SYS3_SAP_CODE_2, SYS3_EXPIRE_TIME_2, SYS4_INFO_2, SYS4_BATCH_NO_2," +
        "  SYS4_SAP_CODE_2, SYS4_EXPIRE_TIME_2, SYS5_INFO_2, SYS5_BATCH_NO_2, SYS5_SAP_CODE_2, SYS5_EXPIRE_TIME_2";

    public static DataTable LDAElog_Open_Data(DateTime? date_fr, DateTime? date_to,
        string lot_id, string mc_no, string userID, string recipe_name,
        string custormer, string device, string elogsheet)
    {
        string sheetType = (elogsheet ?? string.Empty).Trim();
        if (sheetType.Length == 0) sheetType = DEFAULT_ELOGSHEET_TYPE;

        // From / To 가 뒤집혀 들어오면 바로잡는다. (그대로 두면 무조건 0건)
        if (date_fr.HasValue && date_to.HasValue && date_fr.Value.Date > date_to.Value.Date)
        {
            DateTime swap = date_fr.Value;
            date_fr = date_to;
            date_to = swap;
        }

        string SQL = "SELECT " + SELECT_COLUMNS + " FROM RTS.LDA_ELOGSHEET WHERE ELOGSHEET_TYPE = " + ToSqlText(sheetType);

        // CREATED_TIME 에는 시분초가 들어있으므로 To 로 지정한 날짜의 하루 전체를 포함시킨다.
        if (date_fr.HasValue)
            SQL += " AND CREATED_TIME >= TO_DATE('" + date_fr.Value.ToString("yyyy-MM-dd") + "','YYYY-MM-DD')";
        if (date_to.HasValue)
            SQL += " AND CREATED_TIME < TO_DATE('" + date_to.Value.ToString("yyyy-MM-dd") + "','YYYY-MM-DD') + 1";

        SQL += ToLikeCondition("LOT_ID", lot_id);
        SQL += ToLikeCondition("EQUIP_ID", mc_no);
        SQL += ToLikeCondition("USER_ID", userID);
        SQL += ToLikeCondition("RECIPE_NAME", recipe_name);
        SQL += ToLikeCondition("CUST_NAME", custormer);
        SQL += ToLikeCondition("CUST_DEVICE", device);

        SQL += " ORDER BY CREATED_TIME DESC";

        // SQL_HELPER.SqlHelper.ExecuteDataset 대신, 이 파일의 다른 조회 메서드들
        // (GetHeatSinkBatchInfo 등)에서 이미 검증된 OracleConnection/OracleDataAdapter 패턴을 쓴다.
        DataTable dtReturn = new DataTable();
        using (OracleConnection oc = new OracleConnection(LibSys.SCK_RTS))
        {
            oc.Open();
            using (OracleDataAdapter da = new OracleDataAdapter(SQL, oc))
            {
                da.Fill(dtReturn);
            }
        }
        return dtReturn;
    }

    /// <summary>문자열을 SQL 리터럴로 만든다. (작은따옴표 이스케이프)</summary>
    private static string ToSqlText(string value)
    {
        return "'" + (value ?? string.Empty).Replace("'", "''") + "'";
    }

    /// <summary>
    /// 값이 있을 때만 LIKE 조건을 만든다. (값이 비어있으면 조건 자체를 걸지 않는다)
    /// 화면 입력칸은 CSS 로만 대문자로 보이고 실제 전송값은 소문자일 수 있으므로 UPPER 로 비교한다.
    /// </summary>
    private static string ToLikeCondition(string column, string value)
    {
        if (value == null) return string.Empty;

        string keyword = value.Trim();
        if (keyword.Length == 0) return string.Empty;

        return " AND UPPER(" + column + ") LIKE UPPER(" + ToSqlText("%" + keyword + "%") + ")";
    }

    protected void LinkButton_Click(object sender, EventArgs e)
    {
        DateTime date = DateTime.Now;
        rgv_List.ExportSettings.FileName = "LDAElog_" + date.ToString("yyyy-MM-dd HH-mm-ss");
        rgv_List.ExportSettings.Excel.Format = GridExcelExportFormat.ExcelML;
        rgv_List.ExportSettings.ExportOnlyData = true;
        rgv_List.ExportSettings.IgnorePaging = true;
        rgv_List.ExportSettings.OpenInNewWindow = true;
        rgv_List.MasterTableView.ExportToExcel();
    }

    protected void rgv_List_DeleteCommand(object source, GridCommandEventArgs e)
    {
        try
        {
            GridDataItem item = e.Item as GridDataItem;
            string seq = item.GetDataKeyValue("SEQ").ToString();

            OracleConnection oc = new OracleConnection(LibSys.SCK_RTS);
            oc.Open();
            string SQL = "DELETE FROM RTS.LDA_ELOGSHEET WHERE SEQ = '" + seq + "'";
            new OracleDataAdapter(SQL, oc).Fill(new DataTable());
            oc.Close();

            rgv_List.Rebind();
        }
        catch { }
    }

    #endregion

}
