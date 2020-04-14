# Class: vision_shipit::script
# ===========================
#
# To manage inotify script, which will then be used in systemd
#
# Parameters
# ----------
#
# @param inotify_script_path Path to inotofy Script
# @param mail_address Mail address to send notifications to
# @param verbose Script verbosity
#

class vision_shipit::script (

  String $inotify_script_path = '/usr/local/bin/inotify-puppet',
  Optional[String] $mail_address = undef,
  Boolean $verbose = false,

) {

  if !defined(Package[ 'inotify-tools' ]) {
    package { 'inotify-tools':
      ensure   => present,
    }
  }

  file { $inotify_script_path :
    ensure  => present,
    content => template('vision_shipit/inotify-puppet.erb'),
    mode    => '0755',
  }

}
