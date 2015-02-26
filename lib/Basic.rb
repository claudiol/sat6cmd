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

class Basic
  
  def initialize
    @client = SatelliteConnection.instance
  end

  def showapi(args, output=false)
    
    data = @client.get("/api/"+@client.api_version,nil)

    if output
      puts JSON.pretty_generate(data)
    end
    
  end
  
  def showkatelloapi(args, output=false)
    
    data = @client.get("/katello/api/"+@client.api_version,nil)
    
    if output
      puts JSON.pretty_generate(data)
    end
    
  end
  
  def showstatus(args, output=false)
    if !args.empty?
      puts "This action doesn't take arguments.  Ignoring #{args}"
    end
    
    data = @client.get("/api/"+@client.api_version+"/status",nil)
    
    if output
      puts JSON.pretty_generate(data)
    end
    
  end

end