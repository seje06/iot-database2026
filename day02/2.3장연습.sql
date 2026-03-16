-- 도서번호가 1인 도서의 이름
SELECT bookname
  FROM Book
 WHERE bookid = 1;

-- 가격이 20000원 이상인 도서의 이름
SELECT bookname
  FROM Book
 WHERE price >= 20000;

-- 박지성의 총 구매액(박지성의 고객번호는 1번으로 놓고 작성)
SELECT o.custid , sum(o.saleprice) "총 구매액" 
  FROM Orders o
 WHERE o.custid =1;

-- 박지성이 구매한 도서의 수(박지성의 고객번호는 1번으로 놓고 작성)
SELECT o.custid, count(*) "총 구매수"
  FROM Orders o
 WHERE o.custid =1;


-- 마당서점 도서의 총 개수
SELECT count(*)
  FROM Book;

-- 마당서점에 도서를 출고하는 출판사의 총 개수
SELECT count(DISTINCT b.publisher )
  FROM Book b;

-- 모든 고객의 이름, 주소
SELECT c.name, c.address 
  FROM Customer c;

-- 2014년 7월 4일 ~ 7월7일 사이에 주문 받은 도서의 주문번호
-- Date형은 문자열이 아니지만날짜를 검색할때 문자열로 비교검색 가능
SELECT o.orderid 
  FROM Orders o
 WHERE o.orderdate >= '2024-07-04'
   AND o.orderdate <= '2024-07-07';

-- between 방식
SELECT o.orderid 
  FROM Orders o
 WHERE o.orderdate between '2024-07-04'
   AND '2024-07-07';

-- 제외한 도서의 주문번호
SELECT o.orderid 
  FROM Orders o
 WHERE o.orderdate NOT between '2024-07-04'
   AND '2024-07-07';

--고객 이름이 김으로 시작하는 고객의 이름과 주소
SELECT c.name, c.address 
  FROM Customer c
 WHERE c.name LIKE "김%";

--고객 이름이 김으로 시작하는 고객의 이름과 주소
SELECT c.name, c.address 
  FROM Customer c
 WHERE c.name LIKE "김_아";
