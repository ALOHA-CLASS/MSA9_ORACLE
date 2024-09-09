-- 72.
-- MS_BOARD 의 WRITER 속성을 NUMBER 타입으로 변경하고
-- MS_USER 의 USER_NO 를 참조하는 외래키로 지정하시오.

-- 1)
-- 데이터 타입 변경
-- ALTER TABLE 테이블명 MODIFY 컬럼명 데이터타입;
ALTER TABLE MS_BOARD MODIFY WRITER NUMBER;

-- 외래키 지정
-- ALTER TABLE 테이블명 ADD CONSTRAINT 제약조건명
-- FOREIGN KEY (외래키컬럼) REFERENCES 참조테이블(기본키);

-- MS_BOARD(WRITER) ----> MS_USER(USER_no)
ALTER TABLE MS_BOARD ADD CONSTRAINT MS_BOARD_WRITER_FK
FOREIGN KEY (WRITER) REFERENCES MS_USER(USER_NO);


-- 2) 외래키 지정 : MS_FILE ( BOARD_NO ) ----> MS_BOARD (BOARD_NO)
-- MS_FILE 테이블의 BOARD_NO 를 외래키로 지정하여, MS_BOARD 테이블의 BOARD_NO 를 참조하도록 지정
ALTER TABLE MS_FILE ADD CONSTRAINT MS_FILE_BOARD_NO_FK
FOREIGN KEY (BOARD_NO) REFERENCES MS_BOARD(BOARD_NO);


-- 3) 외래키 : MS_REPLY (BOARD_NO)  ---->  MS_BOARD (BOARD_NO)
ALTER TABLE MS_REPLY ADD CONSTRAINT MS_REPLY_BOARD_NO_FK
FOREIGN KEY (BOARD_NO) REFERENCES MS_BOARD(BOARD_NO);

-- 제약조건 삭제
-- ALTER TABLE 테이블명 DROP CONSTRAINT 제약조건명;
ALTER TABLE MS_BOARD DROP CONSTRAINT MS_BOARD_WRITER_FK;
ALTER TABLE MS_FILE DROP CONSTRAINT MS_FILE_BOARD_NO_FK;
ALTER TABLE MS_REPLY DROP CONSTRAINT MS_REPLY_BOARD_NO_FK;




-- 73.
-- MS_USER 테이블에 속성을 추가하시오.
DELETE FROM MS_USER;
ALTER TABLE MS_USER ADD CTZ_NO CHAR(14) NOT NULL UNIQUE;
ALTER TABLE MS_USER ADD GENDER CHAR(6) NOT NULL;

COMMENT ON COLUMN MS_USER.CTZ_NO IS '주민번호';
COMMENT ON COLUMN MS_USER.GENDER IS '성별';



-- 74.
-- MS_USER 의 GENDER 속성이 ('여', '남', '기타') 값만 갖도록
-- 제약조건을 추가하시오.
-- CHECK 제약조건 추가
ALTER TABLE MS_USER
ADD CONSTRAINT MS_USER_GENDER_CHECK
CHECK (GENDER IN ('여','남','기타'));



-- 75.
-- MS_FILE 테이블에 확장자(EXT) 속성을 추가하시오.
ALTER TABLE MS_FILE ADD EXT VARCHAR2(10) NULL;
COMMENT ON COLUMN MS_FILE.EXT IS '확장자';



-- 76.
-- 테이블 MS_FILE 의 FILE_NAME 속성에서 확장자를 추출하여 
-- EXT 속성에 UPDATE 하는 SQL 문을 작성하시오. 

 MERGE INTO MS_FILE T           -- 대상 테이블 지정
 -- 사용할 테이블 지정
 USING ( SELECT FILE_NO, FILE_NAME FROM MS_FILE ) F
 -- 매치조건
 ON (T.FILE_NO = F.FILE_NO)
 -- 매치 시 처리
 WHEN MATCHED THEN
    -- 이미지 파일 확장자를 추출하여 수정
    UPDATE SET T.EXT = SUBSTR( F.FILE_NAME, INSTR(F.FILE_NAME, '.', -1) + 1)
    -- 이미지 확장자(jpeg, jpg, gif, png, webp)가 아니면 삭제
    DELETE WHERE LOWER( SUBSTR( F.FILE_NAME, INSTR(F.FILE_NAME, '.', -1) + 1))
                 NOT IN ('jpeg', 'jpg', 'gif', 'png', 'webp')
    -- WHEN NOT MATCHED THEN
;

SELECT * FROM MS_FILE;
DELETE FROM MS_USER;
DELETE FROM MS_BOARD;
DELETE FROM MS_FILE;


-- 파일 추가
INSERT INTO MS_FILE ( 
            FILE_NO, BOARD_NO, FILE_NAME, FILE_DATA, REG_DATE, UPD_DATE, EXT
            )
VALUES (1, 1, '강아지.png', '123', sysdate, sysdate, 'jpg' );


INSERT INTO MS_FILE ( 
            FILE_NO, BOARD_NO, FILE_NAME, FILE_DATA, REG_DATE, UPD_DATE, EXT
            )
VALUES (2, 1, 'main.html', '123', sysdate, sysdate, 'jpg' );



-- 게시글 추가
INSERT INTO MS_BOARD (
                BOARD_NO, TITLE, CONTENT, WRITER, HIT, LIKE_CNT,
                DEL_YN, DEL_DATE, REG_DATE, UPD_DATE
                )
VALUES (
        1, '제목', '내용', 1, 0, 0, 'N', NULL, sysdate, sysdate
        );


-- 유저 추가
INSERT INTO MS_USER(
                USER_NO, USER_ID, USER_PW, USER_NAME, BIRTH,
                TEL, ADDRESS, REG_DATE, UPD_DATE,
                CTZ_NO, GENDER
                )
VALUES ( 1, 'ALOHA', '123456', '김조은', TO_DATE('2003/01/01', 'YYYY/MM/DD'),
         '010-1234-1234', '부평', sysdate, sysdate,
         '030101-3334444', '기타');



-- 77.
-- 테이블 MS_FILE 의 EXT 속성이
-- ('jpg', 'jpeg', 'gif', 'png', 'webp') 값을 갖도록 하는 제약조건을 추가하시오.
ALTER Table MS_FILE
ADD CONSTRAINT MS_FILE_EXT_CHECK
CHECK ( EXT IN ('jpg', 'jpeg', 'gif', 'png', 'webp') );

-- 제약조건 삭제
ALTER TABLE MS_FILE
DROP CONSTRAINT MS_FILE_EXT_CHECK;

SELECT * FROM MS_FILE;
INSERT INTO MS_FILE 
(file_no, board_no, file_name, file_data, REG_DATE, UPD_DATE, ext)
VALUES (3, 1, '고양이.webp', '123', '2024/09/05', '2024/09/05', 'webp');




-- 78.
-- MS_USER, MS_BOARD, MS_FILE, MS_REPLY 테이블의
-- 모든 데이터를 삭제하는 명령어를 작성하시오.

-- DDL - TRUNCATE
TRUNCATE TABLE MS_USER;
TRUNCATE TABLE MS_BOARD;
TRUNCATE TABLE MS_FILE;
TRUNCATE TABLE MS_REPLY;

-- DML - DELETE
DELETE FROM MS_USER;
DELETE FROM MS_BOARD;
DELETE FROM MS_FILE;
DELETE FROM MS_REPLY;




-- DELETE vs TRUNCATE
-- * DELETE - 데이터 조작어(DML)
-- - 한 행 단위로 데이터를 삭제한다.
-- - WHERE 조건절을 기준으로 일부 삭제 가능.
-- - COMMIT, ROLLBACK 을 이용하여 변경사항을 
--   적용하거나 되돌릴 수 있음.

-- * TRUNCATE - 데이터 정의어(DDL)
-- - 모든 행을 삭제한다.
-- - 삭제된 데이터를 되돌릴 수 없음




-- 79.
-- 테이블의 속성을 삭제하시오.
-- * MS_BOARD 테이블의 WRITER 속성
-- * MS_FILE 테이블의 BOARD_NO 속성
-- * MS_REPLY 테이블의 BOARD_NO 속성

ALTER TABLE MS_BOARD DROP COLUMN WRITER;
ALTER TABLE MS_FILE DROP COLUMN BOARD_NO;
ALTER TABLE MS_REPLY DROP COLUMN BOARD_NO;

-- 80.
-- 각 테이블에 속성들을 추가한 뒤, 외래키로 지정하시오.
-- 해당 외래키에 대하여 참조 테이블의 데이터 삭제 시,
-- 연결된 속성의 값도 삭제하는 옵션도 지정하시오.

-- 1)
-- MS_BOARD 에 WRITER 속성 추가
ALTER TABLE MS_BOARD ADD WRITER NUMBER NOT NULL;

-- WRITER 속성을 외래키로 지정
-- + 참조 테이블 데이터 삭제 시, 연쇄적으로 함께 삭제하는 옵션 지정
ALTER TABLE MS_BOARD
ADD CONSTRAINT MS_BOARD_WRITER_FK
FOREIGN KEY(WRITER) REFERENCES MS_USER(USER_NO)
    ON DELETE CASCADE
;
-- ** 외래키가 참조하는 참조컬럼의 데이터 삭제 시, 동작할 옵션 지정
-- ON DELETE [NO ACTION, RESTRICT, CASCADE, SET NULL]
-- * NO ACTION      :   아무 행위도 안 함.
-- * RESTRICT       :   자식 테이블의 데이터가 존재하면, 삭제 안 함.
-- * CASCADE        :   자식 테이블의 데이터도 함께 삭제 
-- * SET NULL       :   자식 테이블의 데이터를 NULL 로 지정


-- 2)
-- MS_FILE 에 BOARD_NO 속성 추가
-- BOARD_NO 속성을 외래키로 추가
-- 참조테이블 : MS_BOARD, 참조 속성 : BOARD_NO
-- + 참조 테이블 데이터 삭제 시, 연쇄적으로 함께 삭제하는 옵션 지정
ALTER TABLE MS_FILE ADD BOARD_NO NUMBER NOT NULL;
ALTER TABLE MS_FILE
ADD CONSTRAINT MS_FILE_BOARD_NO_FK
FOREIGN KEY (BOARD_NO) REFERENCES MS_BOARD(BOARD_NO)
    ON DELETE CASCADE;


-- 3)
-- MS_REPLY 에 BOARD_NO 속성 추가
-- BOARD_NO 속성을 외래키로 추가
-- 참조테이블 : MS_BOARD, 참조 속성 : BOARD_NO
-- + 참조 테이블 데이터 삭제 시, 연쇄적으로 함께 삭제하는 옵션 지정
ALTER TABLE MS_REPLY ADD BOARD_NO NUMBER NOT NULL;
ALTER TABLE MS_REPLY
ADD CONSTRAINT MS_REPLY_BOARD_NO_FK
FOREIGN KEY (BOARD_NO) REFERENCES MS_BOARD(BOARD_NO)
    ON DELETE CASCADE;


-- 유저 추가
INSERT INTO MS_USER(
                USER_NO, USER_ID, USER_PW, USER_NAME, BIRTH,
                TEL, ADDRESS, REG_DATE, UPD_DATE,
                CTZ_NO, GENDER
                )
VALUES ( 1, 'ALOHA', '123456', '김조은', TO_DATE('2003/01/01', 'YYYY/MM/DD'),
         '010-1234-1234', '부평', sysdate, sysdate,
         '030101-3334444', '기타');

-- 게시글 추가
INSERT INTO MS_BOARD (
                BOARD_NO, TITLE, CONTENT, WRITER, HIT, LIKE_CNT,
                DEL_YN, DEL_DATE, REG_DATE, UPD_DATE
                )
VALUES (
        1, '제목', '내용', 1, 0, 0, 'N', NULL, sysdate, sysdate
        );


-- 댓글 추가
INSERT INTO MS_REPLY ( REPLY_NO,  CONTENT, WRITER, DEL_YN, REG_DATE, UPD_DATE, BOARD_NO )
VALUES (1, '댓글내용', '김조은', 'N', '2024/09/05', '2024/09/05', 1);

-- 파일 추가
INSERT INTO MS_FILE ( 
            FILE_NO, BOARD_NO, FILE_NAME, FILE_DATA, REG_DATE, UPD_DATE, EXT
            )
VALUES (1, 1, '강아지.png', '123', sysdate, sysdate, 'jpg' );


INSERT INTO MS_FILE ( 
            FILE_NO, BOARD_NO, FILE_NAME, FILE_DATA, REG_DATE, UPD_DATE, EXT
            )
VALUES (2, 1, 'main.html', '123', sysdate, sysdate, 'jpg' );



SELECT * FROM MS_USER;
SELECT * FROM MS_BOARD;
SELECT * FROM MS_FILE;
SELECT * FROM MS_REPLY;

DELETE FROM MS_USER WHERE USER_NO = 1;


-- 외래키 제약 조건
ALTER TABLE 테이블명
ADD CONSTRAINT 제약조건명 FOREIGN KEY (외래키 속성)
REFERENCES 참조테이블(참조 속성)
ON UPDATE [NO ACTION, RESTRICT, CASCADE, SET NULL]
ON DELETE [NO ACTION, RESTRICT, CASCADE, SET NULL]
;

-- 옵션
-- ON UPDATE            -- 참조 테이블 수정 시,
--  * CASCADE           : 자식 데이터 수정
--  * SET NULL          : 자식 데이터는 NULL 
--  * SET DEFAULT       : 자식 데이터는 기본값
--  * RESTRICT          : 자식 테이블의 참조하는 데이터가 존재하면, 부모 데이터 수정 불가
--  * NO ACTION         : 아무런 행위도 취하지 않는다 (기본값)

-- ON DELETE            -- 참조 테이블 삭제 시,
--  * CASCADE           : 자식 데이터 삭제
--  * SET NULL          : 자식 데이터는 NULL 
--  * SET DEFAULT       : 자식 데이터는 기본값
--  * RESTRICT          : 자식 테이블의 참조하는 데이터가 존재하면, 부모 데이터 삭제 불가
--  * NO ACTION         : 아무런 행위도 취하지 않는다 (기본값)




-- 81.
-- EMPLOYEE, DEPARTMENT, JOB 테이블을 사용하여
-- 스칼라 서브쿼리로 출력결과와 같이 조회하시오.

SELECT * FROM EMPLOYEE;
SELECT * FROM DEPARTMENT;
SELECT * FROM JOB;



-- 스칼라 서브쿼리
-- 사원번호, 직원명, 부서명, 직급명
SELECT e.EMP_ID 사원번호
      ,e.EMP_NAME 직원명
      ,(SELECT DEPT_TITLE FROM DEPARTMENT d WHERE e.DEPT_CODE = d.DEPT_ID) 부서명
      ,(SELECT JOB_NAME FROM JOB j WHERE e.JOB_CODE = j.JOB_CODE) 직급명
FROM EMPLOYEE e
;



-- 82.
-- 출력결과를 참고하여,
-- 인라인 뷰를 이용해 부서별로 최고급여를 받는 직원을 조회하시오.

-- 1. 부서별로 최고급여를 조회 
SELECT DEPT_CODE 부서코드
      ,MAX(SALARY) 최고급여
      ,MIN(SALARY) 최저급여
      ,AVG(SALARY) 평균급여
FROM EMPLOYEE
GROUP BY DEPT_CODE
;


-- 2. 부서별 최고급여 조회결과를 서브쿼리(인라인 뷰)
SELECT EMP_ID 사원번호
      ,EMP_NAME 직원명
      ,DEPT_TITLE 부서명
      ,SALARY 급여
      ,t.MAX_SAL 최고급여
      ,t.MIN_SAL 최저급여
      ,ROUND(t.AVG_SAL, 2) 평균급여
FROM EMPLOYEE e, DEPARTMENT d
    ,(
      SELECT DEPT_CODE 부서코드
      ,MAX(SALARY) MAX_SAL
      ,MIN(SALARY) MIN_SAL
      ,AVG(SALARY) AVG_SAL
      FROM EMPLOYEE
      GROUP BY DEPT_CODE
    ) t
WHERE e.DEPT_CODE = d.DEPT_ID
  AND e.SALARY = t.MAX_SAL
;



-- 83.
-- 서브쿼리를 이용하여,
-- 직원명이 '이태림' 인 사원과 같은 부서의 직원들을 조회하시오.

SELECT EMP_ID 사원번호
      ,EMP_NAME 직원명
      ,(SELECT DEPT_TITLE FROM DEPARTMENT d WHERE d.DEPT_ID = e.DEPT_CODE) 부서명
      ,EMAIL 이메일
      ,PHONE 전화번호
FROM EMPLOYEE e
WHERE DEPT_CODE = (
                    SELECT DEPT_CODE
                    FROM EMPLOYEE
                    WHERE EMP_NAME = '이태림'
                  )
;



-- 84.
-- 사원 테이블에 존재하는 부서코드만 포함하는 부서를 조회하시오.
-- (사원이 존재하는 부서만 조회하시오.)

-- 1) 서브쿼리 
SELECT DEPT_ID 부서번호
      ,DEPT_TITLE 부서명
      ,LOCATION_ID 지역명
FROM DEPARTMENT
WHERE DEPT_ID IN (
                    SELECT DISTINCT DEPT_CODE
                    FROM EMPLOYEE
                    WHERE DEPT_CODE IS NOT NULL
                )
ORDER BY 부서번호 ASC
;

-- 2) EXISTS
SELECT DEPT_ID 부서번호
      ,DEPT_TITLE 부서명
      ,LOCATION_ID 지역명
FROM DEPARTMENT d
WHERE EXISTS (
                SELECT *
                FROM EMPLOYEE e
                WHERE d.DEPT_ID = e.DEPT_CODE
             )
ORDER BY 부서번호 ASC
;

-- 사원이 존재하는 부서 : D1,D2,D5,D6,D8,D9


-- 85.
-- 사원 테이블에 존재하지 않는 부서코드만 포함하는 부서를 조회하시오.
-- (사원이 존재하지 않는 부서만 조회하시오.)

-- 사원이 있는 부서 : D1, D2, D5, D6, D8, D9
-- 사원이 없는 부서 : D3, D4, D7 


-- 1) 서브쿼리 
SELECT DEPT_ID 부서번호
      ,DEPT_TITLE 부서명
      ,LOCATION_ID 지역명
FROM DEPARTMENT
WHERE DEPT_ID NOT IN (
                    SELECT DISTINCT DEPT_CODE
                    FROM EMPLOYEE
                    WHERE DEPT_CODE IS NOT NULL
                )
ORDER BY 부서번호 ASC
;

-- 2) EXISTS
SELECT DEPT_ID 부서번호
      ,DEPT_TITLE 부서명
      ,LOCATION_ID 지역명
FROM DEPARTMENT d
WHERE NOT EXISTS (
                SELECT *
                FROM EMPLOYEE e
                WHERE d.DEPT_ID = e.DEPT_CODE
             )
ORDER BY 부서번호 ASC
;




-- 86.
-- EMPLOYEE 테이블의 DEPT_CODE 가 'D1' 인 부서의 최대급여 보다
-- 더 큰 급여를 받는 사원을 조회하시오.

-- 1. 최대급여를 구하여 비교
-- 1) 부서코드가 'D1'인 사원의 최대급여
SELECT MAX(salary)
FROM EMPLOYEE
WHERE DEPT_CODE = 'D1'
;

-- 2) 급여가 D1 최대급여보다 큰 사원 조회
SELECT e.EMP_ID 사원번호
      ,e.EMP_NAME 직원명
      ,d.DEPT_ID 부서번호
      ,d.DEPT_TITLE 부서명
      ,e.SALARY 급여
FROM EMPLOYEE e, DEPARTMENT d
WHERE e.DEPT_CODE = d.DEPT_ID
  AND e.SALARY > 3660000
;

-- 3) 3660000 자리에 1)번 쿼리 대입
SELECT e.EMP_ID 사원번호
      ,e.EMP_NAME 직원명
      ,d.DEPT_ID 부서번호
      ,d.DEPT_TITLE 부서명
      ,e.SALARY 급여
FROM EMPLOYEE e, DEPARTMENT d
WHERE e.DEPT_CODE = d.DEPT_ID
  AND e.SALARY > (
                    SELECT MAX(salary)
                    FROM EMPLOYEE
                    WHERE DEPT_CODE = 'D1'
                )
;


-- 2. ALL 연산으로 구하기
SELECT e.EMP_ID 사원번호
      ,e.EMP_NAME 직원명
      ,d.DEPT_ID 부서번호
      ,d.DEPT_TITLE 부서명
      ,e.SALARY 급여
FROM EMPLOYEE e, DEPARTMENT d
WHERE e.DEPT_CODE = d.DEPT_ID
  AND e.SALARY > ALL (
                    SELECT salary
                    FROM EMPLOYEE
                    WHERE DEPT_CODE = 'D1'
                )
;




-- 87.
-- EMPLOYEE 테이블의 DEPT_CODE 가 'D9' 인 부서의 최저급여 보다
-- 더 큰 급여를 받는 사원을 조회하시오.

-- 1. 최저급여를 구하여 비교
-- 1) 부서코드가 'D9'인 사원들 중 최저급여
SELECT MIN(salary)
FROM EMPLOYEE
WHERE DEPT_CODE = 'D9'
;

-- 2) 급여 > 최저급여
SELECT e.EMP_ID 사원번호
      ,e.EMP_NAME 직원명
      ,d.DEPT_ID 부서번호
      ,d.DEPT_TITLE 부서명
      ,e.SALARY 급여
FROM EMPLOYEE e, DEPARTMENT d
WHERE e.DEPT_CODE = d.DEPT_ID
  AND e.SALARY > (
                    SELECT MIN(salary)
                    FROM EMPLOYEE
                    WHERE DEPT_CODE = 'D9'
                 )
;


-- 2. ANY 연산으로 구하기
SELECT e.EMP_ID 사원번호
      ,e.EMP_NAME 직원명
      ,d.DEPT_ID 부서번호
      ,d.DEPT_TITLE 부서명
      ,e.SALARY 급여
FROM EMPLOYEE e, DEPARTMENT d
WHERE e.DEPT_CODE = d.DEPT_ID
  AND e.SALARY > ANY (
                        SELECT salary
                        FROM EMPLOYEE
                        WHERE DEPT_CODE = 'D9'
                    )
;






-- 88.
-- EMPLOYEE 와 DEPARTMENT 테이블을 조인하여 출력하되,
-- 부서가 없는 직원도 포함하여 출력하시오.

-- 사원번호, 직원명, 부서번호, 부서명

SELECT e.EMP_ID 사원번호
      ,e.EMP_NAME 직원명
      ,NVL(d.DEPT_ID, '(없음)') 부서번호
      ,NVL(d.DEPT_TITLE, '(없음)') 부서명
FROM EMPLOYEE e 
      LEFT JOIN DEPARTMENT d
      ON (e.DEPT_CODE = d.DEPT_ID)
;


-- 89.
-- EMPLOYEE 와 DEPARTMENT 테이블을 조인하여 출력하되,
-- 직원이 없는 부서도 포함하여 출력하시오.

SELECT NVL(e.EMP_ID, '(없음)') 사원번호
      ,NVL(e.EMP_NAME, '(없음)') 직원명
      ,d.DEPT_ID 부서번호
      ,d.DEPT_TITLE 부서명
FROM EMPLOYEE e
      RIGHT JOIN DEPARTMENT d
      ON (e.DEPT_CODE = d.DEPT_ID)
;


--90.
-- 직원 및 부서 유무에 상관없이 출력하는 SQL문을 작성하시오.
SELECT NVL(e.EMP_ID, '(없음)') 사원번호
      ,NVL(e.EMP_NAME, '(없음)') 직원명
      ,NVL(d.DEPT_ID, '(없음)') 부서번호
      ,NVL(d.DEPT_TITLE, '(없음)') 부서명
FROM EMPLOYEE e
      FULL JOIN DEPARTMENT d
      ON (e.DEPT_CODE = d.DEPT_ID)
;

-- 91.
-- 사원번호, 직원명, 부서번호, 지역명, 국가명, 급여, 입사일자를 출력하시오.

SELECT * FROM EMPLOYEE;
SELECT * FROM DEPARTMENT;
SELECT * FROM LOCATION;
SELECT * FROM NATIONAL;


SELECT E.EMP_ID 사원번호
      ,E.EMP_NAME 직원명
      ,D.DEPT_ID 부서번호
      ,D.DEPT_TITLE 부서명
      ,L.LOCAL_NAME 지역명
      ,N.NATIONAL_NAME 국가명
      ,E.SALARY 급여
FROM EMPLOYEE E
      ,E.HIRE_DATE 입사일자
     LEFT JOIN DEPARTMENT D ON E.DEPT_CODE = D.DEPT_ID 
     LEFT JOIN LOCATION L ON D.LOCATION_ID = L.LOCAL_CODE
     LEFT JOIN NATIONAL N ON L.NATIONAL_CODE = N.NATIONAL_CODE
;


-- 92.
-- 사원들 중 매니저를 출력하시오.
-- 사원번호, 직원명, 부서명, 직급, 구분('매니저')
-- * MANAGER_ID : 해당 사원의 매니저 사원번호

SELECT * FROM EMPLOYEE;

-- 1.
-- MANAGER_ID 컬럼이 NULL 아닌 사원을 중복없이 조회
-- ➡ 매니저들의 사원 번호
SELECT DISTINCT MANAGER_ID
FROM EMPLOYEE
WHERE MANAGER_ID IS NOT NULL;

-- 2.
-- EMPLOYEE, DEPARTMENT, JOB 테이블 조인하여 조회
SELECT *
FROM EMPLOYEE E
      LEFT JOIN DEPARTMENT D ON E.DEPT_CODE = D.DEPT_ID
      JOIN JOB J ON E.JOB_CODE = J.JOB_CODE
;

-- 3.
-- 조인 결과 중, EMP_ID 가 매니저 사원번호인 경우만 조회
SELECT E.EMP_ID 사원번호
      ,E.EMP_NAME 직원명
      ,D.DEPT_TITLE 부서명
      ,JOB_NAME 직급명
      ,'매니저' 구분
FROM EMPLOYEE E
      LEFT JOIN DEPARTMENT D ON E.DEPT_CODE = D.DEPT_ID
      JOIN JOB J ON E.JOB_CODE = J.JOB_CODE
WHERE E.EMP_ID IN (
                        SELECT DISTINCT MANAGER_ID
                        FROM EMPLOYEE
                        WHERE MANAGER_ID IS NOT NULL       
                  )                       
;



-- 93.
-- 사원(매니저가 아닌)만 조회하시오.

SELECT E.EMP_ID 사원번호
      ,E.EMP_NAME 직원명
      ,D.DEPT_TITLE 부서명
      ,JOB_NAME 직급명
      ,'사원' 구분
FROM EMPLOYEE E
      LEFT JOIN DEPARTMENT D ON E.DEPT_CODE = D.DEPT_ID
      JOIN JOB J ON E.JOB_CODE = J.JOB_CODE
WHERE E.EMP_ID NOT IN (
                        SELECT DISTINCT MANAGER_ID
                        FROM EMPLOYEE
                        WHERE MANAGER_ID IS NOT NULL       
                  )                       
;


-- 94.
-- UNION 키워드를 사용하여,
-- 매니저와 사원 구분하여 조회하시오.


SELECT E.EMP_ID 사원번호
      ,E.EMP_NAME 직원명
      ,D.DEPT_TITLE 부서명
      ,JOB_NAME 직급명
      ,'매니저' 구분
FROM EMPLOYEE E
      LEFT JOIN DEPARTMENT D ON E.DEPT_CODE = D.DEPT_ID
      JOIN JOB J ON E.JOB_CODE = J.JOB_CODE
WHERE E.EMP_ID IN (
                        SELECT DISTINCT MANAGER_ID
                        FROM EMPLOYEE
                        WHERE MANAGER_ID IS NOT NULL       
                  )  
UNION
SELECT E.EMP_ID 사원번호
      ,E.EMP_NAME 직원명
      ,D.DEPT_TITLE 부서명
      ,JOB_NAME 직급명
      ,'사원' 구분
FROM EMPLOYEE E
      LEFT JOIN DEPARTMENT D ON E.DEPT_CODE = D.DEPT_ID
      JOIN JOB J ON E.JOB_CODE = J.JOB_CODE
WHERE E.EMP_ID NOT IN (
                        SELECT DISTINCT MANAGER_ID
                        FROM EMPLOYEE
                        WHERE MANAGER_ID IS NOT NULL       
                  )
;

-- 95.
-- CASE 키워드를 사용하여,
-- 매니저와 사원을 구분하여 출력하시오


SELECT E.EMP_ID 사원번호
      ,E.EMP_NAME 직원명
      ,D.DEPT_TITLE 부서명
      ,J.JOB_NAME 직급명
      ,CASE
            WHEN EMP_ID IN (
                              SELECT DISTINCT MANAGER_ID
                              FROM EMPLOYEE
                              WHERE MANAGER_ID IS NOT NULL
                           )
            THEN '매니저'
            ELSE '사원'
      END 구분
FROM EMPLOYEE E
      LEFT JOIN DEPARTMENT D ON E.DEPT_CODE = D.DEPT_ID
      JOIN JOB J ON E.JOB_CODE = J.JOB_CODE
;




-- 96.
-- EMPLOYEE, DEPARTMENT, JOB 테이블을 조인하여 조회하시오
-- 사원의 나이와 성별을 구하여 출력하고,
-- 주민등록번호 뒷자리 첫글자를 제외하고 마스킹하여 출력하시오.

-- 사원번호, 직원명, 부서명, 직급, 구분
SELECT E.EMP_ID 사원번호
      ,E.EMP_NAME 직원명
      ,D.DEPT_TITLE 부서명
      ,J.JOB_NAME 직급명
      ,CASE
            WHEN EMP_ID IN (
                              SELECT DISTINCT MANAGER_ID
                              FROM EMPLOYEE
                              WHERE MANAGER_ID IS NOT NULL
                           )
            THEN '매니저'
            ELSE '사원'
      END 구분
      -- 성별
      -- * 주민등록번호 (EMP_NO) 뒷자리 첫글자
      --   1,3 (남자), 2,4 (여자)
      ,
      CASE
            WHEN SUBSTR(EMP_NO, 8, 1) IN ('1','3') THEN '남자'
            WHEN SUBSTR(EMP_NO, 8, 1) IN ('2','4') THEN '여자'
      END 성별
      ,
      -- 나이
      -- 1900년대 출생 (주민번호 뒷자리 첫글자 1,2)
      -- 2000년대 출생 (주민번호 뒷자리 첫글자 3,4)
      TRUNC(
            MONTHS_BETWEEN(
                  SYSDATE,
                  TO_DATE(
                        CASE 
                              WHEN SUBSTR(EMP_NO, 8, 1) IN ('1','2') THEN  '19'
                              WHEN SUBSTR(EMP_NO, 8, 1) IN ('3','4') THEN  '20'
                        END || SUBSTR(EMP_NO, 1, 2) || '0101'
                        ,
                        'YYYYMMDD'
                  )
            ) / 12
      ) + 1 나이
      ,
      RPAD( SUBSTR(EMP_NO, 1, 8), 14, '*') 주민등록번호
FROM EMPLOYEE E
     LEFT JOIN DEPARTMENT D ON E.DEPT_CODE = D.DEPT_ID
     JOIN JOB J USING (JOB_CODE)
;


-- 97.
-- 96번 조회결과에 
-- 순번, 만나이, 근속연수, 입사일자, 연봉을 추가하시오.

SELECT ROWNUM 순번
      ,E.EMP_ID 사원번호
      ,E.EMP_NAME 직원명
      ,D.DEPT_TITLE 부서명
      ,J.JOB_NAME 직급명
      ,CASE
            WHEN EMP_ID IN (
                              SELECT DISTINCT MANAGER_ID
                              FROM EMPLOYEE
                              WHERE MANAGER_ID IS NOT NULL
                           )
            THEN '매니저'
            ELSE '사원'
      END 구분
      -- 성별
      -- * 주민등록번호 (EMP_NO) 뒷자리 첫글자
      --   1,3 (남자), 2,4 (여자)
      ,
      CASE
            WHEN SUBSTR(EMP_NO, 8, 1) IN ('1','3') THEN '남자'
            WHEN SUBSTR(EMP_NO, 8, 1) IN ('2','4') THEN '여자'
      END 성별
      ,
      -- 나이
      -- 1900년대 출생 (주민번호 뒷자리 첫글자 1,2)
      -- 2000년대 출생 (주민번호 뒷자리 첫글자 3,4)
      TRUNC(
            MONTHS_BETWEEN(
                  SYSDATE,
                  TO_DATE(
                        CASE 
                              WHEN SUBSTR(EMP_NO, 8, 1) IN ('1','2') THEN  '19'
                              WHEN SUBSTR(EMP_NO, 8, 1) IN ('3','4') THEN  '20'
                        END || SUBSTR(EMP_NO, 1, 2) || '0101'
                        ,
                        'YYYYMMDD'
                  )
            ) / 12
      ) + 1 나이
      ,
      TRUNC(
            MONTHS_BETWEEN(
                  SYSDATE,
                  TO_DATE(
                        CASE 
                              WHEN SUBSTR(EMP_NO, 8, 1) IN ('1','2') THEN  '19'
                              WHEN SUBSTR(EMP_NO, 8, 1) IN ('3','4') THEN  '20'
                        END || SUBSTR(EMP_NO, 1, 6)
                        ,
                        'YYYYMMDD'
                  )
            ) / 12
      ) 만나이
      ,
      TRUNC(
            MONTHS_BETWEEN(
                  SYSDATE,
                  HIRE_DATE
            ) / 12 
      ) 근속연수
      ,
      RPAD( SUBSTR(EMP_NO, 1, 8), 14, '*') 주민등록번호
      ,
      TO_CHAR(HIRE_DATE, 'YYYY.MM.DD') 입사일자
      -- 연봉 = (급여 + (급여*보너스)) * 12
      ,
      TO_CHAR(
            ( SALARY + ( SALARY * NVL(BONUS, 0) ) ) * 12
            ,
            '999,999,999,999'
      ) 연봉
FROM EMPLOYEE E
     LEFT JOIN DEPARTMENT D ON E.DEPT_CODE = D.DEPT_ID
     JOIN JOB J USING (JOB_CODE)
;


-- 98.
-- employee, department 테이블을 조인하여,
-- 사원번호, 직원명, 부서번호, 부서명, 이메일, 전화번호
-- 주민번호, 입사일자, 급여, 연봉을 조회하시오.
-- CREATE OR REPLACE 객체
-- - 없으면, 새로 생성
-- - 있으면, 대체 (기존에 생성 되어 있어도 에러발생X)
CREATE OR REPLACE VIEW VE_EMP_DEPT AS
SELECT e.emp_id
      ,e.emp_name
      ,d.dept_id
      ,d.dept_title
      ,e.email
      ,e.phone
      -- 주민등록번호
      ,RPAD( SUBSTR(emp_no, 1, 8), 14, '*' ) emp_no
      -- 입사일자
      ,TO_CHAR( hire_date, 'YYYY.MM.DD' ) hire_date
      -- 급여
      ,TO_CHAR( salary, '999,999,999' ) salary
      -- 연봉
      ,TO_CHAR( (salary + NVL( salary*bonus, 0)) * 12, '999,999,999,999') yr_salary
FROM employee e
     LEFT JOIN department d ON (e.dept_code = d.dept_id)
;


-- 뷰 조회
SELECT *
FROM VE_EMP_DEPT
;



-- 99.
-- 시퀀스를 생성하시오.
-- SEQ_MS_USER
-- SEQ_MS_BOARD
-- SEQ_MS_FILE
-- SEQ_MS_REPLY
-- (시작: 1, 증가값: 1, 최솟값: 1, 최댓값: 1000000)
-- 시퀀스 생성
CREATE SEQUENCE SEQ_MS_USER
INCREMENT BY 1                -- 증가값
START WITH 1                  -- 시작값
MINVALUE 1                    -- 최솟값
MAXVALUE 1000000;             -- 최댓값

CREATE SEQUENCE SEQ_MS_BOARD
INCREMENT BY 1                -- 증가값
START WITH 1                  -- 시작값
MINVALUE 1                    -- 최솟값
MAXVALUE 1000000;             -- 최댓값

CREATE SEQUENCE SEQ_MS_FILE
INCREMENT BY 1                -- 증가값
START WITH 1                  -- 시작값
MINVALUE 1                    -- 최솟값
MAXVALUE 1000000;             -- 최댓값

CREATE SEQUENCE SEQ_MS_REPLY
INCREMENT BY 1                -- 증가값
START WITH 1                  -- 시작값
MINVALUE 1                    -- 최솟값
MAXVALUE 1000000;             -- 최댓값


-- 100.
-- SEQ_MS_USER 의 다음 번화와 현재 번호를 출력하시오.

-- 다음 시퀀스 번호
SELECT SEQ_MS_USER.NEXTVAL FROM DUAL;

-- 현재 시퀀스 번호
SELECT SEQ_MS_USER.CURRVAL FROM DUAL;




-- 101.
-- SEQ_MS_USER 를 삭제하시오.
DROP SEQUENCE SEQ_MS_USER;



-- 102.
-- SEQ_MS_USER 를 이용하여, MS_USER 의 user_no 가
-- 시퀀스 번호로 적용될 수 있도록 데이터를 추가해보시오.

INSERT INTO MS_USER ( USER_NO, USER_ID, USER_PW, USER_NAME,
                      BIRTH, TEL, ADDRESS, REG_DATE, UPD_DATE, CTZ_NO, GENDER
                      )
VALUES (
      SEQ_MS_USER.NEXTVAL, 'ALOHA', '123456', '김조은',
      '2024/03/06', '010-1234-1234', '인천 부평구', SYSDATE, SYSDATE,
      '020101-4123123', '여'
);

INSERT INTO MS_USER ( USER_NO, USER_ID, USER_PW, USER_NAME,
                      BIRTH, TEL, ADDRESS, REG_DATE, UPD_DATE, CTZ_NO, GENDER
                      )
VALUES (
      SEQ_MS_USER.NEXTVAL, 'JOEUN', '123456', '박조은',
      '2024/03/06', '010-1234-1234', '서울 구로구', SYSDATE, SYSDATE,
      '970101-4123123', '여'
);

SELECT * FROM MS_USER;


-- 103.
-- 시퀀스 SEQ_MS_USER 의 최댓값을 100,000,000 으로 수정하시오.

ALTER SEQUENCE SEQ_MS_USER MAXVALUE 100000000;


-- 104.
-- USER_IND_COLUMNS 테이블을 조회하시오.
-- * 사용자가 정의한 인덱스 정보가 들어있다.
SELECT INDEX_NAME, TABLE_NAME, COLUMN_NAME
FROM USER_IND_COLUMNS;


-- 105.
-- MS_USER 테이블의 USER_NAME 에 대한
-- 인덱스 IDX_MS_USER_NAME 을 생성하시오.

-- 인덱스 생성
CREATE INDEX IDX_MS_USER_NAME ON MS_USER(USER_NAME);

-- 인덱스 삭제
DROP INDEX IDX_MS_USER_NAME;




-- 그룹 관련 함수

-- ROLLUP 미사용
SELECT dept_code, job_code
      ,COUNT(*), MAX(salary), SUM(salary), TRUNC( AVG(salary), 2)
FROM employee
GROUP BY dept_code, job_code
ORDER BY dept_code, job_code
;


-- ROLLUP 사용
SELECT dept_code, job_code
      ,COUNT(*), MAX(salary), SUM(salary), TRUNC( AVG(salary), 2)
FROM employee
WHERE dept_code IS NOT NULL
  AND job_code IS NOT NULL
GROUP BY ROLLUP(dept_code, job_code)
ORDER BY dept_code, job_code
;



-- CUBE
SELECT dept_code, job_code
      ,COUNT(*), MAX(salary), SUM(salary), TRUNC( AVG(salary), 2)
FROM employee
WHERE dept_code IS NOT NULL
  AND job_code IS NOT NULL
GROUP BY CUBE(dept_code, job_code)
ORDER BY dept_code, job_code
;


-- GROUPING SETS
SELECT dept_code, job_code, COUNT(*)
FROM employee
GROUP BY GROUPING SETS( (dept_code), (job_code) )
ORDER BY dept_code, job_code
;


-- GROUPING
SELECT dept_code
      , job_code
      , COUNT(*)
      , MAX(salary)
      , SUM(salary)
      , TRUNC( AVG(salary), 2)
      , GROUPING(dept_code) "부서코드 그룹여부"
      , GROUPING(job_code) "직급코드 그룹여부"
FROM employee
WHERE dept_code IS NOT NULL
  AND job_code IS NOT NULL
GROUP BY CUBE(dept_code, job_code)
ORDER BY dept_code, job_code
;




-- LISTAGG
SELECT dept_code 부서코드
      ,LISTAGG( emp_name, ', ')
       WITHIN GROUP(ORDER BY emp_name) "부서별 사원이름목록"
FROM employee
GROUP BY dept_code
ORDER BY dept_code
;


-- PIVOT
SELECT *
FROM (
        SELECT dept_code, job_code, salary
        FROM employee
     )
     PIVOT (
        MAX(salary)
        -- 열에 올릴 컬럼들
        FOR dept_code IN ('D1','D2','D3','D4','D5','D6','D7','D8','D9')
        /*
            SELECT LISTAGG(dept_id, ',')
            FROM department
        */
     )
ORDER BY job_code;



-- PIVOT 전 데이터
SELECT dept_code, job_code, salary
FROM employee;



-- UNPIVOT
SELECT *
FROM (
        SELECT dept_code
              ,MAX( DECODE(job_code, 'J1', salary ) ) J1 
              ,MAX( DECODE(job_code, 'J2', salary ) ) J2 
              ,MAX( DECODE(job_code, 'J3', salary ) ) J3 
              ,MAX( DECODE(job_code, 'J4', salary ) ) J4 
              ,MAX( DECODE(job_code, 'J5', salary ) ) J5 
              ,MAX( DECODE(job_code, 'J6', salary ) ) J6 
              ,MAX( DECODE(job_code, 'J7', salary ) ) J7 
        FROM employee
        GROUP BY dept_code
        ORDER BY dept_code
     )
     UNPIVOT (
        salary
        FOR job_code IN (J1, J2, J3, J4, J5, J6, J7)
     )
;

-- UNPIVOT 전 데이터
SELECT dept_code
              ,MAX( DECODE(job_code, 'J1', salary ) ) J1 
              ,MAX( DECODE(job_code, 'J2', salary ) ) J2 
              ,MAX( DECODE(job_code, 'J3', salary ) ) J3 
              ,MAX( DECODE(job_code, 'J4', salary ) ) J4 
              ,MAX( DECODE(job_code, 'J5', salary ) ) J5 
              ,MAX( DECODE(job_code, 'J6', salary ) ) J6 
              ,MAX( DECODE(job_code, 'J7', salary ) ) J7 
        FROM employee
        GROUP BY dept_code
        ORDER BY dept_code;



-- 윈도우 함수
-- RANK
SELECT employee_id, salary
     , RANK() 
	OVER (ORDER BY salary DESC) AS salary_rank
FROM employees;


-- DENSE_RANK
SELECT employee_id
       ,salary
       ,DENSE_RANK() 
        OVER (ORDER BY salary DESC) AS dense_salary_rank
FROM employees;


-- ROW_NUMBER
SELECT employee_id
      ,salary
      ,ROW_NUMBER() 
       OVER (ORDER BY salary DESC) AS row_num
FROM employees;


-- FIRST_VALUE
SELECT department_id
    , employee_id
    , salary
    ,FIRST_VALUE(salary) 
        OVER (PARTITION BY department_id 
              ORDER BY hire_date) AS first_salary
FROM employees;



-- LAST_VALUE
SELECT department_id
    , employee_id
    , salary
    , LAST_VALUE(salary) 
      OVER (PARTITION BY department_id 
            ORDER BY hire_date
            -- ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
            ROWS BETWEEN UNBOUNDED PRECEDING AND 2 PRECEDING
      ) AS last_salary
FROM employees;

-- ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
-- 현재 행을 기준으로 첫번째 행부터 마지막 행까지 모두 포함하여 계산




-- LAG
SELECT employee_id, first_name, hire_date,
       LAG(first_name) OVER (ORDER BY hire_date) AS previous_name,
       LAG(hire_date) OVER (ORDER BY hire_date) AS previous_hire_date
FROM employees;


-- LEAD
SELECT employee_id, first_name, hire_date,
       LEAD(first_name) OVER (ORDER BY hire_date) AS next_first_name,
       LEAD(hire_date) OVER (ORDER BY hire_date) AS next_hire_date
FROM employees;



-- 비율함수
-- CUME_DIST : 누적분포
SELECT employee_id
    , salary
    , CUME_DIST() 
      OVER (ORDER BY salary DESC) AS cumulative_distribution
FROM employees;


-- PECENT_RANK
SELECT employee_id
    , salary
    , PERCENT_RANK() 
      OVER (ORDER BY salary DESC) AS percent_rank
FROM employees;


-- NTILE
SELECT employee_id
    , salary
    , NTILE(4) 
      OVER (ORDER BY salary DESC) AS quartile
FROM employees;


-- RATIO_TO_REPORT
SELECT department_id
    , employee_id
    , salary
    , RATIO_TO_REPORT(salary) 
      OVER (PARTITION BY department_id) AS salary_ratio
FROM employees;




-- TOP N 쿼리

-- ORACLE 페이징 처리
SELECT *
FROM (
    SELECT ROWNUM AS row_num, no, title, content
    FROM board
    WHERE ROWNUM <= 10
)
WHERE row_num >= 1; 

-- MySQL 페이징 처리
SELECT *
FROM board
LIMIT 0, 10;      -- LIMIT 시작INDEX, 개수






-- 계층형 쿼리 - CONNECT BY
SELECT LEVEL
    , employee_id
    , LPAD(' ', LEVEL * 4, ' ') || FIRST_NAME AS 직원명
    , first_name
    , last_name
    , job_id
    , manager_id
FROM employees
START WITH manager_id IS NULL
CONNECT BY PRIOR employee_id = manager_id;






-- PL/SQL 기본 구조

-- 블록
DECLARE    
      필요한 요소를 선언;           -- 선언부
BEGIN
      실행문;                      -- 실행부
EXCEPTION
      예외 처리 부분                -- 예외 처리
END;
/




-- 변수 선언과 출력
-- 실행결과 출력하도록 설정 (SQL PLUS, SQL Developer 에서 실행 가능)
SET SERVEROUTPUT ON;          

DECLARE
      VI_NUM      NUMBER;     -- 선언부 (NUMBER 타입 변수 VI_NUM 선언)
BEGIN
      VI_NUM := 100;          -- 실행부
      DBMS_OUTPUT.PUT_LINE(VI_NUM);
END;
/



-- 변수 선언

DECLARE
      -- 변수 선언 : 변수명 데이터타입 := 값;
      -- VS_EMP_NAME VARCHAR2(100);
      -- VS_DEPT_NAME VARCHAR2(100);
      -- 데이터타입 참조형 : 테이블명.컬럼명%TYPE
      VS_EMP_NAME EMPLOYEE.EMP_NAME%TYPE;
      VS_DEPT_NAME DEPARTMENT.DEPT_TITLE%TYPE;
BEGIN
      SELECT E.EMP_NAME, D.DEPT_TITLE
        INTO VS_EMP_NAME, VS_DEPT_NAME    -- 조회결과를 변수에 대입(INTO)
        FROM EMPLOYEE E
            ,DEPARTMENT D
      WHERE E.DEPT_CODE = D.DEPT_ID
        AND E.EMP_ID = 200;

      DBMS_OUTPUT.PUT_LINE(VS_EMP_NAME || ' : ' || VS_DEPT_NAME);
END;
/








-- PL/SQL 제어문
-- 조건문
-- IF
DECLARE
      VN_NUM1 NUMBER := 10;
      VN_NUM2 NUMBER := 20;
BEGIN
      IF VN_NUM1 > VN_NUM2 THEN
            DBMS_OUTPUT.PUT_LINE(VN_NUM1 || '이 더 큽니다.');
      ELSE
            DBMS_OUTPUT.PUT_LINE(VN_NUM2 || '이 더 큽니다.');
      END IF;
END;
/


-- IF - ELSIF
-- 사원들 중 부서가 'D1'에서 급여가 가장 많은 사원의 급여를
-- 조회하여 1,000,000 원 이상 2,000,000 이하 이면 1 출력
--         2,000,001 원 이상 3,000,000 이하 이면 2 출력
--         그렇지 않으면 3 을 출력해보세요.
DECLARE
      -- 지정 부서 
      VN_DEPT_CODE DEPARTMENT.DEPT_ID%TYPE := 'D1';
      -- 최대급여를 담을 변수
      MAX_SALARY NUMBER := 0;
BEGIN
      -- 조회 (D1 부서의 최대 급여를 MAX_SALARY 에 조회하여 대입)
      SELECT MAX(salary)
        INTO MAX_SALARY
        FROM EMPLOYEE
      WHERE DEPT_CODE = VN_DEPT_CODE;
      DBMS_OUTPUT.PUT_LINE('D1 부서 최대급여 : ' || MAX_SALARY);
      -- 조건문
      IF MAX_SALARY BETWEEN 1000000 AND 2000000 THEN
            DBMS_OUTPUT.PUT_LINE('1');
      ELSIF MAX_SALARY BETWEEN 2000001 AND 3000000 THEN
            DBMS_OUTPUT.PUT_LINE('2');
      ELSE
            DBMS_OUTPUT.PUT_LINE('3');
      END IF;
END;
/





-- CASE
DECLARE
      VN_DEPT_CODE DEPARTMENT.DEPT_ID%TYPE := 'D1';
      MAX_SALARY NUMBER := 0;
BEGIN
      SELECT MAX(salary)
        INTO MAX_SALARY
        FROM EMPLOYEE
      WHERE DEPT_CODE = VN_DEPT_CODE;
      DBMS_OUTPUT.PUT_LINE('D1 부서 최대급여 : ' || MAX_SALARY);
      -- 조건문
      CASE 
            WHEN MAX_SALARY BETWEEN 1000000 AND 2000000 THEN
                  DBMS_OUTPUT.PUT_LINE('1');
            WHEN MAX_SALARY BETWEEN 2000001 AND 3000000 THEN
                  DBMS_OUTPUT.PUT_LINE('2');
            ELSE
                  DBMS_OUTPUT.PUT_LINE('3');
      END CASE;
END;
/




-- LOOP
DECLARE
      VN_BASE_NUM NUMBER := 3;
      VN_CNT NUMBER := 1;
BEGIN
      LOOP
            DBMS_OUTPUT.PUT_LINE(VN_BASE_NUM || '*' || VN_CNT || '=' ||
                                 VN_BASE_NUM * VN_CNT);
            VN_CNT := VN_CNT + 1;
            EXIT WHEN VN_CNT > 9;         -- 종료 조건
      END LOOP;
END;
/



-- WHILE LOOP
DECLARE
      VN_BASE_NUM NUMBER := 3;
      VN_CNT NUMBER := 1;
BEGIN
      WHILE VN_CNT <= 9 LOOP
            DBMS_OUTPUT.PUT_LINE(VN_BASE_NUM || '*' || VN_CNT || '=' ||
                                 VN_BASE_NUM * VN_CNT);
            VN_CNT := VN_CNT + 1;
      END LOOP;
END;
/







-- FOR LOOP
DECLARE
      VN_BASE_NUM NUMBER := 3;
BEGIN
      FOR i IN 1..9 LOOP
            DBMS_OUTPUT.PUT_LINE(VN_BASE_NUM || '*' || i || '=' ||
                                 VN_BASE_NUM * i);
      END LOOP;
END;
/

-- FOR LOOP (REVERSE)
DECLARE
      VN_BASE_NUM NUMBER := 3;
BEGIN
      FOR i IN REVERSE 1..9 LOOP
            DBMS_OUTPUT.PUT_LINE(VN_BASE_NUM || '*' || i || '=' ||
                                 VN_BASE_NUM * i);
      END LOOP;
END;
/





-- CONITNUE
DECLARE
      VN_NUM NUMBER := 1;
BEGIN
      FOR i IN 1..20 LOOP
            CONTINUE WHEN MOD(i, 2) = 0;        -- 짝수일 때, 건너뜀
            DBMS_OUTPUT.PUT_LINE(i);
      END LOOP;
END;
/



-- 함수
-- 부서번호로, 부서명을 구하는 함수 정의
CREATE OR REPLACE FUNCTION get_dept_title( p_dept_id VARCHAR2 ) 
RETURN VARCHAR2
IS
      OUT_DEPT_TITLE DEPARTMENT.DEPT_TITLE%TYPE;
BEGIN
      SELECT DEPT_TITLE
        INTO OUT_DEPT_TITLE
      FROM DEPARTMENT
      WHERE DEPT_ID = p_dept_id;

      RETURN OUT_DEPT_TITLE;
END;
/



-- SELECT 문에서 함수 실행
SELECT get_dept_title('D1')
FROM dual;


-- PL/SQL 블록에서 함수 실행
DECLARE
      RESULT DEPARTMENT.DEPT_TITLE%TYPE;
BEGIN
      RESULT := get_dept_title('D1');
      DBMS_OUTPUT.PUT_LINE( RESULT );
END;
/







-- 함수 생성
-- emp_id 를 인자로 넘겨주면,
-- 사원 구분을 '매니저', '사원' 으로 반환하는 함수를 정의해보세요.
-- 함수명 : emp_type( 200 )

CREATE OR REPLACE FUNCTION emp_type( p_emp_id VARCHAR2 )
RETURN VARCHAR2
IS
      RESULT VARCHAR2(10);
BEGIN
      -- 사원 타입 조회 ('매니저', '사원')
      SELECT CASE
                  WHEN EXISTS ( SELECT 1 FROM EMPLOYEE WHERE MANAGER_ID = p_emp_id )
                  THEN '매니저'
                  ELSE '사원'
             END
        INTO RESULT
      FROM dual;
      RETURN RESULT;
END;
/

select * from employee;


SELECT EMP_ID 사원번호
      ,EMP_NAME 사원명
      ,get_dept_title( DEPT_CODE ) 부서명
      ,emp_type( EMP_ID ) 구분
FROM EMPLOYEE;


-- 함수 삭제
DROP FUNCTION get_dept_title;
DROP FUNCTION emp_type;



-- 114.
-- 사원번호로 부서명을 구하는 함수를 정의하는 PL/SQL 을 작성하시오.
-- 함수명 : dept_title
CREATE OR REPLACE FUNCTION dept_title( p_emp_id VARCHAR2 ) 
RETURN VARCHAR2
IS
      OUT_DEPT_TITLE DEPARTMENT.DEPT_TITLE%TYPE;
BEGIN
      SELECT DEPT_TITLE
        INTO OUT_DEPT_TITLE
      FROM EMPLOYEE E, DEPARTMENT D
      WHERE E.DEPT_CODE = D.DEPT_ID
        AND E.EMP_ID = p_emp_id
      RETURN OUT_DEPT_TITLE;
END;
/








-- 프로시저 생성
CREATE OR REPLACE PROCEDURE PRO_PRINT
IS
      V_A NUMBER := 10;
      V_B NUMBER := 20;
      V_C NUMBER;
BEGIN
      V_C := V_A + V_B;
      DBMS_OUTPUT.PUT_LINE('V_C : ' || V_C);
END;
/

-- 프로시저 실행
SET SERVEROUTPUT ON;
EXECUTE PRO_PRINT();




-- 파라미터 있는 프로시저
-- 사원번호, 제목, 내용을 입력받아
-- 사원이름으로 BOARD 테이블에 게시글이 작성되도록 하는 프로시저를 정의하시오.

CREATE OR REPLACE PROCEDURE PRO_EMP_WRITER 
(
      IN_EMP_ID IN EMPLOYEE.EMP_ID%TYPE,
      IN_TITLE IN VARCHAR2 DEFAULT '제목없음',
      IN_CONTENT IN VARCHAR2 DEFAULT '내용없음'
)
IS
      V_EMP_NAME EMPLOYEE.EMP_NAME%TYPE;
BEGIN
      SELECT EMP_NAME INTO V_EMP_NAME
        FROM EMPLOYEE
      WHERE EMP_ID = IN_EMP_ID;

      INSERT INTO board( no, title, writer, content )
      VALUES ( SEQ_BOARD.NEXTVAL, IN_TITLE, V_EMP_NAME, IN_CONTENT );
END;
/

TRUNCATE TABLE BOARD;

-- SEQ_BOARD 시퀀스 생성
CREATE SEQUENCE SEQ_BOARD
INCREMENT BY 1
START WITH 1
MINVALUE 1
MAXVALUE 10000;



-- 프로시저 실행
EXECUTE PRO_EMP_WRITER( '200', '글 제목', '글 내용' );
EXECUTE PRO_EMP_WRITER( '201', '글 제목');
EXECUTE PRO_EMP_WRITER( '202' );

SELECT * FROM BOARD;






-- 직무 변경에 다른 직무 이력 갱신 프로세스를 프로시저로 정의하시오.
-- 1. EMPLOYEES 테이블에서 JOB_ID 가 변경
-- 2. JOB_HISTORY 테이블에서 직무이력 갱신
--    1) 해당 기간 내 직무 이력 없으면, 새로 추가
--    2) 해당 기간 내 직무 이력 있으면, 직무ID, 시작/종료일자 갱신
CREATE OR REPLACE PROCEDURE PRO_APP_EMP (
      -- 파라미터
      IN_EMP_ID IN EMPLOYEES.EMPLOYEE_ID%TYPE,        -- 사원번호
      IN_JOB_ID IN JOBS.JOB_ID%TYPE,                  -- 직무ID
      IN_STD_DATE IN DATE,                            -- 직무 시작일
      IN_END_DATE IN DATE                             -- 직무 종료일
)
IS
      -- 선언부
      V_DEPT_ID EMPLOYEES.DEPARTMENT_ID%TYPE;         -- 부서번호
      V_CNT NUMBER := 0;                              -- 직무이력 개수
BEGIN
      -- 실행부
      -- 1. 사원 테이블에서 부서번호 조회
      SELECT DEPARTMENT_ID INTO V_DEPT_ID
      FROM EMPLOYEES
      WHERE EMPLOYEE_ID = IN_EMP_ID;

      -- 2. 사원 테이블의 JOB_ID 수정
      -- ex) AC_MGR --> IT_PROG
      UPDATE EMPLOYEES
         SET JOB_ID = IN_JOB_ID
      WHERE EMPLOYEE_ID = IN_EMP_ID;

      -- 3. 직무이력 테이블에 업무이력 갱신
      -- * 현재 날짜에 포함된 직무이력 여부 확인
      SELECT COUNT(*) INTO V_CNT
      FROM JOB_HISTORY
      WHERE EMPLOYEE_ID = IN_EMP_ID
        AND sysdate BETWEEN START_DATE AND END_DATE;
      
      -- 해당 기간 내 직무 이력 없으면 --> 직무이력 추가
      IF V_CNT = 0 THEN
            INSERT INTO JOB_HISTORY 
                  ( EMPLOYEE_ID, START_DATE, END_DATE, JOB_ID, DEPARTMENT_ID )
            VALUES ( IN_EMP_ID, IN_STD_DATE, IN_END_DATE, IN_JOB_ID, V_DEPT_ID );
      -- 해당 기간 내 직무 이력 있으면 --> 직무이력 갱신
      ELSE
            UPDATE JOB_HISTORY
               SET JOB_ID = IN_JOB_ID
                  ,START_DATE = IN_STD_DATE
                  ,END_DATE = IN_END_DATE
            WHERE EMPLOYEE_ID = IN_EMP_ID
              AND sysdate BETWEEN START_DATE AND END_DATE;
      END IF;
END;
/

-- 프로시저 실행
-- 200번 사원의 직무를 IT_PROG 로 변경하고, 직무이력 해당 기간으로 갱신하시오.
EXECUTE PRO_APP_EMP( '200', 'SA_MAN', '2025/01/01', '2027/01/01');

-- 
SELECT * FROM EMPLOYEES WHERE EMPLOYEE_ID = 200;
SELECT * FROM JOB_HISTORY
ORDER BY EMPLOYEE_ID;


-- OUT 파라미터를 사용한 프로시저

-- OUT 파라미터를 사용한 프로시저
-- '200/김조은/3,000,000'
CREATE OR REPLACE PROCEDURE PRO_OUT_EMP (
    IN_EMP_ID IN EMPLOYEE.EMP_ID%TYPE,  -- 사원번호
    OUT_RESULT_STR OUT CLOB
)
IS
    V_EMP EMPLOYEE%ROWTYPE;
    -- %ROWTYPE
    -- : 해당 테이블 또는 뷰의 컬럼들을 참조타입으로 선언
BEGIN
    SELECT * INTO V_EMP
    FROM EMPLOYEE
    WHERE EMP_ID = IN_EMP_ID;

    OUT_RESULT_STR := V_EMP.EMP_ID
                      || '/' || V_EMP.EMP_NAME
                      || '/' || V_EMP.SALARY;
END;
/


-- OUT 파라미터 프로시저 실행(블록으로 실행)
DECLARE
    -- 프로시저 OUT 결과를 받아올 변수
    OUT_RESULT_STR CLOB;
BEGIN
    -- 프로시저 실행
    PRO_OUT_EMP( '200', OUT_RESULT_STR );
    DBMS_OUTPUT.PUT_LINE( OUT_RESULT_STR );
END;
/



-- 프로시저로 OUT 파라미터 2개 이상 사용하기
CREATE OR REPLACE PROCEDURE PRO_OUT_MUL (
    IN_EMP_ID IN EMPLOYEE.EMP_ID%TYPE,
    OUT_DEPT_CODE OUT EMPLOYEE.DEPT_CODE%TYPE,
    OUT_JOB_CODE OUT EMPLOYEE.JOB_CODE%TYPE
)
IS
    V_EMP EMPLOYEE%ROWTYPE;
BEGIN
    SELECT * INTO V_EMP
    FROM EMPLOYEE
    WHERE EMP_ID = IN_EMP_ID;

    OUT_DEPT_CODE := V_EMP.DEPT_CODE;
    OUT_JOB_CODE := V_EMP.JOB_CODE;
END;
/



-- 프로시저 호출
-- 1) 매개변수 없거나, IN 매개변수만 : EXECUTE 프로시저명( 인자1, 인자2 );
-- 2) OUT 매개변수                  : PL/SQL 블록 안에서 호출

-- EXECUTE PRO_OUT_MUL( 1, 2, 3 ) -- OUT 파라미터가 있어서, 블록 안에서 호출해야함

DECLARE
    OUT_DEPT_CODE EMPLOYEE.DEPT_CODE%TYPE;
    OUT_JOB_CODE EMPLOYEE.JOB_CODE%TYPE;
BEGIN
    -- 호출
    PRO_OUT_MUL( '200', OUT_DEPT_CODE, OUT_JOB_CODE );
    DBMS_OUTPUT.PUT_LINE('부서코드 : ' || OUT_DEPT_CODE );
    DBMS_OUTPUT.PUT_LINE('직급코드 : ' || OUT_JOB_CODE );
END;
/




-- 프로시저에서 예외처리
CREATE OR REPLACE PROCEDURE PRO_PRINT_EMP(
    IN_EMP_ID IN EMPLOYEE.EMP_ID%TYPE    
)
IS
    STR_EMP_INFO CLOB;
    V_EMP EMPLOYEE%ROWTYPE;
BEGIN
    SELECT * INTO V_EMP
    FROM EMPLOYEE
    WHERE EMP_ID = IN_EMP_ID;

    STR_EMP_INFO := '사원정보' || CHR(10) ||
                    '사원명 : ' || V_EMP.EMP_NAME || CHR(10) ||
                    '이메일 : ' || V_EMP.EMAIL || CHR(10) ||
                    '전화번호 : ' || V_EMP.PHONE;

    DBMS_OUTPUT.PUT_LINE( STR_EMP_INFO );

    -- 예외처리부
    EXCEPTION
        -- NO_DATA_FOUND : SELECT INTO 변수 를 사용할 때, 조회 결과가 하나도 없는 경우 예외 발생
        WHEN NO_DATA_FOUND THEN
            STR_EMP_INFO := '존재하지 않는 사원ID 입니다.';
            DBMS_OUTPUT.PUT_LINE( STR_EMP_INFO );
END;
/


-- 존재하는 사원 번호
EXECUTE PRO_PRINT_EMP('200')


-- 존재하는 않는 사원 번호 (예외 발생)
EXECUTE PRO_PRINT_EMP('500')

