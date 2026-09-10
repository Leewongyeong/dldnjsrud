-- ======================================================================================================
-- RTS.LDA_ELOGSHEET : PRD(Prod) Material Information Head2 컬럼 추가
-- Material Information 요청사항 반영 (System1~4 + Lid 를 Head1/Head2 로 분리)
--
-- *** 이 세션에는 Oracle DB 접속 권한이 없어 아래 스크립트를 실행하지 못했습니다.
--     실제 RTS.LDA_ELOGSHEET 테이블에 접속 가능한 환경에서 검토 후 직접 실행해 주세요. ***
-- ======================================================================================================


-- 1) 먼저 기존 Head1 컬럼의 실제 타입/길이를 확인하세요.
--    아래 ALTER 문의 VARCHAR2(100) 은 추정치이며, 반드시 이 조회 결과에 맞춰 조정해야 합니다.
SELECT column_name, data_type, data_length, data_precision, data_scale, nullable
FROM   all_tab_columns
WHERE  owner = 'RTS'
AND    table_name = 'LDA_ELOGSHEET'
AND    column_name IN (
    'SYS1_INFO','SYS1_BATCH_NO','SYS1_SAP_CODE','SYS1_EXPIRE_TIME',
    'SYS2_INFO','SYS2_BATCH_NO','SYS2_SAP_CODE','SYS2_EXPIRE_TIME',
    'QA_SYS3_INFO','QA_SYS3_BATCH_NO','QA_SYS3_SAP_CODE','QA_SYS3_EXPIRE_TIME',
    'QA_SYS4_INFO','QA_SYS4_BATCH_NO','QA_SYS4_SAP_CODE','QA_SYS4_EXPIRE_TIME',
    'SYS5_INFO','SYS5_BATCH_NO'
)
ORDER BY column_id;


-- 2) Head2 컬럼 추가
--    VARCHAR2(100) / DATE 는 Head1 컬럼과 동일하다고 가정한 추정치입니다.
--    위 1) 조회 결과와 다르면 아래 크기를 맞춰서 수정한 뒤 실행하세요.
ALTER TABLE RTS.LDA_ELOGSHEET ADD (
    SYS1_INFO_2          VARCHAR2(100),
    SYS1_BATCH_NO_2      VARCHAR2(100),
    SYS1_SAP_CODE_2      VARCHAR2(100),
    SYS1_EXPIRE_TIME_2   VARCHAR2(100),   -- 코드가 문자열로 저장(TO_DATE 미사용, Head1과 동일 방식). DATE 컬럼이면 DATE 로 변경.

    SYS2_INFO_2          VARCHAR2(100),
    SYS2_BATCH_NO_2      VARCHAR2(100),
    SYS2_SAP_CODE_2      VARCHAR2(100),
    SYS2_EXPIRE_TIME_2   VARCHAR2(100),

    QA_SYS3_INFO_2       VARCHAR2(100),
    QA_SYS3_BATCH_NO_2   VARCHAR2(100),
    QA_SYS3_SAP_CODE_2   VARCHAR2(100),
    QA_SYS3_EXPIRE_TIME_2 VARCHAR2(100),

    QA_SYS4_INFO_2       VARCHAR2(100),
    QA_SYS4_BATCH_NO_2   VARCHAR2(100),
    QA_SYS4_SAP_CODE_2   VARCHAR2(100),
    QA_SYS4_EXPIRE_TIME_2 VARCHAR2(100),

    SYS5_INFO_2          VARCHAR2(100),
    SYS5_BATCH_NO_2      VARCHAR2(100)
);


-- 3) 조회 탭(Search) 결과 그리드에도 위 18개 컬럼이 "(Head2)" 라벨로 추가되어 있습니다.
--    (cim_LDAElog.aspx.cs 의 BuildGridColumns "PROD"/"PRD" case)
--    별도 SQL 작업은 필요 없습니다 — SELECT * 로 이미 새 컬럼까지 읽어옵니다.
