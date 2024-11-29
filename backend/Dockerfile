#
# Simple backend server image
#

FROM python:3.13-slim

WORKDIR /opt/backend

RUN pip3 install flask

COPY python /opt/backend

CMD ["python", "/opt/backend/simple-backend.py"]

# EOF
