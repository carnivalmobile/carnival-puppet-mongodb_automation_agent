# Installs the MongoDB automation agent.
class mongodb_automation_agent (
  $agent_version = 'latest',
  $agent_config_mmsgroupid,
  $agent_config_mmsapikey,
) {

  Exec {
    path => ['/sbin', '/bin', '/usr/sbin', '/usr/bin'],
  }

  # The download scheme is inconsistent so we have specifically configured each
  # option. Pull requests to add additionals welcome.
  if ($::os['distro']['id'] == 'Ubuntu') {
    if ($::os['release']['major'] == '12.04') {
      $download_url = "https://cloud.mongodb.com/download/agent/automation/mongodb-mms-automation-agent-manager_${agent_version}_amd64.deb"
    }
    if ($::os['release']['major'] == '14.04') {
      $download_url = "https://cloud.mongodb.com/download/agent/automation/mongodb-mms-automation-agent-manager_${agent_version}_amd64.deb"
    }
    if ($::os['release']['major'] == '16.04') {
      $download_url = "https://cloud.mongodb.com/download/agent/automation/mongodb-mms-automation-agent-manager_${agent_version}_amd64.ubuntu1604.deb"
    }
  }

  # Download and install the software
  # TODO: Non-portable - Debian/Ubuntu Specific.

  if ($agent_version == 'latest') {
    # The "latest" version means we can't handle update via this module - we
    # just check that it's installed and install it if not.
    exec { 'mongo_agent_download':
      creates   => "/tmp/mongodb-mms-automation-agent-manager_${agent_version}.deb",
      command   => "wget -nv ${download_url} -O /tmp/mongodb-mms-automation-agent-manager_${agent_version}.deb",
      unless    => "dpkg -s mongodb-mms-automation-agent-manager | grep -q \"Status: install ok installed\"",
      logoutput => true,
      notify    => Exec['mongo_agent_install'],
    }
  } else {
    # Ensure we have the exact version requested.
    exec { 'mongo_agent_download':
      creates   => "/tmp/mongodb-mms-automation-agent-manager_${agent_version}.deb",
      command   => "wget -nv ${download_url} -O /tmp/mongodb-mms-automation-agent-manager_${agent_version}.deb",
      unless    => "dpkg -s mongodb-mms-automation-agent-manager | grep -q \"Version: ${agent_version}\"", # Download new version if not already installed.
      logoutput => true,
      notify    => Exec['mongo_agent_install'],
    }
  }

  exec { 'mongo_agent_install':
    # Ideally we'd use "apt-get install package.deb" but this only become
    # available in apt 1.1 and later. Hence we do a bit of a hack, which is
    # to install the deb and then fix the deps with apt-get -y -f install.
    # TODO: When Ubuntu 16.04 is out, check if we can migrate to the better approach
    command     => "bash -c 'dpkg -i /tmp/mongodb-mms-automation-agent-manager_${agent_version}.deb; apt-get -y -f install'",
    require     => Exec['mongo_agent_download'],
    logoutput   => true,
    refreshonly => true,
  }

  # Generate the configuration file
  file { '/etc/mongodb-mms/automation-agent.config':
    owner   => 'mongodb',
    group   => 'mongodb',
    mode    => '0755',
    content => template('mongodb_automation_agent/automation-agents.config.erb'),
  }

}
