#!/usr/bin/perl -w
use 5.010;
use Data::Dumper;

my @list;
my @ignores = ();
my $fileType = "*";
my $index = 0;
my @history = ();
my @tagList = ();
my $editor = "vim";
my @btHistory = ();

# Config Input
my $input = shift || ".cr";
if(defined($input) && -e $input) {
  say "Configure $input found.";
  open FILE, "<$input";
  while(<FILE>) {
    my $line = $_;
    chomp($line);

    my @opts = ();
    @opts = split(" ", $line);
    my $cmd = shift(@opts);
    _processCmd($cmd, @opts);

  }
  close FILE;
}

# ctags
if(!-e "tags") {
  say "Generating tags...";
  system "ctags -R --fields=+n";
} 
open(FILE, "<tags");
while(my $line = <FILE>) {
  my @itemList = split(" ",$line);
  if($itemList[0] =~ /^\!/) {
    next;
  }

  my $tag = undef;
  $tag->{symbol} = $itemList[0];
  $tag->{file} = $itemList[1];
  $tag->{type} = $itemList[-2];
  $tag->{line} = $itemList[-1];
  $tag->{line} = substr($tag->{line}, 5);
  if($tag->{line}=~ /^\d+$/) {
    push @tagList, $tag;
  }
  $tag = undef;
}
close(FILE);

Console();

sub _processCmd {
  my $cmd = shift;
  my @opts = @_;

# Processing commands
  $_ = $cmd;
  if($cmd ne "r")
  {
    my $item;
    $item->{cmd} = $cmd;
    $item->{opts} = \@opts;
    push @history, $item;
  }

  if($cmd eq "s")
  {
    Search(@opts);
  }	
  elsif($cmd eq "b")
  {
    CallStack(@opts);
  }
  elsif($cmd eq "bb")
  {
    BB(@opts);
  }
  elsif($cmd eq "p")
  {
    Perforce(@opts);
  }
  elsif($cmd eq "o")
  {
    Editor(@opts);
  }
  elsif($cmd eq "r")
  {
    Recall(@opts);
  }
  elsif($cmd eq "v")
  {
    View(@opts);
  }
  elsif($cmd eq "c")
  {
    Checkout(@opts);
  }
  elsif($cmd eq "i")
  {
    Ignore(@opts);
  }
  elsif($cmd eq "t")
  {
    File(@opts) ;
  }
  elsif($cmd eq "f")
  {
    Find(@opts) ;
  }
  elsif($cmd eq "e")
  {
    Exit(@opts) ;
  }
  elsif($cmd eq "h")
  {
    Help(@opts) ;
  }
  elsif($cmd eq "x")
  {
    Exec(@opts) ;
  }
  elsif($cmd eq "")
  {
    say "View $index.";
    View($index);
  }
  elsif(/^[0-9]*$/)
  {
    View($cmd);
  }	
  else 
  {
    Search($cmd, @opts);	
  }
}

sub Editor {
  $editor = shift;
}

sub Recall {
  my $i = shift;
  my $idx = 0;
  if(!defined($i)) {
    for($i=0; $i<@history; $i++) {
      say $i . ': ' . $history[$i]->{cmd} . ' ' . join(' ', @{$history[$i]->{opts}})
    }
  } else {
    _processCmd($history[$i]->{cmd}, @{$history[$i]->{opts}});
  }
}

sub Checkout {
  my $i = shift;
  return if !defined($i);
  system "p4 edit ".$list[$i]->{file};
}

sub Console {
  my $cmd = "";
  while ($cmd ne "Exit") {
    print "cmd>";
    my $line = <>;
    chomp($line);

    my @opts = ();
    @opts = split(" ", $line);
    $cmd = shift(@opts);
    if(!defined($cmd))
    {
      $cmd = "";
    }

    _processCmd($cmd, @opts);
  }
}
sub Ignore {
  @ignores = @_;
}

sub Exec {
  my $cmd = "";
  foreach my $item (@_)
  {
    $cmd .= $item." ";		
  }

  system $cmd;
}

sub Find {
  my $f = shift;
  my $cmd = "find . -name \"*$f*\""; 
  my @res = `$cmd`;
  @list = ();
  $index = 0;

  foreach my $line (@res) {
    chomp($line);
    if(_checkIgnore($line)==1) {
      next;
    }
    my $item = {
      "file" => $line,
      "line" => 0,
      "code" => "",
    };
    push @list, $item;
  }

  my $i = 0;
  foreach my $item (@list) {
    printf("%d %s:%s\n", $i, $item->{file}, $item->{code});
    $i++;
  }

}

sub Perforce {
  system "p4v -p p4-corp-prx-bej:1666 -u ctan -c ctan_PI-XTF_Projects_dev -t pending &";
}

sub Help {
  say "s=Serch";
  say "v=View";
  say "t=FileType";
  say "f=Find";
  say "e=Exit";
  say "x=Exec";
  say "i=Ignore";
  say "c=Checkout";
  say "r=Recall";
  say "o=Editor";
  say "p=P4V";
  say "h=Help";

}

sub View {
  my $i = shift;
  return if !defined($i);
  system "$editor ".$list[$i]->{file}." +".$list[$i]->{line};
  $index = $i+1;
}

sub Exit {
  exit();
}

sub File {
  $fileType = shift || $fileType;
}

sub BB {
  my $i = shift;
  return if !defined($i);
  my $symbol = $list[$i]->{tag}->{symbol};
  CallStack($symbol);
}

sub nCallStack {
  my $a = shift || return;
  my $f = shift || $fileType;

  @btList = ();
  _CallStack($a, $f, 0);
}

sub _CallStack {
  my $a = shift || return;
  my $f = shift || $fileType;
  my $n = shift || 0;

  $a =~ s/\+/ /g;

  #Check if printed
  foreach my $bt (@btList) {
    if($bt eq $a) {
      return;
    }
  }
  push @btList, $a;

  foreach my $tag (@tagList) {
    if($tag->{symbol} eq $a) {
      my $t = $tag->{type};
      #func or sub
      if($t eq "f" || $t eq "s") {
	for(my $i=0; $i<$n; $i++) {
	  print "[$i]";
	}
	printf("%s[%d]:%s\n",
	  $tag->{file},
	  $tag->{line},
	  $tag->{symbol}
	);
	last;
      }
    }
  }

  my $cmd = "find . -name \"$f\" -exec grep -n -i -H \"$a\" {} \\;";

  my @res = `$cmd`;
  $index = 0;
  foreach my $line (@res) {
    chomp($line);
    my @temp = split ':', $line;
    if(_checkIgnore($temp[0])==1) {
      next;
    }
    my $item = {
      "file" => shift @temp,
      "line" => shift @temp,
    };
    $item->{file} = substr($item->{file}, 2);
    $_ = join ":", @temp;
    while(/^ /)
    {
      s/^ //g;
    }
    while(/^\t/)
    {
      s/^\t//g;
    }
    my $code = $_;
    next if($code =~ /printf/);
    next if($code =~ /syslog/);
    if(length($code)>100)
    {
      $code =	substr $code, 0, 100;
      $code .= "...";
    }
    $item->{code} = $code;
    foreach my $tag (@tagList) {
      my $beginLine = 0;
      if($tag->{file} eq  $item->{file}) {
	if($tag->{line}<$item->{line}) {
	  if($tag->{line}>$beginLine) {
	    $item->{tag} = $tag;
	    $beginLine = $tag->{line};
	    last;
	  }
	}
      }
    }
    if(defined($item->{tag})){
      if($item->{tag}->{symbol} ne $a) {
	if($item->{tag}->{type} eq "f" || $item->{tag}->{type} eq "s") {
	  _CallStack($item->{tag}->{symbol}, $f, $n+1);
	}
      }
    }
  }
}

sub CallStack {
  my $a = shift || return;
  my $f = shift || $fileType;

  $a =~ s/\+/ /g;

  my $cmd = "find . -name \"$f\" -exec grep -n -i -H \"$a\" {} \\;";

  my @res = `$cmd`;
  @list = ();
  $index = 0;

  foreach my $line (@res) {
    chomp($line);
    my @temp = split ':', $line;
    if(_checkIgnore($temp[0])==1) {
      next;
    }
    my $item = {
      "file" => shift @temp,
      "line" => shift @temp,
    };
    $item->{file} = substr($item->{file}, 2);
    $_ = join ":", @temp;
    while(/^ /)
    {
      s/^ //g;
    }
    while(/^\t/)
    {
      s/^\t//g;
    }
    my $code = $_;
    next if($code =~ /printf/);
    next if($code =~ /syslog/);
    if(length($code)>100)
    {
      $code =	substr $code, 0, 100;
      $code .= "...";
    }
    $item->{code} = $code;
    push @list, $item;
  }

  my $i = 0;
  foreach my $item (@list) {
    # Find tag from tags
    foreach my $tag (@tagList) {
      my $beginLine = 0;
      if($tag->{file} eq  $item->{file}) {
	if($tag->{line}<$item->{line}) {
	  if($tag->{line}>=$beginLine) {
	    $item->{tag} = $tag;
	    $beginLine = $tag->{line};
	  }
	}
      }
    }

    printf("%d %s[%d]:%s[%s] => %s\n", $i, 
      $item->{file}, 
      $item->{line},
      $item->{tag}->{symbol},
      $item->{tag}->{type},
      $a);
    $i++;
  }

}

sub Search {
  my $a = shift || return;
  my $f = shift || $fileType;

  $a =~ s/\+/ /g;

  my $cmd = "find . -name \"$f\" -exec grep -n -i -H \"$a\" {} \\;";

  my @res = `$cmd`;
  @list = ();
  $index = 0;

  foreach my $line (@res) {
    chomp($line);
    my @temp = split ':', $line;
    if(_checkIgnore($temp[0])==1) {
      next;
    }
    my $item = {
      "file" => shift @temp,
      "line" => shift @temp,
    };
    $_ = join ":", @temp;
    while(/^ /)
    {
      s/^ //g;
    }
    while(/^\t/)
    {
      s/^\t//g;
    }
    my $code = $_;
    if(length($code)>100)
    {
      $code =	substr $_, 0, 100;
      $code .= "...";
    }
    $item->{code} = $code;
    push @list, $item;
  }

  my $i = 0;
  foreach my $item (@list) {
    printf("%d %s:%s\n", $i, $item->{file}, $item->{code});
    $i++;
  }

}

sub _checkIgnore {
  my $input = shift;
  my $res = 0;

  foreach my $item (@ignores) {
    $_ = $input;
    if(/$item/) {
      return 1;
    }
  }
  return $res;
}
