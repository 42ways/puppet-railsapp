puppet-railsapp
===============

puppet-railsapp is our puppet provisioning module for a basic rails application server.

The module can be used to deploy multiple rails application to the rails application server by installing the apps under different vhosts on the server.

The module assumes the rails application will be deployed via capistrano (https://github.com/capistrano/capistrano) or at least in a capistrano like directory structure.

The configuration files ``config.yml`` and ``database.yml``are created from the corresponding files in the templates dir (of the calling module).
You can ovveride the path to these two config files with the variable ``configtemplatedir``

EXAMPLE USAGE
-------------

In general, you want to declare the railsapp in order to setup your server and then define one or more app resources on it.

Here is an example with two rails applications:

    class { 'railsapp' :
        servername => 'myrailsapp.example.com',
    }

    railsapp::app { 'firstrailsapp' :
        fqdn                => 'myfirstrailsapp.example.com',
        dbuser              => 'firstdbuser',
        dbpassword          => 'firstsecret',
    }

    railsapp::app { 'secondrailsapp' :
        fqdn                => 'mysecondrailsapp.example.com',
        dbuser              => 'seconddbuser',
        dbpassword          => 'secondsecret',
        configtemplatedir   => 'mymodule/secondapp',
    }


DEPENDENCIES
------------

This module is based on [puppetlabs/apache](https://forge.puppetlabs.com/puppetlabs/apache), [puppetlabs/mysql](https://forge.puppetlabs.com/puppetlabs/mysql), [puppetlabs/firewall](https://forge.puppetlabs.com/puppetlabs/firewall) and [maestrodev/rvm](https://forge.puppetlabs.com/maestrodev/rvm) which all can be found on [puppetforge](https://forge.puppetlabs.com/).

LICENSE
-------

Copyright 2013, 2014 42ways UG, teleteach GmbH

Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at

  http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.
