## Выбор каталогов приложения пользователя, в названии которых содержится слово steel
``` sql
SELECT * FROM plugin_host.catalog AS c
LEFT JOIN user_host."user" AS u ON c.fk_user = u.id
WHERE c.name ILIKE '%steel%';
```

## Вставка пользователя в таблицу с выводом id, который назначен после вставки в БД
``` sql
INSERT INTO user_host."user"
(fk_role, name, register_date, email, phone, fk_country, password_hash)
VALUES(1, 'TestUser', now(), 'test@test.ru', '79209044100', 1, '51b40bbbfb88261ed6b616025a7c15a61f282d58614e6a216156b770250fee51206924989671299d8a0cadd476a1e8e465066ff2451a589360e940a3709cf40e')
RETURNING id;
```

## Изменение почты пользователя и вывод id и новой электронной почты после вставки
``` sql
UPDATE user_host."user"
SET email = 'test2@test.ru'
WHERE id = 2
RETURNING id, email;
```

## Удаление всех данных о загрузке файлов, если дата загрузки более 1 года
``` sql
DELETE FROM plugin_host.download
USING plugin_host.plugin_version
WHERE plugin_version.release_date < (clock_timestamp() - interval '1 year')
RETURNING download.id, download.date;
```

## Копирование спика каталогов приложения из csv файла
``` sql
\COPY TO plugin_host.catalog(name, description, fk_user) FROM 'C:\csv.csv' DELIMITER ';' CSV HEADER;
```