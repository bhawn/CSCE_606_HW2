class Movie < ActiveRecord::Base
    def self.with_ratings(ratings)
        self.where(rating: ratings)
    end
    
    def self.get_ratings
    #   puts self.select(:rating).distinct.all
    #   self.select(:rating).distinct.pluck(:rating)
        self.order(:rating).uniq.pluck(:rating)
    end
    
end