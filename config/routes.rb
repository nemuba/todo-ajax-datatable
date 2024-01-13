# frozen_string_literal: true

require 'sidekiq/web'

Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiq'
  mount ActionCable.server => '/cable'

  resources :todos do
    delete 'delete_all', on: :collection
    post 'import', on: :collection
    get 'clone', on: :member
  end

  root 'todos#index'
end
