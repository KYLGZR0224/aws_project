-- Active: 1687738737464@@127.0.0.1@3306@employees


select emp_no, salary, from_date, to_date from salaries;

-- 사원번호가 10001, 10002, 10003 인 사람이 각각 받은 총 급여 정보를 출력
-- 각각의 사원 번호를 입력하여 출력해야 함
SELECT emp_no, SUM(salary) AS 'total_salary' FROM salaries
WHERE emp_no = 10003;
select emp_no, sum(salary) as 'total_salary' from salaries
where emp_no = 10002;
select emp_no, sum(salary) as 'total_salary' from salaries
where emp_no = 10001;

select emp_no, sum(salary) as 'total_salary' from salaries
GROUP BY emp_no;

-- 검색조건을 추가하여 사용해도 된다
select emp_no, sum(salary) from salaries where emp_no < 10010
GROUP BY emp_no;

select * from employees;

-- 이름이 mario인 사람을 검색하여 성별에 따라 남자, 여자를 구분하여 출력
-- 예전 방식의 남여 구분하여 이름이 mario인 사람을 검색
select emp_no, first_name, last_name, gender, hire_DATE FROM employees
WHERE first_name = 'mario'
and gender = 'M';

select emp_no, first_name, last_name, gender, hire_DATE FROM employees
WHERE first_name = 'mario'
and gender = 'F';

-- group by 를 사용하여 출력하는 결과를 gender 컬럼을 기준으로 구분하여 출력
select emp_no, first_name, last_name, gender, hire_date 
from employees
where first_name = 'mario'
GROUP BY gender ,emp_no;

--이건 선생님이 오류 났는데 해결 못한 쿼리문이라서 참고 하면 안된다.
select emp_no, first_name, last_name, gender, hire_date 
from employees
where first_name = 'mario'
GROUP BY gender;

select emp_no, first_name, last_name, gender, hire_DATE FROM employees
WHERE first_name = 'mario';

select count(emp_no), gender
from employees
where first_name = 'mario'
GROUP BY gender;

select count(emp_no), gender
from employees
where first_name = 'mario'
GROUP BY gender;

-- 각 직급별로 몇명이 근무했엇는지 검색하여 출력

selcet COUNT(emp_no) as cnt, title from titles
GROUP BY title;

select title, count(emp_no) as cnt from titles
where to_date >= '2023-06-26'
GROUP BY title;

-- join을 사용하여 근무하고 잇는 사람 중 몇명이 근무하고 있는지 검색하여 출력

SELECT * from titles;

SELECT * from titles where title = 'Assistant Engineer';
SELECT * from titles where title = 'Engineer';
SELECT * from titles where emp_no = "10009";

select * from titles where emp_no = 10009;
select * from salaries where emp_no = 10009;

-- 사원번호가 10009번인 사람의 각 직급별로 받은 총 급여 정보를 출력
-- 이건 내가 성공한거


select a.title, b.salary as salary
from titles as a
join salaries as b
on a.emp_no = b.emp_no
and a.emp_no = 10009
GROUP BY b.salary, a.title;


-- 트리거 : 특정 테이블에 이벤트가 발생 시 미리 설정된 작업이 자동으로 실행되는 것
-- 이벤트 발생 시점으로 before와 after 2가지가 존재한다
-- before : 이벤트 발생 이전에 트리거가 먼저 동작
-- after : 이벤트가 발생 후 트리거가 나중에 동작

-- 이벤트로 insert, update, delete 명령에 트리거가 동작함
-- INSERT : 지정한 테이블에 데이터가 insert 시 트리거가 동작
-- update : 지정한 테이블에 데이터가 update 시 트리거가 동작
-- delete : 지정한 테이블에 데이터가 delete 시 트리거가 동작

-- 데이터 속성으로 old, new 2가지가 존재한다
-- 어떠한 값을 사용할 지 지정
-- old : 기존에 존재하는 값, insert는 사용할 수 없음, update/delete 만 사용 가능
-- new : 새로운 값, insert와 update만 사용 가능하며, delete는 사용 할 수 없음

-- 사용법 :
-- create trigger <트리거명> <트리거 실행시점>(before/after) <on> <트리거 설정 테이블명>
-- for each ROW
-- begin
--     자동 실행할 트리거 내용 <SQL문>
-- end


-- delimiter : sql 쿼리문을 실행 종료하는 문자를 설정하는 명령어
-- sql 문에 기본적으로 적용되는 실행 종료 기호는 ; 이지만 delimiter $$로 설정 시 sql문 끝에 사용하는 기호가 $$로 변경됨
-- 사용 방법 : delimiter $$, delimiter ; 형태로 사용
-- 사용 방법 :
-- 



DELIMITER $$
create TRIGGER 'trg_after_'

-- 멤버 테이블에 회원추가시 로그에 자동으로 데이터가 추가 되도록 만드는 것


INSERT INTO member (user_id, user_name, user_age, user_grade, user_job)
values ('test12', '테스트12', 20, 'silver', '대학생');
