require 'spec_helper'

describe 'amplet::client' do

  context 'on unsupported distributions' do
    let(:facts) {{ :osfamily => 'Unsupported' }}

    it 'it fails' do
      expect { subject.call }.to raise_error(/is not supported on an Unsupported based system/)
    end
  end

  context 'on Debian' do
    let(:facts) {{
      :osfamily => 'Debian',
      :lsbdistid => 'Debian',
      :clientcert => 'foo.bar',
      :lsbdistcodename => 'wheezy'
    }}

    it 'includes amplet::repo::apt' do
      should contain_class('amplet::repo::apt')
    end

    it { should contain_apt__source('amplet-repo').with(
      'location'    => 'http://amp.wand.net.nz/debian/',
      'release'     => 'wheezy',
      'repos'       => 'main',
      'include_src' => false,
      'key'         => 'A9765B25FA4AA5AA1D6D421C86CE832077002036'
    )}
  end

  ['Debian'].each do |distro|
    context "on #{distro}" do
      let(:facts) {{
        :osfamily => distro,
        :lsbdistid => distro,
        :lsbdistcodename => 'wheezy',
        :clientcert => 'foo.bar',
        :nameserver0 => '8.8.8.8'
      }}

      let(:params) {{
        :nameservers => ['8.8.8.8'],
        :package_ensure => 'installed'
      }}

      it { should contain_class('amplet::client::install') }
      it { should contain_class('amplet::client::config') }
      it { should contain_class('amplet::client::service') }

      describe 'package installation' do
        it { should contain_package('amplet2-client').with(
          'ensure' => 'installed',
          'name'   => 'amplet2-client'
        )}
      end

      describe 'cleanup old amp configuration' do
        it { should contain_file('/etc/amplet2/client.conf').with(
          'ensure' => 'absent'
        )}
        it { should contain_file('/etc/amplet2/nametable').with(
          'ensure' => 'absent'
        )}
        it { should contain_file('/etc/amplet2/schedule.d/example.schedule').with(
          'ensure' => 'absent'
        )}
        it { should contain_file('/etc/amplet2/schedule.d/schedule').with(
          'ensure' => 'absent'
        )}
        it { should contain_file('/etc/amplet2/schedule.d').with(
          'ensure' => 'absent'
        )}
        it { should contain_file('/etc/amplet2/keys/cacert.pem').with(
          'ensure' => 'absent'
        )}
        it { should contain_file('/etc/amplet2/keys/cert.pem').with(
          'ensure' => 'absent'
        )}
        it { should contain_file('/etc/amplet2/keys/key.pem').with(
          'ensure' => 'absent'
        )}
      end

      describe 'remove default amp configuration' do
        it { should contain_file('default.conf').with(
          'ensure' => 'absent',
          'path'   => '/etc/amplet2/clients/default.conf'
        )}
      end

      describe 'configure /etc/default/amplet2-client' do
        it { should contain_file('/etc/default/amplet2-client').with(
          'ensure' => 'file'
        )}
      end

      describe 'configure client config' do
        it { should contain_file('client.conf').with(
          'ensure' => 'file',
          'path'   => '/etc/amplet2/clients/foo.bar.conf'
        )}
        it 'should configure client options' do
          should contain_file('client.conf') \
            .with_content(/ampname = foo\.bar/) \
            .with_content(/packetdelay = 1000/) \
            .with_content(/nameservers = { 8.8.8.8 }/) \
            .with_content(/port\s*=\s*5671/) \
            .with_content(/ssl\s*=\s*true/) \
            .with_content(/cacert\s*=\s*\/etc\/amplet2\/keys\/foo.bar\/cacert.pem/) \
            .with_content(/cert\s*=\s*\/etc\/amplet2\/keys\/foo.bar\/cert.pem/) \
            .with_content(/key\s*=\s*\/etc\/amplet2\/keys\/foo.bar\/key.pem/)
        end
      end

      describe 'configure ssl keys' do
        it { should contain_file('/etc/amplet2/keys/foo.bar').with(
          'ensure' => 'directory',
          'path'   => '/etc/amplet2/keys/foo.bar',
          'owner'  => 'rabbitmq',
          'mode'   => '0700'
        )}
        it { should contain_file('cacert.pem').with(
          'ensure' => 'file',
          'path'   => '/etc/amplet2/keys/foo.bar/cacert.pem',
          'owner'  => 'rabbitmq',
          'mode'   => '0644',
          'notify' => [
            'Service[rabbitmq-server]',
            'Class[Amplet::Client::Service]'
          ]
        )}
        it { should contain_file('cert.pem').with(
          'ensure' => 'file',
          'path'   => '/etc/amplet2/keys/foo.bar/cert.pem',
          'owner'  => 'rabbitmq',
          'mode'   => '0644',
          'notify' => [
            'Service[rabbitmq-server]',
            'Class[Amplet::Client::Service]'
          ]
        )}
        it { should contain_file('key.pem').with(
          'ensure' => 'file',
          'path'   => '/etc/amplet2/keys/foo.bar/key.pem',
          'owner'  => 'rabbitmq',
          'mode'   => '0600',
          'notify' => [
            'Service[rabbitmq-server]',
            'Class[Amplet::Client::Service]'
          ]
        )}
      end

      describe 'configure nametable' do
        it { should contain_file('/etc/amplet2/nametables/foo.bar').with(
          'ensure' => 'directory',
          'path'   => '/etc/amplet2/nametables/foo.bar',
          'mode'   => '0755'
        )}
        it { should contain_file('puppet.name').with(
          'ensure' => 'file',
          'path'   => '/etc/amplet2/nametables/foo.bar/puppet.name'
        )}
      end

      describe 'configure schedule' do
        it { should contain_file('/etc/amplet2/schedules/foo.bar').with(
          'ensure' => 'directory',
          'path'   => '/etc/amplet2/schedules/foo.bar',
          'mode'   => '0755'
        )}
        it { should contain_file('puppet.sched').with(
          'ensure' => 'file',
          'path'   => '/etc/amplet2/schedules/foo.bar/puppet.sched'
        )}
      end

    end
  end

end
