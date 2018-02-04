# Class: vision_shipit::inotify
# ===========================
#
# Parameters
# ----------
# fact_file: Path the file to watch with inotify
# service_name: Name of the systemd service to setup (Example: app-name-notify)
#
define inotify (

  String $fact_file,
  String $service_name,
  String $inotify_script_path = '/usr/local/bin/inotify-puppet'

) {

  contain vision_shipit::script

  $service_file = "/etc/systemd/system/${service_name}.service"

  file { $service_file:
    ensure  => present,
    content => template('vision_shipit/tag-notify.service.erb'),
    notify  => Service[$service_name],
  }

  service { $service_name:
    ensure   => running,
    enable   => true,
    requires => [
      File[$service_file],
    ],
  }

}
