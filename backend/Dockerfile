#
# Simple backend server image
#

FROM python:3.13-slim

WORKDIR /opt/backend

RUN pip3 install --no-cache-dir flask

COPY python /opt/backend

CMD ["python3", "/opt/backend/simple-backend.py"]

# EOF
