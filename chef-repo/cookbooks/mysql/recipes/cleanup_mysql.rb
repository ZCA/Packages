################################
#
# clean up older versions of mysql
#
################################


# cleanup the old mysql stuff on the host first
# this is currently not platform specific 
# TODO: make this work on all platforms
# TODO: not sure if this is actually needed at all
#old_mysql_packages = %w{ mysql-client-5.1 mysql-client-core-5.1 mysql-common mysql-server mysql-server-5.1 mysql-server-core-5.1 mysql-connector-odbc mysql-libs }

#old_mysql_packages.each do |pkg|
#  package pkg do
#    action :purge
#  end
#end


