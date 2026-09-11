-- ======================================================================================================
-- RTS.LDA_ELOGSHEET : Lid SAP Code 컬럼 추가 (Expire Time 은 불필요하다는 요청에 따라 제외)
--
-- *** 이 세션에는 Oracle DB 접속 권한이 없어 실행하지 못했습니다. 직접 실행해 주세요. ***
-- ======================================================================================================


-- [아직 컬럼을 하나도 추가하지 않으셨다면] 이 ALTER 만 실행하면 됩니다.
ALTER TABLE RTS.LDA_ELOGSHEET ADD (
    SYS5_SAP_CODE        VARCHAR2(100),   -- System1~4 의 SAP Code 컬럼과 동일한 크기로 맞춤 (필요시 조정)
    SYS5_SAP_CODE_2      VARCHAR2(100)
);


-- [이전 버전(db_migration_lda_elogsheet_lid_sap_expire.sql 구버전)을 이미 실행해서
--  SYS5_EXPIRE_TIME / SYS5_EXPIRE_TIME_2 까지 이미 추가하셨다면] 위 ALTER 대신 이걸 실행하세요.
--  (신규 컬럼이라 데이터가 들어있을 수 없으므로 백업/백필 없이 바로 삭제해도 안전합니다)
-- ALTER TABLE RTS.LDA_ELOGSHEET DROP (SYS5_EXPIRE_TIME, SYS5_EXPIRE_TIME_2);


-- 확인
SELECT column_name, data_type, data_length
FROM   all_tab_columns
WHERE  owner = 'RTS'
AND    table_name = 'LDA_ELOGSHEET'
AND    column_name LIKE 'SYS5_%'
ORDER BY column_id;
-- SYS5_INFO, SYS5_BATCH_NO, SYS5_SAP_CODE, SYS5_INFO_2, SYS5_BATCH_NO_2, SYS5_SAP_CODE_2
-- 6개만 나와야 정상입니다 (SYS5_EXPIRE_TIME 계열은 없어야 함).
