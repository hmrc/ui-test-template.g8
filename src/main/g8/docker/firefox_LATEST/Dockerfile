#Update this version periodically to match the browser version running in CI pipeline
FROM selenium/standalone-firefox-debug:3.141.59-20200326

USER root

# Install apt packages
RUN apt-get -y update
RUN apt-get -y install rinetd

USER seluser

COPY sidecar-wrapper.sh /opt/bin/sidecar-wrapper.sh

ENTRYPOINT ["/bin/bash", "/opt/bin/sidecar-wrapper.sh"]