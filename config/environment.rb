# Load the Rails application.
require_relative "application"

# TODO: fix this later, Rails autoloading sucks
require_relative '../app/services/tasks'
require_relative '../app/services/users'
require_relative '../app/services/manager/tasks'
require_relative '../app/services/worker/tasks'
require_relative '../app/authorization'
require_relative '../app/authorization/unauthorized_exception'


# Initialize the Rails application.
Rails.application.initialize!
