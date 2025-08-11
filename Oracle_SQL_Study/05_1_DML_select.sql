-- SELECT
/*
SELECT [ALL | DISTINCT] 열이름 리스트
FROM 테이블명
[WHERE 검색조건(들)]
[GROUP BY 열이름]
[HAVING 검색조건(들)]
[ORDER BY 열이름 [ASC | DESC]]
*/

-- 서점 관계 테이블 IMPORT 후 테이블에 제약 조건 설정

-- 참조 무결성 제약 조건
-- 참조되는 테이블의 기본키 먼저 구성, 참조하는 테이블의 외래키 구성

-- 서점의 모든 도서는 거래하고 있는 출판사에서 구매된다 - 도서 테이블(BOOK) 출판사 데이터(pubNo)는 출판사 테이블(PUBLISHER)의 기본키 도메인의 범위에 국한된다
-- 서점의 모든 도서는 회원가입되어 있는 회원이 서점에 등록되어있는 도서를 구매할 수 있다 : 구매관계 테이블(BOOKSALE)

-- 기본키 제약조건
ALTER TABLE publisher
    ADD CONSTRAINT PK_publisher_pubNo
    PRIMARY KEY(pubNo);
    
ALTER TABLE book
    ADD CONSTRAINT PK_book_bookNo
    PRIMARY KEY(bookNo);
    
ALTER TABLE client
    ADD CONSTRAINT PK_client_clientNo
    PRIMARY KEY(clientNo);
    
ALTER TABLE bookSale
    ADD CONSTRAINT PK_bookSale_bsNo
    PRIMARY KEY(bsNo);

-- 외래키 제약조건 추가
ALTER TABLE book
    ADD CONSTRAINT FK_book_publisher
    FOREIGN KEY(pubNo) REFERENCES publisher(pubNo);
    
ALTER TABLE bookSale
    ADD CONSTRAINT FK_bookSale_client
    FOREIGN KEY(clientNo) REFERENCES client(clientNo);
    
ALTER TABLE bookSale
    ADD CONSTRAINT FK_bookSale_book
    FOREIGN KEY(bookNo) REFERENCES book(bookNo);

--------------------------------------------------------------------------------

-- 특정 테이블의 모든 튜플을 반환 -> 반환결과 테이블
SELECT * FROM publisher;

-- BOOK 테이블에서 도서명, 도서가격만 출력
SELECT bookName, bookPrice FROM book;

-- BOOK 테이블에서 저자 검색
SELECT bookAuthor FROM book;
SELECT DISTINCT bookAuthor FROM book; -- 중복 튜플 한번만 반환

--------------------------------------------------------------------------------

/*
WHERE 조건절 : 검색의 세분화
조건 사용 연산자
비교 : =, <, >, <=, >=, !=
범위 : BETWEEN
리스트에 포함 : IN, NOT IN
NULL : IS NULL, IS NOT NULL
논리 : AND, OR
패턴 매칭 : LIKE
*/

-- 비교 : =, <, >, <=, >=, !=
-- 저자가 홍길동인 도서의 도서명, 저자 반환
SELECT bookName, bookAuthor FROM book WHERE bookAuthor='홍길동';

-- 도서가가 30000원 이상인 도서의 도서명, 가격, 재고 반환
SELECT bookName, bookPrice, bookStock FROM book
    WHERE bookPrice >= 30000;
    
-- 도서재고가 3권 이상이고 5권 이하인 도서의 도서명과 재고 반환
SELECT bookName, bookStock FROM book
    WHERE bookStock >= 3 AND bookStock <= 5;
    
-- 범위 : BETWEEN
-- 도서재고가 3권 이상이고 5권 이하인 도서의 도서명과 재고 반환 - 위의 질의어와 같은 의미
SELECT bookName, bookStock FROM book
    WHERE bookStock BETWEEN 3 AND 5;
    
-- 리스트에 포함 : IN, NOT IN : 속성명 IN (값1, 값2, ...) -> 리스트
-- 서울출판사('1')와 도서출판 강남('2')의 도서명과 출판사 번호 출력
SELECT bookName, pubNo FROM book
    WHERE pubNo IN ('1', '2');
    
-- 서울출판사('1')와 도서출판 강남('2')의 도서가 아닌 도서의 도서명과 출판사 번호 출력
SELECT bookName, pubNo FROM book
    WHERE pubNo NOT IN ('1', '2');
    
-- NULL : IS NULL, IS NOT NULL
-- 모든 클라이언트의 이름과 취미를 반환
SELECT clientName, clientHobby FROM client;

-- 취미 정보가 NULL인 클라이언트의 이름과 취미를 반환
SELECT clientName, clientHobby FROM client
    WHERE clientHobby IS NULL;
    
-- 취미 정보가 NULL이 아닌 클라이언트의 이름과 취미를 반환
SELECT clientName, clientHobby FROM client
    WHERE clientHobby IS NOT NULL;
    
-- 취미에 공백값이 저장되어있는 클라이언트의 이름과 취미
SELECT clientName, clientHobby FROM client
    WHERE clientHobby = ' ';

-- 논리 : AND, OR
-- 저자가 홍길동이면서 재고가 3권 이상인 도서의 정보 반환
SELECT * FROM book
    WHERE bookAuthor = '홍길동' AND bookStock >= 3;
    
-- 저자가 홍길동이거나 성춘향인 도서의 정보
SELECT * FROM book
    WHERE bookAuthor = '홍길동' OR bookAuthor = '성춘향';

-- 저자가 홍길동이거나 성춘향인 도서의 정보 : IN 사용
SELECT * FROM book
    WHERE bookAuthor IN ('홍길동', '성춘향');
    
-- 패턴 매칭 : LIKE
-- WHERE 컬럼명 LIKE '패턴'
-- % : 0개 이상의 문자를 가진 문자열, _ : 한 개의 문자
-- '홍%' : 홍으로 시작하는 문자열 Ex. 홍, 홍길, 홍길동
-- '%길%' : 길을 포함하는 문자열 Ex. 길, 홍길, 길동, 홍길동
-- '%동' : 동으로 끝나는 문자열 Ex. 동, 길동, 홍길동
-- ____ : 4개의 문자로 구성된 문자열 Ex. 홍길동전, 홍길동(X)

-- 출판사명에 '출판사' 문자열이 포함된 출판사 정보
SELECT * FROM publisher
    WHERE pubName LIKE '%출판사%';
    
-- 출생년도가 1990년대인 고객의 정보 반환
SELECT * FROM client
    WHERE clientBirth LIKE '199%';
    
-- 이름이 4글자인 고객의 정보 반환
SELECT * FROM client
    WHERE clientName LIKE '____';
    
-- NOT LIKE
-- 도서명에 안드로이드가 포함되지 않은 도서의 정보
SELECT * FROM book
    WHERE bookName NOT LIKE '%안드로이드%';
    
--------------------------------------------------------------------------------

-- ORDER BY
-- 특정 열의 값을 기준으로 정렬
-- 가장 마지막에 진행되는 연산 (ORDER BY 절은 마지막에 나옴)
-- 기준열을 두 개 이상 나열 가능 - 우선기준, 두번째 기준, 세번째 기준, ...
-- ASC : 오름차순 (기본값이라 생략가능)
-- DESC : 내림차순
-- 도서 정보를 도서명 순으로 반환
SELECT * FROM book
    ORDER BY bookName;

-- 내림차순
SELECT * FROM book
    ORDER BY bookName DESC;
    
-- 조건절 뒤에 ORDER BY
SELECT bookName, bookAuthor, bookStock FROM book
    WHERE bookPrice >= 20000
    ORDER BY bookPrice;
    
-- 정렬 조건 2개 이상일 경우
-- 도서 재고를 기준으로 내림차순 정렬하고 재고가 동일한 튜플인 경우 저자를 기준으로 오름차순 정렬한 도서 정보를 반환
SELECT * FROM book
    ORDER BY bookStock DESC, bookAuthor ASC;

--------------------------------------------------------------------------------

-- 집계 함수
-- SUM() / AVG() / COUNT() / COUNT(*) / MAX() / MIN()

-- SUM()
-- 도서의 총 재고 수량 출력
SELECT SUM(bookStock) FROM book; -- 테이블 반환 -> 컬럼명이 있음 (SELECT 컬럼에 연산을 진행하면 연산식이 컬럼명으로 반환)

-- 모든 컬럼은 컬럼의 별명 생성 가능 (SELECT문에서 AS 활용)
-- 컬럼 AS "별명"
SELECT SUM(bookStock) AS "SUM OF BOOKSTOCK" FROM book;

-- 한글 가능 
SELECT SUM(bookStock) AS "총 재고량" FROM book;

-- 2번 고객이 주문한 총 주문 도서 수
SELECT SUM(bsQTY) AS "총 주문수량" FROM bookSale WHERE clientNo = '2';

-- 2번 고객이 주문한 총 주문 도서 수와 주문 도서 번호
-- 총 주문수량은 1개의 튜플
-- 도서번호는 3개의 튜플
-- GROUP BY 절을 포함하고 있는 경우가 아니면 SELECT에 집계함수가 포함되면 다른 컬럼도 집계함수를 사용해야함
/*
SELECT SUM(bsQTY) AS "총 주문수량", bookNo AS "도서번호"
FROM bookSale WHERE clientNo = '2';
*/
SELECT SUM(bsQTY) AS "총 주문수량", AVG(bsQTY) AS "평균주문수량"
FROM bookSale WHERE clientNo = '2';

-- MIN() / MAX()
-- 도서 판매 현황 중 주문 권수가 가장 많은 주문권수, 가장 적은 주문권수
SELECT MAX(bsQTY) AS 최대주문량, MIN(bsQTY) AS 최소주문량 FROM bookSale;

-- AVG()
-- 서점에 있는 도서의 전체 가격 총액, 평균가격, 최고가, 최저가 확인
SELECT SUM(bookPrice) AS 가격총액,
       AVG(bookPrice) AS 평균가격,
       MAX(bookPrice) AS 최고가,
       MIN(bookPrice) AS 최저가
FROM book;

-- COUNT()
-- 도서판매 테이블에서 도서 판매 건수 조회
-- bsDate가 null을 허용하거나 값이 중복되는 컬럼이라면 count가 원하는 목적으로 반환되지 않을 수 있음
SELECT COUNT(bsDate) AS "총 판매건수" FROM bookSale;

-- COUNT(*)
-- 특정 필드값의 수가 아닌 튜플의 수를 세고자 하면 count(*) 활용
SELECT COUNT(*) AS "총 판매건수" FROM bookSale;

-- 고객 테이블에서 총 취미의 개수 출력 : 취미를 제공한 고객 수
-- count(속성명) : 속성값이 null인 경우는 제외하고 수를 센 결과 반환
SELECT COUNT(clientHobby) AS 취미 FROM client;

-- 서점의 총 고객수는 몇명인가?
SELECT COUNT(*) FROM client;

--------------------------------------------------------------------------------

-- GROUP BY <속성>
-- 그룹에 대한 질의를 기술할 때 사용
-- 특정 열(속성)의 값을 기준으로 동일한 값의 데이터들끼리 그룹을 구성
-- 각 그룹에 대해 한 행씩 질의 결과 생성

-- 각 도서번호별 판매수량 확인
-- group by 진행한 경우 select절에 집계함수를 통해 필요 열의 집계 진행가능, group by에 기준되는 열은 select에 포함시킬 수 있음
SELECT SUM(bsQTY), bookNo FROM bookSale GROUP BY bookNo
ORDER BY 1; -- select된 첫번째 열을 기준으로 정렬

-- 각 지역별 고객의 수
SELECT clientAddress AS 지역, COUNT(*) AS 고객수 FROM client GROUP BY clientAddress;

-- 성별에 따른 고객의 수
SELECT clientGender AS 성별, COUNT(*) AS 고객수 FROM client GROUP BY clientGender;

-- 성별에 따른 고객 수와 고객들의 지역
-- group by의 기준으로 사용하지 않은 필드는 select에 단독 사용 불가
/*
SELECT clientGender AS 성별, COUNT(*) AS 고객수, clientAddress AS 지역
FROM client
GROUP BY clientGender;
*/
SELECT clientGender AS 성별, COUNT(*) AS 고객수, clientAddress AS 지역
FROM client
GROUP BY clientGender, clientAddress;

-- HAVING <검색 조건>
-- group by절에 의해 구성된 그룹들에 대해 적용할 조건 기술
-- 집계함수와 함께 사용
-- 주의!
-- 1. 반드시 group by절과 함께 사용
-- 2. where절보다 뒤에 위치
-- 3. 검색조건에 집계함수가 와야함

-- 각 출판사별 도서가격이 25000 이상인 도서가 2권 이상인 출판사번호와 도서권수
SELECT pubNo, COUNT(*) AS 도서합계 FROM book
WHERE bookPrice >= 25000
GROUP BY pubNo HAVING COUNT(*) >= 2;

