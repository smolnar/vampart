FROM bamos/openface
MAINTAINER Samuel Molnar <molnar.samuel@gmail.com>

RUN pip install flask conditional

WORKDIR /root/openface/vampart

COPY . .

CMD python api.py
EXPOSE 1337
