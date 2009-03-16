module Brcobanca
  ##
  ## Modulo de Formatacao
  ##
  module FormatModule
    def to_br_cpf
      return (self.kind_of?(String) ? self : self.to_s).gsub(/^(.{3})(.{3})(.{3})(.{2})$/,'\1.\2.\3-\4')
    end

    def to_br_cep
      return (self.kind_of?(String) ? self : self.to_s).gsub(/^(.{5})(.{3})$/,'\1-\2')
    end

    def to_br_cnpj
      return (self.kind_of?(String) ? self : self.to_s).gsub(/^(.{2})(.{3})(.{3})(.{4})(.{2})$/,'\1.\2.\3/\4-\5')
    end

    def to_br_ie
      return (self.kind_of?(String) ? self : self.to_s).gsub(/^(.{2})(.{3})(.{3})(.{1})$/,'\1.\2.\3-\4')
    end

    def formata_documento
      case (self.kind_of?(String) ? self : self.to_s).size
      when 8 then self.to_br_cep
      when 11 then self.to_br_cpf
      when 14 then self.to_br_cnpj
      when 9 then self.to_br_ie
      else
        self
      end     
    end

    def limpa_valor_moeda
      return self unless self.kind_of?(String) && self.moeda?
      return self.somente_numeros
    end

    def somente_numeros
      return self unless self.kind_of?(String)
      return self.gsub(/\D/,'')
    end
  end

  ##
  ## Modulo de Validacao
  ##
  module ValidaModule

    # Verifica se o valor e moeda
    # Ex. +1.232.33
    # Ex. -1.232.33
    # Ex. +1,232.33
    # Ex. -1,232.33
    # Ex. +1.232,33
    # Ex. -1.232,33
    # Ex. +1,232,33
    # Ex. -1,232,33
    def moeda?
      return false unless self.kind_of?(String)
      self =~ /^(\+|-)?\d+((\.|,)\d{3}*)*((\.|,)\d{2}*)$/ ? true : false
    end
  end

  module CleanModule
    def limpa_valor_moeda
      return self unless self.kind_of?(Float)
      valor_inicial = self.to_s
      (valor_inicial + ("0" * (2 - valor_inicial.split(/\./).last.size ))).somente_numeros
    end
  end

  module DataModule
    # Calcula quantidade de dias a partir da data setada ate a data base de 07-10-1997
    def fator_vencimento
      data_base = Date.parse "1997-10-07"
      return (self - data_base).to_i
    end

    def to_s_br
      self.strftime('%d/%m/%Y')
    end
  end

  module VerdadeModule
    def to_s_br
      "Sim" 
    end
  end

  module FalsoModule
    def to_s_br
      "Não" 
    end
  end
end

# Inclui os Modulos nas Classes Correspondentes
class String
  include Brcobanca::FormatModule
  include Brcobanca::ValidaModule
end

class Integer
  include Brcobanca::FormatModule
end

class Float
  include Brcobanca::CleanModule
end

class Date
  include Brcobanca::DataModule
end

class TrueClass
  include Brcobanca::VerdadeModule
end

class FalseClass
  include Brcobanca::FalsoModule
end
