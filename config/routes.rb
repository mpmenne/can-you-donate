# frozen_string_literal: true

Rails.application.routes.draw do
  get 'site/home'
  get 'site/start'
  resources 'messages', only: [:create], defaults: { format: 'json' }
  resources 'tokens', only: [:create], defaults: { format: 'json' }
  root to: 'site#home'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
