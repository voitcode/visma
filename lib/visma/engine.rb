module Visma
  class Engine < ::Rails::Engine
    config.autoload_paths << "#{config.root}/lib"
    isolate_namespace Visma
  end
end
