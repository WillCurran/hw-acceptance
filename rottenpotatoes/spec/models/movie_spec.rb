require 'rails_helper'
require 'spec_helper'

RSpec.describe Movie, type: :model do
    describe 'all_ratings' do
        it 'should return a list of ratings' do
            expect(Movie.all_ratings).to eq(%w(G PG PG-13 NC-17 R))
        end
    end
    
    describe 'with_ratings' do
        it 'should return only the movies that are of the same ratings' do
            seed_movies = [
                    {:id => 1, :rating => 'G'}, 
                    {:id => 221, :rating => 'N/A'},
                    {:id => 31, :rating => 'G'},
                    {:id => 2132, :rating => 'PG'},
                    {:id => 422, :rating => 'R'},
                    {:id => 1323, :rating => 'NC-17'},
                    {:id => 234, :rating => 'PG'}
                    ]
            g_movies = Set[1, 31]
            pg_movies = Set[2132, 234]
            r_movies = Set[422]
            Movie.create(seed_movies)
            expect(
                Movie.with_ratings(['PG']).map do |record|
                    record.id
                end.to_set).
                to eq pg_movies
            expect(
                Movie.with_ratings(['G', 'PG']).map do |record|
                    record.id
                end.to_set).
                to eq(g_movies | pg_movies)
            expect(
                Movie.with_ratings(['G', 'PG', 'R']).map do |record|
                    record.id
                end.to_set).
                to eq(g_movies | pg_movies | r_movies)
        end
    end
    
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
