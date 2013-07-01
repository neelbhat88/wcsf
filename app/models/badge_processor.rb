class BadgeProcessor
	attr_accessor :curr_user
	
	def initialize(user)
		@badgefactory = BadgeFactory.new(user)
		@curr_user = user
	end

	def CheckSemesterAcademics
		return CompareBadges(@badgefactory.GetAcademicsBadges(@curr_user.user_info.current_semester))

	  	# # Call compare and pass in totalGPA
	  	# newbadgecount = 0
	  	# allBadges.each do |b|
	  	# 	# If badge is not minreq then only compare if all minreqs met
	  	# 	badgeEarned = false
	  	# 	Rails.logger.debug("DEBUG: IsMinReq? #{b.isminrequirement}")
	  	# 	if b.isminrequirement == false
	  	# 		if @curr_user.user_info.MetAllMinRequirements()
	  	# 			badgeEarned = b.Compare()
	  	# 			Rails.logger.debug("DEBUG: #{b.title} earned? #{badgeEarned}. All minreqs met.")		
	  	# 		end
	  	# 	else
	  	# 		badgeEarned = b.Compare()	  			
	  	# 		Rails.logger.debug("DEBUG: #{b.title} earned? #{badgeEarned}")
	  	# 	end	  		

	  	# 	userHasBadge = (@curr_user.user_badges.find_by_global_badge_id(b.id) != nil)	  		
	  	# 	# If badge earned and user does not have badge
	  	# 	if badgeEarned == true && userHasBadge == false
	  	# 		newbadgecount += 1

	  	# 		# Save earned badge to db
	  	# 		@curr_user.user_badges.create(:global_badge_id => b.id)
	  	# 	# If badge not earned and user has badge
	  	# 	elsif badgeEarned == false && userHasBadge == true
	  	# 		removedBadge = @curr_user.user_badges.find_by_global_badge_id(b.id)

	  	# 		# Remove earned badge
	  	# 		@curr_user.user_badges.find_by_global_badge_id(b.id).destroy()
	  	# 		Rails.logger.debug("DEBUG: BadgeEarned = false and UserHasBadge = true. UserBadge with GlobalBadgeId: #{b.id} removed.")
	  	# 	end
	  	# end

	  	# # TODO: Return object here of new and removed badges
	  	# return newbadgecount
	end

	def CheckSemesterActivities
		return CompareBadges(@badgefactory.GetActivitiesBadges(@curr_user.user_info.current_semester))
	end

	def CompareBadges(allBadges)
		newbadgecount = 0
	  	allBadges.each do |b|
	  		# If badge is not minreq then only compare if all minreqs met
	  		badgeEarned = false
	  		Rails.logger.debug("DEBUG: IsMinReq? #{b.isminrequirement}")
	  		if b.isminrequirement == false
	  			if @curr_user.user_info.MetAllMinRequirements()
	  				badgeEarned = b.Compare()
	  				Rails.logger.debug("DEBUG: #{b.title} earned? #{badgeEarned}. All minreqs met.")		
	  			end
	  		else
	  			badgeEarned = b.Compare()	  			
	  			Rails.logger.debug("DEBUG: #{b.title} earned? #{badgeEarned}")
	  		end	  		

	  		userHasBadge = (@curr_user.user_badges.find_by_global_badge_id(b.id) != nil)	  		
	  		# If badge earned and user does not have badge
	  		if badgeEarned == true && userHasBadge == false
	  			newbadgecount += 1

	  			# Save earned badge to db
	  			@curr_user.user_badges.create(:global_badge_id => b.id)
	  		# If badge not earned and user has badge
	  		elsif badgeEarned == false && userHasBadge == true
	  			removedBadge = @curr_user.user_badges.find_by_global_badge_id(b.id)

	  			# Remove earned badge
	  			@curr_user.user_badges.find_by_global_badge_id(b.id).destroy()
	  			Rails.logger.debug("DEBUG: BadgeEarned = false and UserHasBadge = true. UserBadge with GlobalBadgeId: #{b.id} removed.")
	  		end
	  	end

	  	# TODO: Return object here of new and removed badges
	  	return newbadgecount
	end
end