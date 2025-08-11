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

-- 서브쿼리 WHERE절에서 사용할 때
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
















