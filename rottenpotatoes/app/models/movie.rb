class Movie < ActiveRecord::Base
    def has_director
        return self.director != nil
    end
        
    def Movie.find_similar_movies(id, director)
        # all movies where director= (use where)
    end
end
