using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SCKIT.Library.SDA
{
    public class PROTEC_SDA_UnitSummaryList : List<PROTEC_SDA_UnitSummary>
    {

        internal void InsertDB_unit_summary(string lotId, string eqId, string stripId, string ppId, string operId, string model)
        {
            try
            {
                if (model == "PRO2020NTW")
                {
                    foreach (var item in this)
                    {
                        string query = "RTS.P_SDA_UNIT_SUM_NTW_P";
                        Dictionary<string, string> inputParams = new Dictionary<string, string>();
                        inputParams.Add("P_EQUIP_ID", eqId);
                        inputParams.Add("P_LOT_ID", lotId);
                        inputParams.Add("P_BOAT_ID", stripId);
                        inputParams.Add("P_RECIPE_NM", ppId);
                        inputParams.Add("P_OPERATION", operId);
                        inputParams.Add("P_UNIT_ID", item.UNITID);
                        inputParams.Add("P_SLUG_ID", item.SLUGID);
                        inputParams.Add("P_X", item.COL.ToString());
                        inputParams.Add("P_Y", item.ROW.ToString());
                        inputParams.Add("P_BINCODE", item.BIN);
                        inputParams.Add("P_M_D1_E1", item.MATIDLIST[0]);
                        inputParams.Add("P_M_D1_E2", item.MATIDLIST[1]);
                        inputParams.Add("P_M_D2_E1", item.MATIDLIST[2]);
                        inputParams.Add("P_M_D2_E2", item.MATIDLIST[3]);
                        inputParams.Add("P_M_A1_HS1", item.MATIDLIST[4]);
                        inputParams.Add("P_M_A1_HS2", item.MATIDLIST[5]);
                        inputParams.Add("P_M_A1_HS3", item.MATIDLIST[6]);
                        inputParams.Add("P_M_A1_HS4", item.MATIDLIST[7]);
                        inputParams.Add("P_M_A2_HS1", item.MATIDLIST[8]);
                        inputParams.Add("P_M_A2_HS2", item.MATIDLIST[9]);
                        inputParams.Add("P_M_A2_HS3", item.MATIDLIST[10]);
                        inputParams.Add("P_M_A2_HS4", item.MATIDLIST[11]);

                        inputParams.Add("P_P_D1_E_WEIGHT", item.PARAMIDLIST[0]);
                        inputParams.Add("P_P_D2_E_WEIGHT", item.PARAMIDLIST[1]);
                        inputParams.Add("P_P_A1_GET_FORCE", item.PARAMIDLIST[2]);
                        inputParams.Add("P_P_A1_SET_TIME", item.PARAMIDLIST[3]);
                        inputParams.Add("P_P_A2_GET_FORCE", item.PARAMIDLIST[4]);
                        inputParams.Add("P_P_A2_SET_TIME", item.PARAMIDLIST[5]);
                        inputParams.Add("P_P_P1_GET_FORCE", item.PARAMIDLIST[6]);
                        inputParams.Add("P_P_P1_SET_TIME", item.PARAMIDLIST[7]);
                        inputParams.Add("P_P_P1_GET_BOTTOM_TEMP1", item.PARAMIDLIST[8]);
                        inputParams.Add("P_P_P1_GET_BOTTOM_TEMP2", item.PARAMIDLIST[9]);
                        inputParams.Add("P_P_P1_GET_BOTTOM_TEMP3", item.PARAMIDLIST[10]);
                        inputParams.Add("P_P_P1_GET_BOTTOM_TEMP4", item.PARAMIDLIST[11]);
                        inputParams.Add("P_P_P1_GET_TOP_TEMP1", item.PARAMIDLIST[12]);
                        inputParams.Add("P_P_P1_GET_TOP_TEMP2", item.PARAMIDLIST[13]);
                        inputParams.Add("P_P_P1_GET_TOP_TEMP3", item.PARAMIDLIST[14]);
                        inputParams.Add("P_P_P1_GET_TOP_TEMP4", item.PARAMIDLIST[15]);

                        inputParams.Add("P_T_D1_B_ID", item.TOOLIDLIST[0]);
                        inputParams.Add("P_T_D1_P1_ID", item.TOOLIDLIST[1]);
                        inputParams.Add("P_T_D1_P2_ID", item.TOOLIDLIST[2]);
                        inputParams.Add("P_T_D2_B_ID", item.TOOLIDLIST[3]);
                        inputParams.Add("P_T_D2_P1_ID", item.TOOLIDLIST[4]);
                        inputParams.Add("P_T_D2_P2_ID", item.TOOLIDLIST[5]);
                        inputParams.Add("P_T_A1_B_ID", item.TOOLIDLIST[6]);
                        inputParams.Add("P_T_A1_P_ID", item.TOOLIDLIST[7]);
                        inputParams.Add("P_T_A2_B_ID", item.TOOLIDLIST[8]);
                        inputParams.Add("P_T_A2_P_ID", item.TOOLIDLIST[9]);
                        inputParams.Add("P_T_P_TOP_B_ID", item.TOOLIDLIST[10]);
                        inputParams.Add("P_T_P_BOTTTOM_B_ID", item.TOOLIDLIST[11]);

                        Dictionary<string, string> outputParam =
                            GlobalVariable.ExecuteStoredProcedure(query, inputParams, new string[] { "P_RETURN_MSG" }, GlobalVariable.getIns().CONSTR_RTS);
                        if (outputParam["P_RETURN_MSG"].StartsWith("ER")) throw new Exception(outputParam["P_RETURN_MSG"]);

                        item.MATIDLIST.RemoveRange(0, 12);
                        item.PARAMIDLIST.RemoveRange(0, 16);
                        item.TOOLIDLIST.RemoveRange(0, 12);
                    }
                }
                else if (model == "PRO2020NTW-J")
                {
                    foreach (var item in this)
                    {
                        string query = "RTS.P_T_SDA_UNIT_SUMMARY_NTWJ";
                        Dictionary<string, string> inputParams = new Dictionary<string, string>();
                        inputParams.Add("P_EQUIP_ID", eqId);
                        inputParams.Add("P_LOT_ID", lotId);
                        inputParams.Add("P_BOAT_ID", stripId);
                        inputParams.Add("P_RECIPE_NM", ppId);
                        inputParams.Add("P_OPERATION", operId);
                        inputParams.Add("P_UNIT_ID", item.UNITID);
                        inputParams.Add("P_SLUG_ID", item.SLUGID);
                        inputParams.Add("P_X", item.COL.ToString());
                        inputParams.Add("P_Y", item.ROW.ToString());
                        inputParams.Add("P_BINCODE", item.BIN);
                        inputParams.Add("P_M_D1_E1", item.MATIDLIST[0]);
                        inputParams.Add("P_M_D1_E2", item.MATIDLIST[1]);
                        inputParams.Add("P_M_D2_E1", item.MATIDLIST[2]);
                        inputParams.Add("P_M_D2_E2", item.MATIDLIST[3]);
                        inputParams.Add("P_M_D3_E1", item.MATIDLIST[4]);
                        inputParams.Add("P_M_D3_E2", item.MATIDLIST[5]);
                        inputParams.Add("P_M_D4_E1", item.MATIDLIST[6]);
                        inputParams.Add("P_M_D4_E2", item.MATIDLIST[7]);
                        inputParams.Add("P_M_D5_E1", item.MATIDLIST[8]);
                        inputParams.Add("P_M_D5_E2", item.MATIDLIST[9]);
                        inputParams.Add("P_M_A_HS1", item.MATIDLIST[10]);
                        inputParams.Add("P_M_A_HS2", item.MATIDLIST[11]);
                        inputParams.Add("P_M_A_HS3", item.MATIDLIST[12]);
                        inputParams.Add("P_M_A_HS4", item.MATIDLIST[13]);
                        inputParams.Add("P_P_D1_E_WEIGHT", item.PARAMIDLIST[0]);
                        inputParams.Add("P_P_D2_E_WEIGHT", item.PARAMIDLIST[1]);
                        inputParams.Add("P_P_D3_E_WEIGHT", item.PARAMIDLIST[2]);
                        inputParams.Add("P_P_D4_E_WEIGHT", item.PARAMIDLIST[3]);
                        inputParams.Add("P_P_D5_E_WEIGHT", item.PARAMIDLIST[4]);
                        inputParams.Add("P_P_A_GET_FORCE", item.PARAMIDLIST[5]);
                        inputParams.Add("P_P_A_SET_TIME", item.PARAMIDLIST[6]);
                        inputParams.Add("P_P_P1_GET_FORCE", item.PARAMIDLIST[7]);
                        inputParams.Add("P_P_P1_SET_TIME", item.PARAMIDLIST[8]);
                        inputParams.Add("P_P_P1_GET_TOP_TEMP1", item.PARAMIDLIST[9]);
                        inputParams.Add("P_P_P1_GET_TOP_TEMP2", item.PARAMIDLIST[10]);
                        inputParams.Add("P_P_P1_GET_TOP_TEMP3", item.PARAMIDLIST[11]);
                        inputParams.Add("P_P_P1_GET_TOP_TEMP4", item.PARAMIDLIST[12]);
                        inputParams.Add("P_P_P1_GET_BOTTOM_TEMP1", item.PARAMIDLIST[13]);
                        inputParams.Add("P_P_P1_GET_BOTTOM_TEMP2", item.PARAMIDLIST[14]);
                        inputParams.Add("P_P_P1_GET_BOTTOM_TEMP3", item.PARAMIDLIST[15]);
                        inputParams.Add("P_P_P1_GET_BOTTOM_TEMP4", item.PARAMIDLIST[16]);
                        inputParams.Add("P_P_P2_GET_FORCE", item.PARAMIDLIST[17]);
                        inputParams.Add("P_P_P2_SET_TIME", item.PARAMIDLIST[18]);
                        inputParams.Add("P_P_P2_GET_TOP_TEMP1", item.PARAMIDLIST[19]);
                        inputParams.Add("P_P_P2_GET_TOP_TEMP2", item.PARAMIDLIST[20]);
                        inputParams.Add("P_P_P2_GET_TOP_TEMP3", item.PARAMIDLIST[21]);
                        inputParams.Add("P_P_P2_GET_TOP_TEMP4", item.PARAMIDLIST[22]);
                        inputParams.Add("P_P_P2_GET_BOTTOM_TEMP1", item.PARAMIDLIST[23]);
                        inputParams.Add("P_P_P2_GET_BOTTOM_TEMP2", item.PARAMIDLIST[24]);
                        inputParams.Add("P_P_P2_GET_BOTTOM_TEMP3", item.PARAMIDLIST[25]);
                        inputParams.Add("P_P_P2_GET_BOTTOM_TEMP4", item.PARAMIDLIST[26]);
                        inputParams.Add("P_T_D1_B_ID", item.TOOLIDLIST[0]);
                        inputParams.Add("P_T_D1_P1_ID", item.TOOLIDLIST[1]);
                        inputParams.Add("P_T_D1_P2_ID", item.TOOLIDLIST[2]);
                        inputParams.Add("P_T_D2_B_ID", item.TOOLIDLIST[3]);
                        inputParams.Add("P_T_D2_P1_ID", item.TOOLIDLIST[4]);
                        inputParams.Add("P_T_D2_P2_ID", item.TOOLIDLIST[5]);
                        inputParams.Add("P_T_D3_B_ID", item.TOOLIDLIST[6]);
                        inputParams.Add("P_T_D3_P1_ID", item.TOOLIDLIST[7]);
                        inputParams.Add("P_T_D3_P2_ID", item.TOOLIDLIST[8]);
                        inputParams.Add("P_T_D4_B_ID", item.TOOLIDLIST[9]);
                        inputParams.Add("P_T_D4_P1_ID", item.TOOLIDLIST[10]);
                        inputParams.Add("P_T_D4_P2_ID", item.TOOLIDLIST[11]);
                        inputParams.Add("P_T_D5_B_ID", item.TOOLIDLIST[12]);
                        inputParams.Add("P_T_D5_P1_ID", item.TOOLIDLIST[13]);
                        inputParams.Add("P_T_D5_P2_ID", item.TOOLIDLIST[14]);
                        inputParams.Add("P_T_INSPEC1_B_ID", item.TOOLIDLIST[15]);
                        inputParams.Add("P_T_A_B_ID", item.TOOLIDLIST[16]);
                        inputParams.Add("P_T_A_P1_ID", item.TOOLIDLIST[17]);
                        inputParams.Add("P_T_A_P2_ID", item.TOOLIDLIST[18]);
                        inputParams.Add("P_T_P1_B1_ID", item.TOOLIDLIST[19]);
                        inputParams.Add("P_T_P1_B2_ID", item.TOOLIDLIST[20]);
                        inputParams.Add("P_T_P2_B1_ID", item.TOOLIDLIST[21]);
                        inputParams.Add("P_T_P2_B2_ID", item.TOOLIDLIST[22]);
                        inputParams.Add("P_T_INSPEC2_B_ID", item.TOOLIDLIST[23]);

                        Dictionary<string, string> outputParam =
                            GlobalVariable.ExecuteStoredProcedure(query, inputParams, new string[] { "P_RETURN_MSG" }, GlobalVariable.getIns().CONSTR_RTS);
                        if (outputParam["P_RETURN_MSG"].StartsWith("ER")) throw new Exception(outputParam["P_RETURN_MSG"]);

                        item.MATIDLIST.RemoveRange(0, 14);
                        item.PARAMIDLIST.RemoveRange(0, 27);
                        item.TOOLIDLIST.RemoveRange(0, 24);
                    }
                }
            }
            catch (Exception ex)
            {
                EquipmentList.getInstance()[eqId].SystemLogger.Fatal(ex.Message + "-" + ex.StackTrace);
                throw ex;
            }
        }
    }

    public class PROTEC_SDA_UnitSummary
    {
        public string UNITID { get; private set; }
        public string SLUGID { get; private set; }
        public ulong COL { get; private set; }
        public ulong ROW { get; private set; }
        public string BIN { get; private set; }
        public List<string> MATIDLIST { get; private set; }
        public List<string> PARAMIDLIST { get; private set; }
        public List<string> TOOLIDLIST { get; private set; }

        public PROTEC_SDA_UnitSummary(ulong col, ulong row, string unitID, string slugid, string bin, List<string> MatIDList, List<string> ParamIDList, List<string> ToolIDList)
        {
            UNITID = unitID;
            SLUGID = slugid;
            COL = col;
            ROW = row;
            BIN = bin;
            MATIDLIST = MatIDList;
            PARAMIDLIST = ParamIDList;
            TOOLIDLIST = ToolIDList;
        }
    }
}
