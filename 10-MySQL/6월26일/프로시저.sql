-- Active: 1687738737464@@127.0.0.1@3306@newschema

-- 프로시저 : stored PROCEDURE

-- 여러개의 sql 문을 하나의 sql문 처럼 정리하여 call 이라는 명령어를 사용하여 한번에 실행할 수 있도록 만든 것이다
-- 비슷한 것으로 function (함수)가 존재한다
-- DB서버에서 동작한다, 네트워크 접속과 같은 시간이 줄어들기 때문에 결론적으로 속도가 빠르다
-- 사용법:
-- delimiter $$
-- create procedure 프로시저명 (변수 1, 변수 2, ...)
-- begin
--     declare 변수명 1 데이터타입;
--      ...
--      SQL문 1;
--      SQL문 2;
--      ...
-- end $$
-- delimiter ;

-- 사용법 : 실행
-- call 프로시저명(매개변수값1, 매개변수값2, ....);

-- declare : 프로시저와 함수에서 안에서 사용하는 명령어로 해당 프로시저 및 함수내에서 사용할 변수를 생성하는 명령어
-- 사용법:
-- declare 변수명 데이터타입 default 데이터값;
-- into 변수명 : select 문 내에서 사용
-- set 변수명 = 데이터값
-- in : 프로시저에 값을 전달,원본값은 프로시저 실행 후에도 그대로 유지, 프로시저는 in의 값을 복사해서 사용함
-- out : 프로시저에서 값을 다시 되돌려줌, 프로시저 실행 시 out으로 설정됨, 
--       변수에 값을 저장하면 프로시저 실행 완료 후 해당 변수로 값이 출력됨
-- inout : in + out의 기능을 한번에 수행

-- if, then, else : 조건식을 사용하여 해당 조건식의 결과가 ture 이면 then 실행
    -- 결과가 false 이면 else 부분을 실행

-- 사용법 :
-- IF 조건식 THEN
--      조건의 결과가 TRUE일 경우 실행할 SQL문
-- ELSE
--      조건의 결과가 FALSE일 경우 실행할 SQL문
-- END IF;


-- case, when, then, else, end : case로 지정한 값과 동일한 값을 가지는 when을 검색하여
    -- then 부분을 실행, 동일한 when 부분이 없을 경우 else를 실행
-- 사용법
-- CASE 변수
--      WHEN 값1 THEN
--          SQL문
--      WHEN 값2 THEN
--          SQL문
--      ELSE
--          SQL문
-- END CASE;

select user_id, user_name, user_age, user_grade, user_job, save_point
from member;

select user_id, user_name, user_age, user_grade, user_job, save_point
from member
where user_job = '대학생';

select user_id, user_name, user_age, user_grade, user_job, save_point
from member
where user_job = '회사원';


insert into t_borad (title, contents, user_id, reg_date)
values ('테스트제목 1', '테스트 게시글 내용1', 'tester2', now());

create Procedure 'select_member_t_board' ()
BEGIN
    SELECT * FROM;

    select * from t_borad;
END
;


CREATE PROCEDURE insert_select_board ()
begin
        insert into t_board (title, contents, user_id, reg_date)
        VALUES ('테스트제목2', '테스트내용2', 'tester2', NOW());
        select * from t_board;
end
;

select * from t_board;

call insert_select_board2('테스트 제목4', '테스트내용4', 'tester4');

create Procedure insert_select_board2 (
PARAM_TITLE VARCHAR(100),
PARAM_CONTENTS VARCHAR(200),
PARAM_USERID VARCHAR(45)
)
BEGIN
    INSERT INTO t_board(title, contents, user_id, reg_date)
    VALUES (PARAM_TITLE, PARAM_CONTENTS, PARAM_USERID, NOW());

    SELECT * FROM t_board;
END
;

call insert_select_board2(title, contents, user_id)


create PROCEDURE 'new_procudure' ()
begin
    declare val1 integer default 10;
    declare val2 integer default 20;
    declare val3 integer;
END

select * from t_board;
insert into t_board (title, contents, user_id, reg_date)
values ('테스트제목1', '테스트게시글내용1', '')