// Mozilla Force Keyup Javascript module
// by 月風(http:://dorajistyle.pe.kr)
// How to use
// mozillaForceKeyup(”inputid”)
// in HTML.
// <input id=”inputid”>
mozillaForceKeyup = function(targetId) {
	var isIntervalRunning, target;
	if (jQuery.browser.mozilla) {
		isIntervalRunning = null;
		target = '#' + targetId;
		$(target).bind('keydown', function(e) {
			var forceKeyup;
			if (e.which === 229) {
				forceKeyup = function() {
					return $(target).trigger('keyup');
				};
				if (!isIntervalRunning) {
					return isIntervalRunning = setInterval(forceKeyup, 100);
				}
			}
		});
		return $(target).bind('blur', function(e) {
			if (isIntervalRunning) {
				clearInterval(isIntervalRunning);
				return isIntervalRunning = null;
			}
		});
	}
};