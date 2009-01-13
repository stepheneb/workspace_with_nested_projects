#!/usr/bin/env ruby
#
# Create a git clone of the svn repo https://svn.concord.org/svn/projects/trunk/common:
#
#   git svn clone -Tcommon --prefix=svn/ https://svn.concord.org/svn/projects/trunk concord-projects-common.svn.git
#
# change to that dir and compress the new git clone once again:
#
#  cd concord-projects-common.svn.git
#  git gc
#
# Run this script to create a new dir named 'workspace' at the top level with symbolic links 
# all the directories that have a .project file inside them.
#
# The result should be a dir that emulates the flat project space that Eclipse needs
# see: Eclipse bug: https://bugs.eclipse.org/bugs/show_bug.cgi?id=35973
#
# Open Eclipse, swith to a new Workspace, select the newly-created 'workspace' dir and import 
# the projects you want to work on.

require 'fileutils'
# include FileUtils::Verbose

if File.exists?('workspace')
  FileUtils.rmdir('workspace')
end
FileUtils.mkdir('workspace')

projects = Dir["**/.project"].collect {|p| p[/(.*)\/\.project/, 1 ] }

Dir.chdir('workspace') do
  projects.each { |p| FileUtils.ln_s("../#{p}", File.basename(p)) }
end
