# frozen_string_literal: true

module Admin
  class UsersController < ApplicationController
    before_action :require_authentication
    before_action :set_user!, only: %i[edit update destroy]

    def index
      respond_to do |format|
        format.html do
          @pagy, @users = pagy User.order(created_at: :desc)
        end

        format.zip { respond_with_zipped_users }
      end
    end

    def create
      if params[:archive].present?
        UserBulkService.call paramas[:archive]
        flash[:success] = 'User imported!'
      end

      redirect_to admin_users_path
    end

    def edit

    end

    def update
      if @user.update(user_params)
        flash[:success] = t 'users.update.success'
        redirect_to admin_users_path
      else
        render :edit
      end
    end

    def destroy
      @user.destroy
      flash[:success] = t 'users.destroy.success'
      redirect_to admin_users_path
    end

    private

    def respond_with_zipped_users
      compressed_filestream = Zip::OutputStream.write_buffer do |zos|
        User.order(created_at: :desc).each do |user|
          zos.put_next_entry "user_#{user.id}.xlsx"
          zos.print render_to_string(
            layout: false, handlers: [:axlsx], formats: [:xlsx],
            template: 'admin/users/user',
            locals: { user: user }
          )
        end
      end

      compressed_filestream.rewind
      send_data compressed_filestream.read, filename: 'users.zip'
    end

    def set_user!
      @user = User.find params[:id]
    end

    def user_params
      params.require(:user).permit(:email, :name, :password, :password_confirmation, :role).merge(admin_edit: true)
    end
  end
end

