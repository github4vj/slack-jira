require 'json'
require 'sinatra'

Dir["#{__dir__}/lib/*.rb"].each { |file| load file }

not_found do
  status 404
  'Seems like you are lost'
end

get '/' do
  status 200
  'Running OK'
end

post '/jira' do
  content_type 'application/json'
  # return 401 unless request[:token] == ENV['SLACK_TOKEN']
  status 200
  text = request[:text].strip
  channel = request[:channel_name]
  if text.empty?
    {text: 'Please provide jira ID'}
  else
    jira = get_jira_details(text)
    data = build_slack_message('in_channel', 'jirabot', "##{channel}", nil, ':robot_face:', '')
    data['attachments'] = [{
                               color: '#36a64f',
                               fallback: 'Oops!, something went wrong',
                               title: jira[:summary],
                               title_link: "#{ENV['JIRA_URL']}/browse/#{text}",
                               fields: [
                                   {
                                       title: 'DefectID',
                                       value: jira[:id],
                                       short: true
                                   },
                                   {
                                       title: 'Reporter',
                                       value: jira[:creator_name],
                                       short: true
                                   },
                                   {
                                       title: 'Priority',
                                       value: jira[:priority],
                                       short: true
                                   },
                                   {
                                       title: 'Status',
                                       value: jira[:status],
                                       short: true
                                   },
                                   {
                                       title: 'Platform',
                                       value: jira[:platform],
                                       short: true
                                   },
                                   {
                                       title: 'Found In Build',
                                       value: jira[:found_in],
                                       short: true
                                   },
                                   {
                                       title: 'Device Affected',
                                       value: jira[:device_affected],
                                       short: true
                                   },
                                   {
                                       title: 'Fixed In Build',
                                       value: jira[:fixed_in],
                                       short: true
                                   },
                                   {
                                       title: 'Operating System',
                                       value: jira[:operating_system],
                                       short: true
                                   },
                                   {
                                       title: 'Assignee',
                                       value: jira[:assignee],
                                       short: true
                                   },
                               ]
                           }]
    data
  end.to_json
end