# -*- mode: ruby; coding: utf-8 -*-

module SCM
  %w( svn hg git ).each { |scm|
    define_method( "scm_#{scm}?".to_sym ) {
      File.exist?( ".#{scm}" ) and which( scm )
    }
  }
end
include SCM

def which( cmd )
  path = ENV['PATH']

  paths = path.split( File::PATH_SEPARATOR ).select { |path|
    File.exist?( path ) and File.exist?( File.join( path, cmd ) )
  }
  if ( paths.size > 0 )
    paths.first + File::SEPARATOR + cmd
  else
    nil
  end
end

def cut( cmd, chr = '?' )
  `#{cmd}`.map { |line|
    c = line.split( /\s+/ )
    if ( c[0] =~ Regexp.new( "[#{chr}]" ) )
      c[c.size-1]
    else
      nil
    end
  }.compact
end

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

if ( methods.grep( /\Ascm_/ ).size > 0 )
  desc "list up untracked files"
  task :untracked do
    if ( scm_hg? )
      puts cut( 'hg stat -A', 'I?' )
    elsif ( scm_git? )
      puts `git ls-files -o`
    elsif ( scm_svn? )
      puts cut( 'svn stat -v', '?' )
    end
  end
end

task :default => :test do
end

