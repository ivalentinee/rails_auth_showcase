# frozen_string_literal: true

module Policies
  class ApplicationPolicy
    attr_reader :user, :object

    def initialize(user, object)
      @user = user
      @object = object
    end
  end
end
