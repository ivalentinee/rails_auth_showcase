# Load the Rails application.
require_relative "application"

# TODO: fix this later, Rails autoloading sucks
require_relative '../app/services/manager/tasks'
require_relative '../app/services/worker/tasks'


# Initialize the Rails application.
Rails.application.initialize!
