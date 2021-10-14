class Movie < ActiveRecord::Base
    def has_director
        self.director != nil
    end
        
    def Movie.find_similar_movies(id, director)
        Movie.where(director: director).select { |x| x.id != id }
    end
end
