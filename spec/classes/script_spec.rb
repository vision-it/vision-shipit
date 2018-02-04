require 'spec_helper'
require 'hiera'

describe 'vision_shipit::script' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end
      # Default check to see if manifest compiles
      context 'compile' do
        it { is_expected.to compile.with_all_deps }
      end

      context 'inotify script' do
        it { is_expected.to contain_file('/usr/local/bin/inotify-puppet') }
      end
    end
  end
end
