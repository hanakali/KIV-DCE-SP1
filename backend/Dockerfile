#
# Simple backend server image
#

FROM ubuntu:24.04

WORKDIR /opt/backend

RUN pip3 install flask

COPY Python /opt/backend

CMD ["python3", "/opt/backend/simple-backend.py"]

# EOF