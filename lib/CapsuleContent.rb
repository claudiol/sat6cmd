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

load 'lib/KatelloBase.rb'

class CapsuleContent < KatelloBase
  def initialize
    super("capsules")
  end
  
  def lifecycle_environments(id)
    data = nil

    unless id.nil? || is_a_number?(id)
      puts "Class CapsuleContent: Method \"lifecycle_environments\" requires the id argument of type integer for the entity identifier"
      return
    else
      data = @client.get("#{@baseurl}/#{@name}/#{id}/content/lifecycle_environments", nil)
    end

    if !data.nil? && output
      puts JSON.pretty_generate(data)
    end

    return data
  end
  
  def available_lifecycle_environments(id)
    data = nil

    unless id.nil? || is_a_number?(id)
      puts "Class CapsuleContent: Method \"available_lifecycle_environments\" requires the id argument of type integer for the entity identifier"
      return
    else
      data = @client.get("#{@baseurl}/#{@name}/#{id}/content/available_lifecycle_environments", nil)
    end

    if !data.nil? && output
      puts JSON.pretty_generate(data)
    end

    return data
  end
  
  def add_lifecycle_environment(id, args)
    data = nil

    unless id.nil? || is_a_number?(id)
      puts "Class CapsuleContent: Method \"add_lifecycle_environment\" requires the id argument of type integer for the entity identifier"
      return
    else
      data = @client.post("#{@baseurl}/#{@name}/#{id}/content/lifecycle_environments", args)
    end

    if !data.nil? && output
      puts JSON.pretty_generate(data)
    end

    return data
  end
  
  def remove_lifecycle_environment(id, environment_id)
    data = nil

    unless (id.nil? || is_a_number?(id)) && (environment_id.nil? || is_a_number?(environment_id))
      puts "Class CapsuleContent: Method \"remove_lifecycle_environment\" requires the id argument of type integer for the entity identifier and environment_id for the environment identifier"
      return
    else
      data = @client.delete("#{@baseurl}/#{@name}/#{id}/content/lifecycle_environments/#{environment_id}", args)
    end

    if !data.nil? && output
      puts JSON.pretty_generate(data)
    end

    return data
  end

  def sync_content(id, args)
    data = nil

    unless id.nil? || is_a_number?(id)
      puts "Class CapsuleContent: Method \"sync_content\" requires the id argument of type integer for the entity identifier"
      return
    else
      data = @client.post("#{@baseurl}/#{@name}/#{id}/content/sync", args)
    end

    if !data.nil? && output
      puts JSON.pretty_generate(data)
    end

    return data
  end
  
end