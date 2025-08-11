--Отображает комментарии на номерах телефонов
CREATE OR REPLACE VIEW view_comments_info AS
SELECT 
  c.phone_number,
  c.contract_date,
  cc.comment_text  
FROM CONTRACTS c
JOIN CONTRACT_COMMENT cc 
  ON c.contractid = cc.contractid; 


-----------------------------------------------------------------------------------------------

--Информация о комментариях к созданным на этой неделе договорам
CREATE OR REPLACE VIEW view_comments_this_week AS
SELECT 
  c.phone_number,
  c.contract_date,
  cc.comment_text
FROM CONTRACTS c
JOIN CONTRACT_COMMENT cc 
  ON c.contractid = cc.contractid
WHERE 
  c.date_created >= TRUNC(SYSDATE, 'IW'); 


-----------------------------------------------------------------------------------------------

--Кол-во комментариев по каждому договору
CREATE OR REPLACE VIEW view_comments_count AS
SELECT 
  c.contractid,
  COUNT(cc.comment_text) AS comment_count
FROM CONTRACTS c
LEFT JOIN CONTRACT_COMMENT cc 
  ON c.contractid = cc.contractid
GROUP BY c.contractid;


-----------------------------------------------------------------------------------------------

--Договоры создали пользователи с фамилией оканчивающейся на ков
CREATE OR REPLACE VIEW view_comments_by_user AS
SELECT 
  c.phone_number,
  c.contract_date,
  cc.comment_text
FROM CONTRACTS c
JOIN CONTRACT_COMMENT cc 
  ON c.contractid = cc.contractid
WHERE c.user_created LIKE '%ков';   
-- Нужно смотреть на формат пользователя т. к. такой паттерн подойдет например для формата ИВВилков/Вилков и т д.

-- Можно использовать REGEXP_LIKE(c.user_created, 'ков[А-Я]{2}$') для пользователей с таким форматом как ВилковИИ/ПроскуряковЛВ 
-- т. к. паттерн отберёт всех пользователей у кого фамилии заканчиваются на ков и после этого сразу идут заглавные инициалы,
-- но будем считать что в нашем случае всех пользователей добавили просто с форматом 'Фамилия'=)


/*
SELECT * FROM view_comments_info;
SELECT * FROM view_comments_this_week;
SELECT * FROM view_comments_count;
SELECT * FROM view_comments_by_user;
*/
