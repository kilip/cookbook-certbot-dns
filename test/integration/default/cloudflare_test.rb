describe file('/etc/certbot-dns-cloudflare.ini') do
  it { should exist }
end

describe file('/etc/letsencrypt/live/test.itstoni.com') do
  it { should exist }
end
