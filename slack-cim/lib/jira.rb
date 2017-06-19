require 'uri'
require 'net/http'
require 'net/https'
require 'json'
require 'base64'
require 'dotenv'
require 'andand'

#Dotenv.load

def get_jira_details(id)
  uri = URI("#{ENV['JIRA_URL']}/rest/api/2/issue/#{id}")
  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = true
  http.verify_mode = OpenSSL::SSL::VERIFY_NONE
  req = Net::HTTP::Get.new(uri)
  auth = Base64.strict_encode64("#{ENV['JIRA_USERNAME']}:#{ENV['JIRA_PASSWORD']}")
  req.add_field 'Authorization', "Basic #{auth}"
  text = request[:text].strip
  result = if text.include? 'X'
             json = JSON.parse(http.request(req).body)
             {
                 id: json['key'],
                 summary: json['fields']['summary'],
                 description: json['fields']['description'],
                 creator_name: json['fields']['reporter']['displayName'],
                 priority: json['fields'].andand['priority'].andand['name'],
                 status: json['fields'].andand['status'].andand['name'],
                 platform: json['fields'].andand['customfield_20640'].andand['value'],
                 found_in: json['fields']['customfield_20641'],
                 device_affected: json['fields'].andand['customfield_22243'].andand['value'],
                 operating_system: json['fields'].andand['customfield_22242'].andand['value'],
                 assignee: json['fields'].andand['assignee'].andand['displayName'],
                 fixed_in: json['fields']['customfield_20642']
             }
           elsif text.include? 'MBT'
             json = JSON.parse(http.request(req).body)
             {
                 id: json['key'],
                 summary: json['fields']['summary'],
                 description: json['fields']['description'],
                 creator_name: json['fields']['reporter']['displayName'],
                 priority: json['fields'].andand['customfield_22953'].andand['value'],
                 status: json['fields'].andand['status'].andand['name'],
                 platform: json['fields'].andand['customfield_20640'].andand['value'],
                 found_in: json['fields']['customfield_20641'],
                 device_affected: json['fields'].andand['customfield_22243'].andand['value'],
                 operating_system: json['fields'].andand['customfield_22242'].andand['value'],
                 assignee: json['fields'].andand['assignee'].andand['displayName']
             }
           else
             json = JSON.parse(http.request(req).body)
             {
                 id: json['key'],
                 summary: json['fields']['summary'],
                 description: json['fields']['description'],
                 creator_name: json['fields']['reporter']['displayName'],
                 priority: json['fields'].andand['customfield_22953'].andand['value'],
                 status: json['fields'].andand['status'].andand['name'],
                 platform: json['fields'].andand['customfield_20640'].andand['value'],
                 device_affected: json['fields'].andand['customfield_22243'].andand['value'],
                 assignee: json['fields'].andand['assignee'].andand['displayName']
             }
           end
  result.inject({}) { |h, (k, v)| h[k] = v.nil? ? 'N/A' : v; h }
end
#puts get_jira_details('XC-123')
