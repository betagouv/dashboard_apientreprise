var chart; // global

$(document).ready(function() {
    Highcharts.setOptions({
        global: {
            useUTC: false
        }
    });

    var options = {
        chart: {
            renderTo: 'nb_call_apientreprise',
            type: 'area',
            marginRight: 10,
            backgroundColor:'rgba(0, 0, 0, 0)',
            events: {
                load: get_last_requests
            }
        },
        title: {
            text: 'Nombre d\'appels sur l\'api'
        },
        credits: {
            enabled: false
        },
        subtitle: {
            text: 'Interval: 15s'
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
