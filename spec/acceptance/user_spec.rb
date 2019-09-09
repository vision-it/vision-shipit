require 'spec_helper_acceptance'

describe 'vision_shipit::user' do
  context 'with defaults' do
    it 'idempotentlies run' do
            pp = <<-FILE
        class vision_docker () {
            group { 'docker':
               ensure => present,
            }
         }

        class { 'vision_shipit::user': }
      FILE

      apply_manifest(pp, catch_failures: true)
      apply_manifest(pp, catch_changes: true)
    end

    describe user('shipit') do
      it { is_expected.to exist }
      it { is_expected.to have_uid 12_345 }
      it { is_expected.to belong_to_group 'docker' }
    end

    describe user('jenkins') do
      it { is_expected.not_to exist }
    end
  end
end
