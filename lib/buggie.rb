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
    @project.stories.all(:story_type => "bug").select do |s|
      not_yet_accepted = (s.accepted_at.nil? || s.accepted_at <= @iteration.finish)
      (s.created_at >= @iteration.start && not_yet_accepted)
    end.size
  end
end
class Caelum::Buggie::Iterations
  def initialize(project, p)
    @project = project
    @iterations = p
  end
  def bugs_per_iteration
    @iterations.inject({}) do |map, i|
      name = "Iteration #{i.number}"
      map[name] = {}
      map[name][:closed_bugs] = Caelum::Buggie::Iteration.new(@project, i).closed_bugs
      map[name][:open_bugs] = Caelum::Buggie::Iteration.new(@project, i).open_bugs
      map
    end
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
