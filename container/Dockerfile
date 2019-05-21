FROM ubuntu:16.04

# install curl, Open JDK
RUN set -x \
	&& apt-get update && apt-get install -y \
	curl \
	unzip \
	openjdk-8-jre-headless \
	&& rm -rf /var/lib/apt/lists/*

ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64
WORKDIR /soda

# download and extract Tomcat to '/opt/tomcat' and remove the admin tools
RUN curl -O https://www-eu.apache.org/dist/tomcat/tomcat-8/v8.5.41/bin/apache-tomcat-8.5.41.tar.gz \
	&& mkdir /opt/tomcat \
	&& tar xvf apache-tomcat-8*tar.gz -C /opt/tomcat --strip-components=1 \
	&& rm apache-tomcat-8*tar.gz \
	&& rm -rf /opt/tomcat/webapps/docs \
	&& rm -rf /opt/tomcat/webapps/examples \
	&& rm -rf /opt/tomcat/webapps/host-manager \
	&& rm -rf /opt/tomcat/webapps/manager \
	&& rm -rf /opt/tomcat/webapps/ROOT

# download and put the MySQL driver into the tomcat libraries
RUN curl -O https://cdn.mysql.com//Downloads/Connector-J/mysql-connector-java-5.1.47.tar.gz \
	&& mkdir connector-j \
	&& tar xvf mysql-connector-java-*.tar.gz -C connector-j --strip-components=1 \
	&& mv connector-j/mysql-connector-*.jar /opt/tomcat/lib \
	&& rm -rf connector-j \
	&& rm mysql-connector-java-*.tar.gz

# copy the webapp
COPY Node.war .
RUN mkdir -p /opt/tomcat/webapps/ROOT \
	&& unzip Node.war -d /opt/tomcat/webapps/ROOT \
	&& rm Node.war
COPY home.html /opt/tomcat/webapps/ROOT/templates/default/html
COPY logo.png /opt/tomcat/webapps/ROOT/templates/default/images

# copy configuration files
COPY server.xml /opt/tomcat/conf
COPY soda4LCA.properties /opt/tomcat/conf
COPY web.xml /opt/tomcat/conf

# create upload and data folders
RUN mkdir -p /opt/soda/data/datafiles \
	&& mkdir -p /opt/soda/data/validation_profiles \
	&& mkdir -p /opt/soda/data/tmp/uploads \
	&& mkdir -p /opt/soda/data/tmp/zips

# adding the startup script
COPY start.sh /soda
RUN chmod +x start.sh

EXPOSE 8080

# sudo docker run -it --rm -p 80:8080 soda
CMD [ "/soda/start.sh" ]
