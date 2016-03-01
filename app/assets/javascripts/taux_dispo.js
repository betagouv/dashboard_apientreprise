function taux_dispo (){
    $.ajax({
        url: '/api/uptime/taux_dispo',
        dataType: 'json',
        async: true
    }).done(function (data) {
        var taux = data['taux_dispo'];

        $("#svp-1 .chart").attr('data-percent', taux);
        $("#svp-1 .metric").html(taux);

        $('.cf-svp').each(function(){
            cf_rSVPs[$(this).prop('id')] = {};
            rSVP($(this));
        });
    });
}

