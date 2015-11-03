module ForemanProxmox
  module HostExtensions
    extend ActiveSupport::Concern

    included do
      # execute callbacks
    end

    # create or overwrite instance methods...
    def instance_method_name
    end

    module ClassMethods
      # create or overwrite class methods...
      def delete
        vm = Virtualmachine.where("host_id = '#{params[:id]}'")
        vm.delete_virtualmachine
        super
      end
    end
  end
end
