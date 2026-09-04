--==========================================================================================
--  RTS.KSY_SEND_MAIL  (DB : SIPPRD          /  Data Modify - Mold_SIP.aspx 용)
--
--  [ 추가 위치 ]
--    기존 프로시저 맨 마지막 분기(SUBSTR(P_MODE,1,16) = 'MOLD_PE_CONFIRM:') 블록이 끝나고
--    최상위 "    END IF;" (EXCEPTION 바로 위, 원본 1887 라인) 바로 앞에 아래 ELSIF 블록을 붙여넣는다.
--
--        ...
--                           mime_type    => 'text/plain;charset=euc-kr');
--        END;
--    <<<<<< 여기에 아래 ELSIF 블록 삽입 >>>>>>
--        END IF;
--    EXCEPTION
--
--  [ 호출 방법 ]
--    RTS.KSY_SEND_MAIL('MOLD_DEL:' || EQUIP_ID || '|' || LOT_ID);
--    예) EXEC RTS.KSY_SEND_MAIL('MOLD_DEL:AS322|0000HA34Y47.0000');
--    여러 건을 한 통으로 보내려면 ';' 로 이어서 넘긴다.
--    예) EXEC RTS.KSY_SEND_MAIL('MOLD_DEL:AS322|LOT1;AS323|LOT2');
--
--  [ 사용 변수 ] 기존 선언부의 L_CRLF / L_SENDER / L_SUBJECT / L_RECIPIENTS / L_MESSAGE 를
--                그대로 사용하므로 선언부는 수정할 것이 없다.
--==========================================================================================

    ELSIF SUBSTR (P_MODE, 1, 9) = 'MOLD_DEL:'
    THEN                          -- DATA MODIFY 사이트에서 MOLD ELOG 데이터 삭제 시 알림메일
        DECLARE
            L_PAYLOAD    VARCHAR2 (4000) := TRIM (SUBSTR (P_MODE, 10));
            L_ITEM       VARCHAR2 (4000);
            L_EQUIP_ID   VARCHAR2 (100);
            L_LOT_ID     VARCHAR2 (100);
            L_POS        NUMBER;
            L_SEP        NUMBER;
        BEGIN
            L_MESSAGE := NULL;

            --  'EQUIP_ID|LOT_ID' 가 한 건, 여러 건이면 ';' 로 구분해서 넘어온다
            WHILE L_PAYLOAD IS NOT NULL
            LOOP
                L_POS := INSTR (L_PAYLOAD, ';');

                IF L_POS = 0
                THEN
                    L_ITEM := L_PAYLOAD;
                    L_PAYLOAD := NULL;
                ELSE
                    L_ITEM := SUBSTR (L_PAYLOAD, 1, L_POS - 1);
                    L_PAYLOAD := SUBSTR (L_PAYLOAD, L_POS + 1);
                END IF;

                L_ITEM := TRIM (L_ITEM);

                IF L_ITEM IS NOT NULL
                THEN
                    L_SEP := INSTR (L_ITEM, '|');

                    IF L_SEP = 0
                    THEN
                        L_EQUIP_ID := L_ITEM;
                        L_LOT_ID := NULL;
                    ELSE
                        L_EQUIP_ID := TRIM (SUBSTR (L_ITEM, 1, L_SEP - 1));
                        L_LOT_ID := TRIM (SUBSTR (L_ITEM, L_SEP + 1));
                    END IF;

                    IF LENGTH (NVL (L_MESSAGE, ' ')) < 3800
                    THEN                            -- 4000 자 넘으면 못 들어간다
                        L_MESSAGE :=
                               L_MESSAGE
                            || RPAD (NVL (L_EQUIP_ID, '-'), 20, '_')
                            || L_LOT_ID
                            || L_CRLF;
                    END IF;
                END IF;
            END LOOP;

            IF L_MESSAGE IS NOT NULL
            THEN                                 -- 넘어온 데이터 없으면 보내지 말자
                L_SENDER := 'SIP_MANAGER@jcetglobal.com';
                L_SUBJECT := 'List of deleted mold logs';
                L_RECIPIENTS := 'JSCK-ASSYPQA@statschippac.com';

                UTL_MAIL.SEND (sender       => L_SENDER,
                               recipients   => L_RECIPIENTS,
                               subject      => L_SUBJECT,
                               MESSAGE      => L_MESSAGE,
                               mime_type    => 'text/plain;charset=euc-kr');
            END IF;
        END;
