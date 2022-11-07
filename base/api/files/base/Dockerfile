FROM ruby:2.7.2

WORKDIR /app

RUN apt-get update -qq && apt-get install -y build-essential

COPY ./#name/src/Gemfile ./
COPY ./Rakefile ./
RUN bundle install

COPY ./#name/src .
COPY ./common ./lib/common
COPY ./entrypoint.sh /usr/bin
RUN chmod +x /usr/bin/entrypoint.sh

RUN git clone https://github.com/coeusit/grace.git
RUN mv grace/fw ./lib/fw
RUN rm -rf grace

ENTRYPOINT ["entrypoint.sh"]
