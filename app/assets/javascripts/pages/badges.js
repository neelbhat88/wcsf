$(function(){
	Badges = function() {	
		var self = this;

		new Header().SetSelectedMenuItem('Badges');

		self.viewModel = {
			semester: ko.observable(1),		
			semesters: [
				{id: 1, text: 'Semester 1'},
				{id: 2, text: 'Semester 2'},
				{id: 3, text: 'Semester 3'},
				{id: 4, text: 'Semester 4'},
				{id: 5, text: 'Semester 5'},
				{id: 6, text: 'Semester 6'},
				{id: 7, text: 'Semester 7'},
				{id: 8, text: 'Semester 8'}
			],
			pageLoaded: ko.observable(false)
		};			

		// Subscribe to drop down change and update the UI accordingly
		self.viewModel.semester.subscribe(function(newValue) {
			if (self.viewModel.pageLoaded()) {
				$.ajax({
					type: "POST",
					url: '/global_badges/semester',
					data: {semester: newValue},
					success: function(data) {
						var json = data;
						ko.mapping.fromJS(json.badges, self.viewModel.badges);						
						self.viewModel.badgesEarned(json.badgesearned);
						self.viewModel.minReqsMet(json.minreqsmet);
						self.viewModel.totalBadgeValue(json.totalbadgevalue);
					},
					error: function() { alert("Failed drop down subscribe ajax post");}
				});
			}
		});
	}

	// Initializes ViewModel
	Badges.prototype.init = function() 
	{
		var self = this;

		$(document).ready(function() {			
			$.ajax({				
				url: '/global_badges/init',				
				success: function(data) {
					self.viewModel.badges = ko.mapping.fromJS(data.badges);
					self.viewModel.badgesEarned = ko.observable(data.badgesearned);
					self.viewModel.minReqsMet = ko.observable(data.minreqsmet);
					self.viewModel.totalBadgeValue = ko.observable(data.totalbadgevalue);
					self.viewModel.semester(data.semester);

					ko.applyBindings(self.viewModel);

					self.viewModel.pageLoaded(true);
				},
				error: function() { alert("Failed initial badge load");}
			});

			$('.minreqsmet').hover(
				function(){
					$('.globalBadge.required.hasNotEarned').addClass('highlight');
				},
				function(){
					$('.globalBadge.required.hasNotEarned').removeClass('highlight');
				}
			);
		});
	}
});

function getBadgeCss(badge) {
	cssClasses = "";

	if (badge.isminrequirement())
		cssClasses += "required";

	return cssClasses += " " + getBadgeColor(badge);
}

function getBadgeColor(badge) {
	if (!badge.hasEarned())
		return "hasNotEarned";	
		
	switch(badge.category())
	{
		case "Academics": 
			return "academics_bg";
		case "Activity": 
			return "extracur_bg";
		case "Service": 
			return "service_bg";
		case "PDU": 
			return "pdu_bg";
		case "Testing": 
			return "testing_bg";
	}			
}