FROM tomcat:8.0
MAINTAINER parushaSingla
COPY target/devopssampleapplication.war /usr/local/tomcat/webapps/parushasingla.war
CMD /usr/local/tomcat/bin/catalina.sh run 