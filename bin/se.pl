#!/usr/bin/perl -w
use strict;
use LWP::Simple;

my $dir = "/opt/music";

my $url = $ARGV[0];
my $act = $ARGV[1];
unless ($url =~ m#^http://#) {
  print "Wrong URL!\n";
}
unless ($act =~ /^(d|l)$/) {
  print "Download OR Listen?\n";
}
my $page = get ($url);
my $name_begin = "border=\"0\" alt=\"";
my $name_end = "\"> <b> Listen Now";
my $link_begin = "javascript:playmedia1\(";
my $link_end = "\);ListenLog";
$page =~ m/$link_begin(.*)$link_end/is;
my $unclean_link = $1;
  $unclean_link =~ s/ //g;
  $unclean_link =~ s/\(//g;
  $unclean_link =~ s/\)//g;
  $unclean_link =~ s/\'//g;
my @misc = split /\,/, $unclean_link;
my $link = $misc[6].$misc[2].".mp3";
print $link;

if ($act eq 'd') {
  $page =~ m/$name_begin(.*)$name_end/is;
  my $name = $1;
    $name =~ s/ //g;
    $name =~ s/\(//g;
    $name =~ s/\)//g;
    $name =~ s/\〔//g;
    $name =~ s/\《//g;
    $name =~ s/\&//g;
    $name =~ s/\@//g;
    $name =~ s/\”//g;
    $name =~ s/\"//g;
    $name =~ s/\“//g;
    $name =~ s/\`//g;
    $name =~ s/\'//g;
    $name =~ s/\\//g;
    $name =~ s/\///g;
    $name =~ s/\#//g;
    $name =~ s/\!//g;
    $name =~ s/\*//g;
    $name =~ s/\、//g;
    $name =~ s/\[//g;
    $name =~ s/\]//g;
    $name =~ s/\{//g;
    $name =~ s/\}//g;
    $name =~ s/\;//g;
    $name =~ s/\://g;
    $name =~ s/\$//g;

  exec "wget -c $link -O ${dir}/${name}.mp3";
}
elsif ($act eq 'l') {
  exec "mplayer -loop 0 $link";
}
