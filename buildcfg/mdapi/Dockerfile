FROM registry.fedoraproject.org/fedora:36

LABEL maintainer "Akashdeep Dhar <t0xic0der@fedoraproject.org>"

# Different intermediate container images are labelled in order for them to be cleaned up after a successful build
LABEL stage=builder
LABEL build=mdapi-build

# Ensuring that the output from the Python codebase (i.e. stdout and stderr) are sent directly to the container logs
# Ref. https://stackoverflow.com/a/59812588 
ENV PYTHONBUFFERED=1

# Setting up the default working directory for the code repository to be cloned into
WORKDIR /code/

# Installing the necessary dependencies and setting up a local instance of the specified remote repository
RUN dnf -y update --setopt=install_weak_deps=False
RUN dnf -y install git poetry python3-pip python3-tox --setopt=install_weak_deps=False
RUN dnf -y clean all
RUN git clone https://github.com/fedora-infra/mdapi.git /code/
RUN git checkout develop

# Copying the build script after cloning is complete as Git does not allow cloning into non-empty directories
COPY /home/alcphost/buildcfg/mdapi/runbuild.sh /code/

# Instantiating the container from the image without any executable would default to running the build script
ENTRYPOINT ["sh", "/code/runbuild.sh"]
