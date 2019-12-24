import sys

import psycopg2

config = {
    'database': 'nasa',
    'user': 'nasa',
    'password': '123456',
    'host': '10.148.217.77',
}


class Database(object):

    def __init__(self) -> None:
        self.__dsn = config
        self.connection = None
        self.cursor = None

    def get_connection(self):
        try:
            return psycopg2.connect(**self.__dsn)
        except psycopg2.DatabaseError as e:
            print(f'Database: {e}')
            sys.exit(1)

    def set_connection(self, value):
        self.connection = value

    def close_connection(self):
        if self.connection:
            self.connection.close()

    def get_cursor(self, connection=None, ):
        if connection is None:
            connection = self.get_connection()
        try:
            cur = connection.cursor()
            print(cur)
            return cur
        except psycopg2.DatabaseError as e:
            print(f'Database error: {e}')

    def set_cursor(self, value):
        self.cursor = value

    def close_cursor(self):
        if self.cursor:
            self.cursor.close()

    def execute(self, sql_stmt, _connection=None, _cursor=None, sql_data=None, auto_close=True,
                fetch_one=True, fetch_many=False, fetch_all=False, execute_many=False, auto_commit=False, ):

        if not _connection:
            connection = self.get_connection()
        else:
            connection = _connection()

        if not _cursor:
            cursor = connection.cursor()
        else:
            cursor = _cursor()

        try:
            if sql_data:
                if execute_many:
                    print(sql_stmt)
                    print(sql_data)
                    cursor.executemany(sql_stmt, sql_data)
                else:
                    cursor.execute(sql_stmt, sql_data)

            else:
                cursor.execute(sql_stmt)

            if auto_commit:
                connection.commit()

            if fetch_one:
                return cursor.fetchone()
            if fetch_many:
                return cursor.fetchmany(10)
            if fetch_all:
                return cursor.fetchall()
            else:
                return

        except psycopg2.DatabaseError as e:
            print(f'Database error: {e}')

        finally:
            if auto_close:
                if cursor:
                    cursor.close()
                if connection:
                    connection.close()
