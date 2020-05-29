FROM rapidsai/rapidsai:0.12-cuda9.2-runtime-ubuntu16.04
# CuPy is used for GPU-Accelerated UDFs
RUN conda run -n rapids pip install --no-cache cupy-cuda92
# Install system-level graphviz...
RUN conda run -n rapids apt-get update -y
RUN conda run -n rapids apt-get install -y graphviz \
    && rm -rf /var/lib/apt/lists/*
# ... and python library graphviz, both for Dask visualizations
RUN conda run -n rapids pip install --no-cache graphviz
# Update to latest jupyterlab and rebuild modules
RUN conda run -n rapids pip install --no-cache --upgrade jupyterlab
RUN conda run -n rapids jupyter lab build
# Create working directory to add repo.
WORKDIR /dli
# Load contents into student working directory.
ADD . .
# Create working directory for students.
WORKDIR /dli/task
# Jupyter listens on 8888.
EXPOSE 8888
# Please see `entrypoint.sh` for details on how this content
# is launched.
ADD entrypoint.sh /usr/local/bin
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
