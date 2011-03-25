function setupDialogs() {
	$('button.ui-segment-jump-button').click(function() {
		$('div.ui-segment-jump-dialog').dialog('open');
		return false;
	})
}

function setupDropdowns() {

	$('select.ui-segment-selector').dropdownchecklist({
		maxDropHeight: 200,
		textFormatFunction: function(options) {
			var selectedOptions = options.filter(":selected");
			var countOfSelected = selectedOptions.size();
			var size = options.size();
			switch(countOfSelected) {
					case 0:
						return "No Segments";
					case 1:
						return selectedOptions.text();
					case options.size():
						return "All Segments";
					default:
						if(countOfSelected > 3)
							return countOfSelected + " Segments";

						text = "";
						selectedOptions.each(function() {
								if ($(this).attr("selected")) {
										text += $(this).text() + ", ";
								}
						});
						if (text.length > 0) {
								text = text.substring(0, text.length - 2);
						}
						return text
			}
		},
		width: 400
	})
}

function setupTables() {

	// Expandable, Expanded, Loading states with XHR expansions
	$('tbody.major').click(function() {

		major = $(this).find('td:first');
		minor = $(this).next('tbody.minor');

		if(!minor.attr('loaded')) {
			major.removeClass('expandable')
			major.addClass('loading');

			minor.load(minor.attr('href'), function() {
				minor.attr('loaded', 1)
				major.removeClass('loading');
				major.addClass('expanded')
			})

		} else {
			minor.toggle();
			if(minor.css('display') != 'none') {
				major.removeClass('expandable')
				major.addClass('expanded')
			} else {
				major.addClass('expandable')
				major.removeClass('expanded')
			}
		}
		return false;
	})
}

function setupTabs()
{
	$('div.ui-tabs-container').tabs({
		cache: true,
		ajaxOptions: {
			error: function (xhr, status, index, anchor) {
				$(anchor.hash).html("Couldn't load this tab");
			},
			success: function(data, status, xhr) {
				doSetupRepeatable();
			}
		},
		fx: {
			effect: 'bounce',
			duration: 'normal'
		},
		spinner: 'Loading...'
	});
}

function setupTooltips() {

	jQuery.bt.options.padding = '4px';
	jQuery.bt.options.fill = 'rgba(20,20,20,0.8)';
	jQuery.bt.options.strokeWidth = 1;
	jQuery.bt.options.strokeStyle = '#000000';
	jQuery.bt.options.spikeLength = 10;
	jQuery.bt.options.spikeGirth = 8;
	jQuery.bt.options.cornerRadius = 5;
	jQuery.bt.options.positions = 'right';
	jQuery.bt.options.centerPointX = 0.4;
	jQuery.bt.options.shrinkToFit = true;
	jQuery.bt.options.cssClass = "bt";
	jQuery.bt.options.showTip = function(box){
    $(box).fadeIn(500);
  };
  jQuery.bt.options.hideTip = function(box, callback){
    $(box).animate({opacity: 0}, 500, callback);
  };

	$('.player').bt({
		contentSelector: "$(this).attr('class')"
	})

}

function doSetupOnce()
{
	setupDropdowns();
}

function doSetupRepeatable()
{
	setupDialogs();
	setupTables();
	setupTabs();
	setupTooltips();
}

$(function() {
	doSetupRepeatable();
	doSetupOnce();
});