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
#####################################################################################
#
# Contact Info: <kenneth.evensen@redhat.com> and <lester@redhat.com>
#
#####################################################################################

class Audits
  
  def initialize
    @client = SatelliteConnection.instance
  end

  def listall(args, output=false)
    
    data = @client.get("/api/#{@client.api_version}/audits",nil)

    if output
      puts JSON.pretty_generate(data)
    end
    
  end
  
  def listallauditsbyhost(args, output=false)
    
    data = nil
    
    if (args['id'].nil?)
      puts "auditbyhost requires an argument --id of type integer"
      return
    else
      id = args.delete('id')
      data = @client.get("/api/#{@client.api_version}/hosts/#{id}/audits",nil)
    end

    if output && !data.nil?
      puts JSON.pretty_generate(data)
    end
    
    if !data.nil?
      return data
    end
      
    
  end
  
end