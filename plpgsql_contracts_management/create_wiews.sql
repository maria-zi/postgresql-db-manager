-- Отображает комментарии на номерах телефонов
CREATE OR REPLACE VIEW view_comments_info AS
SELECT 
  c.phone_number,
  c.contract_date,
  cc.comment_text  
FROM contracts c
JOIN contract_comment cc 
  ON c.contractid = cc.contractid; 

-----------------------------------------------------------------------------------------------

-- Информация о комментариях к созданным на этой неделе договорам
CREATE OR REPLACE VIEW view_comments_this_week AS
SELECT 
  c.phone_number,
  c.contract_date,
  cc.comment_text
FROM contracts c
JOIN contract_comment cc 
  ON c.contractid = cc.contractid
WHERE 
  c.date_created >= date_trunc('week', CURRENT_DATE); 

-----------------------------------------------------------------------------------------------

-- Кол-во комментариев по каждому договору
CREATE OR REPLACE VIEW view_comments_count AS
SELECT 
  c.contractid,
  COUNT(cc.comment_text) AS comment_count
FROM contracts c
LEFT JOIN contract_comment cc 
  ON c.contractid = cc.contractid
GROUP BY c.contractid;

-----------------------------------------------------------------------------------------------

-- Договоры создали пользователи с фамилией, оканчивающейся на "ков"
CREATE OR REPLACE VIEW view_comments_by_user AS
SELECT 
  c.phone_number,
  c.contract_date,
  cc.comment_text
FROM contracts c
JOIN contract_comment cc 
  ON c.contractid = cc.contractid
WHERE c.user_created LIKE '%ков';   

-- Можно использовать регулярное выражение для пользователей с таким форматом как ВилковИИ/ПроскуряковЛВ
-- Для этого можно использовать:
-- WHERE REGEXP_LIKE(c.user_created, 'ков[А-Я]{2}$');

-- Однако в данном случае мы предполагаем, что всех пользователей добавили с форматом 'Фамилия'.


SELECT * FROM view_comments_info;
SELECT * FROM view_comments_this_week;
SELECT * FROM view_comments_count;
SELECT * FROM view_comments_by_user;

