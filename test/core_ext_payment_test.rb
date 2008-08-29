$:.unshift File.join(File.dirname(__FILE__), "..", "lib")
require 'core_ext_payment.rb'
require 'test/unit'
require 'date'

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

  def test_should_return_true_is_moeda
    assert_equal true, 1234.03.to_s.moeda?
    assert_equal true, +1234.03.to_s.moeda?
    assert_equal true, -1234.03.to_s.moeda?
    assert_equal false, 123403.to_s.moeda?
    assert_equal false, -123403.to_s.moeda?
    assert_equal false, +123403.to_s.moeda?
    assert_equal true, "1234.03".moeda?
    assert_equal true, "1234,03".moeda?
    assert_equal true, "1,234.03".moeda?
    assert_equal true, "1.234.03".moeda?
    assert_equal true, "1,234,03".moeda?
    assert_equal true, "12.340,03".moeda?
    assert_equal true, "+1234.03".moeda?
    assert_equal true, "+1234,03".moeda?
    assert_equal true, "+1,234.03".moeda?
    assert_equal true, "+1.234.03".moeda?
    assert_equal true, "+1,234,03".moeda?
    assert_equal true, "+12.340,03".moeda?
    assert_equal true, "-1234.03".moeda?
    assert_equal true, "-1234,03".moeda?
    assert_equal true, "-1,234.03".moeda?
    assert_equal true, "-1.234.03".moeda?
    assert_equal true, "-1,234,03".moeda?
    assert_equal true, "-12.340,03".moeda?
    assert_equal false, "1234ab".moeda?
    assert_equal false, "ab1213".moeda?
    assert_equal false, "ffab".moeda?
    assert_equal false, "1234".moeda?
  end

  def test_should_return_correct_number_days
    assert_equal 3769, (Date.parse "2008-02-01").fator_vencimento
    assert_equal 3770, (Date.parse "2008-02-02").fator_vencimento
    assert_equal 3774, (Date.parse "2008-02-06").fator_vencimento
  end
  
  def test_should_return_correct_formated_date
    assert_equal "01/02/2008", (Date.parse "2008-02-01").to_s_br
    assert_equal "02/02/2008", (Date.parse "2008-02-02").to_s_br
    assert_equal "06/02/2008", (Date.parse "2008-02-06").to_s_br
  end

  def test_should_clean_value
    assert_equal "123403", 1234.03.limpa_valor_moeda
    assert_equal "123403", +1234.03.limpa_valor_moeda
    assert_equal "123403", -1234.03.limpa_valor_moeda
    assert_equal 123403, 123403.limpa_valor_moeda
    assert_equal -123403, -123403.limpa_valor_moeda
    assert_equal 123403, +123403.limpa_valor_moeda
    assert_equal "123403", "1234.03".limpa_valor_moeda
    assert_equal "123403", "1234,03".limpa_valor_moeda
    assert_equal "123403", "1,234.03".limpa_valor_moeda
    assert_equal "123403", "1.234.03".limpa_valor_moeda
    assert_equal "123403", "1,234,03".limpa_valor_moeda
    assert_equal "1234003", "12.340,03".limpa_valor_moeda
    assert_equal "123403", "+1234.03".limpa_valor_moeda
    assert_equal "123403", "+1234,03".limpa_valor_moeda
    assert_equal "123403", "+1,234.03".limpa_valor_moeda
    assert_equal "123403", "+1.234.03".limpa_valor_moeda
    assert_equal "123403", "+1,234,03".limpa_valor_moeda
    assert_equal "1234003", "+12.340,03".limpa_valor_moeda
    assert_equal "123403", "-1234.03".limpa_valor_moeda
    assert_equal "123403", "-1234,03".limpa_valor_moeda
    assert_equal "123403", "-1,234.03".limpa_valor_moeda
    assert_equal "123403", "-1.234.03".limpa_valor_moeda
    assert_equal "123403", "-1,234,03".limpa_valor_moeda
    assert_equal "1234003", "-12.340,03".limpa_valor_moeda
    assert_equal "1234ab", "1234ab".limpa_valor_moeda
    assert_equal "ab1213", "ab1213".limpa_valor_moeda
    assert_equal "ffab", "ffab".limpa_valor_moeda
    assert_equal "1234", "1234".limpa_valor_moeda
  end

end
