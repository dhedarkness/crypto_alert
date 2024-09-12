class AlertsController < ApplicationController
  skip_before_action :verify_authenticity_token
  
  # USER_ALERTS_CACHE_KEY="alerts_user_#{@user.id}_status_#{params[:status]}"
  # before_action :authenticate_user!
  before_action :authenticate_user_name

  def create
    puts 'jjjjjjjjjjjjjjjjjccccccccccc', alert_params, 'apppppppppppppppppppppp'
    
    if @user
      puts 'ahhhhhhhhhhhh', alert_params, 'hhhhhhaaaaaaaaaaaaaaaa'
      @alert = Alert.new(alert_params.merge(status: :created, user: @user))
    else
      if params[:user_name].blank? || params[:email].blank?
        puts alert_params, 'whattttttttteevvvvvvvvvvvverrrr'
        return render json: { success: false, message: 'please provide user_name and email parameter for new user'}
      end
      puts 'owmsya'
      @user = User.create!(name: params[:user_name], email: params[:email])
      @alert = Alert.new(alert_params.merge(status: :created, user: @user))
    end
    if @alert.save
      puts 'wowzaa'
      Rails.cache.delete("alerts_user_#{@user.id}_status_#{@alert.status}")
      Rails.cache.delete("alerts_user_#{@user.id}_status_")
      render json: @alert, status: :created
    else
      puts 'zowma'
      render json: @alert.errors, status: :unprocessable_entity
    end
  # rescue => 
  end

  def index
    unless @user
      render json: {success: false, message: 'User not found'}
    end
    # Cache based on user id and status, status can be nil
    cache_key = "alerts_user_#{@user.id}_status_#{params[:status]}"
    
    #if fails hit postgres
    alerts = Rails.cache.fetch(cache_key, expires_in: 24.hours) do
      unless params[:status].blank?
        puts 'hsd'
        @alerts = @user.alerts.where(status: params[:status].to_sym)
      else
        puts 'hsr'
        @alerts = @user.alerts
      end
      puts @alerts, '@alertttttttttsssssssssssssssszzzzzzzzzzzzzz'
      @alerts.select(:name, :status, :target_price)
    end
    paginated_alerts = alerts.page(params[:page]).per(params[:per_page] || 20)
    puts 'jjjjjjjjjjaaaaaaaaaaaaaaa', params, 'aaaaaaaaaaaajjjjjjjjjjjjjjj'
    render json: {
      alerts: paginated_alerts, 
      current_page: paginated_alerts.current_page,
      total_pages: paginated_alerts.total_pages,
      total_count: paginated_alerts.total_count
    }
  end

  def destroy
    @alert = Alert.find_by(id: params[:id], user: @user)
  
    if @alert
      Rails.cache.delete("alerts_user_#{@user.id}_status_")
      Rails.cache.delete("alerts_user_#{@user.id}_status_#{@alert.status}")
      @alert.destroy
      render json: { message: 'Alert deleted successfully' }, status: :ok
    else
      render json: { error: 'Alert not found' }, status: :not_found
    end
  end
  
  def delete_by_name
    unless @user
      return render json: { success: false, message: 'please provide user_name param'}
    end
    @alert = @user.alerts.find_by(name: params[:name])
    if @alert
      @alert.update(status: :deleted)
      Rails.cache.delete("alerts_user_#{@user.id}_status_deleted")
      Rails.cache.delete("alerts_user_#{@user.id}_status_")
      render json: {success: true, message: 'Alert delete successful'}
    else
      render json: {success: false, message: 'Alert not found'}
    end
  end

  private

  def alert_params
    params.permit(:name, :cryptocurrency, :target_price)
  end

  def authenticate_user_name
    puts params, 'prrrrrrrrrrrrrrrrrrrrrrrrppp'
    @user = User.find_by(name: params[:user_name])
  end
end
