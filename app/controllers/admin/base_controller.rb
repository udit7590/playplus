class Admin::BaseController < ::ApplicationController
  layout 'standard'
  before_action :authenticate_user!
end
