class Boleto
  #necessario para gerar codigo de barras
  include RGhost

  attr_accessor :banco
  attr_accessor :banco_dv
  attr_accessor :convenio
  attr_accessor :contrato
  attr_accessor :moeda
  attr_accessor :carteira
  attr_accessor :data_processamento
  attr_accessor :dias_vencimento
  attr_accessor :data_vencimento
  attr_accessor :quantidade
  attr_accessor :valor
  attr_accessor :valor_documento
  attr_accessor :valor_documento_limpo
  attr_accessor :nosso_numero
  attr_accessor :nosso_numero_dv
  attr_accessor :agencia
  attr_accessor :agencia_dv
  attr_accessor :conta_corrente
  attr_accessor :conta_corrente_dv
  attr_accessor :fator_vencimento
  attr_accessor :linha_digitavel
  attr_accessor :codigo_barras
  attr_accessor :cedente
  attr_accessor :documento_cedente
  attr_accessor :numero_documento
  attr_accessor :especie
  attr_accessor :especie_documento
  attr_accessor :data_documento
  attr_accessor :sacado
  attr_accessor :instrucao1
  attr_accessor :instrucao2
  attr_accessor :instrucao3
  attr_accessor :instrucao4
  attr_accessor :instrucao5
  attr_accessor :instrucao6
  attr_accessor :instrucao7
  attr_accessor :local_pagamento
  attr_accessor :documento_sacado
  attr_accessor :aceite
  attr_accessor :sacado_linha1
  attr_accessor :sacado_linha2
  attr_accessor :sacado_linha3

  def initialize
    self.especie_documento = 'DM'
    self.especie = 'R$'
    self.moeda = 9
    self.data_processamento = Date.today
    self.data_documento = self.data_processamento
    self.dias_vencimento = 0
    self.data_vencimento = self.dias_vencimento.days.from_now(self.data_processamento)
    self.aceite = "N"
    self.quantidade = 1
    self.valor = 0
    self.valor_documento = (self.quantidade * self.valor)
    self.local_pagamento = "QUALQUER BANCO ATÉ O VENCIMENTO"
  end

end

