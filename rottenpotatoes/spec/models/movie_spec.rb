require 'rails_helper'
require 'spec_helper'

RSpec.describe Movie, type: :model do
    describe 'has_director' do
        context 'when director exists' do
            it 'should return true' do
                expect(Movie.new(:director => 'Stanley Fakerick').has_director).
                    to eq(true)
            end
        end
        context 'when director does not exist' do
            it 'should return false' do
                expect(Movie.new(:director => '').has_director).to eq(false)
            end
        end
    end
    describe 'find_similar_movies' do
        it 'should return the correct matches for movies by the same director' do
            seed_movies = [
                    {:id => 1, :director => 'Bobby Jones'}, 
                    {:id => 221, :director => ''},
                    {:id => 31, :director => 'Bobby Jones'},
                    {:id => 2132, :director => 'Brad Bitt'},
                    {:id => 422, :director => 'Stanley Fakerick'},
                    {:id => 1323, :director => 'Stanley Fakerick'},
                    {:id => 234, :director => 'Stanley Fakerick'}
                    ]
            Movie.create(seed_movies)
            expect(
                Movie.find_similar_movies(422, 'Stanley Fakerick').map do |record|
                    record.id
                end.to_set).
                to eq Set[1323, 234]
        end
        
        it 'should not return matches of movies by different directors' do
            seed_movies = [
                    {:id => 1, :director => 'Bobby Jones'}, 
                    {:id => 221, :director => ''},
                    {:id => 31, :director => 'Bobby Jones'},
                    {:id => 2132, :director => 'Brad Bitt'},
                    {:id => 422, :director => 'Stanley Fakerick'},
                    {:id => 1323, :director => 'Stanley Fakerick'},
                    {:id => 234, :director => 'Stanley Fakerick'}
                    ]
            Movie.create(seed_movies)
            Movie.find_similar_movies(422, 'Stanley Fakerick').each do |record|
                expect(record.director).to eq('Stanley Fakerick')
            end
        end
        
        it 'should not return a match for the same movie as the input' do
            fake_movies = [
                    double('Movie', :id => 1, :director => 'Stanley Fakerick'), 
                    double('Movie', :id => 2, :director => 'Stanley Fakerick')
                    ]
            desired_movies = fake_movies.pop
            Movie.stub(:where).and_return(fake_movies)
            expect(Movie.find_similar_movies(2, 'Stanley Fakerick').length).
                to eq(1)
        end
    end
end
