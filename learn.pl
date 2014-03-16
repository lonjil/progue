use strict; use warnings;
use File::Spec;
use SDL;

my %words = ("coin" => {"singular" => "coin", "plural" => "coins"},);
my $gamelog = "gamelog.txt";
my $log = "log.txt";
my %print_chars = ("floor" => ".",
		   "wall"  => "|",
		   "door"  => "+",);
my @messages;
use constant {
	GL => "GAMELOG: ",
	AT => "ATTENTION: ",
	WA => "WARNING: ",
	ER => "ERROR: ",
};


sub main {
	my @level = make_level(3,3);
	game_print("Gamelog: ".File::Spec->rel2abs($gamelog));
}

sub plurize {
	return $words{pop @_}->{abs pop @_!=1?"plural":"singular"};
}
sub net {
	return ($_[0]>0?"gain":"loose")." ".abs $_[0];
}
sub gains {
	return "You ", &net($_[0])," ",&plurize($_[0],$_[1]);
}
sub log {
	open(my $out,">>",$log) || die "Could't open $log for writing because: $!";
	print $out @_,"\n";
}
sub gamelog {
	open(my $out,">>",$gamelog) || die "Could't open $gamelog for writing because: $!";
	print $out @_,"\n";
	&log(GL, @_)
}
sub queue_message {
	unshift @messages, "@_";
	gamelog(@_);
}

sub make_level {
	my ($x, $y) = @_;
	gamelog("Making level: $x * $y");
	my @level;
	foreach my $i (0 .. $y){
		my @row;
		foreach my $j (0 .. $x) {
			$row[$j] = "floor";
		}
		$level[$i] = \@row;
	}
	return @level;
}
sub print_level {
	my @level = @{shift @_};
	foreach (@level){
		foreach (@{ $_ }){
			print $print_chars{ $_ };
		}
		print "\n";
	}
}
&main();