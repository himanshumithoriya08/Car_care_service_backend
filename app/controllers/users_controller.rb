class UsersController < ApplicationController
	before_action :authorize_access_request!

	before_action :set_user, only: [:show, :update, :destroy]

	def create
		user = User.new(users_params)
		if user.save
			render json: {user: user}, status: 201
		else
			render json: {error: "error"}, status: 422
		end
	end

	def index
		users = User.all
		render json: {users: users}, status: 200
	end

	def show
		render json: { user: @user }, status: 200
	end

	def update
		if @user.update(users_params)
			render json: { message: "Updated successfully" }, status: 200
		else
			render json: { error: error }, status: 422
		end
	end

	def destroy
		@user.destroy
		render json: { message: "User has been deleted successfully" }, status: 200
	end

	private

	def set_user
		@user = User.find_by(id: params[:id])
	end

	def users_params
		params.require(:users).permit(:name, :email, :password, :confirm_password)
	end
end
