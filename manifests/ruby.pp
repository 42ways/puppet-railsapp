######################################################################
# railsapp/manifests/ruby.pp
# puppet provisioning module for a basic rails application server
# rvm and ruby stuff
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

class railsapp::ruby (
    $rubyversion,
    $passengerversion,
    $railsuser
)
{

    class { 'rvm':
        require => Stage['setup']
    }

    rvm::system_user { $railsuser : ; }

    rvm_system_ruby { $rubyversion :
        ensure => 'present',
        default_use => false;   # this is imporant to avoid breaking of puppet itself
    }

    rvm_gem { "$rubyversion/bundler" :
        ensure => latest,
        require => Rvm_system_ruby[$rubyversion];
    }

}
