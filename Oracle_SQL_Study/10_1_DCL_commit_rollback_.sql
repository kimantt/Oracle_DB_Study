-- commit/rollback

-- commit
-- 트랜잭션 처리가 정상적으로 종료되는 상황
-- 트랜잭션이 수행한 변경 내용을 데이터베이스에 반영하는 연산
-- 트랜잭션이 commit에 의해 완료되면 DB는 완전히 변경되어서 시스템 오류가 발생해도 변경사항이 취소되지 않음

-- rollback
-- 트랜잭션 처리가 비정상적으로 종료된 경우
-- 데이터베이스의 일관성이 깨졌을 때 트랜잭션이 진행한 변경작업을 취소하는 연산 - 이전 상태로 되돌림

-- 간단한 예제
-- insert : DB 테이블에 변경을 가함
INSERT INTO book VALUES('12345678', 'booktest', 'test', 33000, '2020-01-01', 5, '1');

SELECT * FROM book;

ROLLBACK;

SELECT * FROM book;

INSERT INTO book VALUES('12345678', 'booktest', 'test', 33000, '2020-01-01', 5, '1');

SELECT * FROM book;

COMMIT; -- commit 이전에 진행한 작업들의 취소는 불가능함

INSERT INTO book VALUES('12345679', 'booktest1', 'test1', 33000, '2020-01-01', 5, '1');

ROLLBACK; -- rollback 되는 범위는 이전 commit 이후까지 rollback

SELECT * FROM book;

-- commit은 세션종료(접속해제)하면 commit 하는지 물어볼 수 있음