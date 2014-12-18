# Shorthand access to Visma CompanyInformation data
class Visma::Info
  class << self
    def info
      @@visma_company_information ||= Visma::CompanyInformation.first
    end

    def method_missing(meth, *args, &block)
      info.send(meth, *args, &block)
    end
  end
end
