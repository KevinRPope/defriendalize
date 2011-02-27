# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Defriend::Application.initialize!

require 'pretty_flash'

ActionController::Base.send(:include, RPH::PrettyFlash::ControllerMethods)
ActionView::Base.send(:include, RPH::PrettyFlash::Display)