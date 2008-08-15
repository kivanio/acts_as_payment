# requerendo libs necessárias
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

# Setando opções iniciais do rghost
# include RGhost
RGhost::Config::GS[:path] = '/opt/local/bin/gs'

ActionView::Base.send(:include, ActsAsPaymentHelper)
