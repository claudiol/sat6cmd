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

class Media
  def initialize
    @client = SatelliteConnection.instance
  end
  
  def listall(args, output=false)
    media = nil
    
    args = cleanargs(args)
    
    puts args.inspect
    
    if args.empty?
      media = @client.get("/api/"+@client.api_version+"/media",nil)
    else
      media = @client.get("/api/"+@client.api_version+"/media",args)
    end
    
    if !media.nil? && output
      puts JSON.pretty_generate(media)
    end
    
    return media
    
  end
  
  def showmedia(args, output=false)
    media = nil
    
    args = cleanargs(args)
    puts args.inspect
    
    if (args['id'].nil?)
      puts "Usage: mediashow --id integer"
      return
    else
      id = args.delete('id')
      media = @client.get("/api/"+@client.api_version+"/media/"+id,args)
    end
    
    if !media.nil? && output
      puts JSON.pretty_generate(media)
    end
    
    return media
    
  end
  
  
  def createmedia(args, output=false)
    media = nil
    args = cleanargs(args)
    puts args.inspect
    
    if args['name'].nil? || args['path'].nil?
      puts "Usage: mediacreate --name medianame --path pathtomediasource [--os_family AIX|Archlinux|Debian|Freebsd|Gentoo|Junos|Redhat|Solaris|Suse|Windows]"
      return
    else
      media = @client.post("/api/"+@client.api_version+"/media/",args)
    end
    
    if !media.nil? && output
      puts JSON.pretty_generate(location)
    end
    
    return media
    
  end
  
  def updatemedia(args, output=false)
    media = nil
    args = cleanargs(args)
    puts args.inspect
    
    if args['name'].nil? || args['path'].nil?
      puts "Usage: mediaupdate --id integer --name medianame --path pathtomediasource [--os_family AIX|Archlinux|Debian|Freebsd|Gentoo|Junos|Redhat|Solaris|Suse|Windows]"
      return
    else
      id = args.delete('id')
      media = @client.put("/api/"+@client.api_version+"/media/"+id,args)
    end
    
    if !media.nil? && output
      puts JSON.pretty_generate(location)
    end
    
    return media
  end
  
  def deletemedia(args, output=false)
    media = nil
    
    args = cleanargs(args)
    puts args.inspect
    
    if (args['id'].nil?)
      puts "Usage: mediadelete --id integer"
      return
    else
      id = args.delete('id')
      media = @client.delete("/api/"+@client.api_version+"/media/"+id,args)
    end
    
    if !location.nil? && output
      puts JSON.pretty_generate(media)
    end
    
    return media
    
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