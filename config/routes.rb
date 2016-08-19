# For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

Rails.application.routes.draw do
  get 'home' => 'pages#home'
  get 'analysis' => 'pages#analysis'
  post 'analysis' => 'pages#analysis'
  root 'pages#home'
end
