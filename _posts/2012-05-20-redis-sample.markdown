Date: 20 May 2012
Categories: development
Summary: Predis is a flexible and feature-complete PHP (>= 5.3) client library for the Redis key-value store.
Read more: Show me more

# Rdis using PHPRedis

My firsts steps with this PHP Library [Predis][predis]. Insert and show registers with [Redis][redis].

	<?php
	
	//error_reporting(E_ALL);
	//ini_set('display_errors','On');
	
	require 'SharedConfigurations.php';
	
	$client = new Predis\Client($single_server);
	
	
	if ($_POST['form_username']<>'') {
	
		$set_name='users:' . $_POST['form_username'];
	
	
		if ($_POST['form_name']<>'') {
			$value=$_POST['form_name'];
			$client->hSet($set_name, 'name', $value);
	
		}
	
		if ($_POST['form_email']<>'') {
			$value=$_POST['form_email'];
			$client->hSet($set_name, 'email', $value);
		}
		
		if ($_POST['form_number']<>'') {
			$value=$_POST['form_number'];
			$client->hSet($set_name, 'form_number', $value);
		}
	
	
	//$retval = $client->hGetAll('users:' . $_POST['form_username']);
	//var_dump($retval);
	
	}
	
	?>
	
	<!DOCTYPE HTML>
	<html>
	 <head>
	  <title>Redis Sample</title>
	 </head>
	 <body>
	 
	  <p>Testing Redis</p>
	 
	 	<form action="sample.php" method="post">
	 
	 	<label>Username</label>
	    <input name="form_username" id="form_name" type="text">
	 
	 	<label>Name</label>
	    <input name="form_name" id="form_name" type="text">
	 	
	 	<label>Email:</label>
	    <input name="form_email" id="form_email" type="email">
	    
	    <label>Age:</label>  
		<input name="form_number" id="form_number" type="number" min="18" max="120">
		
		<input name="submit" id="form_submit" type="submit">
	 
	  </form>
	  
	  <ul>
	  
	  	<li>List</li>
	  	
	  	<?php
	  	
	  		$getall = $client->keys('users:*');
	  		
	  		foreach ($getall as $users) {
	  		
				$space = strpos($users, ' ');
	  			
	  			if ($space==0) {
	  			
	  				$super_user = $client->hGetAll($users);
	  				
	  				?>
	  		
	  				<li><?php echo 'Name: '. $super_user['name'] . ' - Email: ' . $super_user['email'] . ' - Age: ' . $super_user['form_number']  ?></li>
	  		
	  			<?php
	  			
	  			}
	  				
	  		}
	  	
	  	?>
	  
	  </ul>
	  
	 
	 </body>
	</html>
	
	
[predis]: https://github.com/nrk/predis
[redis]: http://redis.io/