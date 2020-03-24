class Users::BaseController < ApplicationController
  # TODO: Move it to a user's base controller as login is not compulsory for our site.
  before_action :authenticate_user!
end
