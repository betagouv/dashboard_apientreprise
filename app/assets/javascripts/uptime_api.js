function uptime_check() {
    $.ajax({
        url: '/api/uptime/all',
        dataType: 'json',
        async: true
    }).done(function (data) {

        var apis = [
            ['#APIENTREPRISE', 'apientreprise'],
            ['#INSEE', 'insee'],
            ['#ACOSS', 'acoss'],
            ['#INFOGREFFE', 'infogreffe'],
            ['#QUALIBAT', 'qualibat'],
            ['#MPS', 'mps'],
            ['#TPS', 'tps']
        ];


        apis.forEach(function(api){
            var status = data[api[1]];
            var selector = api[0]+' .metric';
            var color_class = '';

            $(selector).html(status);

            if(status === 'UP')
                color_class = 'm-green';
            else if (status === 'DOWN')
                color_class = 'm-red';

            $(selector).addClass(color_class);
        });
    });
}
