CREATE SEQUENCE contract_comment_id_seq
MINVALUE 1
--MAXVALUE --оно тут по умолчанию максимальное но можно прописать предел
START WITH 1          
INCREMENT BY 1     
NOCACHE             
NOCYCLE;


------------------------------------------------------------------------

CREATE TABLE CONTRACT_COMMENT (
    commid NUMBER PRIMARY KEY,  
    contractid NUMBER NOT NULL,  
    comment_text VARCHAR2(4000),  --либо CLOB если вдруг будем писать комментарии больше 4000 символов но при добавлении или апдейте комментария надо использовать TO_CLOB()
    comm_date_created TIMESTAMP DEFAULT CURRENT_TIMESTAMP,  
    comm_user_created VARCHAR2(50),
    comm_date_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP,  
    comm_user_updated VARCHAR2(50),  
    CONSTRAINT fk_contract FOREIGN KEY (contractid) REFERENCES CONTRACTS(contractid)  -- Внешний ключ на таблицу CONTRACTS
);

с
--Перед каждым добавлением значений будет генерироваться id из уникальной последовательности, дата на момент добавления и юзер
--Информация о последнем изменении будет вноситься и при добавлении и при изменении
CREATE OR REPLACE TRIGGER trg_set_contract_comment
BEFORE INSERT OR UPDATE ON CONTRACT_COMMENT  
FOR EACH ROW 
BEGIN
    
    IF INSERTING THEN
        :NEW.commid := contract_comment_id_seq.NEXTVAL;  
        :NEW.comm_date_created := CURRENT_TIMESTAMP; 
        :NEW.comm_user_created := USER;  
    END IF;

    
    :NEW.comm_date_updated := CURRENT_TIMESTAMP;  
    :NEW.comm_user_updated := USER;  
END;
/

------------------------------------------------------------------------

/*INSERT INTO CONTRACT_COMMENT (contractid, comment_text)
VALUES (
    (SELECT contractid FROM CONTRACTS WHERE phone_number = '88008888888'),
    'Договор был заключен с физ. лицом'
);

INSERT INTO CONTRACT_COMMENT (contractid, comment_text)
VALUES (
    (SELECT contractid FROM CONTRACTS WHERE phone_number = '88008888888'),
    'Клиент просил продублировать оригинал договора'
);

INSERT INTO CONTRACT_COMMENT (contractid, comment_text)
VALUES (2, 'У клиента вопрос по оформлению льгот, отправлен на рассмотрение в юр.отдел');


SELECT * FROM CONTRACT_COMMENT;
*/
