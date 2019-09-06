SHOW DATABASES ;

USE test_db;

SHOW TABLES ;

CREATE TABLE `test_table` (
                          `id` INT PRIMARY KEY ,
                          `name` VARCHAR(8) NOT NULL ,
                          `age` INT NOT NULL ,
                          `created_at` timestamp NOT NULL
) ENGINE=INNODB DEFAULT CHARSET=utf8;

INSERT INTO test_table (id, name, age, created_at) VALUE (1, "zhangsan", 12, CURRENT_TIMESTAMP);

SELECT * FROM test_db.test_table;

select * from test_table where id = 1