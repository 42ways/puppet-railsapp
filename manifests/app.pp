######################################################################
# railsapp/manifests/app.pp
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

define railsapp::app (
    # $name,                          # application name (comes for free from puppet witg $title as the default)
    $fqdn,                            # fully qualified domain name for the apache virtual host of this app instance
    $dbuser,                          # user to access the database (will be replaced in database.yml)
    $dbpassword,                      # password for db user (will be replaced in database.yml)
    $configtemplatedir = $name        # directory with config.yml and database.yml templates
)
{

    # get rails user and group name from railsapp class
    $railsuser = $railsapp::railsuser
    $railsgroup = $railsapp::railsgroup

    ######################################################################
    # application directories and apache vhost conf
    # using puppet 3 we could have an array of paths for the stuff below /srv
    # but this more noisy version is compatible with puppet 2.7

    file { "/srv/www/rails/${name}" :
        ensure => "directory",
        owner  => $railsuser,
        group  => $railsgroup,
        mode   => 0644,
    }
    ->
    file { "/srv/www/rails/${name}/releases" :
        ensure => "directory",
        owner  => $railsuser,
        group  => $railsgroup,
        mode   => 0644,
    }
    ->
    file { "/srv/www/rails/${name}/releases/empty" : # dummy release to make apache module happy
        ensure => "directory",
        owner  => $railsuser,
        group  => $railsgroup,
        mode   => 0644,
    }
    ->
    file { "/srv/www/rails/${name}/shared" :
        ensure => "directory",
        owner  => $railsuser,
        group  => $railsgroup,
        mode   => 0644,
    }
    ->
    file { "/srv/www/rails/${name}/shared/config" :
        ensure => "directory",
        owner  => $railsuser,
        group  => $railsgroup,
        mode   => 0644,
    }
    ->
    file { "/srv/www/rails/${name}/shared/log" :  # TODO: this should done by capistrano, but it isn't....
        ensure => "link",
        target => "/var/log/${name}"
    }
    ->
    file { "/srv/www/rails/${name}/current" :
        replace => "no",    # if we already deployed app releases we want to leave this alone
        ensure => "link",
        target => "/srv/www/rails/${name}/releases/empty"
    }

    file { "/var/log/${name}" :
        ensure => "directory",
        owner  => $railsuser,
        group  => $railsgroup,
        mode   => 0644,
    }

    apache::vhost { "railsapp-${name}":
      ensure        => 'present',
      port          => '80',
      docroot       => "/srv/www/rails/${name}/current/public",
      directories   => [
        {
          'path'    => "/srv/www/rails/${name}/current/public",
          'Allow'   => 'from all',
          'Options' => '-MultiViews',
        }
      ],
      serveraliases => [ $fqdn, ],
    }

    file { "/srv/www/rails/${name}/shared/config/database.yml" :
        ensure  => file,
        content => template("$configtemplatedir/database.yml")
    }

    file { "/srv/www/rails/${name}/shared/config/config.yml" :
        ensure  => file,
        content => template("$configtemplatedir/config.yml")
    }

    notify { "Railsapp vhost for Application ${name} on ${fqdn}" : }

}
