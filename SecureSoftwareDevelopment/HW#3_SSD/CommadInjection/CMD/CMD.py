import os
try:
    import Image
except ImportError:
    from PIL import Image
from flask import Flask, request, url_for, render_template, redirect


app = Flask(__name__, static_url_path='/static', static_folder='static')
app.config['DEBUG'] = True

@app.route("/")
def start():
    return render_template("index.html")


@app.route("/home", methods=['POST'])
def home():
    sizeImg = request.form['size']
    if sizeImg in ['50', '150']:
        print(sizeImg)
        image = Image.open("./static/img/bones.png")
        width, height = image.size
        print(width, height)
        os.system('convert ./static/img/bones.png -resize '+sizeImg+'% ./static/img/bones.png')
        image = Image.open("./static/img/bones.png")
        width, height = image.size
        print(width, height)
        return render_template("index.html")
    else:
        print("Command Injection detected")
        return render_template("index.html")




if __name__ == '__main__':
    app.run(host='0.0.0.0')

