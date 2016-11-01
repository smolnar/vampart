from flask import Flask
from flask import request
from flask.json import jsonify
from core import getFaces
import os

app = Flask(__name__)
fileDir = os.path.dirname(os.path.realpath(__file__))

@app.route('/')
def getFacialModels():
    path = request.args.get('path')
    imagePath = os.path.join(fileDir, path)
    faces = getFaces(imagePath, save = False)

    return jsonify(faces)

if __name__ == "__main__":
    app.run(host = '0.0.0.0', port = 1337, threaded = True)
