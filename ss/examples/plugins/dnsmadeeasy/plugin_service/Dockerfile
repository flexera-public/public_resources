FROM  ruby:2.1-onbuild 

RUN git clone https://github.com/rightscale/public_resources.git

WORKDIR /usr/src/app/public_resources/ss/examples/plugins/dnsmadeeasy/

RUN git checkout dockerize_dme

RUN bundle install

EXPOSE 8088

# overwrite this with 'CMD []' in a dependent Dockerfile
CMD ["rackup","-p","8088"]

