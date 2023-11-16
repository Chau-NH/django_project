# Pull base image
FROM python:3.11.5-slim-bullseye

# Environment variables
ENV PIP_DISABLE_PIP_VERSION_CHECK 1 
ENV PYTHONDONTWRITEBYTECODE 1 
ENV PYTHONUNBUFFERED 1

# Install mysql extensions
RUN apt-get update
RUN apt-get install gcc default-libmysqlclient-dev -y

# Set working directory
WORKDIR /app

# Install dependencies
COPY ./requirements.txt .
RUN pip install -r requirements.txt

# Copy project
COPY . .

CMD python3 manage.py runserver 0.0.0.0:8000