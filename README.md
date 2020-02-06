# VampArt

[![Build Status](https://travis-ci.org/smolnar/vampart.svg?branch=master)](https://travis-ci.org/smolnar/vampart)

How vampire are you? A machine-learning/art data project initiated during [Art Data Hackathon](a href="http://hackathon.sng.sk/") and kindly using artworks from the [Slovak National Gallery](http://www.sng.sk) and [Nasjonalmuseet collections](http://www.nasjonalmuseet.no/) to find your look-alikes in historical artworks.


## Requirements

* PostgreSQL
* Docker
* Ruby

## Running

Run `docker-compose up` followed by `docker-compose exec web rails db:setup` to start things up and initialize your database.

In order to update the data and download all the new images, run `bin/update`.

**Note**: *Bear in mind that updating the data requires a a lot of CPU power, so don't hesitate to jack up the performance of your Docker VM.*

## License

**Artworks**:

Please, refer to respective websites of galleries for more information on license. All of the artworks are used purely for non-commercial and research activities in scope of this project. We own and guarantee nothing :scream:.

**Source Code:**

MIT License

Copyright (c) 2016 Samuel Molnár, Pavol Truben, Matej Lukášik, Ľubomír Fundarek

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
