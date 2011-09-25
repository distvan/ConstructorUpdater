# Recursive seaching php files and
# Replace all old style constructor calling
package ConstructorUpdater;
use File::Find;

#
# Constructor
sub new
{
	my($class) = @_;
	my $self = {
		_searchPath => '.',
		_ext => '\.php',
		_classes => []
	};
	bless $self, $class;
	return $self;
}

#
# Eloszor kicsereli a konstruktorokat 
# majd a referenciait a megadott konyvtartol kezdve rekurzivan
# At first it replaces the old php constructor call
# and after then it replaces their refences
sub doUpdate
{
	my ($self) = @_;
	$o = new ConstructorUpdater;
	$ref = sub{ $o->replaceConstructor() };
	find(\&$ref, $o->{_searchPath});
	$ref = sub{ $o->replaceReferences() };
	find(\&$ref, $o->{_searchPath});
}

# A regi php konstruktotokat csereli le es megjegyzi az osztalyokat
# Replace all old constructor and get class names into an array
sub replaceConstructor
{
	my ($self) = @_;
	my $fileName = $_;
	if($fileName =~ /$self->{_ext}/)
	{
		open(FILE, $fileName) or die $!;
		undef $/;
		while(<FILE>)
		{
			while ($_ =~ m/\s*(class\s+(\w+)\b.*\s*function\s+)\2\b/gs)
			{
				if(!grep /$2/, $self->{_classes})
				{
					push(@{$self->{_classes}}, $2);
				}
			}
			$_ =~ s/\s*(class\s+(\w+)\b.*\s*function\s+)\2\b/\1__construct/gs;
			$self->saveFile($fileName, $_);
		}
		close(FILE);
	}
}

# A konstruktor csere soran megjegyzett osztalyokban lecsereli a regi 
# konstruktor hivatkozasokat
# Replace all old constructor references
sub replaceReferences
{
	my ($self) = @_;
	my $fileName = $_;
	my $classNames = join "|", @{$self->{_classes}};
	if($fileName =~ /$self->{_ext}/)
	{
		open(FILE, $fileName) or die $!;
		undef $/;
		while(<FILE>)
		{
			$_ =~ s/((?:parent)::)($classNames)\b/parent::__construct/gs;
			$_ =~ s/((?:\$this->))($classNames)\b/\$this->__construct/gs;
			$_ =~ s/(?:($classNames)::)\1\b/\1::__construct/gs;
			$self->saveFile($fileName, $_);
		}
		close(FILE);
	}
}

# beallitja a konyvtarat, ahol a belepesi pont lesz
# Set the searching folder
sub setSearchPath
{
	my ($self, $path) = @_;
	$self->{_searchPath} = $path if defined($path);
	return $self->{_searchPath};
}

sub saveFile
{
	my ($self, $fileName, $content) = @_;
	open(SAVED, '>'.$fileName) or die $!;
	print SAVED $content;
	close(SAVED);
}

1;
