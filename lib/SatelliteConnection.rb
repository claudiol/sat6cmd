## Licensed under the Apache License, Version 2.0 (the "License");
## you may not use this file except in compliance with the License.
## You may obtain a copy of the License at
#
## http://www.apache.org/licenses/LICENSE-2.0
##
## Unless required by applicable law or agreed to in writing, software
## distributed under the License is distributed on an "AS IS" BASIS,
##    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
##    See the License for the specific language governing permissions and
##    limitations under the License.
##
######################################################################################
##
## Contact Info: <kenneth.evensen@redhat.com> and <lester@redhat.com>
##
######################################################################################

require 'rest-client'
require 'json'
require 'singleton'

class SatelliteConnection 
  include Singleton

	def initialize
		@method = nil
		@url = nil
		@user = nil
		@password = nil
		@verifyssl = nil
		
	end
end

		
