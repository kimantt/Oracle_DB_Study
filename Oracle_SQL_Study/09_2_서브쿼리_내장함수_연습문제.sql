-- 연습문제3

-- 서브쿼리 연습문제
-- 1.호날두(고객명)가 주문한 도서의 총 구매량 출력
SELECT SUM(bsQTY)
FROM bookSale
WHERE clientNo = (
    SELECT clientNo
    FROM client
    WHERE clientName = '호날두'
);
-- JOIN 활용
SELECT SUM(BS.bsQTY) 
FROM bookSale BS
INNER JOIN client C ON C.clientNo = BS.clientNO
WHERE C.clientName = '호날두';

-- 2.'정보출판사'에서 출간한 도서를 구매한 적이 있는 고객명 출력
SELECT clientName
FROM client
WHERE clientNo IN (
    SELECT clientNo
    FROM bookSale
    WHERE bookNo IN (
        SELECT bookNo
        FROM book
        WHERE pubNo = (
            SELECT pubNo
            FROM publisher
            WHERE pubName = '정보출판사'
        )
    )
);
-- JOIN 활용
SELECT DISTINCT C.clientName
FROM client C
INNER JOIN bookSale BS ON BS.clientNO = C.clientNo
INNER JOIN book B ON B.bookNo = BS.bookNo
INNER JOIN publisher P ON P.pubNo = B.pubNo
WHERE P.pubName = '정보출판사';

-- 3.베컴이 주문한 도서의 최고 주문수량 보다 더 많은 도서를 구매한 고객명 출력
SELECT clientName
FROM client
WHERE clientNo IN (
    SELECT clientNo
    FROM bookSale
    WHERE bsQTY > (
        SELECT MAX(bsQTY)
        FROM bookSale
        WHERE clientNo = (
            SELECT clientNo
            FROM client
            WHERE clientName = '베컴'
        )
    )
);
-- JOIN 활용
SELECT DISTINCT C.clientName
FROM client C
INNER JOIN bookSale BS ON C.clientNo = BS.clientNo
INNER JOIN client C_bk ON C_bk.clientName = '베컴'
INNER JOIN bookSale BS_bk ON BS_bk.clientNo = C_bk.clientNo
GROUP BY C.clientName, BS.bsQTY
HAVING BS.bsQTY > MAX(BS_bk.bsQTY);

-- 4.천안에 거주하는 고객에게 판매한 도서의 총 판매량 출력
SELECT SUM(bsQTY)
FROM bookSale
WHERE clientNo IN (
    SELECT clientNo
    FROM client
    WHERE clientAddress = '천안'
);
-- JOIN 활용
SELECT SUM(BS.bsQTY)
FROM bookSale BS
INNER JOIN client C ON BS.clientNo = C.clientNo
WHERE C.clientAddress = '천안';


-- 내장함수 연습문제
-- 저자 중 성(姓)이 '손'인 모든 저자 출력
SELECT DISTINCT bookAuthor
FROM book
WHERE SUBSTR(bookAuthor,1,1) = '손';

-- 저자 중에서 같은 성(姓)을 가진 사람이 몇명이나 되는지 알아보기 위해 성(姓)별로 그룹 지어 인원수 출력
SELECT SUBSTR(bookAuthor, 1, 1) AS 성,
       COUNT(*) AS 인원수
FROM book
GROUP BY GROUPING SETS(SUBSTR(bookAuthor, 1, 1));

-- CUBE, ROLLUP, GROUPING SETS
CREATE TABLE sales(
    prdName VARCHAR2(20),
    salesDate VARCHAR2(10),
    prdCompany VARCHAR2(10),
    salesAmount NUMBER(8)
);
INSERT INTO sales VALUES('노트북','2021.01','삼성',10000);
INSERT INTO sales VALUES('노트북','2021.03','삼성',20000);
INSERT INTO sales VALUES('냉장고','2021.01','LG',12000);
INSERT INTO sales VALUES('냉장고','2021.03','LG',20000);
INSERT INTO sales VALUES('프린터','2021.01','HP',3000);
INSERT INTO sales VALUES('프린터','2021.03','HP',1000);
SELECT * FROM sales;

-- 상품과 회사의 모든 조합별 판매액 합계와 전체 판매액 합계를 산출
SELECT prdName, prdCompany, SUM(salesAmount) AS 판매액
FROM sales
GROUP BY CUBE(prdName, prdCompany);

-- 상품과 회사별 판매액 합계와 상품별 판매액 합계를 산출
SELECT prdName, prdCompany, SUM(salesAmount) AS 판매액
FROM sales
GROUP BY ROLLUP(prdName, prdCompany);

-- 상품별 판매액 합계와 회사별 판매액 합계만 산출
SELECT prdName, prdCompany, SUM(salesAmount) AS 판매액
FROM sales
GROUP BY GROUPING SETS(prdName, prdCompany);

-- 주문일에 7일을 더한 날을 배송일로 계산하여 출력
SELECT bsDate AS 주문일, bsDate+7 AS 배송일
FROM bookSale;

-- 도서 테이블에서 도서명과 출판연도 출력
SELECT bookName AS 도서명, EXTRACT(YEAR FROM bookDate) AS 출판연도
FROM book;

