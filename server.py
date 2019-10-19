#!/usr/bin/env python3

import os
import http.server
import socketserver

PORT = 8080
Handler = http.server.SimpleHTTPRequestHandler


class MyServer(socketserver.TCPServer):
    allow_reuse_address = True


class MyHandler(http.server.BaseHTTPRequestHandler):

    # Handler for the GET requests
    def do_GET(self):
        self.send_response(200)
        self.send_header("Content-type", "text/html")
        self.end_headers()
        # Send the html message
        self.wfile.write(b"Hello World !")
        return

    def do_POST(self):
        content_length = int(self.headers["Content-Length"])
        body = self.rfile.read(content_length)

        print("Received:\n%s" % body)
        self.send_response(200)
        self.send_header("Content-type", "text/html")
        self.end_headers()

        # Send the html message
        self.wfile.write(b"Hello I got your post !\n")
        self.wfile.write(b"STAY AWAKE\n")
        os.system("say -v Karen you have mail")
        return


with MyServer(("", PORT), MyHandler) as httpd:
    print("serving at port", PORT)
    httpd.serve_forever()
