require 'rails_helper'
require 'spec_helper'

RSpec.describe Movie, type: :model do
  describe 'find_similar_movies' do
      
    it 'should return the correct matches for movies by the same director' do
        
    end
    
    it 'should not return matches of movies by different directors' do
        
    end
    
    it 'should not return a match for the same movie as the input' do
        Movie.stub(:find_similar_movies).and_return(fake_movies)
    end
  end
end
