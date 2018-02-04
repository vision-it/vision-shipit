require 'spec_helper_acceptance'

describe 'vision_shipit' do
  context 'with defaults' do
    it 'run idempotently' do
      pp = <<-FILE
        class { 'vision_shipit::script': }
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
  context 'test hiera data' do
    describe file('/usr/local/bin/inotify-puppet') do
      it { is_expected.to exist }
      its(:content) { is_expected.to match 'managed by Puppet' }
      its(:content) { is_expected.to match 'inotifywait' }
      its(:content) { is_expected.to match 'puppet agent' }
    end
  end
end
