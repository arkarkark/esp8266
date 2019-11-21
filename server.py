#!/usr/bin/env python3

import http.server
import os
import pathlib
import socketserver
import urllib.request

PORT = 1988
Handler = http.server.SimpleHTTPRequestHandler

IFTTT_KEY = pathlib.Path(".ifttt.key").read_text().strip()


class MyServer(socketserver.TCPServer):
    allow_reuse_address = True


class MyHandler(http.server.BaseHTTPRequestHandler):
    def do_GET(self):
        self.send_response(200)
        self.send_header("Content-type", "text/html")
        self.end_headers()
        # Send the html message
        self.wfile.write(b"Hello World !")
        return

    def do_POST(self):
        if "Content-Length" in self.headers:
            content_length = int(self.headers["Content-Length"])
            body = self.rfile.read(content_length)

            print("Received:\n%s" % body)

        self.send_response(200)
        self.send_header("Content-type", "text/html")
        self.end_headers()

        # Send the html message
        self.wfile.write(b"Hello I got your post !\n")
        # self.wfile.write(b"STAY AWAKE\n")

        # DO.. The.. Thing!

        os.system("say -v Karen beep")
        # os.system("say -v Karen you have mail")
        # https://www.thesoundarchive.com/play-wav-files.asp?sound=email/youGotmail.wav
        # os.system("afplay '%s'" % os.path.expanduser("~/Downloads/youGotmail.wav"))

        # ifttt_url = "https://maker.ifttt.com/trigger/mail/with/key/{}".format(IFTTT_KEY)
        # req = urllib.request.Request(ifttt_url)
        # urllib.request.urlopen(req)

        return


with MyServer(("", PORT), MyHandler) as httpd:
    print("serving at port", PORT)
    httpd.serve_forever()
