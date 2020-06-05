from flask import Flask, request, url_for, render_template, redirect
import sqlite3

def database_con():
    with sqlite3.connect("config/Database.db") as con:
        cur = con.cursor()
    return con

class Pages:

    def getPage(self, pageId):
        db = database_con()

        s = 'SELECT pageId, title, content FROM pages WHERE pageId=?'
        db.execute(s,pageId)

        return cur.fetchall()


app = Flask(__name__, static_url_path='/static', static_folder='static')
app.config['DEBUG'] = True


@app.route("/", methods=['GET'])
def home():
    return render_template("index.html")


@app.route("/home/<pageId>", methods=['GET'])
def inject(pageId):
    if pageId == 0:
        pageId = 1
    sqli  = Pages()
    values = sqli.getPage(pageId)
    id      = values[0][0]
    title   = values[0][1]
    content = values[0][2]
    return render_template("index.html",title = title, content = content, id = id)


if __name__ == "__main__":
    app.run(host='0.0.0.0')


#UNION SELECT 1,username,password FROM users
