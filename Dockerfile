# s2i-georchestra
FROM openshift/base-centos7

MAINTAINER Marc Sutter <marc.sutter@camptocamp.com>

ENV MAVEN_VERSION=3.5.3 \
    BUILDER_VERSION=1.0

# Docker Image Metadata
LABEL io.k8s.description="Platform for building geOrchestra" \
      io.k8s.display-name="geOrchestra 1.0.0"  \
      io.openshift.expose-services="8080" \
      io.openshift.tags="georchestra-builder" \
      io.openshift.s2i.destination="/tmp" \
      org.jboss.deployments-dir="/deployments"

# Update Packages
RUN yum -y update

# Install Java
RUN INSTALL_PKGS="java-1.8.0-openjdk java-1.8.0-openjdk-devel" && \
    yum install -y $INSTALL_PKGS && \
    rpm -V $INSTALL_PKGS

# Install Maven
RUN wget -q http://www-eu.apache.org/dist/maven/maven-3/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.tar.gz && \
    mkdir /opt/maven && \
    tar xzf apache-maven-${MAVEN_VERSION}-bin.tar.gz -C /opt/maven && \
    rm apache-maven-${MAVEN_VERSION}-bin.tar.gz && \
    ln -s /opt/maven/apache-maven-${MAVEN_VERSION}/bin/mvn /usr/local/bin/mvn

# Install EPEL repo
RUN yum -y install epel-release

# install python pip and self update
RUN yum -y install python-pip tree && \
    pip install --upgrade pip

# install build tree for output
RUN yum -y install python-pip tree

# cleanup yum
RUN yum clean all -y

# Install Python tools 
RUN pip install jstools virtualenv

# Linnk Python executables
RUN ln -s /usr/lib64/python2.7/site-packages/jstools /usr/bin

# Make folder for deliverables
RUN mkdir /tmp/deliverables

# S2I scripts
COPY ./s2i/bin/ /usr/libexec/s2i

# Set permissions
RUN chown -R 1001:1001 /opt/app-root && \
    chown -R 1001:1001 /tmp/deliverables

USER 1001

EXPOSE 8080

CMD ["/usr/libexec/s2i/usage"]

