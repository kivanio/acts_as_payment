require 'test/unit'
require File.dirname(__FILE__) + '/../lib/core_ext_payment.rb'


class CoreExtPaymentTest < Test::Unit::TestCase
  # Teste da Extensão de core do ActAsPayment
  def test_should_return_correct_true_string
    assert_equal true.to_s_br, "Sim"
  end
  
  def test_should_return_correct_false_string
    assert_equal false.to_s_br, "Não"
  end

  def test_should_format_correct_cpf
    assert_equal 98789298790.to_br_cpf, "987.892.987-90"
    assert_equal "98789298790".to_br_cpf, "987.892.987-90"
  end
  
  def test_should_format_correct_cep
    assert_equal 85253100.to_br_cep, "85253-100"
    assert_equal "85253100".to_br_cep, "85253-100"
  end

  def test_should_format_correct_cnpj
    assert_equal 88394510000103.to_br_cnpj, "88.394.510/0001-03"
    assert_equal "88394510000103".to_br_cnpj, "88.394.510/0001-03"
  end
  
  def test_should_format_correct_ie
    assert_equal 999999999.to_br_ie, "99.999.999-9"
    assert_equal "999999999".to_br_ie, "99.999.999-9"
  end

  def test_should_calculate_correct_module10
    assert_equal "0987654321".modulo10, 7
    assert_equal 987654321.modulo10, 7
  end

  def test_should_calculate_correct_module11
    assert_equal "0987654321".modulo11, 6
    assert_equal 987654321.modulo11, 6
  end
 
  def test_should_calculate_correct_addiction_of_numbers
    assert_equal 111.soma_digitos, 3
    assert_equal 8.soma_digitos, 8
    assert_equal "111".soma_digitos, 3
    assert_equal "8".soma_digitos, 8
  end

  def test_should_fill_correctly_with_zeros
    assert_equal 123.zeros_esquerda(5), "00123"
    assert_equal "123".zeros_esquerda(5), "00123"
  end
  
  def test_should_return_correct_object_formated
    assert_equal 999999999.formata_documento, "99.999.999-9"
    assert_equal "999999999".formata_documento, "99.999.999-9"
    assert_equal 98789298790.formata_documento, "987.892.987-90"
    assert_equal "98789298790".formata_documento, "987.892.987-90"
    assert_equal 85253100.formata_documento, "85253-100"
    assert_equal "85253100".formata_documento, "85253-100"
    assert_equal 88394510000103.formata_documento, "88.394.510/0001-03"
    assert_equal "88394510000103".formata_documento, "88.394.510/0001-03"
  end
  
  def test_should_clean_value
    assert_equal "88.39".limpa_valor, "8839"
    assert_equal 88.39.limpa_valor, "88390"
  end
  
  
end
