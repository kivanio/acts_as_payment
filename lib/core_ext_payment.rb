class TrueClass
  def to_s_br
    "Sim" 
  end
end

class FalseClass
  def to_s_br
    "Não" 
  end
end

class String

  def to_br_cpf
    self.gsub(/^(.{3})(.{3})(.{3})(.{2})$/,'\1.\2.\3-\4')
  end

  def to_br_cep
    self.gsub(/^(.{5})(.{3})$/,'\1-\2')
  end

  def to_br_cnpj
    self.gsub(/^(.{2})(.{3})(.{3})(.{4})(.{2})$/,'\1.\2.\3/\4-\5')
  end

  def to_br_ie
    self.gsub(/^(.{2})(.{3})(.{3})(.{1})$/,'\1.\2.\3-\4')
  end

  # metodo generico para calculo de modulo 10
  def modulo10
    total = 0
    multiplicador = 2

    for caracter in self.split(//).reverse!
      total += (caracter.to_i * multiplicador).soma_digitos
      multiplicador = multiplicador == 2 ? 1 : 2
    end
    valor = (10 - (total % 10))
    return valor == 10 ? 0 : valor
  end

  # metodo generico para calculo de modulo 11
  # Padrão de multiplicaroes de 9 a 2
  def modulo11(tipo=1)    
    # tipo == 0 para codigo de barras (multiplicadores de 2 a 9)
    # tipo == 1 para linha digitável (multiplicadores de 9 a 2)
    tipo == 1 ? multiplicadores = [9,8,7,6,5,4,3,2] : multiplicadores = [2,3,4,5,6,7,8,9]

    total = 0
    multiplicador_posicao = 1

    for caracter in self.split(//).reverse!
      multiplicador_posicao = 1 if (multiplicador_posicao == 9)
      total += (caracter.to_i * multiplicadores[multiplicador_posicao-1])
      multiplicador_posicao += 1
    end

    valor = (tipo == 1) ? (total % 11 ) : (11 - (total % 11))

    return valor
  end

  # Soma numero com 2 dígitos ou mais
  # Ex. 1 = 1
  #     11 = (1+1) = 2
  #     13 = (1+3) = 4
  def soma_digitos
    return self.to_i if self.size == 1
    total = 0
    0.upto(self.size-1) {|digito| total += self[digito,1].to_i }
    return total
  end

  # Completa zeros a esquerda
  # Ex. numero="123" tamanho=3 | numero="123"
  #     numero="123" tamanho=4 | numero="0123"
  #     numero="123" tamanho=5 | numero="00123"
  def zeros_esquerda(tamanho=self.size)
    valor = ""
    0.upto((tamanho - self.size - 1)) do
      valor << "0"
    end
    return "#{valor}#{self}"
  end
  
  
  def limpa_valor
    self.to_s.gsub(/\./,'')
  end
  
  def formata_documento
    case self.size
    when 8 then self.to_br_cep
    when 11 then self.to_br_cpf
    when 14 then self.to_br_cnpj
    when 9 then self.to_br_ie
    end     
  end

end

class Integer

  def to_br_ie
    self.to_s.to_br_ie
  end

  def to_br_cpf
    self.to_s.to_br_cpf
  end

  def to_br_cep
    self.to_s.to_br_cep
  end

  def to_br_cnpj
    self.to_s.to_br_cnpj
  end

  def modulo10
    self.to_s.modulo10
  end

  def modulo11
    self.to_s.modulo11
  end

  def soma_digitos
    self.to_s.soma_digitos
  end
  
  def zeros_esquerda(tamanho)
    self.to_s.zeros_esquerda(tamanho)
  end
  
  def limpa_valor
    self.to_s.limpa_valor
  end
  
  def formata_documento
    self.to_s.formata_documento
  end

end

class Float
  def limpa_valor
    self.to_s.limpa_valor + "0"
  end
end

class Date
  # Calcula quantidade de dias da data setada até a data base de 07-10-1997
  def fator_vencimento
    data_base = Date.parse "1997-10-07"
    return (self - data_base).to_i
  end
  
  def to_s_br
    self.strftime('%d/%m/%Y')
  end

end