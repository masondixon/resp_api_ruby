require_relative 'ri_rest'

test_json = File.read( 'json_samples/merge_trigger.json' );

instance = RI_REST.new( 'https://login5.responsys.net', 'api_user_name', 'api_password', true )

response = instance.mergeTriggerEmail( 'campaign_name', test_json )

puts response
