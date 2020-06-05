import base64
from time import gmtime, strftime
from flask import Flask, request, url_for, render_template, redirect, make_response
import requests
import sqlite3

def database_con():
    with sqlite3.connect("Database.db") as con:
        cur = con.cursor()
    return con

class Classes:

    def getUser(self, username):
        db = database_con()
        cur = db.execute('SELECT UserId, Username, Password FROM users WHERE Username= ?',
                         [username])
        return cur.fetchall()

    def getColor(self, userId):
        db = database_con()
        cur = db.execute('SELECT Color FROM prefs WHERE UserId=?',
                         [userId])
        return cur.fetchall()

    def updateColor(self, color, userId):
        db = database_con()
        cur = db.execute('UPDATE prefs SET Color=? WHERE UserId=?',
                         [color, userId])
        db.commit()
        return cur.fetchall()



app = Flask(__name__, static_url_path='/static', static_folder='static')

app.config['DEBUG'] = True

@app.route("/")
def start():
    time = strftime("%H:%M", gmtime())
    csrf = "admin" + time
    csrf_raw = base64.b64encode(csrf.encode())
    csrf_token = str(csrf_raw, 'utf-8')
    return render_template("evil.html", csrf_token = csrf_token)

if __name__ == "__main__":
    app.run(host='0.0.0.0', port=1337)
	

