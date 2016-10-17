class Movie < ActiveRecord::Base
    
    def self.ratings
      self.select(:rating).map(&:rating).uniq.sort
    end
    
end
