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
      - .:/app
    ports:
      - 8000:8000
    depends_on:
      - db
  db: 
    container_name: mysql-db
    image: mysql:8.0.34
    restart: always
    volumes:
      - mysql_data:/var/lib/mysql
    env_file:
      - ./.env.dev
    environment:
      MYSQL_ROOT_PASSWORD: ${SQL_ROOT_PASSWORD}
      MYSQL_USER: ${SQL_USER}
      MYSQL_PASSWORD: ${SQL_PASSWORD}
      MYSQL_DATABASE: ${SQL_DATABASE}
    ports:
      - 3306:3306
volumes:
  mysql_data:

```
6. Run docker compose
```sh
docker compose --env-file .env.dev up --build -d
```

7. Run migration script
```sh
python3 manage.py migrate
```

8. Create super user
```sh
docker exec -it django-web python3 manage.py createsuperuser
```

9. Visit `http://localhost:8000` or `http://localhost:8000/admin`