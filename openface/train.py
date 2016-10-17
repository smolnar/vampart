#!/usr/bin/env python2
#
# Example to compare the faces in two images.
# Brandon Amos
# 2015/09/29
#
# Copyright 2015-2016 Carnegie Mellon University
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

import time
import argparse
import cv2
import itertools
import os
import numpy as np
import json
import re
from contextlib import contextmanager

np.set_printoptions(precision = 2)

import openface

fileDir = os.path.dirname(os.path.realpath(__file__))
modelDir = os.path.join(fileDir, '..', 'models')
dlibModelDir = os.path.join(modelDir, 'dlib')
openfaceModelDir = os.path.join(modelDir, 'openface')
dataFile = os.path.join(fileDir, './data.json')
imagesPath = os.path.join(fileDir, 'storage/images')
facesPath = os.path.join(fileDir, 'storage/faces')

align = openface.AlignDlib(os.path.join(dlibModelDir, "shape_predictor_68_face_landmarks.dat"))
neuralNet = openface.TorchNeuralNet(os.path.join(openfaceModelDir, 'nn4.small2.v1.t7'), 96)

@contextmanager
def measure(message):
    print message, '...',
    start = time.time()
    yield
    print 'done ({}s)'.format(time.time() - start)

def getFaces(path):
    name = re.search('(\w+)\.(jpg|png)\Z', path).group(1)
    faces = list()
    image = cv2.imread(path)

    with measure('Detecting faces'):
        rgbImage = cv2.cvtColor(image, cv2.COLOR_BGR2RGB)
        boxes = align.getAllFaceBoundingBoxes(rgbImage)

    for i, box in enumerate(boxes):
        x1, y1, x2, y2 = (box.left(), box.top(), box.right(), box.bottom())

        if y2 - y1 >= 100:
            filename = '%s-%d.jpg' % (name, i)

            with measure('Extracting face as %s' % filename):
                face = image[y1:y2, x1:x2]
                cv2.imwrite(os.path.join(facesPath, filename), face)

                alignedFace = align.align(96, rgbImage, box, landmarkIndices = openface.AlignDlib.OUTER_EYES_AND_NOSE)

                if alignedFace is not None:
                    rep = neuralNet.forward(alignedFace)

                    faces.append({
                        'file': filename,
                        'model': rep.tolist()
                    })

    return faces

with open(dataFile) as file:
    data = json.load(file)

    for i, artwork in enumerate(data):
        print('Processing image %d of %d: %s' % (i + 1, len(data), artwork['image_url']))

        imagePath = os.path.join(imagesPath, artwork['image'])
        faces = getFaces(imagePath)
        artwork['faces'] = faces

with open(dataFile, 'w') as file:
    json = json.dumps(data, indent=4, separators=(',', ': '))

    file.write(json)
