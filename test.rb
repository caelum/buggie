require 'rubygems'
require 'lib/buggie'

b = Buggie.with("guilherme.silveira@caelum.com.br", "your_password")
p b.projects["webchat"].bugs_per_iteration
