function insertInfo(tresc){
	$('div.inf').html('<div class="ui-widget"><div class="ui-state-highlight ui-corner-all" style="margin-top: 20px; padding: 0 .7em;"><p><span class="ui-icon ui-icon-info" style="float: left; margin-right: .3em;"></span><strong>Info: </strong>'+tresc+'</p></div></div>');
}

function insertError(tresc){
	$('div.inf').html('<div class="ui-widget"><div class="ui-state-error ui-corner-all" style="padding: 0 .7em;"><p><span class="ui-icon ui-icon-alert" style="float: left; margin-right: .3em;"></span><strong>Błąd: </strong>'+tresc+'</p></div></div>');

}