-- Active: 1687738737464@@127.0.0.1@3306@newschema
CREATE TABLE `newschema`.`member_log` (
  `idx` INT NOT NULL AUTO_INCREMENT,
  `user_id` VARCHAR(45) NOT NULL,
  `message` VARCHAR(200) NULL,
  `reg_date` DATETIME NOT NULL,
  PRIMARY KEY (`idx`));


INSERT INTO member (user_id, user_name, user_age, user_grade, user_job)
values ('test12', '테스트12', 20, 'silver', '대학생');

insert into member_log (user_id, message, reg_date)
VALUES ('test12', '사용자가 추가되었습니다', now());


DELIMITER $$   # 종료기호를 $$로 생성
CREATE Trigger 'trg_after_insert_member_log'
after INSERT    #insert 이후에 member 테이블에 동작하도록 하겠다는 것
on 'member'
for each row
BEGIN
        insert into 'member_log' (user_id, message, reg_date)
        values(new.user_id, '사용자가 추가 되었습니다.', now());
end $$
DELIMITER ;  #원래의 종료 기호로 복구



create definer = CURRENT_USER TRIGGER 'testdb', 'member_after_insert' AFTER INSERT on 'member' for each row
BEGIN
insert into member_log (user_id, message, reg_date)
values(new.user_id, '사용자가 추가 되었습니다.', now());
end$$
DELIMITER;

create definer = CURRENT_USER TRIGGER 'testdb', 'member_after_delete' AFTER INSERT on 'member' for each row

-- 트리거 쓰는 방법은 나중에 다시 써보자
-- 사용에 대한 기록을 남길때
-- 또는 백업용 테이블을 만드려고 할 때 트리거를 쓴다


