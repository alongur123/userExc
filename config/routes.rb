Rails.application.routes.draw do
  namespace 'api' do
    namespace 'v1' do 
      resources :users
      post 'sign_in', to: 'users#sign_in' 
      post 'sign_out', to: 'users#sign_out' 
    end
  end

end
