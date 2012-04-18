// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require twitter/bootstrap
//= require jquery.timePicker.min
//= require_tree .

$(function() {
	$("#booking_date").datepicker({ dateFormat: "DD, d MM yy"});
	
	// $("#time_start").timePicker();
	$("#booking_time_start, #booking_time_finish").timePicker({
		  	startTime: "08:00", // Using string. Can take string or Date object.
		  	endTime: new Date(0, 0, 0, 18, 00, 0), // Using Date object here.
		  	show24Hours: false,
		  	separator: ':',
		  	step: 15}
  			);
  			
	var oldTime = $.timePicker("#booking_time_start").getTime();
	
	$("#booking_time_start").change(function() {
	  if ($("#booking_time_finish").val()) { // Only update when second input has a value.
	    // Calculate duration.
	    var duration = ($.timePicker("#booking_time_finish").getTime() - oldTime);
	    var time = $.timePicker("#booking_time_start").getTime();
	    // Calculate and update the time in the second input.
	    $.timePicker("#booking_time_finish").setTime(new Date(new Date(time.getTime() + duration)));
	    oldTime = time;
	  }
	});
	// Validate.
	$("#time_finish").change(function() {
	  if($.timePicker("#time_start").getTime() > $.timePicker(this).getTime()) {
	    $(this).addClass("required span2");
	  }
	  else {
	    $(this).removeClass("error");
	  }
	});
	
});