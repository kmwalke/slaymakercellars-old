FROM ruby:2.6.5
RUN apt-get update -qq && apt-get install -y nodejs postgresql-client
RUN mkdir /slaymakercellars
WORKDIR /slaymakercellars
RUN gem install bundler:2.0.2
COPY Gemfile /slaymakercellars/Gemfile
COPY Gemfile.lock /slaymakercellars/Gemfile.lock
RUN bundle install
COPY . /slaymakercellars

# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

# Start the main process.
CMD ["rails", "server", "-b", "0.0.0.0"]