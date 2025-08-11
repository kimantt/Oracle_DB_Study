-- SELECT를 통한 테이블 데이터 복사
-- CREATE TABLE ... AS SELECT
-- CREATE TABLE 새 테이블명 AS SELECT 복사할 열 FROM 원본 테이블명 WHERE 조건

-- 테이블 복사 : 제약조건은 복사 안됨 (따로 추가)
CREATE TABLE newBook AS
SELECT * FROM book WHERE bookDate >= '2019-01-01';

-- 제약조건은 복사되지 않으므로 수정 작업
ALTER TABLE newBook
ADD CONSTRAINT PK_newBook_bookNo
PRIMARY KEY(bookNO);

-- newBook 데이터 삭제
DELETE FROM newBook;

-- 빈 테이블에 데이터 저장 - 다른 테이블의 SELECT를 통해서 저장
-- 데이터를 저장할 테이블과 SELECT되는 테이블의 구조가 같을 경우
-- book 테이블과 newBook 테이블이 동일한 구조
INSERT INTO newBook SELECT * FROM book;

-- 테이블 생성
-- book 테이블의 bookNo, BookName 속성을 새로 구성하는 테이블의 구조와 데이터로 사용
CREATE TABLE newBook2 AS
SELECT bookNo, bookName FROM book;

SELECT * FROM newBook2;

DELETE FROM newBook2;

-- newBook2 테이블에 book 테이블의 bookNo, bookName을 복사해서 저장하시오
INSERT INTO newBook2(bookNo, bookName)
SELECT bookNo, bookName FROM book;