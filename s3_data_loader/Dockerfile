FROM garland/aws-cli-docker:1.16.140

WORKDIR /var

ADD download_from_data_sources .
RUN chmod +x download_from_data_sources

CMD ./download_from_data_sources
