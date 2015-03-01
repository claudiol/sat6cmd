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

class CustomInformation < KatelloBase
  
  def initialize
    super("custom_info")
  end
  
  def create_custom_information(informable_type, informable_id, args)
    
    data.nil?
    
    data = @client.post("#{@baseurl}/#{@name}/#{informable_type}/#{informable_id}", args)
    
    if !data.nil? && output
      puts JSON.pretty_generate(data)
    end
    
    return data
  end
  
  def update_custom_information(informable_type, informable_id, keyname, args)
    
    data.nil?
    
    data = @client.put("#{@baseurl}/#{@name}/#{informable_type}/#{informable_id}/#{keyname}", args)
    
    if !data.nil? && output
      puts JSON.pretty_generate(data)
    end
    
    return data
  end
  
end