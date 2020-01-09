FROM centos/python-27-centos7
LABEL maintainer="joel@spotx.tv"

USER root

# Java
RUN yum clean all && yum install -y java-1.7.0-openjdk
ENV JAVA_HOME /usr/lib/jvm/jre-openjdk
ENV PATH $JAVE_HOME/bin:$PATH

# Hadoop
RUN mkdir /usr/lib/hadoop && curl -s "https://archive.cloudera.com/cdh5/cdh/5/hadoop-2.6.0-cdh5.7.0.tar.gz" \
      | tar zx -C /usr/lib/hadoop --strip-components 1
ENV HADOOP_PREFIX /usr/lib/hadoop
ENV HADOOP_CONF_DIR $HADOOP_PREFIX/etc/hadoop
ENV HADOOP_CLASSPATH $HADOOP_PREFIX/share/hadoop/tools/lib/
ENV PATH $HADOOP_PREFIX/bin:$PATH

# Configure services
COPY core-site.xml $HADOOP_PREFIX/etc/hadoop/core-site.xml

ADD entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]
