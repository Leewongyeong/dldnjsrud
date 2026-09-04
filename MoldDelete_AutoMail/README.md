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

| 파일 | 수정 내용 |
|---|---|
| `Mold.aspx` | GridView1 태그에 `OnRowDeleted="GridView1_RowDeleted"` 1줄 추가 (**이 저장소 루트에 수정본 있음**) |
| `Mold_SIP.aspx` | 동일 (**이 저장소 루트에 수정본 있음**) |
| `Mold.aspx.cs` | 이벤트 핸들러 + 프로시저 호출 메서드 추가 → `Mold.aspx.cs.snippet.cs` |
| `Mold_SIP.aspx.cs` | 동일 → `Mold_SIP.aspx.cs.snippet.cs` |
| `web.config` | appSettings 접속 문자열 2개 확인/추가 → `web.config.snippet.xml` |
| `RTS.KSY_SEND_MAIL` (SCKCIMDWH) | `MOLD_DEL:` 분기 추가 → `KSY_SEND_MAIL_MOLD_DEL_SCKCIMDWH.sql` |
| `RTS.KSY_SEND_MAIL` (SIPPRD) | `MOLD_DEL:` 분기 추가 → `KSY_SEND_MAIL_MOLD_DEL_SIPPRD.sql` |

---

## 3. 화면(.aspx) 수정

`Mold.aspx` / `Mold_SIP.aspx` 둘 다 GridView1 여는 태그에 이벤트 하나만 추가한다.

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

---

## 4. 코드비하인드(.aspx.cs) 수정

`Mold.aspx.cs.snippet.cs` / `Mold_SIP.aspx.cs.snippet.cs` 내용을 기존 클래스 안에 붙여넣는다.
두 파일 차이는 **클래스명 / 접속 문자열 key / 발신자** 뿐이다.

핵심 로직 3단계.

```csharp
protected void GridView1_RowDeleted(object sender, GridViewDeletedEventArgs e)
{
    // (1) 진짜 지워진 건만
    if (e.Exception != null || e.AffectedRows <= 0) return;

    // (2) 지워진 행에서 장비/LOT 꺼내기
    string equipId = GetDeletedValue(e, "MACHINE_ID");
    string lotId   = GetDeletedValue(e, "LOTID");
    if (equipId.Length == 0 && lotId.Length == 0) return;

    // (3) 메일 발송 (실패해도 화면은 안 죽게 try/catch)
    try   { SendDeletedMoldMail(equipId, lotId); }
    catch (Exception ex) { System.Diagnostics.Trace.Write("... FAIL : " + ex.Message); }
}
```

### 값 꺼내는 부분 주의사항

* `DataKeyNames="SEQ"` 라서 **MACHINE_ID / LOTID 는 `e.Keys` 가 아니라 `e.Values` 에 들어온다.**
* 이 페이지는 `ConflictDetection="CompareAllValues"` 라서 DELETE 문의 `original_*` 파라미터용으로
  **전체 컬럼이 이미 `e.Values` 로 넘어오고 있다.** (그래서 지금 삭제가 정상 동작하는 것)
  → 별도 조회 없이 그대로 쓰면 된다.
* snippet 의 `GetDeletedValue()` 는 `e.Keys` → `e.Values` 순으로 찾으므로,
  혹시 값이 안 넘어오면 `.aspx` 의 `DataKeyNames="SEQ"` 를 `DataKeyNames="SEQ,MACHINE_ID,LOTID"` 로만
  바꾸면 코드 수정 없이 그대로 동작한다. (키가 늘어나도 기존 DELETE 문은 그대로 동작함)

### 프로시저 호출

```csharp
using (OracleConnection conn = new OracleConnection(connStr))
using (OracleCommand cmd = new OracleCommand("RTS.KSY_SEND_MAIL", conn))
{
    cmd.CommandType = CommandType.StoredProcedure;
    cmd.Parameters.Add(new OracleParameter("P_MODE", "MOLD_DEL:" + equipId + "|" + lotId));
    conn.Open();
    cmd.ExecuteNonQuery();
}
```

* `connStr` : `ConfigurationManager.AppSettings["_CONSTR_RTS_SCKCIMDWH"]` (SIP 는 `_CONSTR_RTS_SIPPRD`)
* **데이터 삭제용 커넥션(MoldConnectionString)과 별개의 커넥션**이다. 삭제 트랜잭션과 무관하므로
  메일이 실패해도 삭제는 이미 커밋되어 있고, 반대로 메일 때문에 삭제가 롤백되지도 않는다.
* Oracle Provider 는 사이트에서 쓰는 것에 맞춘다.
  ODP.NET 이면 `Oracle.DataAccess.Client`, Devart 면 `Devart.Data.Oracle` 로 using 만 바꾸면 된다.
  (접속 문자열의 `Validate Connection=True` 는 두 Provider 다 지원한다)

---

## 5. 프로시저 수정

두 DB 모두 프로시저명은 `RTS.KSY_SEND_MAIL` 로 같고, **분기(ELSIF) 하나만 추가**한다.
선언부(변수)는 손댈 게 없다. 기존 `L_CRLF / L_SENDER / L_SUBJECT / L_RECIPIENTS / L_MESSAGE` 재사용.

### 5-1. SCKCIMDWH (Mold.aspx 용) — `KSY_SEND_MAIL_MOLD_DEL_SCKCIMDWH.sql`

맨 마지막 분기 `P_MODE = 'DPELOG_RELEASE'` 가 끝나고 최상위 `END IF;` (EXCEPTION 바로 위) 앞에 삽입.

```
        CLOSE C_DPELOG_RELEASE;
    ELSIF SUBSTR (P_MODE, 1, 9) = 'MOLD_DEL:'     <-- 여기부터 추가
    THEN
        ...
    END IF;
EXCEPTION
```

### 5-2. SIPPRD (Mold_SIP.aspx 용) — `KSY_SEND_MAIL_MOLD_DEL_SIPPRD.sql`

맨 마지막 분기 `SUBSTR(P_MODE,1,16) = 'MOLD_PE_CONFIRM:'` 블록이 끝나고 최상위 `END IF;` 앞에 삽입.
내용은 SCK 와 동일하고 **발신자만 `SIP_MANAGER@jcetglobal.com`** 이다.

### 5-3. 추가되는 분기 내용

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

## 6. 테스트 방법

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

## 7. 확인/주의 사항

* **UTL_MAIL 사용 가능 여부** : 두 DB 다 이미 다른 모드에서 `UTL_MAIL.SEND` 를 쓰고 있으므로
  패키지 설치, `SMTP_OUT_SERVER` 파라미터, ACL 은 이미 되어 있다. 추가 작업 없음.
* **권한** : 웹에서 쓰는 계정이 `rts` (프로시저 소유자) 이므로 별도 GRANT 불필요.
* 삭제가 실패하면(`e.AffectedRows = 0`) 메일이 나가지 않는다.
* 메일 발송이 실패해도 삭제는 이미 완료된 상태로 유지된다 (`try/catch` 로 흡수, Trace 에만 기록).
* 삭제자(사번), 삭제 시각, SITE 를 메일 본문에 같이 넣고 싶으면
  프로시저의 `L_MESSAGE` 앞에 `L_MESSAGE_HEAD` 를 붙이거나, 호출 시 P_MODE 뒤에 값을 하나 더
  실어 보내면 된다. (현재는 요청받은 `Equip_ID + Lot_ID` 만 발송)
