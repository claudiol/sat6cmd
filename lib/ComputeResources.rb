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

class ComputeResources < Base
  def initialize
    super("compute_resources")
  end
  
  def list_available_images(id)
    data = nil

    unless id.nil? || is_a_number?(id)
      puts "Class #{@name}: Method \"list_available_images\" requires the id argument of type integer for the entity identifier"
      return
    else
      data = @client.get("#{@baseurl}/#{@name}/#{id}/available_images", nil)
    end

    if !data.nil? && output
      puts JSON.pretty_generate(data)
    end

    return data
  end
  
  def list_available_clusters(id)
    data = nil

    unless id.nil? || is_a_number?(id)
      puts "Class #{@name}: Method \"list_available_clusters\" requires the id argument of type integer for the entity identifier"
      return
    else
      data = @client.get("#{@baseurl}/#{@name}/#{id}/available_clusters", nil)
    end

    if !data.nil? && output
      puts JSON.pretty_generate(data)
    end

    return data
  end

  def list_available_networks(id)
    data = nil

    unless id.nil? || is_a_number?(id)
      puts "Class #{@name}: Method \"list_available_networks\" requires the id argument of type integer for the entity identifier"
      return
    else
      data = @client.get("#{@baseurl}/#{@name}/#{id}/available_networks", nil)
    end

    if !data.nil? && output
      puts JSON.pretty_generate(data)
    end

    return data
  end
  
  def list_available_networks_by_cluster(id, clusterid)
    data = nil

    unless (id.nil? || is_a_number?(id)) && (clusterid.nil? || is_a_number?(clusterid))
      puts "Class #{@name}: Method \"listavailablenetworks\" requires the id argument of type integer for the entity identifier and an argument clusterid for the cluster identifier"
      return
    else
      data = @client.get("#{@baseurl}/#{@name}/#{id}/available_clusters/#{clusterid}/available_networks", nil)
    end

    if !data.nil? && output
      puts JSON.pretty_generate(data)
    end

    return data
  end
  
  def list_available_storage_domains(id)
    data = nil

    unless id.nil? || is_a_number?(id)
      puts "Class #{@name}: Method \"list_available_networks\" requires the id argument of type integer for the entity identifier"
      return
    else
      data = @client.get("#{@baseurl}/#{@name}/#{id}/available_storage_domains", nil)
    end

    if !data.nil? && output
      puts JSON.pretty_generate(data)
    end

    return data
  end
  
end