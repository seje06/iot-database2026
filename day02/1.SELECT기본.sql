-- 서점에 어떤 도서가 있는지 알고 싶다
-- 모든 도서의 이름과 가격을 조회하시오
SELECT bookname
	    ,price 
  FROM Book;

-- 모든 도서의 가격과 이름을 조회하시오
SELECT price
	  ,bookname
  FROM Book;

-- 모든 도서의 도서번호, 도서명, 출판사, 가격 조회하시오.
SELECT *
  FROM Book;

SELECT bookid
	 , bookname
	 , publisher
	 , price
  FROM Book;

-- 도서 테이블의 중복을 제거한 출판사를 조회하세요
SELECT DISTINCT publisher
  FROM Book;

SELECT ALL publisher
  FROM Book;

-- WHERE절
-- 가격이 10000이상 20000이하인 도서 조회하세요
SELECT *
  FROM Book
 WHERE price BETWEEN 10000 AND 20000;

-- between은 and로 변경 가능
SELECT *
  FROM Book
 WHERE price >= 10000
   AND price <= 20000;

-- 출판사가 굿스포츠, 대한미디어인 도서를 조회하시오
SELECT *
  FROM Book
 WHERE publisher IN ('굿스포츠', '대한미디어');

-- OR와 동일, 단, 값이 너무 많으면 IN절이 훨씬 효울적
SELECT *
  FROM Book
 WHERE publisher = '굿스포츠'
 	OR publisher = '대한미디어';

SELECT *
  FROM Book
 WHERE publisher NOT IN ('굿스포츠', '대한미디어');

-- LIKE 패턴 필터링
-- 축구의 역사 출간한 출판사를 조회하시오
SELECT bookname
	 , publisher
  FROM Book
 WHERE bookname = '축구의 역사';

SELECT bookname
	 , publisher
  FROM Book
 WHERE bookname LIKE '축구의 역사';

-- 책 제목에 축구로 시작하는 출판사를 조회하시오
SELECT bookname
	 , publisher
  FROM Book
 WHERE bookname LIKE '축구%';

-- 책 제목에 축구가 포함된 출판사를 조회하시오
SELECT bookname
	 , publisher
  FROM Book
 WHERE bookname LIKE '%축구%';

-- 책 제목에 축구로 끝나는 출판사를 조회하시오
SELECT bookname
	 , publisher
  FROM Book
 WHERE bookname LIKE '%축구';

-- 책 제목에 축구로 시작하고 총 제목 길이가 8자리인 
-- 책을 출판하는 출판사를조회하시오
SELECT bookname
	 , publisher
  FROM Book
 WHERE bookname LIKE '축구______';

SELECT *
  FROM Book
 WHERE bookname LIKE '_구%';

-- 축구에 관한 도서중 가격이 20000원 이상인 도서 조회하시오
SELECT *
  FROM Book
 WHERE bookname LIKE '%축구%'
   AND price >= 20000;

-- ORDER BY 오름차순, 내림차순 정렬
-- 도서를 이름순으로 조회하시오
SELECT *
  FROM Book
  ORDER BY bookname;

-- 도서를 가격순으로 조회하고, 가격이 같으면 이름순으로 조회하시오
SELECT *
  FROM Book
  ORDER BY price ASC, bookname ASC;

-- 집계함수 SUM
-- 2번 김연아 고객이 주문한 도서의 총 판매액을 조회하시오
SELECT *
  FROM Customer
 WHERE name = '김연아';

-- 2번 김연아 고객이 주문한 도서의 총 판매액을 조회하시오
SELECT sum(saleprice) AS "총 매출"
  FROM Orders
 WHERE custid = 2;

-- Alias
SELECT b.bookid AS "책순번"
	 , b.bookname AS "책제목"
	 , b.price AS "정가"
  FROM Book AS b;

-- 고객이 주문한 도서의 총 판매액, 평균, 최저, 최고가 조회하시오
SELECT sum(saleprice) "Total"
	 , avg(saleprice) "Average"
	 , min(saleprice) "Minimum"
	 , max(saleprice) "Maximum"
	 FROM Orders o;

-- 마당서점의 총 도서 판매수를 조회하시오
SELECT count(*) "총 판매수"
	 , count(o.orderid) "총 판매수" -- 아래와 개수 차이가 날 수 있음
  FROM Orders o;

-- GROUP BY 어느 고객이 얼마나 주문했는지 알고 싶음
-- 고객별로 주문한 도서의 총 수량과 총 판매액을 조회하시오
SELECT o.custid
	 , count(*) "판매 수량"
	 , sum(o.saleprice) "총 판매액"
  FROM Orders o
 GROUP BY o.custid;

-- 가격이 8000원 이상인 도서를 구매한 고객에 대하여 고객별 주문도서, 총 수량
-- 조회하시오. 단 두 권 이상 구매한 고객만 조회
SELECT o.custid
	 , count(*) "도서수량"
  FROM Orders o
 WHERE o.saleprice >= 8000
 GROUP BY o.custid 
HAVING count(*) >= 2
 ORDER BY o.custid DESC;

-- 도서번호가 1인 도서의 이름
