module Services
  module Users
    class << self
      def get(id)
        User.find(id)
      end
    end
  end
end
