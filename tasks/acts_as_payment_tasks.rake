namespace :acts_as_payment do
  desc "Instala arquivos necessários"
  task :install do
    plugin_dir = File.join(File.dirname(__FILE__), '..')
    #copiando arquivos para a public
    FileUtils.cp_r( 
    Dir[File.join(plugin_dir, 'arquivos/public/*')], 
    File.join("#{RAILS_ROOT}/public"),
    :verbose => true
    )

    #copiando os layouts dos boleto em html
    FileUtils.cp_r( 
    Dir[File.join(plugin_dir, 'arquivos/views/*')], 
    File.join("#{RAILS_ROOT}/app/views"),
    :verbose => true
    )

    puts "Terminado."
  end
end
