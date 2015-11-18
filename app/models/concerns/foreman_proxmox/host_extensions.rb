require 'logger'
module ForemanProxmox
  module HostExtensions
    extend ActiveSupport::Concern
	
    included do
      #execute callbacks	
    end
    
    
    

    # create or overwrite instance methods...
    def destroy
        vm = Virtualmachine.where("host_id = #{self.id}").first
        vm.delete_virtualmachine
        super
    end
    
    def create
		$LOG = Logger.new("/tmp/maccie.log")
		$LOG.error("Start mac #{self.mac} + start ip: #{self.ip}")
		ip =  self.ip.split(".") 
		mac = "09:0e:06:12:#{ip[2]}:#{ip[3]}"
		$LOG.error("#{mac}")
		self.mac = mac
		self.primary_interface.mac = mac
		self.provision_interface.mac = mac
		self.primary_interface.save
		$LOG.error(self.primary_interface.errors.full_messages)
		$LOG.error("#{self.mac} + #{self.primary_interface.mac}")
		super
		
		new_vm = Virtualmachine.new
		
        new_vm.sockets = self.params['sockets']
        new_vm.cores = self.params['cores']
        new_vm.memory = self.params['memory']
        new_vm.size = self.params['size']
        if self.params['vmid'] == nil then
			new_vm.get_free_vmid
		else
          new_vm.vmid = self.params['vmid']
        end
        new_vm.mac = self.mac
        new_vm.host_id = self.id
        new_vm.save
        
        new_vm.create_harddisk
        new_vm.create_virtualmachine
        new_vm.start
        
    end
    
    
    


    module ClassMethods
      # create or overwrite class methods...
      
    end
  end
end
