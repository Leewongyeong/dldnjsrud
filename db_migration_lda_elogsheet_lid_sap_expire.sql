-- ======================================================================================================
-- RTS.LDA_ELOGSHEET : Lid SAP Code / Expire Time 컬럼 추가
--
-- 이미 통합 스키마로 테이블을 재생성하신 상태라 이전 마이그레이션 파일
-- (db_migration_lda_elogsheet_head2.sql) 은 더 이상 필요 없습니다 — 이 파일만 실행하면 됩니다.
--
-- Lid(System5) 는 지금까지 Information / Batch No 만 있고 System1~4 에는 있는
-- SAP Code / Expire Time 이 없었습니다. 신규 컬럼이라 기존 데이터에 영향 없이
-- ADD 만 하면 됩니다 (기존 행은 NULL로 채워짐).
--
-- *** 이 세션에는 Oracle DB 접속 권한이 없어 실행하지 못했습니다. 직접 실행해 주세요. ***
-- ======================================================================================================

ALTER TABLE RTS.LDA_ELOGSHEET ADD (
    SYS5_SAP_CODE        VARCHAR2(100),   -- System1~4 의 SAP Code 컬럼과 동일한 크기로 맞춤 (필요시 조정)
    SYS5_EXPIRE_TIME     VARCHAR2(100),
    SYS5_SAP_CODE_2      VARCHAR2(100),
    SYS5_EXPIRE_TIME_2   VARCHAR2(100)
);

-- 확인
SELECT column_name, data_type, data_length
FROM   all_tab_columns
WHERE  owner = 'RTS'
AND    table_name = 'LDA_ELOGSHEET'
AND    column_name IN ('SYS5_SAP_CODE','SYS5_EXPIRE_TIME','SYS5_SAP_CODE_2','SYS5_EXPIRE_TIME_2')
ORDER BY column_id;
