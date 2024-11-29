#
# Simple backend server image
#

FROM python:3.13-slim

WORKDIR /opt/backend

RUN pip install flask

COPY Python /opt/backend

CMD ["python", "/opt/backend/simple-backend.py"]

# EOF