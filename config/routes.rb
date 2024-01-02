# frozen_string_literal: true

Rails.application.routes.draw do
  mount ActionCable.server => '/cable'

  resources :todos do
    delete 'delete_all', on: :collection
    post 'import', on: :collection
  end

  get 'home/welcome'
end
