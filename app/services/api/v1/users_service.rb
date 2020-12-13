module Api
    module V1
        class UsersService    
            def initialize(token = nil, email = nil)
                if token != nil
                    @user = User.find_by(token: token);
                elsif email != nil
                    @user = User.find_by(email: email)
                end
            end
            
            # check if the input is really a user
            def is_authenticate(password)
                @user.authenticate(password)
            end

            # add user id and token 
            def add_token_to_cookie(cookies)
                token = SecureRandom.urlsafe_base64()
                @user.update(token: token)
                cookies['token'] = token
                create_return_object()
            end

            # remove the cookies and the token
            def delete_cookie(cookies)
                cookies.delete('token')
                @user.update(token: '')
            end

            # check if there is a cookie and if the id is that one of the current user  
            def check_current_user(id, token)
                @user != nil && @user.token.to_s() == token && @user.id.to_s() == id
            end

            # update the users by the given params
            def update_user(user_params)
                @user.update(user_params)
                create_return_object()
            end

            def create_return_object()
               wanted_att = @user.as_json
               wanted_att.delete('token')
               wanted_att
            end
        end
    end
end