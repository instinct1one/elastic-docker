FROM openjdk:11

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update
RUN apt-get install -y --no-install-recommends software-properties-common
ENV JAVA_HOME /usr/lib/jvm/java-11-openjdk-amd64/

RUN groupadd -g 1000 elasticsearch && useradd elasticsearch -u 1000 -g 1000

RUN apt-key adv --keyserver pgp.mit.edu --recv-keys 46095ACC8548582C1A2699A9D27D666CD88E42B4 && \
    add-apt-repository -y "deb http://packages.elastic.co/elasticsearch/2.x/debian stable main" --keyserver https://pgp.mit.edu/ && \
    apt-get update && \
    apt-get install -y --no-install-recommends elasticsearch

WORKDIR /usr/share/elasticsearch

RUN set -ex && for path in data logs config config/scripts; do \
        mkdir -p "$path"; \
        chown -R elasticsearch:elasticsearch "$path"; \
    done

COPY logging.yml /usr/share/elasticsearch/config/
COPY elasticsearch.yml /usr/share/elasticsearch/config/

VOLUME ["/usr/share/elasticsearch/data", "/usr/share/elasticsearch/logs"]

USER elasticsearch

ENV PATH=$PATH:/usr/share/elasticsearch/bin

CMD ["elasticsearch"]

EXPOSE 9200
EXPOSE 9300