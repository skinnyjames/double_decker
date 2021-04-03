FROM ruby:3.0

RUN gem install bundler

WORKDIR /double_decker
ADD . .
RUN bundle install

CMD ["irb"]

