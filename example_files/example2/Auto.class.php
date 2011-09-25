<?
class Auto 
{
	public function Auto()
	{
		/* example old style constructor calling*/
	}
}

class VW extends Auto{
	
	public function VW(){
			/* example old style constructo calling*/
			parent::Auto();
	}
}


class Mercedes extends Auto {

	public function Mercedes(){
		/* example old style constructor calling */
		Auto::Auto();
	}

	protected function Example_method()
	{
		/*example stupid method just for test*/
		$this->Auto();
	}
}
?>
