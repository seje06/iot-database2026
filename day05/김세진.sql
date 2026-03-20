-- 1. 각 고객의 custid와 총 구매금액을 조회하시오.
SELECT o.custid
	 , SUM(o.saleprice) AS "총 구매금액"
  FROM Orders o
 GROUP BY o.custid
 ORDER BY "총 구매금액" DESC;

SELECT c.custid
     , IFNULL(SUM(o.sailprice),0) AS "총 구매금액"
  FROM Customer c
  LEFT OUTER JOIN Orders o
	ON c.custid = o.custid
 GROUP BY c.custid
 ORDER BY "총 구매금액" DESC;
 
 
-- 2.  주문한 고객의 이름, 책 번호, 판매가격, 주문일자를 조회하시오.
SELECT c.name
	 , o.bookid
     , o.saleprice
     , orderdate
  FROM Customer c
 INNER JOIN Orders o
    ON c.custid = o.custid;
    
-- 3.  전체 주문의 평균 판매가보다 높은 판매가격의 주문을 조회하시오.
-- 주문번호, 고객번호, 책번호, 판매가격을 출력하시오.
SELECT o.orderid
	 , o.custid
     , o.bookid
     , o.saleprice
  FROM Orders o
 WHERE o.saleprice > (SELECT AVG(saleprice) FROM Orders);
 
 -- 4.  고객별 총 구매금액이 50,000원 이상인 고객의 이름과 총 구매금액을 조회하시오.
SELECT c.name
	 , SUM(o.saleprice) AS "총 구매금액"
  FROM Customer c
 INNER JOIN Orders o
	ON c.custid = o.custid
 GROUP BY c.custid, c.name
HAVING "총 구매금액" >= 50000;
 