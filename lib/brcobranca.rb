require 'rubygems'

Dir[File.join(File.dirname(__FILE__), "brcobranca", "*.rb")].each do |file|
  require file
end

%w( boleto bancobrasil itau ).each do |arquivo|
  require File.join(File.dirname(__FILE__), "brcobranca", "boleto", "#{arquivo}.rb")
end

%w( retorno_cbr643 ).each do |arquivo|
  require File.join(File.dirname(__FILE__), "brcobranca", "retorno", "#{arquivo}.rb")
end
