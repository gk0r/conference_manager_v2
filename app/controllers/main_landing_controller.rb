class MainLandingController < ApplicationController
  # skip_before_filter :authorise
  
  def index
    respond_to do |format|
      format.html { render 'layouts/_main_landing_page.html.erb' }
    end
  end
  
end # End Class