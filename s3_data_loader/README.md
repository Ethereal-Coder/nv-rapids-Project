# S3 Data Loader for DLI Content

This repo builds a container which is intended to be used as a sidecar to DLI content containers. It asynchronously downloads data located in S3 to a volume which is also shared by the content container. It will only download data that is not already present.

## Usage As a Sidecar Container with Content

Add a `s3_data_loader` service to the content's `docker-compose.yml` which:

- Uses the image `224292665285.dkr.ecr.us-east-1.amazonaws.com/s3_data_loader:latest` which is built from the `Dockerfile` in this repo.
- Mounts 3 volumes:
  1) The `$HOME/.aws/credentials` from the host machine, into this container, which allows it access to the S3 buckets it needs to download from
  2) The `task/data_sources` file, which lives in the content and lists all S3 assets that should be downloaded.
  3) The host `./task/data`, which the content container will read from, into `/data` which is the data destination inside this container.

Here is an example `docker-compose.yml` with a content container that also uses the `s3_data_loader` as a sidecar. Please read the comments.

```
version: '2.3'

services:

  # This `lab` service will be a content container. `image` will change depending on the actual content.
  lab:
    image: 224292665285.dkr.ecr.us-east-1.amazonaws.com/c-ds-02-v1:v1.2.1

    volumes:
      # The s3_data_loader service will download data entities described in
      # /task/data_sources to the shared volume `data` which is made available
      # to students in `/dli/task/data` here via the shared `data` volume.
      - ./task/data:/dli/task/data

  s3_data_loader:

    image: 224292665285.dkr.ecr.us-east-1.amazonaws.com/s3_data_loader:latest

    volumes:
      # Mount AWS credentials to give access to S3 buckets.
      - $HOME/.aws/credentials:/root/.aws/credentials:ro

      # Mount `data_sources` into `/var/data_sources` so the container knows what to download.
      - ./task/data_sources:/var/data_sources

      # Mount the shared `./task/data` volume into `/data` where this container will download the data,
      # and where the content container will be able to read it.
      - ./task/data:/data

```

## Building the s3_data_loader Docker Image

1) Clone this repo
2) Run `docker build -t 224292665285.dkr.ecr.us-east-1.amazonaws.com/s3_data_loader .`
3) Run `docker push 224292665285.dkr.ecr.us-east-1.amazonaws.com/s3_data_loader`. You may need to login to AWS via the command line first.
