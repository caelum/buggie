require 'rubygems'
require 'lib/buggie'

b = Buggie.with("guilherme.silveira@caelum.com.br", "your_password_here")
puts b.projects["QCon 2010"].to_html
