Rails.application.routes.draw do
  resources :contacts, defaults: { format: 'json' }, constraints: { format: 'json' } do
    resources :activities, only: [:create, :show, :update, :destroy]
  end
end
