module Api
    module V1
        class UsersController < ApplicationController
            include ActionController::Cookies

            before_action :set_user
            def index
                user = User.order('created_at DESC');
                render json: {status: 'Success', data: user}, status: :ok;
            end

            def show                
                begin
                    user = User.find(params.fetch(:id));                
                    render json: {status: 'Success', data: user}, status: :ok;                
                rescue
                    render :status => 404, json: {data: 'error', status: 'Not Found'}
                end
            end

            def create
                begin
                    user = User.create(user_params)
                    render json: {status: 200, data: user}, status: :ok;
                rescue
                    render json: {status: 500, data: user.errors}, status: :unprocessable_entity;
                end                
            end

            def destroy
                user = User.find(params.fetch(:id));
                user.destroy
                render json: {status: 'Success', data: user}, status: :ok;

            end

            def update
                
                # Check if user is login
                if @service && @service.isIdIsCurrentLogIn(update_param.fetch('id'))
                    user = @service.updateUser(user_params)
                    if user
                        render json: {status: 'Success', data: user}
                    else
                        render json: {status: 'ERROR', data: 'error in update user'}, status: :unprocessable_entity;
                    end
                else
                    render json: {status: 'ERROR', data: 'user is not log in'}, status: :unauthorized;
                end
            end

            def signIn

                # sign in and create cookies if authenticate
                @service = UsersService.new(nil, signIn_params.fetch(:email, nil), signIn_params.fetch(:password, nil))              
                if @service.isAuthenticate()
                    @service.addTokenToCookie(cookies)
                    puts cookies
                    render json: {status: 'Success', data: "signIn"}
                else
                    render json: {status: 'ERROR', data: "email or password incorrect"}, status: :unauthorized;
                end
            end

            def signOut
                # check if we signed in 
                if @service != nil

                    # remove the cookies
                    @service.deleteCookie(cookies)
                    puts cookies
                end
                render json: {status: 'Success', data: "signOut"}
            end

            def set_user
                @user_id = cookies.fetch('user_id', nil)
                if @user_id
                    @service = UsersService.new(@user_id)
                end
            end

            private
            def user_params
                params.permit(:first_name, :last_name, :email, :password)
            end

            def signIn_params
                params.permit(:email, :password)
            end

            def update_param
                params.permit(:id)
            end
        end
    end
end