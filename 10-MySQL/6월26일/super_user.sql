

select * from testdb.super_user
select * from testdb.super_user_log
insert into super_user (name, email)
values ('admin', 'admin@btc.go.kr');

update super_user set email='web_master@btc.go.kr'
where id = 1;

-- 문제) 게시판에 글을 등록하고 댓글이 등록되어 있을 경우 지정한 글을 삭제하려고 할 때
-- 기존의 댓글이 존재하기 때문에 해당 글이 삭제되지 않는다
-- 트리거를 이용하여 해당 게시글의 댓글을 먼저 삭제하도록 설정 하세요

-- 댓글 테이블이 게시판 테이블의 board_idx 컬럼을 참조키로 사용함

-- 게시판용 테이블명 : t_borad
-- 게시판 테이블 컬럼 : board_idx, title, contents, user_id, reg_date, up_date

-- 댓글용 테이블명 : t_reply
-- 댓글 테이블 컬럼 : reply_idx, board_idx, contents, user_id, reg_date, up_date