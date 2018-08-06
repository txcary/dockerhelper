#!/usr/bin/perl
use 5.010;
my $image = inputFromList("Select Image", getImageList());
my ($imageBase) = split ":", $image;

my $options = inputFromList("Select Option", getOptionList($imageBase));
if(-e "$options") {
	$options = `cat $options`;	
	chomp($options);
} else {
	$options = "";
}

my $entry = inputFromList("Select Entrypoint", getEntryList($imageBase));
if(-e "$entry") {
	$entry = "--entrypoint $entry";
} else {
	$entry = "";
}

my $cmd = inputFromList("Select Command", getCommandList($imageBase));
if(-e "$cmd") {
	chomp($cmd);
} else {
	$cmd = "";
}

run("docker run $options $entry $image $cmd");

sub run {
	my $cmd = shift;
	say $cmd;
	system $cmd;
}

sub getFileList {
  my $path = shift;
  unless(-e $path) {
  	return ();
  }
  my @list = ();
  my @files = `ls -l $path/ | grep ^-`;
  foreach my $file (@files) {
    chomp($file);
    my @tempList = split ' ',$file;
    $file = $tempList[-1];
    push @list, "$path/$file";
  }
  return @list;
}

sub getEntryList {
  my $imageBase = shift;
  my @list = getFileList("/workspace/dockerhelper/entrypoints");
  @list = (@list, getFileList("/workspace/dockerhelper/entrypoints/$imageBase"));
  return @list;
}

sub getCommandList {
  my $imageBase = shift;
  my @list = getFileList("/workspace/dockerhelper/commands");
  @list = (@list, getFileList("/workspace/dockerhelper/commands/$imageBase"));
  return @list;
}

sub getOptionList {
	my $imageBase = shift;
 	my @list = getFileList("/workspace/dockerhelper/options");
  	@list = (@list, getFileList("/workspace/dockerhelper/options/$imageBase"));
  	return @list;
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

	if(@list==0) {
		return "";
	}

	for(my $i=0; $i<@list; $i++) {
		say "$i.$list[$i]";
	}
	print "$title> ";
	my $ret = <>;
	chomp($ret);
	if($ret =~ /^\d+$/) {
		return $list[$ret];
	}
	return "";
}
