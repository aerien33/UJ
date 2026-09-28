#!/usr/bin/python3
# -*- coding: UTF-8 -*-

'''
Aplikacja WSGI implementująca najważniejsze części
usługi REST dającej dostęp do bazy z danymi osób i psów.

Aplikacja nie potrafi sama stworzyć swojej bazy danych,
trzeba to zrobić przed jej uruchomieniem
'''

plik_bazy = './osoby.sqlite'

import re, sqlite3, urllib.parse

class OsobyApp:
    def __init__(self, environment, start_response):
        self.env = environment
        self.start_response = start_response
        self.status = '200 OK'
        self.headers = [ ('Content-Type', 'text/html; charset=UTF-8') ]
        self.content = b''

    def __iter__(self):
        try:
            self.route()
        except sqlite3.Error as e:
            s = 'SQLite error: ' + str(e)
            self.failure('500 Internal Server Error', s)
        n = len(self.content)
        self.headers.append( ('Content-Length', str(n)) )
        self.start_response(self.status, self.headers)
        yield self.content

    def failure(self, status, detail = None):
        self.status = status
        s = '<html>\n<head>\n<title>' + status + '</title>\n</head>\n'
        s += '<body>\n<h1>' + status + '</h1>\n'
        if detail is not None:
            s += '<p>' + detail + '</p>\n'
        s += '</body>\n</html>\n'
        self.content = s.encode('UTF-8')

    def route(self):
        n = int(self.env.get('CONTENT_LENGTH', 0) or 0)
        if self.env['REQUEST_METHOD'] in ['POST', 'PUT'] and n <= 0:
            self.failure('400 Bad Request')
            return

        if self.env['PATH_INFO'] == '/search':
            query = urllib.parse.parse_qs(self.env['QUERY_STRING'])
            keys = []
            vals = []

            for key, val in query.items():
                keys.append(key)
                vals.append(val)

            self.handle_search(keys, vals)
            return

        if self.env['PATH_INFO'] == '/osoby':
            self.handle_table("osoby")
            return

        m = re.search('^/osoby/(?P<id>[0-9]+)$', self.env['PATH_INFO'])
        if m is not None:
            self.handle_item("osoby", m.group('id'))
            return

        if self.env['PATH_INFO'] == '/psy':
            self.handle_table("psy")
            return

        m = re.search('^/psy/(?P<id>[0-9]+)$', self.env['PATH_INFO'])
        if m is not None:
            self.handle_item("psy", m.group('id'))
            return

        self.failure('404 Not Found')

    def handle_table(self, table):
        if self.env['REQUEST_METHOD'] == 'GET':
            colnames, rows = self.sql_select(table)
            self.send_rows(colnames, rows)
        elif self.env['REQUEST_METHOD'] == 'POST':
            colnames, vals = self.read_tsv()
            q = 'INSERT INTO ' + table + ' (' + ', '.join(colnames) + ') VALUES ('
            q += ', '.join(['?' for v in vals]) + ')'
            id = self.sql_modify(q, vals)
            colnames, rows = self.sql_select(table, id)
            self.send_rows(colnames, rows)
        else:
            self.failure('501 Not Implemented')

    def handle_search(self, keys, vals):
        if self.env['REQUEST_METHOD'] == 'GET':
            colnames, rows = self.sql_select_params("osoby", keys, vals)
            if len(rows) == 0:
                self.failure('404 Not Found')
            else:
                self.send_rows(colnames, rows)

    def handle_item(self, table, id):
        if self.env['REQUEST_METHOD'] == 'GET':
            colnames, rows = self.sql_select(table, id)
            if len(rows) == 0:
                self.failure('404 Not Found')
            else:
                self.send_rows(colnames, rows)
        elif self.env['REQUEST_METHOD'] == 'PUT':
            colnames, vals = self.read_tsv()
            q = 'UPDATE ' + table + ' SET '
            q += ', '.join([c + ' = ?' for c in colnames])
            q += ' WHERE id = ?'
            vals.append(id)
            self.sql_modify(q, vals)
            colnames, rows = self.sql_select(table, id)
            self.send_rows(colnames, rows)
        elif self.env['REQUEST_METHOD'] == 'DELETE':
            print("Deleting item with id = " + str(id) + " from table " + table)
            colnames, rows = self.sql_select(table, id)
            if len(rows) == 0:
                self.failure('404 Not Found')
            else:
                q = 'DELETE FROM ' + table + ' WHERE id = ' + id
                self.sql_modify(q)
        else:
            self.failure('501 Not Implemented')

    def read_tsv(self):
        f = self.env['wsgi.input']
        n = int(self.env['CONTENT_LENGTH'])
        raw_bytes = f.read(n)
        lines = raw_bytes.decode('UTF-8').splitlines()
        colnames = lines[0].split('\t')
        vals = lines[1].split('\t')
        return colnames, vals

    def send_rows(self, colnames, rows):
        s = '\t'.join(colnames) + '\n'
        for row in rows:
            s += '\t'.join([str(val) for val in row]) + '\n'
        self.content = s.encode('UTF-8')
        self.headers = [ ('Content-Type',
                'text/tab-separated-values; charset=UTF-8') ]

    def sql_select(self, table, id = None):
        conn = sqlite3.connect(plik_bazy)
        conn.execute("PRAGMA foreign_keys = ON")
        crsr = conn.cursor()
        query = 'SELECT * FROM ' + str(table)
        if id is not None:
            query += ' WHERE id = ?'
            crsr.execute(query, (id,))
        else:
            crsr.execute(query)
        colnames = [ d[0] for d in crsr.description ]
        rows = crsr.fetchall()
        crsr.close()
        conn.close()
        return colnames, rows

    def sql_select_params(self, table, keys, params):
        conn = sqlite3.connect(plik_bazy)
        conn.execute("PRAGMA foreign_keys = ON")
        crsr = conn.cursor()
        query = 'SELECT * FROM ' + table
        if len(keys) > 0 and len(params) > 0:
            query += ' WHERE '
        if keys is not None and params is not None:
            for i in range(0, len(keys)):
                if keys[i] is not None and params[i] is not None:
                    key = str(keys[i])
                    val = str(params[i][0])
                    if "'" in key or '"' in key or "'" in val or "'" in val:
                            crsr.close()
                            conn.close()
                            print("Error: Text cannot contain characters: '"' or '"'")
                            self.failure('400 Bad Request')
                    query += key + ' = "' + val + '"'
                if len(keys) > 1 and i < len(keys) - 1:
                    query += ' AND '

        crsr.execute(query)
        colnames = [d[0] for d in crsr.description]
        rows = crsr.fetchall()
        crsr.close()
        conn.close()
        return colnames, rows

    def sql_modify(self, query, params = None):
        conn = sqlite3.connect(plik_bazy)
        conn.execute("PRAGMA foreign_keys = ON")
        crsr = conn.cursor()
        if params is None:
            crsr.execute(query)
            print("Deleted items:")
            print(crsr.rowcount)
        else:
            crsr.execute(query, params)
        rowid = crsr.lastrowid
        crsr.close()
        conn.commit()
        conn.close()
        return rowid

if __name__ == '__main__':
    from wsgiref.simple_server import make_server
    port = 8000
    httpd = make_server('', port, OsobyApp)
    print('Listening on port %i, press ^C to stop.' % port)
    httpd.serve_forever()
