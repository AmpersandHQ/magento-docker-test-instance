# magento-docker-test-instance

[![Build Status](https://app.travis-ci.com/AmpersandHQ/magento-docker-test-instance.svg?branch=master)](https://app.travis-ci.com/AmpersandHQ/magento-docker-test-instance)

Quickly provision a disposable magento docker instance for testing against.

You can either boot it as a full installation of Magento that you can browse around, or bring it in as a `require-dev` dependency to run your integration and unit tests.

This is for test use only, not for production or any deployed environment.

# Usage 

Run `./bin/mtest-make` to see all supported versions

```
$ ./bin/mtest-make

2-3-7       Launch 2.3.7
2-3-7-p1    Launch 2.3.7-p1
2-3-7-p2    Launch 2.3.7-p2
2-3-7-p3    Launch 2.3.7-p3
2-3-7-p4    Launch 2.3.7-p4
2-4-0       Launch 2.4.0
2-4-1       Launch 2.4.1
2-4-2       Launch 2.4.2
2-4-3       Launch 2.4.3
2-4-4       Launch 2.4.4
2-4-4-p1    Launch 2.4.4-p1
2-4-4-p2    Launch 2.4.4-p2
2-4-4-p3    Launch 2.4.4-p3
2-4-5       Launch 2.4.5
2-4-5-p1    Launch 2.4.5-p1
2-4-5-p2    Launch 2.4.5-p2
2-4-6       Launch 2.4.6
2-latest    Launch the latest 2.x series

```

## Full Installation

For a full installation
```
FULL_INSTALL=1 ./bin/mtest-make 2-4-5
```

That will allow you to then browse `http://0.0.0.0:1234/admin` with the credentials `admin/somepassword123`

## Partial Installation for running unit/integration tests

Please see [this sample module](https://github.com/AmpersandHQ/magento-docker-test-instance/tree/master) for instructions on how to run your custom integration/unit tests. 

## Execute commands inside the docker container

```
./bin/mtest 'vendor/bin/n98-magerun2 config:store:set test/some/config 123'
```

or to connect to the container

```
./bin/mtest-ssh
```