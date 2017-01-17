# carnival-puppet-mongodb_automation_agent

## Overview

This module can be used to install the MongoDB Cloud Manager automation agent
onto servers. Whilst the use of MongoDB Cloud Manager generally means that
Puppet won't be managing the MongoDB installation itself, Puppet is still a
great way of provisioning the rest of the server and it's very useful having the
agent deployed this way.


## Usage

Simply add the class to the required servers:

    class { '::mongodb_automation_agent': }


And setup the credentials to associate it with the right Mongo Cloud Manager
account and group:

    mongodb_automation_agent::agent_config_mmsgroupid: foo
    mongodb_automation_agent::agent_config_mmsapikey: bar


By default this module will install the latest version of the agent provided by
Mongo and will leave updates to be managed via Cloud Manager. However you can
instruct Puppet to ensure a specific version of the agent is installed by
passing the `agent_version` param.


    class { '::mongodb_automation_agent':
        agent_version => '3.3.1.1977-1',
    }


## Requirements

Support is currently limited to Ubuntu GNU/Linux. Pull requests to add other
platforms or distributions are always welcome.


## Contributions

All contributions are welcome via Pull Requests including documentation fixes or
compatibility fixes for supporting other distributions (or other operating
systems).


## License

This module is licensed under the Apache License, Version 2.0 (the "License").
See the LICENSE or http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
