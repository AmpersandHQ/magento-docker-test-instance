# magento-docker-test-instance

[![Build Status](https://app.travis-ci.com/AmpersandHQ/magento-docker-test-instance.svg?branch=master)](https://app.travis-ci.com/AmpersandHQ/magento-docker-test-instance)

Quickly provision a disposable magento docker instance for testing against.

Supports
- Booting a full instance for you to click around and run manual or other automated tests on
- Integration testing a module
- Unit testing a module

We try to keep these installations as vanilla and untouched as possible. However there are a few caveats
- This is for test use only, not for production or any deployed environment. This uses https://repo-magento-mirror.fooman.co.nz/ to pull in Magento which should not be used for production.
- 2FA modules are disabled by default to allow easier admin access

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

You can install by cloning this repo
```
git clone https://github.com/AmpersandHQ/magento-docker-test-instance
cd magento-docker-test-instance
FULL_INSTALL=1 ./bin/mtest-make 2-4-5

# run commands inside the  container
./bin/mtest 'vendor/bin/n98-magerun2 config:store:set test/some/config 123'
```

or pull it in as a composer dependency

```
composer require --dev ampersand/magento-docker-test-instance:"^0.1"
FULL_INSTALL=1 vendor/bin/mtest-make 2-4-5

# run commands inside the  container
vendor/bin/mtest 'vendor/bin/n98-magerun2 config:store:set test/some/config 123'
```

That will allow you to then browse `http://0.0.0.0:1234/admin` with the credentials `admin/somepassword123`

## Partial Installation for running unit/integration tests

Please see [this sample module](https://github.com/AmpersandHQ/magento-docker-test-instance/tree/sample) for instructions on how to run your custom integration/unit tests.