ARG IMAGE=intersystemsdc/iris-community:latest
FROM $IMAGE

USER root

# Update package and install sudo
RUN apt-get update && apt-get install -y


WORKDIR /irisdev/app
RUN chown ${ISC_PACKAGE_MGRUSER}:${ISC_PACKAGE_IRISGROUP} /irisdev/app
USER ${ISC_PACKAGE_MGRUSER}

## Python stuff
ENV IRISUSERNAME "SuperUser"
ENV IRISPASSWORD "SYS"
ENV IRISNAMESPACE "USER"

ENV PYTHON_PATH=/usr/irissys/bin/

ENV PATH "/usr/irissys/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/home/irisowner/bin"

COPY . .
COPY iris.script /tmp/iris.script

RUN pip3 install -r requirements.txt

RUN iris start IRIS \
	&& iris session IRIS < /tmp/iris.script \
    && iris stop IRIS quietly
