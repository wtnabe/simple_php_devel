require File.dirname(__FILE__) + '/test_helper.rb'

def rake_dir
  File.dirname( __FILE__ )
end

TEST_DIR = nil
LIB_DIR  = nil

require "test/unit"
class SimplePhpdevelTest < Test::Unit::TestCase
  @verbose = false

  def setup
    @obj = SimplePhpDevel.new
  end

  def test_test_dir
    assert @obj.test_dir == './test/test'
  end

  def test_lib_dir
    assert @obj.lib_dir == './test/lib'
  end

  def test_create_dirs
#    assert nil
  end

  def test_create_class
#    assert nil
  end

  def test_test_files
    assert( @obj.test_files( 'test/sample' ) == %w( test_abc.php ) )
    assert( @obj.test_files() == %w( test/sample/test_abc.php
                                     test/test_sample.php ) )
  end

  def test_create_dir
#    assert nil
  end

  def test_classize
    assert( @obj.classize( 'abcdef' ) == 'Abcdef' )
    assert( @obj.classize( 'abc_def' ) == 'Abc_Def' )
    assert( @obj.classize( 'abc/def' ) == 'Abc_Def' )
  end

  def test_test_file
    assert( @obj.test_file( 'abcdef' ) == 'test_abcdef.php' )
    assert( @obj.test_file( 'abc_def' ) == 'test_abc_def.php' )
    assert( @obj.test_file( 'abc/def' ) == 'abc/test_def.php' )
  end

  def test_lib_file
    assert( @obj.lib_file( 'abcdef' ) == 'abcdef.php' )
    assert( @obj.lib_file( 'abc_def' ) == 'abc_def.php' )
    assert( @obj.lib_file( 'abc/def' ) == 'abc/def.php' )
  end

  def test_class_tmpl
    if ( @verbose )
      puts @obj.tmpl_class( 'klass' )
    end
  end

  def test_test_class_tmpl
    if ( @verbose )
      puts @obj.tmpl_test_class( 'klass' )
    end
  end
end
