list: 					        # Lists all available commands
	printf "\n"; grep -v -e "^\t" Makefile | grep . | grep -v ENV | awk -F":.+?#" '{ print $$1 " #" $$2 }' | column -t -s '#';

2-4-5:			 # Launch 2.4.5
	MAGE_VERSION="2.4.5" PHP_VERSION='8.1.6' COMPOSER_VERSION='composer22' MYSQL_VERSION="mysql:8.0.32-debian" ELASTICSEARCH_VERSION='docker.elastic.co/elasticsearch/elasticsearch:7.17.0' MAGENTO_PORT=1234 make docker-start

2-latest:			 # Launch the latest 2.x series
	PHP_VERSION='8.2.2' COMPOSER_VERSION='composer22' MYSQL_VERSION="mysql:8.0.32-debian" ELASTICSEARCH_VERSION='docker.elastic.co/elasticsearch/elasticsearch:7.17.0' MAGENTO_PORT=1234 make docker-start

docker-start:       # Launch docker container
	docker compose --file=docker-compose.yml pull
	docker compose --file=docker-compose.yml down --remove-orphans
	docker compose --file=docker-compose.yml up --remove-orphans -d magento
	docker exec -it mtest '/ampersand/magento-install.sh'
