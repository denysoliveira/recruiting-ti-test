<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<title>ping</title>
</head>

<body>

<?php

	$json = $_POST['jsonstring'];
	$obj = json_decode($json);
	if ( $obj->message == "pong")
		echo "ping";
	else
		echo "Comando inválido! Você tinha me dito que era pong!";
?> 

</body>
</html>
