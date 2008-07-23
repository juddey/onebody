# Filters added to this controller will be run for all controllers in the application.
# Likewise, all the methods added will be available for all controllers.
class ApplicationController < ActionController::Base
  include ExceptionNotifiable

  layout 'default.html.erb'
  
  before_filter :get_site
  before_filter :feature_enabled?
  before_filter :authenticate_user, :except => %w(family_email)
  
  private
    def get_site
      if RAILS_ENV == 'setup'
        redirect_to setup_url
        return false
      end
      if Setting.get(:features, :multisite)
        Site.current = Site.find_by_host(request.host)
      else
        Site.current = Site.find(1) or raise 'No Default site found.'
      end
      if Site.current
        update_view_paths
      else
        render :text => 'There is no site configured at this address: ' + request.host
        return false
      end
    end
    
    def update_view_paths
      theme_dirs = [File.join(RAILS_ROOT, 'themes', get_theme_name)]
      if defined? DEPLOY_THEME_DIR
        theme_dirs = [DEPLOY_THEME_DIR] + theme_dirs
      end
      self.view_paths = theme_dirs + ActionController::Base.view_paths
      if defined? PLUGIN_VIEW_PATHS
        PLUGIN_VIEW_PATHS.each { |p| self.append_view_path(p) }
      end
    end
    
    def get_theme_name
      Setting.get(:appearance, :theme)
    end
    
    # used by some anonymous controller actions to see if someone is logged in
    # (without redirecting if they are not)
    def get_user
      if id = session[:logged_in_id]
        Person.logged_in = @logged_in = Person.find_by_id(id)
      end
    end
  
    def authenticate_user
      if id = session[:logged_in_id]
        unless person = Person.find_by_id(id)
          session[:logged_in_id] = nil
          redirect_to new_session_path
          return false
        end
        unless person.can_sign_in?
          session[:logged_in_id] = nil
          redirect_to page_for_public_path('system/bad_status')
          return false
        end
        Person.logged_in = @logged_in = person
        if Site.current.id != @logged_in.site_id
          session[:logged_in_id] = nil
          redirect_to new_session_path
          return false
        end
#        unless @logged_in.email
#          redirect_to edit_account_path
#          return false
#        end
#      elsif session[:family_id] and params[:controller] == 'account' and params[:action] == 'edit'
#        @family = Family.find session[:family_id]
      elsif params[:code]
        unless Person.logged_in = @logged_in = Person.find_by_feed_code(params[:code])
          render :text => 'Invalid code.', :status => 500
          return false
        end
      else
        redirect_to new_session_path(:from => request.request_uri)
        return false
      end
    end
    
    def render_message(message)
      respond_to do |wants|
        wants.js { render(:update) { |p| p.alert message } }
        wants.html { render :text => message, :layout => true }
      end
    end
    
    def rescue_action_with_page_detection(exception)
      get_site
      path, args = request.request_uri.downcase.split('?')
      if exception.is_a?(ActionController::RoutingError) and @page = Page.find_by_path(path)
        redirect_to '/pages/' + @page.path + (args ? "?#{args}" : '')
      else
        rescue_action_without_page_detection(exception)
      end
    end
    alias_method_chain :rescue_action, :page_detection
    
    def me?
      @logged_in and @person and @logged_in == @person
    end
    
    def redirect_back(fallback=nil)
      if params[:from]
        redirect_to(params[:from])
      elsif request.env["HTTP_REFERER"]
        redirect_to(request.env["HTTP_REFERER"])
      elsif fallback
        redirect_to(fallback)
      else
        redirect_to(people_path)
      end
      return false # in case you want to halt action
    end
    
    def params_without_action
      params.clone.delete_if { |k, v| %w(controller action).include? k }
    end
    
    def add_errors_to_flash(record)
      flash[:warning] = record.errors.full_messages.join('; ')
    end
        
    def decimal_in_words(number)
      if number % 1 == 0.0
        "exactly #{number}"
      elsif number % 1 < 0.5
        "more than #{number.to_i}"
      elsif number % 1 >= 0.5
        "less than #{number.to_i + 1}"
      end
    end
    
    # stolen from ActionView::Helpers::NumberHelper
    def number_to_phone(number, options = {})
      options   = options.stringify_keys
      area_code = options.delete("area_code") { false }
      delimiter = options.delete("delimiter") { "-" }
      extension = options.delete("extension") { "" }
      begin
        str = area_code == true ? number.to_s.gsub(/([0-9]{3})([0-9]{3})([0-9]{4})/,"(\\1) \\2#{delimiter}\\3") : number.to_s.gsub(/([0-9]{3})([0-9]{3})([0-9]{4})/,"\\1#{delimiter}\\2#{delimiter}\\3")
        extension.to_s.strip.empty? ? str : "#{str} x #{extension.to_s.strip}"
      rescue
        number
      end
    end
    
    def only_admins
      unless @logged_in.admin?
        render :text => 'You must be an administrator to use this section.', :layout => true, :status => 401
        return false
      end
    end
    
    def feature_enabled?
      true
    end
end
