class Boleto
  # necessario para gerar codigo de barras
  include RGhost unless self.include?(RGhost)

  attr_accessor :banco
  attr_accessor :convenio
  attr_accessor :contrato
  attr_accessor :moeda
  attr_accessor :carteira
  attr_accessor :variacao
  attr_accessor :data_processamento
  attr_accessor :dias_vencimento
  attr_accessor :data_vencimento
  attr_accessor :quantidade
  attr_accessor :valor
  attr_accessor :valor_documento
  attr_accessor :nosso_numero
  attr_accessor :nosso_numero_dv
  attr_accessor :agencia
  attr_accessor :agencia_dv
  attr_accessor :conta_corrente
  attr_accessor :conta_corrente_dv
  attr_accessor :cedente
  attr_accessor :documento_cedente
  attr_accessor :numero_documento
  attr_accessor :especie
  attr_accessor :especie_documento
  attr_accessor :data_documento
  attr_accessor :sacado
  attr_accessor :documento_sacado
  attr_accessor :instrucao1
  attr_accessor :instrucao2
  attr_accessor :instrucao3
  attr_accessor :instrucao4
  attr_accessor :instrucao5
  attr_accessor :instrucao6
  attr_accessor :instrucao7
  attr_accessor :local_pagamento
  attr_accessor :aceite
  attr_accessor :sacado_linha1
  attr_accessor :sacado_linha2
  attr_accessor :sacado_linha3
  
  # validates_presence_of :banco, :message => "Banco não pode estar em branco."
  #  validates_presence_of :agencia, :message => "Agência não pode estar em branco."
  #  validates_presence_of :conta_corrente, :message => "Conta Corrente não pode estar em branco."
  #  validates_presence_of :especie_documento, :message => "Espécie de Documento não pode estar em branco."
  #  validates_presence_of :especie, :message => "Espécie não pode estar em branco."
  #  validates_presence_of :moeda, :message => "Moeda não pode estar em branco."
  #  validates_presence_of :data_processamento, :message => "Date de Processamento não pode estar em branco."
  #  validates_presence_of :dias_vencimento, :message => "Dias para o Vencimento não pode estar em branco."
  #  validates_presence_of :data_vencimento, :message => "Data de Vencimento não pode estar em branco."
  #  validates_presence_of :aceite, :message => "Aceite não pode estar em branco."
  #  validates_presence_of :quantidade, :message => "Quantidade não pode estar em branco."
  #  validates_presence_of :valor_documento, :message => "Valor do Documento não pode estar em branco."
  #  validates_presence_of :cedente, :message => "Cedente não pode estar em branco."
  #  validates_presence_of :documento_cedente, :message => "Documento do Cedente não pode estar em branco."
  #  validates_presence_of :nosso_numero, :message => "Nosso Número não pode estar em branco."
  #  validates_presence_of :sacado, :message => "Sacado não pode estar em branco."
  #  validates_presence_of :documento_sacado, :message => "Documento do Sacado não pode estar em branco."

  def initialize
    self.especie_documento = "DM"
    self.especie = "R$"
    self.moeda = "9"
    self.data_processamento = Date.today
    self.data_documento = self.data_processamento
    self.dias_vencimento = 0
    self.data_vencimento = self.data_processamento
    self.aceite = "N"
    self.quantidade = 1
    self.valor = 0.0
    self.valor_documento = 0.0
    self.local_pagamento = "QUALQUER BANCO ATÉ O VENCIMENTO"
  end
  
  # Monta a linha digitavel padrao para todos os bancos segundo a BACEN
  # Retorna + nil + para Codigo de Barras em branco, 
  # Codigo de Barras com tamanho diferente de 44 digitos e 
  # Codigo de Barras que não tenham somente caracteres numericos 
  def linha_digitavel(valor_inicial="")
    return nil if (valor_inicial !~ /\S/) || valor_inicial.size != 44 || (!valor_inicial.scan(/\D/).empty?)

    campo_1_a = "#{valor_inicial[0..3]}"
    campo_1_b = "#{valor_inicial[19..23]}"
    dv_1 = self.modulo10("#{campo_1_a}#{campo_1_b}")
    campo_1_dv = "#{campo_1_a}#{campo_1_b}#{dv_1}"
    campo_linha_1 = "#{campo_1_dv[0..4]}.#{campo_1_dv[5..9]}"

    campo_2 = "#{valor_inicial[24..33]}"
    dv_2 = self.modulo10(campo_2)
    campo_2_dv = "#{campo_2}#{dv_2}"
    campo_linha_2 = "#{campo_2_dv[0..4]}.#{campo_2_dv[5..10]}"

    campo_3 = "#{valor_inicial[34..43]}"
    dv_3 = self.modulo10(campo_3)
    campo_3_dv = "#{campo_3}#{dv_3}"
    campo_linha_3 = "#{campo_3_dv[0..4]}.#{campo_3_dv[5..10]}"

    campo_linha_4 = "#{valor_inicial[4..4]}"

    campo_linha_5 = "#{valor_inicial[5..18]}"

    linha = "#{campo_linha_1} #{campo_linha_2} #{campo_linha_3} #{campo_linha_4} #{campo_linha_5}"

    return linha
  end

  # metodo padrao para calculo de modulo 10 segundo a BACEN
  def modulo10(valor_inicial="")
      return nil if (valor_inicial !~ /\S/)

      total = 0
      multiplicador = 2

      for caracter in valor_inicial.split(//).reverse!
        total += self.soma_digitos(caracter.to_i * multiplicador)
        multiplicador = multiplicador == 2 ? 1 : 2
      end

      valor = (10 - (total % 10))
      return valor == 10 ? 0 : valor
  end

  # metodo padrao para calculo de modulo 11 com multiplicaroes de 9 a 2 segundo a BACEN
  # Usado no DV do Nosso Numero, Agencia e Cedente
  # Retorna + nil + para todos os parametros que nao forem String
  # Retorna + nil + para String em branco
  def modulo11_9to2(valor_inicial="")
    return nil if (valor_inicial !~ /\S/)

    multiplicadores = [9,8,7,6,5,4,3,2]
    total = 0
    multiplicador_posicao = 0

    for caracter in valor_inicial.split(//).reverse!
      multiplicador_posicao = 0 if (multiplicador_posicao == 8)
      total += (caracter.to_i * multiplicadores[multiplicador_posicao])
      multiplicador_posicao += 1
    end

    return (total % 11 )
  end

  # metodo padrao para calculo de modulo 11 com multiplicaroes de 2 a 9 segundo a BACEN
  # Usado no DV do Codigo de Barras
  # Retorna + nil + para todos os parametros que nao forem String
  # Retorna + nil + para String em branco
  def modulo11_2to9(valor_inicial="")
    return nil if (valor_inicial !~ /\S/)

    multiplicadores = [2,3,4,5,6,7,8,9]
    total = 0
    multiplicador_posicao = 0

    for caracter in valor_inicial.split(//).reverse!
      multiplicador_posicao = 0 if (multiplicador_posicao == 8)
      total += (caracter.to_i * multiplicadores[multiplicador_posicao])
      multiplicador_posicao += 1
    end

    valor = (11 - (total % 11))
    return [0,10,11].include?(valor) ? 1 : valor
  end

  # Soma numeros inteiros positivos com 2 dígitos ou mais
  # Retorna 0(zero) para qualquer outro paramentro passado
  # Ex. 1 = 1
  #     11 = (1+1) = 2
  #     13 = (1+3) = 4
  def soma_digitos(valor_inicial=0)
    return 0 if (valor_inicial == 0 ) || !valor_inicial.kind_of?(Fixnum)
    return valor_inicial if valor_inicial <= 9

    valor_inicial = valor_inicial.to_s
    total = 0

    0.upto(valor_inicial.size-1) {|digito| total += valor_inicial[digito,1].to_i }

    return total
  end

  # Completa zeros a esquerda
  # Ex. numero="123" tamanho=3 | numero="123"
  #     numero="123" tamanho=4 | numero="0123"
  #     numero="123" tamanho=5 | numero="00123"
  def zeros_esquerda(valor_inicial="",digitos=self.to_s.size)
    return valor_inicial if (valor_inicial !~ /\S/)
    diferenca = (digitos - valor_inicial.size)

    return valor_inicial if (diferenca <= 0)
    return (("0" * diferenca) + valor_inicial )
  end
  
  def fator_vencimento
    return nil unless self.data_vencimento.kind_of?(Date)
    self.data_vencimento.fator_vencimento
  end

end

