require 'logger'
module ForemanProxmox
	module NicBaseExtensions
		extend ActiveSupport::Concern
		include do
			before_validation :set_validated
			#before_validation :set_mac
			#def set_mac
			#	$LOG = Logger.new("/tmp/mac.log")
			#	self.mac = "aa:bb:cc:dd:ee:ff"
			#	$LOG.error(self.mac)
			#end
		end
		def normalize_mac
		end
	end
end
