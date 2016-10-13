FROM bamos/openface
MAINTAINER Samuel Molnar <molnar.samuel@gmail.com>

RUN pip install flask

ADD ./openface /root/openface/vampart
