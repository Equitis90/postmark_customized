require "griddler"
require "griddler/postmark_customized/version"
require "griddler/postmark_customized/adapter"

module Griddler
  module PostmarkCustomized
  end
end

Griddler.adapter_registry.register(:postmark_customized, Griddler::PostmarkCustomized::Adapter)
