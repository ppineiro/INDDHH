function initPage() {
	$('btnConf').addEvent('click', function(ele) {
		$('queryForm').submit();
	});
}