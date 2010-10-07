#It's Buggie time!#

Getting nice stats from your pivotal projects.

#Example#

Simple usage to capture the number of open and closed bugs:

require 'rubygems'
require 'lib/buggie'

b = Buggie.with("guilherme.silveira@caelum.com.br", "your_password_here")
puts b.projects["QCon 2010"].to_html


#Team and Contact#

"Guilherme Silveira":guilherme.silveira@caelum.com.br

#How to contribute#

Fork, patch, test, push and send a pull request.