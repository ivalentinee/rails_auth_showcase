module Services
  module Tasks
    class << self
      def get(id)
        Task.find(id)
      end
    end
  end
end
