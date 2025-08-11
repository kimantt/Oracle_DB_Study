-- 연습문제

-- ORDER BY, 집계함수, GROUP BY, HAVING 연습문제
-- 1.도서 테이블에서 가격 순으로 내림차순 정렬하여,  도서명, 저자, 가격 출력 (가격이 같으면 저자 순으로 오름차순 정렬)
SELECT bookName, bookAuthor, bookPrice FROM book ORDER BY bookPrice DESC, bookAuthor ASC;

-- 2.도서 테이블에서 저자에 '길동'이 들어가는 도서의 총 재고 수량 계산하여 출력
SELECT SUM(bookStock) AS "총 재고 수량" FROM book WHERE bookAuthor LIKE '%길동%';

-- 3.도서 테이블에서 ‘서울 출판사' 도서 중 최고가와 최저가 출력
SELECT MAX(bookPrice) AS 최고가, MIN(bookPrice) AS 최저가 FROM book WHERE pubNo = '1';

-- 4.도서 테이블에서 출판사별로 총 재고수량과 평균 재고 수량 계산하여 출력 (‘총 재고 수량’으로 내림차순 정렬)
SELECT pubNo, SUM(bookStock) AS "총 재고수량", ROUND(AVG(bookStock), 2) AS "평균 재고 수량" FROM book
GROUP BY pubNo ORDER BY "총 재고수량" DESC;

-- 5.도서판매 테이블에서 고객별로 ‘총 주문 수량’과 ‘총 주문 건수’ 출력. 단 주문 건수가 2이상인 고객만 해당
SELECT clientNo, SUM(bsQTY) AS "총 주문 수량", COUNT(*) AS "총 주문 건수" FROM bookSale
GROUP BY clientNo HAVING COUNT(*) >= 2;


-- JOIN 연습문제
-- 1.모든 도서에 대하여 도서의 도서번호, 도서명, 출판사명 출력
SELECT B.bookNo, B.bookName, P.pubName
FROM book B
INNER JOIN publisher P ON B.pubNo = P.pubNo
ORDER BY B.bookNo;

-- 2.'서울 출판사'에서 출간한 도서의 도서명, 저자명, 출판사명 출력 (출판사명 사용)
SELECT B.bookName, B.bookAuthor, P.pubName
FROM book B
INNER JOIN publisher P ON B.pubNo = P.pubNo
WHERE P.pubName = '서울 출판사'
ORDER BY B.bookNo;

-- 3.'정보출판사'에서 출간한 도서 중 판매된 도서의 도서명 출력 (중복된 경우 한 번만 출력) (출판사명 사용)
SELECT UNIQUE B.bookName
FROM book B
INNER JOIN bookSale BS ON B.bookNo = BS.bookNo
INNER JOIN publisher P ON B.pubNo = P.pubNo
WHERE P.pubName = '정보출판사';

-- 4.도서가격이 30,000원 이상인 도서를 주문한 고객의 고객명, 도서명, 도서가격, 주문수량 출력
SELECT C.clientName, B.bookName, B.bookPrice, BS.bsQTY
FROM bookSale BS
INNER JOIN client C ON C.clientNo = BS.clientNo
INNER JOIN book B ON B.bookNo = BS.bookNo
WHERE B.bookPrice >= 30000;

-- 5.'안드로이드 프로그래밍' 도서를 구매한 고객에 대하여 도서명, 고객명, 성별, 주소 출력 (고객명으로 오름차순 정렬)
SELECT B.bookName, C.clientName, C.clientGender, C.clientAddress
FROM bookSale BS
INNER JOIN client C ON C.clientNo = BS.clientNo
INNER JOIN book B ON B.bookNo = BS.bookNo
WHERE B.bookName = '안드로이드 프로그래밍'
ORDER BY C.clientName ASC;

-- 6.'도서출판 강남'에서 출간된 도서 중 판매된 도서에 대하여 '총 매출액' 출력
SELECT P.pubName, SUM(BS.bsQTY * B.bookPrice) AS "총 매출액"
FROM book B
INNER JOIN bookSale BS ON B.bookNo = BS.bookNo
INNER JOIN publisher P ON B.pubNo = P.pubNo
WHERE P.pubName = '도서출판 강남'
GROUP BY P.pubName;

-- 7.'서울 출판사'에서 출간된 도서에 대하여 판매일, 출판사명, 도서명, 도서가격, 주문수량, 주문액 출력
SELECT BS.bsDate, P.pubName, B.bookName, B.bookPrice, BS.bsQTY, BS.bsQTY * B.bookPrice AS "주문액"
FROM book B
INNER JOIN bookSale BS ON B.bookNo = BS.bookNo
INNER JOIN publisher P ON B.pubNo = P.pubNo
WHERE P.pubName = '서울 출판사';

-- 8.판매된 도서에 대하여 도서별로 도서번호, 도서명, 총 주문 수량 출력
SELECT B.bookNo, B.bookName, SUM(BS.bsQTY)
FROM book B
INNER JOIN bookSale BS ON B.bookNo = BS.bookNo
GROUP BY B.bookNo, B.bookName;

-- 9.판매된 도서에 대하여 고객별로 고객명, 총구매액 출력 ( 총구매액이 100,000원 이상인 경우만 해당)
SELECT C.clientName, SUM(BS.bsQTY * B.bookPrice) AS "총 구매액"
FROM bookSale BS
INNER JOIN client C ON C.clientNo = BS.clientNo
INNER JOIN book B ON B.bookNo = BS.bookNo
GROUP BY C.clientNo, C.clientName
HAVING SUM(BS.bsQTY * B.bookPrice) >= 100000;

-- 10.판매된 도서 중 '도서출판 강남'에서 출간한 도서에 대하여 고객명, 주문일, 도서명, 주문수량, 출판사명 출력 (고객명으로 오름차순 정렬)
SELECT C.clientName, BS.bsDate, B.bookName, BS.bsQTY, P.pubName
FROM book B
INNER JOIN bookSale BS ON B.bookNo = BS.bookNo
INNER JOIN client C ON C.clientNo = BS.clientNo
INNER JOIN publisher P ON B.pubNo = P.pubNo
WHERE P.pubName = '도서출판 강남'
ORDER BY C.clientName ASC;

