
#Build

FROM maven AS build

WORKDIR /opt/shipping

COPY pom.xml /opt/shipping/
RUN mvn dependency:resolve
COPY src /opt/shipping/src/
RUN mvn package
# CMD [ "java", "-Xmn256m", "-Xmx768m", "-jar", "target/shipping-*.jar" ]--> can be run like this also but unnecesary JDK env will be the image.

#
# Run
# this is jre based on alpine os
FROM openjdk:8-jre-alpine3.9

EXPOSE 8080

WORKDIR /opt/shipping

ENV CART_ENDPOINT=cart:8080
ENV DB_HOST=mysql

COPY --from=build /opt/shipping/target/shipping-1.0.jar shipping.jar 
# copying only shipping:1.0 jar as we dont want JDK env after build

CMD [ "java", "-Xmn256m", "-Xmx768m", "-jar", "shipping.jar" ]

# FROM maven AS build

# WORKDIR /opt/shipping

# COPY pom.xml /opt/shipping/
# RUN mvn dependency:resolve
# COPY src /opt/shipping/src/
# RUN mvn package
# RUN mv /opt/shipping/target/shipping-1.0.jar shipping.jar
# CMD [ "java", "-Xmn256m", "-Xmx768m", "-jar", "shipping.jar" ]
