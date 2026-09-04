# Data Modify - Mold 데이터 삭제 시 Auto Mail 발송

Data Modify 사이트에서 Mold ELog 데이터를 **Delete** 할 때
`JSCK-ASSYPQA@statschippac.com` 그룹메일로 자동 발송되도록 하는 작업 정리.

| 항목 | 내용 |
|---|---|
| Subject | `List of deleted mold logs` |
| Content | `Equip_ID___________Lot_ID` (Equip_ID 를 `_` 로 20 자리 채우고 Lot_ID 이어붙임) |
| 수신 | `JSCK-ASSYPQA@statschippac.com` |
| 발신 | SOC : `CIM_MANAGER@jcetglobal.com` / SIP : `SIP_MANAGER@jcetglobal.com` |

---

## 1. 전체 구조

```
[Data Modify 사이트]                        [Oracle]
 Mold.aspx      GridView Delete 클릭
     |            (1) 기존 SqlDataSource1 DeleteCommand 실행  --> MOLDPCSD.PCSD_MOLD_ELOGSHEET  (SCK)
     |            (2) RowDeleted 이벤트에서 프로시저 호출
     +--------------------------------------------------->  RTS.KSY_SEND_MAIL @ SCKCIMDWH
                                                              P_MODE = 'MOLD_DEL:AS322|0000HA34Y47.0000'
                                                              -> UTL_MAIL.SEND

 Mold_SIP.aspx  GridView Delete 클릭
     |            (1) 기존 SqlDataSource1 DeleteCommand 실행  --> MOLDPCSD.PCSD_MOLD_ELOGSHEET  (SIP)
     |            (2) RowDeleted 이벤트에서 프로시저 호출
     +--------------------------------------------------->  RTS.KSY_SEND_MAIL @ SIPPRD
                                                              P_MODE = 'MOLD_DEL:AS322|0000HA34Y47.0000'
                                                              -> UTL_MAIL.SEND
```

**핵심 : 프로시저 signature(`P_MODE` 1개)를 바꾸지 않는다.**
기존 SIP 프로시저의 `MOLD_PE_CONFIRM:` 분기와 똑같이 `'MOLD_DEL:' + 값` 형태로 P_MODE 뒤에 값을 실어 보낸다.
그래야 스케줄러/배치에서 이미 호출중인 40여 개 기존 모드에 아무 영향이 없다.

---

## 2. 수정 파일 목록

> **전제** : `Mold.aspx.cs` / `Mold_SIP.aspx.cs` **원본 소스가 없다** (구버전 배포, 코드비하인드는
> 이미 컴파일된 DLL 상태로만 서버에 있음). 그래서 코드비하인드는 손대지 않고,
> **`.aspx` 마크업 파일 안에 `<script runat="server">` 인라인 코드**로 전부 처리한다.
>
> ASP.NET 은 `CodeBehind` 방식이어도 요청이 들어올 때마다 `.aspx` 를 파싱해서
> `Inherits="Data_modify.Mold"` (기존 배포된 클래스) 를 **상속하는 새 클래스를 런타임에 동적 컴파일**한다.
> 이때 `.aspx` 안의 `<script runat="server">` 코드는 그 파생 클래스의 멤버로 그대로 포함되므로,
> 원본 `.cs` 소스나 프로젝트 없이도 IIS 에 `.aspx` 텍스트 파일만 새로 올리면
> 다음 요청부터 자동 반영된다 (재컴파일/재배포 불필요).

| 파일 | 수정 내용 |
|---|---|
| `Mold.aspx` | ① `<%@ Import %>` 지시문 + `<script runat="server">` 블록 추가, ② GridView1 태그에 `OnRowDeleted="GridView1_RowDeleted"` 추가 (**이 저장소 루트에 수정본 있음**) |
| `Mold_SIP.aspx` | 동일 (**이 저장소 루트에 수정본 있음**) |
| `Mold.aspx.cs` / `Mold_SIP.aspx.cs` | **수정 안 함** (원본 없음 → 건드릴 필요도 없음) |
| `web.config` | appSettings 접속 문자열 2개 확인/추가 → `web.config.snippet.xml` (이건 컴파일 대상이 아닌 설정 파일이라 원본 프로젝트 없이도 편집 가능) |
| `RTS.KSY_SEND_MAIL` (SCKCIMDWH) | `MOLD_DEL:` 분기 추가 → `KSY_SEND_MAIL_MOLD_DEL_SCKCIMDWH.sql` |
| `RTS.KSY_SEND_MAIL` (SIPPRD) | `MOLD_DEL:` 분기 추가 → `KSY_SEND_MAIL_MOLD_DEL_SIPPRD.sql` |

> `Mold.aspx.cs.snippet.cs` / `Mold_SIP.aspx.cs.snippet.cs` 는 **참고용(대안)** 으로 남겨둔다.
> 나중에 원본 프로젝트/소스를 구해서 정식으로 코드비하인드에 넣고 싶어지면 그 내용을 그대로 옮기면 된다.
> 지금 당장 배포하는 버전은 `.aspx` 인라인 스크립트만으로 완결된다.

---

## 3. 화면(.aspx) 수정 — Import 지시문 + 인라인 스크립트 + 이벤트 연결

`Mold.aspx` 기준 (`Mold_SIP.aspx` 는 커넥션 key 만 다름). `@ Page` 지시문 바로 아래,
첫 `<asp:Content>` 시작 전에 아래를 통째로 추가한다.

```aspx
<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Mold.aspx.cs" Inherits="Data_modify.Mold" %>
<%@ Import Namespace="System" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Web" %>
<%@ Import Namespace="System.Web.UI.WebControls" %>
<%@ Import Namespace="System.Configuration" %>
<%@ Import Namespace="Oracle.DataAccess.Client" %>
<script runat="server">

    private const string MAIL_CONSTR_KEY = "_CONSTR_RTS_SCKCIMDWH";
    private const string MAIL_MODE = "MOLD_DEL:";

    protected void GridView1_RowDeleted(object sender, GridViewDeletedEventArgs e)
    {
        if (e.Exception != null || e.AffectedRows <= 0) return;   // 진짜 지워진 건만

        string equipId = GetDeletedValue(e, "MACHINE_ID");
        string lotId = GetDeletedValue(e, "LOTID");
        if (equipId.Length == 0 && lotId.Length == 0) return;

        try { SendDeletedMoldMail(equipId, lotId); }
        catch (Exception ex)
        {
            System.Diagnostics.Trace.Write("RTS.KSY_SEND_MAIL(MOLD_DEL) FAIL : " + ex.Message);
        }
    }

    private static string GetDeletedValue(GridViewDeletedEventArgs e, string fieldName)
    {
        object value = null;
        if (e.Keys != null) value = e.Keys[fieldName];
        if (value == null && e.Values != null) value = e.Values[fieldName];
        if (value == null) return string.Empty;

        return HttpUtility.HtmlDecode(Convert.ToString(value)).Replace('\u00A0', ' ').Trim();
    }

    private static void SendDeletedMoldMail(string equipId, string lotId)
    {
        string connStr = ConfigurationManager.AppSettings[MAIL_CONSTR_KEY];
        if (string.IsNullOrEmpty(connStr) && ConfigurationManager.ConnectionStrings[MAIL_CONSTR_KEY] != null)
            connStr = ConfigurationManager.ConnectionStrings[MAIL_CONSTR_KEY].ConnectionString;
        if (string.IsNullOrEmpty(connStr))
            throw new ConfigurationErrorsException(MAIL_CONSTR_KEY + " 가 web.config 에 없습니다.");

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

</script>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    ...
```

(실제 삽입된 전체 내용은 저장소 루트의 `Mold.aspx` / `Mold_SIP.aspx` 참고. `Mold_SIP.aspx` 는
`MAIL_CONSTR_KEY` 값만 `"_CONSTR_RTS_SIPPRD"` 로 다르다.)

그리고 GridView1 여는 태그에 이벤트를 연결한다.

```diff
         <asp:GridView ID="GridView1" runat="server"
             AutoGenerateColumns="False" BackColor="White" BorderColor="#DEDFDE"
             BorderStyle="None" BorderWidth="1px" CellPadding="4" DataKeyNames="SEQ"
             DataSourceID="SqlDataSource1" ForeColor="Black" GridLines="Vertical"
-            Font-Names="Tahoma" Font-Size="X-Small">
+            Font-Names="Tahoma" Font-Size="X-Small"
+            OnRowDeleted="GridView1_RowDeleted">
```

> `RowDeleting`(삭제 전)이 아니라 **`RowDeleted`(삭제 후)** 를 쓴다.
> 삭제가 실패했는데 메일만 나가는 상황을 막기 위함이다.
> SqlDataSource / DeleteCommand / DeleteParameters 는 **전혀 손대지 않는다.**

### 값 꺼내는 부분 주의사항

* `DataKeyNames="SEQ"` 라서 **MACHINE_ID / LOTID 는 `e.Keys` 가 아니라 `e.Values` 에 들어온다.**
* 이 페이지는 `ConflictDetection="CompareAllValues"` 라서 DELETE 문의 `original_*` 파라미터용으로
  **전체 컬럼이 이미 `e.Values` 로 넘어오고 있다.** (그래서 지금 삭제가 정상 동작하는 것)
  → 별도 조회 없이 그대로 쓰면 된다.
* `GetDeletedValue()` 는 `e.Keys` → `e.Values` 순으로 찾으므로, 혹시 값이 안 넘어오면
  `.aspx` 의 `DataKeyNames="SEQ"` 를 `DataKeyNames="SEQ,MACHINE_ID,LOTID"` 로만 바꾸면
  코드 수정 없이 그대로 동작한다. (키가 늘어나도 기존 DELETE 문은 그대로 동작함)

### 인라인 스크립트 관련 주의사항

* **네임스페이스 임포트는 `using` 이 아니라 `<%@ Import Namespace="..." %>` 지시문**으로 한다.
  (인라인 코드는 클래스 본문에 들어가는 것이라 `using` 지시문을 쓸 수 없다)
* Oracle Provider 는 사이트에서 쓰는 것에 맞춘다.
  ODP.NET 이면 `Oracle.DataAccess.Client`, Devart 면 `Devart.Data.Oracle` 로
  `<%@ Import %>` 한 줄만 바꾸면 된다. (접속 문자열의 `Validate Connection=True` 는 두 Provider 다 지원)
* **데이터 삭제용 커넥션(MoldConnectionString)과 별개의 커넥션**을 새로 연다. 삭제 트랜잭션과
  무관하므로 메일이 실패해도 삭제는 이미 커밋되어 있고, 반대로 메일 때문에 삭제가 롤백되지도 않는다.
* `MAIL_CONSTR_KEY`, `GetDeletedValue`, `SendDeletedMoldMail` 같은 이름이 기존(보이지 않는)
  `Mold.aspx.cs` 안에 **이미 있을 가능성은 낮지만**, 배포 후 컴파일 에러(`중복된 멤버` 등)가 나면
  이름이 겹친 것이므로 이 블록의 이름만 다른 걸로 바꿔주면 된다.

---

## 4. 프로시저 수정

두 DB 모두 프로시저명은 `RTS.KSY_SEND_MAIL` 로 같고, **분기(ELSIF) 하나만 추가**한다.
선언부(변수)는 손댈 게 없다. 기존 `L_CRLF / L_SENDER / L_SUBJECT / L_RECIPIENTS / L_MESSAGE` 재사용.

### 4-1. SCKCIMDWH (Mold.aspx 용) — `KSY_SEND_MAIL_MOLD_DEL_SCKCIMDWH.sql`

맨 마지막 분기 `P_MODE = 'DPELOG_RELEASE'` 가 끝나고 최상위 `END IF;` (EXCEPTION 바로 위) 앞에 삽입.

```
        CLOSE C_DPELOG_RELEASE;
    ELSIF SUBSTR (P_MODE, 1, 9) = 'MOLD_DEL:'     <-- 여기부터 추가
    THEN
        ...
    END IF;
EXCEPTION
```

### 4-2. SIPPRD (Mold_SIP.aspx 용) — `KSY_SEND_MAIL_MOLD_DEL_SIPPRD.sql`

맨 마지막 분기 `SUBSTR(P_MODE,1,16) = 'MOLD_PE_CONFIRM:'` 블록이 끝나고 최상위 `END IF;` 앞에 삽입.
내용은 SCK 와 동일하고 **발신자만 `SIP_MANAGER@jcetglobal.com`** 이다.

### 4-3. 추가되는 분기 내용

```sql
    ELSIF SUBSTR (P_MODE, 1, 9) = 'MOLD_DEL:'
    THEN
        DECLARE
            L_PAYLOAD   VARCHAR2 (4000) := TRIM (SUBSTR (P_MODE, 10));
            ...
        BEGIN
            -- 'EQUIP_ID|LOT_ID' 파싱 (여러 건이면 ';' 로 구분)
            ...
            L_MESSAGE := L_MESSAGE || RPAD (L_EQUIP_ID, 20, '_') || L_LOT_ID || L_CRLF;
            ...
            IF L_MESSAGE IS NOT NULL THEN
                L_SENDER     := 'CIM_MANAGER@jcetglobal.com';   -- SIP 는 SIP_MANAGER@
                L_SUBJECT    := 'List of deleted mold logs';
                L_RECIPIENTS := 'JSCK-ASSYPQA@statschippac.com';

                UTL_MAIL.SEND (sender     => L_SENDER,
                               recipients => L_RECIPIENTS,
                               subject    => L_SUBJECT,
                               MESSAGE    => L_MESSAGE,
                               mime_type  => 'text/plain;charset=euc-kr');
            END IF;
        END;
```

* 넘어온 값이 없으면 메일을 보내지 않는다.
* `L_MESSAGE` 가 `VARCHAR2(4000)` 이므로 3800 자에서 끊는다 (기존 다른 모드와 동일한 방식).
* 한 번에 여러 건을 보내고 싶으면 `MOLD_DEL:AS322|LOT1;AS323|LOT2` 처럼 `;` 로 이어서 넘기면
  한 통에 여러 줄로 나간다. 지금 화면은 한 행씩 삭제하므로 **삭제 1건 = 메일 1통** 이다.

---

## 5. 테스트 방법

### 프로시저 단독 테스트 (SQL*Plus / Toad)

```sql
-- SCKCIMDWH 접속 후
EXEC RTS.KSY_SEND_MAIL('MOLD_DEL:AS322|0000HA34Y47.0000');

-- SIPPRD 접속 후
EXEC RTS.KSY_SEND_MAIL('MOLD_DEL:AS322|0000HA34Y47.0000');
```

받은 메일이 아래와 같으면 정상.

```
Subject : List of deleted mold logs

AS322_______________0000HA34Y47.0000
```

수신자 테스트 중에는 `L_RECIPIENTS` 를 본인 메일로 바꿔서 확인한 뒤 그룹메일로 되돌린다.

### 화면 테스트

1. Data Modify → Mold 화면에서 Lot ID 조회
2. 한 행 Delete 클릭
3. 그리드에서 행이 사라지는지 확인 → 메일 수신 확인
4. Mold SIP 화면도 동일하게 확인

---

## 6. 확인/주의 사항

* **인라인 스크립트가 안 통하는 경우** : 사이트가 `aspnet_compiler` 로 "고정 네이밍 + 단일 어셈블리(-fixednames, 즉 마크업 없는 완전 사전컴파일)" 로 배포되어 있으면 서버에 `.aspx` 텍스트 자체가 없어서 이 방법이 안 통한다.
  지금 받은 파일들이 실제 `.aspx` 텍스트라는 건 서버에도 `.aspx` 원본이 그대로 배포돼 있다는 뜻이라 대부분의 경우(특히 오래된 사내 사이트)는 문제없다. 배포 후 페이지가 뜨는지만 확인하면 된다.
* 인라인 스크립트를 넣은 `.aspx` 를 배포하면 **해당 페이지의 첫 요청에서 서버가 새로 컴파일**하느라 살짝(보통 1초 내) 지연이 있을 수 있다. 이후 요청부터는 캐시된 어셈블리로 정상 속도.
* **UTL_MAIL 사용 가능 여부** : 두 DB 다 이미 다른 모드에서 `UTL_MAIL.SEND` 를 쓰고 있으므로
  패키지 설치, `SMTP_OUT_SERVER` 파라미터, ACL 은 이미 되어 있다. 추가 작업 없음.
* **권한** : 웹에서 쓰는 계정이 `rts` (프로시저 소유자) 이므로 별도 GRANT 불필요.
* 삭제가 실패하면(`e.AffectedRows = 0`) 메일이 나가지 않는다.
* 메일 발송이 실패해도 삭제는 이미 완료된 상태로 유지된다 (`try/catch` 로 흡수, Trace 에만 기록).
* 삭제자(사번), 삭제 시각, SITE 를 메일 본문에 같이 넣고 싶으면
  프로시저의 `L_MESSAGE` 앞에 `L_MESSAGE_HEAD` 를 붙이거나, 호출 시 P_MODE 뒤에 값을 하나 더
  실어 보내면 된다. (현재는 요청받은 `Equip_ID + Lot_ID` 만 발송)
