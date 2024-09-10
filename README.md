# sample






global
  log stdout format raw local0
  maxconn 2048
defaults
  log     global
  mode    http
  #option httplog
  option  tcplog
  option  dontlognull
  timeout connect 5000
  timeout client  50000
  timeout server  50000

frontend stats
  bind *:1937
  stats uri /
  stats show-legends
  stats refresh 60s


frontend entrypoint
  bind *:443 ssl  crt /etc/letsencrypt/live/vault-02.quidam.re/haproxy.pem   alpn h2,http/1.1
  mode http
  option forwardfor
  acl allowed_ips_proxied hdr_ip(X-Forwarded-For) 0000

  #http-request deny if !allowed_ips_proxied
  http-request deny if !allowed_ips_proxied
  use_backend bk_vault-02 if { hdr(host) -i vault-02.quidam.re } 
 


backend bk_vault-02
  server server-vault-02-i 54.37.75.241:8200 check
