FROM ubuntu:12.04

MAINTAINER Mario Luan

ENV RUBY_VERSION 2.2.3

# install curl
RUN apt-get update -y
RUN apt-get install curl -y

# download rvm's necessary signatures
RUN gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3

# install ruby
RUN curl -sSL https://get.rvm.io | bash -s stable --ruby=${RUBY_VERSION}

# source rvm
RUN echo "source /usr/local/rvm/scripts/rvm" >> /etc/bash.bashrc

# install executables for bundler and rackup
RUN /bin/bash -l -c "gem install bundler --no-ri --no-rdoc"
RUN /bin/bash -l -c "gem install rack --no-ri --no-rdoc"

# sets the working directory
ADD . /app
WORKDIR /app

# install project's dependencies
RUN /bin/bash -l -c "bundle"

# default command executed for the underlying image
CMD /bin/bash -l -c "bundle exec rackup --host 0.0.0.0 -p 5000"

# server
EXPOSE 5000