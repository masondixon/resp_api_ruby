require 'rest-client'
require 'json'

class RI_REST

  #service urls
  LOGIN_SERVICE_URL    = '/rest/api/v1/auth/token'
  CAMPAIGN_SERVICE_URL = '/rest/api/v1/campaigns/'
  LIST_SERVICE_URL     = '/rest/api/v1/lists/'
  EVENT_SERVICE_URL    = '/rest/api/v1/events/'

  
  def initialize( login_url, user_name, password, debug=false )
    
    if debug == true
      RestClient.log = 'stdout'
    end
    
    begin
      payload  = {:user_name => user_name, :password => password, :auth_type => 'password'}
        
      response = RestClient::Request.execute( :method => :post,
                                              :url => login_url + LOGIN_SERVICE_URL, 
                                              :payload => payload, 
                                              :verify_ssl => false,
                                              :content_type => 'application/x-www-form-urlencoded',
                                              :accept => :json ) 

      json_response = JSON.parse(response)
      
      @authToken = json_response['authToken']
      @endPoint  = json_response['endPoint']
      
    rescue RestClient::ExceptionWithResponse => e
      puts 'login initialize Exception : ' + e.response
    end
  end
  
  def mergeTriggerEmail( campaign_name, json_payload )
    begin
      response = RestClient::Request.execute( :method => :post,
                                              :url => @endPoint + CAMPAIGN_SERVICE_URL + campaign_name + "/email", 
                                              :payload => json_payload, 
                                              :verify_ssl => false,
                                              :content_type => 'application/json',
                                              :headers => {'Authorization' => @authToken, 'Content-Type' => 'application/json' },
                                              :accept => :json ) 
      
      json_response = JSON.parse(response)
      
      return json_response
      
    rescue RestClient::ExceptionWithResponse => e
        puts 'mergeTrigger Exception : ' + e.response
    end
  end
  
end