puppet-railsapp
===============

puppet-railsapp is our puppet provisioning module for a basic rails application server.

It assumes the rails application will be deployed via capistrano (https://github.com/capistrano/capistrano) or at least in a capistrano like directory structure.

The module is based on [puppetlabs/apache](https://forge.puppetlabs.com/puppetlabs/apache), [puppetlabs/mysql](https://forge.puppetlabs.com/puppetlabs/mysql), [puppetlabs/firewall](https://forge.puppetlabs.com/puppetlabs/firewall) and [maestrodev/rvm](https://forge.puppetlabs.com/maestrodev/rvm) which all can be found on [puppetforge](https://forge.puppetlabs.com/).

LICENSE
-------

Copyright 2013 42ways UG, teleteach GmbH

Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at

  http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.
