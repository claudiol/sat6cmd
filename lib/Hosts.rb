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

class Hosts < Base
  # @!method initialize
  # Calls base class with the class identifier
  def initialize
    super("hosts")
  end

  # @!method showhost
  # @param args - Arguments for show host are passed by the user. Valid argument is --id <hostid>
  # @param output - Boolean true or false
  #
  def showhost(args, output=false)
    data = nil

    puts args.count
    unless args.include? '--id'
      puts "#{@name} requires an argument --id of type integer for the Host identifier"
      return
    else
      args = cleanargs(args)
      puts args.inspect

      id = args.delete('id')
      if self.is_a_number?(id)
        data = @client.get("#{@baseurl}/#{@name}/#{id}", args)
      else
        puts "The id must be an integer type."
      end

    end

    if !data.nil? && output
      puts JSON.pretty_generate(data)
    end

    return data
  end

  def is_a_number?(s)
    s.to_s.match(/\A[+-]?\d+?(\.\d+)?\Z/) == nil ? false : true
  end

  # @!method createhost
  # @param args - Arguments for show host are passed by the user. Valid argument is -n <name of host>
  # @param hostinfo - Hash that contains the following information.
  #   #
  #   host	False	Hash	Host subcollection
  #   host[name]	True	String	Host name
  #   host[environment_id]	False	String	Environment identifier
  #   host[ip]	False	String	Host IP address. Not required if using a subnet with DHCP proxy.
  #   host[mac]	False	String	Host MAC address. Not required if host is a virtual machine.
  #   host[domain_id]	False	Number	Host domain identifier
  #   host[realm_id]	False	Number	Host realm identifier
  #   host[puppet_proxy_id]	False	Number	Host Puppet Proxy identifier
  #   host[puppet_class_ids]	False	Array	List of Puppet Class identifiers
  #   host[operatingsystem_id]	False	String	Host operating System identifier
  #   host[medium_id]	False	Number	Host medium identifier
  #   host[ptable_id]	False	Number	Host partition table identifier
  #   host[subnet_id]	False	Number	Host subnet identifier
  #   host[compute_resource_id]	False	Number	Host compute resource identifier
  #   host[sp_subnet_id]	False	Number	The subnet identifier to use for the host's service processor on the baseboard management controller
  #   host[model_id]	False	Number	Host's model identifier
  #   host[hostgroup_id]	False	Number	Host's hostgroup identifier
  #   host[owner_id]	False	Number	Host's owner identifier
  #   host[puppet_ca_proxy_id]	False	Number	Host's Puppet certificate authority identifier
  #   host[image_id]	False	Number	Host's image identifier
  #   host[host_parameters_attributes]	False	Array	List of parameter attributes for the host
  #   host[build]	False	Boolean	Enables build mode for the host
  #   host[enabled]	False	Boolean	Defines if the host is included within reporting
  #   host[provision_method]	False	String	Defines the provisioning method to use. Either build or image.
  #   host[managed]	False	Boolean	Defines if Satellite manages the host's build cycle.
  #   host[progress_report_id]	False	String	Progress report identifier to track orchestration tasks status
  #   host[capabilities]	False	String	Capabilities of compute resources for host
  #   host[compute_profile_id]	False	Number	Compute profile identifier
  #   host[compute_attributes]	False	Hash	Subcollection of compute attributes
  # @param output - Boolean true or false
  #
  def createhost(args, hostinfo={}, output=false)
    data = nil
    hostinfo = {}
    puts args.inspect
    unless args.include? '-n'
      puts "#{@name}:createhost method requires an argument -n <hostname> of type string for the Host name"
      return
    else
      hostname = "#{args['-n']}"
      if !hostname.nil?
        puts "#{hostname}"
        hostinfo['name'] = "#{hostname}"
        puts "after"
        data = @client.post("#{@baseurl}/#{@name}/", hostinfo)
      else
        puts "The hostname must be present."
      end
    end

    if !data.nil? && output
      puts JSON.pretty_generate(data)
    end

    return data



  end
end
