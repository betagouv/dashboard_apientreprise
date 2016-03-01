function createPieChart(obj){
	$(window).resize(generatePieChart);

	function generatePieChart(){
		$container = obj;
		pId = $container.prop('id');
		var $canvas = $('canvas', $container);
		var cWidth = $container.width()*0.50;
		var cHeight = $container.height();		
		
		// Safari 5.1.10 .height() bug
		if(cHeight == 0){
			cHeight = cWidth - 28;
		}

		//Set canvas size
		$canvas.prop({width:cWidth,height:cHeight});
	
		// Get canvas context		
		var ctx = $canvas.get(0).getContext('2d');
		
		// Check for custom options
		var pieOptions;
		if(cf_rPs[pId].options){
			var pieOptions = $.extend({}, cf_DefaultPieOpts, cf_rPs[pId].options);
		}
		else{
			pieOptions = cf_DefaultPieOpts;
		}

		// Create chart		
		new Chart(ctx).Pie(cf_rPs[pId].data,pieOptions);
		createPieLegend(pId);
	}
	
	function createPieLegend(pId){
		// Check if we've already generated the legend
		if(cf_rPs[pId].legend){
			$('#'+pId).append(pieLegendHtml);			
		}
		else{
			// generate legend
			var pieLegendRow = '';
			var pieLegendHtml = '';
			
			for(i in cf_rPs[pId].data){
				pieLegendRow += '<li><div class="cf-pie-legend-color" style="background-color:'+cf_rPs[pId].data[i].color+'"></div>'+cf_rPs[pId].data[i].label+'</li>';
			}
			pieLegendHtml += '<div class="cf-pie-legend"><ul>'+pieLegendRow+'</ul></div>';
			$('#'+pId).append(pieLegendHtml);
			cf_rPs[pId].legend = pieLegendHtml;
		}
	}
	
	// Call once on page load
	generatePieChart();
}

function createLineChart(obj){
	$(window).resize(generateLineChart);

	function generateLineChart(){
		$container = obj;
		lId = $container.prop('id');

		var $canvas = $('canvas', $container);
		var cWidth = $container.width();
		var cHeight = $container.height();		
		
		console.log(cWidth, cHeight);

		// Get canvas context		
		var ctx = $canvas.get(0).getContext('2d');

		//Set canvas size
		$canvas.prop({width:cWidth,height:cHeight});
		
		// Check for custom options
		var lineOptions;
		if(cf_rLs[lId].options){
			var lineOptions = $.extend({}, cf_lineDefaultOpts, cf_rLs[lId].options);
		}
		else{
			lineOptions = cf_lineDefaultOpts;
		}

		// Create chart		
		new Chart(ctx).Line(cf_rLs[lId].data,lineOptions);
	}
	
	// Call once on page load
	generateLineChart();
}

function createSparkline(obj, data, sparkOptions){
	
	$(window).resize(generateSparkline);
	
	function generateSparkline(){
		var ww = $(window).width();
		var $obj = obj;			
		var $parent = $obj.parent().parent();
	
		// Current value
		$('.sparkline-value .metric-small', $parent).html(data[data.length-1]);
	
		// Sizing
		if(ww < 768){
			var cWidth = $parent.width();
			var slWidth = Math.floor(cWidth/3);
		}
		else{
			var svWidth = $('.sparkline-value', $parent).width();
			var cWidth = $parent.width();
			var slWidth = cWidth - svWidth - 20;
			var cHeight = $parent.parent().outerHeight() - 35;
			var svmHeight = $('.cf-svmc', $parent).height();
			var slHeight = cHeight - svmHeight;
			$('.sparkline-value', $parent).css({height:slHeight});
		}	
	
		// Options
		sparkOptions.width = slWidth;
		sparkOptions.height = slHeight;		
	
		// Create sparkline
		$obj.sparkline(data, sparkOptions);
	}
	
	// Call once on page load
	generateSparkline();
}

/*
*	Set or update a Gauge
*	@param gauge 	string 		ID of gauge container
*	@param opts 	object		JSON object of options
*/
function gaugeUpdate(gauge, opts){
	if(opts.minVal){
		$('.val-min .metric-small', $('#'+gauge)).html(opts.minVal);		
		cf_rGs[gauge].minValue = opts.minVal;
	}
	if(opts.maxVal){
		cf_rGs[gauge].maxValue = opts.maxVal;
		$('.val-max .metric-small', $('#'+gauge)).html(opts.maxVal);
	}
	if(opts.newVal){
		cf_rGs[gauge].set(parseInt(opts.newVal));
	}
}

/*
*	Create single value pie charts
*/
function rSVP(element, options){
	// Call the chart generation on window resize
	$(window).resize(generateChart);
	
	var container = $(element);
	var chart = '#'+$(element).attr('id')+' .chart';
	

	// Create the chart
	function generateChart(){
		
		// Resize when width is 768 or greater 
		// Remove any existing canvas                
		if($('canvas', $(container)).length){
			$.when($('canvas', $(container)).remove()).then(addChart());
		}
		else{
			addChart();
		}
		
		function addChart(){
			//Setup options
			var rsvpOpt = {
				barColor: pieBar,
				trackColor: pieTrack,
				scaleColor: false,
				lineWidth: 15,			
				lineCap: 'butt',
				size: 100
			};
			
			//Alter settings depending on layout and screen width
			var ww = $(window).width();
			
			if(ww > 767 && ww < 992){
				rsvpOpt.size = container.width()-10;
										
				switch($(chart).data('layout')){
					case 'l-6':
						rsvpOpt.lineWidth = 30;
						break;
					
					case 'l-6-i':
						rsvpOpt.lineWidth = 20;
						rsvpOpt.size = parseFloat((container.width()*0.7)-10);
						break;					
					
					case 'l-6-12-6':
						break;
					
					case 'l-6-4':
						rsvpOpt.lineWidth = 5;	
						break;
				}
			}
			else if(ww > 991 && ww < 1200 ){
				rsvpOpt.size = container.width()-10;
										
				switch($(chart).data('layout')){
					case 'l-6':
						rsvpOpt.lineWidth = 30;
						break;
					
					case 'l-6-i':
						rsvpOpt.lineWidth = 30;
						rsvpOpt.size = parseFloat((container.width()*0.75)-10);
						break;					
					
					case 'l-6-12-6':
						rsvpOpt.lineWidth = 20;
						break;
					
					case 'l-6-4':
						rsvpOpt.lineWidth = 5;	
						break;
				}
			}
			else if(ww > 1199 && ww < 1399){
				rsvpOpt.size = container.width()-10;
										
				switch($(chart).data('layout')){
					case 'l-6':
						rsvpOpt.lineWidth = 40;
						break;
					
					case 'l-6-i':
						rsvpOpt.lineWidth = 30;
						rsvpOpt.size = parseFloat((container.width()*0.75)-10);
						break;					
					
					case 'l-6-12-6':
						rsvpOpt.lineWidth = 20;					
						break;
					
					case 'l-6-4':
						rsvpOpt.lineWidth = 10;	
						break;
				}
			}
			else if(ww > 1399){
				rsvpOpt.size = container.width()-10;
										
				switch($(chart).data('layout')){
					case 'l-6':
						rsvpOpt.lineWidth = 50;
						break;
					
					case 'l-6-i':
						rsvpOpt.lineWidth = 40;
						rsvpOpt.size = parseFloat((container.width()*0.75)-10);
						break;					
					
					case 'l-6-12-6':
						rsvpOpt.lineWidth = 30;
						break;
					
					case 'l-6-4':
						rsvpOpt.lineWidth = 15;	
						break;
				}
			}
			// Create and store the chart
			cf_rSVPs[$(element).attr('id')].chart = new EasyPieChart(document.querySelector(chart), rsvpOpt);
		}
	};

	// Run once on first load
	generateChart();
}

/*
*	Size modules 
*/
function cfSizeItems(){
	var width = $(window).width();

	$('.cf-item').each(function(){
		if(width > 767 ){
			$(this).height($(this).width());
		}
		else{
			$(this).height('auto');
		}
	});
}

/*
*	Shorten large numbers
*/
function prettyNumber (number) {
    var prettyNumberSuffixes = ["", "K", "M", "bn", "tr"];
	var addCommas = function (nStr){
		var x = '';
		var rgx = /(\d+)(\d{3})/;
		while (rgx.test(x)) {
			x = x.replace(rgx, '$1' + ',' + '$2');
		}
		return x;
	}
	var prettyNumber_rec = function (number, i) {
		if (i == prettyNumberSuffixes.length) {
			return addCommas(Math.round(number*1000)) + prettyNumberSuffixes[i-1];
		}
		if (number / 1000 >= 1) { // 1000+
			return prettyNumber_rec(number / 1000, ++i);
		}
		else {
			var decimals = number - Math.floor(number);
			if (decimals != 0) {
				if (number >= 10) { // 10 - 100
					number = Math.floor(number) + Math.round(decimals*10) / 10 + '';
					number = number.replace(/(.*\..).*$/, '$1');
				}
				else { // 0 - 10
					number = Math.floor(number) + Math.round(decimals*100) / 100 + '';
					number = number.replace(/(.*\...).*$/, '$1');
				}
				return number + prettyNumberSuffixes[i];
			}
			else {
				return Math.floor(number) + prettyNumberSuffixes[i];
			}
		}
	}
	return prettyNumber_rec(number, 0);
}