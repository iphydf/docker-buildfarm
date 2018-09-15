FROM toxchat/buildfarm

COPY worker.config /config/
CMD java -Djava.util.logging.config.file=/config/logging.properties -jar /buildfarm-worker_deploy.jar /config/worker.config
