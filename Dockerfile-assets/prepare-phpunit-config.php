<?php
set_error_handler(function ($severity, $message, $file, $line) {
    throw new \ErrorException($message, $severity, $severity, $file, $line);
});

$magentoPath = realpath($argv[1]);
echo "Current working directory " . $magentoPath . PHP_EOL;

if (!is_file($magentoPath . '/app/etc/di.xml')) {
    throw new \Exception('Could not detect app/etc/di.xml for: ' . $magentoPath);
}
$packageName = $argv[2];
echo "Using package name $packageName" . PHP_EOL;

$configPath = "$magentoPath/dev/tests/integration/phpunit.xml.dist";
echo "Magento phpunit integration xml is at $configPath" . PHP_EOL;

$config = new \SimpleXMLElement($configPath, 0, true);

unset($config->testsuites);
$testsuiteNode = $config->addChild('testsuites')->addChild('testsuite');
$testsuiteNode->addAttribute('name', 'Integration');
$testsuiteNode->addChild('directory', "$magentoPath/vendor/$packageName/src/Test/Integration")->addAttribute('suffix', 'Test.php');

$config->asXML($configPath);

echo "Definition" . PHP_EOL;
echo str_pad('', 120, '-') . PHP_EOL;
echo file_get_contents($configPath) . PHP_EOL;
echo str_pad('', 120, '-') . PHP_EOL;
