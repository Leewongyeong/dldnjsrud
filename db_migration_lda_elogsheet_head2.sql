-- ======================================================================================================
-- RTS.LDA_ELOGSHEET : Material Information 컬럼 정리 + Head2 추가 (PRD 탭 + QA 탭)
--
-- 배경: 기존 스키마는 System1 / System3 / System4 / Lid Info 는 PRD·QA 가 컬럼을 공유하면서
--       System2 / Lid Batch No 만 PRD 전용(SYS2_*, SYS5_BATCH_NO) / QA 전용(QA_SYS2_*, QA_SYS5_BATCH_NO)
--       으로 갈라져 있었다. ELOGSHEET_TYPE('PROD'/'QA') 으로 이미 행을 구분할 수 있으므로 컬럼을
--       나눌 이유가 없다 — 아래 스크립트로 전부 통일한다.
--
-- 목표 스키마 (Head1):  SYS1_*, SYS2_*, SYS3_*, SYS4_*, SYS5_INFO, SYS5_BATCH_NO
-- 목표 스키마 (Head2):  위 컬럼명 + "_2" 접미사
-- QA_ 접두어는 진짜 QA 전용 필드(QA_SYS1_PATTERN, QA_SYS2_PATTERN, QA_DUMMY_COVERAGE 등)에만 남긴다.
--
-- *** 이 세션에는 Oracle DB 접속 권한이 없어 아래 스크립트를 실행하지 못했습니다.
--     실제 RTS.LDA_ELOGSHEET 테이블에 접속 가능한 환경에서 STEP 순서대로 직접 실행해 주세요.
--     이 마이그레이션을 다 마친 뒤에 새 코드(cim_LDAElog.aspx / .aspx.cs)를 배포해야 합니다
--     (컬럼명이 바뀌므로 DB 반영 전에 새 코드가 먼저 올라가면 "invalid identifier" 오류가 납니다). ***
-- ======================================================================================================


-- ------------------------------------------------------------------------------------------------------
-- STEP 0. 백업 (되돌릴 수 있도록 원본 테이블을 통째로 복사해 둔다)
-- ------------------------------------------------------------------------------------------------------
CREATE TABLE RTS.LDA_ELOGSHEET_BAK_20260910 AS
SELECT * FROM RTS.LDA_ELOGSHEET;

-- 건수가 원본과 같은지 확인
SELECT (SELECT COUNT(*) FROM RTS.LDA_ELOGSHEET) AS ORIG_CNT,
       (SELECT COUNT(*) FROM RTS.LDA_ELOGSHEET_BAK_20260910) AS BAK_CNT
FROM DUAL;


-- ------------------------------------------------------------------------------------------------------
-- STEP 1. 기존 Head1 컬럼의 실제 타입/길이 확인
--    STEP 4 의 VARCHAR2(100) 은 추정치이며, 반드시 이 조회 결과에 맞춰 조정해야 합니다.
-- ------------------------------------------------------------------------------------------------------
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


-- ------------------------------------------------------------------------------------------------------
-- STEP 2. System3 / System4 컬럼명 정리 (RENAME 만 — 데이터 그대로 유지, 안전)
--    이미 PRD/QA 가 공유해서 쓰던 컬럼이라 이름만 바꾼다. 만약 SYS3_INFO 등의 이름이 이미
--    존재한다면 ORA-00957(중복 컬럼) 로 즉시 실패하니, 그 경우 먼저 원인을 확인하세요.
-- ------------------------------------------------------------------------------------------------------
ALTER TABLE RTS.LDA_ELOGSHEET RENAME COLUMN QA_SYS3_INFO        TO SYS3_INFO;
ALTER TABLE RTS.LDA_ELOGSHEET RENAME COLUMN QA_SYS3_BATCH_NO    TO SYS3_BATCH_NO;
ALTER TABLE RTS.LDA_ELOGSHEET RENAME COLUMN QA_SYS3_SAP_CODE    TO SYS3_SAP_CODE;
ALTER TABLE RTS.LDA_ELOGSHEET RENAME COLUMN QA_SYS3_EXPIRE_TIME TO SYS3_EXPIRE_TIME;

ALTER TABLE RTS.LDA_ELOGSHEET RENAME COLUMN QA_SYS4_INFO        TO SYS4_INFO;
ALTER TABLE RTS.LDA_ELOGSHEET RENAME COLUMN QA_SYS4_BATCH_NO    TO SYS4_BATCH_NO;
ALTER TABLE RTS.LDA_ELOGSHEET RENAME COLUMN QA_SYS4_SAP_CODE    TO SYS4_SAP_CODE;
ALTER TABLE RTS.LDA_ELOGSHEET RENAME COLUMN QA_SYS4_EXPIRE_TIME TO SYS4_EXPIRE_TIME;


-- ------------------------------------------------------------------------------------------------------
-- STEP 3. System2 / Lid Batch No 컬럼 통합 (백필 -> 검증 -> 삭제)
--    PRD 는 SYS2_*/SYS5_BATCH_NO 에, QA 는 QA_SYS2_*/QA_SYS5_BATCH_NO 에 각자 저장해 왔으므로
--    QA 쪽 데이터를 공용 컬럼으로 옮긴 뒤에 옛 컬럼을 지운다.
-- ------------------------------------------------------------------------------------------------------

-- 3-1) 백필: QA 로 저장된 행(ELOGSHEET_TYPE='QA')의 System2/Lid Batch No 값을 공용 컬럼으로 복사.
--      PRD 행(ELOGSHEET_TYPE='PROD')은 WHERE 조건에 안 걸리므로 기존 SYS2_*/SYS5_BATCH_NO 값이
--      그대로 보존된다.
UPDATE RTS.LDA_ELOGSHEET
SET    SYS2_INFO        = QA_SYS2_INFO,
       SYS2_BATCH_NO    = QA_SYS2_BATCH_NO,
       SYS2_SAP_CODE    = QA_SYS2_SAP_CODE,
       SYS2_EXPIRE_TIME = QA_SYS2_EXPIRE_TIME,
       SYS5_BATCH_NO    = QA_SYS5_BATCH_NO
WHERE  ELOGSHEET_TYPE = 'QA';

COMMIT;

-- 3-2) 검증: 아래 쿼리가 0건이어야 백필이 완전히 성공한 것입니다.
--      0건이 아니면 STEP 3-3(삭제) 을 진행하지 말고 원인을 먼저 확인하세요.
SELECT SEQ, LOT_ID,
       QA_SYS2_INFO, SYS2_INFO,
       QA_SYS2_BATCH_NO, SYS2_BATCH_NO,
       QA_SYS2_SAP_CODE, SYS2_SAP_CODE,
       QA_SYS2_EXPIRE_TIME, SYS2_EXPIRE_TIME,
       QA_SYS5_BATCH_NO, SYS5_BATCH_NO
FROM   RTS.LDA_ELOGSHEET
WHERE  ELOGSHEET_TYPE = 'QA'
AND  ( NVL(QA_SYS2_INFO,        '~') != NVL(SYS2_INFO,        '~')
    OR NVL(QA_SYS2_BATCH_NO,    '~') != NVL(SYS2_BATCH_NO,    '~')
    OR NVL(QA_SYS2_SAP_CODE,    '~') != NVL(SYS2_SAP_CODE,    '~')
    OR NVL(QA_SYS2_EXPIRE_TIME, '~') != NVL(SYS2_EXPIRE_TIME, '~')
    OR NVL(QA_SYS5_BATCH_NO,    '~') != NVL(SYS5_BATCH_NO,    '~') );

-- ##########################################################################################
-- # STOP — 바로 위 검증 쿼리가 0건으로 나온 것을 직접 확인한 뒤에만 아래 3-3(삭제)을 실행하세요. #
-- ##########################################################################################

-- 3-3) 옛 QA 전용 컬럼 삭제 (되돌릴 수 없음 — STEP 0 백업 테이블에는 남아있음)
ALTER TABLE RTS.LDA_ELOGSHEET DROP (
    QA_SYS2_INFO,
    QA_SYS2_BATCH_NO,
    QA_SYS2_SAP_CODE,
    QA_SYS2_EXPIRE_TIME,
    QA_SYS5_BATCH_NO
);


-- ------------------------------------------------------------------------------------------------------
-- STEP 4. Head2 컬럼 추가 (전부 신규 컬럼이라 백필 불필요, 통일된 이름으로 바로 추가)
--    VARCHAR2(100) / DATE 는 Head1 컬럼과 동일하다고 가정한 추정치입니다.
--    STEP 1 조회 결과와 다르면 아래 크기를 맞춰서 수정한 뒤 실행하세요.
-- ------------------------------------------------------------------------------------------------------
ALTER TABLE RTS.LDA_ELOGSHEET ADD (
    SYS1_INFO_2          VARCHAR2(100),
    SYS1_BATCH_NO_2      VARCHAR2(100),
    SYS1_SAP_CODE_2      VARCHAR2(100),
    SYS1_EXPIRE_TIME_2   VARCHAR2(100),   -- 코드가 문자열로 저장(TO_DATE 미사용, Head1과 동일 방식). DATE 컬럼이면 DATE 로 변경.

    SYS2_INFO_2          VARCHAR2(100),
    SYS2_BATCH_NO_2      VARCHAR2(100),
    SYS2_SAP_CODE_2      VARCHAR2(100),
    SYS2_EXPIRE_TIME_2   VARCHAR2(100),

    SYS3_INFO_2          VARCHAR2(100),
    SYS3_BATCH_NO_2      VARCHAR2(100),
    SYS3_SAP_CODE_2      VARCHAR2(100),
    SYS3_EXPIRE_TIME_2   VARCHAR2(100),

    SYS4_INFO_2          VARCHAR2(100),
    SYS4_BATCH_NO_2      VARCHAR2(100),
    SYS4_SAP_CODE_2      VARCHAR2(100),
    SYS4_EXPIRE_TIME_2   VARCHAR2(100),

    SYS5_INFO_2          VARCHAR2(100),
    SYS5_BATCH_NO_2      VARCHAR2(100)
);


-- ------------------------------------------------------------------------------------------------------
-- STEP 5. 최종 확인
-- ------------------------------------------------------------------------------------------------------
SELECT column_name, data_type, data_length
FROM   all_tab_columns
WHERE  owner = 'RTS'
AND    table_name = 'LDA_ELOGSHEET'
AND    (column_name LIKE 'SYS%' OR column_name LIKE 'QA_SYS%')
ORDER BY column_id;

-- QA_SYS1_PATTERN, QA_SYS2_PATTERN 만 QA_ 접두어로 남아있어야 정상입니다
-- (이 둘은 진짜 QA 전용 필드 — TIM/Glue Pattern — 라서 그대로 둡니다).


-- ------------------------------------------------------------------------------------------------------
-- (참고) 조회 탭(Search) 결과 그리드에도 위 컬럼들이 "(Head1)"/"(Head2)" 라벨로 이미 반영되어 있습니다.
--    (cim_LDAElog.aspx.cs 의 BuildGridColumns "PROD"/"PRD"/"QA" case) — 별도 SQL 작업 불필요.
-- ------------------------------------------------------------------------------------------------------
