<?php

namespace Localbox\Installers;

use Composer\Script\Event;

class Installer
{
    public static function postInstall(Event $event)
    {
        // Provides access to the current Composer instance.
        $composer = $event->getComposer();
        $io = $event->getIO();

        if (!file_exists('Homestead.yaml')) {
            copy('resources/Homestead.yaml', 'Homestead.yaml');
            $io->write('Copied resources/Homestead.yaml to /Homestead.yaml');

            if ($sitesFolder = rtrim($io->ask("Enter the full path to your sites folder, e.g /home/Bob/Sites : "), '/\\')) {
                $configFile = file_get_contents('Homestead.yaml');
                $configFile = str_replace('__SITES_DIRECTORY__', $sitesFolder, $configFile);
                
                if (file_put_contents('Homestead.yaml', $configFile)) {
                    $io->write('Sites folder set to ' . $sitesFolder . ' in Homestead.yaml');
                }
            }

            if ($boxUrl = rtrim(strtolower($io->ask("Enter your box URL, e.g bob.box : ")), '/\\')) {
                $configFile = file_get_contents('Homestead.yaml');
                $configFile = str_replace('__BOX_URL__', $boxUrl, $configFile);
                
                if (file_put_contents('Homestead.yaml', $configFile)) {
                    $io->write('Box URL set to ' . $boxUrl . ' in Homestead.yaml');
                }
            }
        }

        if (!file_exists('after.sh')) {
            copy('resources/after.sh', 'after.sh');
            $io->write('Copied resources/after.sh to /after.sh');
        }

        if (!file_exists('aliases')) {
            copy('resources/aliases', 'aliases');
            $io->write('Copied resources/aliases to /aliases');
        }

    }
}
