apt_repository 'certbot' do
  uri 'ppa:certbot/certbot'
  action :add
end

apt_package 'certbot' do
  action :install
end

domain = node['certbot']['domain']
cloudflare_email = node['certbot']['cloudflare']['email']

apt_package 'python3-certbot-dns-cloudflare' do
  action :install
end

param = {
  'email' => node['certbot']['cloudflare']['email'],
  'api_key' => node['certbot']['cloudflare']['api_key'],
}

template '/etc/certbot-dns-cloudflare.ini' do
  source 'cloudflare.ini.erb'
  owner 'root'
  group 'root'
  mode '0644'
  action :create
  variables param
  sensitive true
end

certfile = "/etc/letsencrypt/live/#{domain}"
execute 'certbot' do
  command <<-eos
  certbot certonly \
  --agree-tos \
  --dns-cloudflare \
  --dns-cloudflare-credentials /etc/certbot-dns-cloudflare.ini \
  -m #{cloudflare_email} \
  -d #{domain}
  eos
  action :run
  not_if { ::File.exist?(certfile) }
end
