module Api
    module V1
        class UsersService    
            def initialize(id = nil, email = nil, password = nil)
                if id != nil
                    @user = User.find_by(id: id);
                elsif email != nil
                    @email = email
                    @password = password
                    @user = User.find_by(email: @email)
                end
            end
            
            # check if the input is really a user
            def isAuthenticate()
                @user.authenticate(@password)
            end

            # add user id and token 
            def addTokenToCookie(cookies)
                cookies['token'] = SecureRandom.urlsafe_base64()
                cookies['user_id'] = @user.id

            end

            # remove the added cookies
            def deleteCookie(cookies)
                cookies.delete('token')
                cookies.delete('user_id')
                cookies.delete('expires')
            end

            # check if there is a cookie and if the id is that one of the current user  
            def isIdIsCurrentLogIn(id)
                puts id
                @user != nil && @user.id.to_s() == id
            end

            # update the users by the given params
            def updateUser(user_params)
                @user.update(user_params)
                @user
            end
        end
    end
end