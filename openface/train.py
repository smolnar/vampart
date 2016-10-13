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
    print message, ' ...',
    start = time.time()
    yield
    print 'done ({}s)'.format(time.time() - start)

def getFaces(path):
    name = re.search('(\w+)\.(jpg|png)\Z', path).group(1)
    faces = list()

    with measure('Reading %s' % name):
        image = cv2.imread(path)

    with measure('Detecting faces'):
        rgbImage = cv2.cvtColor(image, cv2.COLOR_BGR2RGB)
        boxes = align.getAllFaceBoundingBoxes(rgbImage)

    for i, box in enumerate(boxes):
        x1, y1, x2, y2 = (box.left(), box.top(), box.right(), box.bottom())

        if y2 - y1 >= 100:
            start = time.time()
            filename = '%s-%d.jpg' % (name, i)
            face = image[y1:y2, x1:x2]
            cv2.imwrite(os.path.join(facesPath, filename), face)

            with measure('Extracting face as %s' % filename):
                alignedFace = align.align(96, rgbImage, box, landmarkIndices = openface.AlignDlib.OUTER_EYES_AND_NOSE)

                if alignedFace is not None:
                    rep = neuralNet.forward(alignedFace)

                    faces.append({
                        'file': filename,
                        'representation': rep.tolist()
                    })

    return faces

with open(dataFile) as file:
    data = json.load(file)

    for artwork in data:
        imagePath = os.path.join(imagesPath, artwork['image'])
        faces = getFaces(imagePath)
        artwork['faces'] = faces

    file.close()

    json.dump(data, dataFile)
