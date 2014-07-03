RoadtripService::Application.routes.draw do
  resources :beacons, only: [:create, :index]
end
