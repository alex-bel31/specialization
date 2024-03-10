DROP DATABASE IF EXISTS human_friends;
CREATE DATABASE human_friends;
USE human_friends;

CREATE TABLE animal (
    id SERIAL PRIMARY KEY,
    type VARCHAR(50) NOT NULL
);

INSERT INTO animal (type) VALUES
    ('pet animal'),
    ('pack animal');

CREATE TABLE pet_animal (
    id SERIAL PRIMARY KEY,
    class VARCHAR(50) NOT NULL,
    animal_id BIGINT UNSIGNED NOT NULL,
    FOREIGN KEY (animal_id) REFERENCES animal(id) ON DELETE CASCADE ON UPDATE CASCADE 
);

INSERT INTO pet_animal (animal_id, class) VALUES
    (1, 'Dogs'),
    (1, 'Cats'),
    (1, 'Hamsters');

CREATE TABLE dogs (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    command VARCHAR(100),
    birth_date DATE,
    pet_animal_id BIGINT UNSIGNED NOT NULL,
    FOREIGN KEY (pet_animal_id) REFERENCES pet_animal(id) ON DELETE CASCADE ON UPDATE CASCADE  
);

INSERT INTO dogs (pet_animal_id, name, command, birth_date) VALUES
    (1, 'Рекс', 'Сидеть, ждать', '2015-07-25'),
    (1, 'Белла', 'Апорт ', '2016-10-30'),
    (1, 'Лайка', 'Гулять', '2017-12-05');

CREATE TABLE cats (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    command VARCHAR(100),
    birth_date DATE,
    pet_animal_id BIGINT UNSIGNED NOT NULL,
    FOREIGN KEY (pet_animal_id) REFERENCES pet_animal(id) ON DELETE CASCADE ON UPDATE CASCADE  
);

INSERT INTO cats (pet_animal_id, name, command, birth_date) VALUES
    (2, 'Мята', 'Прыгать', '2015-07-25'),
    (2, 'Вишня', 'Принести игрушку', '2016-10-30'),
    (2, 'Луна', 'Прятаться на команду', '2017-12-05');

CREATE TABLE hamsters (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    command VARCHAR(100),
    birth_date DATE,
    pet_animal_id BIGINT UNSIGNED NOT NULL,
    FOREIGN KEY (pet_animal_id) REFERENCES pet_animal(id) ON DELETE CASCADE ON UPDATE CASCADE  
);

INSERT INTO hamsters (pet_animal_id, name, command, birth_date) VALUES
    (3, 'Шуша', 'Прятаться в домике', '2015-07-25'),
    (3, 'Пушок', 'Проходить через трубы', '2016-10-30'),
    (3, 'Буся', 'Есть из руки', '2017-12-05');


CREATE TABLE pack_animal (
    id SERIAL PRIMARY KEY,
    class VARCHAR(50) NOT NULL,
    animal_id BIGINT UNSIGNED NOT NULL,
    FOREIGN KEY (animal_id) REFERENCES animal(id) ON DELETE CASCADE ON UPDATE CASCADE 
);


INSERT INTO pack_animal (animal_id, class) VALUES
    (2, 'Horses'),
    (2, 'Camels'),
    (2, 'Donkeys');

CREATE TABLE horses (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    command VARCHAR(100),
    birth_date DATE,
    pack_animal_id BIGINT UNSIGNED NOT NULL,
    FOREIGN KEY (pack_animal_id) REFERENCES pet_animal(id) ON DELETE CASCADE ON UPDATE CASCADE  
);

INSERT INTO horses (pack_animal_id, name, command, birth_date) VALUES
    (1, 'Грейс', 'Пройти по тропинке', '2015-07-25'),
    (1, 'Роза', 'Принять уздечку для езды', '2016-10-30'),
    (1, 'Чарли', 'Бегать по кругу вокруг владельца', '2017-12-05');

CREATE TABLE camels (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    command VARCHAR(100),
    birth_date DATE,
    pack_animal_id BIGINT UNSIGNED NOT NULL,
    FOREIGN KEY (pack_animal_id) REFERENCES pet_animal(id) ON DELETE CASCADE ON UPDATE CASCADE  
);

INSERT INTO camels (pack_animal_id, name, command, birth_date) VALUES
    (2, 'Шейла', 'Принять груз', '2015-07-25'),
    (2, 'Амара', 'Принимать и выносить питьевую воду', '2016-10-30'),
    (2, 'Али', 'Пройти по песчаной дюне', '2017-12-05');

CREATE TABLE donkeys (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    command VARCHAR(100),
    birth_date DATE,
    pack_animal_id BIGINT UNSIGNED NOT NULL,
    FOREIGN KEY (pack_animal_id) REFERENCES pet_animal(id) ON DELETE CASCADE ON UPDATE CASCADE  
);

INSERT INTO donkeys (pack_animal_id, name, command, birth_date) VALUES
    (3, 'Барни', ' Переносить грузы в телеге', '2015-07-25'),
    (3, 'Оскар', 'Поднимать передние ноги для приветствия', '2016-10-30'),
    (3, 'Мэри', 'Следовать за владельцем во время прогулки', '2017-12-05');


-- Удаление всех верблюдов из таблицы camels
DELETE FROM camels;

-- Объединение таблиц лошадей и ослов в одну таблицу с именем equines
CREATE TABLE equines AS
SELECT *
FROM horses
UNION ALL
SELECT *
FROM donkeys;

-- Удаление таблиц horses и donkeys 
DROP TABLE IF EXISTS horses;
DROP TABLE IF EXISTS donkeys;


-- Создание таблицы "молодые животные"
CREATE TABLE young_animals AS
SELECT *,
       TIMESTAMPDIFF(YEAR, birth_date, CURDATE()) - 
       CASE
           WHEN DATE_FORMAT(birth_date, '%m%d') > DATE_FORMAT(CURDATE(), '%m%d') THEN 1
           ELSE 0
       END AS age_years,
       TIMESTAMPDIFF(MONTH, birth_date, CURDATE()) % 12 AS age_months
FROM (
    SELECT * FROM dogs
    UNION ALL
    SELECT * FROM cats
    UNION ALL
    SELECT * FROM hamsters
    UNION ALL
    SELECT * FROM horses
    UNION ALL
    SELECT * FROM camels
    UNION ALL
    SELECT * FROM donkeys
) AS all_animals;

-- Фильтрация животных старше 1 года, но младше 3 лет
DELETE FROM young_animals WHERE age_years NOT BETWEEN 1 AND 3;

-- Создание общей таблицы и добавление столбца для указания типа животного
CREATE TABLE all_animals AS
SELECT 'dog' AS animal_type, id, name, command, birth_date, pet_animal_id
FROM dogs
UNION ALL
SELECT 'cat' AS animal_type, id, name, command, birth_date, pet_animal_id
FROM cats
UNION ALL
SELECT 'hamster' AS animal_type, id, name, command, birth_date, pet_animal_id
FROM hamsters
UNION ALL
SELECT 'horse' AS animal_type, id, name, command, birth_date, pack_animal_id
FROM horses
UNION ALL
SELECT 'camel' AS animal_type, id, name, command, birth_date, pack_animal_id
FROM camels
UNION ALL
SELECT 'donkey' AS animal_type, id, name, command, birth_date, pack_animal_id
FROM donkeys;

-- Удаление таблиц, если они больше не нужны
DROP TABLE IF EXISTS dogs;
DROP TABLE IF EXISTS cats;
DROP TABLE IF EXISTS hamsters;
DROP TABLE IF EXISTS horses;
DROP TABLE IF EXISTS camels;
DROP TABLE IF EXISTS donkeys;



