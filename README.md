# magento-docker-test-instance

## Sample

To use https://github.com/AmpersandHQ/magento-docker-test-instance for running your integration / unit tests you do the following.

```
composer require --dev ampersand/magento-docker-test-instance:"^0.1"
```

Then locally or in your CI pipeline you can tell it to boot a version of Magento for testing, passing in the location of the current extension.

The current extension will be mounted into the docker container as a volume, and then composer required as a symlink [path repository](https://getcomposer.org/doc/05-repositories.md#path) so that it is installed correctly. This means that local changes are immediately present within the magento install.

```
CURRENT_EXTENSION="." vendor/bin/mtest-make 2-4-5
```

You can then run the unit and integration tests
```
vendor/bin/mtest 'vendor/bin/phpunit -c /var/www/html/dev/tests/unit/phpunit.xml.dist --testsuite Unit --debug'
vendor/bin/mtest 'vendor/bin/phpunit -c /var/www/html/dev/tests/integration/phpunit.xml.dist --testsuite Integration --debug'
```

Logs can be accessed
```
vendor/bin/mtest 'ls -l /var/www/html/var/report/'
vendor/bin/mtest 'cat /var/www/html/var/log/*.log'
```

You can connect to the container to clear caches, regenerate di, etc

```
vendor/bin/mtest-ssh
```

### Configuration

We have the following environment variables which can be overridden when running the `./vendor/bin/mtest-make` command

| ENV VAR  	 | Default value	|
|------------|---------------|
| `COMPOSER_REPOSITORY` 	 | https://repo-magento-mirror.fooman.co.nz/ |
| `UNIT_TESTS_PATH`  | src/Test/Unit |
| `INTEGRATION_TESTS_PATH`	 | 	src/Test/Integration          |

Example: 
```
UNIT_TESTS_PATH='Tests/Unit' INTEGRATION_TESTS_PATH='Tests/Integration' CURRENT_EXTENSION="." vendor/bin/mtest-make 2-4-5
```