-- 서브쿼리
-- 하나의 SQL문 안에 다른 SQL문이 중첩
-- 하나의 질의 수행 후 반환 릴레이션에 대해 다른 질의 릴레이션으로 포함시킴
-- 다른 테이블에서 가져온 데이터로 현재 테이블에 있는 정보 찾거나 가공할 때 사용

-- 조인 VS 서브쿼리
-- 1. 조인 : 여러 데이터를 모두 합쳐서 연산
--          카티전 곱 연산 + SELECT 연산

-- 2. 서브쿼리 : 필요한 데이터만 찾아서 제공
--              경우에 따라 조인보다 성능이 더 좋을 수도 있지만 대용량 데이터에서 서브쿼리 수행 성능이 나쁠 수도 있음

-- 구성 : 메인쿼리 (서브쿼리) -> 서브쿼리 먼저 진행 후 메인쿼리 진행

-- 메시(client) 고객이 주문한 도서의 총 수량(bookSale) -> bookSale에는 clientNo만 있음
SELECT SUM(bsQTY)
FROM bookSale
WHERE clientNo = ( -- 서브쿼리
    SELECT clientNo
    FROM client
    WHERE clientName = '메시'
);

-- 서브쿼리 WHERE절에서 사용할 때 : 조건의 값으로 사용 (조건 연산자 필요)
-- 서브쿼리 질의 결과값이 단일행인 경우 : 단일행 서브쿼리 (비교 연산자 사용)
-- 서브쿼리 질의 결과값이 다중행인 경우 : 다중행 서브쿼리 (IN, ANY, ALL, EXISTS 연산자 사용)
-- IN, NOT IN (집합에 값이 있는지 / 없는지)
-- EXISTS, NOT EXISTS (존재의 의미)
-- ALL(모두), ANY(하나라도) : 한정

-- 고객 호날두의 주문수량 및 주문 날짜 조회
-- 1. client 테이블에서 '호날두'의 clientNo를 찾아서
-- 2. bookSale 테이블에서 1에서 찾은 clientNo에 해당되는 주문의 주문일/주문수량 조회
SELECT bsDate, bsQTY
FROM bookSale
WHERE clientNo = ( -- 단일행 반환
    SELECT clientNo
    FROM client
    WHERE clientName = '호날두'
);

-- 고객 호날두가 주문한 총 주문수량
SELECT SUM(bsQTY) AS "총 주문수량"
FROM bookSale
WHERE clientNo = ( -- 단일행 반환
    SELECT clientNo
    FROM client
    WHERE clientName = '호날두'
);

-- 가장 비싼 도서의 도서명과 가격 출력
SELECT bookName, bookPrice
FROM book
WHERE bookPrice = (
    SELECT MAX(bookPrice)
    FROM book
);

-- 서점 도서의 평균가격을 초과하는 도서의 이름과 도서 가격을 조회
SELECT bookName, bookPrice
FROM book
WHERE bookPrice > (
    SELECT AVG(bookPrice)
    FROM book
);

--------------------------------------------------------------------------------

-- 도서를 구매한적이 있는 고객의 고객명과 지역을 조회
-- 서브쿼리에서 다중행이 반환되는 예제
SELECT clientName, clientAddress
FROM client
WHERE clientNo IN (
    SELECT DISTINCT clientNo
    FROM bookSale
);

-- 도서를 한번도 구매한적이 없는 고객의 번호와 고객명 조회
SELECT clientNo, clientName
FROM client
WHERE clientNo NOT IN (
    SELECT DISTINCT clientNo
    FROM bookSale
);

--------------------------------------------------------------------------------

-- 중첩 서브쿼리
-- 도서명이 '안드로이드 프로그래밍'인 도서를 구매한 고객의 고객명 출력
-- 1. '안드로이드 프로그래밍' 도서의 도서번호 확인
SELECT bookNo FROM book WHERE bookName = '안드로이드 프로그래밍';
-- 2. bookNo 1004번의 도서가 주문된적이 있다면 주문한 고객의 번호를 조회
SELECT clientNo FROM bookSale WHERE bookNo = '1004';
-- 3. 고객번호가 7번 8번인 고객들의 고객명 조회
SELECT clientName FROM client WHERE clientNo = '7' OR clientNo = '8';

SELECT clientName
FROM client
WHERE clientNo IN (
    SELECT clientNo
    FROM bookSale
    WHERE bookNo = (
        SELECT bookNo
        FROM book
        WHERE bookName = '안드로이드 프로그래밍'
    )
)
ORDER BY clientName; -- 서브쿼리를 사용했더라도 서브쿼리의 결과는 조건값이므로
                     -- WHERE절 뒤에 모든 필요한 질의어 추가 가능
                     
--------------------------------------------------------------------------------

-- 다중행 서브쿼리 연산자 (EXISTS, NOT EXISTS)
-- EXISTS : 서브쿼리의 결과가 행을 반환하면 참이 되는 연산자
--          참조무결성에 대한 조건검사가 병행되어야함
--          상관서브쿼리 연산이 가능 : 서브쿼리에서 메인쿼리의 컬럼을 사용가능
-- 도서를 구매한적이 있는 고객
SELECT clientNo, clientName
FROM client
WHERE EXISTS (
    SELECT clientNo
    FROM bookSale
    WHERE client.clientNo = bookSale.clientNo
);

-- 도서를 한번도 구매한적이 없는 고객
-- 서브쿼리의 조건에 해당되는 행이 없으면 true 반환
SELECT clientNo, clientName
FROM client
WHERE NOT EXISTS (
    SELECT clientNo
    FROM bookSale
    WHERE client.clientNo = bookSale.clientNo
);

-- 위 예시는 IN, NOT IN 사용할 때와 같은 결과가 나옴
-- NULL값을 포함하고 있는 컬럼 : IN VS EXISTS
-- client 테이블의 clientHobby 컬럼은 NULL값을 포함

-- 서브쿼리의 SELECT된 컬럼의 값이 NULL 포함 여부에 따라 메인쿼리의 결과가 달라질 수 있음
-- EXISTS : 서브쿼리 결과에 NULL값 포함
SELECT clientNo
FROM client
WHERE EXISTS (
    SELECT clientHobby
    FROM client
);

-- IN : 서브쿼리 결과에 NULL값이 포함되지 않음
-- 취미정보가 입력된(NULL이 아닌) 고객의 번호를 조회
SELECT clientNo
FROM client
WHERE clientHobby IN (
    SELECT clientHobby
    FROM client
);

--------------------------------------------------------------------------------

-- ALL / ANY
-- 관계연산자와 같이 사용
-- ALL : 서브쿼리의 결과 리스트가 조건검사대상이 되는 컬럼의 값과 비교할때 리스트의 모든값이 비교연산에 대해 참이 되는 경우 참
-- 컬럼값이 10 > ALL(3,4,5,6) -> 참
-- ANY : 서브쿼리의 결과 리스트가 조건검사대상이 되는 컬럼의 값과 비교할때 리스트의 어떤 하나의 값이 비교연산에 대해 참이 되는 경우 참
-- 컬럼값이 10 > ANY(11,12,5,13) -> 참

-- 2번 고객이 주문한 도서의 최고 주문수량보다 더 많은 도서를 구입한 고객의 고객번호, 주문번호, 주문수량 출력
SELECT clientNo, bsNo, bsQTY
FROM bookSale
WHERE bsQTY > ALL (
    SELECT bsQTY
    FROM bookSale
    WHERE clientNo = '2'
);

-- 2번 고객의 주문 내역들과 비교할때 한번이라도 더 많은 주문을 한 적이 있는 고객(2번 고객이 3번 주문한 주문수량들 중 어떤 수량이라도 더 많이 주문한 고객의 고객번호
-- 주문수량을 조회
-- 2번 고객의 최소 주문수량보다 많이 주문했던 고객의 주문정보 (2번 고객 포함)
SELECT clientNo, bsNo, bsQTY
FROM bookSale
WHERE bsQTY > ANY (
    SELECT bsQTY
    FROM bookSale
    WHERE clientNo = '2'
);

-- 2번 고객이 주문한 최소 주문수량보다 많이 주문한 고객의 주문정보 (2번 고객 제외)
SELECT clientNo, bsNo, bsQTY
FROM bookSale
WHERE bsQTY > ANY (
    SELECT bsQTY
    FROM bookSale
    WHERE clientNo = '2'
) AND clientNo != '2';

--------------------------------------------------------------------------------

-- 스칼라 서브쿼리
-- SELECT절에서 사용
-- 서브쿼리의 결과로 단일열의 스칼라값으로 반환
-- 고객별로 총 주문수량
-- 고객번호, 고객이름, 총 주문수량
SELECT clientNo AS 고객번호, (SELECT clientName -- WHERE절에서 비교되는 clientNo가 group 기준이므로 반환되는 clientName은 그룹별로 반환됨
                  FROM client
                  WHERE bookSale.clientNo = client.clientNo) AS 고객명, SUM(bsQTY) AS "총 주문수량"
FROM bookSale
GROUP BY clientNo
ORDER BY clientNo;

-- DBMS VIEW 객체 제공
-- 하나의 릴레이션에 모든 정보가 저장되지는 않음
-- 필요한 정보를 얻기 위해 JOIN, SUBQUERY 등을 진행하게 됨 -> 많은 연산 수행이 동반됨
-- 한번 연산 해놓은 결과를 다시 동일한 데이터를 사용하려고 할때 빠른 연산을 위해 연산의 순서를 기록해 놓은것
-- 물리적 의미는 위와 같지만 사용할때는 릴레이션처럼 사용가능
-- 개발 중에 뷰가 필요한 경우 뷰를 생성하면 관리 문제나 트랜잭션 등의 성능 문제가 발생할 수 있음
-- 따라서 가상의 뷰, 인라인 뷰를 사용

-- 인라인 뷰 : 변환되는 데이터는 다중행, 다중열이어도 상관없음
-- 도서가격이 25000원 이상인 도서 중 판매된 도서에 대해 도서별로 도서명, 도서가격, 총판매수량, 총판매액 조회
SELECT BOOK.bookName, BOOK.bookPrice, COUNT(*) AS 판매건수, SUM(BS.bsQTY) AS "총 판매수량", SUM(BOOK.bookPrice * BS.bsQTY) AS "총 판매액"
FROM bookSale BS,
    (SELECT bookNo, bookName, bookPrice
     From book
     WHERE bookPrice > 25000) BOOK
WHERE BOOK.bookNo = BS.bookNo
GROUP BY BOOK.bookNo, BOOK.bookName, BOOK.bookPrice;

