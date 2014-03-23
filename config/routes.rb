RoadtripService::Application.routes.draw do
  resources :trips, only: [:create]
end
