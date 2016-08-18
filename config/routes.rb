# For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

Rails.application.routes.draw do
  get 'pages/home'
  get 'pages/analysis'
  post 'pages/analysis'
  root 'pages#home'
end
