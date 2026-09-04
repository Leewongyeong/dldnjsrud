//==========================================================================================
//  Mold_SIP.aspx.cs  (Data_modify.Mold_SIP)  - "추가할 부분"만 정리한 파일입니다.
//  기존 Mold_SIP.aspx.cs 를 그대로 두고, 아래 내용만 클래스 안에 붙여넣으세요.
//
//  대상 DB   : SIPPRD           (web.config appSettings key : _CONSTR_RTS_SIPPRD)
//  호출 PROC : RTS.KSY_SEND_MAIL('MOLD_DEL:' + EQUIP_ID + '|' + LOT_ID)
//==========================================================================================

// ---- 1) 파일 맨 위 using 절에 없는 것만 추가 ----------------------------------------
using System;
using System.Configuration;
using System.Data;
using System.Web;
using System.Web.UI.WebControls;
using Oracle.DataAccess.Client;   // ※ 사이트에서 쓰는 Oracle Provider 에 맞추세요.
                                  //    Devart 면 using Devart.Data.Oracle;

namespace Data_modify
{
    public partial class Mold_SIP : System.Web.UI.Page
    {
        // ---- 2) 아래 상수 2개 + 메서드 3개를 기존 클래스 안에 그대로 붙여넣기 --------

        /// <summary>메일 발송 프로시저(RTS.KSY_SEND_MAIL)가 있는 DB 접속 문자열 key</summary>
        private const string MAIL_CONSTR_KEY = "_CONSTR_RTS_SIPPRD";

        /// <summary>RTS.KSY_SEND_MAIL 에 추가한 P_MODE prefix</summary>
        private const string MAIL_MODE = "MOLD_DEL:";

        /// <summary>
        /// GridView1 의 Delete 버튼으로 행이 삭제된 "직후" 호출된다.
        /// Mold_SIP.aspx 의 GridView1 태그에 OnRowDeleted="GridView1_RowDeleted" 를 추가해야 동작한다.
        /// </summary>
        protected void GridView1_RowDeleted(object sender, GridViewDeletedEventArgs e)
        {
            // 실제로 삭제된 건만 메일 발송 (에러 났거나 0건이면 발송 안함)
            if (e.Exception != null || e.AffectedRows <= 0)
            {
                return;
            }

            string equipId = GetDeletedValue(e, "MACHINE_ID");   // 장비 = Equip_ID
            string lotId = GetDeletedValue(e, "LOTID");          // LOT   = Lot_ID

            if (equipId.Length == 0 && lotId.Length == 0)
            {
                return;
            }

            // 메일 발송이 실패해도 삭제 화면은 그대로 진행되어야 하므로 예외는 여기서 흡수한다.
            try
            {
                SendDeletedMoldMail(equipId, lotId);
            }
            catch (Exception ex)
            {
                System.Diagnostics.Trace.Write("RTS.KSY_SEND_MAIL(MOLD_DEL) FAIL : " + ex.Message);
            }
        }

        /// <summary>
        /// 삭제된 행의 컬럼 값을 꺼낸다.
        /// DataKeyNames 에 있는 값은 e.Keys, 나머지 BoundField 값은 e.Values 에 들어온다.
        /// (이 페이지는 ConflictDetection="CompareAllValues" 라서 전체 컬럼이 e.Values 로 넘어온다.)
        /// </summary>
        private static string GetDeletedValue(GridViewDeletedEventArgs e, string fieldName)
        {
            object value = null;

            if (e.Keys != null)
            {
                value = e.Keys[fieldName];
            }

            if (value == null && e.Values != null)
            {
                value = e.Values[fieldName];
            }

            if (value == null)
            {
                return string.Empty;
            }

            // 그리드 셀에서 넘어온 값이라 &nbsp; 등이 섞일 수 있어 정리해준다.
            return HttpUtility.HtmlDecode(Convert.ToString(value)).Replace('\u00A0', ' ').Trim();
        }

        /// <summary>RTS.KSY_SEND_MAIL 프로시저를 호출해서 Auto Mail 을 발송한다.</summary>
        private static void SendDeletedMoldMail(string equipId, string lotId)
        {
            string connStr = ConfigurationManager.AppSettings[MAIL_CONSTR_KEY];

            if (string.IsNullOrEmpty(connStr)
                && ConfigurationManager.ConnectionStrings[MAIL_CONSTR_KEY] != null)
            {
                connStr = ConfigurationManager.ConnectionStrings[MAIL_CONSTR_KEY].ConnectionString;
            }

            if (string.IsNullOrEmpty(connStr))
            {
                throw new ConfigurationErrorsException(MAIL_CONSTR_KEY + " 가 web.config 에 없습니다.");
            }

            // 구분자로 쓰는 '|' , ';' 가 값에 섞이면 프로시저 파싱이 깨지므로 제거한다.
            string pMode = MAIL_MODE
                         + equipId.Replace("|", "").Replace(";", "")
                         + "|"
                         + lotId.Replace("|", "").Replace(";", "");

            using (OracleConnection conn = new OracleConnection(connStr))
            using (OracleCommand cmd = new OracleCommand("RTS.KSY_SEND_MAIL", conn))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add(new OracleParameter("P_MODE", pMode));

                conn.Open();
                cmd.ExecuteNonQuery();
            }
        }
    }
}
