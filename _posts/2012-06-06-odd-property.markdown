---
layout: post
title:  "The sum of a sequence of odd numbers gives you the sequence for the perfect squares"
date:   2012-06-06 00:00:00 +0200
categories: development
summary: A curious mathematical property.
---

Really? We can test with a simple PHP Code:

<?php
	
	echo '<h1>The sum of a sequence of odd numbers gives you the sequence for the perfect squares</h1>';
	
	//The limit
	$limit=1000;
	
	$odd=array();
	
	for ($i=1;$i<$limit;$i++) {
	
		if ($i%2!=0) {
			$odd[]=$i;
		}
	
	}
	
	$begin=0;
	$end=1;
	
	while ($end<count($odd)) {
	
		$write='';
		$result=0;
	
		for ($i=$begin;$i<$end;$i++) {
		
			$result=$result+$odd[$i];
			
			$write.=$odd[$i];
		
			if ($i==($end-1)) {
				$write.='=';
			} else {
				$write.='+';
			}
		
		}
		
		$write.=$result;
		
		echo '<h3>' . $write;
		
		$square=sqrt($result);
		
		if ($square==$end) {
			$question="Yes";
		} else {
			$question="No";
		}
		
		echo ' numbers=' . $end . ' sqrt(' . $result . ')=' . $square . ' Really? ' . $question . '</h3>';
	
		$end++;
	
	}
	
	?>