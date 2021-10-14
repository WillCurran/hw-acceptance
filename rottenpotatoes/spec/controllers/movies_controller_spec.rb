require 'rails_helper'
require 'spec_helper'

RSpec.describe MoviesController, type: :controller do
    describe "similar_movie" do
        
        it 'should call Movie model method to find similar movies' do
            fake_movies = [double('Movie'), double('Movie')]
            @movie.stub(:director).and_return('Stanley Fakerick')
            Movie.stub(:find_similar_movies).and_return(fake_movies)
            expect(Movie).to receive(:find_similar_movies).with("123") # TODO - should this be a string or int??
            get :similar_movie, {:id => "123"}
        end
        
        it 'should render similar movies view' do
            fake_movies = [double('Movie'), double('Movie')]
            @movie.stub(:director).and_return('Stanley Fakerick')
            Movie.stub(:find_similar_movies).and_return(fake_movies)
            get :similar_movie, {:id => "123"}
            expect(response).to render_template('similar')
        end
        
        it 'should provide a list of movies if we know director' do
            fake_movies = [
                double('Movie', :id => 1, :director => 'Stanley Fakerick'), 
                double('Movie', :id => 2, :director => 'Stanley Fakerick'),
                ]
            Movie.stub(:find).and_return(double('Movie'))
            @movie.stub(:director).and_return('Stanley Fakerick')
            Movie.stub(:find_similar_movies).and_return(fake_movies)
            get :similar_movie, {:id => "3"}
            expect(@movies).to eq(fake_movies)
        end
        
        it 'should redirect to home page if we don\'t know director' do
            @movie.stub(:director).and_return(nil) # TODO - or empty string?
            Movie.stub(:find_similar_movies).and_return(nil)
            get :similar_movie, {:id => "123"}
            expect(response).to render_template('movies')
        end
    end
end
