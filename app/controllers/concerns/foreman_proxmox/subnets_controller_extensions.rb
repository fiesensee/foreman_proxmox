require 'logger'
module ForemanProxmox
  class SubnetsControllerExtensions < ::SubnetsController
    
    def freeip
    $LOG = Logger.new("/tmp/mac.log")
    invalid_request and return unless (s=params[:subnet_id].to_i) > 0
    organization = params[:organization_id].blank? ? nil : Organization.find(params[:organization_id])
    location = params[:location_id].blank? ? nil : Location.find(params[:location_id])
    Taxonomy.as_taxonomy organization, location do
      not_found and return unless (subnet = Subnet.authorized(:view_subnets).find(s))
      if (ip = subnet.unused_ip(params[:host_mac], params[:taken_ips]))
		ip_array = ip.split(".")
		$LOG.error("Before mac")
		mac = "00:50:#{ip_array[0].to_i.to_s(16)}:#{ip_array[1].to_i.to_s(16)}:#{ip_array[2].to_i.to_s(16)}:#{ip_array[3].to_i.to_s(16)}"
		$LOG.error("MAC: #{mac}")
        render :json => {:ip => ip, :mac => mac}
      else
        not_found
      end
    end
    rescue => e
    logger.warn "Failed to query subnet #{s} for free ip: #{e}"
    process_ajax_error(e, "get free ip")
    end
    
  end
end
