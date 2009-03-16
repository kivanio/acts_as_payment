class BancoBrasil < Boleto

  attr_accessor :codigo_servico
  # validates_presence_of :codigo_servico

  def initialize
    super
    self.carteira = "18"
    self.banco = "001"
    self.codigo_servico = false
  end

  def codigo_barras
    banco = self.zeros_esquerda(self.banco,3)
    valor_documento = self.zeros_esquerda((self.valor_documento.limpa_valor_moeda),10)
    convenio = self.convenio.to_s
    fator = self.data_vencimento.fator_vencimento

    case convenio.size
      # Nosso Numero de 17 digitos com Convenio de 7 digitos e complemento de 10 digitos
    when 7 then
      nosso_numero = self.zeros_esquerda(self.nosso_numero,10)
      raise "Seu complemento está com #{nosso_numero.size} dígitos. Com convênio de 7 dígitos, somente permite-se até 10 dígitos no complemento do nosso numero." if nosso_numero.size > 10
      numero_dv = "#{banco}#{self.moeda}#{fator}#{valor_documento}000000#{convenio}#{nosso_numero}#{self.carteira}"
      dv_barra = "#{self.modulo11_2to9(numero_dv)}"
      barra = "#{banco}#{self.moeda}#{dv_barra}#{fator}#{valor_documento}000000#{convenio}#{nosso_numero}#{self.carteira}"
      return barra
    when 6
      if self.codigo_servico == false 
        nosso_numero = self.zeros_esquerda(self.nosso_numero,5)
        raise "Seu complemento está com #{nosso_numero.size} dígitos. Com convênio de 6 dígitos, somente permite-se até 5 dígitos no complemento do nosso numero. Para emitir boletos com nosso numero de 17 dígitos, coloque o atributo codigo_servico=true" if nosso_numero.size > 5
        agencia = self.zeros_esquerda(self.agencia,4)
        conta = self.zeros_esquerda(self.conta_corrente,8)
        numero_dv = "#{banco}#{self.moeda}#{fator}#{valor_documento}#{convenio}#{nosso_numero}#{agencia}#{conta}#{self.carteira}"
        dv_barra = "#{self.modulo11_2to9(numero_dv)}"
        barra = "#{banco}#{self.moeda}#{dv_barra}#{fator}#{valor_documento}#{convenio}#{nosso_numero}#{agencia}#{conta}#{self.carteira}"
        return barra
      else
        nosso_numero = self.zeros_esquerda(self.nosso_numero,17)
        raise "Seu complemento está com #{nosso_numero.size} dígitos. Com convênio de 6 dígitos, somente permite-se até 17 dígitos no complemento do nosso numero." if (nosso_numero.size > 17)
        raise "Só é permitido emitir boletos com nosso número de 17 dígitos com carteiras 16 ou 18. Sua carteira atual é #{self.carteira}" unless (["16","18"].include?(self.carteira))
        numero_dv = "#{banco}#{self.moeda}#{fator}#{valor_documento}#{convenio}#{nosso_numero}21"
        dv_barra = "#{self.modulo11_2to9(numero_dv)}"
        barra = "#{banco}#{self.moeda}#{dv_barra}#{fator}#{valor_documento}#{convenio}#{nosso_numero}21"
        return barra
      end
    when 4
      nosso_numero = self.zeros_esquerda(self.nosso_numero,7)
      raise "Seu complemento está com #{nosso_numero.size} dígitos. Com convênio de 4 dígitos, somente permite-se até 7 dígitos no complemento do nosso numero." if nosso_numero.size > 7
      agencia = self.zeros_esquerda(self.agencia,4)
      conta = self.zeros_esquerda(self.conta_corrente,8)
      numero_dv = "#{banco}#{self.moeda}#{fator}#{valor_documento}#{convenio}#{nosso_numero}#{agencia}#{conta}#{self.carteira}"
      dv_barra = "#{self.modulo11_2to9(numero_dv)}"
      barra = "#{banco}#{self.moeda}#{dv_barra}#{fator}#{valor_documento}#{convenio}#{nosso_numero}#{agencia}#{conta}#{self.carteira}"
      return barra
    else
      return nil
    end


  end

  # metodo para retorno de digito verificador de modulo 11 para linha digitavel do Banco do Brasil
  def modulo11_9to2_bb(valor_inicial="")
    return nil if (valor_inicial !~ /\S/)
    #calcula modulo
    valor = self.modulo11_9to2(valor_inicial)
    #retorna digito para o bb
    return valor == 10 ? "X" : valor
  end

  def boleto_html
    doc=Document.new :paper => [16,2], :margin => [1, 1, 1, 1]
    doc.barcode_interleaved2of5(self.codigo_barras, :height => 2)
    doc.render :jpeg, :filename => 'public/images/payment/codigobb.jpg', :size => '10x20'
  end

  # Gerar o boleto em pdf usando template padrão
  def boleto_pdf
    doc=Document.new :paper => :A4 # 210x297
    doc.image File.join(File.dirname(__FILE__), '..','..','arquivos/eps_templates/boleto_bb.eps')

    doc.define_tags do
      tag :grande, :size => 12
    end

    #INICIO Primeira parte do BOLETO BB
    doc.moveto :x => '6.8 cm' , :y => '28 cm'
    doc.show "#{self.banco}-#{self.moeda}", :tag => :grande
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
    doc.show "#{self.banco}-#{self.moeda}", :tag => :grande
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
    doc.show "#{self.banco}-#{self.moeda}", :tag => :grande
    doc.moveto :x => '8.4 cm' , :y => '9 cm'
    doc.show self.linha_digitavel(self.codigo_barras), :tag => :grande
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