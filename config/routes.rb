# frozen_string_literal: true

Rails.application.routes.draw do
  resources :todos do
    delete 'delete_all', on: :collection
  end

  get 'home/welcome'
end
