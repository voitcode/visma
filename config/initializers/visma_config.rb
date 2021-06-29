# These are configuration options necessary to make use of the Visma gem.
#
# The default values hash contains:
#   option_key => [ explanation, default_value ]
config = {
  table_name_prefix: ["Visma table prefix", nil],
  employee_chain_number:  ["The Customer number employees are Chain members of", nil],
  factoring_customer_profile_number: ["The CustomerProfileNo used for factoring", nil],
  factoring_form_profile_number: ["The FormProfileNo used for factoring", nil],
  factoring_remittance_profile_number: ["The RemittanceProfileNo used for factoring", nil]
}

begin
  VISMA_CONFIG = YAML.load_file('config/visma.yml')
rescue
  File.write 'config/visma.yml', config.collect {|k,v| "# #{v.first}\n#{k}: #{v.last}" }.join("\n")
  raise Visma::Error, "You must set up the VISMA_CONFIG values in config/visma.yml"
end

missing = config.collect {|key, val| key if VISMA_CONFIG[key.to_s].blank? }.compact

unless missing.empty?
  raise Visma::Error, "\nYou need to set a value for options #{missing.join("\n\t")}\n in config/visma.yml"
end
