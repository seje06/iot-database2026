-- 서브쿼리 종류

-- WHERE절 서브쿼리

-- 서브쿼리를 사용해서 출판사이름이 '미디어'로 끝나는 출판사에서
-- 출판할 책을 조회하시오
SELECT b.bookname
  FROM Book b
 WHERE b.publisher IN (SELECT DISTINCT b.publisher 
  FROM Book b
 WHERE b.publisher LIKE '%미디어');

-- 도서를 구매한 적이 있는 고객의 이름을 조회하시오
SELECT  c.name
  FROM Customer c
 WHERE c.custid  IN (SELECT DISTINCT  o.custid 
  FROM Orders o);
  
-- 대한미디어에서 출판한 도서를 구매한 고객의 정보를 보이시오
-- 고객테이블 컬럼만 사용가능
SELECT *
  FROM Customer c
 WHERE c.custid IN (SELECT o.custid 
  FROM Orders o
 WHERE o.bookid  IN (SELECT b.bookid
  FROM Book b
 WHERE b.publisher = '대한미디어'));

SELECT o.custid 
  FROM Orders o
 WHERE o.bookid  IN (SELECT b.bookid
  FROM Book b
 WHERE b.publisher = '대한미디어');

SELECT b.bookid
  FROM Book b
 WHERE b.publisher = '대한미디어';

SELECT DISTINCT  o.custid 
  FROM Orders o;

-- 조인으로 변경가능, 모든 테이블의 컬럼 사용가능
SELECT *
  FROM Customer c, Orders o, Book b
  WHERE c.custid = o.custid
    AND b.bookid = o.bookid
    AND b.publisher = '대한미디어';
 
-- 도서 전체 평균값 보다 저렴한 책들을 조회하시오
SELECT *
  FROM Book b
 WHERE b.price < (SELECT avg(b.price )
  FROM Book b);

SELECT avg(b.price )
  FROM Book b;

-- 출판사별 가장 비싼 도서를 조회하시오
-- 서브쿼리로 두컬럼을 비교가능
SELECT *
  FROM Book b
 WHERE (b.publisher, b.price) IN(SELECT b.publisher, MAX(b.price)
								   FROM Book b
							      GROUP BY b.publisher);

SELECT *
  FROM Book b
 WHERE b.price IN(SELECT MAX(b.price)
					FROM Book b
				   GROUP BY b.publisher);
-- ANY = OR
-- ANY, SOME 결과 중 메인쿼리 조건이 하나라도 참이면 출력
-- 출판사별 가장 비싼 책과 가격이 일치하는 책 정보를 조회하라
SELECT *
  FROM Book b
 WHERE b.price = ANY (SELECT MAX(b.price)
						FROM Book b
					   GROUP BY b.publisher);
-- 출판사별 가장비싼 책과 가격이 하나라도 더 비싼 책정보를 조회하라
SELECT *
  FROM Book b
 WHERE b.price > ANY (SELECT MAX(b.price)
						FROM Book b
					   GROUP BY b.publisher);
-- ALL = AND
-- 출판사별 가장비싼 책들과 가격이 모두 조건에 일치하는 책 정보룰 조회하라
SELECT *
  FROM Book b
 WHERE b.price < ALL (SELECT MAX(b.price)
						FROM Book b
					   GROUP BY b.publisher);
-- EXISTS
-- 서브쿼리 결과가 아무것도 없으면 메인쿼리는 조회안됨
-- 서브쿼리 결과가 뭐라도 있으면 메인쿼리 조회가능
SELECT *
  FROM Book b
 WHERE EXISTS (SELECT MAX(b.price)
				 FROM Book b
				GROUP BY b.publisher
			   HAVING max(price) > 40000);

-- 상관서브쿼리(Correlated subquery).
-- 메인쿼리의 컬럼이 서브쿼리의 조건에 포함될 때
-- 서브쿼리만 따로 실행 불가능
-- 출판사별 출판사 평균 도서가격보다 비싼 도서를 조회하세요

(SELECT avg(b2.price) 
   FROM Book b2
  GROUP BY b2.publisher)

-- 상관서브쿼리는 안쪽 서브쿼리만 따로 실행불가. 코드 이해가 쉽지 않음
-- 많이 안쓰는 걸 권장
SELECT *
  FROM Book b1
 WHERE b1.price > (SELECT avg(b2.price) 
  					 FROM Book b2
 					WHERE b2.publisher = b1.publisher );

/* FROM절 서브쿼리 */

-- 서브쿼리로 만들어진 가상테이블을 진짜 테이블처럼 FROM절에 사용하는것
-- 구매 고객별 합계 중에서 총 금액이 5만 이상인 구매정보를 조회하세요
SELECT *
  FROM (SELECT custid, sum(saleprice) AS 'totalPrice'
   		  FROM Orders
 		 GROUP BY custid) t
  WHERE t.totalPrice >= 32000
  ORDER BY t.totalPrice DESC;

-- FROM절 서브쿼리는 일반 테이블과 조인 가능
SELECT c.*, t.totalPrice
  FROM (SELECT custid, sum(saleprice) AS "totalPrice"
   		  FROM Orders
 		 GROUP BY custid) t
 INNER JOIN Customer c
  	ON t.custid = c.custid 
 WHERE t.totalPrice >= 32000
 ORDER BY t.totalPrice DESC;

-- 구매를 2번 이상한 고객만 조회하시오
SELECT c.*, t.Order_cnt
  FROM (SELECT custid, count(*) AS "Order_cnt"
  		  FROM Orders
 		 GROUP BY custid) t
 INNER JOIN Customer c
    ON c.custid = t.custid
 WHERE t.Order_cnt >= 3;


/* SELECT절 서브쿼리 */
-- 조인을 사용하지 않고 주문번호 5이하인 주문건들의 고객명과 책이름을 같이 조회하시오.
-- 조인으로 했을때 쿼리. 특징 : 속도가 빠름
SELECT o.orderid
	 , o.custid
	 , o.bookid
	 , o.saleprice
	 , o.orderdate
	 , c.name
	 , b.bookname 
  FROM Orders o, Customer c, Book b
 WHERE o.custid = c.custid
   AND o.bookid = b.bookid
   AND o.orderid <= 5 ;

-- SELECT 서브쿼리는 한행 한컬럼만 리턴되어야 함!. 특징 : 조인보다 성능 안좋음
SELECT o.orderid
	 , o.custid
	 , (SELECT name FROM Customer WHERE custid = o.custid) "고객명"
	 , (SELECT bookname FROM Book WHERE bookid = o.bookid) "도서명"
	 , o.bookid
	 , o.saleprice
	 , o.orderdate
  FROM Orders o
 WHERE o.orderid <= 5;
