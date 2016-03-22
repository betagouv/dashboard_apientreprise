// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require_tree .
//= require bootstrap-sprockets

//= require moment
//= require easypiechart
//= require gauge
//= require chart
//= require jquery_sparklines
//= require controlfrog-plugins
//= require controlfrog

//= require highcharts
//= require highcharts/highcharts-more
//= require highcharts/themes/dark-unica
//= require highcharts/modules/exporting

var chart; // global

$(document).ready(function() {
    Highcharts.setOptions({
        global: {
            useUTC: false
        }
    });

    var options = {
        chart: {
            renderTo: 'container',
            type: 'area',
            marginRight: 10,
            events: {
                load: get_last_requests
            }
        },
        title: {
            text: 'Nombre d\'appels sur l\'api'
        },
        subtitle: {
            text: 'Interval 15s'
        },
        xAxis: {
            type: 'datetime',
            tickPixelInterval: 150
        },
        yAxis: {
            title: {
                text: 'Nombre d\'appel'
            },
            labels: {
                formatter: function () {
                    return this.value;
                }
            }
        },
        plotOptions: {
            area: {
                marker: {
                    enabled: false,
                    symbol: 'circle',
                    radius: 2,
                    states: {
                        hover: {
                            enabled: true
                        }
                    }
                }
            }
        },
        tooltip: {
            formatter: function () {
                return Highcharts.dateFormat('%Y-%m-%d %H:%M:%S', this.x) + '<br/>' +
                       Highcharts.numberFormat(this.y, 2) + ' appels';
            }
        },
        legend: {
            enabled: false
        },
        exporting: {
            enabled: false
        },
        series: [{}]
    };
    
    var url =  '/api/elasticsearch/requests_last_hour';
    $.getJSON(url,  function(data) {
        options.series[0].data = data.data;
        chart = new Highcharts.Chart(options);
    });
});

function get_last_requests() {
    $.ajax({
        url: '/api/elasticsearch/last_requests',
        success: function(point) {
            var series = chart.series[0],
                shift = series.data.length > 60; 
            // add the point
            chart.series[0].addPoint(point, true, shift);
            
            // call it again after one second
            setTimeout(get_last_requests, 15000);    
        },
        cache: false
    });
}
