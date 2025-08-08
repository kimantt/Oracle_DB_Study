-- 테이블 생성 연습 문제
CREATE TABLE department(
    depNo VARCHAR2(10) NOT NULL PRIMARY KEY,
    depName VARCHAR2(20) NOT NULL,
    depTel VARCHAR2(15),
    depRoom VARCHAR2(5)
);

CREATE TABLE student(
    stdNo VARCHAR2(10) NOT NULL PRIMARY KEY,
    stdName VARCHAR2(10) NOT NULL,
    stdPhone VARCHAR2(15),
    stdGrade NUMBER(1) CHECK(stdGrade > 0 and stdGrade < 5),
    stdDepartment VARCHAR2(10) NOT NULL,
    
    CONSTRAINT FK_student_department FOREIGN KEY (stdDepartment) REFERENCES department(depNo)
);

