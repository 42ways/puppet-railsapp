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

    class {
      'rvm::passenger::apache':
        version => $passengerversion,
        ruby_version => $rubyversion,
        mininstances => '3',
        maxinstancesperapp => '0',
        maxpoolsize => '30',
        spawnmethod => 'smart-lv2';
    }


    ######################################################################
    # application directories and apache conf

    file { [ "/srv",
             "/srv/www",
             "/srv/www/rails",
             "/srv/www/rails/${appname}",
             "/srv/www/rails/${appname}/releases",
             "/srv/www/rails/${appname}/shared",
             "/srv/www/rails/${appname}/shared/config" ] :
        ensure => "directory",
        owner  => $railsuser,
        group  => $railsgroup,
        mode   => 755,
    }
    ->
    file { "/srv/www/rails/${appname}/shared/log" :  # TODO: this should done by capistrano, but it isn't....
        ensure => "link",
        target => "/var/log/${appname}"
    }

    file { "/var/log/${appname}" :
        ensure => "directory",
        owner  => $railsuser,
        group  => $railsgroup,
        mode   => 755,
    }

    file { '/etc/apache2/sites-enabled':
        ensure => 'directory',
        recurse => true,
        purge => true,
        require => Class['rvm::passenger::apache']
    }
    ->
    file { "/etc/apache2/sites-enabled/railsapp-${appname}.conf" :
        ensure  => file,
        content => template("railsapp/vhost.erb")
    }

    service { 'apache2':
        ensure => running,
        subscribe => File["/etc/apache2/sites-enabled/railsapp-${appname}.conf"],
    }

}
