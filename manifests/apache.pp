######################################################################
# railsapp/manifests/apache.pp
# puppet provisioning module for a basic rails application server
# apache and passenger stuff
#
# Copyright 2013 42ways UG, teleteach GmbH
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
######################################################################

class railsapp::apache (
    $appname,
    $servername,
    $rubyversion,
    $passengerversion,
    $railsuser,
    $railsgroup
)
{

    ######################################################################
    # apache with rvm / passager

    class { '::apache':
        default_vhost => false,
    }

    class { 'rvm::passenger::apache':
      version            => $passengerversion,
      ruby_version       => $rubyversion,
      mininstances       => '3',
      maxinstancesperapp => '0',
      maxpoolsize        => '30',
      spawnmethod        => 'smart-lv2',
    }


    ######################################################################
    # application directories and apache conf
    # using puppet 3 we could have an array of paths for the stuff below /srv
    # but this more noisy version is compatible with puppet 2.7

    file { "/srv" :
        ensure => "directory",
        owner  => 'root',
        group  => 'root',
        mode   => 0755,
    }
    ->
    file { "/srv/www" :
        ensure => "directory",
        owner  => $railsuser,
        group  => $railsgroup,
        mode   => 0755,
    }
    ->
    file { "/srv/www/rails" :
        ensure => "directory",
        owner  => $railsuser,
        group  => $railsgroup,
        mode   => 0755,
    }
    ->
    file { "/srv/www/rails/${appname}" :
        ensure => "directory",
        owner  => $railsuser,
        group  => $railsgroup,
        mode   => 0755,
    }
    ->
    file { "/srv/www/rails/${appname}/releases" :
        ensure => "directory",
        owner  => $railsuser,
        group  => $railsgroup,
        mode   => 0755,
    }
    ->
    file { "/srv/www/rails/${appname}/releases/empty" : # dummy release to make apache module happy
        ensure => "directory",
        owner  => $railsuser,
        group  => $railsgroup,
        mode   => 0755,
    }
    ->
    file { "/srv/www/rails/${appname}/shared" :
        ensure => "directory",
        owner  => $railsuser,
        group  => $railsgroup,
        mode   => 0755,
    }
    ->
    file { "/srv/www/rails/${appname}/shared/config" :
        ensure => "directory",
        owner  => $railsuser,
        group  => $railsgroup,
        mode   => 0755,
    }
    ->
    file { "/srv/www/rails/${appname}/shared/log" :  # TODO: this should done by capistrano, but it isn't....
        ensure => "link",
        target => "/var/log/${appname}"
    }
    ->
    file { "/srv/www/rails/${appname}/current" :
        replace => "no",    # if we already deployed app releases we want to leave this alone
        ensure => "link",
        target => "/srv/www/rails/${appname}/releases/empty"
    }

    file { "/var/log/${appname}" :
        ensure => "directory",
        owner  => $railsuser,
        group  => $railsgroup,
        mode   => 0755,
    }

    apache::vhost { "railsapp-${appname}":
      ensure        => 'present',
      port          => '80',
      docroot       => "/srv/www/rails/${appname}/current/public",
      directories   => [
        {
          'path'    => "/srv/www/rails/${appname}/current/public",
          'Allow'   => 'from all',
          'Options' => '-MultiViews',
        }
      ],
      serveraliases => [ $servername, ],
    }
}
