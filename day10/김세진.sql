-- 1.   현재 대여 중인 도서를 조회하시오.
SELECT m.member_name
	 , b.book_name
	 , r.rentalDate 
  FROM books b
 INNER JOIN rentals r
    ON b.book_idx = r.book_idx
 INNER JOIN members m
    ON r.member_idx = m.member_idx
 WHERE r.returnDate IS NULL
 ORDER BY r.rentalDate ASC;

-- 2.  회원별 대여 횟수를 집계하시오.
SELECT m.member_idx
	 , m.member_name
	 , count(*) "대여횟수"
  FROM members m
 INNER JOIN rentals r
    ON r.member_idx = m.member_idx 
 GROUP BY m.member_idx
 ORDER BY 대여횟수 DESC, m.member_name ASC;

-- 3.  장르별 도서수를 조회하시오.
SELECT d.div_code
	 , d.div_name
	 , count(*) "도서수" 
  FROM division d
 INNER JOIN books b
    ON d.div_code = b.div_code
 GROUP BY d.div_code
 ORDER BY 도서수 DESC;
 
-- 4.  한번도 대여되지 않은 도서를 조회하시오
SELECT b.book_name 
  FROM books b
  LEFT OUTER JOIN rentals r
    ON b.book_idx = r.book_idx
 WHERE r.rental_idx IS NULL;

-- 5. 평균 대여수보다 많이 대여한 회원을 조회하시오
SELECT m.member_idx
	 , m.member_name
	 , count(*) "대여횟수"
  FROM members m
 INNER JOIN rentals r
    ON m.member_idx  = r.member_idx
 GROUP BY m.member_idx
having 대여횟수 > (SELECT avg(s.`대여횟수`) AS "평균"
  					 FROM (SELECT r.member_idx
  			 				 	, count(*) "대여횟수"
  		  					 FROM rentals r
 		 					GROUP BY r.member_idx) s);


SELECT r1.member_idx AS "회원번호"
     , (SELECT member_name FROM members WHERE member_idx = r1.member_idx ) AS "회원명"
    , COUNT(*) AS "대여횟수"
  FROM rentals r1
 GROUP BY member_idx
 HAVING 대여횟수 > (SELECT AVG(r2.count_num)
                 FROM (SELECT member_idx, COUNT(*) AS "count_num"
                         FROM rentals
                       GROUP BY member_idx) r2);
