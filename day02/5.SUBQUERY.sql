-- 책중에 가장 비싼 도서의 이름을 조회하시오.
SELECT max(b.price), b.bookname
  FROM Book b
 GROUP BY b.bookname;

SELECT b.bookname
  FROM Book b
 WHERE b.price  = (SELECT max(b.price)
  FROM Book b);