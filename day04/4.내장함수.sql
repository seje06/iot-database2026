/* 내장함수 */

-- 1. 수학함수

-- 절대값
SELECT abs(-78), abs(+78)
  FROM DUAL;  -- 테이블을 사용하지 않을때 사용하는 키워드
  
-- 반올림
-- 두번째 인자 양수 소수점, 음수 정수부분
SELECT round(3.141592, 3);

-- 고객별 평균 주문금액을 백원단위로 반올림하시오
SELECT o.custid "고객번호"
     , round(avg(o.saleprice), -2) AS "평균금액"
  FROM Orders o
 GROUP BY o.custid;

SELECT ceil(3.14), floor(3.67), power(2,64), log(10);

-- 나머지
SELECT mod(10,3);

-- 2. 문자함수
-- 결합함수 파라미터 갯수 제한이 없음!
SELECT concat('성','ㅇ' ,'유고', '만쉐이!');

-- 소문자, 대문자
SELECT lower("Hello");
SELECT lower("Hello"), upper("hello");

-- 자리수 채우기
SELECT LPAD('hello', 10, '*');
SELECT RPAD('hello', 10, '@'); -- 주민번호, 생년월일-성별이후 여섯자리*

-- 문자열 대체
SELECT replace('Hello World', 'Hello', 'Bye');

-- 문자열 자르기
SELECT substr('hello World', 7, 5);

-- 문자열 앞뒤 공백 없애기(중간 공백 제외)
SELECT concat('|',trim('          Hello World          '),'|') "TRIM",
		concat('|',ltrim('          Hello World          '),'|') "LTRIM",
		concat('|',rtrim('          Hello World          '),'|') "RTRIM";

-- 구분자로 지정하여 문자열합치기
SELECT concat_ws('-','2026','03','18'),
	   concat_ws(' ','hello','world');

-- 알파벳을 아스키코드 변환
SELECT ascii('A');

-- 문자열 길이리턴
-- 한글 1글자 UTF-8에서 3byte, 글자길이와 저장되는 바이트길이는 다름
SELECT length('문자열길이'),
	   char_length('안녕하세요');

-- 3. 날짜시간함수

-- 날짜문자열을 날짜형식으로 변환
SELECT str_to_date('2026-03-18', '%Y-%m-%d');
-- 날짜문자열을 날짜포맷에 맞춰서 변환
SELECT date_format('2026-03-18', '%Y-%m-%d'),
	   date_format('2026-03-18', '%m-%d-%y'),
	   date_format(NOW(), '%m.%d.%y');

-- 날짜 더하기/빼기
SELECT adddate(NOW(), INTERVAL -10 DAY),
	   date(now()), time(NOW());

-- 날짜 간 날짜 차이 수
SELECT datediff('2026-03-19', '2026-03-08');

-- 현재 일시
SELECT sysdate(), now();

-- 날짜함수 포맷
/*
 * %Y : 네자리 년도 2026
 * %y : 두자리 년도 26
 * %m : 월
 * %M : 월이름 (Janumary ~ December)
 * %b : 월이름 (Jan ~ Dec)
 * %d : 일
 * %W : 요일(Wednesday)
 * %w : 요일숫자(0 일요일 ~ 6 토요일)
 * %a : 요일약자(Sun, Mon, Wed)
 * %h : 12시간 hour
 * %H : 24시간 hour
 * %i : 분
 * %s : 초
 */

SELECT date_format(now(), '%Y-%M-%d %w'),
	   date_format(now(),'%H:%i:%s');
