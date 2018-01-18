module Patterns
    class << self
        def mobile
            /\A1[0-9]{10}\z/
        end

        def email
            /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
        end
  end
end