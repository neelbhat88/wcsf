class AcademicsController < ApplicationController
  before_filter :authenticate_user!

  def index
  end

  def saveClasses
  	totalGpa = params[:totalGPA]

  	# Load all Academics-GPA badges
  	allBadges = GlobalBadge.where("category = 'Academics' and subcategory = 1 and semester = ?", current_user.current_semester)

  	# Call compare and pass in totalGPA
  	@newbadgecount = 0
  	allBadges.each do |b|
  		if b.Compare(totalGpa) == true
  			@newbadgecount += 1
  		end
  	end

  	# Return new badges received
  	respond_to do |format|
  		format.js
	end
  end
end
