require 'sinatra'

get '/' do
  FloatDashboard.new.projects.to_json
end

class FloatDashboard
  require 'http'
  def fetch_tasks
    header = {
      content_type: "application/x-www-form-urlencoded",
      accept: "application/json",
      user_agent: "Ministry of Justice UK team dashboard (james.darling@digital.justice.gov.uk)"
    }
    response = HTTP[header].auth("Bearer #{ENV['FLOAT_API_TOKEN']}").get('https://api.floatschedule.com/api/v1/tasks?weeks=1')
    JSON.parse(response.to_s)
  end

  def projects
    projects = {}
    fetch_tasks['people'].each do |person|
      name = person['tasks'].first['person_name']
      project = person['tasks'].first['project_name']
      projects[project] ||= []
      projects[project] << name
    end
    projects
  end
end
