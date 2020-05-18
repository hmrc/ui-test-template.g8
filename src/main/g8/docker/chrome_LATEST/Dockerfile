#Update this version periodically to match the browser version running in CI pipeline
FROM selenium/standalone-chrome-debug:3.141.59-zirconium

USER root

# Install apt packages
RUN apt-get -y update
RUN apt-get -y install rinetd

USER seluser

COPY sidecar-wrapper.sh /opt/bin/sidecar-wrapper.sh

ENTRYPOINT ["/bin/bash", "/opt/bin/sidecar-wrapper.sh"]