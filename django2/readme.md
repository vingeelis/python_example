# django2 notebook


## create database

```sql
CREATE DATABASE mydb;
```


## create user with corresponding privileges

```sql
CREATE USER myuser WITH PASSWORD 'password';
ALTER ROLE myuser SET client_encoding TO 'utf8';
ALTER ROLE myuser SET default_transaction_isolation TO 'read committed';
ALTER ROLE myuser SET timezone TO 'UTC';
GRANT ALL PRIVILEGES ON DATABASE mydb TO myuser;
\q
```


## Configure the Django Database Settings

```text
...

DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.postgresql_psycopg2',
        'NAME': 'myproject',
        'USER': 'myprojectuser',
        'PASSWORD': 'password',
        'HOST': 'localhost',
        'PORT': '',
    }
}

...

```

## create django project

```bash
django-admin startproject bookmarks
```

## create django app

```bash
cd bookmarks/
django-admin startapp account
```

## reg django app

By placing our app first in the INSTALLED_APPS setting, 
we ensure that our authentication templates will be used by default instead of any other authentication templates contained in other apps.

```text
...
INSTALLED_APPS = [
'account.apps.AccountConfig',
# ...
]
...
```

## create sql script

```bash
python manage.py makemigrations
```

## exec sql script

```bash
python manage.py migrate
```

