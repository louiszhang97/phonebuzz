Rails.application.routes.draw do
  get 'phonebuzz/index'
  root 'phonebuzz#index'

  post 'phonebuzz/call', to: 'phonebuzz#handle_incoming_call'
  post 'phonebuzz/get_all_fizzbuzz', to: 'phonebuzz#get_all_fizzbuzz'
  post 'phonebuzz/dial', to: 'phonebuzz#dial'
  post 'phonebuzz/connect_outgoing_call', to: 'phonebuzz#connect_outgoing_call'
  post 'phonebuzz/replay', to: 'phonebuzz#replay'

  post 'log_entry/replay/:id', to: 'log_entry#replay'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
