<?php
set_error_handler(function ($severity, $message, $file, $line) {
    throw new \ErrorException($message, $severity, $severity, $file, $line);
});

echo "prepare-phpunit-config.php" . PHP_EOL;

$magentoPath = realpath($argv[1]);
echo "Current working directory " . $magentoPath . PHP_EOL;

if (!is_file($magentoPath . '/app/etc/di.xml')) {
    throw new \Exception('Could not detect app/etc/di.xml for: ' . $magentoPath);
}
$packageName = $argv[2];
echo "Using package name $packageName" . PHP_EOL;

$integrationTestsDir = $argv[3];
echo "Integration tests live in $integrationTestsDir" . PHP_EOL;

$unitTestsDir = $argv[4];
echo "Unit tests live in $unitTestsDir" . PHP_EOL;

$integrationConfigPath = "$magentoPath/dev/tests/integration/phpunit.xml.dist";
echo "Magento phpunit integration xml is at $integrationConfigPath" . PHP_EOL;

$integrationConfig = new \SimpleXMLElement($integrationConfigPath, 0, true);
unset($integrationConfig->testsuites);
$testsuiteNode = $integrationConfig->addChild('testsuites')->addChild('testsuite');
$testsuiteNode->addAttribute('name', 'Integration');
$testsuiteNode->addChild('directory', "$magentoPath/vendor/$packageName/$integrationTestsDir")->addAttribute('suffix', 'Test.php');

$integrationConfig->asXML($integrationConfigPath);

echo "Definition" . PHP_EOL;
echo str_pad('', 120, '-') . PHP_EOL;
echo file_get_contents($integrationConfigPath) . PHP_EOL;
echo str_pad('', 120, '-') . PHP_EOL;

$unitConfigPath = "$magentoPath/dev/tests/unit/phpunit.xml.dist";
echo "Magento phpunit unit xml is at $unitConfigPath" . PHP_EOL;

$unitConfig = new \SimpleXMLElement($unitConfigPath, 0, true);
unset($unitConfig->testsuites);
//failOnEmptyTestSuite todo bake this into the config
$testsuiteNode = $unitConfig->addChild('testsuites')->addChild('testsuite');
$testsuiteNode->addAttribute('name', 'Unit');
$testsuiteNode->addChild('directory', "$magentoPath/vendor/$packageName/$unitTestsDir")->addAttribute('suffix', 'Test.php');

# https://github.com/magento/magento2/pull/36703
$unitConfigAsXml = str_replace('<string>allure/allure.config.php</string>', '<string>dev/tests/unit/allure/allure.config.php</string>', $unitConfig->asXML());
file_put_contents($unitConfigPath, $unitConfigAsXml);

echo "Definition" . PHP_EOL;
echo str_pad('', 120, '-') . PHP_EOL;
echo file_get_contents($unitConfigPath) . PHP_EOL;
echo str_pad('', 120, '-') . PHP_EOL;
