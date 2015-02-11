# These are configuration options necessary to make use of the Visma gem.
#
# The default values hash contains:
#   option_key => [ explanation, default_value ]
config = {
  table_name_prefix: ["Visma table prefix", nil],
  employee_chain_number:  ["The Customer number employees are Chain members of", nil],
  time_zone: ["Time zone for Timestamp", "CET"]
}

begin
  VISMA_CONFIG = YAML.load_file('config/visma.yml')
rescue
  File.write 'config/visma.yml', config.collect {|k,v| "# #{v.first}\n#{k}: #{v.last}" }.join("\n")
  raise VismaError, "You must set up the VISMA_CONFIG values in config/visma.yml"
end

config.each do |key,val|
  raise VismaError, "Missing option value \"#{key}\" in config/visma.yml" if VISMA_CONFIG[key.to_s].blank?
end
