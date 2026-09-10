-- ======================================================================================================
-- RTS.LDA_ELOGSHEET : Material Information Head2 컬럼 추가 (PRD 탭 + QA 탭)
-- "장비 1대당 Head 2개" 요청사항 반영 (System1~4 + Lid 를 Head1/Head2 로 분리)
--
-- *** 이 세션에는 Oracle DB 접속 권한이 없어 아래 스크립트를 실행하지 못했습니다.
--     실제 RTS.LDA_ELOGSHEET 테이블에 접속 가능한 환경에서 검토 후 직접 실행해 주세요. ***
--
-- 참고: PRD 와 QA 는 아래처럼 일부 컬럼을 이미 공유하고 있습니다 (기존 스키마, 이 작업에서 바꾸지 않음).
--   - 공유:  SYS1_*, QA_SYS3_*, QA_SYS4_*, SYS5_INFO   (PRD/QA 모두 이 컬럼을 씀)
--   - 별도:  SYS2_*(PRD 전용) / QA_SYS2_*(QA 전용), SYS5_BATCH_NO(PRD 전용) / QA_SYS5_BATCH_NO(QA 전용)
-- 그래서 Head2 컬럼도 공유되는 건 하나만 추가하면 PRD/QA 둘 다 쓰고, 별도였던 건 각각 추가합니다.
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
    'QA_SYS2_INFO','QA_SYS2_BATCH_NO','QA_SYS2_SAP_CODE','QA_SYS2_EXPIRE_TIME',
    'QA_SYS3_INFO','QA_SYS3_BATCH_NO','QA_SYS3_SAP_CODE','QA_SYS3_EXPIRE_TIME',
    'QA_SYS4_INFO','QA_SYS4_BATCH_NO','QA_SYS4_SAP_CODE','QA_SYS4_EXPIRE_TIME',
    'SYS5_INFO','SYS5_BATCH_NO','QA_SYS5_BATCH_NO'
)
ORDER BY column_id;


-- 2) Head2 컬럼 추가 (PRD/QA 공유 컬럼 13개 + PRD 전용 4개 + QA 전용 5개 = 22개)
--    VARCHAR2(100) / DATE 는 Head1 컬럼과 동일하다고 가정한 추정치입니다.
--    위 1) 조회 결과와 다르면 아래 크기를 맞춰서 수정한 뒤 실행하세요.
ALTER TABLE RTS.LDA_ELOGSHEET ADD (
    -- System1 (PRD/QA 공유)
    SYS1_INFO_2          VARCHAR2(100),
    SYS1_BATCH_NO_2      VARCHAR2(100),
    SYS1_SAP_CODE_2      VARCHAR2(100),
    SYS1_EXPIRE_TIME_2   VARCHAR2(100),   -- 코드가 문자열로 저장(TO_DATE 미사용, Head1과 동일 방식). DATE 컬럼이면 DATE 로 변경.

    -- System2 (PRD 전용)
    SYS2_INFO_2          VARCHAR2(100),
    SYS2_BATCH_NO_2      VARCHAR2(100),
    SYS2_SAP_CODE_2      VARCHAR2(100),
    SYS2_EXPIRE_TIME_2   VARCHAR2(100),

    -- System2 (QA 전용)
    QA_SYS2_INFO_2        VARCHAR2(100),
    QA_SYS2_BATCH_NO_2    VARCHAR2(100),
    QA_SYS2_SAP_CODE_2    VARCHAR2(100),
    QA_SYS2_EXPIRE_TIME_2 VARCHAR2(100),

    -- System3 (PRD/QA 공유)
    QA_SYS3_INFO_2        VARCHAR2(100),
    QA_SYS3_BATCH_NO_2    VARCHAR2(100),
    QA_SYS3_SAP_CODE_2    VARCHAR2(100),
    QA_SYS3_EXPIRE_TIME_2 VARCHAR2(100),

    -- System4 (PRD/QA 공유)
    QA_SYS4_INFO_2        VARCHAR2(100),
    QA_SYS4_BATCH_NO_2    VARCHAR2(100),
    QA_SYS4_SAP_CODE_2    VARCHAR2(100),
    QA_SYS4_EXPIRE_TIME_2 VARCHAR2(100),

    -- Lid / System5
    SYS5_INFO_2          VARCHAR2(100),   -- PRD/QA 공유
    SYS5_BATCH_NO_2      VARCHAR2(100),   -- PRD 전용
    QA_SYS5_BATCH_NO_2   VARCHAR2(100)    -- QA 전용
);


-- 3) 조회 탭(Search) 결과 그리드에도 위 컬럼들이 "(Head1)"/"(Head2)" 라벨로 추가되어 있습니다.
--    (cim_LDAElog.aspx.cs 의 BuildGridColumns "PROD"/"PRD"/"QA" case)
--    별도 SQL 작업은 필요 없습니다 — SELECT * 로 이미 새 컬럼까지 읽어옵니다.
