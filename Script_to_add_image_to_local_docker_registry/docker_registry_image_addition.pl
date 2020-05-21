use strict;
use warnings;

#Open the file containing all the list of all the image details 

my $filename = 'version.yaml';
open(my $fh, '<:encoding(UTF-8)', $filename)
  or die "Could not open file '$filename' $!";
 
#replace the <path_to_the_version_file> with the actual path of the yaml
#file contianing the version inormation. Its path in the repository is 
#/root/deploy/treasuremap/global/software/config/versions.yaml

open(FILE, "< <path_to_the_version_file>") || die "File not found";
my @lines = <FILE>;
close(FILE);



while (my $row = <$fh>) {
  chomp $row;
  my @values = split(':', $row, 2);
  foreach my $val (@values) {
    print "$val\t";
  }
  my $image = (split(/\//, $values[1]))[-1];
  my $final_image = join('/',"myregistrydomain.com:443",$image);

  `docker pull $values[1]`;
  `docker tag $values[1] $final_image`;
  `docker push $final_image`;
  `docker image rm $values[1]`; 
  `docker image rm $final_image`; 

  foreach(@lines) {
    $_ =~ s/$values[1]/$final_image/g;
  }

  print "\n";
}

open(FILE, "> <path_to_the_version_file>") || die "File not found";
print FILE @lines;
close(FILE);
print "\nJOB DONE\n";
