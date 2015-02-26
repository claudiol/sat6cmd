#!/usr/bin/env ruby
#####################################################################################
# Copyright 2015 Kenneth Evensen <kenneth.evensen@redhat.com>
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
#    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#    See the License for the specific language governing permissions and
#    limitations under the License.
#
######################################################################################
#
# Contact Info: <kenneth.evensen@redhat.com> and <lester@redhat.com>
#
######################################################################################

require 'rest-client'
require 'json'
require 'singleton'

class SatelliteConnection 
  include Singleton
  
  attr_reader :url

	def initialize
		@method = nil
		@url = nil
		@user = nil
		@password = nil
		@verifyssl = nil
		
	end
	
	def setup(user, password, host, verifyssl=false)
	  @user = user
    @password = password
    @verifyssl = verifyssl
    @url = host
	end
	
	def get(location, json_data)	  
	  
	  response = nil
	  puts "#{location}"
	  
	  if json_data.nil?
      response = RestClient::Request.new(
          :method => :get,
          :url => @url+location,
          :user => @user,
          :password => @password,
          :verify_ssl => @verifyssl,
          :headers => { :accept => :json,
          :content_type => :json }
      ).execute
    else
      response = RestClient::Request.new(
          :method => :get,
          :url => @url+location,
          :user => @user,
          :password => @password,
          :verify_ssl => @verifyssl,
          :headers => { :accept => :json,
          :content_type => :json },
          :payload => JSON.generate(json_data)
      ).execute
    end
    
    if !response.nil?
      results = JSON.parse(response.to_str)
      return results
    end
  end

  def post(location, json_data)
  
     response = nil
    puts "#{location}"
  
    response = RestClient::Request.new(
        :method => :post,
        :url => @url+location,
        :user => @user,
        :verify_ssl => @verifyssl,
        :password => @password,
        :headers => { :accept => :json,
        :content_type => :json},
        :payload => JSON.generate(json_data)
    ).execute
    
    if !response.nil?
      results = JSON.parse(response.to_str)
      return results
    end
  end
  
  def put(location, json_data)
  
     response = nil
    puts "#{location}"
  
    response = RestClient::Request.new(
        :method => :put,
        :url => @url+location,
        :user => @user,
        :verify_ssl => @verifyssl,
        :password => @password,
        :headers => { :accept => :json,
        :content_type => :json},
        :payload => JSON.generate(json_data)
    ).execute
    
    if !response.nil?
      results = JSON.parse(response.to_str)
      return results
    end
  end
	
	def api_version
    @api_ver = "v2"
    return @api_ver
  end
	
	def delete(location, json_data)
  
     response = nil
    puts "#{location}"
  
    response = RestClient::Request.new(
        :method => :delete,
        :url => @url+location,
        :user => @user,
        :verify_ssl => @verifyssl,
        :password => @password,
        :headers => { :accept => :json,
        :content_type => :json},
        :payload => JSON.generate(json_data)
    ).execute
    
    if !response.nil?
      results = JSON.parse(response.to_str)
      return results
    end
  end
  
  def api_version
    @api_ver = "v2"
    return @api_ver
  end
	
	
end

		
