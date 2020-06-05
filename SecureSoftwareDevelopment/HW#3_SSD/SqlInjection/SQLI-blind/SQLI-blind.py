from flask import Flask, request, url_for, render_template, redirect

import sqlite3

def database_con():
    with sqlite3.connect("config/Database.db") as con:
        cur = con.cursor()
    return con

class Pages:

    def getPage(self, pageId):
        try:
            db = database_con()
            cur = db.execute('SELECT pageId, title, content FROM pages WHERE pageId=' + pageId)
            return cur.fetchone()
        except Exception as e:
            print(e)
            return None

app = Flask(__name__, static_url_path='/static', static_folder='static')
app.config['DEBUG'] = True


@app.route("/", methods=['GET'])
def home():
    return render_template("index.html")


@app.route("/home/<pageId>", methods=['GET'])
def inject(pageId):
    sqli = Pages()
    values = sqli.getPage(pageId)
    print(values)
    print(pageId)
    if values:
        if pageId == '1':
            return render_template("index.html",title = "The welcome page", content = "Some text about the welcome page is inserted here", id = 1)
        if pageId == '2':
            return render_template("index.html",title = "About", content = "Some text about the about page!", id = 2)
        if pageId == '3':
            return render_template("index.html",title = "Contact", content = "Some contact information is found here", id = 3) 
        return render_template("index.html")
    else:
        return render_template("404.html")

@app.route('/asdfg', defaults={'path': ''})
@app.route('/<path:path>')
def default(path):
    return render_template("404.html")

if __name__ == "__main__":
    app.run(host='0.0.0.0')



#UNION SELECT 1,username,password FROM users
