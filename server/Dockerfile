FROM toxchat/buildfarm

COPY server.config /config/
CMD java -Djava.util.logging.config.file=/config/logging.properties -jar /buildfarm-server_deploy.jar /config/server.config
