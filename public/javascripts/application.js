// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
$(document).ready(function() {
	$('p.notice, p.warning, p.error').delay(2500).fadeOut(1500);
	if (document.title == "Your friend change list") {
		check_updates();
	}
});

function check_updates() {
	$.get('defriend/update_checkin', function(data) {
		if (data == "false") {
			setTimeout(check_updates, 3000);
		} else if (data == "true") {
			$.get('defriend/friend_list_update')
		}
		
	});
	
}
