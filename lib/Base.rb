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

class Base
  
  
  def initialize(name)
    @client = SatelliteConnection.instance
    @baseurl="/api/"+@client.api_version
    @name = name
  end
  
  def setup(user, pass, host, verify_ssl)
    @client.setup(@user, @pass, @host, @verify_ssl)
  end
  
  def listall(args, output=false)
    data = nil
    
    if args.empty?
      data = @client.get(@baseurl+"/"+@name,nil)
    else
      data = @client.get(@baseurl+"/"+@name,args)
    end
    
    if !data.nil? && output
      puts JSON.pretty_generate(data)
    end
    
    return data
    
  end
  
  
  def show(id, output=false)
    data = nil

    unless id.nil? || is_a_number(id)
      puts "Class #{@name}: Method \"show\" requires the id argument of type integer for the entity identifier"
      return
    else
      data = @client.get("#{@baseurl}/#{@name}/#{id}", nil)
    end

    if !data.nil? && output
      puts JSON.pretty_generate(data)
    end

    return data

  end
  
  def create(entityname, args, output=false)
    data = nil
    
    unless entityname.nil? && args['name'].nil?
      puts "Class #{@name}: Method \"create\" requires a name for the entity."
      return
    else
      if args['name'].nil?
        args['name'] = entityname
      end
      data = @client.post("#{@baseurl}/#{@name}/", args)
    end
    
    if !data.nil? && output
      puts JSON.pretty_generate(data)
    end
    
    return data
    
  end
  
  def update(id, args, output=false)
    
    data = nil
    
    unless id.nil? || is_a_number(id)
      puts "Class #{@name}: Method \"update\" requires the id argument of type integer for the entity identifier"
      return
    else
      data = @client.put("#{@baseurl}/#{@name}/#{id}",args)
    end
    
    if !data.nil? && output
      puts JSON.pretty_generate(data)
    end
    
    return data
    
  end
  
  def delete(id, args, output=false)
    
    data = nil
    unless id.nil? || is_a_number(id)
      puts "Class #{@name}: Method \"delete\" requires the id argument of type integer for the entity identifier"
      return
    else
      data = @client.delete("#{@baseurl}/#{@name}/#{id}",args)
    end
    
    if !data.nil? && output
      puts JSON.pretty_generate(data)
    end
    
    return data
    
  end
  
  private
  def is_a_number?(s)
    s.to_s.match(/\A[+-]?\d+?(\.\d+)?\Z/) == nil ? false : true
  end
end