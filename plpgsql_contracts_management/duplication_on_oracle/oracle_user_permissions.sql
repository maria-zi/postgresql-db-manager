-- Создание пользователя some_cool_user
CREATE USER some_cool_user IDENTIFIED BY cool_secure_password;

-- Права на последовательности
GRANT SELECT, INSERT ON contracts_id_seq TO some_cool_user;

GRANT SELECT, INSERT ON contract_comment_id_seq TO some_cool_user;

-- Права на таблицы
GRANT SELECT, INSERT, UPDATE, DELETE ON CONTRACTS TO some_cool_user;

GRANT SELECT, INSERT, UPDATE, DELETE ON CONTRACT_COMMENT TO some_cool_user;

-- Права на представления
GRANT SELECT ON view_comments_info TO some_cool_user;

GRANT SELECT ON view_comments_this_week TO some_cool_user;

GRANT SELECT ON view_comments_count TO some_cool_user;

GRANT SELECT ON view_comments_by_user TO some_cool_user;

-- Права на пакет contract_comment_pkg
GRANT EXECUTE ON contract_comment_pkg TO some_cool_user;
