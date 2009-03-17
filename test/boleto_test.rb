$:.unshift File.join(File.dirname(__FILE__), "..", "lib")
require 'test/unit'
require 'brcobranca'

class BoletoTest < Test::Unit::TestCase

  def setup
    @boleto = Boleto.new
  end

  def test_should_calculate_correct_addiction_of_numbers
    assert_equal 3, @boleto.soma_digitos(111)
    assert_equal 8, @boleto.soma_digitos(8)
    assert_equal 0, @boleto.soma_digitos("111")
    assert_equal 0, @boleto.soma_digitos("8")
    assert_kind_of( Fixnum, @boleto.soma_digitos(111) )
  end

  def test_should_fill_correctly_with_zeros
    assert_equal "123", @boleto.zeros_esquerda("123",0)
    assert_equal "123", @boleto.zeros_esquerda("123",1)
    assert_equal "123", @boleto.zeros_esquerda("123",2)
    assert_equal "123", @boleto.zeros_esquerda("123",3)
    assert_equal "0123", @boleto.zeros_esquerda("123",4)
    assert_equal "00123", @boleto.zeros_esquerda("123",5)
    assert_equal "0000000123", @boleto.zeros_esquerda("123",10)
    assert_kind_of( String, @boleto.zeros_esquerda("123",5) )
  end

  def test_should_calculate_correct_module10
    assert_equal nil, @boleto.modulo10("")
    assert_equal nil, @boleto.modulo10
    assert_equal 5, @boleto.modulo10("001905009")
    assert_equal 9, @boleto.modulo10("4014481606")
    assert_equal 4, @boleto.modulo10("0680935031")
    assert_equal 5, @boleto.modulo10("29004590")
    assert_kind_of( Fixnum, @boleto.modulo10("001905009") )
  end

  def test_should_calculate_correct_modulo11_9to2
    assert_equal 9, @boleto.modulo11_9to2("85068014982")
    assert_equal 1, @boleto.modulo11_9to2("05009401448")
    assert_equal 2, @boleto.modulo11_9to2("12387987777700168")
    assert_equal 8, @boleto.modulo11_9to2("4042")
    assert_equal 0, @boleto.modulo11_9to2("61900")
    assert_equal 6, @boleto.modulo11_9to2("0719")
    assert_equal 5, @boleto.modulo11_9to2("000000005444")
    assert_equal 5, @boleto.modulo11_9to2("5444")
    assert_equal 3, @boleto.modulo11_9to2("01129004590")
    assert_kind_of( Fixnum, @boleto.modulo11_9to2("5444") )
    assert_kind_of( Fixnum, @boleto.modulo11_9to2("000000005444") )
  end

  def test_should_calculate_correct_modulo11_2to9
    assert_equal 3, @boleto.modulo11_2to9("0019373700000001000500940144816060680935031")
    assert_kind_of( Fixnum, @boleto.modulo11_2to9("0019373700000001000500940144816060680935031") )
  end

  def test_should_mont_correct_linha_digitalvel
    assert_equal("00190.00009 01238.798779 77700.168188 2 37690000013500", @boleto.linha_digitavel("00192376900000135000000001238798777770016818"))
    assert_kind_of( String, @boleto.linha_digitavel("00192376900000135000000001238798777770016818"))
    assert_equal nil, @boleto.linha_digitavel("")
    assert_equal nil, @boleto.linha_digitavel("00193373700")
    assert_equal nil, @boleto.linha_digitavel("0019337370000193373700")
    assert_equal nil, @boleto.linha_digitavel("00b193373700bb00193373700")
    assert_equal nil, @boleto.linha_digitavel("0019337370000193373700bbb")
    assert_equal nil, @boleto.linha_digitavel("0019237690000c135000c0000123f7987e7773016813")
  end

end