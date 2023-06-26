

-- GROUP BY
-- 출력할 결과물을 지정한 그룹으로 묶어서 출력하는 명령어
-- 사용법 : SELECT 컬럼명1, 컬럼명2, ....., FROM 테이블명 GROUP BY 그룹지정컬럼명
-- 집계 함수인 count, sum, avg등 과 함꼐 사용시

# SET GLOBAL sql_mode=strict(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''));

-- ㅡMySQL 버전에 따라서 sql-mode 설정값이 변경되어 있음
-- ONLY_FULL_GROUP_BY 옵션이 설정되어 잇어서 특정 버전에서만 group by가 먹힐 수 있음

# set session sql_mode='STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION';

# C:\ProgramData\MySQL\MySQL Server 8.0 디렉터리에 가서 my.ini에서 only_full_group_by에 대한 오류를
# 수정 할 수 있지만 https://velog.io/@heumheum2/ONLYFULLGROUPBY 홈페이지에서 알 수 있듯이
# 이 오류 코드는 나중에 안뜨면 잘못될 가능성이 큰 오류 피드백이기 때문에 이것을 수정 하는 것 보다는
# 차라리 쿼리문을 제대로 쓰는 것이 낫다



