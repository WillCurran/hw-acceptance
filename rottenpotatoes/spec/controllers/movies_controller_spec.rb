require 'rails_helper'
require 'spec_helper'

RSpec.describe MoviesController, type: :controller do
    describe "similar_movie" do
        
        it 'should call Movie model method to find similar movies' do
            fake_movies = [double('Movie'), double('Movie')]
            fake_query_movie = double('Movie', :id => 123, :director => 'Stanley Fakerick')
            fake_query_movie.stub(:has_director).and_return(true)
            Movie.stub(:find).and_return(fake_query_movie)
            Movie.stub(:find_similar_movies).and_return(fake_movies)
            expect(Movie).to receive(:find_similar_movies).with('123', 'Stanley Fakerick') # TODO - should this be a string or int??
            get :similar_movie, {:id => '123'}
        end
        
        it 'should render similar movies view' do
            fake_movies = [double('Movie'), double('Movie')]
            fake_query_movie = double('Movie', :id => 123, :director => 'Stanley Fakerick')
            fake_query_movie.stub(:has_director).and_return(true)
            Movie.stub(:find).and_return(fake_query_movie)
            Movie.stub(:find_similar_movies).and_return(fake_movies)
            get :similar_movie, {:id => '123'}
            expect(response).to render_template('similar_movie')
        end
        
        context 'when we know director' do
            it 'should provide a list of movies' do
                fake_movies = [
                    double('Movie', :id => 1, :director => 'Stanley Fakerick'), 
                    double('Movie', :id => 2, :director => 'Stanley Fakerick')
                    ]
                fake_query_movie = double('Movie', :id => 3, :director => 'Stanley Fakerick')
                fake_query_movie.stub(:has_director).and_return(true)
                Movie.stub(:find).and_return(fake_query_movie)
                Movie.stub(:find_similar_movies).and_return(fake_movies)
                get :similar_movie, {:id => '3'}
                expect(assigns(:movies)).to eq(fake_movies)
            end
        end
        
        context 'when we don\'t know director' do
            it 'should redirect to home page' do
                fake_query_movie = double('Movie', :id => 3, :director => nil) # TODO - '' or nil?
                fake_query_movie.stub(:has_director).and_return(false)
                Movie.stub(:find).and_return(fake_query_movie)
                get :similar_movie, {:id => '123'}
                expect(response).to redirect_to movies_path # TODO - redirect? need to make sure flash is set?
            end
        end
    end
end
