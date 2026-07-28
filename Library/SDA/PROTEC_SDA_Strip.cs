using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;

namespace SCKIT.Library.SDA
{
    public class PROTEC_SDA_Strip : Strip
    {

        public PROTEC_SDA_Strip(string stripid, Equipment eq) : base(stripid, eq)
        {

        }

        internal void InsertDB_strip_master(string eqId, string operId, string lotId, string ppId, string nick)
        {
            try {
                bool result = false;
                Dictionary<string, object> param = new Dictionary<string, object>();

                string SQL = "INSERT INTO CRMS.T_SDA_M (OPER_ID, EQUIP_ID, LOT_ID, BOAT_ID, RECIPE_NM,NICK, CREATED_TIME) VALUES ( '{0}', '{1}', '{2}', '{3}', '{4}','{5}', SYSDATE )";
                SQL = string.Format(SQL, operId, eqId, lotId, ID, ppId, nick);

                result = GlobalVariable.ExecuteSingleQuery(SQL, GlobalVariable.getIns().CONSTR_CRMS);
                EquipmentList.getInstance()[eqId].SystemLogger.Info("T_SDA_M insert result :" + result.ToString());
            }
            catch (Exception ex)
            {
                EquipmentList.getInstance()[eqId].SystemLogger.Fatal(ex.Message + "-" + ex.StackTrace);
                throw ex;
            }

        }

    }
}
