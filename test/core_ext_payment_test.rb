require 'test/unit'
require File.dirname(__FILE__) + '/../lib/core_ext_payment.rb'


class CoreExtPaymentTest < Test::Unit::TestCase
  # Teste da Extensão de core do ActAsPayment
  def test_should_return_correct_true_string
    assert_equal "Sim", true.to_s_br
  end
  
  def test_should_return_correct_false_string
    assert_equal  "Não", false.to_s_br
  end

  def test_should_format_correct_cpf
    assert_equal "987.892.987-90", 98789298790.to_br_cpf
    assert_equal "987.892.987-90", "98789298790".to_br_cpf
  end
  
  def test_should_format_correct_cep
    assert_equal "85253-100", 85253100.to_br_cep
    assert_equal "85253-100", "85253100".to_br_cep
  end

  def test_should_format_correct_cnpj
    assert_equal "88.394.510/0001-03", 88394510000103.to_br_cnpj
    assert_equal "88.394.510/0001-03", "88394510000103".to_br_cnpj
  end
  
  def test_should_format_correct_ie
    assert_equal "99.999.999-9", 999999999.to_br_ie
    assert_equal "99.999.999-9", "999999999".to_br_ie
  end

  def test_should_calculate_correct_module10
    assert_equal 7, "0987654321".modulo10
    assert_equal 7, 987654321.modulo10
  end

  def test_should_calculate_correct_module11
    assert_equal 6, "0987654321".modulo11
    assert_equal 6, 987654321.modulo11
  end
 
  def test_should_calculate_correct_addiction_of_numbers
    assert_equal 3, 111.soma_digitos
    assert_equal 8, 8.soma_digitos
    assert_equal 3, "111".soma_digitos
    assert_equal 8, "8".soma_digitos
  end

  def test_should_fill_correctly_with_zeros
    assert_equal "00123", 123.zeros_esquerda(5)
    assert_equal "00123", "123".zeros_esquerda(5)
  end
  
  def test_should_return_correct_object_formated
    assert_equal "99.999.999-9", 999999999.formata_documento
    assert_equal "99.999.999-9", "999999999".formata_documento
    assert_equal "987.892.987-90", 98789298790.formata_documento
    assert_equal "987.892.987-90", "98789298790".formata_documento
    assert_equal "85253-100", 85253100.formata_documento
    assert_equal "85253-100", "85253100".formata_documento
    assert_equal "88.394.510/0001-03", 88394510000103.formata_documento
    assert_equal "88.394.510/0001-03", "88394510000103".formata_documento
  end
  
  def test_should_clean_value
    assert_equal "8839", "88.39".limpa_valor
    assert_equal "88390", 88.39.limpa_valor
  end
  
  
end
