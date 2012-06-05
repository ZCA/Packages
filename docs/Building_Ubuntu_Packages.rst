========================
Building Ubuntu Packages
========================

.. contents::
   :depth: 4
   
Setup Build Server
------------------
Start by setting up a build server using our chef cookbooks
:doc:`setup_build_server`

Next Install a Few extra packages. This will get included into the main cookbooks, if this process pans out

	sudo apt-get install dpkg-dev debhelper devscripts fakeroot linda dh-make

Get to Work
-----------
Start by getting logged in as the zenoss user and getting into the source directory::

	sudo su - zenoss
	cd ~/install-sources
	
Use *dh_make* to setup some structure::

	dh_make -n -s -p zenoss_4.1.70
	
Edit *debian/control*. @Todo: Flush This Out

Edit *debian/rules*. @Todo: Flush This Out

Kick off a build::

	fakeroot debian/rules clean


References
----------
The following pages were used as references when deriving this process.

* http://www.debian.org/doc/manuals/maint-guide/maint-guide.en.pdf
* http://www.debian-administration.org/articles/336
* http://www.debian-administration.org/article/337/Rolling_your_own_Debian_packages_part_2
* http://grumbel.blogspot.com/2010/05/how-to-build-ubuntu-package.html
* http://answers.oreilly.com/topic/451-how-to-create-an-ubuntu-package/

