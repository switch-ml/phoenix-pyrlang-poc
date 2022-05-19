FROM python:latest

RUN apt-get update \
    && curl https://sh.rustup.rs -sSf > /tmp/rustup-init.sh \
    && chmod +x /tmp/rustup-init.sh \
    && sh /tmp/rustup-init.sh -y \
    && rm -rf /tmp/rustup-init.sh \
    && apt-get install erlang-base -y

ENV PATH="/root/.cargo/bin:${PATH}"

ENV APP_HOME /app

RUN mkdir -p $APP_HOME

COPY . /app

WORKDIR $APP_HOME

RUN pip install -r requirements.txt

CMD [ "sh", "-c", "tail -f /dev/null" ]