#!/usr/bin/perl
use 5.010;
my $image = inputFromList("Select Image", getImageList());
my $cmd = inputFromCommand("Input Command");
my ($imageBase) = split ":", $image;
my $options = "";
if(-e "options/$imageBase.conf") {
  $options =  `cat options/$imageBase.conf`;
}
chomp($options);
run("docker run -it --rm $options $image $cmd");

sub run {
	my $cmd = shift;
	say $cmd;
	system $cmd;
}

sub getImageList {
	my @images = `docker images`;
	foreach my $image (@images) {
		my ($repo, $tag) = split(' ', $image);
		if($repo eq "REPOSITORY") {
			next;
		}
		my $len = @list;
		push @list, "$repo:$tag";
	}
	return @list;
}

sub inputFromCommand {
	my $title = shift;
	print "$title> ";
	my $cmd = <>;
	return $cmd;
}

sub inputFromList {
	my $title = shift;
	my @list = @_;

	for(my $i=0; $i<@list; $i++) {
		say "$i.$list[$i]";
	}
	print "$title> ";
	my $ret = <>;
	return $list[$ret];
}
