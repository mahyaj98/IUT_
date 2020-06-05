from flask import Flask, request, url_for, render_template, redirect, current_app
import os, urllib


app = Flask(__name__, static_url_path='/static', static_folder='static')
app.config['DEBUG'] = False

@app.route("/")
def start():
    return render_template("index.html")


@app.route("/home", methods=['POST'])
def home():
    filename1 = urllib.parse.unquote(request.form['filename'])
    read='Were you trying to LFI on me?'
    filename2 = urllib.parse.unquote(filename1)
    while filename1 != filename2:
        filename1 = filename2
        filename2 = urllib.parse.unquote(filename1)
        filename2=filename2.replace('../','')

    if os.path.isfile(current_app.root_path + '/' + filename1):
        with current_app.open_resource(filename1, "r") as f:
            read = f.read()
    return render_template("index.html", read=read)

@app.errorhandler(404)
def page_not_found(e):
    return render_template("404.html")


if __name__ == "__main__":
    app.run(host='0.0.0.0')
