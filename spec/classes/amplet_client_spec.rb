require 'spec_helper'

describe 'amplet::client' do

  context 'on unsupported distributions' do
    let(:facts) {{ :osfamily => 'Unsupported' }}

    it 'it fails' do
      expect { subject }.to raise_error(/not supported on an Unsupported/)
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
      'key'         => '77002036'
    )}
  end

  ['Debian'].each do |distro|
    context "on #{distro}" do
      let(:facts) {{
        :osfamily => distro,
        :lsbdistid => distro,
        :lsbdistcodename => 'squeeze',
        :clientcert => 'foo.bar',
        :nameserver0 => '8.8.8.8'
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

      describe 'configure /etc/default/amplet2-client' do
        it { should contain_file('/etc/default/amplet2-client').with(
          'ensure' => 'file'
        )}
      end

      describe 'configure /etc/amplet2/client.conf' do
        it { should contain_file('/etc/amplet2/client.conf').with(
          'ensure' => 'file'
        )}
        it 'should configure ampname' do
          should contain_file('/etc/amplet2/client.conf') \
            .with_content(/ampname = foo\.bar/)
        end
      end

      describe 'configure /etc/amplet2/nametable' do
        it { should contain_file('/etc/amplet2/nametable').with(
          'ensure' => 'file'
        )}
      end

      describe 'configure /etc/amplet2/schedule.d/schedule' do
        it { should contain_file('/etc/amplet2/schedule.d/schedule').with(
          'ensure' => 'file'
        )}
        it 'should configure local dns tests' do
          should contain_file('/etc/amplet2/schedule.d/schedule') \
            .with_content(/8\.8\.8\.8,dns/)
        end
      end

    end
  end

end
