
FROM tomcat:latest

RUN rm -rf /usr/local/tomcat/webapps/*

COPY target/*.jar /usr/local/tomcat/webapps/ROOT.jar

EXPOSE 8080

CMD ["catalina.sh", "run"]
