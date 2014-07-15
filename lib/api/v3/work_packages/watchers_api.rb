module API
  module V3
    module WorkPackages
      class WatchersAPI < Grape::API

        resources :watchers do
          params do
            requires :user_id, desc: 'Id of the user watching the work package'
          end

          before do
            @user = User.find params[:user_id]
          end

          post do
            authorize(:add_work_package_watchers, context: @work_package.project)

            if @work_package.watcher_users.include?(@user)
              status 200
            else
              watcher = Watcher.new(user: @user, watchable: @work_package)

              if watcher.valid?
                @work_package.watchers << watcher
              else
                raise ::API::Errors::Validation.new(watcher)
              end
            end

            model = ::API::V3::Users::UserModel.new(@user)
            @representer = ::API::V3::Users::UserRepresenter.new(model).to_json
          end

        end
      end
    end
  end
end
