FROM ubuntu
WORKDIR /root
RUN apt-get update
RUN apt-get install -y curl git default-jdk
RUN curl -O https://hub.spigotmc.org/jenkins/job/BuildTools/lastSuccessfulBuild/artifact/target/BuildTools.jar
RUN java -jar BuildTools.jar
RUN cp spigot-*.jar spigot.jar