class MainController < ApplicationController

  def index
    flash[:notice] = "Logged in successfully"
    flash[:alert] = "Invaled email or password"
  end

end
