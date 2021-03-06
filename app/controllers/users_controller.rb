class UsersController < ApplicationController

  before_action :authenticate_user!, except: [:new, :create]
  before_action :find_user, only: [:edit, :update, :edit_password, :stats, :destroy, :stats]
  before_action :authorize, only: [:index, :stats, :edit, :update, :edit_password]

  load_and_authorize_resource

  def index
    @users = User.order(score: :desc)
    p current_user
    @user = current_user
  end

  def new
    @user = User.new
  end

  def stats
    # aggregate average score
    @scoretotal = User.sum(:score)
    userrecords = User.all
    @totalusers = userrecords.size
    # average attempts per questions
    @attempts = UserDrill.select(:user_id).sum(:attempts).to_f
    @completions = UserDrill.select(:user_id).where(completed: true).size.to_f
    # query total groups
    grouprecords = Group.all
    @totalgroups = grouprecords.size
    #query total drills
    drillrecords = Drill.all
    @totaldrills = drillrecords.size
    #get completed drills
    drillz = UserDrill.where(completed: true).where(user_id: @user.id)
    @completeddrills = Drill.where(:id => drillz).all
    #get completed drills by level
    @bronzedrills = @completeddrills.where(:level => 1).all
    @silverdrills = @completeddrills.where(:level => 2).all
    @golddrills = @completeddrills.where(:level => 3).all
    #get completed groups




  end

  def bookmarks
    # list bookmarks
    bookmark = UserGroup.where(user_id: current_user).pluck(:group_id)
    @groups = Group.find bookmark
  end

  def create
    @user = User.new user_params

    # Generate email validation token now and store in session
    # to prevent malicious generation of email_validations from URI
    token = User.new_token
    @user.email_validation_token = User.hash_token(token)

    p token

    if @user.save
      session[:email_valid_token] = token
      p 'Session token is: ' + session[:email_valid_token]
      redirect_to new_user_validate_email_path(@user)
    else
      render :new
    end
  end

  def edit
  end

  def update
    if current_user.update(user_params)
      redirect_to root_path, notice: 'Account updated!'
    else
      render :edit
    end
  end

  def edit_password
    if @user && @user.authenticate(params[:user][:current_password])
      if params[:user][:current_password] != params[:user][:new_password]
        if params[:user][:new_password] == params[:user][:new_password_confirmation]
          @user.password = params[:user][:new_password]
          @user.save
          redirect_to root_path, notice: "Password Updated!"
        else
          flash[:alert] = "new password must match the new password confirmation"
          render :edit
        end
      else
        flash[:alert] = "New password must be different from the current password"
      end
    else
      flash[:alert] = "Wrong password"
      render :edit
    end
  end

  def destroy
    @user.destroy
    session[:user_id] = nil
    #session[:user_id] = nil unless URI(request.referer).path == '/admin/dashboard'
    redirect_to root_path, notice: 'Account deleted!'
  end

  private

  def user_params
    params.require(:user).permit([:first_name,
                                 :last_name,
                                 :email,
                                 :password,
                                 :password_confirmation,
                                 :is_admin,
                                 :is_validated,
                                 :provider,
                                 :uid,
                                 :oauth_token,
                                 :oauth_secret,
                                 :oauth_raw_data])
  end


  def find_user
    @user = User.find params[:id]
  end

  def authorize
    if current_user.is_validated == false || current_user.valid_email == false
      redirect_to root_path, alert: 'Not authorized!'
    end
  end

  # For password reset
  def self.new_token
    SecureRandom.urlsafe_base64
  end

  # Generates password reset link with unencrypted token before it is digest-ed
  def gen_reset_link(url, token)
    "#{url}/reset_password/#{token}/edit?email=#{self.email}"
  end

  # Use bcrypt to convert unhashed token into digest
  def self.hash_token(token)
    BCrypt::Password.create(token)
  end

end
