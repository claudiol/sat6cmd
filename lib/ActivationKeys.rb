#!/usr/bin/env ruby
#####################################################################################
# Copyright 2015 Kenneth Evensen <kenneth.evensen@redhat.com>
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at

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

require 'json'

load 'lib/Base.rb'

class ActivationKeys < Base
  def initialize
    super("activation_keys")
    @client = SatelliteConnection.instance
  end

  # @!method listallkeys
  # @param args - Arguments passed by the user. Valid arguments are --o <orgid> or -e <environmentid>
  #               or -c <contentviewid>
  # @param output - JSON data for Activation Key
  #
  def listallkeys(args)
    puts "Empty args? #{args.empty?} #{args.inspect}"
    if !args.include? '-o'
      if !args.include? '-e'
        if !args.include? '-c'
          puts "#{@name} requires an argument of -o for organization id or -e for environment with identifier"
          return
        end
      end
    end

    if !args['-e'].nil?
      data = @client.get("/katello/api/"+@client.api_version+"/environments/#{args['-e']}/activation_keys",nil)
    elsif !args['-o'].nil?
      data = @client.get("/katello/api/"+@client.api_version+"/organizations/#{args['-o']}/activation_keys",nil)
    elsif !args['-c'].nil?
      data = @client.get("/katello/api/"+@client.api_version+"/content_views/#{args['-c']}", nil) ##"/#{args['-c']}/activation_keys",nil)
      ###data = @client.get("/katello/api/"+@client.api_version+"/content_views", nil) ##"/#{args['-c']}/activation_keys",nil)
    end
    if !data.nil?
      puts JSON.pretty_generate(data)
    end

    return data
  end


  # organization_id True Number Organization identifier
  # name True String Plain text name
  # description False String Plain text description
  # environment False Hash Environment subcollection
  # environment_id False String from 2 to 128 characters containing only alphanumeric characters, space,
  #                             underscores, and dashes but no leading or trailing space Environment identifier
  # content_view_id False String from 2 to 128 characters containing
  #                              only alphanumeric characters, space, underscores, and dashes but no leading or trailing space
  #                              Content view identifier
  # max_content_hosts False Number Maximum number of registered content hosts
  # unlimited_content_hosts False Boolean Set if the activation key can have unlimited hosts



  def createkey(args)
    if !args.include? '-o'
      puts "#{@name} requires an argument of -o for organization id and -c for name identifier"
      return
    end

    if !args.include? '-n'
          puts "#{@name} requires both arguments of -o for organization id and -c for name identifier"
          return
    end

    org_id = "#{args['-o']}"
    name = "#{args['-n']}"

    if org_id.nil? || name.nil?
      puts "Org id or Name cannot be nil"
      return
    end
    content = {:organization_id => "#{org_id}", :name => "#{name}" }
    data = @client.post("/katello/api/activation_keys", content) ##"/#{args['-c']}/activation_keys",nil)

    if !data.nil?
      puts JSON.pretty_generate(data)
    end

  end

  def deletekey(args)
    begin

      if !args.include? '--id'
        puts "#{@name} requires an argument of -o for organization id and -c for name identifier"
        return
      end

      key_id = "#{args['--id']}"

      if key_id.nil?
        puts "Key id cannot be nil"
        return
      end
      content = {"id" => "#{key_id}"}
      @client.delete("/katello/api/activation_keys/#{key_id}", {}) ##"/#{args['-c']}/activation_keys",nil)

    rescue => ex
      puts "Exception in deletekey: #{ex.message}"
    end
  end
end