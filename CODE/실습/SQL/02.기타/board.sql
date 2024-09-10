-- DDL
CREATE TABLE board (
  no NUMBER NOT NULL,
  title varchar2(100) NOT NULL,
  writer varchar2(100) NOT NULL,
  content varchar2(1000),
  reg_date DATE DEFAULT sysdate NOT NULL,
  upd_date DATE  DEFAULT sysdate NOT NULL,
  views NUMBER  DEFAULT 0 NOT NULL,
  PRIMARY KEY (no)
);

SELECT * FROM BOARD;
TRUNCATE TABLE board;

-- 샘플 데이터
INSERT INTO board (no, title, writer, content, reg_date, upd_date, views) VALUES (1, '제목01', '작성자01', '내용01', SYSDATE, SYSDATE, 0);
INSERT INTO board (no, title, writer, content, reg_date, upd_date, views) VALUES (2, '제목02', '작성자02', '내용02', SYSDATE, SYSDATE, 0);
INSERT INTO board (no, title, writer, content, reg_date, upd_date, views) VALUES (3, '제목03', '작성자03', '내용03', SYSDATE, SYSDATE, 0);
INSERT INTO board (no, title, writer, content, reg_date, upd_date, views) VALUES (4, '제목04', '작성자04', '내용04', SYSDATE, SYSDATE, 0);
INSERT INTO board (no, title, writer, content, reg_date, upd_date, views) VALUES (5, '제목05', '작성자05', '내용05', SYSDATE, SYSDATE, 0);
INSERT INTO board (no, title, writer, content, reg_date, upd_date, views) VALUES (6, '제목06', '작성자06', '내용06', SYSDATE, SYSDATE, 0);
INSERT INTO board (no, title, writer, content, reg_date, upd_date, views) VALUES (7, '제목07', '작성자07', '내용07', SYSDATE, SYSDATE, 0);
INSERT INTO board (no, title, writer, content, reg_date, upd_date, views) VALUES (8, '제목08', '작성자08', '내용08', SYSDATE, SYSDATE, 0);
INSERT INTO board (no, title, writer, content, reg_date, upd_date, views) VALUES (9, '제목09', '작성자09', '내용09', SYSDATE, SYSDATE, 0);
INSERT INTO board (no, title, writer, content, reg_date, upd_date, views) VALUES (10, '제목10', '작성자10', '내용10', SYSDATE, SYSDATE, 0);
INSERT INTO board (no, title, writer, content, reg_date, upd_date, views) VALUES (11, '제목11', '작성자11', '내용11', SYSDATE, SYSDATE, 0);
INSERT INTO board (no, title, writer, content, reg_date, upd_date, views) VALUES (12, '제목12', '작성자12', '내용12', SYSDATE, SYSDATE, 0);
INSERT INTO board (no, title, writer, content, reg_date, upd_date, views) VALUES (13, '제목13', '작성자13', '내용13', SYSDATE, SYSDATE, 0);
INSERT INTO board (no, title, writer, content, reg_date, upd_date, views) VALUES (14, '제목14', '작성자14', '내용14', SYSDATE, SYSDATE, 0);
INSERT INTO board (no, title, writer, content, reg_date, upd_date, views) VALUES (15, '제목15', '작성자15', '내용15', SYSDATE, SYSDATE, 0);
INSERT INTO board (no, title, writer, content, reg_date, upd_date, views) VALUES (16, '제목16', '작성자16', '내용16', SYSDATE, SYSDATE, 0);
INSERT INTO board (no, title, writer, content, reg_date, upd_date, views) VALUES (17, '제목17', '작성자17', '내용17', SYSDATE, SYSDATE, 0);
INSERT INTO board (no, title, writer, content, reg_date, upd_date, views) VALUES (18, '제목18', '작성자18', '내용18', SYSDATE, SYSDATE, 0);
INSERT INTO board (no, title, writer, content, reg_date, upd_date, views) VALUES (19, '제목19', '작성자19', '내용19', SYSDATE, SYSDATE, 0);
INSERT INTO board (no, title, writer, content, reg_date, upd_date, views) VALUES (20, '제목20', '작성자20', '내용20', SYSDATE, SYSDATE, 0);
INSERT INTO board (no, title, writer, content, reg_date, upd_date, views) VALUES (21, '제목21', '작성자21', '내용21', SYSDATE, SYSDATE, 0);
INSERT INTO board (no, title, writer, content, reg_date, upd_date, views) VALUES (22, '제목22', '작성자22', '내용22', SYSDATE, SYSDATE, 0);
INSERT INTO board (no, title, writer, content, reg_date, upd_date, views) VALUES (23, '제목23', '작성자23', '내용23', SYSDATE, SYSDATE, 0);
INSERT INTO board (no, title, writer, content, reg_date, upd_date, views) VALUES (24, '제목24', '작성자24', '내용24', SYSDATE, SYSDATE, 0);
INSERT INTO board (no, title, writer, content, reg_date, upd_date, views) VALUES (25, '제목25', '작성자25', '내용25', SYSDATE, SYSDATE, 0);
INSERT INTO board (no, title, writer, content, reg_date, upd_date, views) VALUES (26, '제목26', '작성자26', '내용26', SYSDATE, SYSDATE, 0);
INSERT INTO board (no, title, writer, content, reg_date, upd_date, views) VALUES (27, '제목27', '작성자27', '내용27', SYSDATE, SYSDATE, 0);
INSERT INTO board (no, title, writer, content, reg_date, upd_date, views) VALUES (28, '제목28', '작성자28', '내용28', SYSDATE, SYSDATE, 0);
INSERT INTO board (no, title, writer, content, reg_date, upd_date, views) VALUES (29, '제목29', '작성자29', '내용29', SYSDATE, SYSDATE, 0);
INSERT INTO board (no, title, writer, content, reg_date, upd_date, views) VALUES (30, '제목30', '작성자30', '내용30', SYSDATE, SYSDATE, 0);
INSERT INTO board (no, title, writer, content, reg_date, upd_date, views) VALUES (31, '제목31', '작성자31', '내용31', SYSDATE, SYSDATE, 0);
INSERT INTO board (no, title, writer, content, reg_date, upd_date, views) VALUES (32, '제목32', '작성자32', '내용32', SYSDATE, SYSDATE, 0);
INSERT INTO board (no, title, writer, content, reg_date, upd_date, views) VALUES (33, '제목33', '작성자33', '내용33', SYSDATE, SYSDATE, 0);
INSERT INTO board (no, title, writer, content, reg_date, upd_date, views) VALUES (34, '제목34', '작성자34', '내용34', SYSDATE, SYSDATE, 0);
INSERT INTO board (no, title, writer, content, reg_date, upd_date, views) VALUES (35, '제목35', '작성자35', '내용35', SYSDATE, SYSDATE, 0);
INSERT INTO board (no, title, writer, content, reg_date, upd_date, views) VALUES (36, '제목36', '작성자36', '내용36', SYSDATE, SYSDATE, 0);
INSERT INTO board (no, title, writer, content, reg_date, upd_date, views) VALUES (37, '제목37', '작성자37', '내용37', SYSDATE, SYSDATE, 0);
INSERT INTO board (no, title, writer, content, reg_date, upd_date, views) VALUES (38, '제목38', '작성자38', '내용38', SYSDATE, SYSDATE, 0);
INSERT INTO board (no, title, writer, content, reg_date, upd_date, views) VALUES (39, '제목39', '작성자39', '내용39', SYSDATE, SYSDATE, 0);
INSERT INTO board (no, title, writer, content, reg_date, upd_date, views) VALUES (40, '제목40', '작성자40', '내용40', SYSDATE, SYSDATE, 0);
INSERT INTO board (no, title, writer, content, reg_date, upd_date, views) VALUES (41, '제목41', '작성자41', '내용41', SYSDATE, SYSDATE, 0);
INSERT INTO board (no, title, writer, content, reg_date, upd_date, views) VALUES (42, '제목42', '작성자42', '내용42', SYSDATE, SYSDATE, 0);
INSERT INTO board (no, title, writer, content, reg_date, upd_date, views) VALUES (43, '제목43', '작성자43', '내용43', SYSDATE, SYSDATE, 0);
INSERT INTO board (no, title, writer, content, reg_date, upd_date, views) VALUES (44, '제목44', '작성자44', '내용44', SYSDATE, SYSDATE, 0);
INSERT INTO board (no, title, writer, content, reg_date, upd_date, views) VALUES (45, '제목45', '작성자45', '내용45', SYSDATE, SYSDATE, 0);
INSERT INTO board (no, title, writer, content, reg_date, upd_date, views) VALUES (46, '제목46', '작성자46', '내용46', SYSDATE, SYSDATE, 0);
INSERT INTO board (no, title, writer, content, reg_date, upd_date, views) VALUES (47, '제목47', '작성자47', '내용47', SYSDATE, SYSDATE, 0);
INSERT INTO board (no, title, writer, content, reg_date, upd_date, views) VALUES (48, '제목48', '작성자48', '내용48', SYSDATE, SYSDATE, 0);
INSERT INTO board (no, title, writer, content, reg_date, upd_date, views) VALUES (49, '제목49', '작성자49', '내용49', SYSDATE, SYSDATE, 0);
INSERT INTO board (no, title, writer, content, reg_date, upd_date, views) VALUES (50, '제목50', '작성자50', '내용50', SYSDATE, SYSDATE, 0);
