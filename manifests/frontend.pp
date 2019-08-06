# frontend env_ssl_frontend
#   bind *:443
#   mode tcp
#   option tcplog
#   tcp-request inspect-delay 10s
#   tcp-request content accept if { req_ssl_hello_type 1 }
#   use_backend bk_app1 if { req.ssl_sni -m end app1.domain.com }
#   use_backend bk_app2 if { req.ssl_sni -m end app2.domain.com }
#   use_backend bk_app3 if { req.ssl_sni -m end app3.domain.com }

# mode    http
# option  httplog
# option  dontlognull
# option forwardfor
# option http-server-close

# option forwardfor [ except <network> ] [  <name> ] [ if-none ]

define haproxy::frontend(
                          $bind,
                          $frontend_name                            = $name,
                          $mode                                     = 'tcp',
                          $description                              = undef,
                          $tcplog                                   = false,
                          $tcp_request_inspect_delay                = undef,
                          $tcp_request_content_action_and_condition = undef,
                          $dontlognull                              = undef,
                          $forwardfor                               = false,
                          $forwardfor_except                        = undef,
                          $forwardfor_header                        = undef,
                          $forwardfor_ifnone                        = false,
                          $http_server_close                        = undef,
                          $httplog                                  = false,
                          $httplog_clf                              = false,
                        ) {
  include ::haproxy

  concat::fragment{ "balancer: ${frontend_name}":
    target  => '/etc/haproxy/haproxy.cfg',
    order   => "97-${frontend_name}-0",
    content => template("${module_name}/frontend.erb"),
  }
}