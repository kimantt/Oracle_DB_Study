-- 테이블 생성
-- 동일DB(동일계정)에 동일명 테이블이 있으면 안됨
-- 기본키 제약조건
-- 1. 속성 설정 시 기본키 지정
CREATE TABLE product(
    prdNo VARCHAR2(10) NOT NULL PRIMARY KEY,
    prdName VARCHAR2(30) NOT NULL,
    prdPrice NUMBER(8),
    prdCompany VARCHAR2(30)
);

-- 2. 기본키 따로 설정 : PRIMARY KEY(필드명)
CREATE TABLE product(
    prdNo VARCHAR2(10) NOT NULL,
    prdName VARCHAR2(30) NOT NULL,
    prdPrice NUMBER(8),
    prdCompany VARCHAR2(30),
    
    PRIMARY KEY (prdNo)
);

-- 3. 제약 이름과 같이 설정 : 제약 변경이나 삭제 시 유용함 -> CONSTRAINT PK_product_prdNo PRIMARY KEY
CREATE TABLE product(
    prdNo VARCHAR2(10) NOT NULL CONSTRAINT PK_product_prdNo PRIMARY KEY,
    prdName VARCHAR2(30) NOT NULL,
    prdPrice NUMBER(8),
    prdCompany VARCHAR2(30)
);

-- 4. 따로 설정하면서 제약명 추가
CREATE TABLE product2(
    prdNo VARCHAR2(10) NOT NULL,
    prdName VARCHAR2(30) NOT NULL,
    prdPrice NUMBER(8),
    prdCompany VARCHAR2(30),
    
    CONSTRAINT PK_product_prdNo PRIMARY KEY (prdNo)
);

-----------------------------------------------------------------------------------------------

-- 출판사 테이블 먼저 생성하고 도서 테이블 생성 (외래키 참조필드)
-- 외래키 필드에 입력되는 값은 참조테이블의 기본키로서 값과 동일해야함
-- 외래키 필드의 도메인과 참조테이블의 기본키 도메인은 동일해야함
-- 테이블 삭제 시에는 생성과 반대로 참조하는 book을 먼저 삭제하고 publisher를 삭제
/* 출판사 테이블 생성 (출판사 번호, 출판사명)
제약조건
- 기본키 not null
*/
CREATE TABLE publisher(
    pubNo VARCHAR2(10) NOT NULL PRIMARY KEY,
    pubName VARCHAR2(30) NOT NULL
);

/* 도서 테이블 생성 (도서번호, 도서명, 가격, 발행일, 출판사번호)
기본키
외래키
기본값 체크조건
*/
-- 외래키 필드는 참조테이블에서는 기본키여야함
CREATE TABLE book(
    bookNo VARCHAR2(10) NOT NULL PRIMARY KEY,
    bookName VARCHAR2(30) NOT NULL,
    bookPrice NUMBER(8) DEFAULT 10000 CHECK(bookPrice > 1000),
    bookDate DATE,
    pubNo VARCHAR2(10) NOT NULL,
    CONSTRAINT FK_book_publisher FOREIGN KEY (pubNo) REFERENCES publisher(pubNo)
);

-----------------------------------------------------------------------------------------------

-- 교수 테이블
CREATE TABLE professor (
	profNo VARCHAR2(10) NOT NULL PRIMARY KEY,
    profName VARCHAR2(30) NOT NULL,
    profPosition VARCHAR2(30),
    profTel VARCHAR2(13),
    dptNo VARCHAR2(10) NOT NULL,
    FOREIGN KEY (dptNo) REFERENCES department(depNo)
);

-- 과목 테이블
CREATE TABLE course (
	courseId VARCHAR(10) NOT NULL PRIMARY KEY,
    courseName VARCHAR(30) NOT NULL,
    courseCredit INT,
    profNo VARCHAR(10) NOT NULL,
    FOREIGN KEY (profNo) REFERENCES professor(profNo)
);

-- 성적 테이블
CREATE TABLE scores(
    stdNo VARCHAR2(10) NOT NULL,
    courseId VARCHAR2(10) NOT NULL,
    score NUMBER(3),
    grade VARCHAR2(2),
    CONSTRAINT PK_SCORES_STDNO_COURSEID PRIMARY KEY(stdNo, courseId),
    CONSTRAINT FK_SCORES_STUDENT FOREIGN KEY(stdNo) REFERENCES student(stdNo),
    CONSTRAINT FK_SCORES_COURSE FOREIGN KEY(courseId) REFERENCES course(courseId)
);
