# Class: motd
class motd (
  $motd_header          = $::motd::params::motd_header,
  $delimiter            = $::motd::params::delimiter,
  $init_char            = $::motd::params::init_char,
  $issue_content        = $::motd::params::issue_content,
  $issue_line_length    = 80,
  $center_issue_content = false,
  $news_line_length     = 62,
) inherits motd::params {

  validate_bool($center_issue_content)

  $motd_archive = '/etc/motd-archive'
  $motd = '/etc/motd'

  file { $motd_archive:
    ensure => directory,
    owner  => root,
    group  => root,
    mode   => '0755',
  }

  # Specify /etc/motd file.
  concat { $motd: mode => '0644', owner => 'root', group => 'root' }

  motd::header{'spacer':
    message => '',
    order   => '00',
  }
  motd::header{'header':
    message => $delimiter,
    order   => '01',
  }
  concat::fragment { 'motd_header':
    ensure  => present,
    target  => $motd,
    content => template('motd/motd.erb'),
    order   => '03',
  }
  motd::header{ 'motd_footer':
    message => $delimiter,
    order   => '98',
  }
  motd::header{'spacer2':
    message => '',
    order   => '99',
  }

  file { '/etc/issue':
    ensure  => 'file',
    content => template('motd/issue.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
  }

  file { '/etc/issue.net':
    ensure  => 'file',
    content => template('motd/issue.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
  }
}

