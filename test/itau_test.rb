$:.unshift File.join(File.dirname(__FILE__), "..", "lib")
require 'test/unit'

require 'rubygems'
require 'rghost'
require 'rghost_barcode'
require 'core_ext_payment.rb'
require 'boleto/boleto.rb'
require 'boleto/itau.rb'

class ItauTest < Test::Unit::TestCase

  BOLETO_ITAU_CARTEIRA_175 = {
    :carteira => "175",
    :moeda => "9",
    :valor_documento => 135.00,
    :convenio => 0,
    :nosso_numero => "12345678",
    :data_vencimento => Date.parse("2008-02-01"),
    :agencia => "0810",
    :conta_corrente => "53678"
  }
  
  def setup
    @boleto_novo = Itau.new # (BOLETO_CARTEIRA_175)
    BOLETO_ITAU_CARTEIRA_175.each do |nome, valor|
      @boleto_novo.send("#{nome}=".to_sym, valor)
    end
  end

  def test_should_return_correct_conta_corrente_dv
    @boleto_novo.agencia = "0607"
    @boleto_novo.conta_corrente = "15255"
    assert_equal 0, @boleto_novo.calcula_conta_corrente_dv
    @boleto_novo.agencia = "1547"
    @boleto_novo.conta_corrente = "85547"
    assert_equal 6, @boleto_novo.calcula_conta_corrente_dv
    @boleto_novo.agencia = "1547"
    @boleto_novo.conta_corrente = "10207"
    assert_equal 7, @boleto_novo.calcula_conta_corrente_dv
    @boleto_novo.agencia = "0811"
    @boleto_novo.conta_corrente = "53678"
    assert_equal 8, @boleto_novo.calcula_conta_corrente_dv
  end
  
  def test_should_verify_nosso_numero_dv_calculation
     @boleto_novo.nosso_numero = "00015448"
     assert_equal 6, @boleto_novo.calcula_nosso_numero_dv
     @boleto_novo.nosso_numero = "15448"
     assert_equal 6, @boleto_novo.calcula_nosso_numero_dv
     @boleto_novo.nosso_numero = "12345678"
     assert_equal 4, @boleto_novo.calcula_nosso_numero_dv
     @boleto_novo.nosso_numero = "34230"
     assert_equal 5, @boleto_novo.calcula_nosso_numero_dv
     @boleto_novo.nosso_numero = "258281"
     assert_equal 7, @boleto_novo.calcula_nosso_numero_dv
  end
  
  def test_should_build_correct_barcode
    assert_equal "34195376900000135001751234567840810536789000", @boleto_novo.codigo_barras
    @boleto_novo.nosso_numero = "258281"
    @boleto_novo.data_vencimento = "2004/09/03".to_date
    assert_equal "34195252300000135001750025828170810536789000", @boleto_novo.codigo_barras
  end
  
  def test_should_build_correct_typeable_line
    
    assert_equal "34191.75124 34567.840813 05367.890000 5 37690000013500", @boleto_novo.linha_digitavel(@boleto_novo.codigo_barras)
    
    @boleto_novo.nosso_numero = "258281"
    @boleto_novo.data_vencimento = "2004/09/03".to_date
    assert_equal "34191.75009 25828.170818 05367.890000 5 25230000013500", @boleto_novo.linha_digitavel(@boleto_novo.codigo_barras)
  end

end