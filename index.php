<html>

<head>
<title> Lista Filmes </title>
</head>

<body>

<?php

 	try
           {
               $connection = new PDO("mysql:host=localhost:3306;dbname=cinema", "", "");
               $connection->exec("set names utf8");
           }
           catch(PDOException $e)
           {
               echo "Falha: " . $e->getMessage();
               exit();
           }
           
           $film = $connection->prepare("SELECT * FROM film");
           
           if( $film->execute() )
           {
               while( $registro = $film->fetch(PDO::FETCH_OBJ) )
               {
echo "<table'>";
                   echo "<tr>";
                   echo "<td>" . $registro->film_id . "</td> &nbsp; | &nbsp";
echo "<td>" . $registro->title . "</td>&nbsp; | &nbsp";
echo "<td>" . $registro->description . "</td> &nbsp; | &nbsp";
echo "<td>" . $registro->release_year . "</td> &nbsp; | &nbsp";
echo "<td>" . $registro->rental_duration . "</td> &nbsp; | &nbsp";
echo "<td>" . $registro->rental_rate . "</td> &nbsp; | &nbsp";
echo "<td>" . $registro->length . "</td> &nbsp; | &nbsp";
echo "<td>" . $registro->replacement_cost . "</td> &nbsp; | &nbsp";
echo "<td>" . $registro->rating . "</td> &nbsp; | &nbsp";
echo "<td>" . $registro->special_features . "</td> &nbsp; | &nbsp";
echo "<td>" . $registro->last_update . "</td> &nbsp; | &nbsp";
echo  "<br />";
echo  "<br />";

 
                   echo "</tr>";
echo "</table>";
               }
           }
           else
           {
               echo "Falha na seleção de registros.<br>";
           }
           
       
       ?>
</body>

</html>
