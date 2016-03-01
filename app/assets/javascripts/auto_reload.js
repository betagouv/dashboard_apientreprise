$(document).ready(services_check);

function services_check(){
    taux_dispo();
    total_dossiers_mps_check ();
    total_dossiers_tps_check ();
    uptime_check();

    setTimeout(services_check, 1000*60*2);
}
