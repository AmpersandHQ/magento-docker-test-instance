The sodium extension is installed and usable, but some composer deps are still complaining about it.

These only affect old versions of Magento, so plugging in a `replace` on `ext-sodium` to get past this constraint

```
root@f3465a2933fa:/var/www/html# php --version
PHP 7.4.29 (cli) (built: Mar 26 2023 15:38:22) ( NTS )
Copyright (c) The PHP Group
Zend Engine v3.4.0, Copyright (c) Zend Technologies
with Zend OPcache v7.4.29, Copyright (c), by Zend Technologies

root@f3465a2933fa:/var/www/html# php -r 'print_r(get_defined_constants());' | grep -i sod | head -5
[SODIUM_LIBRARY_VERSION] => 1.0.17
[SODIUM_LIBRARY_MAJOR_VERSION] => 10
[SODIUM_LIBRARY_MINOR_VERSION] => 2
[SODIUM_CRYPTO_AEAD_AES256GCM_KEYBYTES] => 32
[SODIUM_CRYPTO_AEAD_AES256GCM_NSECBYTES] => 0

root@f3465a2933fa:/var/www/html# php --modules | grep -i sod
sodium
```