# Class: vision_shipit::script
# ===========================
#
# Parameters
# ----------
#

class vision_shipit::script (

  String $inotify_script_path = '/usr/local/bin/inotify-puppet'

) {

  if !defined(Package[ 'inotify-tools' ]) {
    package { 'inotify-tools':
      ensure   => present,
    }
  }

  file { $inotify_script_path :
    ensure  => present,
    content => template('vision_shipit/inotify-puppet')
    mode    => '0755',
  }

}
