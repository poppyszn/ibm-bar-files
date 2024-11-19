FROM preciousokpor/ibm-ace-integration-server:12.0.12.0

# Switch to root user for setup
USER root

# Copy BAR files into the container
COPY *.bar /tmp/

ENV LICENSE=accepet

# Compile the BAR files
RUN bash -c ' \
    set -x && \
    . /opt/IBM/ace-12/server/bin/mqsiprofile \
    && set -x && for FILE in /tmp/*.bar; do \
       echo "$FILE" >> /tmp/deploys && \
       ibmint package --compile-maps-and-schemas --input-bar-file "$FILE" --output-bar-file /tmp/temp.bar  2>&1 | tee -a /tmp/deploys && \
       ibmint deploy --input-bar-file /tmp/temp.bar --output-work-directory /home/aceuser/ace-server/ 2>&1 | tee -a /tmp/deploys; done \
    && ibmint optimize server --work-dir /home/aceuser/ace-server'

# Ensure permissions are set correctly
RUN chmod -R ugo+rwx /home/aceuser && \ 
    chmod -R ugo+rwx /var/mqsi/

# Switch back to non-root user for runtime
USER 1001
