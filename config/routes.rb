Rails.application.routes.draw do
  namespace 'api' do
    namespace 'v1' do 
      resources :users
      post 'sign_in', to: 'users#signIn' 
      post 'sign_out', to: 'users#signOut' 
    end
  end

end
