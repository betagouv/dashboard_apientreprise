function total_dossiers_mps_check (){

    $.ajax({
        url: '/api/stats/mps/dossiers',
        dataType: 'json',
        async: true
    }).done(function (data) {
        $("#MPS_TOTAL_MARCHES").html(data['total']);
        $("#MPS_MARCHES_MOIS").html(data['mois']);
    });
}

function total_dossiers_tps_check (){

    $.ajax({
        url: '/api/stats/tps/dossiers',
        dataType: 'json',
        async: true
    }).done(function (data) {
        $("#TPS_TOTAL_DOSSIERS").html(data['total']);
        $("#TPS_DOSSIERS_MOIS").html(data['mois']);
    });
}
