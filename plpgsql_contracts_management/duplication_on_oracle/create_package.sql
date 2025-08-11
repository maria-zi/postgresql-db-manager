CREATE OR REPLACE PACKAGE contract_comment_pkg AS
    
    PROCEDURE add_comment(contractid IN NUMBER, comment_text IN VARCHAR2);
    PROCEDURE update_comment(p_commid IN NUMBER, p_comment_text IN VARCHAR2);
    PROCEDURE delete_comment(p_commid IN NUMBER);
    FUNCTION count_contracts_with_multiple_comments RETURN NUMBER;
 -- Альтернативная версия с входными датами 
 -- FUNCTION count_contracts_with_multiple_comments(p_start_date IN DATE, p_end_date IN DATE) RETURN NUMBER;
END contract_comment_pkg;
/


--------------------------------------------------------------------------------


CREATE OR REPLACE PACKAGE BODY contract_comment_pkg AS

    
    PROCEDURE add_comment(contractid IN NUMBER, comment_text IN VARCHAR2) IS
    BEGIN
        INSERT INTO CONTRACT_COMMENT (contractid, comment_text)
        VALUES (contractid, comment_text);
    END add_comment;




    PROCEDURE update_comment(p_commid IN NUMBER, p_comment_text IN VARCHAR2) IS
    BEGIN
        UPDATE CONTRACT_COMMENT
        SET comment_text = p_comment_text,
            comm_date_updated = SYSDATE,
            comm_user_updated = USER
        WHERE commid = p_commid;
    END update_comment;




    PROCEDURE delete_comment(p_commid IN NUMBER) IS
    BEGIN
        DELETE FROM CONTRACT_COMMENT
        WHERE commid = p_commid;
    END delete_comment;



--кол-во договоров с 2 и более комментариями за текущий период

-----------------------------------------------------------------------------
--1. Если мы берем за "текущий период" из формулировки текущую неделю как в 1 задаче то:

    FUNCTION count_contracts_with_multiple_comments RETURN NUMBER IS
        v_count NUMBER := 0;
    BEGIN
        SELECT COUNT(*)
    INTO v_count
        
    FROM (
        SELECT 
          c.contractid
        FROM CONTRACT_COMMENT cc
        JOIN CONTRACTS c 
          ON cc.contractid = c.contractid
        WHERE cc.comm_date_created >= TRUNC(SYSDATE, 'IW')
        GROUP BY c.contractid
        HAVING COUNT(cc.commid) >= 2
    );

        RETURN v_count;
   
   --2.  Если "текущий период" это даты подающиеся на вход то:
        
    /* 
    FUNCTION count_contracts_with_multiple_comments(p_start_date IN DATE, p_end_date IN DATE) RETURN NUMBER IS
        v_count NUMBER := 0;
    BEGIN
        SELECT COUNT(*)
        INTO v_count
        
        FROM (
            SELECT 
              c.contractid
            FROM CONTRACT_COMMENT cc
            JOIN CONTRACTS c 
              ON cc.contractid = c.contractid
            WHERE cc.comm_date_created BETWEEN p_start_date AND p_end_date
            GROUP BY c.contractid
            HAVING COUNT(cc.commid) >= 2
        );

        RETURN v_count;
        
   -- можно еще прописать исключение например на случай если таких договоров не окажется в выбранном периоде   
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RETURN 0; 
        
    */
  
        
    END count_contracts_with_multiple_comments;

END contract_comment_pkg;
/


/*   Тест функции count_contracts_with_multiple_comments. В данном случае возвращает 1 договор с 2 комментариями.
DECLARE
    v_count NUMBER;
BEGIN
    v_count := contract_comment_pkg.count_contracts_with_multiple_comments;
    DBMS_OUTPUT.put_line('Количество договоров с несколькими комментариями: ' || v_count);
END;
/


*/
