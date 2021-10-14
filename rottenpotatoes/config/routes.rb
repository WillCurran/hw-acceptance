Rottenpotatoes::Application.routes.draw do
  resources :movies
  # map '/' to be a redirect to '/movies'
  root :to => redirect('/movies')
  # details is same as 'show'
  get '/movies/:id', to: 'movies#show', as: 'details_movie'
  # match 'similar_movie', to: 'movies#similar_movie', via: :all
  match 'similar_movie/:id', to: 'movies#similar_movie', via: :all, as: 'similar_movie'
end
