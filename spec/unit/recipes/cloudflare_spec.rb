require 'spec_helper.rb'

describe 'certbot-dns::cloudflare' do
  default_attributes['certbot']['cloudflare']['email'] = 'some-email'
  default_attributes['certbot']['cloudflare']['api_key'] = 'some-api-key'
  default_attributes['certbot']['domain'] = 'foo.bar.com'

  describe '~> should install certbot' do
    it {
      is_expected.to add_apt_repository('certbot')
        .with(uri: 'ppa:certbot/certbot')
    }
  end

  describe '~> should install dns cloud flare plugin' do
    it { is_expected.to install_apt_package('python3-certbot-dns-cloudflare')}
  end

  describe '~> should create credentials file' do
    file = '/etc/certbot-dns-cloudflare.ini'
    it { is_expected.to create_template(file) }
    it {
      is_expected.to render_file(file)
        .with_content(/.*some-email/)
        .with_content(/.*some-api-key/)
    }
  end

  describe '~> should generate new certificate' do
    it {
      is_expected.to run_execute('certbot')
        .with(
          command: /certbot certonly.*-d foo.bar.com/
        )
    }
  end
end
