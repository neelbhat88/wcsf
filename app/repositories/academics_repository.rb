class AcademicsRepository
	attr_accessor :user

	def initialize(user)
		self.user = user
	end

	def GetUserClassesBySemester(semester)
		return self.user.user_classes.where('semester = ?', semester)	
	end

	def GetSemesterGpa(semester)
		gpas = self.user.user_semester_gpas.where(:semester => semester)

		# There should only be one GPA for a user per semester
		if gpas.length > 1
			Rails.logger.error("UserId #{self.user.id} has multiple gpas for semester #{semester}")
		end

		# Just return the first gpa
		return '%.2f' % (gpas.first.gpa)
	end

	def SaveTotalSemesterGpa(semester)
	    semester_classes = self.user.user_classes.where(:semester => semester)
	    numclasses = semester_classes.length
	    credithourtotal = 0.00
	    classeswithgrade = 0
	    totalGpa = 0.00

	    semester_classes.each do |c|
	      unless c.grade.nil?
	        totalGpa += (c.gpa * c.school_class.credit_hours)
	        credithourtotal += c.school_class.credit_hours
	        classeswithgrade += 1
	      end
	    end
	    
	    semester_gpa = 0.00
	    if semester_classes.length > 0
		    # '%.2f' % forces 2 decimal places
			semester_gpa = '%.2f' % ((totalGpa / credithourtotal).round(2))
		end

	    # Save Semester gpa
	    user_semester_gpa = self.user.user_semester_gpas.where(:semester => semester)
	    if (user_semester_gpa.length > 1)
	    	Rails.logger.error("ERROR: There should not be more than 1 user_semester_gpa. UserId #{self.user.id} Semester #{self.user.user_info.current_semester}")
	    end

	    if (user_semester_gpa.length == 0)
	    	self.user.user_semester_gpas.create(:semester=>semester, :gpa=>semester_gpa)
	    else
	    	# There should only be one so assume the first one
	    	user_semester_gpa[0].update_attributes(:gpa => semester_gpa)
	    end

	    return semester_gpa
  	end
end