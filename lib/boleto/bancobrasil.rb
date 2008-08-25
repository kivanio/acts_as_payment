class BancoBrasil < Boleto
  
  def initialize
    super
    self.carteira = 18
    self.banco = "001"
    self.banco_dv = self.banco.modulo11
  end

  def monta_linha_digitalvel

    campo_1_a = "#{self.codigo_barras[0..3]}"
    campo_1_b = "#{self.codigo_barras[19..23]}"
    dv_1 = "#{campo_1_a}#{campo_1_b}".modulo10
    campo_1_dv = "#{campo_1_a}#{campo_1_b}#{dv_1}"
    campo_linha_1 = "#{campo_1_dv[0..4]}.#{campo_1_dv[5..9]}"

    campo_2 = "#{self.codigo_barras[24..33]}"
    dv_2 = campo_2.modulo10
    campo_2_dv = "#{campo_2}#{dv_2}"
    campo_linha_2 = "#{campo_2_dv[0..4]}.#{campo_2_dv[5..10]}"

    campo_3 = "#{self.codigo_barras[34..43]}"
    dv_3 = campo_3.modulo10
    campo_3_dv = "#{campo_3}#{dv_3}"
    campo_linha_3 = "#{campo_3_dv[0..4]}.#{campo_3_dv[5..10]}"

    campo_linha_4 = "#{self.codigo_barras[4..4]}"

    campo_linha_5 = "#{self.codigo_barras[5..18]}"

    linha = "#{campo_linha_1} #{campo_linha_2} #{campo_linha_3} #{campo_linha_4} #{campo_linha_5}"

    return linha
  end

  # Carteira 18
  def codigo_barra_bb_carteira_18
    banco = self.banco.zeros_esquerda(3)
    valor_documento = self.valor_documento.limpa_valor_moeda.zeros_esquerda(10)
    nosso_numero = self.nosso_numero.zeros_esquerda(10)
    convenio = self.convenio.to_s
    fator = self.data_vencimento.fator_vencimento

    # Convenio 7 digitos e nosso numero 10 digitos
    if ((convenio.size == 7) && (nosso_numero.size == 10))
      numero_dv = "#{banco}#{self.moeda}#{fator}#{valor_documento}000000#{convenio}#{nosso_numero}#{self.carteira}"
      dv_barra = "#{self.modulo11_bb_codigo_barra(numero_dv)}"
      barra = "#{banco}#{self.moeda}#{dv_barra}#{fator}#{valor_documento}000000#{convenio}#{nosso_numero}#{self.carteira}"
      return barra
    end

  end

  # metodo para retorno de digito verificador de modulo 11 para codigo de barras do Banco do Brasil
  def modulo11_bb_codigo_barra(numero)
    #calcula modulo 11 para codigo de barras do BB
    valor = numero.modulo11(0)
    # retorna o digito para o BB
    return [0,10,11].include?(valor) ? 1 : valor
  end

  # metodo para retorno de digito verificador de modulo 11 para linha digitavel do Banco do Brasil
  def modulo11_bb_linha_digitavel(numero)
    #calcula modulo
    valor = numero.modulo11
    #retorna digito para o bb
    return [0].include?(valor) ? "X" : valor
  end
  
  def codigo_barra_imagem
    doc=Document.new :paper => [16,2], :margin => [1, 1, 1, 1]
    doc.barcode_interleaved2of5(self.codigo_barras, :height => 2)
    doc.render :jpeg, :filename => 'public/images/payment/codigobb.jpg', :size => '10x20'
  end
  
  # Gerar o boleto em pdf usando template padrão
  def boleto_pdf
    doc=Document.new :paper => :A4 # 210x297
    doc.image "public/images/payment/boleto.eps"

    doc.define_tags do
      tag :grande, :size => 12
    end
    
    #INICIO Primeira parte do BOLETO BB
    doc.moveto :x => '6.8 cm' , :y => '28 cm'
    doc.show "#{self.banco}-#{self.banco_dv}", :tag => :grande
    doc.moveto :x => '0.5 cm' , :y => '27.2 cm'
    doc.show self.local_pagamento
    doc.moveto :x => '17.5 cm' , :y => '27.2 cm'
    doc.show self.data_vencimento.to_s_br
    doc.moveto :x => '0.5 cm' , :y => '26.5 cm'
    doc.show self.cedente
    doc.moveto :x => '17.5 cm' , :y => '26.5 cm'
    doc.show "#{self.agencia}-#{self.agencia_dv}/#{self.conta_corrente}-#{self.conta_corrente_dv}"
    doc.moveto :x => '0.5 cm' , :y => '25.9 cm'
    doc.show self.data_documento.to_s_br
    doc.moveto :x => '4.2 cm' , :y => '25.9 cm'
    doc.show self.numero_documento
    doc.moveto :x => '7.3 cm' , :y => '25.9 cm'
    doc.show self.especie
    doc.moveto :x => '9.3 cm' , :y => '25.9 cm'
    doc.show self.aceite
    doc.moveto :x => '12 cm' , :y => '25.9 cm'
    doc.show self.data_processamento.to_s_br
    doc.moveto :x => '17.5 cm' , :y => '25.9 cm'
    doc.show "#{self.convenio}#{self.nosso_numero}-#{self.nosso_numero_dv}"
    doc.moveto :x => '0.5 cm' , :y => '25.2 cm'
    doc.show self.documento_cedente.formata_documento
    doc.moveto :x => '4.2 cm' , :y => '25.2 cm'
    doc.show self.carteira
    doc.moveto :x => '6.2 cm' , :y => '25.2 cm'
    doc.show self.moeda
    doc.moveto :x => '9 cm' , :y => '25.2 cm'
    doc.show self.quantidade
    doc.moveto :x => '12 cm' , :y => '25.2 cm'
    doc.show self.valor.to_currency
    doc.moveto :x => '17.5 cm' , :y => '25.2 cm'
    doc.show self.valor_documento.to_currency
    doc.moveto :x => '0.5 cm' , :y => '24.6 cm'
    doc.show self.instrucao1
    doc.moveto :x => '0.5 cm' , :y => '24.2 cm'
    doc.show self.instrucao2
    doc.moveto :x => '0.5 cm' , :y => '23.8 cm'
    doc.show self.instrucao3
    doc.moveto :x => '0.5 cm' , :y => '23.4 cm'
    doc.show self.instrucao4
    doc.moveto :x => '0.5 cm' , :y => '23 cm'
    doc.show self.instrucao5
    doc.moveto :x => '0.5 cm' , :y => '22.6 cm'
    doc.show self.instrucao6
    doc.moveto :x => '1.2 cm' , :y => '21.8 cm'
    doc.show "#{self.sacado} - #{self.documento_sacado.formata_documento}"
    doc.moveto :x => '1.2 cm' , :y => '21.5 cm'
    doc.show "#{self.sacado_linha2} - #{self.sacado_linha3}"
    #FIM Primeira parte do BOLETO BB
    
    #INICIO Segunda parte do BOLETO BB
    doc.moveto :x => '6.8 cm' , :y => '18.4 cm'
    doc.show "#{self.banco}-#{self.banco_dv}", :tag => :grande
    doc.moveto :x => '0.5 cm' , :y => '17.6 cm'
    doc.show self.local_pagamento
    doc.moveto :x => '17.5 cm' , :y => '17.6 cm'
    doc.show self.data_vencimento.to_s_br
    doc.moveto :x => '0.5 cm' , :y => '16.9 cm'
    doc.show self.cedente
    doc.moveto :x => '17.5 cm' , :y => '16.9 cm'
    doc.show "#{self.agencia}-#{self.agencia_dv}/#{self.conta_corrente}-#{self.conta_corrente_dv}"
    doc.moveto :x => '0.5 cm' , :y => '16.3 cm'
    doc.show self.data_documento.to_s_br
    doc.moveto :x => '4.2 cm' , :y => '16.3 cm'
    doc.show self.numero_documento
    doc.moveto :x => '7.3 cm' , :y => '16.3 cm'
    doc.show self.especie
    doc.moveto :x => '9.3 cm' , :y => '16.3 cm'
    doc.show self.aceite
    doc.moveto :x => '12 cm' , :y => '16.3 cm'
    doc.show self.data_processamento.to_s_br
    doc.moveto :x => '17.5 cm' , :y => '16.3 cm'
    doc.show "#{self.convenio}#{self.nosso_numero}-#{self.nosso_numero_dv}"
    doc.moveto :x => '0.5 cm' , :y => '15.6 cm'
    doc.show self.documento_cedente.formata_documento
    doc.moveto :x => '4.2 cm' , :y => '15.6 cm'
    doc.show self.carteira
    doc.moveto :x => '6.2 cm' , :y => '15.6 cm'
    doc.show self.moeda
    doc.moveto :x => '9 cm' , :y => '15.6 cm'
    doc.show self.quantidade
    doc.moveto :x => '12 cm' , :y => '15.6 cm'
    doc.show self.valor.to_currency
    doc.moveto :x => '17.5 cm' , :y => '15.6 cm'
    doc.show self.valor_documento.to_currency
    doc.moveto :x => '0.5 cm' , :y => '15 cm'
    doc.show self.instrucao1
    doc.moveto :x => '0.5 cm' , :y => '14.6 cm'
    doc.show self.instrucao2
    doc.moveto :x => '0.5 cm' , :y => '14.2 cm'
    doc.show self.instrucao3
    doc.moveto :x => '0.5 cm' , :y => '13.8 cm'
    doc.show self.instrucao4
    doc.moveto :x => '0.5 cm' , :y => '13.4 cm'
    doc.show self.instrucao5
    doc.moveto :x => '0.5 cm' , :y => '13.0 cm'
    doc.show self.instrucao6
    doc.moveto :x => '1.2 cm' , :y => '12.2 cm'
    doc.show "#{self.sacado} - #{self.documento_sacado.formata_documento}"
    doc.moveto :x => '1.2 cm' , :y => '11.9 cm'
    doc.show "#{self.sacado_linha2} - #{self.sacado_linha3}"
    #FIM Segunda parte do BOLETO BB
    
    #INICIO Terceira parte do BOLETO BB
    doc.moveto :x => '6.8 cm' , :y => '9 cm'
    doc.show "#{self.banco}-#{self.banco_dv}", :tag => :grande
    doc.moveto :x => '8.4 cm' , :y => '9 cm'
    doc.show self.linha_digitavel, :tag => :grande
    doc.moveto :x => '0.5 cm' , :y => '8.2 cm'
    doc.show self.local_pagamento
    doc.moveto :x => '17.5 cm' , :y => '8.2 cm'
    doc.show self.data_vencimento.to_s_br
    doc.moveto :x => '0.5 cm' , :y => '7.5 cm'
    doc.show self.cedente
    doc.moveto :x => '17.5 cm' , :y => '7.5 cm'
    doc.show "#{self.agencia}-#{self.agencia_dv}/#{self.conta_corrente}-#{self.conta_corrente_dv}"
    doc.moveto :x => '0.5 cm' , :y => '6.9 cm'
    doc.show self.data_documento.to_s_br
    doc.moveto :x => '4.2 cm' , :y => '6.9 cm'
    doc.show self.numero_documento
    doc.moveto :x => '7.3 cm' , :y => '6.9 cm'
    doc.show self.especie
    doc.moveto :x => '9.3 cm' , :y => '6.9 cm'
    doc.show self.aceite
    doc.moveto :x => '12 cm' , :y => '6.9 cm'
    doc.show self.data_processamento.to_s_br
    doc.moveto :x => '17.5 cm' , :y => '6.9 cm'
    doc.show "#{self.convenio}#{self.nosso_numero}-#{self.nosso_numero_dv}"
    doc.moveto :x => '0.5 cm' , :y => '6.2 cm'
    doc.show self.documento_cedente.formata_documento
    doc.moveto :x => '4.2 cm' , :y => '6.2 cm'
    doc.show self.carteira
    doc.moveto :x => '6.2 cm' , :y => '6.2 cm'
    doc.show self.moeda
    doc.moveto :x => '9 cm' , :y => '6.2 cm'
    doc.show self.quantidade
    doc.moveto :x => '12 cm' , :y => '6.2 cm'
    doc.show self.valor.to_currency
    doc.moveto :x => '17.5 cm' , :y => '6.2 cm'
    doc.show self.valor_documento.to_currency
    doc.moveto :x => '0.5 cm' , :y => '5.7 cm'
    doc.show self.instrucao1
    doc.moveto :x => '0.5 cm' , :y => '5.3 cm'
    doc.show self.instrucao2
    doc.moveto :x => '0.5 cm' , :y => '4.9 cm'
    doc.show self.instrucao3
    doc.moveto :x => '0.5 cm' , :y => '4.5 cm'
    doc.show self.instrucao4
    doc.moveto :x => '0.5 cm' , :y => '4.1 cm'
    doc.show self.instrucao5
    doc.moveto :x => '0.5 cm' , :y => '3.7 cm'
    doc.show self.instrucao6
    doc.moveto :x => '1.2 cm' , :y => '2.8 cm'
    doc.show "#{self.sacado} - #{self.documento_sacado.formata_documento}"
    doc.moveto :x => '1.2 cm' , :y => '2.5 cm'
    doc.show "#{self.sacado_linha2} - #{self.sacado_linha3}"
    #FIM Terceira parte do BOLETO BB
    
    #Gerando codigo de barra
    doc.barcode_interleaved2of5(self.codigo_barras, :width => '12 cm', :height => '1.5 cm', :x => '0.5 cm', :y => '0.6 cm' )
    
    #Gerando PDF
    doc.render_stream(:pdf)

  end

end