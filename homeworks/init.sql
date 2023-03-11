-- На поле id ограничения, которые запрещают вставлять их в запросах из приложения,
-- данное поле инициализирует только БД (для всех подобных полей ниже аналогично)
-- name обязательно не пустое, так как является важной частью интерфейса приложения
-- также наложено ограничение на минимальную длину имени
-- description допускает NULL
CREATE TABLE catalog
(
    id SERIAL PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    name TEXT NOT NULL CHECK ( length(name) > 5 ),
    description text,
    fk_developer INTEGER REFERENCES "user"(id)
);

-- На таблице обязательно считаю необходимо сделать уникальными поля email и phone
-- name обязательно не пустое, так как является важной частью интерфейса приложения
-- также наложено ограничение на минимальную длину имени
-- register_date содержит в себе часовой пояс и вставляется средствами БД
CREATE TABLE "user"
(
    id SERIAL PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    fk_role INTEGER REFERENCES "role"(id),
    name TEXT NOT NULL CHECK ( length(name) > 3 ),
    register_date TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT (NOW() AT TIME ZONE 'utc'),
    email TEXT NOT NULL UNIQUE,
    phone TEXT NOT NULL UNIQUE,
    country TEXT
);

-- name обязательно не пустое, так как является важной частью интерфейса приложения
-- также наложено ограничение на минимальную длину имени
-- description допускает NULL
CREATE TABLE plugin
(
    id SERIAL PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    name TEXT NOT NULL CHECK ( length(name) > 5 ),
    description text
);

-- release_date содержит в себе часовой пояс и вставляется средствами БД
-- download_url обязательно должно быть уникальным, так как не может быть ситуации, когда
-- две разных версии плагина ведут к одной ссылке для скачивания
-- description допускает NULL
CREATE TABLE plugin_version
(
    id SERIAL PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    fk_plugin INTEGER REFERENCES plugin(id),
    release_date TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT (NOW() AT TIME ZONE 'utc'),
    download_url TEXT NOT NULL UNIQUE,
    version_number VARCHAR(20) NOT NULL,
    changes TEXT[] NOT NULL,
    description text
);

-- id SMALLSERIAL, так как ролей должно быть небольшое количество
-- name обязательно не пустое
CREATE TABLE "role"
(
    id SMALLSERIAL PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    name TEXT NOT NULL
);

CREATE TABLE user_to_catalog
(
    fk_user INTEGER REFERENCES "user"(id),
    fk_catalog INTEGER REFERENCES  catalog(id)
);

CREATE TABLE user_to_plugin
(
    fk_user INTEGER REFERENCES "user"(id),
    fk_plugin INTEGER REFERENCES "user"(id)
);

CREATE TABLE catalog_to_plugin
(
    fk_catalog INTEGER REFERENCES  catalog(id),
    fk_plugin INTEGER REFERENCES "user"(id)
);

-- Запросы к данной таблице должны быть с целью получения каталогов, которыми владеет user
-- поэтому считаю, что рационально будет создать индекс по полю fk_user
CREATE INDEX ON user_to_catalog (fk_user);

-- Запросы к данной таблице должны быть с целью получения плагинов, на которые подписан user
-- поэтому считаю, что рационально будет создать индекс по полю fk_user
CREATE INDEX ON user_to_plugin (fk_user);

-- Считаю, что на таблицу catalog_to_plugin можно создать два отдельных индекса,
-- потому что к данной таблице должны быть запросу во первых по посику всех плагинов
-- которые сожержит каталог, а во вторых будут запросы, на получение каталогов
-- к которым относятся плагины
CREATE INDEX ON catalog_to_plugin (fk_catalog);
CREATE INDEX ON catalog_to_plugin (fk_plugin);