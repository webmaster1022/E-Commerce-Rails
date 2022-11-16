# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
   before_action :configure_sign_up_params, only: [:create]
  # before_action :configure_account_update_params, only: [:update]
  
  # GET /resource/sign_up
  def new
    @user = User.new
    @additional = @user.build_additional
    @Shoppingcart = @user.build_shoppingcart
    @cities = City.all
  end

  # POST /resource
  def create
    @user = User.new(user_params)
    if @user.valid?
      createcustomer = CreateCustomer.new
      customer = createcustomer.create_stripe_customer(@user)
      @user.stripe_customer_id = customer.id
      @session = createcustomer.create_checkout_session(customer, @user)
      @user.save!
      redirect_to @session.url
    else
      flash.now[:error] = @user.errors.full_messages
      render :new
    end
  end


  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  # def update
  #   super
  # end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

   protected

  # If you have extra params to permit, append them to the sanitizer.
   def configure_sign_up_params
     devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :email, :password, :role, additional_attributes: [:country, :street, :zip, :phone]])
   end

   def user_params
    params.require(:user).permit(:name, :email, :password, :role, :plan, additional_attributes: [:country, :street, :zip, :phone])
   end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
  # end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
end
