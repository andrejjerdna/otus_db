# Установка СУБД PostgreSQL.

## Установка
Запуск postgresql выпонен в виде развертывания docker контейнера на VPS сервере.
Был создан файл **docker-compose** и выполнена команда **docker-compose up -d**. 

См. рис. ниже:

![](../Files/postgre_install_1.png)
![](../Files/postgre_install_2.png)

## Подключение

Выполнено подключение к системному пользователю, при помощи команды **su postgres**

При помощи команды **\l** получен список созданых на текущий момент базах


![](../Files/postgre_install_3.png)

## Создание таблицы

Скрипт создания таблицы:
**CREATE TABLE public.test (id int PRIMARY KEY, stringValue VARCHAR(255), numericValue NUMERIC);**

![](../Files/postgre_install_4.png)

## Создание базы данных

**CREATE DATABASE test_db;**

При помощи команды **\l** получен список созданых на текущий момент базах
![](../Files/postgre_install_5.png)

## Создание новой роли
Скрипт создания роли:
**CREATE ROLE test_role WITH LOGIN CREATEDB CREATEROLE;**
![](../Files/postgre_install_6.png) 

## Создание новой таблицы в тестовой базе данных

Подключаемся к тестовой базе данных:

**postgres=# psql -d test_db -U postgres**

Создаем новую таблицу при помощи скрипта:

**CREATE TABLE test (id int PRIMARY KEY, stringValue VARCHAR(255), numericValue NUMERIC);**
![](../Files/postgre_install_7.png) 


