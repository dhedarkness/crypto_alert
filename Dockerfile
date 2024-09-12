# Use the official Ruby image from Docker Hub
FROM ruby:3.2

# Install dependencies
RUN apt-get update -qq && apt-get install -y nodejs postgresql-client

# Set the working directory
WORKDIR /app

# Copy the Gemfile and Gemfile.lock to the container
COPY Gemfile Gemfile.lock ./

# Install gems
RUN bundle install

# Copy the rest of the app's source code
COPY . .

# Precompile assets (optional, needed for production)
# RUN bundle exec rake assets:precompile

# Expose port 3000 for the Rails app
EXPOSE 3000

# Start the Rails server
CMD ["rails", "server", "-b", "0.0.0.0"]
