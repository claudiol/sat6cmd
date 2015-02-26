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

class Organizations < KatelloBase
  
  def initialize
    super("organizations")
  end
  
  def repodiscover(args, output=false)
    data = nil
    
    args = cleanargs(args)
    puts args.inspect
    
    if (args['id'].nil?)
      puts "orgrepodiscover requires an argument --id of type integer"
      return
    else
      id = args.delete('id')
      data = @client.put("/api/"+@client.api_version+"/#{@name}/#{id}/repo_discover",args)
    end
    
    if !data.nil? && output
      puts JSON.pretty_generate(data)
    end
    
    return data
    
  end
  
  def cancelrepodiscover(args, output=false)
    data = nil
    
    args = cleanargs(args)
    puts args.inspect
    
    if (args['id'].nil?)
      puts "orgcancelrepodiscover requires an argument --id of type integer"
      return
    else
      id = args.delete('id')
      data = @client.put("#{@baseurl}/#{@name}/#{id}/cancel_repo_discover",args)
    end
    
    if !data.nil? && output
      puts JSON.pretty_generate(data)
    end
    
    return data
    
  end 
  
  def downloaddebugcert(args, output=false)
    data = nil
    
    args = cleanargs(args)
    puts args.inspect
    
    if (args['id'].nil?)
      puts "orgdownloaddebugcert requires an argument --id of type integer"
      return
    else
      id = args.delete('id')
      data = @client.get("#{@baseurl}/#{@name}/#{id}/download_debug_certificate",args)
    end
    
    if !data.nil? && output
      puts JSON.pretty_generate(data)
    end
    
    return data
    
  end  
  
  def autoattachsubs(args, output=false)
    data = nil
    
    args = cleanargs(args)
    puts args.inspect
    
    if (args['id'].nil?)
      puts "orgautoattach requires an argument --id of type integer"
      return
    else
      id = args.delete('id')
      data = @client.post("#{@baseurl}/#{@name}/#{id}/autoattach_subscriptions",args)
    end
    
    if !data.nil? && output
      puts JSON.pretty_generate(data)
    end
    
    return data
    
  end  
     
  
end