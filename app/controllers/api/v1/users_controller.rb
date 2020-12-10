module Api
    module V1
        class UsersController < ApplicationController
            def index
                # UserService.new()
                user = User.order('created_at DESC');
                render json: {status: 'Success', data: user}, status: :ok;
            end

            def show                
                begin
                    user = User.find(params[:id]);                
                    render json: {status: 'Success', data: user}, status: :ok;                
                rescue
                    render :status => 404, json: {data: 'error', status: 'Not Found'}
                end
            end

            def create
                begin
                    user = User.create(user_params)
                    render json: {status: 'Success', data: user}, status: :ok;
                rescue
                    render json: {status: 'ERROR', data: user.errors}, status: :unprocessable_entity;
                end                
            end

            def destroy
                user = User.find(params[:id]);
                user.destroy
                render json: {status: 'Success', data: user}, status: :ok;

            end

            def update
                user = User.find(params[:id]);
                if user.update_attributes(user_params)
                    render json: {status: 'Success', data: user}
                else
                    render json: {status: 'ERROR', data: user.errors}, status: :unprocessable_entity;
                end
            end

            def signIn
                render json: {status: 'Success', data: "signIn"}
            end

            def SignOut
                render json: {status: 'Success', data: "signOut"}
            end

            private
            def user_params
                params.permit(:first_name, :last_name, :email, :password)
            end

            def signIn_oarams
                params.permit(:email, :password)
            end
        end
    end
end