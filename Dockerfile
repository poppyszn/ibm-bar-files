FROM ibmcom/ace-server:latest

USER root

COPY *.bar /home/aceuser/bars
RUN  chmod -R ugo+rwx /home/aceuser

USER root

RUN  chmod -R ugo+rwx /home/aceuser

USER 1000
