-- Создание пользователя some_cool_user
CREATE USER some_cool_user WITH PASSWORD 'cool_secure_password';

-- Раздача прав на таблицы
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE contracts TO some_cool_user;

GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE contract_comment TO some_cool_user;

-- Раздача прав на представления
GRANT SELECT ON view_comments_info TO some_cool_user;

GRANT SELECT ON view_comments_this_week TO some_cool_user;

GRANT SELECT ON view_comments_count TO some_cool_user;

GRANT SELECT ON view_comments_by_user TO some_cool_user;

-- Раздача прав на функции в пакете contract_comment_pkg
GRANT EXECUTE ON FUNCTION contract_comment_pkg.add_comment(INTEGER, TEXT) TO some_cool_user;

GRANT EXECUTE ON FUNCTION contract_comment_pkg.update_comment(INTEGER, TEXT) TO some_cool_user;

GRANT EXECUTE ON FUNCTION contract_comment_pkg.delete_comment(INTEGER) TO some_cool_user;

GRANT EXECUTE ON FUNCTION contract_comment_pkg.count_contracts_with_multiple_comments() TO some_cool_user;

GRANT EXECUTE ON FUNCTION contract_comment_pkg.count_contracts_with_multiple_comments_dates(DATE, DATE) TO some_cool_user;

--ЛИБО

-- Установка прав на схему 
GRANT USAGE ON SCHEMA contract_comment_pkg TO some_cool_user;
