name 'zca_build_server'
description 'A build server for use by the ZCA'
run_list 'recipe[zca_build_server::alpha4]', 'recipe[mysql::server55]'