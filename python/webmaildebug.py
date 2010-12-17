import asyncore, asynchat
import email
import re
import smtpd
import sqlite3
import socket, string
import StringIO, mimetools

# HTTP based on examples at http://effbot.org/librarybook/asynchat.htm
class HTTPChannel(asynchat.async_chat):

    def __init__(self, server, sock, addr):
        asynchat.async_chat.__init__(self, sock)
        self.server = server
        self.set_terminator("\r\n\r\n")
        self.header = None
        self.data = ""
        self.shutdown = 0

    def collect_incoming_data(self, data):
        self.data = self.data + data
        if len(self.data) > 16384:
            # limit the header size to prevent attacks
            self.shutdown = 1

    def found_terminator(self):
        if not self.header:
            # parse http header
            fp = StringIO.StringIO(self.data)
            request = string.split(fp.readline(), None, 2)
            if len(request) != 3:
                # badly formed request; just shut down
                self.shutdown = 1
            else:
                # parse message header
                self.header = mimetools.Message(fp)
                self.set_terminator("\r\n")
                self.server.handle_request(
                    self, request[0], request[1], self.header
                    )
                self.close_when_done()
            self.data = ""
        else:
            pass # ignore body data, for now

    def pushstatus(self, status, explanation="OK"):
        self.push("HTTP/1.0 %d %s\r\n" % (status, explanation))

class HTTPServer(asyncore.dispatcher):

    def __init__(self, sock,store, request=None):
        asyncore.dispatcher.__init__(self)
        self.sock = sock or ('',80)
        self.store = store
        if request:
            self.handle_request = request # external request handler
        self.create_socket(socket.AF_INET, socket.SOCK_STREAM)
        self.bind(sock)
        self.listen(5)

    def handle_accept(self):
        conn, addr = self.accept()
        HTTPChannel(self, conn, addr)

    def handle_request(self, channel, method, path, header):
        # silly copy/paste until I write a url dispatcher
        if path == '/':
            #message list
            channel.pushstatus(200, "OK")
            channel.push("Content-type: text/html\r\n")
            channel.push("\r\n")
            channel.push("ALL MESSAGES")
            channel.push("<table><th>To</th><th>From</th><th>Subject</th>")
            for row in self.store.fetch_all():
                id,peer,mailfrom,rcpttos,data = row
                subject = email.message_from_string(str(data))['subject']
                channel.push("<tr><td>{3}</td><td>{1}</td><td><a href='/view/{0}/'>{2}</a></td></tr>".format(id,mailfrom,subject,rcpttos))
            channel.push("</table>")
        elif path == '/reset/':
            #reset db
            channel.pushstatus(200, "OK")
            channel.push("Content-type: text/html\r\n")
            channel.push("\r\n")
            channel.push("MESSAGES RESET")
            self.store.clear_all()
        elif re.match('^/view/\d+/$|^/view/\d+/html/$',path):
            #view an invididual message, as text or html
            id = re.match('^/view/(\d+)/.*$',path).group(1)
            html = False
            if re.match('^/view/\d+/html/$',path):
                html = True
            data = self.store.fetch_index(id)
            if data:
                channel.pushstatus(200, "OK")
                if html:
                    channel.push("Content-Type: text/html; charset=utf-8\r\n")
                else:
                    channel.push("Content-Type: text/plain\r\n")
                channel.push("\r\n")
                message = email.message_from_string(str(data))
                channel.push(str(message))
            else:
                channel.pushstatus(404,"Not found")
                channel.push("\r\n")
                channel.push("Row with id = %s not found!" % id)
        else:
            channel.pushstatus(404,"Not found")
            channel.push("\r\n")
            channel.push("Can't find what you're looking for.")

class MailServer(smtpd.SMTPServer):
    def __init__(self,store,*args,**kwargs):
        smtpd.SMTPServer.__init__(self,*args,**kwargs)
        self.store = store

    def process_message(self,*args,**kwargs):
        self.store.insert(*args,**kwargs)
        print "mail saved."

class DataStore(object):
    def fetch_all(self):
        raise NotImplementedError
    def fetch_index(self,i):
        raise NotImplementedError
    def clear_all(self):
        raise NotImplementedError
    def insert(self,peer,mailfrom,rcpttos,data):
        raise NotImplementedError

class SqlStore(DataStore):
    """Uses SQLite to store messages"""
    def __init__(self,filename=None):
        """filename or None if using :memory:"""
        self.filename = filename or ':memory:'
        self.conn = sqlite3.connect(self.filename)
        self.c = self.conn.cursor()
        self.c.execute('CREATE TABLE IF NOT EXISTS mail (id INTEGER PRIMARY KEY,peer,mailfrom,rcpttos,data BLOB)')
    def fetch_all(self):
        return self.c.execute("SELECT * FROM mail").fetchall()
    def fetch_index(self,id):
        row = self.c.execute('SELECT data FROM mail WHERE id = ?',(id,)).fetchone()
        if row:
            return row[0]
        else:
            return None
    def clear_all(self):
        self.c.execute("DELETE FROM mail")
    def insert(self,peer,mailfrom,rcpttos,data):
        self.c.execute('INSERT INTO mail (peer,mailfrom,rcpttos,data) VALUES (?,?,?,?)',(str(peer),mailfrom,unicode(rcpttos),data))
        self.conn.commit()

class ListStore(DataStore):
    """Uses a Python list to store messages"""
    def __init__(self):
        self.counter = 0
        self.data = []
    def fetch_all(self):
        return self.data
    def clear_all(self):
        self.data = []
    def fetch_index(self,i):
        i = int(i)
        try:
            return self.data[i][4]
        except IndexError:
            return None
    def insert(self,peer,mailfrom,rcpttos,data):
        self.data.append((self.counter,str(peer),mailfrom,str(rcpttos),data))
        self.counter += 1

if __name__ == '__main__':
    store = SqlStore()
    #store = ListStore()
    MailServer(store,('',1025),None)
    HTTPServer(store=store,sock=('',5201))
    asyncore.loop()
