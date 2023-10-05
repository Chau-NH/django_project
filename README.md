# DJANGO and DOCKER

### Prerequisite
- Install Docker
- Install Python 3.x
- Install PIP

### Django Set Up
1. Install Django by using PIP
```sh
pip install django~=4.2.0
```

2. Start new project on Local
```sh
django-admin startproject django_project .
python manage.py migrate
python manage.py runserver
```

3. Export packages from local machine
```sh
pip freeze > requirements.txt
```

4. Create Dockerfile
```Dockerfile
# Pull base image
FROM python:3.11.5-slim-bullseye

# Environment variables
ENV PIP_DISABLE_PIP_VERSION_CHECK 1 
ENV PYTHONDONTWRITEBYTECODE 1 
ENV PYTHONUNBUFFERED 1

# Set environment variables
WORKDIR /code

# Install dependencies
COPY ./requirements.txt .
RUN pip install -r requirements.txt

# Copy project
COPY . .

CMD python3 manage.py runserver 0.0.0.0:8000
```

5. Create docker-compose.yml file
```yml
version: '3.0'
services:
  web:
    container_name: python-web
    build:
      context: .
      dockerfile: Dockerfile
    volumes:
      - .:/code
    ports:
      - 8000:8000
    depends_on:
      - db
  db:
    container_name: postgres-db
    image: postgres:14
    volumes:
      - postgres_data:/var/lib/postgresql/data/
    ports:
      - 5432:5432
    environment:
      - "POSTGRES_HOST_AUTH_METHOD=trust"

volumes:
  postgres_data:

```

6. Run migration script
```sh
python3 manage.py migrate
```