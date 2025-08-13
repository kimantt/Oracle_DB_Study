-- DCL(데이터 제어어) 정리

/* 사용권한을 관리
- GRANT : 데이터베이스 객체에 권한 부여
- REVOKE : 부여된 권한 회수(취소)

- 권한 : 실행하거나 접근(사용)할 수 있는 권리
- 권한 종류 : 시스템권한, 객체권한

- 시스템 권한
    - DBA 계정에 부여
    - DBA 권한이 있음 - 최상위 권한
    - 사용자 생성/삭제
    - 모든 CREATE 권한
    - 모든 접근 권한
    - 시스템 권한 중 일부는 일반사용자에게 부여됨

- 객체 권한
    - 특정 객체를 조작할 수 있는 권한
    - DML 관련 권한

- ROLE
    - 사용자에게 효율적으로 권한을 부여하도록 여러개의 권한을 묶어놓은것
    - EX. 일반사용자의 필수 권한
        - CREATE TABLE, ALTER, DROP 등
        - INSERT, UPDATE, DELETE, SELECT 등
        - ALTER SESSION, CREATE SEQUENCE 등
        - 공통으로 필요한 권한을 ROLL로 그룹화 한 후 ROLL을 부여함

- CONNECT 롤 : ALTER SESSION, CREATE와 관련된 롤
- RESOURCE 롤 : 사용자객체 생성 및 접근 권한에 해당되는 롤
- DBA 롤 : 슈퍼관리자 권한 모두 부여되는 롤
*/

-- 오라클 세션 설정 변경
ALTER SESSION SET "_ORACLE_SCRIPT" = TRUE;

-- SYSTEM은 사용자 계정 생성/수정/삭제 가능
-- 계정 관리

-- 사용자 계정 생성
-- CREATE USER 계정명 IDENTIFIED BY "비밀번호"
CREATE USER NEWUSER IDENTIFIED BY "1234"
DEFAULT TABLESPACE USERS
TEMPORARY TABLESPACE TEMP;

-- 일반 사용자 ROLE 부여
GRANT CONNECT, RESOURCE TO NEWUSER;

-- 사용자 테이블 스페이스 할당량 지정 (ALTER)
ALTER USER NEWUSER QUOTA UNLIMITED ON USERS; -- 테이블스페이스 무제한 활용

-- 할당량 제한(변경)
ALTER USER NEWUSER QUOTA 50M ON USERS;

-- 사용자 계정 생성 시 할당량 부여
CREATE USER NEWUSER2 IDENTIFIED BY "1234"
DEFAULT TABLESPACE USERS
TEMPORARY TABLESPACE TEMP
QUOTA 10M ON USERS;

GRANT CONNECT, RESOURCE TO NEWUSER2;

-- NEWUSER2에 부여된 CONNECT 롤 제거
REVOKE CONNECT FROM NEWUSER2; -- DB접속과 관련된 ROLE 제거했으므로 접속이 제한됨

-- CONNECT 권한만 부여
GRANT CONNECT TO NEWUSER2;

-- NEWUSER2에 대해 새로운 비밀번호로 변경
ALTER USER NEWUSER2 IDENTIFIED BY 1111;

-- 현재 DB에 생성된 계정정보 확인
-- DBA_USERS / ALL_USERS / USER_USERS
SELECT * FROM DBA_USERS; -- DBA 권한으로만 사용할 수 있는 계정정보 테이블
SELECT * FROM ALL_USERS;
SELECT * FROM USER_USERS; -- 현재 계정에 대한 정보 조회

-- 객체에 대한 정보 확인
-- DBA_XXX : DBA 권한으로 확인가능
SELECT * FROM DBA_TABLES;
-- ALL_XXX : DBA 권한보다 낮으면서 부여된 권한으로 조회할 수 있는 객체 확인
SELECT * FROM ALL_TABLES;
-- USER_XXX : 자신이 생성한 모든 객체에 대한 정보
SELECT * FROM USER_TABLES;

-- 계정 삭제
DROP USER NEWUSER2;
DROP USER NEWUSER2 CASCADE;

-- 사용자에게 부여된 롤 조회
SELECT GRANTEE, GRANTED_ROLE FROM DBA_ROLE_PRIVS
WHERE GRANTEE = 'NEWUSER';

-- ROLE에 부여된 권한 조회
SELECT * FROM DBA_SYS_PRIVS
WHERE GRANTEE = 'RESOURCE';

--------------------------------------------------------------------------------

-- 백업 복구 위한 준비
-- 백업 복구를 진행할 계정은 CONNECT와 RESOURCE 권한이 있어야함

-- 백업 실습 위해 계정에 테이블 복사
CREATE TABLE NEWUSER.PUBLISHER AS
SELECT * FROM C##USER_SELECT.publisher;

CREATE TABLE NEWUSER.BOOK AS
SELECT * FROM C##USER_SELECT.book;

