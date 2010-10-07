#It's Buggie time!#

Getting nice stats from your pivotal projects.

#Example#

Simple usage to capture the number of open and closed bugs:

b = Buggie.with("guilherme.silveira@caelum.com.br", "your_password")
p b.projects["webchat"].bugs_per_iteration
