CREATE SEQUENCE contracts_id_seq --генератор последовательности
MINVALUE 1
--MAXVALUE --оно тут по умолчанию максимальное но можно прописать предел
START WITH 1          
INCREMENT BY 1     
NOCACHE             
NOCYCLE;         

-----------------------------------------------------------------

CREATE TABLE CONTRACTS (
    contractid NUMBER PRIMARY KEY,  
    contract_date DATE NOT NULL,  
    phone_number VARCHAR2(15),  
    date_created TIMESTAMP DEFAULT CURRENT_TIMESTAMP,  
    user_created VARCHAR2(50),  
    date_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP, 
    user_updated VARCHAR2(50)  
);

-- можно указать ограничение CONSTRAINT для формата номера телефона
--CONSTRAINT check_ph_num CHECK (REGEXP_LIKE(phone_number, '^[0-9]{3,15}$')) длина номера тут от 3 до 15 символов

------------------------------------------------------------------

--Перед каждым добавлением значений будет генерироваться id из уникальной последовательности, дата на момент добавления и юзер
--Информация о последнем изменении будет вноситься и при добавлении и при изменении
CREATE OR REPLACE TRIGGER trg_set_contracts
BEFORE INSERT OR UPDATE ON CONTRACTS  
FOR EACH ROW
BEGIN
    
    IF INSERTING THEN
        :NEW.contractid := contracts_id_seq.NEXTVAL;  
        :NEW.date_created := CURRENT_TIMESTAMP; 
        :NEW.user_created := USER;  
    END IF;

    
    :NEW.date_updated := CURRENT_TIMESTAMP;  
    :NEW.user_updated := USER;  
END;
/

/* вставка данных для проверки работы

INSERT INTO CONTRACTS (contract_date, phone_number)
VALUES (TO_DATE('2025-08-01', 'YYYY-MM-DD'), '88008888888');


INSERT INTO CONTRACTS (contract_date, phone_number)
VALUES (TO_DATE('2025-08-02', 'YYYY-MM-DD'), '89279279279');


INSERT INTO CONTRACTS (contract_date, phone_number)
VALUES (TO_DATE('2025-08-03', 'YYYY-MM-DD'), '5555555555');


INSERT INTO CONTRACTS (contract_date)
VALUES (TO_DATE('2025-08-04', 'YYYY-MM-DD'));

--select * from CONTRACTS
*/
