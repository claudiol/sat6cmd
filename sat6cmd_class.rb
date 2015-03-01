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
load 'lib/Architectures.rb'
load 'lib/Audits.rb'
load 'lib/Autosign.rb'
load 'lib/Bookmarks.rb'
load 'lib/Capsules.rb'
load 'lib/CommonParameters.rb'
load 'lib/Locations.rb'
load 'lib/Ldap.rb'
load 'lib/Media.rb'
load 'lib/Models.rb'
load 'lib/OperatingSystems.rb'
load 'lib/Organizations.rb'

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
            
            'archlist',
            'archshow',
            'archcreate',
            'archupdate',
            'archdelete',
            
            'auditlist',
            'auditlistbyhost',
            
            'autosignlist',
            
            'bookmarklist',
            'bookmarkshow',
            'bookmarkcreate',
            'bookmarkupdate',
            'bookmarkdelete',
            
            'capsulelist',
            'capsuleshow',
            
            'commonparameterlist',
            'commonparametershow',
            'commonparametercreate',
            'commonparamterupdate',
            'commonparamterdelete',
            
            'ldaplist',
            'ldapshow',
            'ldapcreate',
            'ldapupdate',
            'ldapdelete',
            
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
            
            'oslist',
            'osshow',
            'oscreate',
            'osupdate',
            'osdelete',
            'osbootfilelist',
            
            'orglist',
            'orgshow',
            'orgcreate',
            'orgupdate',
            'orgdelete',
            'orgrepodiscover',
            'orgcancelrepodiscover',
            'orgdownloaddebugcert',
            'orgautoattach',
            'orglistresources',
            
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
        
         
        ['archlist', 'List architectures'],
        ['archshow', 'Show an architecture'],
        ['archcreate', 'Create an architecture'],
        ['archupdate', 'Update an architecture'],
        ['archdelete', 'Delete an architecture'],
        
        ['auditlist', 'List all audits'],
        ['auditlistbyhost', 'List all audits for a given host'],
        
        ['autosignlist', 'List all autosign'],
        
        ['bookmarklist', 'List bookmarks'],
        ['bookmarkshow', 'Show a bookmark'],
        ['bookmarkcreate', 'Create an bookmark'],
        ['bookmarkupdate', 'Update a bookmark'],
        ['bookmarkdelete', 'Delete a bookmark'],
        
        ['capsulelist', 'List all capsules'],
        ['capsuleshow', 'Show a capsule'],
        
        ['commonparameterlist', 'List Common Parameters sources'],
        ['commonparametershow', 'Show a common parameter'],
        ['commonparametercreate', 'Create a common parameter'],
        ['commonparameterupdate', 'Update a common parameter'],
        ['commonparameterdelete', 'Delete a common parameter'],
        
        ['ldaplist', 'List LDAP sources'],
        ['ldapshow', 'Show an LDAP source'],
        ['ldapcreate', 'Create an LDAP source'],
        ['ldapupdate', 'Update an LDAP source'],
        ['ldapdelete', 'Delete an LDAP source'],
        
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
        ['modelshow', 'Show a model'],
        ['modelcreate', 'Create a model'],
        ['modelupdate', 'Update a model'],
        ['modeldelete', 'Delete a model'],
        ['oslist', 'List operating systems'],
        ['osshow', 'Show an OS'],
        ['oscreate', 'Create an OS'],
        ['osupdate', 'Update an OS'],
        ['osdelete', 'Delete an OS'],
        ['osbootfilelist', 'List boot files for an operating system'],
        ['orglist', 'List organizations'],
        ['orgshow', 'Show an organization'],
        ['orgcreate', 'Create an organization'],
        ['orgupdate', 'Update an organization'],
        ['orgdelete', 'Delete an organization'],
        ['orgdelete', 'Delete an organization'],
        ['version', 'Get the Satellite 6 Version'],
        ['orgrepodiscover', 'Discover repositories'],
        ['orgcancelrepodiscover', 'Cancel repository discovery'],
        ['orgdownloaddebugcert', 'Download a debug certificate'],
        ['orgautoattach', 'Auto-attach available subscriptions to all systems within an organization'],
        ['orglistresources','List all resources for an organization'],
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
    
    
   
    
    
    @basic = Basic.new
    @activationKeys = ActivationKeys.new
    @arch = Architectures.new
    @audit = Audits.new
    @auto = Autosign.new
    @book = Bookmarks.new
    @capsule = Capsules.new
    @commonparameter = CommonParameters.new
    @ldap = Ldap.new
    @locations = Locations.new
    @media = Media.new
    @model = Models.new
    @os = OperatingSystems.new
    @org = Organizations.new
    
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
    
    run_arguments = cleanargs(run_arguments)
    puts run_arguments.inspect
    
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
          
        when "archlist"
          @arch.listall(run_arguments, true)
        when "archshow"
          @arch.show(run_arguments, true)
        when "archcreate"
          @arch.create(run_arguments, true)
        when "archupdate"
          @arch.update(run_arguments, true)
        when "archdelete"
          @arch.delete(run_arguments, true)
          
        when "auditlist"
          @audit.listall(run_arguments,true)
        when "auditlistbyhost"
          @audit.listallauditsbyhost(run_arguments,true)
          
        when "autosignlist"
          @auto.listall(run_arguments,true)
          
        when "bookmarklist"
          @book.listall(run_arguments, true)
        when "bookmarkshow"
          @book.show(run_arguments, true)
        when "bookmarkcreate"
          @book.create(run_arguments, true)
        when "bookmarkupdate"
          @book.update(run_arguments, true)
        when "bookmarkdelete"
          @book.delete(run_arguments, true)
          
        when "capsulelist"
          @capsule.listall(run_arguments, true)
        when "capsuleshow"
          @capsule.show(run_arguments, true)
          
        when "commonparameterlist"
          @commonparameter.listall(run_arguments, true)
        when "commonparametershow"
          @commonparameter.show(run_arguments, true)
        when "commonparametercreate"
          @commonparameter.create(run_arguments, true)
        when "commonparameterupdate"
          @commonparameter.update(run_arguments, true)
        when "commonparameterdelete"
          @commonparameter.delete(run_arguments, true)
                   
        when "ldaplist"
          @ldap.listall(run_arguments, true)
        when "ldapshow"
          @ldap.show(run_arguments, true)
        when "ldapcreate"
          @ldap.create(run_arguments, true)
        when "ldapupdate"
          @ldap.update(run_arguments, true)
        when "ldapdelete"
          @ldap.delete(run_arguments, true)
          
        when "locationlist"
          @locations.listall(run_arguments, true)
        when "locationshow"
          @locations.show(run_arguments, true)
        when "locationcreate"
          @locations.create(run_arguments, true)
        when "locationupdate"
          @locations.update(run_arguments, true)
        when "locationdelete"
          @locations.delete(run_arguments, true)
          
        when "medialist"
          @media.listall(run_arguments, true)
        when "mediashow"
          @media.show(run_arguments, true)
        when "mediacreate"
          @media.create(run_arguments, true)
        when "mediaupdate"
          @media.update(run_arguments, true)
        when "mediadelete"
          @media.delete(run_arguments, true)  
          
        when "modellist"
          @model.listall(run_arguments, true)
        when "modelshow"
          @model.show(run_arguments, true)
        when "modelcreate"
          @model.create(run_arguments, true)
        when "modelupdate"
          @model.update(run_arguments, true)
        when "modeldelete"
          @model.delete(run_arguments, true)  
          
        when "oslist"
          @os.listall(run_arguments, true)
        when "osshow"
          @os.show(run_arguments, true)
        when "oscreate"
          @os.create(run_arguments, true)
        when "osupdate"
          @os.update(run_arguments, true)
        when "osdelete"
          @os.delete(run_arguments, true)  
        when "oslistbootfiles"
          @os.listbootfiles(run_arguments, true) 
          
        when "orglist"
          @org.listall(run_arguments, true)
        when "orgshow"
          @org.show(run_arguments, true)
        when "orgcreate"
          @org.create(run_arguments, true)
        when "orgupdate"
          @org.update(run_arguments, true)
        when "orgdelete"
          @org.delete(run_arguments, true)  
          
        when "orgrepodiscover"
          @org.repodiscover(run_arguments, true)
        when "orgcancelrepodiscover"
          @org.cancelrepodiscover(run_arguments, true)
        when "orgdownloaddebugcert"
          @org.downloaddebugcert(run_arguments,true)
        when "orgautoattach"
          @org.autoattachsubs(run_arguments,true)
        when "orglistresources"
          @org.listallresources(run_arguments,true)
          
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
        
