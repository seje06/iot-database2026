-- ALTER 객체 수정

-- NewBook 테이블에 ISBN 컬럼을 추가하시오
ALTER TABLE NewBook
  ADD isbn char(13);

-- 데이터 추가
INSERT INTO NewBook VALUES
(1, '프로젝트 헤일메리', '알에이치', 22000, '9788925588735');

SELECT * FROM NewBook;

-- NewBook 테이블에 장르 컬럼을 추가하시오
-- 이전에 데이터에 empty가 추가
ALTER TABLE NewBook
  ADD genre varchar(10) NOT NULL;

SELECT * FROM NewBook;

ALTER TABLE NewBook
 DROP COLUMN genre;

-- NewBook에 isbn을 삭제하시오
ALTER TABLE NewBook
 DROP COLUMN isbn;

-- NewBook publisher에 NOT NULL 제약조건을 추가하시오
ALTER TABLE NewBook
MODIFY publisher varchar(40) NOT NULL;

-- 기본키 추가는 ALTER로 거의 하지않음
-- imported_book
ALTER TABLE NewBook
  ADD PRIMARY KEY(bookid);

-- DROP
DROP TABLE OldBook;

-- 관계형db에서는 관계를 맺고 있는 부모테이블 부터 삭제할 수 없음
-- 항상 자식테이블부터 삭제 후 부모테이블을 삭제할 수 있음
DROP TABLE NewOrder;
DROP TABLE NewBook;
DROP TABLE NewCustomer;