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

class Models
  def initialize
    @client = SatelliteConnection.instance
  end
  
  def listall(args, output=false)
    model = nil
    
    args = cleanargs(args)
    
    puts args.inspect
    
    if args.empty?
      model = @client.get("/api/"+@client.api_version+"/models",nil)
    else
      model = @client.get("/api/"+@client.api_version+"/models",args)
    end
    
    if !model.nil? && output
      puts JSON.pretty_generate(model)
    end
    
    return model
    
  end
  
  def showmodel(args, output=false)
    model = nil
    
    args = cleanargs(args)
    puts args.inspect
    
    if (args['id'].nil?)
      puts "Usage: modelshow --id integer"
      return
    else
      id = args.delete('id')
      model = @client.get("/api/"+@client.api_version+"/models/"+id,args)
    end
    
    if !model.nil? && output
      puts JSON.pretty_generate(model)
    end
    
    return model
    
  end
  
  
  def createmodel(args, output=false)
    model = nil
    args = cleanargs(args)
    puts args.inspect
    
    if args['name'].nil? || args['path'].nil?
      puts "Usage: modelcreate --name modelname [--info modelinformation --vendor_class modelvendorclass --hardware_model modelhardware]"
      return
    else
      model = @client.post("/api/"+@client.api_version+"/models/",args)
    end
    
    if !model.nil? && output
      puts JSON.pretty_generate(location)
    end
    
    return model
    
  end
  
  def updatemodel(args, output=false)
    model = nil
    args = cleanargs(args)
    puts args.inspect
    
    if args['name'].nil? || args['path'].nil?
      puts "Usage: modelupdate --id integer --name modelname [--info modelinformation --vendor_class modelvendorclass --hardware_model modelhardware]"
      return
    else
      id = args.delete('id')
      model = @client.put("/api/"+@client.api_version+"/models/"+id,args)
    end
    
    if !model.nil? && output
      puts JSON.pretty_generate(location)
    end
    
    return model
  end
  
  def deletemodel(args, output=false)
    model = nil
    
    args = cleanargs(args)
    puts args.inspect
    
    if (args['id'].nil?)
      puts "Usage: modeldelete --id integer"
      return
    else
      id = args.delete('id')
      model = @client.delete("/api/"+@client.api_version+"/models/"+id,args)
    end
    
    if !location.nil? && output
      puts JSON.pretty_generate(model)
    end
    
    return model
    
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