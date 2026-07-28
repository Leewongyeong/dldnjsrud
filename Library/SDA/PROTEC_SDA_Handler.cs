using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using Dapper;
using Oracle.ManagedDataAccess.Client;
using SCKIT.SECSDriver.SECSMessage;
using SCKIT.SECSMessages;
using SCKIT.WebModule;

namespace SCKIT.Library.SDA
{
    public class PROTEC_SDA_Handler : SCKIT.Library.MessageHandler_Common
    {
        public PROTEC_SDA_Handler(Equipment eq)
            : base(eq)
        {
        }
        #region Send_Stream2

        // [SEND] [S2F41] [PP SELECT]
        private void Send_S2F41_PPSELECT(Recipe oRecipe)
        {
            try
            {
                string key = "S2F41_PPSELECT";
                string errMessage = string.Empty;
                StreamFunction sf = _EQ._SECSMSG_LIST.getMessage(this._EQ.getDeviceID(), key);
                sf.SystemByte = this._EQ.hsmsDriver.getNewSystemByte();
                sf.ExtraTag1 = oRecipe;
                if (sf == null)
                    throw new Exception("Can't find message which is " + key);
                else
                {
                    if (!sf.KeyItemList["PPID"].setValue(oRecipe.RECIPE_NAME, out errMessage))
                        throw new Exception(errMessage);
                    _EQ.AsyncSendandReceive(sf, CallBack_S2F41_PPSELECT);
                }
            }
            catch (Exception ex)
            {
                _EQ.SystemLogger.Error(ex, ex.Message, null);
                Send_S10F3(ex.Message);
            }
        }

        // [SEND] [S2F41] [START]
        protected void Send_S2F41_START(bool result, string lotId, Lot oLot, Recipe oRecipe, List<string> boatList)
        {
            string key = "S2F41_START";
            string errMessage = string.Empty;
            StreamFunction sf = _EQ._SECSMSG_LIST.getMessage(this._EQ.getDeviceID(), key);
            if (sf == null) throw new Exception("Can't find message which is " + key);
            else
            {
                sf.SystemByte = this._EQ.hsmsDriver.getNewSystemByte();
                sf.ExtraTag1 = oLot;
                if (!sf.KeyItemList["RESULT"].setValue(result.ToString(), out errMessage))
                    throw new Exception(errMessage);
                if (!sf.KeyItemList["LOT_ID"].setValue(oLot.BarCodeID, out errMessage))
                    throw new Exception(errMessage);
                if (!sf.KeyItemList["PPID"].setValue(oRecipe.RECIPE_NAME, out errMessage))
                    throw new Exception(errMessage);
                if (!sf.KeyItemList["QTY"].setValue(oLot.QTY.ToString(), out errMessage))
                    throw new Exception(errMessage);
                if (sf.KeyItemList["BOATLIST"] != null)
                {

                    foreach (var item in oLot.getSubstrateList<PROTEC_SDA_Strip>())
                    {
                        SECSItem boat = new SECSItem(ENUM_ITEM_FORMAT.ASCII);
                        boat.AddBody(item.ID);
                        sf.KeyItemList["BOATLIST"].AppendChild(boat);
                    }
                }

                _EQ.AsyncSendandReceive(sf, CallBack_S2F41_START);
            }
        }

        // [SEND] [S2F41] [BOAT VALIDATION]
        protected void Send_S2F41_BOAT_VALID(bool result, string boatId)
        {
            string key = "S2F41_BOAT_VALID";
            string errMessage = string.Empty;
            StreamFunction sf = _EQ._SECSMSG_LIST.getMessage(this._EQ.getDeviceID(), key);
            if (sf == null) throw new Exception("Can't find message which is " + key);
            else
            {
                sf.SystemByte = this._EQ.hsmsDriver.getNewSystemByte();
                if (!sf.KeyItemList["RESULT"].setValue(result.ToString(), out errMessage))
                    throw new Exception(errMessage);
                if (!sf.KeyItemList["BOAT_ID"].setValue(boatId.ToString(), out errMessage))
                    throw new Exception(errMessage);

                _EQ.AsyncSendandReceive(sf, null);

            }
        }

        // [SEND] [S2F41] [BOAT END VALIDATION (boat IN ID 와 boat END ID 비교하여 다르면 False ]
        protected void Send_S2F41_BOAT_END(bool result, string IN_boatId, string OUT_boatID)
        {
            string key = "S2F41_BOAT_END";
            string errMessage = string.Empty;
            StreamFunction sf = _EQ._SECSMSG_LIST.getMessage(this._EQ.getDeviceID(), key);
            if (sf == null) throw new Exception("Can't find message which is " + key);
            else
            {
                sf.SystemByte = this._EQ.hsmsDriver.getNewSystemByte();
                if (!sf.KeyItemList["RESULT"].setValue(result.ToString(), out errMessage))
                    throw new Exception(errMessage);
                if (!sf.KeyItemList["IN_BOAT_ID"].setValue(IN_boatId.ToString(), out errMessage))
                    throw new Exception(errMessage);
                if (!sf.KeyItemList["OUT_BOAT_ID"].setValue(OUT_boatID.ToString(), out errMessage))
                    throw new Exception(errMessage);

                _EQ.AsyncSendandReceive(sf, null);

            }
        }

        // [SEND] [S2F41] [TOOL VALIDATION]
        protected void Send_S2F41_TOOL_VALID(bool result, string resultdesc, object o, string tooltype)
        {
            string key = "S2F41_TOOL_VALID";
            string errMessage = string.Empty;
            StreamFunction sf = _EQ._SECSMSG_LIST.getMessage(this._EQ.getDeviceID(), key);

            if (sf == null) throw new Exception("Can't find message which is " + key);
            else
            {
                sf.SystemByte = this._EQ.hsmsDriver.getNewSystemByte();
                sf.ExtraTag1 = o;

                if (!sf.KeyItemList["RESULT"].setValue(result.ToString().ToUpper(), out errMessage))
                    throw new Exception(errMessage);
                if (!sf.KeyItemList["ERR_MSG"].setValue(resultdesc, out errMessage))
                    throw new Exception(errMessage);
                if (!sf.KeyItemList["TOOL_ID"].setValue(o.ToString(), out errMessage))
                    throw new Exception(errMessage);
                if (!sf.KeyItemList["TOOL_TYPE"].setValue(tooltype, out errMessage))
                    throw new Exception(errMessage);

                _EQ.AsyncSendandReceive(sf, null);
            }
        }
        protected void Send_S2F41_JIG_VALID(bool result, string JigId)
        {
            string key = "S2F41_JIG_VALID";
            string errMessage = string.Empty;
            StreamFunction sf = _EQ._SECSMSG_LIST.getMessage(this._EQ.getDeviceID(), key);

            if (sf == null) throw new Exception("Can't find message which is " + key);
            else
            {
                sf.SystemByte = this._EQ.hsmsDriver.getNewSystemByte();

                if (!sf.KeyItemList["RESULT"].setValue(result.ToString(), out errMessage))
                    throw new Exception(errMessage);
                if (!sf.KeyItemList["JIG_ID"].setValue(JigId.ToString(), out errMessage))
                    throw new Exception(errMessage);

                _EQ.AsyncSendandReceive(sf, null);
            }
        }
        // [SEND] [S2F41] [MATERIAL TIMER]
        protected void S2F41_MATERIAL_TIMER(string matId1, DateTime? timer1, string matId2, DateTime? timer2, string matId3, DateTime? timer3,
                                            string matId4, DateTime? timer4, string matId5, DateTime? timer5, string matId6, DateTime? timer6, object o, bool result)
        {
            string key = "S2F41_MATERIAL_TIMER";
            string errMessage = string.Empty;
            StreamFunction sf = _EQ._SECSMSG_LIST.getMessage(this._EQ.getDeviceID(), key);

            if (sf == null) throw new Exception("Can't find message which is " + key);
            else
            {
                sf.SystemByte = this._EQ.hsmsDriver.getNewSystemByte();
                sf.ExtraTag1 = o;

                if (!sf.KeyItemList["RESULT"].setValue(result.ToString().ToUpper(), out errMessage))
                    throw new Exception(errMessage);
                if (!sf.KeyItemList["MATL_ID_1ST"].setValue(matId1, out errMessage))
                    throw new Exception(errMessage);
                if (!sf.KeyItemList["EXPOSE_1ST"].setValue(timer1?.To14String() ?? "", out errMessage))
                    throw new Exception(errMessage);
                if (!sf.KeyItemList["MATL_ID_2ND"].setValue(matId2, out errMessage))
                    throw new Exception(errMessage);
                if (!sf.KeyItemList["EXPOSE_2ND"].setValue(timer2?.To14String() ?? "", out errMessage))
                    throw new Exception(errMessage);
                if (!sf.KeyItemList["MATL_ID_3RD"].setValue(matId3, out errMessage))
                    throw new Exception(errMessage);
                if (!sf.KeyItemList["EXPOSE_3RD"].setValue(timer3?.To14String() ?? "", out errMessage))
                    throw new Exception(errMessage);
                if (!sf.KeyItemList["MATL_ID_4TH"].setValue(matId4, out errMessage))
                    throw new Exception(errMessage);
                if (!sf.KeyItemList["EXPOSE_4TH"].setValue(timer4?.To14String() ?? "", out errMessage))
                    throw new Exception(errMessage);
                if (!sf.KeyItemList["MATL_ID_5TH"].setValue(matId5, out errMessage))
                    throw new Exception(errMessage);
                if (!sf.KeyItemList["EXPOSE_5TH"].setValue(timer5?.To14String() ?? "", out errMessage))
                    throw new Exception(errMessage);
                if (!sf.KeyItemList["MATL_ID_6TH"].setValue(matId6, out errMessage))
                    throw new Exception(errMessage);
                if (!sf.KeyItemList["EXPOSE_6TH"].setValue(timer6?.To14String() ?? "", out errMessage))
                    throw new Exception(errMessage);

                _EQ.AsyncSendandReceive(sf, null);
            }
        }
        protected void S2F41_MATERIAL_TIMER(string matId1, DateTime? timer1, string matId2, DateTime? timer2, string matId3, DateTime? timer3,
            string matId4, DateTime? timer4, string matId5, DateTime? timer5, string matId6, DateTime? timer6,
            string matId7, DateTime? timer7, string matId8, DateTime? timer8, string matId9, DateTime? timer9, string matId10, DateTime? timer10, object o, bool result)
        {
            string key = "S2F41_MATERIAL_TIMER";
            string errMessage = string.Empty;
            StreamFunction sf = _EQ._SECSMSG_LIST.getMessage(this._EQ.getDeviceID(), key);

            if (sf == null) throw new Exception("Can't find message which is " + key);
            else
            {
                sf.SystemByte = this._EQ.hsmsDriver.getNewSystemByte();
                sf.ExtraTag1 = o;

                if (!sf.KeyItemList["RESULT"].setValue(result.ToString().ToUpper(), out errMessage))
                    throw new Exception(errMessage);
                if (!sf.KeyItemList["MATL_ID_1ST"].setValue(matId1, out errMessage))
                    throw new Exception(errMessage);
                if (!sf.KeyItemList["EXPOSE_1ST"].setValue(timer1?.ToString() ?? "", out errMessage))
                    throw new Exception(errMessage);
                if (!sf.KeyItemList["MATL_ID_2ND"].setValue(matId2, out errMessage))
                    throw new Exception(errMessage);
                if (!sf.KeyItemList["EXPOSE_2ND"].setValue(timer2?.ToString() ?? "", out errMessage))
                    throw new Exception(errMessage);
                if (!sf.KeyItemList["MATL_ID_3RD"].setValue(matId3, out errMessage))
                    throw new Exception(errMessage);
                if (!sf.KeyItemList["EXPOSE_3RD"].setValue(timer3?.ToString() ?? "", out errMessage))
                    throw new Exception(errMessage);
                if (!sf.KeyItemList["MATL_ID_4TH"].setValue(matId4, out errMessage))
                    throw new Exception(errMessage);
                if (!sf.KeyItemList["EXPOSE_4TH"].setValue(timer4?.ToString() ?? "", out errMessage))
                    throw new Exception(errMessage);
                if (!sf.KeyItemList["MATL_ID_5TH"].setValue(matId5, out errMessage))
                    throw new Exception(errMessage);
                if (!sf.KeyItemList["EXPOSE_5TH"].setValue(timer5?.ToString() ?? "", out errMessage))
                    throw new Exception(errMessage);
                if (!sf.KeyItemList["MATL_ID_6TH"].setValue(matId6, out errMessage))
                    throw new Exception(errMessage);
                if (!sf.KeyItemList["EXPOSE_6TH"].setValue(timer6?.ToString() ?? "", out errMessage))
                    throw new Exception(errMessage);
                if (!sf.KeyItemList["MATL_ID_7TH"].setValue(matId7, out errMessage))
                    throw new Exception(errMessage);
                if (!sf.KeyItemList["EXPOSE_7TH"].setValue(timer7?.ToString() ?? "", out errMessage))
                    throw new Exception(errMessage);
                if (!sf.KeyItemList["MATL_ID_8TH"].setValue(matId8, out errMessage))
                    throw new Exception(errMessage);
                if (!sf.KeyItemList["EXPOSE_8TH"].setValue(timer8?.ToString() ?? "", out errMessage))
                    throw new Exception(errMessage);
                if (!sf.KeyItemList["MATL_ID_9TH"].setValue(matId9, out errMessage))
                    throw new Exception(errMessage);
                if (!sf.KeyItemList["EXPOSE_9TH"].setValue(timer9?.ToString() ?? "", out errMessage))
                    throw new Exception(errMessage);
                if (!sf.KeyItemList["MATL_ID_10TH"].setValue(matId10, out errMessage))
                    throw new Exception(errMessage);
                if (!sf.KeyItemList["EXPOSE_10TH"].setValue(timer10?.ToString() ?? "", out errMessage))
                    throw new Exception(errMessage);

                _EQ.AsyncSendandReceive(sf, null);
            }
        }
        // [SEND] [S2F41] [MATERIAL VALIDATION]

        protected void S2F41_MATERIAL_VALID(bool result, string errMsg, List<object> matlList)
        {
            string key = "S2F41_MATERIAL_VALID";
            string errMessage = string.Empty;
            StreamFunction sf = _EQ._SECSMSG_LIST.getMessage(this._EQ.getDeviceID(), key);

            if (sf == null) throw new Exception("Can't find message which is " + key);
            else
            {
                sf.SystemByte = this._EQ.hsmsDriver.getNewSystemByte();

                if (!sf.KeyItemList["RESULT"].setValue(result.ToString().ToUpper(), out errMessage))
                    throw new Exception(errMessage);
                if (!sf.KeyItemList["ERR_MSG"].setValue(errMsg, out errMessage))
                    throw new Exception(errMessage);

                for (int i = 0; i < 6; i++)
                {
                    if (matlList[i] is Materials.MTMSMaterial)
                    {
                        Materials.MTMSMaterial m = matlList[i] as Materials.MTMSMaterial;
                        if (!sf.KeyItemList[$"MAT{i + 1}_ID"].setValue(m.ID, out errMessage)) throw new Exception(errMessage);
                        if (!sf.KeyItemList[$"MAT{i + 1}_EXPOSE"].setValue(m.LIMITED_TIME.To14String(), out errMessage)) throw new Exception(errMessage);
                        if (!sf.KeyItemList[$"MAT{i + 1}_SAPCODE"].setValue(m.SAPCODE, out errMessage)) throw new Exception(errMessage);
                        if (!sf.KeyItemList[$"MAT{i + 1}_DESC"].setValue(m.MATL_DESC, out errMessage)) throw new Exception(errMessage);
                    }
                }
                _EQ.AsyncSendandReceive(sf, null);
            }
        }
        protected void S2F41_MATERIAL_VALID(string matId1, string matId2, string matId3, string matId4, string matId5, string matId6, object o, bool result)
        {
            string key = "S2F41_MATERIAL_VALID";
            string errMessage = string.Empty;
            StreamFunction sf = _EQ._SECSMSG_LIST.getMessage(this._EQ.getDeviceID(), key);

            if (sf == null) throw new Exception("Can't find message which is " + key);
            else
            {
                sf.SystemByte = this._EQ.hsmsDriver.getNewSystemByte();
                sf.ExtraTag1 = o;

                if (!sf.KeyItemList["RESULT"].setValue(result.ToString().ToUpper(), out errMessage))
                    throw new Exception(errMessage);
                if (!sf.KeyItemList["MATL_ID_1ST"].setValue(matId1, out errMessage))
                    throw new Exception(errMessage);
                if (!sf.KeyItemList["MATL_ID_2ND"].setValue(matId2, out errMessage))
                    throw new Exception(errMessage);
                if (!sf.KeyItemList["MATL_ID_3RD"].setValue(matId3, out errMessage))
                    throw new Exception(errMessage);
                if (!sf.KeyItemList["MATL_ID_4TH"].setValue(matId4, out errMessage))
                    throw new Exception(errMessage);
                if (!sf.KeyItemList["MATL_ID_5TH"].setValue(matId5, out errMessage))
                    throw new Exception(errMessage);
                if (!sf.KeyItemList["MATL_ID_6TH"].setValue(matId6, out errMessage))
                    throw new Exception(errMessage);
                if (!sf.KeyItemList["MATL_TYPE"].setValue(o.ToString(), out errMessage))
                    throw new Exception(errMessage);

                _EQ.AsyncSendandReceive(sf, null);
            }
        }
        protected void S2F41_MATERIAL_VALID(string matId1, string matId2, string matId3, string matId4, string matId5, string matId6, string matId7, string matId8, string matId9, string matId10, object o, bool result)
        {
            string key = "S2F41_MATERIAL_VALID";
            string errMessage = string.Empty;
            StreamFunction sf = _EQ._SECSMSG_LIST.getMessage(this._EQ.getDeviceID(), key);

            if (sf == null) throw new Exception("Can't find message which is " + key);
            else
            {
                sf.SystemByte = this._EQ.hsmsDriver.getNewSystemByte();
                sf.ExtraTag1 = o;

                if (!sf.KeyItemList["RESULT"].setValue(result.ToString().ToUpper(), out errMessage))
                    throw new Exception(errMessage);
                if (!sf.KeyItemList["MATL_ID_1ST"].setValue(matId1, out errMessage))
                    throw new Exception(errMessage);
                if (!sf.KeyItemList["MATL_ID_2ND"].setValue(matId2, out errMessage))
                    throw new Exception(errMessage);
                if (!sf.KeyItemList["MATL_ID_3RD"].setValue(matId3, out errMessage))
                    throw new Exception(errMessage);
                if (!sf.KeyItemList["MATL_ID_4TH"].setValue(matId4, out errMessage))
                    throw new Exception(errMessage);
                if (!sf.KeyItemList["MATL_ID_5TH"].setValue(matId5, out errMessage))
                    throw new Exception(errMessage);
                if (!sf.KeyItemList["MATL_ID_6TH"].setValue(matId6, out errMessage))
                    throw new Exception(errMessage);
                if (!sf.KeyItemList["MATL_ID_7TH"].setValue(matId7, out errMessage))
                    throw new Exception(errMessage);
                if (!sf.KeyItemList["MATL_ID_8TH"].setValue(matId8, out errMessage))
                    throw new Exception(errMessage);
                if (!sf.KeyItemList["MATL_ID_9TH"].setValue(matId9, out errMessage))
                    throw new Exception(errMessage);
                if (!sf.KeyItemList["MATL_ID_10TH"].setValue(matId10, out errMessage))
                    throw new Exception(errMessage);
                if (!sf.KeyItemList["MATL_TYPE"].setValue(o.ToString(), out errMessage))
                    throw new Exception(errMessage);

                _EQ.AsyncSendandReceive(sf, null);
            }
        }
        protected void S2F41_MATERIAL_VALID2(bool result, int location, string matId, Materials.Material oMatl, string errMsg = "")
        {
            string key = "S2F41_MATERIAL_VALID2";
            string errMessage = string.Empty;
            StreamFunction sf = _EQ._SECSMSG_LIST.getMessage(this._EQ.getDeviceID(), key);

            if (sf == null) throw new Exception("Can't find message which is " + key);
            else
            {
                sf.SystemByte = this._EQ.hsmsDriver.getNewSystemByte();
                sf.ExtraTag1 = oMatl;

                if (!sf.KeyItemList["RESULT"].setValue(result.ToString().ToUpper(), out errMessage)) throw new Exception(errMessage);
                if (!sf.KeyItemList["ERR_MSG"].setValue(errMsg, out errMessage)) throw new Exception(errMessage);
                if (!sf.KeyItemList["LOCATION"].setValue(location.ToString(), out errMessage)) throw new Exception(errMessage);
                if (!sf.KeyItemList["MATL_ID"].setValue(matId, out errMessage)) throw new Exception(errMessage);

                if (location < 9)
                {
                    if (!sf.KeyItemList["MATL_EXPOSETIME"].setValue(oMatl == null ? "" : oMatl.LIMITED_TIME.To14String(), out errMessage)) throw new Exception(errMessage);
                    if (!sf.KeyItemList["MATL_SAPCODE"].setValue(oMatl == null ? "" : oMatl.SAPCODE, out errMessage)) throw new Exception(errMessage);
                }
                // 2023.05.23 Q-time Over MGZ Block 기능 구현
                else
                {
                    if (!sf.KeyItemList["MATL_EXPOSETIME"].setValue(oMatl != null && oMatl.LIMITED_TIME != null ? oMatl.LIMITED_TIME.To14String() : "", out errMessage)) throw new Exception(errMessage);
                    if (!sf.KeyItemList["MATL_SAPCODE"].setValue(oMatl != null && !string.IsNullOrWhiteSpace(oMatl.SAPCODE) ? oMatl.SAPCODE : "", out errMessage)) throw new Exception(errMessage);
                }

                if (!sf.KeyItemList["MATL_DESC"].setValue(oMatl.MATL_DESC == null ? "" : oMatl.MATL_DESC, out errMessage)) throw new Exception(errMessage);
                _EQ.AsyncSendandReceive(sf, null);
            }
        }
        #endregion

        #region Received_Stream6
        protected override void Received_S6F11(SCKIT.SECSDriver.SECSMessage.StreamFunction sf)
        {
            if (sf.NeedReply) Reply_S6F12(sf.SystemByte);
            uint ceid = getCEIDFromS6F11(sf, ENUM_ITEM_FORMAT.U4);
            ReportList reportList = getReportListFromS6F11(sf);

            switch (ceid)
            {
                case 4002:                  // CONTROL_STATE_CHANGE_REMOTE
                case 4003:                  // CONTROL_STATE_CHANGE_OFFLINE
                    Received_S6F11_ControlStatusChanged(ceid, reportList, sf);
                    break;
                case 4004:                  // PROCESS_STATE_CHANGE
                    Received_S6F11_ProcessStatusChanged(ceid, reportList, sf);
                    break;
                case 4060:                  //  LOT ID READ
                    Received_S6F11_LotIDRead(ceid, reportList, sf);
                    break;
                case 4062:                  //  LOT START
                    Received_S6F11_LotStart(ceid, reportList, sf);
                    break;
                case 4063:                  //  LOT END
                    Received_S6F11_LotEnd(ceid, reportList, sf);
                    break;
                case 4050:                  // Dispenser 1 Boat ID Read
                case 4150:                  // Dispenser 2 Boat ID Read
                case 4250:                  // Attach 1 Boat ID Read
                case 4251:                  // Attach 2 Boat ID Read
                case 4350:                  // Press1 Boat ID Read
                case 4450:                  // Press2 Boat ID Read
                    Received_S6F11_BoatIDRead(ceid, reportList, sf);
                    break;
                case 4052:                  //  BOAT START
                    Received_S6F11_BoatStarted(ceid, reportList, sf);
                    break;
                case 4453:                  //  Press2 BOAT END
                    Received_S6F11_BoatEnded(ceid, reportList, sf);
                    break;
                case 4080:                  //  MATERIAL ID READ on DISP1
                case 4180:                  //  MATERIAL ID READ on DISP2
                    Received_S6F11_MaterialIDRead_NEW(ceid, reportList, sf);
                    break;
                case 4260:                  //PCB 2D ID Read on Zone1
                case 4265:                  //PCB 2D ID Read on Zone2
                    Received_S6F11_PCB2DRead(ceid, reportList, sf);
                    break;
                case 4270:                  //LID 2D ID Read on Zone1
                case 4275:                  //LID 2D ID Read on Zone2
                    Received_S6F11_LID2DRead(ceid, reportList, sf);
                    break;
                case 4090:                  // TOOL ID READ (TOOL_VERIFY_REQUEST)
                    Received_S6F11_ToolIDRead(ceid, reportList, sf);
                    break;
                case 4457:                  // Press2 Unloader MGZ Read Event (MGZ_READ) NTW
                case 4857:                  // Unloader MGZ Read Event (MGZ_READ) NTW-J
                    Received_S6F11_MGZReading(ceid, reportList, sf);
                    break;
                case 4474:                  // Press2 Unloader MGZ Unloading Event (MGZ_OUT) NTW
                case 4874:                  // Unloader MGZ Unloading Event (MGZ_OUT) NTW-J
                    Received_S6F11_MGZSendingWithStripListFromUnloader(ceid, reportList, sf);
                    break;
                case 4030:                  // Check Pattern Weight Dispenser1
                case 4130:                  // Check Pattern Weight Dispenser2
                    Received_S6F11_CheckPatternWeight(ceid, reportList, sf);
                    break;
                case 4051:                  // Dispenser 1 Jig ID Read
                case 4151:                  // Dispenser 2 Jig ID Read
                    Received_S6F11_JigIDRead(ceid, reportList, sf);
                    break;
                default:
                    break;
            }
        }
        //[RECIEVED] [S6F11] [LOT ID READ]
        private void Received_S6F11_LotIDRead(uint ceid, ReportList reportList, StreamFunction sf)
        {
            try
            {
                string lotId = reportList[0].DATALIST[0].AsciiValue;
                string eqId = reportList[0].DATALIST[1].AsciiValue;
                string operatorId = reportList[0].DATALIST[2].AsciiValue;
                string ppId = reportList[0].DATALIST[3].AsciiValue;

                lotId = WebModule.MESInterface.GetLotIDFromBarcode(lotId);
                PROTEC_SDA_LOT oLot = _EQ.setCLot(lotId) as PROTEC_SDA_LOT;
                Recipe oRecipe = new Recipe(WebModule.CIMInterface.GetRMSKey("U", _EQ.OPER_ID, _EQ.OPERATION, oLot.ID, _EQ.ID), _EQ.eqConfig);

                if (oRecipe.RECIPE_NAME != ppId) throw new Exception($"Recipe name is different. Server = {oRecipe.RECIPE_NAME} EQ = {ppId}");

            }
            catch (Exception ex)
            {
                _EQ.SystemLogger.Error(ex, ex.Message, null);
                Send_S10F3(ex.Message);
            }
        }

        protected void Received_S6F11_LotStart(uint ceid, ReportList reportList, StreamFunction sf)
        {

            string lotId = reportList[0].DATALIST[0].AsciiValue;
            PROTEC_SDA_LOT oLot = _EQ.setCLot(lotId) as PROTEC_SDA_LOT;
            Recipe oRecipe = new Recipe(WebModule.CIMInterface.GetRMSKey("U", _EQ.OPER_ID, _EQ.OPERATION, oLot.ID, _EQ.ID), _EQ.eqConfig);

            Send_S2F41_START(true, lotId, oLot, oRecipe, null);

            oLot.LotStarted(_EQ.ID, oRecipe.RECIPE_NAME);

            SCKIT.WebModule.MESTransactionV7.LOT_START(oLot.ID, _EQ.OPER_ID, _EQ.ID, null, _EQ.OPER_ID == "140" ? "by RMS.SDA_LOT_      START" : "by RMS.STA_LOT_START", null, "");

        }

        //[RECIEVED] [S6F11] [LOT END]
        protected void Received_S6F11_LotEnd(uint ceid, ReportList reportList, StreamFunction sf)
        {
            try
            {
                string lotId = reportList[0].DATALIST[0].AsciiValue;
                string eqId = reportList[0].DATALIST[1].AsciiValue;
                string operId = reportList[0].DATALIST[2].AsciiValue;
                string ppId = reportList[0].DATALIST[3].AsciiValue;
                string qty = reportList[0].DATALIST[4].AsciiValue;

                if (string.IsNullOrEmpty(lotId))
                    throw new Exception($"Lot is Empty.");

                lotId = WebModule.MESInterface.GetLotIDFromBarcode(lotId);
                PROTEC_SDA_LOT lot = _EQ.setCLot(lotId) as PROTEC_SDA_LOT;

                lot.LotEnded(_EQ.ID, lot.QTY, lot.QTY);

                List<string> stripList = getRemainStripList(lotId);
                bool isFinalEnd = stripList.Count == 0;

                SCKIT.WebModule.MESTransactionV7.LOT_END(lot.ID, _EQ.OPER_ID, _EQ.ID, null, isFinalEnd, _EQ.OPER_ID == "140" ? "by RMS.SDA_LOT_START" : "by RMS.STA_LOT_START", null, GlobalVariable.getIns().getCurrentEMPID());
            }
            catch (Exception ex)
            {
                _EQ.SystemLogger.Error(ex, ex.Message, null);
                Send_S10F3(ex.Message);
            }
        }
        protected List<string> getRemainStripList(string lotId)
        {
            using (var con = new OracleConnection(GlobalVariable.getIns().CONSTR_RTS))
            {
                return con.Query<string>("select strip_id from t_ksy_runlotstrip_cur where a_lot_id=:LOT_ID " +
                    "minus select strip_id from t_ksy_runlotstrip_workhis_m where lot_id=:LOT_ID", new { LOT_ID = lotId }).ToList();
            }
        }
        //[RECIEVED] [S6F11] [BOAT ID READ]
        protected void Received_S6F11_BoatIDRead(uint ceid, ReportList reportList, StreamFunction sf)
        {
            string boatId = string.Empty;
            try
            {
                boatId = reportList[0].DATALIST[0].AsciiValue;
                string lotId = reportList[0].DATALIST[1].AsciiValue;
                string ppId = reportList[0].DATALIST[2].AsciiValue;

                PROTEC_SDA_LOT lot = _EQ.setCLot(lotId) as PROTEC_SDA_LOT;
                // Boat Validation
                if (boatId.StartsWith("$B"))
                {
                    if (lot.getSubstrateList<PROTEC_SDA_Strip>().Exists(boat => boat.ID == boatId) == false)
                        throw new Exception($"Boat[{boatId}] is not assigned the Lot[{lot.ID}]");

                    PROTEC_SDA_Strip oSubst = lot.getSubstrate<PROTEC_SDA_Strip>(boatId);

                    string query = @"RTS.PKG_KSY_BOATCNTR.P_CHK_MIX_UNLD_V2 ";
                    Dictionary<string, string> inputPara = new Dictionary<string, string>();
                    inputPara.Add("P_EQUIP_ID", _EQ.ID);
                    inputPara.Add("P_LOT_ID", lotId);
                    inputPara.Add("P_BOAT_ID", boatId);
                    inputPara.Add("P_USER_ID", GlobalVariable.getIns().getCurrentEMPID());
                    string[] outputPara = { "P_RETURN_MSG" };

                    Dictionary<string, string> pResult = GlobalVariable.ExecuteStoredProcedure(query, inputPara, outputPara, GlobalVariable.getIns().CONSTR_RTS);

                    if (pResult["P_RETURN_MSG"].StartsWith("ERROR")) throw new Exception(pResult["P_RETURN_MSG"]);

                    ushort q_check = reportList[0].DATALIST[3].U2Values[0];
                    if (q_check == 1 && lot.OPERList.Contains("146"))
                    {
                        if (!oSubst.CheckWindowTime("139", false, (15 * 60) + 30)) throw new Exception("Substrate Window Time 16hour(block:15.5h) Over");
                    }
                }
                else
                {
                    if (lot.getSubstrateList<PROTEC_SDA_Strip>().Exists(strip => strip.ID == boatId) == false)
                        throw new Exception($"Strip [{boatId}] is not assigned the Lot[{lot.ID}]");
                }

                Send_S2F41_BOAT_VALID(true, boatId);
            }
            catch (Exception ex)
            {
                _EQ.SystemLogger.Error(ex, ex.Message, null);
                Send_S2F41_BOAT_VALID(false, boatId);
                Send_S10F3(ex.Message);
            }
        }

        //[RECIEVED] [S6F11] [BOAT STARTED]
        protected void Received_S6F11_BoatStarted(uint ceid, ReportList reportList, StreamFunction sf)
        {
            try
            {
                string boatId = reportList[0].DATALIST[0].AsciiValue;
                string lotId = reportList[0].DATALIST[1].AsciiValue;
                string ppId = reportList[0].DATALIST[2].AsciiValue;

                PROTEC_SDA_Strip oStrip = new PROTEC_SDA_Strip(boatId, _EQ);
                oStrip.Loaded(_EQ.ID, _EQ.eqConfig.OPER_ID, lotId);

            }
            catch (Exception ex)
            {
                _EQ.SystemLogger.Error(ex, ex.Message, null);
                Send_S10F3(ex.Message);
            }
        }

        //[RECIEVED] [S6F11] [BOAT ENDED]
        protected void Received_S6F11_BoatEnded(uint ceid, ReportList reportList, StreamFunction sf)
        {
            try
            {
                string boatId = reportList[0].DATALIST[0].AsciiValue;
                string lotId = reportList[0].DATALIST[1].AsciiValue;
                string eqId = reportList[0].DATALIST[2].AsciiValue;
                string ppId = reportList[0].DATALIST[3].AsciiValue;

                PROTEC_SDA_LOT oLot = _EQ.setCLot(lotId) as PROTEC_SDA_LOT;

                PROTEC_SDA_Strip oStrip = new PROTEC_SDA_Strip(boatId, _EQ);
                oStrip.Unload(_EQ.ID, _EQ.eqConfig.OPER_ID);
                oStrip.InsertDB_strip_master(_EQ.ID, _EQ.eqConfig.OPER_ID, oLot.ID, ppId, oLot.NICK);
            }
            catch (Exception ex)
            {
                _EQ.SystemLogger.Error(ex, ex.Message, null);
                Send_S10F3(ex.Message);
            }
        }


        //[RECIEVED] [S6F11] [UNIT PCB 2D READ]
        protected void Received_S6F11_PCB2DRead(uint ceid, ReportList reportList, StreamFunction sf)
        {
            try
            {
                string lotId = reportList[0].DATALIST[0].AsciiValue;
                string eqId = reportList[0].DATALIST[1].AsciiValue;
                string operId = reportList[0].DATALIST[2].AsciiValue;
                string ppId = reportList[0].DATALIST[3].AsciiValue;

                switch (ceid)
                {
                    case 4260:  // Attach Zone1
                        string unitId1 = reportList[1].DATALIST[0].AsciiValue;
                        break;

                    case 4265:  // Attach Zone2
                        string unitId2 = reportList[1].DATALIST[1].AsciiValue;
                        break;
                }

            }
            catch (Exception ex)
            {
                _EQ.SystemLogger.Error(ex, ex.Message, null);
                Send_S10F3(ex.Message);
            }

        }


        protected void Received_S6F11_LID2DRead(uint ceid, ReportList reportList, StreamFunction sf)
        {
            try
            {
                string lotId = reportList[0].DATALIST[0].AsciiValue;
                string eqId = reportList[0].DATALIST[1].AsciiValue;
                string operId = reportList[0].DATALIST[2].AsciiValue;
                string ppId = reportList[0].DATALIST[3].AsciiValue;

                switch (ceid)
                {
                    case 4270:  // HeatSpreader Attach Zone1
                        string LId1 = reportList[1].DATALIST[2].AsciiValue;
                        break;

                    case 4275:  // HeatSpreader Attach Zone2
                        string LId2 = reportList[1].DATALIST[3].AsciiValue;
                        break;
                }

            }
            catch (Exception ex)
            {
                _EQ.SystemLogger.Error(ex, ex.Message, null);
                Send_S10F3(ex.Message);
            }

        }

        //[RECIEVED] [S6F11] [MATERIAL ID READ]
        protected void Received_S6F11_MaterialIDRead_OLD(uint ceid, ReportList reportList, StreamFunction sf)
        {
            string[] matIds = new string[10];
            string matLocation = string.Empty;
            try
            {
                switch (ceid)
                {
                    case 4080:
                        for (int i = 0; i <= 5; i++)
                            matIds[i] = reportList[1].DATALIST[i].AsciiValue;

                        if (_EQ.eqConfig.MODEL == "PRO2020NTW-J")
                        {
                            for (int i = 6; i <= 9; i++)
                                matIds[i] = reportList[1].DATALIST[i].AsciiValue;
                        }

                        matLocation = "DP1";
                        break;

                    case 4180:
                        for (int i = 0; i <= 5; i++)
                            matIds[i] = reportList[1].DATALIST[i].AsciiValue;

                        if (_EQ.eqConfig.MODEL == "PRO2020NTW-J")
                        {
                            for (int i = 6; i <= 9; i++)
                                matIds[i] = reportList[1].DATALIST[i].AsciiValue;
                        }

                        matLocation = "DP2";
                        break;

                    default:
                        return;
                }

                string boatId = reportList[0].DATALIST[0].AsciiValue;
                string lotId = reportList[0].DATALIST[1].AsciiValue;
                PROTEC_SDA_LOT oLot = _EQ.setCLot(lotId) as PROTEC_SDA_LOT;

                string[] timMatIds = new[] { matIds[0], matIds[1] };
                var tims = timMatIds
                    .Where(m => !string.IsNullOrWhiteSpace(m) && m.StartsWith("$"))
                    .Select(m => new Materials.MTMSMaterial(m, _EQ))
                    .ToList();

                string[] adMatIds = new[] { matIds[2], matIds[3] };
                var ads = adMatIds
                    .Where(m => !string.IsNullOrWhiteSpace(m) && m.StartsWith("$"))
                    .Select(m => new Materials.MTMSMaterial(m, _EQ))
                    .ToList();

                if (tims.Any(m => DateTime.Now > m.EXPOSE_TIME))
                    throw new Exception($@"Expose time overred... : {tims.First(m => DateTime.Now > m.EXPOSE_TIME).ID} Expose time 이 경과하였습니다.");

                if (tims.Any(m => DateTime.Now > m.EXPIRE_TIME))
                    throw new Exception($@"Expire time overred... : {tims.First(m => DateTime.Now > m.EXPIRE_TIME).ID} Expire time 이 경과하였습니다.");

                if (ads.Any(m => DateTime.Now > m.EXPOSE_TIME))
                    throw new Exception($@"Expose time overred... : {ads.First(m => DateTime.Now > m.EXPOSE_TIME).ID} Expose time 이 경과하였습니다.");

                if (ads.Any(m => DateTime.Now > m.EXPIRE_TIME))
                    throw new Exception($@"Expire time overred... : {ads.First(m => DateTime.Now > m.EXPIRE_TIME).ID} Expire time 이 경과하였습니다.");

                if (!string.IsNullOrWhiteSpace(matIds[4]))
                {
                    string stiffener = matIds[4].Contains("/") ? matIds[4].Split('/')[0].Trim() : matIds[4];
                    string[] strStiffenerList = oLot.getStifferSapCodeList();
                    if (!strStiffenerList.Contains(stiffener))
                        throw new Exception($"Scann 한 Heat Stiffener '{stiffener}' 의 SAPCODE와 AI상의 SAPCODE '{(string.Join(",", strStiffenerList))}' 가 일치하지 않습니다.");
                }

                if (!string.IsNullOrWhiteSpace(matIds[5]))
                {
                    string spreader = matIds[5].Contains("/") ? matIds[5].Split('/')[0].Trim() : matIds[5];
                    string[] strSpreaderList = oLot.getSpreaderSapCodeList();
                    if (!strSpreaderList.Contains(spreader))
                        throw new Exception($"Scann 한 Heat Spreader '{spreader}' 의 SAPCODE와 AI상의 SAPCODE List[{(string.Join(",", strSpreaderList))}]가 일치하지 않습니다.");
                }

                string[] timsSapCodeFromAI = _EQ.OPER_ID == "110"
                    ? oLot.getSTATimMaterialListFromAI()
                    : oLot.getSDATimMaterialListFromAI();

                string[] timsSapCodeFromEQ = tims.Select(m => m.SAPCODE).ToArray();
                string notMatchedtim = timsSapCodeFromEQ.FirstOrDefault(m => !timsSapCodeFromAI.Contains(m));
                if (notMatchedtim != null)
                    throw new Exception($@"EQ에 입력된 TIM 용액({notMatchedtim})이 AI에 등록되지 않았습니다.");

                string[] adsSapCodeFromAI = _EQ.OPER_ID == "110"
                    ? oLot.getSTAAdMaterialListFromAI()
                    : oLot.getSDAAdMaterialListFromAI();

                string[] adsSapCodeFromEQ = ads.Select(m => m.SAPCODE).ToArray();
                string notMatchedads = adsSapCodeFromEQ.FirstOrDefault(m => !adsSapCodeFromAI.Contains(m));
                if (notMatchedads != null)
                    throw new Exception($@"EQ에 입력된 ADS 용액({notMatchedads})이 AI에 등록되지 않았습니다.");

                if (_EQ.eqConfig.MODEL == "PRO2020NTW")
                {
                    S2F41_MATERIAL_TIMER(
                        matIds[0], string.IsNullOrWhiteSpace(matIds[0]) ? DateTime.MaxValue : tims.FirstOrDefault(m => m.ID == matIds[0])?.EXPOSE_TIME ?? DateTime.MaxValue,
                        matIds[1], string.IsNullOrWhiteSpace(matIds[1]) ? DateTime.MaxValue : tims.FirstOrDefault(m => m.ID == matIds[1])?.EXPOSE_TIME ?? DateTime.MaxValue,
                        matIds[2], string.IsNullOrWhiteSpace(matIds[2]) ? DateTime.MaxValue : tims.FirstOrDefault(m => m.ID == matIds[2])?.EXPOSE_TIME ?? DateTime.MaxValue,
                        matIds[3], string.IsNullOrWhiteSpace(matIds[3]) ? DateTime.MaxValue : tims.FirstOrDefault(m => m.ID == matIds[3])?.EXPOSE_TIME ?? DateTime.MaxValue,
                        matIds[4], DateTime.MaxValue,
                        matIds[5], DateTime.MaxValue,
                        matLocation, true
                    );
                }
                else if (_EQ.eqConfig.MODEL == "PRO2020NTW-J")
                {
                    S2F41_MATERIAL_TIMER(
                        matIds[0], string.IsNullOrWhiteSpace(matIds[0]) ? DateTime.MaxValue : tims.FirstOrDefault(m => m.ID == matIds[0])?.EXPOSE_TIME ?? DateTime.MaxValue,
                        matIds[1], string.IsNullOrWhiteSpace(matIds[1]) ? DateTime.MaxValue : tims.FirstOrDefault(m => m.ID == matIds[1])?.EXPOSE_TIME ?? DateTime.MaxValue,
                        matIds[2], string.IsNullOrWhiteSpace(matIds[2]) ? DateTime.MaxValue : tims.FirstOrDefault(m => m.ID == matIds[2])?.EXPOSE_TIME ?? DateTime.MaxValue,
                        matIds[3], string.IsNullOrWhiteSpace(matIds[3]) ? DateTime.MaxValue : tims.FirstOrDefault(m => m.ID == matIds[3])?.EXPOSE_TIME ?? DateTime.MaxValue,
                        matIds[4], DateTime.MaxValue,
                        matIds[5], DateTime.MaxValue,
                        matIds[6], string.IsNullOrWhiteSpace(matIds[6]) ? DateTime.MaxValue : tims.FirstOrDefault(m => m.ID == matIds[6])?.EXPOSE_TIME ?? DateTime.MaxValue,
                        matIds[7], string.IsNullOrWhiteSpace(matIds[7]) ? DateTime.MaxValue : tims.FirstOrDefault(m => m.ID == matIds[7])?.EXPOSE_TIME ?? DateTime.MaxValue,
                        matIds[8], string.IsNullOrWhiteSpace(matIds[8]) ? DateTime.MaxValue : tims.FirstOrDefault(m => m.ID == matIds[8])?.EXPOSE_TIME ?? DateTime.MaxValue,
                        matIds[9], string.IsNullOrWhiteSpace(matIds[9]) ? DateTime.MaxValue : tims.FirstOrDefault(m => m.ID == matIds[9])?.EXPOSE_TIME ?? DateTime.MaxValue,
                        matLocation, true
                    );
                }
            }
            catch (Exception ex)
            {
                _EQ.SystemLogger.Error(ex, ex.Message, null);

                if (_EQ.eqConfig.MODEL == "PRO2020NTW")
                {
                    S2F41_MATERIAL_VALID(matIds[0], matIds[1], matIds[2], matIds[3], matIds[4], matIds[5], matLocation, false);
                }
                else if (_EQ.eqConfig.MODEL == "PRO2020NTW-J")
                {
                    S2F41_MATERIAL_VALID(matIds[0], matIds[1], matIds[2], matIds[3], matIds[4], matIds[5], matIds[6], matIds[7], matIds[8], matIds[9], matLocation, false);
                }
                Send_S10F3(ex.Message);
            }
        }
        protected void Received_S6F11_MaterialIDRead_NEW(uint ceid, ReportList reportList, StreamFunction sf)
        {
            Material_Validation(ceid, reportList, sf);
        }

        // SDA(140) / STA(110) 자재 검증 공통 로직
        // - SDA: EPOXY(loc 1~8), LID_Magazine 또는 HEAT_SLUG(loc 9~16)
        // - STA: EPOXY(loc 1~8), LID_Magazine 또는 HEAT_SLUG(loc 17~24)
        // - ceid==4080(Dispenser1)일 때만 설비로 검증 결과 응답 및 DB 저장
        protected void Material_Validation(uint ceid, ReportList reportList, StreamFunction sf)
        {
            string lotId = string.Empty;
            ushort matLocation = 0;
            string matId = string.Empty;
            Materials.Material oMatl = null;

            try
            {
                lotId = ceid == 4080 ? reportList[0].DATALIST[1].AsciiValue : reportList[0].DATALIST[0].AsciiValue;
                matLocation = reportList[1].DATALIST[0].U2Values[0];
                matId = reportList[1].DATALIST[matLocation].AsciiValue;
                ushort lid_qtime_use = reportList[1].DATALIST[25].U2Values[0];

                lotId = WebModule.MESInterface.GetLotIDFromBarcode(lotId);
                PROTEC_SDA_LOT oLot = _EQ.setCLot(lotId) as PROTEC_SDA_LOT;
                string lead = oLot.LeadCount;

                int lidLocationStart, lidLocationEnd;

                if (oLot.CUROPER_ID == "140")
                {
                    lidLocationStart = 9; lidLocationEnd = 16;
                    if (matLocation >= 1 && matLocation <= 8)
                    {
                        oMatl = new Materials.EPOXY(matId, _EQ);
                        (oMatl as Materials.EPOXY).Validate(oLot.getSDATimMaterialListFromAI());
                    }
                    else if (matLocation >= lidLocationStart && matLocation <= lidLocationEnd)
                    {
                        if (lid_qtime_use == 1)
                        {
                            oMatl = new Materials.LID_Magazine(matId, lead, _EQ);
                            (oMatl as Materials.LID_Magazine).Validate(oLot.CUROPER_ID);
                        }
                        else
                        {
                            oMatl = new Materials.HEAT_SLUG(matId, _EQ);
                            (oMatl as Materials.HEAT_SLUG).Validate(oLot.getSpreaderSapCodeList(), oLot.ID);
                        }
                    }
                    else throw new Exception($"Location[{matLocation}] on OPER[{oLot.CUROPER_ID}] is not defined");
                }
                else if (oLot.CUROPER_ID == "110")
                {
                    lidLocationStart = 17; lidLocationEnd = 24;
                    if (matLocation >= 1 && matLocation <= 8)
                    {
                        oMatl = new Materials.EPOXY(matId, _EQ);
                        (oMatl as Materials.EPOXY).Validate(oLot.getSTATimMaterialListFromAI());
                    }
                    else if (matLocation >= lidLocationStart && matLocation <= lidLocationEnd)
                    {
                        if (lid_qtime_use == 1)
                        {
                            oMatl = new Materials.LID_Magazine(matId, lead, _EQ);
                            (oMatl as Materials.LID_Magazine).Validate(oLot.CUROPER_ID);
                        }
                        else
                        {
                            oMatl = new Materials.HEAT_SLUG(matId, _EQ);
                            (oMatl as Materials.HEAT_SLUG).Validate(oLot.getStifferSapCodeList());
                        }
                    }
                    else throw new Exception($"Location[{matLocation}] on OPER[{oLot.CUROPER_ID}] is not defined");
                }
                else throw new Exception($"Lot[{lotId}] is not on SDA(STA) Oper");

                if (ceid == 4080)
                {
                    if (!oMatl.ValidationResult) throw new Exception(oMatl.ValidationErrMsg);
                    S2F41_MATERIAL_VALID2(true, matLocation, matId, oMatl);
                    bool isLidLocation = matLocation >= lidLocationStart && matLocation <= lidLocationEnd;
                    if (isLidLocation && lid_qtime_use == 1)
                        oLot.InsertDB_lot_master(_EQ.ID, _EQ.eqConfig.OPER_ID, oLot.ID, oMatl.ID, oMatl.SAPCODE, oMatl.BATCH_ID);
                }
            }
            catch (Exception ex)
            {
                _EQ.SystemLogger.Error(ex, ex.Message, null);
                Send_S10F3(ex.Message);
                S2F41_MATERIAL_VALID2(false, matLocation, matId, oMatl, ex.Message);
            }
        }

        private void Received_S6F11_CheckPatternWeight(uint ceid, ReportList reportList, StreamFunction sf)
        {
            try
            {
                string lotId = reportList[0].DATALIST[0].AsciiValue;
                ushort valveNo = reportList[0].DATALIST[1].U2Values[0];
                string weight1 = reportList[0].DATALIST[2].AsciiValue;
                string weight2 = reportList[0].DATALIST[3].AsciiValue;
                string weight3 = reportList[0].DATALIST[4].AsciiValue;
                string weight4 = reportList[0].DATALIST[5].AsciiValue;
                string weight5 = reportList[0].DATALIST[6].AsciiValue;
                string weight6 = reportList[0].DATALIST[7].AsciiValue;

                string dispensorNo = ceid == 4030 ? "1" : ceid == 4130 ? "2" : string.Empty;

                PROTEC_SDA_LOT oLot = _EQ.setCLot(lotId) as PROTEC_SDA_LOT;
                oLot.InsertDB_dispenser_master(_EQ.OPERATION, _EQ.ID, oLot.ID, dispensorNo, valveNo.ToString(), weight1, weight2, weight3, weight4, weight5, weight6);

            }
            catch (Exception ex)
            {
                _EQ.SystemLogger.Error(ex, ex.Message, null);
                Send_S10F3(ex.Message);
            }
        }

        protected void Received_S6F11_ToolIDRead(uint ceid, ReportList reportList, StreamFunction sf)
        {
            try
            {
                string LotId = reportList[0].DATALIST[0].AsciiValue;

                int loopEnd = _EQ.eqConfig.MODEL == "PRO2020NTW" ? 12 : 24;

                List<string> toolList = new List<string>();
                for (int i = 1; i <= loopEnd; i++)
                {
                    string value = reportList[0].DATALIST[i].AsciiValue;
                    if (!string.IsNullOrWhiteSpace(value))
                        toolList.Add(value);
                }

                string[] toolist = toolList.ToArray();
                PROTEC_SDA_LOT oLot = _EQ.setCLot(LotId) as PROTEC_SDA_LOT;

                if (!string.IsNullOrWhiteSpace(LotId))
                {
                    string returnMsg = "";
                    using (var con = new OracleConnection(GlobalVariable.getIns().CONSTR_RTS))
                    {
                        foreach (string tool in toolist)
                        {
                            if (tool.StartsWith("$TL"))
                            {
                                string itemValue = tool.Substring(0, 4);
                                string sql = $"SELECT * FROM T_SDA_TOOLVAL_INFO WHERE APPLICATION = 'COMMON_RMS' AND TYPE='TOOL_SUBSTRING' AND ITEM='{itemValue}'";
                                var dbResult = con.QueryFirstWithLogging(_EQ, sql);

                                if (dbResult == null)
                                    throw new Exception("There isn`t Miscellaneous data on DB");

                                int toolValcount = Convert.ToInt32(dbResult.VALUE);
                                string tooltype = dbResult.REMARK1;
                                string[] aryToolIds = tool.Split('-');
                                string toolId = string.Empty;
                                for (int i = 0; i < toolValcount; i++)
                                {
                                    if (i == toolValcount - 1) toolId += aryToolIds[i];
                                    else toolId += aryToolIds[i] + "-";
                                }
                                if (!Tool_Validation(oLot.AI_NO_INTR, tooltype, toolId, _EQ, out returnMsg, con))
                                {
                                    Send_S2F41_TOOL_VALID(false, returnMsg, tool, "TOOL_TYPE");
                                    throw new Exception(returnMsg);
                                }
                                if (!GlobalVariable.checkMaterial(_EQ, oLot.ID, string.Empty, tooltype, toolId, out returnMsg)) throw new Exception($"Can't use the Tool[{tool}] on Lot[{oLot.ID}]. Please check AI.{Environment.NewLine}{returnMsg}");
                            }
                        }
                        Send_S2F41_TOOL_VALID(true, returnMsg, string.Join(",", toolist), "TOOL_TYPE");
                    }
                }
            }
            catch (Exception ex)
            {
                _EQ.SystemLogger.Error(ex, ex.Message, null);
                Send_S10F3(ex.Message);
            }
        }
        internal bool Tool_Validation(string ai_intr, string tooltype, string toolid, Library.Equipment oEQ, out string returnMsg, OracleConnection con)
        {
            try
            {
                if (con == null) throw new ArgumentNullException(nameof(con));

                string query = string.Empty;
                switch (tooltype)
                {
                    case "SDA VACUUM BLOCK ID":
                        query = $"SELECT * FROM AI_CONTENT@LINK_AI WHERE ai_no_intr = '{ai_intr}' AND OPER in ('140')  AND ITEM_ID IN ( 'txt_7253' ,'txt_7254' ) ";
                        break;
                }

                DataTable dt = GlobalVariable.GetOracleDataTable(query, GlobalVariable.getIns().CONSTR_RTS);
                if (dt != null && dt.Rows.Count > 0)
                {
                    foreach (DataRow row in dt.Rows)
                    {
                        string ai_itemValue = row["ITEM_VALUE"].ToString().ToUpper();
                        if (!toolid.Equals(ai_itemValue))
                        {
                            returnMsg = $"ToolID '{toolid}' does not match AI value '{ai_itemValue}'.";
                            return false;
                        }
                    }
                    returnMsg = string.Empty;
                    return true;
                }
                else
                {
                    returnMsg = "No tool information registered in AI.";
                    return false;
                }
            }
            catch (Exception ex)
            {
                Send_S10F3(ex.Message);
                returnMsg = ex.Message;
                return false;
            }
        }
        protected void Received_S6F11_MGZReading(uint ceid, ReportList reportList, StreamFunction sf)
        {
            try
            {
                _EQ.SystemLogger.Info("Received S6F11 CEID=" + ceid + "(MGZReading)");

                string stripid = reportList[0].DATALIST[0].AsciiValue;
                string mgzid = reportList[0].DATALIST[1].AsciiValue;
                int mgzslot = (int)reportList[0].DATALIST[2].U4Values[0];

                PROTEC_SDA_Strip oStrip = new PROTEC_SDA_Strip(stripid, _EQ);
                oStrip.Unload(_EQ.ID, _EQ.eqConfig.OPER_ID, mgzid, mgzslot);
            }
            catch (Exception ex)
            {
                _EQ.SystemLogger.Error(ex, ex.Message, null);
                this.Send_S10F3(ex.Message);

            }
        }
        protected void Received_S6F11_MGZSendingWithStripListFromUnloader(uint ceid, ReportList reportList, StreamFunction sf)
        {
            try
            {
                if (_EQ.ControlStatus == Equipment.ENUM_CONTROL_STATE.ONLINE_REMOTE)
                {
                    string mgzid = reportList[0].DATALIST[0].AsciiValue;
                    uint stripcount = reportList[0].DATALIST[1].U4Values[0];
                    Magazine mgz = new Magazine(mgzid, _EQ);
                    List<string> striplist = new List<string>();

                    foreach (SECSItem sublist in reportList[0].DATALIST[2].ChildItem)
                    {
                        striplist.Add(sublist.ChildItem[1].AsciiValue);
                    }

                    _EQ.setCLot(mgz.getLotIdFromStrip());
                    mgz.Unloaded(_EQ.ID, _EQ.eqConfig.OPER_ID, _EQ.eqConfig.OPERATION, _EQ.getCLotID());
                }
            }
            catch (Exception ex)
            {
                _EQ.SystemLogger.Error(ex, ex.Message, null);
                this.Send_S10F3(ex.Message);
            }
        }

        // Jig VALID 26/03/06 김영주 기장 요청
        protected void Received_S6F11_JigIDRead(uint ceid, ReportList reportList, StreamFunction sf)
        {
            try
            {
                string JigId = reportList?[0]?.DATALIST?[0]?.AsciiValue;
                string LotId = reportList?[0]?.DATALIST?[1]?.AsciiValue;

                if (string.IsNullOrWhiteSpace(JigId) || string.IsNullOrWhiteSpace(LotId))
                    throw new Exception("설비에서 올라온 데이터 중 JigId 또는 LotId 값이 없습니다.");

                PROTEC_SDA_LOT oLot = _EQ.setCLot(LotId) as PROTEC_SDA_LOT;

                if (oLot == null || string.IsNullOrWhiteSpace(oLot.AI_NO_INTR))
                    throw new Exception("AI_NO_INTR 값을 확인할 수 없습니다.");

                string query =
                    $"SELECT TRIM(ITEM_VALUE) ITEM_VALUE " +
                    $"FROM AI_CONTENT@LINK_AI " +
                    $"WHERE AI_NO_INTR = '{oLot.AI_NO_INTR}' " +
                    $"AND OPER = '140' " +
                    $"AND ITEM_ID = 'ddl_11950'";

                DataTable dt = GlobalVariable.GetOracleDataTable(query, GlobalVariable.getIns().CONSTR_RTS);

                if (dt == null || dt.Rows.Count == 0)
                    throw new Exception("AI에 Jig 정보가 등록되지 않았습니다.");

                string jigPrefix = JigId.Substring(0, 1).ToUpper();

                bool isMatch = dt.AsEnumerable()
                    .Any(r => jigPrefix.Equals(r["ITEM_VALUE"]?.ToString().Trim().ToUpper()));

                Send_S2F41_JIG_VALID(isMatch, JigId);

                if (!isMatch)
                {
                    string aiValues = string.Join(",",
                        dt.AsEnumerable()
                          .Select(r => r["ITEM_VALUE"]?.ToString().Trim())
                          .Where(v => !string.IsNullOrWhiteSpace(v)));

                    throw new Exception($"Jig ID mismatch. Equipment='{jigPrefix}', AI='{aiValues}'");
                }
            }
            catch (Exception ex)
            {
                _EQ.SystemLogger.Error(ex, ex.Message, null);
                Send_S10F3(ex.Message);
            }
        }
        #endregion

        #region Received_Stream14

        protected override void ReceivedPrimary_Stream14(SCKIT.SECSDriver.SECSMessage.StreamFunction objStrFun)
        {
            switch (objStrFun.Function)
            {
                case 1:
                    Received_S14F1(objStrFun);
                    break;
                case 3:
                    Received_S14F3(objStrFun);
                    break;
                default:
                    break;
            }
        }


        protected override void Received_S14F1(SCKIT.SECSDriver.SECSMessage.StreamFunction sf)
        {
            string boatid = string.Empty;
            Strip oStrip = null;
            try
            {
                if (GlobalVariable.getIns().EXEMODE == ENUM_EXE_MODE.DEBUG) _EQ.SystemLogger.Debug("Start to parsing S14F1");
                string objSpec = sf.Body.ChildItem[0].AsciiValue;
                string objType = sf.Body.ChildItem[1].AsciiValue;

                List<string> objIDList = new List<string>();
                foreach (var item in sf.Body.ChildItem[2].ChildItem)
                    objIDList.Add(item.AsciiValue);

                List<List<string>> objQualifiersToMatch = new List<List<string>>();
                foreach (var item in sf.Body.ChildItem[3].ChildItem)
                {
                    List<string> subList = new List<string>();
                    foreach (var subItem in item.ChildItem)
                    {
                        subList.Add(subItem.getFirstValue().ToString());
                    }
                    objQualifiersToMatch.Add(subList);
                }

                List<string> attributes = new List<string>();
                foreach (var item in sf.Body.ChildItem[4].ChildItem)
                {
                    attributes.Add(item.getFirstValue().ToString());
                }
                if (GlobalVariable.getIns().EXEMODE == ENUM_EXE_MODE.DEBUG) _EQ.SystemLogger.Debug("Start to create strip object");
                oStrip = _EQ.CreateStripInstance((boatid = objIDList[0]));
                if (oStrip == null) throw new Exception("ER_STRIP");
                if (oStrip.LOT_ID == string.Empty) throw new Exception("ER_LOT");
                if (GlobalVariable.getIns().EXEMODE == ENUM_EXE_MODE.DEBUG) _EQ.SystemLogger.Debug("Start to get strip map");
                oStrip.getPCBMap(_EQ.ID);
                if (oStrip.MAP == null) throw new Exception("ER_MAP");

                Reply_S14F2_SubstrateMap(sf.SystemByte, boatid, oStrip, true);
            }

            catch (System.Reflection.TargetInvocationException ex1)
            {
                string errMsg = string.Empty, errDesc = string.Empty;
                errMsg = "ER_TI";
                errDesc = ex1.InnerException.Message;
                _EQ.SystemLogger.Error(errMsg + "-" + errDesc);
                Reply_S14F2_SubstrateMap(sf.SystemByte, boatid, null, false, errMsg, errDesc);
                Send_S10F3(errMsg + "-" + errDesc);
            }
            catch (Exception ex)
            {
                string errMsg = string.Empty, errDesc = string.Empty;
                errMsg = ex.Message;
                switch (ex.Message)
                {
                    case "ER_STRIP":
                        errDesc = $"Can't create Strip Object for {boatid}.";
                        break;
                    case "ER_LOT":
                        errDesc = $"Boat[{boatid}] is not assigned to Lot";
                        break;
                    case "ER_MAP":
                        errDesc = $"Can't get Map information from Boat[{boatid}]";
                        break;
                    default:
                        errMsg = "ER_UDF";
                        errDesc = ex.Message;
                        break;
                }

                _EQ.SystemLogger.Error(errMsg + "-" + errDesc);
                Reply_S14F2_SubstrateMap(sf.SystemByte, boatid, null, false, errMsg, errDesc);
                Send_S10F3(errMsg + "-" + errDesc);
            }
        }

        protected override void Reply_S14F2_SubstrateMap(uint systemByte, string stripid, Strip oStrip, bool result, string errorCode = "", string errorDescription = "")
        {
            string errMessage = string.Empty;
            string key = "S14F2_GET_ATTR_DATA_BOATMAP";
            StreamFunction sf = null;
            try
            {
                sf = _EQ._SECSMSG_LIST.getMessage(this._EQ.getDeviceID(), key);
                if (sf == null) throw new Exception("Can't find message which is " + key);

                sf.SystemByte = systemByte;
                if (!sf.KeyItemList["OBJACK"].setValue(result ? "0" : "1", out errMessage)) throw new Exception(errMessage);
                if (!sf.KeyItemList["OBJID"].setValue(stripid, out errMessage)) throw new Exception(errMessage);
                if (result && oStrip != null)
                {
                    if (!sf.KeyItemList["ROWS"].setValue(oStrip.ROW.ToString(), out errMessage)) throw new Exception(errMessage);
                    if (!sf.KeyItemList["COLS"].setValue(oStrip.COL.ToString(), out errMessage)) throw new Exception(errMessage);
                    if (sf.KeyItemList["MAP"].Format == ENUM_ITEM_FORMAT.ASCII)
                    {
                        if (!sf.KeyItemList["MAP"].setValue(oStrip.MAP, out errMessage)) throw new Exception(errMessage);
                    }
                    else
                    {
                        sf.KeyItemList["MAP"].AddBodyArray(oStrip.getMAPArray());
                    }

                    if (sf.KeyItemList.ContainsKey("LOT_ID"))
                    {
                        if (!sf.KeyItemList["LOT_ID"].setValue(oStrip.LOT_ID, out errMessage)) throw new Exception(errMessage);
                    }
                    sf.KeyItemList["ERRCODE"].ParentItem.ParentItem.RemoveChildAll();
                }
                else
                {
                    if (!sf.KeyItemList["ERRCODE"].setValue(errorCode, out errMessage)) throw new Exception(errMessage);
                    if (!sf.KeyItemList["ERRDESC"].setValue(errorDescription, out errMessage)) throw new Exception(errMessage);
                }

                _EQ.SendMessage(sf);
            }
            catch (Exception ex)
            {
                _EQ.SystemLogger.Error(ex.Message);
                if (sf == null) Send_S10F3(ex.Message);
                else _EQ.SendMessage(sf);
            }
        }


        protected override void Received_S14F3(SCKIT.SECSDriver.SECSMessage.StreamFunction sf)
        {
            string errMessage = "";
            string stripid = string.Empty;
            string map = "";
            string recipeName = "";
            uint rowCount = 0;
            uint colCount = 0;
            List<string> objIDList = new List<string>();
            PROTEC_SDA_LOT oLot = _EQ.getCLot<PROTEC_SDA_LOT>();
            PROTEC_SDA_Strip oStrip = null;
            List<string> MatIDList = new List<string>();
            List<string> ParamIDList = new List<string>();
            List<string> ToolIDList = new List<string>();

            try
            {
                string objSpec = sf.Body.ChildItem[0].AsciiValue;
                string objType = sf.Body.ChildItem[1].AsciiValue;
                string objID = sf.Body.ChildItem[2].AsciiValue;
                string boatID = sf.Body.ChildItem[2].ChildItem[0].AsciiValue;


                if (oLot == null)
                {
                    string lotId = GlobalVariable.getLotFromStrip(boatID);
                    oLot = new PROTEC_SDA_LOT(lotId, _EQ as PROTEC_SDA_EQ);
                }

                foreach (var item in sf.Body.ChildItem[2].ChildItem)
                {
                    objIDList.Add(item.AsciiValue);
                }

                var attributes = sf.Body.ChildItem[3].ChildItem.ToDictionary(item => item.ChildItem[0].AsciiValue, item => item.ChildItem[1]);
                rowCount = attributes["ROWS"].U4Values[0];
                colCount = attributes["COLUMNS"].U4Values[0];
                map = attributes["MAPDATA"].ChildItem[0].AsciiValue;
                recipeName = attributes["PPID"].AsciiValue;


                PROTEC_SDA_UnitSummaryList oSummaryList = new PROTEC_SDA_UnitSummaryList();

                foreach (var listItem in attributes["MAPDATA"].ChildItem[1].ChildItem)
                {
                    if (listItem.ChildItem.Count == 0) continue;

                    uint X = listItem.ChildItem[0].U4Values[0];
                    uint Y = listItem.ChildItem[1].U4Values[0];
                    string unitID = listItem.ChildItem[2].AsciiValue;
                    string lidID = listItem.ChildItem[3].AsciiValue;
                    string bincode = listItem.ChildItem[4].AsciiValue;

                    if (!string.IsNullOrEmpty(lidID) && oLot.CustID.Equals("SSO") && oLot.LeadCount.Equals("2401"))
                        lidID = "YY" + lidID.Substring(lidID.Length - 12);

                    foreach (var tItem in listItem.ChildItem[5].ChildItem[0].ChildItem)
                        MatIDList.Add(tItem.AsciiValue);
                    foreach (var tItem in listItem.ChildItem[5].ChildItem[1].ChildItem)
                        ParamIDList.Add(tItem.AsciiValue);
                    foreach (var tItem in listItem.ChildItem[5].ChildItem[2].ChildItem)
                        ToolIDList.Add(tItem.AsciiValue);

                    oSummaryList.Add(new PROTEC_SDA_UnitSummary(X, Y, unitID, lidID, bincode, MatIDList, ParamIDList, ToolIDList));
                }

                // 장비에서 MapData 자리에 실제 map이 아닌 "MAPDATA"라는 값을 올려 MAP을 Unit Summary로 재계산
                // NTW-J 는 MAP DATA UPLOAD 안함
                if (_EQ.eqConfig.MODEL == "PRO2020NTW")
                {
                    map = string.Empty;
                    for (ulong r = 1; r <= rowCount; r++)
                    {
                        for (ulong c = 1; c <= colCount; c++)
                        {
                            var unit = oSummaryList.Where(u => u.ROW == r && u.COL == c);
                            if (unit.Count() == 0) map += "0";
                            else map += unit.First().BIN;
                        }
                        map += "/";
                    }
                    map = map.TrimEnd(new char[] { '/' });
                }

                oSummaryList.InsertDB_unit_summary(oLot.ID, _EQ.ID, boatID, recipeName, _EQ.OPER_ID, _EQ.eqConfig.MODEL);

                Reply_S14F4(sf.SystemByte, objIDList, null, true);
            }
            catch (Exception ex)
            {
                string errDesc = string.Empty;
                switch (ex.Message)
                {
                    case "ER_STRIP":
                        errDesc = $"Can't create Strip Object for {stripid}.";
                        break;
                    case "ER_LOT":
                        errDesc = $"Strip[{stripid}] is not assigned to Lot";
                        break;
                    case "ER_MAP":
                        errDesc = $"Can't get Map information from Strip[{stripid}]";
                        break;
                    default:
                        break;
                }

                _EQ.SystemLogger.Error(ex.Message + "-" + errDesc);
                Reply_S14F4(sf.SystemByte, objIDList, null, false, ex.Message, errDesc);
                Send_S10F3(ex.Message + "-" + errDesc);
            }
        }

        protected override void Reply_S14F4(uint systemByte, List<string> objIDList, Dictionary<string, object> attributes, bool result, string errCode = "0", string errMessage = "")
        {
            string key = "S14F4_SET_ATTR_DATA_BOAT";
            StreamFunction sf = null;
            try
            {
                sf = _EQ._SECSMSG_LIST.getMessage(this._EQ.getDeviceID(), key);
                sf.SystemByte = systemByte;

                if (sf == null) throw new Exception("Can't find message which is " + key);
                if (!sf.KeyItemList["OBJID"].setValue(objIDList[0], out errMessage)) throw new Exception(errMessage);
                if (!sf.KeyItemList["OBJACK"].setValue(result ? "0" : "1", out errMessage)) throw new Exception(errMessage);
                if (result) sf.KeyItemList["ERRLIST"].RemoveChildAll();
                else
                {
                    if (!sf.KeyItemList["ERRCODE"].setValue(errCode, out errMessage)) throw new Exception(errMessage);
                    if (!sf.KeyItemList["ERRDESC"].setValue(errMessage, out errMessage)) throw new Exception(errMessage);
                }

                _EQ.SendMessage(sf);
            }
            catch (Exception ex)
            {
                _EQ.SystemLogger.Error(ex.Message);
                if (sf == null) Send_S10F3(ex.Message);
                else _EQ.SendMessage(sf);
            }
        }
        #endregion
    }
}
