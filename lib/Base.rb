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
  
  def listall(args, output=false)
    data = nil
    
    args = cleanargs(args)
    
    puts args.inspect
    
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
  
  def show(args, output=false)
    data = nil
    
    args = cleanargs(args)
    puts args.inspect
    
    if (args['id'].nil?)
      puts "show requires an argument --id of type integer"
      return
    else
      id = args.delete('id')
      data = @client.get("#{@baseurl}/#{@name}/"+id,args)
    end
    
    if !data.nil? && output
      puts JSON.pretty_generate(data)
    end
    
    return data
    
  end
  
  def create(args, output=false)
    data = nil
    args = cleanargs(args)
    puts args.inspect
    
    if args['name'].nil?
      puts "create requires an argument --name of type string"
      return
    else
      data = @client.post("#{@baseurl}/#{@name}/",args)
    end
    
    if !data.nil? && output
      puts JSON.pretty_generate(data)
    end
    
    return data
    
  end
  
  def update(args, output=false)
    
    data = nil
    args = cleanargs(args)
    puts args.inspect
    
    if (args['id'].nil?)
      puts "update requires an argument --id of type integer"
      return
    else
      id = args.delete('id')
      data = @client.put("#{@baseurl}/#{@name}/"+id,args)
    end
    
    if !data.nil? && output
      puts JSON.pretty_generate(data)
    end
    
    return data
    
  end
  
  def delete(args, output=false)
    
    data = nil
    args = cleanargs(args)
    puts args.inspect
    
    if (args['id'].nil?)
      puts "delete requires an argument --id of type integer"
      return
    else
      id = args.delete('id')
      data = @client.delete("#{@baseurl}/#{@name}/"+id,args)
    end
    
    if !data.nil? && output
      puts JSON.pretty_generate(data)
    end
    
    return data
    
  end
  
  private
  def cleanargs(args)
    sort = Hash.new
    
    args.keys.each do |k|
      if(k[0,2] == '--')
          args[k[2, k.length - 1]] = args[k]
          args.delete(k)
      end
    end
    
    if !args['sortby'].nil?
      sort["by"] = args["sortby"]
      args.delete("sortby")
    end
    
    if !args['sortorder'].nil?
      sort["order"] = args["sortorder"]
      args.delete("sortorder")
    end
 
    if !sort.empty?
      args["sort"] = sort
    end 
    
    return args
  end
end