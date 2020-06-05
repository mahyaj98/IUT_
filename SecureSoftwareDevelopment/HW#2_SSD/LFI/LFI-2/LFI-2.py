from flask import Flask, request, url_for, render_template, redirect, current_app
import os


app = Flask(__name__, static_url_path='/static', static_folder='static')
app.config['DEBUG'] = False

@app.route("/")
def start():
    return render_template("index.html")


@app.route("/home", methods=['POST'])
def home():
    filename = request.form['filename']
    filename=filename.replace('../','')
    if os.path.isfile(current_app.root_path + '/' + filename):
        with current_app.open_resource(filename, "r") as f:
            read = f.read()
    else: 
        read='Were you trying to LFI on me?'
    return render_template("index.html",read = read)

if __name__ == "__main__":
    app.run(host='0.0.0.0')
