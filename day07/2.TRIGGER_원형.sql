-- 트리거 원본
-- 아래꺼 루트에서 실행해줘야함
-- SET GLOBAL log_bin_trust_function_creators = 1;

delimiter $$

CREATE TRIGGER trg_AfterInsertBook
 AFTER INSERT ON Book FOR EACH ROW
BEGIN
	INSERT INTO Book_log(bookid_l, bookname_l, publisher_l, price_l, dml_type)
	-- new.컬럼명 새로 들어온 데이터(INSERT), old.컬럼명 이전값(UPDATE, DELETE)
	VALUES (NEW.bookid, NEW.bookname, NEW.publisher, NEW.price, 'INSERT');
END;
$$
delimiter $$;
-- Alt+X로 전체 실행