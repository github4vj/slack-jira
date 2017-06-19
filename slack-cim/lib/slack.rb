'''

Slash Command Incoming Variables

token=V2CBIv1N3GSdhgzZHu8GSZgf
team_id=T0001
team_domain=example
channel_id=C2147483705
channel_name=test
user_id=U2147483697
user_name=Steve
command=/weather
text=94070
response_url=https://hooks.slack.com/commands/1234/5678

'''

def build_slack_message(response_type, username, channel, icon_url, icon_emoji, payload)
	data = { response_type: response_type, username: username, channel: channel, text: payload }
	(icon_url) ? (data['icon_url'] = icon_url) : (icon_emoji) ? (data['icon_emoji'] = icon_emoji) : data['icon_emoji'] = ':robot_face:'
	data
end
