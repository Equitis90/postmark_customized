require "griddler"
require "griddler/postmark_customized/version"
require "griddler/postmark_customized/adapter"

Griddler.adapter_registry.register(:postmark_customized, Griddler::PostmarkCustomized::Adapter)
