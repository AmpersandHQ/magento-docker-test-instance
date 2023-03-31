list: 					        # Lists all available commands
	printf "\n"; grep -v -e "^\t" Makefile | grep . | grep -Ev 'CURRENT_EXTENSION|list|docker-start|ENV' | awk -F":.+?#" '{ print $$1 " #" $$2 }' | column -t -s '#';

CURRENT_EXTENSION ?= '/dev/null'

2-3-7:			 # Launch 2.3.7
	MAGE_VERSION="2.3.7" PHP_VERSION='7.4.29' COMPOSER_VERSION='composer22' MYSQL_VERSION="mysql:5.7.41-debian" ELASTICSEARCH_VERSION='docker.elastic.co/elasticsearch/elasticsearch:7.9.0' ELASTICSEARCH_OPTIONS='' MAGENTO_PORT=1234 CURRENT_EXTENSION=$(CURRENT_EXTENSION) make docker-start

2-3-7-p1:		 # Launch 2.3.7-p1
	MAGE_VERSION="2.3.7-p1" PHP_VERSION='7.4.29' COMPOSER_VERSION='composer22' MYSQL_VERSION="mysql:5.7.41-debian" ELASTICSEARCH_VERSION='docker.elastic.co/elasticsearch/elasticsearch:7.9.0' ELASTICSEARCH_OPTIONS='' MAGENTO_PORT=1234 CURRENT_EXTENSION=$(CURRENT_EXTENSION) make docker-start

2-3-7-p2:		 # Launch 2.3.7-p2
	MAGE_VERSION="2.3.7-p2" PHP_VERSION='7.4.29' COMPOSER_VERSION='composer22' MYSQL_VERSION="mysql:5.7.41-debian" ELASTICSEARCH_VERSION='docker.elastic.co/elasticsearch/elasticsearch:7.9.0' ELASTICSEARCH_OPTIONS='' MAGENTO_PORT=1234 CURRENT_EXTENSION=$(CURRENT_EXTENSION) make docker-start

2-3-7-p3:		 # Launch 2.3.7-p3
	MAGE_VERSION="2.3.7-p3" PHP_VERSION='7.4.29' COMPOSER_VERSION='composer22' MYSQL_VERSION="mysql:5.7.41-debian" ELASTICSEARCH_VERSION='docker.elastic.co/elasticsearch/elasticsearch:7.9.0' ELASTICSEARCH_OPTIONS='' MAGENTO_PORT=1234 CURRENT_EXTENSION=$(CURRENT_EXTENSION) make docker-start

2-3-7-p4:		 # Launch 2.3.7-p4
	MAGE_VERSION="2.3.7-p4" PHP_VERSION='7.4.29' COMPOSER_VERSION='composer22' MYSQL_VERSION="mysql:5.7.41-debian" ELASTICSEARCH_VERSION='docker.elastic.co/elasticsearch/elasticsearch:7.9.0' ELASTICSEARCH_OPTIONS='' MAGENTO_PORT=1234 CURRENT_EXTENSION=$(CURRENT_EXTENSION) make docker-start

2-4-0:			 # Launch 2.4.0
	MAGE_VERSION="2.4.0" PHP_VERSION='7.4.29' COMPOSER_VERSION='composer1' MYSQL_VERSION="mysql:8.0.32-debian" ELASTICSEARCH_VERSION='docker.elastic.co/elasticsearch/elasticsearch:7.6.0' ELASTICSEARCH_OPTIONS='--elasticsearch-host elasticsearch --elasticsearch-port 9200' MAGENTO_PORT=1234 CURRENT_EXTENSION=$(CURRENT_EXTENSION) make docker-start

2-4-1:			 # Launch 2.4.1
	MAGE_VERSION="2.4.1" PHP_VERSION='7.4.29' COMPOSER_VERSION='composer1' MYSQL_VERSION="mysql:8.0.32-debian" ELASTICSEARCH_VERSION='docker.elastic.co/elasticsearch/elasticsearch:7.7.0' ELASTICSEARCH_OPTIONS='--elasticsearch-host elasticsearch --elasticsearch-port 9200' MAGENTO_PORT=1234 CURRENT_EXTENSION=$(CURRENT_EXTENSION) make docker-start

2-4-2:			 # Launch 2.4.2
	MAGE_VERSION="2.4.2" PHP_VERSION='7.4.29' COMPOSER_VERSION='composer1' MYSQL_VERSION="mysql:8.0.32-debian" ELASTICSEARCH_VERSION='docker.elastic.co/elasticsearch/elasticsearch:7.9.0' ELASTICSEARCH_OPTIONS='--elasticsearch-host elasticsearch --elasticsearch-port 9200' MAGENTO_PORT=1234 CURRENT_EXTENSION=$(CURRENT_EXTENSION) make docker-start

2-4-3:			 # Launch 2.4.3
	MAGE_VERSION="2.4.3" PHP_VERSION='7.4.29' COMPOSER_VERSION='composer1' MYSQL_VERSION="mysql:8.0.32-debian" ELASTICSEARCH_VERSION='docker.elastic.co/elasticsearch/elasticsearch:7.10.0' ELASTICSEARCH_OPTIONS='--elasticsearch-host elasticsearch --elasticsearch-port 9200' MAGENTO_PORT=1234 CURRENT_EXTENSION=$(CURRENT_EXTENSION) make docker-start

2-4-4:			 # Launch 2.4.4
	MAGE_VERSION="2.4.4" PHP_VERSION='8.1.6' COMPOSER_VERSION='composer22' MYSQL_VERSION="mysql:8.0.32-debian" ELASTICSEARCH_VERSION='docker.elastic.co/elasticsearch/elasticsearch:7.16.0' ELASTICSEARCH_OPTIONS='--elasticsearch-host elasticsearch --elasticsearch-port 9200' MAGENTO_PORT=1234 CURRENT_EXTENSION=$(CURRENT_EXTENSION) make docker-start

2-4-4-p1:		 # Launch 2.4.4-p1
	MAGE_VERSION="2.4.4-p1" PHP_VERSION='8.1.6' COMPOSER_VERSION='composer22' MYSQL_VERSION="mysql:8.0.32-debian" ELASTICSEARCH_VERSION='docker.elastic.co/elasticsearch/elasticsearch:7.16.0' ELASTICSEARCH_OPTIONS='--elasticsearch-host elasticsearch --elasticsearch-port 9200' MAGENTO_PORT=1234 CURRENT_EXTENSION=$(CURRENT_EXTENSION) make docker-start

2-4-4-p2:		 # Launch 2.4.4-p2
	MAGE_VERSION="2.4.4-p2" PHP_VERSION='8.1.6' COMPOSER_VERSION='composer22' MYSQL_VERSION="mysql:8.0.32-debian" ELASTICSEARCH_VERSION='docker.elastic.co/elasticsearch/elasticsearch:7.16.0' ELASTICSEARCH_OPTIONS='--elasticsearch-host elasticsearch --elasticsearch-port 9200' MAGENTO_PORT=1234 CURRENT_EXTENSION=$(CURRENT_EXTENSION) make docker-start

2-4-4-p3:		 # Launch 2.4.4-p3
	MAGE_VERSION="2.4.4-p3" PHP_VERSION='8.1.6' COMPOSER_VERSION='composer22' MYSQL_VERSION="mysql:8.0.32-debian" ELASTICSEARCH_VERSION='docker.elastic.co/elasticsearch/elasticsearch:7.17.0' ELASTICSEARCH_OPTIONS='--elasticsearch-host elasticsearch --elasticsearch-port 9200' MAGENTO_PORT=1234 CURRENT_EXTENSION=$(CURRENT_EXTENSION) make docker-start

2-4-5:			 # Launch 2.4.5
	MAGE_VERSION="2.4.5" PHP_VERSION='8.1.6' COMPOSER_VERSION='composer22' MYSQL_VERSION="mysql:8.0.32-debian" ELASTICSEARCH_VERSION='docker.elastic.co/elasticsearch/elasticsearch:7.17.0' ELASTICSEARCH_OPTIONS='--elasticsearch-host elasticsearch --elasticsearch-port 9200' MAGENTO_PORT=1234 CURRENT_EXTENSION=$(CURRENT_EXTENSION) make docker-start

2-4-5-p1:		# Launch 2.4.5-p1
	MAGE_VERSION="2.4.5-p1" PHP_VERSION='8.1.6' COMPOSER_VERSION='composer22' MYSQL_VERSION="mysql:8.0.32-debian" ELASTICSEARCH_VERSION='docker.elastic.co/elasticsearch/elasticsearch:7.17.0' ELASTICSEARCH_OPTIONS='--elasticsearch-host elasticsearch --elasticsearch-port 9200' MAGENTO_PORT=1234 CURRENT_EXTENSION=$(CURRENT_EXTENSION) make docker-start

2-4-5-p2:		# Launch 2.4.5-p2
	MAGE_VERSION="2.4.5-p2" PHP_VERSION='8.1.6' COMPOSER_VERSION='composer22' MYSQL_VERSION="mysql:8.0.32-debian" ELASTICSEARCH_VERSION='docker.elastic.co/elasticsearch/elasticsearch:7.17.0' ELASTICSEARCH_OPTIONS='--elasticsearch-host elasticsearch --elasticsearch-port 9200' MAGENTO_PORT=1234 CURRENT_EXTENSION=$(CURRENT_EXTENSION) make docker-start

2-4-6:			 # Launch 2.4.6
	MAGE_VERSION="2.4.6" PHP_VERSION='8.2.2' COMPOSER_VERSION='composer22' MYSQL_VERSION="mysql:8.0.32-debian" ELASTICSEARCH_VERSION='docker.elastic.co/elasticsearch/elasticsearch:7.17.0' ELASTICSEARCH_OPTIONS='--search-engine elasticsearch7 --elasticsearch-host elasticsearch --elasticsearch-port 9200' MAGENTO_PORT=1234 CURRENT_EXTENSION=$(CURRENT_EXTENSION) make docker-start

2-latest:			 # Launch the latest 2.x series
	PHP_VERSION='8.2.2' COMPOSER_VERSION='composer22' MYSQL_VERSION="mysql:8.0.32-debian" ELASTICSEARCH_VERSION='docker.elastic.co/elasticsearch/elasticsearch:7.17.0' ELASTICSEARCH_OPTIONS='--search-engine elasticsearch7 --elasticsearch-host elasticsearch --elasticsearch-port 9200' MAGENTO_PORT=1234 CURRENT_EXTENSION=$(CURRENT_EXTENSION) make docker-start

docker-start:       # Launch docker container
	docker compose --file=docker-compose.yml down --remove-orphans
	docker container rm -f mtest-mysql mtest mtest-elasticsearch
	docker compose --file=docker-compose.yml up --quiet-pull --remove-orphans -d magento #--build
	docker exec mtest '/home/ampersand/assets/magento-install.sh'
