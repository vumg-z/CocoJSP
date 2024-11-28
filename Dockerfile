FROM tomcat:9.0.1-jre8-alpine

# Install the JDK
RUN apk add --no-cache openjdk8

# Set JAVA_HOME and update PATH
ENV JAVA_HOME=/usr/lib/jvm/default-jvm
ENV PATH="${JAVA_HOME}/bin:${PATH}"

# Set the working directory
WORKDIR /app

# Verify that javac is available
RUN javac -version

# Copy the web application source code
COPY ./webapp /app/webapp

# Copy the Servlet API JAR from Tomcat
RUN cp /usr/local/tomcat/lib/servlet-api.jar /app

# Compile Java source files with Servlet API in classpath
RUN find /app/webapp/WEB-INF/classes -name "*.java" > sources.txt \
    && javac -cp /app/servlet-api.jar -d /app/webapp/WEB-INF/classes @sources.txt

# Remove Java source files (optional)
RUN find /app/webapp/WEB-INF/classes -name "*.java" -delete

# Remove default ROOT application
RUN rm -rf /usr/local/tomcat/webapps/ROOT

# Create the WAR file
RUN jar -cvf /usr/local/tomcat/webapps/ROOT.war -C /app/webapp .

# Clean up Tomcat work and temp directories
RUN rm -rf /usr/local/tomcat/work/* /usr/local/tomcat/temp/*

# Expose port 8080
EXPOSE 8080

# Start Tomcat
CMD ["catalina.sh", "run"]
