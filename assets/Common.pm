#!/usr/bin/env perl

package Common;
use strict;
use warnings;
use JSON;

sub get_last_version
{
	open(my $fh, ">:encoding(UTF-8)", '/tmp/input')
	    || die "Can't open UTF-8 encoded /tmp/input: $!\n";

	# redirect stdin to temporary input file
	while (<>) {
	    print $fh $_; # or simply "print;"
	}    
	close $fh;

	open($fh, "<:encoding(UTF-8)", '/tmp/input')
	    || die "Can't open UTF-8 encoded /tmp/input: $!\n";


	my $str = do { local $/; <$fh> };
	close $fh;

	my $decoded = JSON->new->decode($str);

	my $force_version=$decoded->{'source'}{'version'};

	my $json=`curl -s https://api.github.com/repos/facebook/rocksdb/releases/latest`
		||die "information about last rocksdb stable version have not been found on provided address\n";

	( my $current_stable_release = JSON->new->decode($json)->{'tag_name'}) =~ s/\D+([.\d+]*)/$1/g;

 	if ($current_stable_release ne "")
	{
		# check if the src tar.gz is available
		my $valid_tar=0;
		my $http_status="ko";
		my $archive_name="mongodb-src-r${current_stable_release}.tar.gz";
		my @tar_info=`curl -sI https://codeload.github.com/facebook/rocksdb/tar.gz/v${current_stable_release}`;

		foreach my $i (@tar_info){
			if ( $i =~ /HTTP\/1.1 200 OK/ ){$http_status="ok";}
			if ( $i =~ /Content-Type: application\/x-gzip/){$valid_tar=1;}
		}

		if ($http_status eq "ko"){die "Download URL doesn't seem to be valid\n";}
		if ( ! $valid_tar ){die "The file $archive_name on remote doesn't seem to be a valid archive\n";}
	}
	return "$current_stable_release";
}

sub get_version_json
{
	my ($version)=@_;
	my %output=('ref' => $version);
    return JSON->new->pretty->encode(\%output);
}

1;