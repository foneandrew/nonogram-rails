(function() {
	var dd = 0;

	window.DropDown = new function() {
		
		this.initEvents = function() {
			dd = $("#dd");

		    dd.on('click', function(event){
		        console.log("DropDown clicked");
		        dd.toggleClass('active');
		         event.stopPropagation();
	        });
		}
	}
})();