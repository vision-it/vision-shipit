# Class: vision_shipit::inotify
# ===========================
#
# Parameters
# ----------
# fact_file: Path the file to watch with inotify
# service_name: Name of the systemd service to setup (Example: app-name-notify)
#
define vision_shipit::inotify (

  String $fact                = $title,
  String $service             = $title,
  String $inotify_script_path = '/usr/local/bin/inotify-puppet',
  String $owner               = 'root',
  String $group               = 'root',
  String $mode                = '0664',

) {

  contain vision_shipit::script

  $service_file = "/etc/systemd/system/${service}.service"
  $fact_file    = "/opt/puppetlabs/facter/facts.d/${fact}.txt"

  file { $service_file:
    ensure  => present,
    content => template('vision_shipit/tag-notify.service.erb'),
    notify  => Service[$service],
  }

  file { $fact_file:
    ensure => present,
    owner  => $owner,
    group  => $group,
    mode   => $mode,
  }

  service { $service:
    ensure   => running,
    enable   => true,
    provider => 'systemd',
    require  => [
      File[$service_file],
    ],
  }

}
