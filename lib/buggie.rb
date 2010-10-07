require 'pivotal-tracker'

module Caelum
  module Buggie
  end
end

class Caelum::Buggie::Iteration
  def initialize(project, p)
    @project = project
    @iteration = p
  end
  def closed_bugs
    @iteration.stories.select do |story|
      (story.story_type == "bug" && story.current_state == "accepted")
    end.size
  end
  def open_bugs
    @project.stories.all.select do |s|
      s.story_type == "bug" && (s.created_at >= @iteration.start && s.created_at <= @iteration.finish)
    end.size
  end
  def name
    "Iteration #{@iteration.number}"
  end
end
class Caelum::Buggie::Iterations
  def initialize(project, p)
    @project = project
    @iterations = p
  end
  def bugs_per_iteration
    @iterations.collect do |i|
      Caelum::Buggie::Iteration.new(@project, i)
    end
  end
  
  def to_html
    content = '<html>
      <head>
        <script type="text/javascript" src="http://www.google.com/jsapi"></script>
        <script type="text/javascript">
          google.load("visualization", "1", {packages:["corechart"]});
          google.setOnLoadCallback(drawChart);
          function drawChart() {
            var data = new google.visualization.DataTable();
            data.addColumn("string", "Iteration");
            data.addColumn("number", "Opened");
            data.addColumn("number", "Closed");'
    bugs = bugs_per_iteration
    content = content + "data.addRows(#{bugs.size});"
    i = 0
    bugs.each do |iteration, v|
      content = content + "data.setValue(#{i}, 0, '#{iteration.name}');"
      content = content + "data.setValue(#{i}, 1, #{iteration.open_bugs});"
      content = content + "data.setValue(#{i}, 2, #{iteration.closed_bugs});"
      i = i + 1
    end
    content = content + "
            var chart = new google.visualization.LineChart(document.getElementById('chart_div'));
            chart.draw(data, {width: 640, height: 480, title: 'Overral opened x closed bugs'});
          }
        </script>
      </head>
      <body>
        <div id='chart_div'></div>
      </body>
    </html>"
  end
end

class Caelum::Buggie::Client
  def initialize(auth)
    @token = auth
  end
  def projects
    PivotalTracker::Project.all.inject({}) do |m, p|
      m[p.name] = Caelum::Buggie::Iterations.new(p, p.iterations.all)
      m
    end
  end
end

module Buggie
  
  def self.with(username, password)
    Caelum::Buggie::Client.new(
      PivotalTracker::Client.token(username, password)
        )
  end
  
end
