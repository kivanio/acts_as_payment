class TesteController < ApplicationController

  # Copiado via rake para o diretório de layouts
  layout "boleto_bb"

  def index

    # Pegando uma nova instancia
    @boleto = BancoBrasil.new
    @boleto.cedente = "Kivanio Barbosa"
    @boleto.documento_cedente = "12345678912"
    @boleto.sacado = "Claudio Pozzebom"
    @boleto.documento_sacado = "12345678900"
    @boleto.valor = 135.00
    @boleto.valor_documento = (@boleto.quantidade * @boleto.valor)
    @boleto.aceite = "S"
    @boleto.agencia = 4042
    @boleto.agencia_dv = @boleto.agencia.modulo11
    @boleto.conta_corrente = 61900
    @boleto.conta_corrente_dv = @boleto.conta_corrente.modulo11
    @boleto.convenio = 1238798
    @boleto.nosso_numero = "7777700168"
    @boleto.nosso_numero_dv = "#{@boleto.convenio}#{@boleto.nosso_numero}".modulo11
    @boleto.numero_documento = "102008"
    @boleto.dias_vencimento = 5
    @boleto.data_vencimento = "2008-02-01".to_date
    @boleto.instrucao1 = "Pagável na rede bancária até a data de vencimento."
    @boleto.instrucao2 = "Juros de mora de 2.0% mensal(R$ 0,09 ao dia)"
    @boleto.instrucao3 = "DESCONTO DE R$ 29,50 APÓS 05/11/2006 ATÉ 15/11/2006"
    @boleto.instrucao4 = "NÃO RECEBER APÓS 15/11/2006"
    @boleto.instrucao5 = "Após vencimento pagável somente nas agências do Banco do Brasil"
    @boleto.instrucao6 = "ACRESCER R$ 4,00 REFERENTE AO BOLETO BANCÁRIO"
    @boleto.sacado_linha1 = @boleto.sacado
    @boleto.sacado_linha2 = "Av. Rubéns de Mendonça, 157"
    @boleto.sacado_linha3 = "78008-000 - Cuiabá/MT "

    # Gerando numero de codigo de barras
    @boleto.codigo_barras = @boleto.codigo_barra_bb_carteira_18
    
    # Gerando numero de linha digitavel
    @boleto.linha_digitavel =  @boleto.monta_linha_digitalvel

    # Gerando imagem de codigo de barra
    # OBS: para esta opção comentar a geração de PDF, só é possível utilizar um ou outro.
    # OBS: não esqueça de criar uma view em branco com o nome da action que você criou.
    # @boleto.codigo_barra_imagem
    
    # Gerando pdf com codigo de barras a partir do template do Banco do Brasil
    send_data @boleto.boleto_pdf, :filename => "boletobb.pdf"

  end

end
