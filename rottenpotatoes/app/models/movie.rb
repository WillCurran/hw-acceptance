class Movie < ActiveRecord::Base
    def self.all_ratings
        %w(G PG PG-13 NC-17 R)
    end
    
    def self.with_ratings ratings
        self.all.where(rating: ratings)
    end
    
    def has_director
        self.director != '' and self.director != nil
    end
        
    def self.find_similar_movies(id, director)
        self.where(director: director).select { |x| x.id != id }
    end
end
