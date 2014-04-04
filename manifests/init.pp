######################################################################
# railsapp/manifests/init.pp
# puppet provisioning module for a basic rails application server
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

class railsapp (
    $rubyversion        = 'ruby-1.9.3-p448',          # Ruby version
    $passengerversion   = '3.0.19',                   # Passenger version
    $railsuser          = 'rails',                    # user running the server (will be created)
    $railsgroup         = 'rails',                    # group running the server (will be created)
    $railsshell         = '/bin/bash',                # login shell for created rails user
    $railshome          = '/home/rails'               # home directory for created rails user
 )
{

    firewall { '110 allow http and https access':
        port   => [80, 443],
        proto  => tcp,
        action => accept
    }

    ######################################################################
    # rails user

    group { $railsgroup :
      ensure => present,
    }

    user { $railsuser :
      ensure     => present,
      gid        => $railsgroup,
      shell      => $railsshell,
      home       => $railshome,
      managehome => true,
    }

    ######################################################################
    # rvm and ruby

    class { 'railsapp::ruby' :
        rubyversion => $rubyversion,
        passengerversion => $passengerversion,
        railsuser => $railsuser
    }

    ######################################################################
    # application directory and apache conf

    class { 'railsapp::apache' :
        rubyversion => $rubyversion,
        passengerversion => $passengerversion,
        railsuser => $railsuser,
        railsgroup => $railsgroup
    }

    notify { "Railsapp base system with ${rubyversion} and Passenger ${passengerversion}" : }
}
