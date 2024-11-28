FROM tomcat:9.0.1-jre8-alpine

# Install necessary tools
RUN apk add --no-cache openjdk8

# Set the working directory
WORKDIR /app

# Copy the web application source code
COPY ./webapp /app/webapp

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
