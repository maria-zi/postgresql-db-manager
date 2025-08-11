-- Создание таблицы CONTRACT_COMMENT
CREATE TABLE contract_comment (
    commid SERIAL PRIMARY KEY,  -- Используем SERIAL для автоинкремента
    contractid INTEGER NOT NULL,  
    comment_text VARCHAR(4000),  -- Можно использовать VARCHAR или TEXT для хранения комментариев
    comm_date_created TIMESTAMP DEFAULT CURRENT_TIMESTAMP,  
    comm_user_created VARCHAR(50),
    comm_date_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP,  
    comm_user_updated VARCHAR(50),  
    CONSTRAINT fk_contract FOREIGN KEY (contractid) REFERENCES contracts(contractid)  -- Внешний ключ на таблицу contracts
);

------------------------------------------------------------------------

-- Триггер для установки значений перед добавлением или обновлением
CREATE OR REPLACE FUNCTION trg_set_contract_comment()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        NEW.comm_date_created := CURRENT_TIMESTAMP; 
        NEW.comm_user_created := SESSION_USER;  
    END IF;

    NEW.comm_date_updated := CURRENT_TIMESTAMP;  
    NEW.comm_user_updated := SESSION_USER;  
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_set_contract_comment
BEFORE INSERT OR UPDATE ON contract_comment  
FOR EACH ROW EXECUTE FUNCTION trg_set_contract_comment();

------------------------------------------------------------------------

-- Примеры вставки данных для проверки работы
INSERT INTO contract_comment (contractid, comment_text)
VALUES (
    (SELECT contractid FROM contracts WHERE phone_number = '88008888888'),
    'Договор был заключен с физ. лицом'
);

INSERT INTO contract_comment (contractid, comment_text)
VALUES (
    (SELECT contractid FROM contracts WHERE phone_number = '88008888888'),
    'Клиент просил продублировать оригинал договора'
);

INSERT INTO contract_comment (contractid, comment_text)
VALUES (2, 'У клиента вопрос по оформлению льгот, отправлен на рассмотрение в юр.отдел');

-- Проверка вставленных данных
SELECT * FROM contract_comment;
