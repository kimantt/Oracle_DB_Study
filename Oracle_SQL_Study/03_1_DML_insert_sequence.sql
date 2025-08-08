-- 데이터 조작어(DML)
-- 데이터 입력/삭제/수정/검색
-- INSERT문 : 테이블에 데이터(튜플)을 저장하는 조작
-- INSERT INTO 테이블명(열이름 리스트) VALUES(값 리스트) : 부분열만 저장 가능 - NULL 허용하는 열의 값은 생략해도됨
-- INSERT INTO 테이블명 VALUES(값 리스트) : 값 리스트에 모든 열의 값이 테이블 생성 시 순서에 맞춰 나열되어야함

-- STUDENT 테이블에 행 삽입 - 열이름 리스트 나열하면 열 순서 상관없음, 값 순서는 나열한 열 순서와 동일해야함
INSERT INTO student(stdNo, stdName, stdYear, dptNo)
VALUES('2016005', '변학도', 4, '1');
-- 값이 문자열일때는 ' ' 표시

-- 열 나열 없이 실제 값만 나열 : 단, 모든 필드의 값이 다 나열되어야 함
INSERT INTO student
VALUES('2016005', '변학도', 4, '서울', '2020-01-01', '1');

-- BOOK 테이블에 데이터 저장
INSERT INTO book
VALUES('4', '자바스크립트', 23000, '2019-05-17', '2');

-- BOOK 테이블 내용 조회 : DB로부터 반환되는 결과는 릴레이션 형태로 나옴
SELECT * FROM book;

-- SELECT EX
SELECT bookName FROM book WHERE bookNo='1';

-- 여러개의 Data(튜플)를 저장 : INSERT ALL INTO 테이블명() VALUES() INTO 테이블명 ... SELECT * FROM DUAL;
INSERT ALL
INTO book VALUES('5', 'C프로그래밍', 35000, '2021-05-12', '2')
INTO book VALUES('6', '파이썬', 30000, '2022-08-07', '1')
SELECT * FROM DUAL;

-- 시퀀스
-- 오라클 데이터베이스 객체로 유이한 값의 일련번호 생성
-- 지정한 수치로 증가하거나 감소
-- 기본키에 자동증가값을 사용할 때 유용
-- 최대 15개까지 생성 가능
-- 객체이기 때문에 테이블과 독립적으로 저장 생성
-- 하나의 시퀀스를 여러 테이블에서 사용가능

-- 시퀀스 생성 : CREATE SEQUENCE 시퀀스명 옵션
CREATE SEQUENCE NO_SEQ
    START WITH 1
    INCREMENT BY 1
    MAXVALUE 10000
    MINVALUE 1
    NOCYCLE;

--  시퀀스 적용할 테이블 생성
DROP TABLE board;
CREATE TABLE  board(
    bNo NUMBER PRIMARY KEY,
    bSubject VARCHAR2(30) NOT NULL,
    bname   VARCHAR2(20) NOT NULL
);

-- 데이터 추가
INSERT INTO board VALUES(NO_SEQ.NEXTVAL, '추석', '홍길동'); -- 시퀀스명.NEXTVAL : 현재값에서 증가분만큼 증가시켜 반환하고 반환된 값 저장
INSERT INTO board VALUES(NO_SEQ.NEXTVAL, '미세먼지', '홍길동');
INSERT INTO board VALUES(NO_SEQ.NEXTVAL, '휴가', '홍길동');

-- 현재 시퀀스 값 검색
SELECT NO_SEQ.CURRVAL FROM DUAL;

-- 시퀀스 수정
ALTER SEQUENCE NO_SEQ
    MAXVALUE 1000;
    
-- 수정 결과 검색 : 구조에 대한 검색, 시퀀스 정보 저장 테이블 USER_SEQUENCES
SELECT SEQUENCE_NAME, MAX_VALUE FROM USER_SEQUENCES;

-- 시퀀스 삭제 : DROP SEQUENCE
DROP SEQUENCE NO_SEQ;

-- 삭제 확인
SELECT SEQUENCE_NAME FROM USER_SEQUENCES; -- 삭제했으므로 반환되는 결과 내용은 없음, 테이블이 반환됨(내용이 빈 테이블)

-- DUAL 테이블
-- 오라클 자체에서 제공되는 테이블
-- 1개의 행과 1개의 열만 있는 더미테이블
-- SYS 소유이지만 모든 사용자가 사용할 수 있음
-- 간단한 함수 계산결과값 확인할때 테이블 생성 없이 결과값 확인(리턴 받을 수 있음)
SELECT CURRENT_DATE FROM DUAL;

-----------------------------------------------------------------------------------------------

-- 데이터 임포트
-- 텍스트 파일을 읽어서 테이블 생성 및 데이터 구성

-- 데이터 임포트 후 제약조건 추가
ALTER TABLE product
    ADD CONSTRAINT PK_PRODUCT_PRDNO1
    PRIMARY KEY(prdNo);


