require 'test/unit'
File.dirname(__FILE__) + '/../lib/retorno/retorno_cbr643'

class RetornoCbr643Test < Test::Unit::TestCase
  

  def retorno_com_arquivo
    arquivo = File.join(File.dirname(__FILE__), '..', 'arquivos', 'exemplo', 'CBR64310.RET')
    @retornos = RetornoCbr643.new(arquivo)
  end

  def retorno_sem_arquivo
    @retornos = RetornoCbr643.new()
  end

  def test_should_correct_return_retorno
    retorno_com_arquivo
    assert_equal("000002", @retornos.retorno.first[:sequencial])
    
    retorno_sem_arquivo
    assert_raise RuntimeError do
      raise 'Arquivo não encontrado'
    end
  end

end