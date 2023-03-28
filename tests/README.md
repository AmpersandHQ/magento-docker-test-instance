# Tests

See `.travis.yml` for how to run the integration tests from this sample module

1. Have the module require-dev `ampersand/magento-docker-test-instance` and run `composer install`
2. Launch the docker containers at the required version while telling it where the current extension lives

    ```
    CURRENT_EXTENSION='/path/to/current/extension' vendor/bin/mtest-make 2-4-5
    ```
   
3. Run the integration tests

    ```
    vendor/bin/mtest 'vendor/bin/phpunit -c /var/www/html/dev/tests/integration/phpunit.xml.dist --testsuite Integration --debug'
    ```
   
4. See any logs

    ```
    vendor/bin/mtest 'cat dev/tests/integration/tmp/sandbox*/var/log/*.log'
    ```