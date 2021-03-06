require 'spec_helper'
require 'hiera'

describe 'vision_shipit::inotify' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end

      let(:title) { 'foobar' }

      # Default check to see if manifest compiles
      context 'compile' do
        it { is_expected.to compile.with_all_deps }
      end
    end
  end
end
