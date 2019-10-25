require 'spec_helper_acceptance'

describe 'vision_shipit' do
  context 'with fact files' do
    it 'run idempotently' do
      pp = <<-FILE

        # Just so that Puppet won't throw an error
        file {['/etc/init.d/barfoo', '/etc/init.d/foobar']:
          ensure  => present,
          mode    => '0777',
          content => 'case "$1" in *) exit 0 ;; esac'
        }

        file {['/vision', '/vision/data']:
          ensure => directory,
        }

        vision_shipit::inotify { 'foobar':
          owner => 'www-data',
          group => 'www-data',
          mode => '0777',
        }
        vision_shipit::inotify { 'barfoo': }
      FILE

      apply_manifest(pp, catch_failures: false)
      apply_manifest(pp, catch_failures: true)
      # To avoid error in Debian 9
      apply_manifest(pp, catch_changes: false)
    end
  end

  context 'packages installed' do
    describe package('inotify-tools') do
      it { is_expected.to be_installed }
    end
  end
  context 'script' do
    describe file('/usr/local/bin/inotify-puppet') do
      it { is_expected.to exist }
      it { is_expected.to be_owned_by('root') }
      its(:content) { is_expected.to match 'managed by Puppet' }
      its(:content) { is_expected.to match 'inotifywait' }
      its(:content) { is_expected.to match 'puppet apply' }
    end
  end
  context 'files' do
    describe file('/opt/puppetlabs/facter/facts.d/foobar.txt') do
      it { is_expected.to exist }
      it { is_expected.to be_symlink }
      it { is_expected.to be_linked_to('/vision/data/foobar.txt') }
    end
    describe file('/vision/data/foobar.txt') do
      it { is_expected.to exist }
      it { is_expected.to be_grouped_into('www-data') }
      it { is_expected.to be_owned_by('www-data') }
      it { is_expected.to be_mode(777) }
    end
    describe file('/opt/puppetlabs/facter/facts.d/barfoo.txt') do
      it { is_expected.to exist }
      it { is_expected.to be_symlink }
      it { is_expected.to be_linked_to('/vision/data/barfoo.txt') }
    end
    describe file('/vision/data/barfoo.txt') do
      it { is_expected.to exist }
      it { is_expected.to be_grouped_into('root') }
      it { is_expected.to be_owned_by('root') }
      it { is_expected.to be_mode(664) }
    end
    describe file('/etc/systemd/system/foobar.service') do
      it { is_expected.to exist }
      its(:content) { is_expected.to match 'foobar' }
    end
    describe file('/etc/systemd/system/barfoo.service') do
      it { is_expected.to exist }
      its(:content) { is_expected.to match 'barfoo' }
    end
  end
end
