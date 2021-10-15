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
            get :similar_movie, {:id => 123}
        end
        
        it 'should render similar movies view' do
            fake_movies = [double('Movie'), double('Movie')]
            fake_query_movie = double('Movie', :id => 123, :director => 'Stanley Fakerick')
            fake_query_movie.stub(:has_director).and_return(true)
            Movie.stub(:find).and_return(fake_query_movie)
            Movie.stub(:find_similar_movies).and_return(fake_movies)
            get :similar_movie, {:id => 123}
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
                get :similar_movie, {:id => 3}
                expect(assigns(:movies)).to eq(fake_movies)
            end
        end
        
        context 'when we don\'t know director' do
            it 'should redirect to home page' do
                fake_query_movie = double('Movie', 
                    :title => 'fake_movie', :id => 3, :director => '')
                fake_query_movie.stub(:has_director).and_return(false)
                Movie.stub(:find).and_return(fake_query_movie)
                get :similar_movie, {:id => 123}
                expect(response).to redirect_to movies_path
            end
        end
    end
    
    describe 'GET index' do
        it 'should render index.html' do
            Movie.stub(:all_ratings).and_return(%w(G PG PG-13 NC-17 R))
            Movie.stub(:with_ratings).and_return([double('Movie'), double('Movie')])
            Movie.stub(:order).and_return([double('Movie'), double('Movie')])
            get :index, {:ratings => nil, :active_col => nil}
            expect(response).to render_template('index')
        end
        it 'should provide a list of movies' do
            Movie.stub(:all_ratings).and_return(%w(G PG PG-13 NC-17 R))
            Movie.stub(:with_ratings).and_return([double('Movie'), double('Movie')])
            Movie.stub(:order).and_return([double('Movie'), double('Movie')])
            get :index, {:ratings => nil, :active_col => nil}
            expect(assigns(:movies).length).to eq(2)
        end
        context 'when active column is nil' do
            it 'should make title and release date have normal formatting' do
                Movie.stub(:all_ratings).and_return(%w(G PG PG-13 NC-17 R))
                Movie.stub(:with_ratings).and_return([double('Movie'), double('Movie')])
                Movie.stub(:order).and_return([double('Movie'), double('Movie')])
                get :index, {:ratings => nil, :active_col => nil}
                expect(assigns(:title_style)).to eq('')
                expect(assigns(:release_style)).to eq('')
            end
        end
        context 'when active column is title' do
            it 'should make title highlighted and release date normal format' do
                Movie.stub(:all_ratings).and_return(%w(G PG PG-13 NC-17 R))
                Movie.stub(:with_ratings).and_return([double('Movie'), double('Movie')])
                Movie.stub(:order).and_return([double('Movie'), double('Movie')])
                get :index, {:ratings => nil, :active_col => 'title'}
                expect(assigns(:title_style)).to eq('hilite bg-warning')
                expect(assigns(:release_style)).to eq('')
            end
        end
        context 'when active column is title' do
            it 'should make title highlighted and release date normal format' do
                Movie.stub(:all_ratings).and_return(%w(G PG PG-13 NC-17 R))
                Movie.stub(:with_ratings).and_return([double('Movie'), double('Movie')])
                Movie.stub(:order).and_return([double('Movie'), double('Movie')])
                get :index, {:ratings => nil, :active_col => 'release_date'}
                expect(assigns(:title_style)).to eq('')
                expect(assigns(:release_style)).to eq('hilite bg-warning')
            end
        end
    end
end
