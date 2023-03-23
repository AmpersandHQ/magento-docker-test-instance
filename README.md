# magento-docker-test-instance

[![Build Status](https://app.travis-ci.com/AmpersandHQ/magento-docker-test-instance.svg?branch=master)](https://app.travis-ci.com/AmpersandHQ/magento-docker-test-instance)

## Installation

For a full installation
```
FULL_INSTALL=1 make 2-4-5
```

That will allow you to then browse `http://0.0.0.0:1234/admin` with the credentials `admin/somepassword123`

(WIP - currently incomplete) For a partial installation (for unit tests / integration tests)
```
make 2-4-5
```

## Execute commands inside the docker container

```
docker exec mtest '/ampersand/command.sh' 'vendor/bin/n98-magerun2 config:store:set test/some/config 123'
```

# TODO
- Configure and test more versions
- Support for integration tests
  - For perf reasons we can probably spin this up and have a volume refer a module on your local machine, then set this up as a composer repository to install into the magento instance via a symlink type.
  - This would mean you can edit your module locally and have it be updated in the vendor directory within the magento container
  - Not a viable way to build a whole project, but if you have only some integration tests to play with it should be quick
