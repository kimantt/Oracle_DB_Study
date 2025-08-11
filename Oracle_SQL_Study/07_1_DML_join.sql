-- JOIN
-- 여러 개의 테이블을 결합하여 조건에 맞는 행 검색
-- ex. 홍길동 학생의 소속과명
-- 조인 종류
-- 1. inner join : 두 테이블에 공통되는 열이 있을 때
-- 2. outer join : 두 테이블에 공통되는 열이 없을 때도 표현

-- 고객 / 주문 테이블
-- 상품을 주문한 고객을 조회 : inner join
-- 상품을 주문한 고객과 주문하지 않은 고객도 주문내역과 같이 조회 : outer join

-- 형식
/* SELECT 열 리스트
   FROM 테이블명1
   INNER JOIN 테이블명2
   ON 조인 조건(보통 기본키 = 외래키); */
   
-- 주문한 적이 있는 고객의 번호와 이름
-- 고객 테이블에 고객 번호와 이름이 있지만 주문여부는 확인 불가능
-- 주문 테이블에서 주문여부 확인이 가능하지만 고객번호의 고객 이름은 확인 불가능

-- 주문한적이 있는 고객의 모든 정보
-- 가장 많이 사용되는 형식
SELECT * FROM client
INNER JOIN bookSale on client.clientNo = bookSale.clientNo;

// FROM 뒤에 나열해서도 가능 (WHERE절로 조건 설정)
SELECT * FROM client, bookSale
WHERE client.clientNo = bookSale.clientNo;

// 결과는 clientNo를 제외하고는 테이블명 포함시키지 않아도 동일함
// 오라클 서버 입장에서는 속성의 소속을 명확히 하게됨으로 위치를 정확히 알려주므로 성능이 향상
SELECT client.clientNo, client.clientName, bookSale.bsQTY
FROM client, bookSale
WHERE client.clientNo = bookSale.clientNo;

-- 테이블에 별칭 사용
SELECT A.clientNo, A.clientName, b.bsQTY
FROM client A, bookSale B
WHERE A.clientNo = b.clientNo;

-- 주문한적이 있는 고객의 모든 정보 - JOIN (inner join의 약어)
SELECT * FROM client
JOIN bookSale on client.clientNo = bookSale.clientNo;

-- 주문한적이 있는 고객의 정보
-- 중복 행을 제거해서 조회 : UNIQUE
-- 고객번호를 기준으로 정렬
SELECT UNIQUE C.clientNo, C.clientName FROM client C
JOIN bookSale BS on C.clientNo = BS.clientNo
ORDER BY C.clientNo;

-- 소장 도서에 대한 도서명과 출판사명
SELECT bookName, pubName
FROM book B
INNER JOIN publisher P
ON B.pubNo = P.pubNo;

--------------------------------------------------------------------------------

-- 주문(bookSale)된 도서의 도서명(book)과 고객명(client)을 확인
-- 3개 테이블 조인 진행 : SELECT ~ FROM ~ INNER JOIN ~ ON ~ INNER JOIN ~ ON ~
SELECT C.clientName, B.bookName
FROM bookSale BS
INNER JOIN client C ON C.clientNo = BS.clientNo
INNER JOIN book B ON B.bookNo = BS.bookNo;

-- 도서를 주문한 고객의 고객정보, 주문정보, 도서정보 조회
SELECT C.clientName, B.bookName, BS.bsDate, BS.bsQTY
--SELECT *
FROM bookSale BS
INNER JOIN client C ON C.clientNo = BS.clientNo
INNER JOIN book B ON B.bookNo = BS.bookNo;

-- 고객별로 총 주문 수량 계산
-- 주문수량 기준 내림차순 정렬
-- 고객명을 표현할 것
-- 고객별로 그룹 생성 시 동일한 이름의 서로 다른 고객이 있을 수 있으므로 고객명이 필요하다고 해서 고객 이름만으로 그룹을 진행하면 안됨
SELECT C.clientNo, C.clientName, SUM(BS.bsQTY) AS "총 주문수량"
FROM bookSale BS
INNER JOIN client C ON C.clientNo = BS.clientNo
GROUP BY C.clientNo, C.clientName
ORDER BY "총 주문수량" DESC;

-- 쿼리를 통한 연산 진행 - 가공필드 생성 가능
-- 주문된 도서의 주문일, 고객명, 도서명, 도서가격, 주문수량, 주문액(계산 가능 : 주문수량 * 단가)을 조회
SELECT BS.bsDate, C.clientName, B.bookName, B.bookPrice, BS.bsQTY,
       BS.bsQTY * B.bookPrice AS "주문액"
FROM bookSale BS
INNER JOIN client C ON C.clientNo = BS.clientNo
INNER JOIN book B ON B.bookNo = BS.bookNo
ORDER BY "주문액" DESC;

-- 조인된 결과를 활용한 가공필드 생성
SELECT BS.bsDate, C.clientName, B.bookName, B.bookPrice, BS.bsQTY,
       BS.bsQTY * B.bookPrice AS "주문액"
FROM bookSale BS
INNER JOIN client C ON C.clientNo = BS.clientNo
INNER JOIN book B ON B.bookNo = BS.bookNo
WHERE (BS.bsQTY * B.bookPrice) >= 100000 -- 별칭 사용 불가능 (별칭 구성 전에 진행됨)
ORDER BY "주문액" DESC; -- 별칭 사용 가능

-- 2018년부터 현재까지 판매된 도서의 주문일, 고객명, 도서명, 도서가격, 주문수량, 주문액 계산해서 조회
SELECT BS.bsDate, C.clientName, B.bookName, B.bookPrice, BS.bsQTY,
       BS.bsQTY * B.bookPrice AS "주문액"
FROM bookSale BS
INNER JOIN client C ON C.clientNo = BS.clientNo
INNER JOIN book B ON B.bookNo = BS.bookNo
WHERE BS.bsDate >= '2018-01-01'
ORDER BY BS.bsDate;

--------------------------------------------------------------------------------

-- client 테이블과 bookSale 테이블 활용 outer join 예시
-- 왼쪽(LEFT) 기준
-- 고객의 주문정보 확인 (주문한적이 없는 고객에 대한 정보도 조회)
SELECT *
FROM client C
LEFT OUTER JOIN bookSale BS
ON C.clientNo = BS.clientNo
ORDER BY C.clientNo;
-- 조회결과 CLIENTNO_1 컬럼에 NULL이라고 표현되는 튜플은 주문한적이 없는 고객에 대한 정보를 주문정보 없이 표현

-- 오른쪽(RIGHT) 기준
-- 서점의 고객 중 주문하지 않은 고객은 존재 가능. 단, 주문한 고객 중 서점의 회원이 아닌 고객은 없음
SELECT *
FROM client C
RIGHT OUTER JOIN bookSale BS
ON C.clientNo = BS.clientNo
ORDER BY C.clientNo;

-- 완전(FULL) OUTER JOIN
-- 고객이 아니면 주문이 불가능하다는 제약조건이 있음 - 따라서 결과는 LEFT OUTER JOIN과 동일
SELECT *
FROM client C
FULL OUTER JOIN bookSale BS
ON C.clientNo = BS.clientNo
ORDER BY C.clientNo;

-- 오라클 OUTER JOIN
-- (+) 연산자를 조인시킬 값이 없는 조인 측에 위치
-- 고객의 주문정보 확인하되 주문이 없는 고객의 정보 확인
SELECT *
FROM client C, bookSale BS
WHERE C.clientNo = BS.clientNo (+)
ORDER BY C.clientNo;

