# perl -I /home/distvan/GIT/ConstructorUpdater test.pl
use ConstructorUpdater;

if($#ARGV == 0)
{
	my $updater =  eval{ new ConstructorUpdater(); } or die ($@);
	$updater->setSearchPath($ARGV[$0]);
	$updater->doUpdate();
}else
{
	print "Nem megfelelő argumentum !\n";
}

