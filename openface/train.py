from core import getFaces
import os
import json

fileDir = os.path.dirname(os.path.realpath(__file__))
dataFile = os.path.join(fileDir, './data.json')
imagesPath = os.path.join(fileDir, 'storage/images')

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
