Lutownica::Application.routes.draw do
  root to: 'events#index'
  get '*scopes' => 'events#index', as: 'events', scopes: {}
end
