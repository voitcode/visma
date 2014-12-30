begin
  VISMA_CONFIG = YAML.load_file('config/visma.yml')
rescue
  File.write 'config/visma.yml', "# Visma table prefix\ntable_name_prefix: \nemployee_chain_number: "
  raise VismaError, "You must configure the \"table_name_prefix:\" option in config/visma.yml"
end

raise VismaError, "Missing option value \"table_name_prefix\" in config/visma.yml" if VISMA_CONFIG["table_name_prefix"].blank?
raise VismaError, "Missing option value \"employee_chain_number\" in config/visma.yml" if VISMA_CONFIG["employee_chain_number"].blank?
