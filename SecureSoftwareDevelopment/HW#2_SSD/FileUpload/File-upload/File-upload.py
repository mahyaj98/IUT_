import os
from flask import Flask, request, redirect, url_for, render_template
from werkzeug.utils import secure_filename
from PIL import Image
import PyPDF2

app = Flask(__name__, static_url_path='/static', static_folder='static')

app.config['DEBUG'] = True

ALLOWED_EXTENSIONS = app.config['ALLOWED_EXTENSIONS'] = set(['txt', 'pdf', 'png', 'jpg', 'jpeg', 'html'])
NOT_ALLOWED_EXTENSIONS = app.config['NOT_ALLOWED_EXTENSIONS'] = set(['exe', 'py', 'php'])

def allowed_file(filename):
    s = '.' in filename and \
           filename.rsplit('.', 1)[1] in ALLOWED_EXTENSIONS
    if filename.rsplit('.', 1)[1] in ["png", "jpg", "jpeg"]:
        try:
            im = Image.open(filename)
        except IOError:
            return False
    if filename.rsplit('.', 1)[1] == "pdf":
        try:
            PyPDF2.PdfFileReader(open("testfile.txt", "rb"))
        except PyPDF2.utils.PdfReadError:
            return False
    for item in filename.rsplit('.')[1:]:
        if(item in NOT_ALLOWED_EXTENSIONS):
            return False
    return s


@app.route("/", methods=['GET', 'POST'])
def index():
    if request.method == 'POST':
        file = request.files['file']
        print(file)
        if file and allowed_file(file):
            filename = file.filename
            file.save(os.path.join('uploads/', filename))
            uploaded = "File was uploaded"
            return render_template("index.html",uploaded = uploaded)
        uploaded = "something went wrong!"
        return render_template("index.html",uploaded = uploaded)
    return render_template("index.html")

@app.errorhandler(404)
def page_not_found(e):
    return render_template("404.html")


if __name__ == "__main__":
    app.run(host='0.0.0.0')
