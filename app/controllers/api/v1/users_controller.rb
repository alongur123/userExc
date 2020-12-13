module Api
    module V1
        class UsersController < ApplicationController
            include ActionController::Cookies

						before_action :set_user
						before_action :is_authenticate, only:[:show,:index, :update]

            def index
                user = User.order(created_at: :desc);
                render json: {status: 'Success', data: user};
            end

            def show               
							user = User.find_by(id: params.fetch(:id)); 
							if user != nil
								render json: {status: 'Success', data: user}, status: :ok;                
							else
								render json: {data: 'error', status: 'Not Found'}
							end
            end

            def create
                user = User.create(user_params)
                if user.errors.inspect
                    render json: {status: 500, data: user.errors};
                else
                    render json: {status: 200, data: user};
                end                
            end

            def destroy
                user = User.find_by(id: params.fetch(:id));
                user.destroy
                render json: {status: 'Success', data: user};
            end

            def update
                
                # Check if user is login
                if UsersService.check_current_user(update_param.fetch('id', nil), cookies.fetch('token', nil))
                    user = UsersService.update_user(user_params)
                    if user
                        render json: {status: 'Success', data: user}
                    else
                        render json: {status: 'ERROR', data: 'error in update user'};
                    end
                else
                    render json: {status: :unauthorized, data: 'user is not log in'};
                end
            end

            def sign_in
                if !UsersService.is_loged_in()

                    # sign in and create cookies if authenticate
                    UsersService.initialize(nil, sign_in_params.fetch(:email, nil))              
                    if UsersService.is_authenticate(sign_in_params.fetch(:password, nil))
                        user = UsersService.add_token_to_cookie(cookies)
                        render json: {status: 'Success', data: user}
                    else
                        render json: {status: :unauthorized, data: "email or password incorrect"}
                    end
                else
                    render json: {status: 'Success', data: "already signed in"}
                end
            end

            def sign_out
                # check if we signed in 
                if UsersService.is_loged_in()

                    # remove the cookies
                    UsersService.delete_cookie(cookies)
                    render json: {status: 'Success', data: "signed out"}
                else 
                    render json: {status: 'Success', data: "there is no user signed in"} 
                end
            end

            def set_user
                token = cookies.fetch('token', nil)
                if token
									UsersService.initialize(token)
                end
						end
						
						def is_authenticate
							if !UsersService.is_loged_in()
							  render json: {status: :unauthorized, data: 'user is not log in'};
							end
						end

            private
            def user_params
                params.permit(:first_name, :last_name, :email, :password)
            end

            def sign_in_params
                params.permit(:email, :password)
            end

            def update_param
                params.permit(:id)
            end
        end
    end
end