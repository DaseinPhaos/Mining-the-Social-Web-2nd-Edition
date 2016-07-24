
include_recipe "apt"
include_recipe "runit"
include_recipe "python"

apt_repository "mongodb-10gen" do
  uri "http://downloads-distro.mongodb.org/repo/ubuntu-upstart"
  distribution "dist"
  components ["10gen"]
  keyserver "keyserver.ubuntu.com"
  key "7F0CEB10"
  action :add
end

dependencies = [
  "mongodb-10gen",                            # Mongodb from 10gen
  "openjdk-6-jdk",                            # required by one of the dependencies
  "libfreetype6-dev", "libpng-dev",           # Matplotlib dependencies
  "libncurses5-dev", "vim", "git-core",
  "build-essential",
]

dependencies.each do |pkg|
  package pkg do
    action :install
  end
end

service "mongodb" do
  action [:enable, :start]
end

execute "mongodb_textsearch" do
  command "echo 'setParameter = textSearchEnabled=true' >> /etc/mongodb.conf"
  not_if "grep textSearchEnabled /etc/mongodb.conf"
  notifies :restart, "service[mongodb]", :immediately
end

packages = [
  # Matplotlib won't install any other way right now unless you install numpy first.
  # http://stackoverflow.com/q/11797688
  "numpy==1.7.1",

  # Install FuXi per https://code.google.com/p/fuxi/wiki/Installation_Testing
  "http://cheeseshop.python.org/packages/source/p/pyparsing/pyparsing-1.5.5.tar.gz",
  "/vagrant/layercake-python.tar.bz2",
  "https://pypi.python.org/packages/source/F/FuXi/FuXi-1.4.1.production.tar.gz",
]

packages.each do |package|
  python_pip package do
    action :install
  end
end

# execute "install_requirements" do
#   command "pip install -r /vagrant/mtsw2e-requirements.txt --allow-unverified matplotlib --allow-all-external"
#   command "pip install -r /vagrant/mtsw2e-requirements2.txt --allow-all-external"
#   # action :nothing
# end

# install BeautifulSoup==3.2.1
python_pip "BeautifulSoup" do
  version "3.2.1"
end
python_pip "Flask" do
  version "0.9"
end
python_pip "Jinja2" do
  version "2.8"
end
python_pip "PyGithub" do
  version "1.17.0"
end
python_pip "PyYAML" do
  version "3.10"
end
python_pip "Werkzeug" do
  version "0.8.3"
end
python_pip "beautifulsoup4" do
  version "4.1.3"
end
python_pip "chardet" do
  version "2.1.1"
end
python_pip "cluster" do
  version "1.1.2"
end
python_pip "envoy" do
  version "0.0.2"
end
python_pip "facebook-sdk" do
  version "0.4.0"
end
python_pip "geopy" do
  version "0.95.1"
end
python_pip "feedparser" do
  version "5.1.3"
end
python_pip "google-api-python-client" do
  version "1.1"
end
python_pip "httplib2" do
  version "0.8"
end
python_pip "nltk" do
  version "2.0.4"
end
python_pip "networkx" do
  version "1.7"
end
python_pip "oauthlib" do
  version "0.4.1"
end
python_pip "prettytable" do
  version "0.7.1"
end
python_pip "python-dateutil" do
  version "2.1"
end
python_pip "python-gflags" do
  version "2.0"
end
python_pip "pymongo" do
  version "2.5.1"
end
python_pip "pyzmq" do
  version "13.0.0"
end
python_pip "python-linkedin"
python_pip "requests" do
  version "1.2.3"
end
python_pip "requests-oauthlib" do
  version "0.3.2"
end
python_pip "tornado" do
  version "2.4.1"
end
python_pip "readline" do
  version "6.2.4.1"
end
python_pip "twitter" do
  version "1.12.1"
end
python_pip "wsgiref" do
  version "0.1.2"
end
python_pip "twitter-text-py" do
  version "2.0.0"
end
python_pip "oauth2" do
  version "1.5.211"
end
python_pip "JPype1" do
  version "0.5.4.4"
end
python_pip "charade" do
  version "1.0.3"
end
python_pip "boilerpipe" do
  version "1.2.0.0"
end
python_pip "ipython" do
  version "1.1.0"
end


# Here we need to some work the matplotlib library will not install.
#python_pip "matplotlib"

#python_pip "matplotlib" do
#  version "1.2.1"
#end

# execute "install_requirements" do
#   command "pip install matplotlib==1.2.1 --allow-unverified matplotlib --allow-all-external"
#   # action :nothing
# end

# Install a few ancillary packages for NLTK in a central location. See http://nltk.org/data.html
#
# XXX:
# TEMPORARILY COMMENTING THESE DOWNLOADS OUT UNTIL CHEF HANDLING CAN BE ADDED TO IGNORE A
# Mixlib::ShellOut::CommandTimeout ERROR DUE TO BANDWIDTH LIMITATIONS. TOO MANY READERS ARE
# INTERMITTENTLY EXPERIENCING THIS PROBLEM AND HAVING TO WORKAROUND THE IT. SINCE THERE ARE
# CUES TO DOWNLOAD THESE ADD-ONS IN THE NOTEBOOKS THAT REQUIRE THEM, IT SEEMS BETTER TO
# AVOID THE ISSUE ALL TOGETHER AT THIS PARTICULAR JUNCTURE.
#
#"punkt maxent_treebank_pos_tagger maxent_ne_chunker words stopwords".each_line do |data|
#  execute "download_nltk_#{data}" do
#    command "python -m nltk.downloader -d /usr/share/nltk_data #{data}"
#    not_if do
#      ::File.exists?("/usr/share/nltk_data/#{data}")
#    end
#  end
#end

runit_service "ipython" do
  default_logger true
  options({
    :port => "8888",
    :notebook_dir => "/vagrant/ipynb",
  })
end
