class StaticPagesController < ApplicationController
  def home
  end

  def donors
  	@donors = Donor.all
  end

  def profile
  end

  def summary
  end
end
