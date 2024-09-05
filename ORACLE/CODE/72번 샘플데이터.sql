-- Active: 1725516651954@@127.0.0.1@1521@orcl@JOEUN

insert into MS_USER (USER_NO, USER_ID, USER_PW, USER_NAME, BIRTH, TEL, ADDRESS, REG_DATE, UPD_DATE)
values(1, 'joeun', '123456', '김조은', '1999/10/10', '010-2000-3000', '인천시 부평구',
      '2024/09/05', '2024/09/05');


insert into MS_BOARD 
(BOARD_NO, TITLE, WRITER, HIT, LIKE_CNT, DEL_YN, DEL_DATE, REG_DATE, UPD_DATE, CONTENT)
values(2, '제목', 1, 0, 0, 'N', NULL, '2024/09/05', '2024/09/05', '글 내용');

SELECT * FROM MS_BOARD;

