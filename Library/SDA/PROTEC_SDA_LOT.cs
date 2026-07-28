using SCKIT.WebModule;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;

namespace SCKIT.Library.SDA
{
    public class PROTEC_SDA_LOT : Lot
    {
        protected override Dictionary<string, Substrate> SubstrateList
        {
            get
            {
                if (_substrateList == null) _substrateList = new Dictionary<string, Substrate>();
                if (_substrateList.Count == 0) getSubstListFromDB(typeof(PROTEC_SDA_Strip));
                return _substrateList;
            }
        }
        public PROTEC_SDA_LOT(string id, PROTEC_SDA_EQ eq)
            : base(id, eq)
        {
        }

        public string[] getSDATimMaterialListFromAI()
        {
            string[] itemIdList = new string[] { "sap_5978", "sap_5979", "sap_6013", "sap_352"};
            var l = WebModule.AIInterface.GetAIItem(AI_NO_INTR, "140", itemIdList);
            return l.Select(r => r["SAP_CODE"].ToString().Trim()).ToArray();
        }
        public string[] getSTATimMaterialListFromAI()
        {
            string[] itemIdList = new string[] { "sap_339", "sap_1196" };
            var l = WebModule.AIInterface.GetAIItem(AI_NO_INTR, "110", itemIdList);
            return l.Select(r => r["SAP_CODE"].ToString().Trim()).ToArray();
        }
        public string[] getSDAAdMaterialListFromAI()
        {
            string[] itemIdList = new string[] { "sap_350" , "sap_351", "sap_9121" };
            var l = WebModule.AIInterface.GetAIItem(AI_NO_INTR, "140", itemIdList);
            return l.Select(r => r["SAP_CODE"].ToString().Trim()).ToArray();
        }
        public string[] getSTAAdMaterialListFromAI()
        {
            string[] itemIdList = new string[] { "sap_339" };
            var l = WebModule.AIInterface.GetAIItem(AI_NO_INTR, "110", itemIdList);
            return l.Select(r => r["SAP_CODE"].ToString().Trim()).ToArray();
        }


        public string[] getStifferSapCodeList()
        {
            string[] itemIdList = new string[] { "sap_1191" };
            var l = WebModule.AIInterface.GetAIItem(AI_NO_INTR, "110", itemIdList);
            return l.Select(r => r["SAP_CODE"].ToString().Trim()).ToArray();
        }
        public string[] getSpreaderSapCodeList()
        {
            string[] itemIdList = new string[] { "sap_1190", "sap_6015", "sap_6016" };
            var l = WebModule.AIInterface.GetAIItem(AI_NO_INTR, "140", itemIdList);
            return l.Select(r => r["SAP_CODE"].ToString().Trim()).ToArray();
        }

        public dynamic getSDADispenserMaterial()
        {
            try
            {
                string[] itemIdList = new string[] { "sap_6485", "sap_6486", "sap_6487", "sap_6488" };
                var l = WebModule.AIInterface.GetAIItem(AI_NO_INTR, "140", itemIdList);
                return returnDispenseObject(l, itemIdList);
            }
            catch (Exception)
            {
                throw;
            }
        }
        public dynamic getSTADispenserMaterial()
        {
            try
            {
                string[] itemIdList = new string[] { "sap_6489", "sap_6490", "sap_6491", "sap_6492" };
                var l = WebModule.AIInterface.GetAIItem(AI_NO_INTR, "110", itemIdList);
                return returnDispenseObject(l, itemIdList);
            }
            catch (Exception)
            {
                throw;
            }
        }

        private dynamic returnDispenseObject(EnumerableRowCollection<DataRow> list, string[] itemIdList)
        {
            if (!list.Any(r => r["ITEM_ID"].ToString() == itemIdList[0])) throw new Exception($"Can't find DISPENSOR 1 item in AI");
            if (!list.Any(r => r["ITEM_ID"].ToString() == itemIdList[1])) throw new Exception($"Can't find DISPENSOR 2 item in AI");
            if (!list.Any(r => r["ITEM_ID"].ToString() == itemIdList[2])) throw new Exception($"Can't find DISPENSOR 3 item in AI");
            if (!list.Any(r => r["ITEM_ID"].ToString() == itemIdList[3])) throw new Exception($"Can't find DISPENSOR 4 item in AI");

            return new
            {
                DISPENSOR_1 = list.Where(r => r["ITEM_ID"].ToString() == itemIdList[0]).Select(r => r["SAP_CODE"].ToString().Trim()).First(),
                DISPENSOR_2 = list.Where(r => r["ITEM_ID"].ToString() == itemIdList[1]).Select(r => r["SAP_CODE"].ToString().Trim()).First(),
                DISPENSOR_3 = list.Where(r => r["ITEM_ID"].ToString() == itemIdList[2]).Select(r => r["SAP_CODE"].ToString().Trim()).First(),
                DISPENSOR_4 = list.Where(r => r["ITEM_ID"].ToString() == itemIdList[3]).Select(r => r["SAP_CODE"].ToString().Trim()).First()
            };
        }

        internal void InsertDB_lot_master(string eqId, string operId, string lotId, string lidid, string sapcode, string batchno)
        {
            try
            {
                bool result = false;
                Dictionary<string, object> param = new Dictionary<string, object>();

                string SQL = "INSERT INTO CRMS.T_SDA_LOT_LID_MAGAZINE (OPER_ID, EQUIP_ID, LOT_ID, LID_MAGAZINE_ID, SAP_CODE, BATCH_NO, CREATED_TIME) VALUES ( '{0}', '{1}', '{2}', '{3}', '{4}','{5}', SYSDATE )";
                SQL = string.Format(SQL, operId, eqId, lotId, lidid, sapcode, batchno);

                result = GlobalVariable.ExecuteSingleQuery(SQL, GlobalVariable.getIns().CONSTR_CRMS);
                EquipmentList.getInstance()[eqId].SystemLogger.Info("T_SDA_LOT_LID_MAGAZINE insert result :" + result.ToString());
            }
            catch (Exception ex)
            {
                EquipmentList.getInstance()[eqId].SystemLogger.Fatal(ex.Message + "-" + ex.StackTrace);
                throw ex;
            }

        }
        internal void InsertDB_dispenser_master(string oper, string eqId, string lotId, string dispensorNo, string valveNo, string weight1, string weight2, string weight3, string weight4, string weight5, string weight6)
        {
            try
            {
                bool result = false;
                Dictionary<string, object> param = new Dictionary<string, object>();

                string SQL = "INSERT INTO CRMS.T_SDA_M_WEIGHT (OPERATION, EQUIP_ID, LOT_ID, DISPENSER_NO, VALVE_NO, WEIGHT1, WEIGHT2, WEIGHT3, WEIGHT4, WEIGHT5, WEIGHT6, CREATED_TIME) VALUES ( '{0}', '{1}', '{2}', '{3}', '{4}','{5}','{6}','{7}','{8}','{9}','{10}', SYSDATE )";
                SQL = string.Format(SQL, oper, eqId, lotId, dispensorNo, valveNo, weight1, weight2, weight3, weight4, weight5, weight6);

                result = GlobalVariable.ExecuteSingleQuery(SQL, GlobalVariable.getIns().CONSTR_CRMS);
                EquipmentList.getInstance()[eqId].SystemLogger.Info("T_SDA_M_WEIGHT insert result :" + result.ToString());
            }
            catch (Exception ex)
            {
                EquipmentList.getInstance()[eqId].SystemLogger.Fatal(ex.Message + "-" + ex.StackTrace);
                throw ex;
            }

        }
    }
}
