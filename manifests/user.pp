# Class: vision_shipit::user
# ===========================

class vision_shipit::user (

  Integer $uid = 50000,
  Integer $gid = 50000,
  Optional[String] $key_type = undef,
  Optional[String] $public_key = undef,

) {

  group { 'shipit':
    ensure => present,
    gid    => $gid,
  }

  user { 'shipit':
    ensure     => present,
    managehome => true,
    uid        => $uid,
    gid        => $gid,
    password   => '*',
    require    => [
      Group['shipit'],
    ]
  }

  if ($public_key != undef) and ($key_type != undef) {
    ssh_authorized_key { 'shipit':
      ensure  => present,
      user    => 'shipit',
      type    => $key_type,
      key     => $public_key,
      require => User['shipit'],
    }
  }

  # ensure legacy jenkins user and group are absent
  user { 'jenkins':
    ensure => absent,
  }

  group { 'jenkins':
    ensure => absent,
  }

}
