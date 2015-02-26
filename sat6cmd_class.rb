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

load 'lib/SatelliteConnection.rb'
load 'lib/Basic.rb'
load 'lib/ActivationKeys.rb'
load 'lib/Locations.rb'
load 'lib/Media.rb'
load 'lib/Models.rb'

require 'readline'
require 'rubygems'
require 'yaml'

class Sat6Cmd  
  def initialize   
    # Instance variables
    # TODO: Need to see if there are other instance variables for this class.  
    # Command Prompt
    #@evm_commands = [:api_get]
    
    @command = nil 
    @LIST = ['showapi',
            'showkatelloapi',
            'showstatus',
            'locationlist',
            'locationshow',
            'locationcreate',
            'locationupdate',
            'locationdelete',
            'medialist',
            'mediashow',
            'mediacreate',
            'mediaupdate',
            'mediadelete',
            'modellist',
            'modelshow',
            'modelcreate',
            'modelupdate',
            'modeldelete',
            'listkeys',
            'version',
            'help',
            'exit',
            'quit'].sort
            
    @list = [
        ['showapi', 'Get the REST API'],
        ['showkatelloapi', 'Get the Katello REST API'],
        ['showstatus','Show status'],
        ['listkeys','List activation keys'],
        ['locationlist', 'List locations'],
        ['locationshow', 'Show a location'],
        ['locationcreate', 'Create a location'],
        ['locationupdate', 'Update a location'],
        ['locationdelete', 'Delete a location'],
        ['medialist', 'List media'],
        ['mediashow', 'Show a medium'],
        ['mediacreate', 'Create a medium'],
        ['mediaupdate', 'Update a medium'],
        ['mediadelete', 'Delete a medium'],
        ['modellist', 'List models'],
        ['modelhow', 'Show a model'],
        ['modelcreate', 'Create a model'],
        ['modelupdate', 'Update a model'],
        ['modeldelete', 'Delete a model'],
        ['version', 'Get the Satellite 6 Version'],
        ['help [cmd]', 'Help me please!'],
        ['exit', 'Get me out of here!'],
        ['quit', 'I want to quit! Get me out of here!']
      ].sort

    config = self.read_config
    
    @host = config["connection"]["host"] 
    @user = config["connection"]["user"]
    @pass = config["connection"]["pass"]
    @verify_ssl = config["connection"]["verify_ssl"]
    @cmdprompt = config["application"]["prompt"]
    @client = SatelliteConnection.instance
    @client.setup(@user, @pass, @host, @verify_ssl)
    #@client.login(@cfmehost, @cfmeport, @cfmeuser, @cfmepass)
    
    
    #@management_sytems = ManagementSystems.new
    #@virtualmachines = VirtualMachines.new
    #@host = Host.new
    #@automationreq = AutomationRequest.new
    #@cluster = Clusters.new
    #@datastore = DataStore.new
    #@resourcepool = ResourcePool.new
    
    
    @basic = Basic.new
    @activationKeys = ActivationKeys.new
    @locations = Locations.new
    @media = Media.new
    @model = Models.new
    
  end

  def read_config
      begin
        return YAML.load_file("config.yaml")
      rescue => exception
        puts exception.message
      end
  end
  
  ########################################################################################################################
  def help ( cmd )
    if cmd == {}
      puts "Commands that can currently be run: "

      # Let's just go through the list that we have ...
      @list.each do | citem, msg |
        puts "  " << citem
      end
    else
      @list.each do | citem, msg |
        if citem == cmd[0]
          command = citem
          message = msg
          puts "#{command} : #{message}"
          break
        end
      end
    end
  end
  
  
  def version
    puts @client.api_version
  end
  
  def run (arguments)
    begin
      comp = proc { |s| @LIST.grep(/^#{Regexp.escape(s)}/) }

      Readline.completion_append_character = ""
      Readline.completion_proc = comp

      if (ARGV[0].nil?) then
        while line = Readline.readline("#{@cmdprompt} ", true)
          run_cmd = line.split
          cmd = {'-x'=>"#{run_cmd[0]}"}
          run_cmd.delete(run_cmd[0])
          (run_cmd.count == 1) ? run_args = run_cmd : run_args = Hash[*run_cmd.flatten]
          run_method = cmd['-x']
          run_arguments = run_args
#          puts "Running command #{run_method} arguments: #{run_arguments}"
          handle_call(cmd['-x'], run_args)
        end
      else
        run_cmd = arguments['-x']
        run_method = arguments['-x']
        run_arguments = arguments
        puts "Running command #{run_method} arguments: #{run_arguments}"
        handle_call(arguments['-x'], run_arguments)
      end
    rescue => exception
      puts exception.message
      puts "Returning to the prompt."
      run(arguments)
    end
  end
  
  def handle_call(run_method, run_arguments)
    begin
      case run_method
        when "showapi"
          @basic.showapi(run_arguments, true)
        when "showkatelloapi"
           @basic.showkatelloapi(run_arguments, true)
        when "showstatus"
           @basic.showstatus(run_arguments, true)
           
        when "listkeys"
          @activationKeys.listall(run_arguments, true)
        when "locationlist"
          @locations.listall(run_arguments, true)
        when "locationshow"
          @locations.showlocation(run_arguments, true)
        when "locationcreate"
          @locations.createlocation(run_arguments, true)
        when "locationupdate"
          @locations.updatelocation(run_arguments, true)
        when "locationdelete"
          @locations.deletelocation(run_arguments, true)
          
        when "medialist"
          @media.listall(run_arguments, true)
        when "mediashow"
          @media.showmedia(run_arguments, true)
        when "mediacreate"
          @media.createmedia(run_arguments, true)
        when "mediaupdate"
          @media.updatemedia(run_arguments, true)
        when "mediadelete"
          @media.deletemedia(run_arguments, true)  
          
        when "modellist"
          @model.listall(run_arguments, true)
        when "modelshow"
          @model.showmodel(run_arguments, true)
        when "modelcreate"
          @model.createmodel(run_arguments, true)
        when "modelupdate"
          @model.updatemodel(run_arguments, true)
        when "modeldelete"
          @model.deletemodel(run_arguments, true)  
          
        when "quit", "QUIT"
          self.quit
        when "exit", "EXIT"
          self.exit
        when "version"
          self.version
        when "help"
          self.help(run_arguments)
        else
          puts "Unrecognized command: #{run_method}"
          self.help({})
        end
     rescue => exception
      puts "Exception: " << exception.message
      return    
     end
  end
      
 ########################################################################################################################
  def quit
    puts "Quitter!"
    Process.exit!(true)
  end

  ########################################################################################################################
  def exit
    puts "Goodbye!"
    Process.exit!(true)
  end

  ########################################################################################################################
  def showminimal(id_title, id_value, name_title, name_value)
    puts "#{id_title}: #{id_value}\t #{name_title}: #{name_value}"
  end


  ########################################################################################################################
  def parseCli(run_method, run_args)
    unless run_method == "blank"
      send (run_method)
    end
  end
      
      
      
        

end
        
