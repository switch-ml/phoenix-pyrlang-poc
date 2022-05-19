FROM python:latest

ENV APP_HOME /app

RUN mkdir -p $APP_HOME

COPY . /app

WORKDIR $APP_HOME

RUN pip install -r requirements.txt

CMD [ "sh", "-c", "tail -f /dev/null" ]