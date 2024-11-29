#
# Simple backend server image
#

FROM python:3.8-slim

WORKDIR /opt/backend

RUN yum -q -y install python3
RUN pip3 install flask

COPY python /opt/backend

CMD ["python", "/opt/backend/simple-backend.py"]

# EOF