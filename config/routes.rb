RoadtripService::Application.routes.draw do
  resources :trips, only: [:create, :index]
end
