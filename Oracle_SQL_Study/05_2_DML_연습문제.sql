-- 연습문제 (2025-08-08)

-- INSERT 연습문제 1
-- 속성과 값을 모두 나열
INSERT INTO student(stdNo, stdName, stdYear, stdBirthday, dptNo)
VALUES('2016001', '홍길동', 4, '1997-01-01', '1');

-- 값만 나열
INSERT INTO student VALUES('2015002', '성춘향', 3, '1996-12-10', '3');

-- 나머지 전체 한번에 저장
INSERT ALL
INTO student VALUES('2014004', '이몽룡', 2, '1996-03-03', '2')
INTO student VALUES('2016002', '변학도', 4, '1995-05-07', '1')
INTO student VALUES('2015003', '손흥민', 3, '1997-11-11', '2')
SELECT * FROM DUAL;

SELECT * FROM student;


-- INSERT, UPDATE, DELETE 연습문제
-- BOOK 테이블에 행 삽입
INSERT ALL
INTO book VALUES('5', 'JAVA 프로그래밍', 30000, '2021-03-10', '서울 출판사')
INTO book VALUES('6', '파이썬 데이터 과학', 24000, '2018-02-05', '도서출판 강남')
SELECT * FROM DUAL;

-- 도서명이 '데이터베이스'인 행의 가격을 22000으로 변경
UPDATE book SET bookPrice=22000 WHERE bookName='데이터베이스';

-- 발행일이 2018년도인 행 삭제
DELETE FROM book
    WHERE bookDate >= '2018-01-01' AND bookDate <=  '2018-12-31';
    
    
-- 종합 연습문제
-- 고객 테이블 생성
CREATE TABLE customer(
    custNo VARCHAR2(10) NOT NULL PRIMARY KEY,
    custName VARCHAR2(30) NOT NULL,
    custPhone VARCHAR2(30),
    custAddress VARCHAR2(40)
);

-- 주문 테이블 생성
CREATE TABLE orderProduct(
    orderNo VARCHAR2(10) NOT NULL PRIMARY KEY,
    orderDate DATE,
    orderQTY NUMBER(3),
    custNo VARCHAR2(10) NOT NULL,
    prdNo VARCHAR2(4) NOT NULL,
    
    CONSTRAINT FK_orderProduct_customer FOREIGN KEY(custNo) REFERENCES customer(custNo),
    CONSTRAINT FK_orderProduct_product FOREIGN KEY(prdNo) REFERENCES product(prdNo)
);

-- 고객 테이블의 전화번호 열을 NOT NULL로 변경
ALTER TABLE customer MODIFY custPhone VARCHAR2(30) NOT NULL;

-- 고객 테이블에 '성별', '나이' 열 추가
ALTER TABLE customer ADD (custGender VARCHAR2(3), custAge Number(3));

-- 고객, 주문 테이블에 데이터 삽입
INSERT ALL
INTO customer VALUES('1001', '홍길동', '010-1111-1111', '강원도 평창', '남', 22)
INTO customer VALUES('1002', '이몽룡', '010-2222-2222', '서울 종로구', '남', 23)
INTO customer VALUES('1003', '성춘향', '010-3333-3333', '서울시 강남구', '여', 22)
SELECT * FROM DUAL;

INSERT ALL
INTO orderProduct VALUES('1', '2018-01-10', 3, '1003', '3')
INTO orderProduct VALUES('2', '2018-03-03', 1, '1001', '7')
INTO orderProduct VALUES('3', '2018-04-05', 2, '1002', '2')
SELECT * FROM DUAL;

-- 주문 테이블에서 상품번호가 2인 행의 주문수량을 3으로 수정
UPDATE orderProduct SET orderQTY=3 WHERE prdNo='2';


-- SELECT 연습문제
-- 1.고객 테이블에서 고객명, 생년월일, 성별 출력
SELECT clientName, clientBirth, clientGender FROM client;

-- 2.고객 테이블에서 주소만 검색하여 출력 (중복되는 튜플은 한번만 출력)
SELECT DISTINCT clientAddress FROM client;

-- 3.고객 테이블에서 취미가 '축구'이거나 '등산'인 고객의 고객명, 취미 출력
SELECT clientName, clientHobby FROM client
    WHERE clientHobby = '축구' OR clientHobby = '등산';

-- 4.도서 테이블에서 저자의 두 번째 위치에 '길'이 들어 있는 저자명 출력 (중복되는 튜플은 한번만 출력)
SELECT DISTINCT bookAuthor FROM book
    WHERE bookAuthor LIKE '_길%';

-- 5.도서 테이블에서 발행일이 2018년인 도서의 도서명, 저자, 발행일 출력
SELECT bookName, bookAuthor, bookDate FROM book
    WHERE bookDate LIKE '2018%';

-- 6.도서판매 테이블에서 고객번호1, 2를 제외한 모든 튜플 출력
SELECT * FROM bookSale
    WHERE clientNo NOT IN ('1', '2');

-- 7.고객 테이블에서 취미가 NULL이 아니면서 주소가 '서울'인 고객의 고객명, 주소, 취미 출력
SELECT clientName, clientAddress, clientHobby FROM client
    WHERE clientHobby IS NOT NULL AND clientAddress = '서울';

-- 8.도서 테이블에서 가격이 25000 이상이면서 저자 이름에 '길동'이 들어가는 도서의 도서명, 저자, 가격, 재고 출력
SELECT bookName, bookAuthor, bookPrice, bookStock FROM book
    WHERE bookPrice >= 25000 AND bookAuthor LIKE '%길동%';

-- 9.도서 테이블에서 가격이 20,000 ~25,000원인 모든 튜플 출력
SELECT * FROM book WHERE bookPrice BETWEEN 20000 AND 25000;

-- 10.도서 테이블에서 저자명에 '길동'이 들어 있지 않는 도서의 도서명, 저자 출력
SELECT bookName, bookAuthor FROM book
    WHERE bookAuthor NOT LIKE '%길동%';



