require 'test/unit'
require 'rubygems'
require 'rghost'
require 'rghost_barcode'

require File.dirname(__FILE__) + '/../lib/core_ext_payment.rb'
require File.dirname(__FILE__) + '/../lib/boleto/boleto.rb'
require File.dirname(__FILE__) + '/../lib/boleto/bancobrasil.rb'

class BancoBrasilTest < Test::Unit::TestCase

  def setup
    @boleto_novo = BancoBrasil.new
  end

  def boleto_um
    @boleto_novo.banco = "001"
    @boleto_novo.carteira = "18"
    @boleto_novo.moeda = "9"
    @boleto_novo.valor_documento = 135.00
    @boleto_novo.convenio = 1238798
    @boleto_novo.nosso_numero = "7777700168"
    @boleto_novo.data_vencimento = Date.parse("2008-02-01")
  end
  
  def boleto_dois
    @boleto_novo.banco = "001"
    @boleto_novo.carteira = "18"
    @boleto_novo.moeda = "9"
    @boleto_novo.valor_documento = 723.56
    @boleto_novo.convenio = 1238798
    @boleto_novo.nosso_numero = "7777700168"
    @boleto_novo.data_vencimento = Date.parse("2008-02-01")
  end
  
  def boleto_nil
    @boleto_novo.banco = ""
    @boleto_novo.carteira = ""
    @boleto_novo.moeda = ""
    @boleto_novo.valor_documento = 0
    @boleto_novo.convenio = ""
    @boleto_novo.nosso_numero = ""
    @boleto_novo.data_vencimento = Date.parse("2008-02-01")
  end

  def test_should_calculate_correct_addiction_of_numbers
    assert_equal 3, @boleto_novo.soma_digitos(111)
    assert_equal 8, @boleto_novo.soma_digitos(8)
    assert_equal 0, @boleto_novo.soma_digitos("111")
    assert_equal 0, @boleto_novo.soma_digitos("8")
    assert_kind_of( Fixnum, @boleto_novo.soma_digitos(111) )
  end

  def test_should_fill_correctly_with_zeros
    assert_equal "123", @boleto_novo.zeros_esquerda("123",0)
    assert_equal "123", @boleto_novo.zeros_esquerda("123",1)
    assert_equal "123", @boleto_novo.zeros_esquerda("123",2)
    assert_equal "123", @boleto_novo.zeros_esquerda("123",3)
    assert_equal "0123", @boleto_novo.zeros_esquerda("123",4)
    assert_equal "00123", @boleto_novo.zeros_esquerda("123",5)
    assert_equal "0000000123", @boleto_novo.zeros_esquerda("123",10)
    assert_kind_of( String, @boleto_novo.zeros_esquerda("123",5) )
  end

  def test_should_calculate_correct_module10
    assert_equal nil, @boleto_novo.modulo10("")
    assert_equal nil, @boleto_novo.modulo10
    assert_equal 5, @boleto_novo.modulo10("001905009")
    assert_equal 9, @boleto_novo.modulo10("4014481606")
    assert_equal 4, @boleto_novo.modulo10("0680935031")
    assert_equal 5, @boleto_novo.modulo10("29004590")
    assert_kind_of( Fixnum, @boleto_novo.modulo10("001905009") )
  end

  def test_should_calculate_correct_modulo11_9to2
    assert_equal 9, @boleto_novo.modulo11_9to2("85068014982")
    assert_equal 1, @boleto_novo.modulo11_9to2("05009401448")
    assert_equal 2, @boleto_novo.modulo11_9to2("12387987777700168")
    assert_equal 8, @boleto_novo.modulo11_9to2("4042")
    assert_equal 0, @boleto_novo.modulo11_9to2("61900")
    assert_equal 6, @boleto_novo.modulo11_9to2("0719")
    assert_equal 5, @boleto_novo.modulo11_9to2("000000005444")
    assert_equal 5, @boleto_novo.modulo11_9to2("5444")
    assert_equal 3, @boleto_novo.modulo11_9to2("01129004590")
    assert_kind_of( Fixnum, @boleto_novo.modulo11_9to2("5444") )
    assert_kind_of( Fixnum, @boleto_novo.modulo11_9to2("000000005444") )
  end

  def test_should_calculate_correct_modulo11_9to2_bb
    assert_equal 9, @boleto_novo.modulo11_9to2_bb("85068014982")
    assert_equal 1, @boleto_novo.modulo11_9to2_bb("05009401448")
    assert_equal 2, @boleto_novo.modulo11_9to2_bb("12387987777700168")
    assert_equal 8, @boleto_novo.modulo11_9to2_bb("4042")
    assert_equal 0, @boleto_novo.modulo11_9to2_bb("61900")
    assert_equal 6, @boleto_novo.modulo11_9to2_bb("0719")
    assert_equal 5, @boleto_novo.modulo11_9to2_bb("000000005444")
    assert_equal 5, @boleto_novo.modulo11_9to2_bb("5444")
    assert_equal 3, @boleto_novo.modulo11_9to2_bb("01129004590")
    assert_equal "X", @boleto_novo.modulo11_9to2_bb("15735")
    assert_kind_of( String, @boleto_novo.modulo11_9to2_bb("15735") )
    assert_kind_of( Fixnum, @boleto_novo.modulo11_9to2_bb("5444") )
    assert_kind_of( Fixnum, @boleto_novo.modulo11_9to2_bb("000000005444") )
  end

  def test_should_calculate_correct_modulo11_2to9
    assert_equal 3, @boleto_novo.modulo11_2to9("0019373700000001000500940144816060680935031")
    assert_kind_of( Fixnum, @boleto_novo.modulo11_2to9("0019373700000001000500940144816060680935031") )
  end

  def test_should_mont_correct_codigo_barras
    boleto_um
    assert_equal "00192376900000135000000001238798777770016818", @boleto_novo.codigo_barras
    boleto_dois
    assert_equal "00194376900000723560000001238798777770016818", @boleto_novo.codigo_barras
    boleto_nil
    assert_equal nil, @boleto_novo.codigo_barras
  end

  def test_should_mont_correct_linha_digitalvel
    boleto_um
    assert_equal("00190.00009 01238.798779 77700.168188 2 37690000013500", @boleto_novo.linha_digitavel(@boleto_novo.codigo_barras))
    boleto_dois
    assert_equal("00190.00009 01238.798779 77700.168188 4 37690000072356", @boleto_novo.linha_digitavel(@boleto_novo.codigo_barras))
    assert_kind_of( String, @boleto_novo.linha_digitavel(@boleto_novo.codigo_barras))
    boleto_nil
    assert_equal nil, @boleto_novo.linha_digitavel(@boleto_novo.codigo_barras)
  end

end