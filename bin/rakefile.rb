# -*- mode: ruby; coding: utf-8 -*-

def rake_dir
  File.dirname( __FILE__ )
end

TEST_DIR = nil
LIB_DIR  = nil
INI_FILE = File.join( SimplePhpDevel.new.test_dir, 'php.my.ini' )

# delete me
require File.dirname( __FILE__ ) + '/../lib/simple_php_devel'

desc "setup env"
task :init do
  SimplePhpDevel.new.create_dirs
end

desc "scaffold new module"
task :scaffold do
  name = HighLine.new.ask( 'What name of library do you want to create: '
                           ) do |q|
    q.readline = true
  end
  SimplePhpDevel.new.create_class( name )
end

task :test do
  SimplePhpDevel.new.exec_test
end

desc "test all test cases"
task :testall do
  devel = SimplePhpDevel.new
  devel.exec_test( devel.test_dir )
end

task :default => :test do
end

