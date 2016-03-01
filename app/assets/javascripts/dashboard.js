var themeColour = 'white';

var backColor = '#4f4f4f';
var metric = '#f2f2f2';
var pointerColor = '#898989';
var pageBackgorund = '#2b2b2b';
var pieSegColors = [metric,'#c0c0c0','#8e8e8e','#5b5b5b','#292929'];
var pieTrack = backColor;
var pieBar = metric;
var gaugeTrackColor = '#4f4f4f';
var gaugeBarColor = '#898989';
var gaugePointerColor = metric;

// Stores
var cf_rSVPs = [];
var cf_rGs = [];
var cf_rLs = [];
var cf_rPs = [];
var cf_rRags = [];
var cf_rFunnels = [];


/*
 *
 * Date Time
 *
 */
$(document).ready(function(){

    // Make items square
    cfSizeItems();

    // Time and date display
    (function updateTime(){
        var now = moment();

        $('.cf-td').each(function(){
            if($(this).hasClass('cf-td-12')){
                $('.cf-td-time', $(this)).html(now.format('h:mm'));
                ampm = now.format('a');
                $('.cf-td-time', $(this)).append('<span>'+ampm+'</span>');
            }
            else{
                $('.cf-td-time', $(this)).html(now.format('HH:mm'));
            }

            $('.cf-td-day', $(this)).html(now.format('dddd'));
            $('.cf-td-date', $(this)).html(now.format('MMMM Do YYYY'));
        });

        setTimeout(updateTime, 3000);
    })();
});

/*
 *
 * Sparklines (cf-svmc-sparkline)
 *
 */
$(document).ready(function(){

    // Set up default options
    window.cf_defaultSparkOpts = {};
    cf_defaultSparkOpts.fillColor = false;
    cf_defaultSparkOpts.lineColor = metric;
    cf_defaultSparkOpts.lineWidth = 1.5;
    cf_defaultSparkOpts.minSpotColor = false;
    cf_defaultSparkOpts.maxSpotColor = false;
    cf_defaultSparkOpts.spotRadius = 2.5;
    cf_defaultSparkOpts.highlightLineColor = metric;
    cf_defaultSparkOpts.spotColor = '#f8f77d';

    // Initialise sparklines
    /*
     *	Copy the each() function for each sparkline you have
     * 	e.g. $('#spark-1').each(function(){.....}
     */
    $('.sparkline').each(function(){

        /*
         // Set custom options and merge with default
         customSparkOptions = {};
         customSparkOptions.minSpotColor = true;
         var sparkOptions = cf_defaultSparkOpts;
         var sparkOptions = $.extend({}, cf_defaultSparkOpts, customSparkOptions);
         */

        // No custom options
        var sparkOptions = cf_defaultSparkOpts;

        data = 	[2343,1765,2000,2453,2122,2333,2666,3000,2654,2322,2500,2700,2654,2456,2892,3292];
        createSparkline($(this), data, sparkOptions);
    });
});


// Call the resize function on window resize
$(window).resize(function(){
    cfSizeItems();
});
