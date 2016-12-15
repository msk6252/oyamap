# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|

  GUEST_RUBY_VERSION = '2.3.2'
  GUEST_RAILS_VERSION = '4.2.7'

  config.vm.box = "bento/centos-6.7"

  config.vm.hostname = "oyamap"
  config.vm.network "forwarded_port", guest: 3000, host: 3000
  config.vm.network "private_network", ip: "192.168.33.10"

  config.vm.synced_folder ".", "/home/oyamap/current"

  config.vm.provider "virtualbox" do |vb|
    vb.gui = false
    vb.memory = "1024"
  end

  # privileged: true => rootユーザにインスト―ル
  config.vm.provision "shell", privileged: true, inline: <<-SHELL
    # インストール中にコマンドラインに出力する
    function install {
      echo installing $1
      shift
      yum -y install "$@" >/dev/null 2>&1
    }

    yum -y update >/dev/null 2>&1
    install "development tools"  gcc-c++ glibc-headers openssl-devel readline libyaml-devel readline-devel zlib zlib-devel
    install "Git" git
    install "sqlite" sqlite sqlite-devel
    yum install -y http://vault.centos.org/6.5/updates/x86_64/Packages/kernel-devel-2.6.32-431.3.1.el6.x86_64.rpm
    yum -y update kernel
    # mysql 5.6
    yum install -y http://dev.mysql.com/get/mysql-community-release-el6-5.noarch.rpm >/dev/null 2>&1
    install "MySQL" mysql mysql-server mysql-devel
    chkconfig --add mysqld
    chkconfig --level 345 mysqld  on
    echo "Start and Initialize MySQL"
    service mysqld start >/dev/null 2>&1
    mysql -uroot <<SQL
-- SET ROOT PASSWORD --
UPDATE mysql.user SET Password=PASSWORD('password') WHERE User='root';
-- REMOVE ANONYMOUS USERS --
DELETE FROM mysql.user WHERE User='';
-- REMOVE REMOTE ROOT --
DELETE FROM mysql.user
WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');
-- REMOVE TEST DATABASE --
DROP DATABASE IF EXISTS test;
DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';
-- RELOAD PRIVILEGE TABLES --
FLUSH PRIVILEGES;
CREATE USER 'oyamap'@'localhost';
SET PASSWORD FOR 'oyamap'@'localhost' = PASSWORD('password');
CREATE DATABASE oyamap_development DEFAULT CHARACTER SET utf8 DEFAULT COLLATE utf8_general_ci;
CREATE DATABASE oyamap_test DEFAULT CHARACTER SET utf8 DEFAULT COLLATE utf8_general_ci;
GRANT ALL PRIVILEGES ON oyamap_development.* to 'oyamap'@'localhost';
GRANT ALL PRIVILEGES ON oyamap_test.* to 'oyamap'@'localhost';
SQL
    install "Nokogiri dependencies" libxml2 libxslt libxml2-devel libxslt-devel
    install "ImageMagick" ImageMagick ImageMagick-devel
    cp /etc/localtime /etc/localtime.org
    ln -sf  /usr/share/zoneinfo/Asia/Tokyo /etc/localtime
    echo "ZONE=\"Asia/Tokyo\"" > /etc/sysconfig/clock
    service crond restart
  SHELL

  # privileged: true => vagrantユーザにインスト―ル
  config.vm.provision "shell", privileged: false, inline: <<-SHELL
    echo installing rbenv
    git clone https://github.com/sstephenson/rbenv.git ~/.rbenv
    git clone https://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build
    echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bash_profile
    echo 'eval "$(rbenv init -)"' >> ~/.bash_profile
    source ~/.bash_profile
    echo 'gem: --no-ri --no-rdoc' >> ~/.gemrc
    echo installing ruby#{GUEST_RUBY_VERSION}
    rbenv install #{GUEST_RUBY_VERSION}
    rbenv global #{GUEST_RUBY_VERSION}
    echo installing Bundler
    gem install bundler -N >/dev/null 2>&1
    gem update --system
    gem install nokogiri -- --use-system-libraries
    gem install --no-ri --no-rdoc rails --version=#{GUEST_RAILS_VERSION}
    gem install bundler
    rbenv rehash
  SHELL
end
