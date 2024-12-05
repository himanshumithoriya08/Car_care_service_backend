class ApplicationController < ActionController::API
  include JWTSessions::RailsAuthorization
  
  if Rails.env != "development"
    rescue_from ActionController::ParameterMissing, with: :bad_request
    rescue_from ActiveRecord::RecordInvalid, with: :unprocessable_entity
    rescue_from ActiveRecord::RecordNotFound, with: :handle_error
    rescue_from NoMethodError, :with => :handle_error
    rescue_from StandardError, :with => :handle_error
    rescue_from JWTSessions::Errors::Unauthorized, with: :not_authorized
    rescue_from JWTSessions::Errors::ClaimsVerification, with: :forbidden
  end

  def current_person
    begin
      @current_person = User.includes( 
        :role, 
        :user_actions, 
        organization: { 
          plan: [ :module_restrictions ] 
        } 
      ).find(payload['user_id'])

      if @current_person.present? &&  session['user_id'].blank?
        session['user_id'] = @current_person.id 
      end

      @current_person
    rescue
      @current_person = {}
      session['user_id'] = ""
    end
  end

  def authenticate_token_header
    return if request.headers[:Authorization].present?

    return render json: { 
      error: 'Authorization token not present' 
    }, status: :unauthorized
  end

  def not_authorized
    return render json: { error: 'Incorrect username or password.' }, status: :unauthorized
  end

  def forbidden
    return render json: { error: 'Forbidden' }, status: :forbidden
  end

  def handle_error(e)
    return render json: { error: e.to_s }, status: :bad_request
  end
end
