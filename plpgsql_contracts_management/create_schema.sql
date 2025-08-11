CREATE SCHEMA IF NOT EXISTS contract_comment_pkg;

-- Процедура для добавления комментария
CREATE OR REPLACE FUNCTION contract_comment_pkg.add_comment(
    contractid INTEGER,
    comment_text TEXT
) RETURNS VOID AS $$
BEGIN
    INSERT INTO contract_comment (contractid, comment_text)
    VALUES (contractid, comment_text);
END;
$$ LANGUAGE plpgsql;

--------------------------------------------------------------------------------

-- Процедура для обновления комментария
CREATE OR REPLACE FUNCTION contract_comment_pkg.update_comment(
    p_commid INTEGER,
    p_comment_text TEXT
) RETURNS VOID AS $$
BEGIN
    UPDATE contract_comment
    SET comment_text = p_comment_text,
        comm_date_updated = CURRENT_TIMESTAMP,
        comm_user_updated = CURRENT_USER
    WHERE commid = p_commid;
END;
$$ LANGUAGE plpgsql;

--------------------------------------------------------------------------------

-- Процедура для удаления комментария
CREATE OR REPLACE FUNCTION contract_comment_pkg.delete_comment(
    p_commid INTEGER
) RETURNS VOID AS $$
BEGIN
    DELETE FROM contract_comment
    WHERE commid = p_commid;
END;
$$ LANGUAGE plpgsql;

--------------------------------------------------------------------------------

-- Функция для подсчета договоров с 2 и более комментариями за текущую неделю
CREATE OR REPLACE FUNCTION contract_comment_pkg.count_contracts_with_multiple_comments()
RETURNS INTEGER AS $$
DECLARE
    v_count INTEGER := 0;
BEGIN
    SELECT COUNT(*)
    INTO v_count
    FROM (
        SELECT 
            c.contractid
        FROM contract_comment cc
        JOIN contracts c 
            ON cc.contractid = c.contractid
        WHERE cc.comm_date_created >= date_trunc('week', CURRENT_DATE)
        GROUP BY c.contractid
        HAVING COUNT(cc.commid) >= 2
    ) AS subquery;

    RETURN v_count;
END;
$$ LANGUAGE plpgsql;

--------------------------------------------------------------------------------

-- Альтернативная версия функции с входными датами
CREATE OR REPLACE FUNCTION contract_comment_pkg.count_contracts_with_multiple_comments_dates(
    p_start_date DATE,
    p_end_date DATE
) RETURNS INTEGER AS $$
DECLARE
    v_count INTEGER := 0;
BEGIN
    SELECT COUNT(*)
    INTO v_count
    FROM (
        SELECT 
            c.contractid
        FROM contract_comment cc
        JOIN contracts c 
            ON cc.contractid = c.contractid
        WHERE cc.comm_date_created BETWEEN p_start_date AND p_end_date
        GROUP BY c.contractid
        HAVING COUNT(cc.commid) >= 2
    ) AS subquery;

    RETURN v_count;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN 0; 
END;
$$ LANGUAGE plpgsql;


-----------------------------------------
-- Тест функции count_contracts_with_multiple_comments
DO $$
DECLARE
    v_count INTEGER;
BEGIN
    v_count := contract_comment_pkg.count_contracts_with_multiple_comments();
    RAISE NOTICE 'Количество договоров с несколькими комментариями: %', v_count;
END;
$$;

