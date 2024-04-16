# Using python image with alpine tag
FROM python:3.9-alpine3.13

# specifies who maintains this repository
LABEL maintainer="kshitijshah95@gmail.com"

# does not buffer the logs and displays immediately to the terminal
ENV PYTHONUNBUFFERED 1

# copies local file to tmp folder in image container
COPY ./requirements.txt /tmp/requirements.txt
COPY ./requirements.dev.txt /tmp/requirements.dev.txt
# copy app dir - contains logic code
COPY ./app /app
# working directory - default directory from where the commands are going to be run from, sets base path
WORKDIR /app
# exposes port 8000 from the container to machine
EXPOSE 8000

ARG DEV=false

# runs a command
# && \ helps break commands on multiple lines
# creates virtual environment
RUN python -m venv /py && \
# upgrades python package manager pip
    /py/bin/pip install --upgrade pip && \
#installs dependencies
    /py/bin/pip install -r /tmp/requirements.txt && \
    if [ $DEV = "true" ]; \
        then /py/bin/pip install -r /tmp/requirements.dev.txt ; \
    fi && \
# Remove temporary files    
    rm -rf /tmp && \
# adds a new user inside the image
    adduser \
        --disabled-password \
        --no-create-home \
        django-user

# Set Env var PATH - prepends /py/bin to any executable commands       
ENV PATH="/py/bin:$PATH"

# defines the user we are switching to
USER django-user
