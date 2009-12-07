# -*- mode: ruby; coding: utf-8 -*-

#
# Simple PHP development helper
#

=begin

TODO

テスト実行時に警告レベルを変えられるようにできるといいな。その機能をひ
な形で埋め込んでしまえばいいのかな。

=end

require 'erb'
require 'fileutils'
include FileUtils::Verbose
require 'rubygems'
require 'highline'

class SimplePhpDevel
  VERSION = '0.0.1'

  def test_dir
    File.join( rake_dir, (::TEST_DIR || 'test') )
  end

  def lib_dir
    File.join( rake_dir, (::LIB_DIR || 'lib') )
  end

  def create_dirs
    %w( test lib ).each { |d|
      create_dir( send( "#{d}_dir" ) )
    }
  end

  def create_class( name )
    create_lib_file( name )
    create_test_file( name )
  end

  def test_files( dir = nil )
    if ( dir )
      Dir.chdir( dir ) {
        Dir.glob( '**/test_*.php' )
      }
    else
      Dir.glob( '**/test_*.php' )
    end
  end

  def create_lib_file( name )
    create_tmpl_file( File.join( lib_dir, lib_file( name ) ),
                      tmpl_class( name ) )
  end

  def create_test_file( name )
    create_tmpl_file( File.join( test_dir, test_file( name ) ),
                      tmpl_test_class( name ) )
  end

  def create_tmpl_file( file, tmpl )
    if ( File.exist?( file ) )
      puts "#{file} already exists !"
    else
      mkdir( File.dirname( file ) ) unless File.exist?( File.dirname( file ) )
      open( file, 'wb' ) { |f|
        f.puts tmpl
      }
      puts "created #{file}"
    end
  end

  def create_dir( dir )
    if ( !File.exist?( dir ) )
      mkdir( dir )
    else
      puts "#{dir} already exist !"
    end
  end

  def classize( name )
    name.split( /[_\/]/ ).map { |e|
      e.capitalize
    }.join( '_' )
  end

  def test_file( name )
    paths = name.split( /\// )
    paths.last.sub!( /(.+)/, 'test_\1.php' )
    paths.join( '/' ) 
  end

  def lib_file( name )
    "#{name}.php"
  end

  def tmpl_class( name )
    return ERB.new( <<EOD ).result( binding )
<?php
/**
 * @since   <%= date = Date.today.to_s %>
 * @package <%= pac  = File.basename( lib_dir )
                pac += ".#{File.dirname(name).capitalize}" if File.dirname( name ) =~ /[^.]/
                pac %>
 */

/**
 * @since   <%= date %>
 * @package <%= pac %>
 */
class <%= classize( name ) %> {
}
EOD
  end

  def tmpl_test_class( name )
    return ERB.new( <<EOD ).result( binding )
<?php
/**
 * @since   <%= date = Date.today.to_s %>
 * @package <%= pac  = File.basename( test_dir )
                pac += ".#{File.dirname(name).capitalize}" if File.dirname( name ) =~ /[^.]/
                pac %>
 */
/** <%= classize( name ) %> */
require_once( '<%= File.join( File.basename( lib_dir ),
                              lib_file( name ) ) %>' );

/**
 * @since   <%= date %>
 * @package <%= pac %>
 */
class Test_<%= classize( name ) %> extends UnitTestCase {
  function Test_<%= classize( name ) %>() {
  }

  function test_any() {
    $this->assertTrue( false );
  }
}

// run tests
if ( realpath( $_SERVER['SCRIPT_FILENAME'] ) == __FILE__ ) {
  $test =& new Test_<%= classize( name ) %>();
  if ( $_SERVER['SERVER_ADDR'] ) {
    $reporter =& new HtmlReporter();
    $reporter->paintHeader( 'Test of <%= "#{File.basename( lib_dir )}/#{lib_file( name )}" %>' );
  } else {
    $reporter =& new TextReporter();
  }
  $test->run( $reporter );
}
EOD
  end

  def exec_test( base_dir = nil )
    base_dir = ( base_dir ) ? base_dir : ENV['PWD']
    test_files( base_dir ).map { |e|
      if ( INI_FILE )
        if ( File.exist?( INI_FILE ) )
          Dir.chdir( File.join( base_dir, File.dirname( e ) ) ) {
            puts "php -c #{INI_FILE} -f #{File.basename( e )}"
            system( "php -c #{INI_FILE} -f #{File.basename( e )}" )
          }
        else
          puts "#{INI_FILE} not exist !"
        end
      else
        Dir.chdir( File.join( base_dir, File.dirname( e ) ) ) {
          system( "php -f #{File.basename( e )}`" )
        }
      end
    }
  end
end
