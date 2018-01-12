Rails.application.routes.draw do
  get 'phonebuzz/index'
  root 'phonebuzz#index'

  post 'phonebuzz/call', to: 'phonebuzz#handle_request'
  post 'phonebuzz/get_all_fizzbuzz', to: 'phonebuzz#get_all_fizzbuzz'
  post 'phonebuzz/dial', to: 'phonebuzz#dial'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
