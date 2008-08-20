# requerendo libs necessárias
require "rubygems"
require 'rghost'
require 'rghost_barcode'


# requerendo plugin
require 'acts_as_payment_helper'
require 'core_ext_payment'
require 'currency'

# requerendo das classes de boleto
# novas classes devem ser colocadas aqui
require 'boleto/boleto'
require 'boleto/bancobrasil'

# Verificação da Plataforma e setando as configurações do RGHOST
case RUBY_PLATFORM
  when /darwin/
   RGhost::Config::GS[:path] = '/opt/local/bin/gs'
  when /linux/
   RGhost::Config::GS[:path] = '/usr/bin/gs'
end

ActionView::Base.send(:include, ActsAsPaymentHelper)
