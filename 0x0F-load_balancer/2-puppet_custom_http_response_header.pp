# Ensure Nginx package is installed
package { 'nginx':
  ensure => 'installed',
}

# Define a custom fact to get the hostname
# This custom fact will be used to set the X-Served-By header value
facter::add_fact {
  'custom_server_hostname':
    value => $::hostname,
}

# Create an Nginx configuration file to set the custom header
file { '/etc/nginx/sites-available/custom_header':
  ensure  => present,
  owner   => 'root',
  group   => 'root',
  mode    => '0644',
  content => "server {
    listen 80;
    server_name _;

    location / {
        add_header X-Served-By $custom_server_hostname;
        root /var/www/html;
        index index.html;
    }
}",
  require => Package['nginx'],
}

# Create a symbolic link to enable the configuration
file { '/etc/nginx/sites-enabled/custom_header':
  ensure  => link,
  target  => '/etc/nginx/sites-available/custom_header',
  require => File['/etc/nginx/sites-available/custom_header'],
}

# Remove the default Nginx default configuration
file { '/etc/nginx/sites-enabled/default':
  ensure => absent,
  before => File['/etc/nginx/sites-available/default'],
}

# Restart Nginx to apply the changes
service { 'nginx':
  ensure  => 'running',
  enable  => true,
  require => [
    File['/etc/nginx/sites-enabled/custom_header'],
    File['/etc/nginx/sites-available/custom_header'],
  ],
}

