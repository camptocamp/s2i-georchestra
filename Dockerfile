# s2i-georchestra
FROM appuio/s2i-maven-java:latest

USER root
RUN yum -y update && yum -y install epel-release && yum -y update && yum -y install python-pip
RUN pip install jstools virtualenv
RUN ln -s /usr/lib64/python2.7/site-packages/jstools /usr/bin
RUN mkdir /tmp/deliverables && chown default:root /tmp/deliverables
ENV LC_ALL C.UTF-8

# openshift s2i specific
ENV BUILDER_VERSION 1.0
LABEL io.k8s.description="Platform for building geOrchestra" \
      io.k8s.display-name="geOrchestra 1.0.0"  \
      io.openshift.expose-services="8080:http" \
      io.openshift.tags="georchestra-builder" \
      io.openshift.s2i.destination="/tmp/s2i"

# sets io.openshift.s2i.scripts-url label that way, or update that label
COPY ./s2i/bin/ /usr/libexec/s2i

#RUN chown -R 1001:1001 /opt/app-root

USER 1001


# TODO: Set the default CMD for the image
# CMD ["/usr/libexec/s2i/usage"]
