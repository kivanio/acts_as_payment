# requerendo libs necessárias
require 'rubygems'
require 'rghost'
require 'rghost_barcode'

# requerendo plugin
require 'core_ext_payment'
require 'currency'

# requerendo das classes de boleto
# novas classes devem ser colocadas aqui
require 'boleto/boleto'
require 'boleto/bancobrasil'
require 'boleto/itau'
require 'retorno/retorno_cbr643'

# Verificação da Plataforma e setando as configurações do RGHOST
case RUBY_PLATFORM
when /darwin/
  RGhost::Config::GS[:path] = '/opt/local/bin/gs'
when /linux/
  RGhost::Config::GS[:path] = '/usr/bin/gs'
when /freebsd/
  RGhost::Config::GS[:path] = '/usr/local/bin/gs'
end
