class Itau < Boleto

  attr_accessor :banco_dv
  attr_accessor :cpf_or_cnpj
  
  def initialize
    super
    self.carteira = "175" # carteira "sem registro"
    self.banco = "341"
    self.banco_dv = "7"
  end

  # Retorna a string de números formatada com o código de barras
  # O nosso_numero_dv é calculado aqui porque o código de barras é 
  # a entrada para o método linha_digitável
  # Para ser válido, o código de barras retornável tem que ter 44 caracteres
  def codigo_barras
    self.nosso_numero_dv = self.calcula_nosso_numero_dv
    self.conta_corrente_dv = self.calcula_conta_corrente_dv
    @valor_documento_formatado = self.zeros_esquerda((self.valor_documento.limpa_valor_moeda),10)
    @fator = self.data_vencimento.fator_vencimento
    
    self.monta_codigo(self.dv_codigo_barras)
  end
  
  # Cálculo do dígito verificador do código de barras do boleto. Sem esse dv
  # o código de barras fica com 43 números ao invés de 44.
  def dv_codigo_barras
    
    codigo = monta_codigo
    
    self.modulo11_2to9(codigo)
  end
  
  # Monta o código de barras com 43 ou 44 caracteres, dependendo se recebeu
  # ou não o dígito verificador do código de barras. Assim o código fica
  # mais DRY.
  def monta_codigo(digito_verificador = "")
    codigo = "#{self.banco}#{self.moeda}#{digito_verificador}#{@fator}#{@valor_documento_formatado}#{self.carteira}"
    codigo << "#{self.nosso_numero}#{self.nosso_numero_dv}#{self.agencia}"
    codigo << "#{self.conta_corrente}#{self.conta_corrente_dv}000"
    codigo
  end
  
  # Os atributos que compõem a string de cálculo do nosso
  # número variam de acordo com o 
  def calcula_nosso_numero_dv
    if %w(126 131 146 150 168).include?(self.carteira)
      modulo10("#{self.carteira}#{self.nosso_numero}");
    else
      self.nosso_numero = self.zeros_esquerda(self.nosso_numero,8)
      modulo10("#{self.agencia}#{self.conta_corrente}#{self.carteira}#{self.nosso_numero}");
    end
  end
  
  # Calcula o dígito verificador para conta corrente do Itaú.
  # Retorna apenas o dígito verificador da conta ou nil caso seja impossível
  # calcular.
  def calcula_conta_corrente_dv
    modulo10("#{self.agencia}#{self.conta_corrente}")
  end

  # Gerar o boleto em pdf usando template padrão
  def boleto_pdf
    
    codigo_de_barras = self.codigo_barras
    
    doc=Document.new :paper => :A4 # 210x297
    doc.image File.join(File.dirname(__FILE__), '..','..','arquivos/eps_templates/boleto_itau.eps')

    doc.define_tags do
      tag :grande, :size => 12
    end

    #Recibo do Sacado (Cliente)
    doc.moveto :x => '1 cm' , :y => '22.4 cm'
    doc.show self.cedente
    doc.moveto :x => '11 cm' , :y => '22.4 cm'
    doc.show "#{self.agencia}/#{self.conta_corrente}-#{self.conta_corrente_dv}"
    doc.moveto :x => '14 cm' , :y => '22.4 cm'
    doc.show self.especie
    doc.moveto :x => '16 cm' , :y => '22.4 cm'
    doc.show self.quantidade
    doc.moveto :x => '17.5 cm' , :y => '22.4 cm'
    doc.show "#{self.carteira}/#{self.nosso_numero}-#{self.nosso_numero_dv}"

    doc.moveto :x => '1 cm' , :y => '21.7 cm'
    doc.show self.numero_documento
    doc.moveto :x => '8 cm' , :y => '21.7 cm'
    doc.show self.cpf_or_cnpj
    doc.moveto :x => '13 cm' , :y => '21.7 cm'
    doc.show self.data_vencimento.to_s_br
    doc.moveto :x => '18 cm' , :y => '21.7 cm'
    doc.show self.valor_documento.to_currency

    doc.moveto :x => '1.7 cm' , :y => '20.2 cm'
    doc.show "#{self.sacado} - #{self.documento_sacado.formata_documento}"

    doc.moveto :x => '1 cm' , :y => '19.2 cm'
    doc.show self.instrucao1
    doc.moveto :x => '1 cm' , :y => '18.8 cm'
    doc.show self.instrucao2
    doc.moveto :x => '1 cm' , :y => '18.3 cm'
    doc.show self.instrucao3
    
    #FIM Recibo do Sacado (Cliente)

    # Recibo do Caixa
    doc.moveto :x => '8.3 cm' , :y => '12 cm'
    doc.show self.linha_digitavel(codigo_de_barras), :tag => :grande
    
    doc.moveto :x => '1 cm' , :y => '10.7 cm'
    doc.show self.local_pagamento
    doc.moveto :x => '17.5 cm' , :y => '10.7 cm'
    doc.show self.data_vencimento.to_s_br
    
    doc.moveto :x => '1 cm' , :y => '10 cm'
    doc.show self.cedente
    doc.moveto :x => '17.5 cm' , :y => '10 cm'
    doc.show "#{self.agencia}/#{self.conta_corrente}-#{self.conta_corrente_dv}"
    
    doc.moveto :x => '1 cm' , :y => '9.2 cm'
    doc.show self.data_documento.to_s_br
    doc.moveto :x => '6.2 cm' , :y => '9.2 cm'
    doc.show self.numero_documento
    doc.moveto :x => '8.7 cm' , :y => '9.2 cm'
    doc.show self.especie
    doc.moveto :x => '11.2 cm' , :y => '9.2 cm'
    doc.show self.aceite
    doc.moveto :x => '12.4 cm' , :y => '9.2 cm'
    doc.show self.data_processamento.to_s_br
    doc.moveto :x => '17.5 cm' , :y => '9.2 cm'
    doc.show "#{self.carteira}/#{self.nosso_numero}-#{self.nosso_numero_dv}"
    
    doc.moveto :x => '1 cm' , :y => '8.5 cm'
    doc.show self.documento_cedente.formata_documento
    doc.moveto :x => '5 cm' , :y => '8.5 cm'
    doc.show self.carteira
    doc.moveto :x => '7 cm' , :y => '8.5 cm'
    doc.show self.moeda
    doc.moveto :x => '10 cm' , :y => '8.5 cm'
    doc.show self.quantidade
    doc.moveto :x => '12 cm' , :y => '8.5 cm'
    doc.show self.valor.to_currency
    doc.moveto :x => '17.5 cm' , :y => '8.5 cm'
    doc.show self.valor_documento.to_currency
    
    doc.moveto :x => '1 cm' , :y => '7.5 cm'
    doc.show self.instrucao1
    doc.moveto :x => '1 cm' , :y => '7.2 cm'
    doc.show self.instrucao2
    doc.moveto :x => '1 cm' , :y => '6.7 cm'
    doc.show self.instrucao3
    doc.moveto :x => '1 cm' , :y => '6.2 cm'
    doc.show self.instrucao4
    doc.moveto :x => '1 cm' , :y => '5.7 cm'
    doc.show self.instrucao5
    doc.moveto :x => '1 cm' , :y => '5.2 cm'
    doc.show self.instrucao6
    doc.moveto :x => '1.2 cm' , :y => '3.8 cm'
    doc.show "#{self.sacado} - #{self.documento_sacado.formata_documento}"
    doc.moveto :x => '1.2 cm' , :y => '3.5 cm'
    doc.show "#{self.sacado_linha2} - #{self.sacado_linha3}"
    #FIM Recibo do Caixa

    #Gerando codigo de barra
#    doc.moveto :x => '1.2 cm' , :y => '2.2 cm'
#    doc.show self.codigo_de_barras
    doc.barcode_interleaved2of5(codigo_de_barras, :width => '12 cm', :height => '1.5 cm', :x => '1 cm', :y => '0.6 cm' )

    #Gerando PDF
    doc.render_stream(:pdf)

  end

end