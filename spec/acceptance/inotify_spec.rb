require 'spec_helper_acceptance'

describe 'vision_shipit' do
  context 'with defaults' do
    it 'run idempotently' do
      pp = <<-FILE
        vision_shipit::inotify { 'foobar':
          owner => 'www-data',
          group => 'www-data',
          mode => '0777',
        }
        vision_shipit::inotify { 'barfoo': }
      FILE

      apply_manifest(pp, catch_failures: true)
      apply_manifest(pp, catch_changes: true)
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
      its(:content) { is_expected.to match 'puppet agent' }
    end
  end
  context 'files' do
    describe file('/opt/puppetlabs/facter/facts.d/foobar.txt') do
      it { is_expected.to exist }
      it { is_expected.to be_grouped_into('www-data') }
      it { is_expected.to be_owned_by('www-data') }
      it { is_expected.to be_mode( 777 ) }
    end
    describe file('/opt/puppetlabs/facter/facts.d/barfoo.txt') do
      it { is_expected.to exist }
      it { is_expected.to be_grouped_into('root') }
      it { is_expected.to be_owned_by('root') }
      it { is_expected.to be_mode( 660 ) }
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
