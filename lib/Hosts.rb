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

load 'lib/Base.rb'

class Hosts < Base
  # @!method initialize
  # Calls base class with the class identifier
  def initialize
    super("hosts")
  end

  # @!method showhost
  # @param args - Arguments for show host are passed by the user. Valid argument is --id <hostid>
  # @param output - Boolean true or false
  #
  def showhost(args, output=false)
    data = nil

    puts args.count
    unless args.include? '--id'
      puts "#{@name} requires an argument --id of type integer for the Host identifier"
      return
    else
      args = cleanargs(args)
      puts args.inspect

      id = args.delete('id')
      if self.is_a_number?(id)
        data = @client.get("#{@baseurl}/#{@name}/#{id}", args)
      else
        puts "The id must be an integer type."
      end

    end

    if !data.nil? && output
      puts JSON.pretty_generate(data)
    end

    return data
  end

  def is_a_number?(s)
    s.to_s.match(/\A[+-]?\d+?(\.\d+)?\Z/) == nil ? false : true
  end

  def createhost(args, output=false)
    data = nil

    args = cleanargs(args)
    puts args.inspect
    unless args.include? 'name'
      puts "#{@name}:createhost method requires an argument --name of type string for the Host name"
      return
    else
      hostname = args.delete('name')
      if !hostname.nil?
        data = @client.post("#{@baseurl}/#{@name}/", args)
      else
        puts "The hostname must be present."
      end

    end

    if !data.nil? && output
      puts JSON.pretty_generate(data)
    end

    return data



  end
end
