package Geo::Coordinates::VandH;
use strict;
use Math::Trig;
use vars qw($VERSION);

$VERSION = '1.00';

sub new {
    my $package = shift;
    return bless({}, $package);
};
	   

sub vh2ll {
	my $self = shift;
#Constants shamelessly stolen from vh2ll.c
my $m_pi=3.14159265358979323846;
my $transv=6363.235;
my $transh=2250.7;
my $rotc=0.23179040;
my $rots=0.97276575;
my $radius=12481.103;
my $ex=0.40426992;
my $ey=0.68210848;
my $ez=0.60933887;
my $wx=0.65517646;
my $wy=0.37733790;
my $wz=0.65449210;
my $px=-0.555977821730048699;
my $py=-0.345728488161089920;
my $pz=0.755883902605524030;
my $gx=0.216507961908834992;
my $gy=-0.134633014879368199;
my $a=0.151646645621077297;
my $q=-0.294355056616412800;
my $q2=0.0866448993556515751;
my @bi = ( 1.00567724920722457, -0.00344230425560210245, 0.000713971534527667990, -0.0000777240053499279217, 0.00000673180367053244284, -0.000000742595338885741395,  0.0000000905058919926194134 );
my $x;
my $y;
my $z;
my $v;
my $h;
my $delta;
($v,$h) = @_;
my $t1 = ($v - $transv) / $radius;
my $t2 = ($h - $transh) / $radius;
my $vhat = $rotc*$t2 - $rots*$t1;
my $hhat = $rots*$t2 + $rotc*$t1;
my $e = cos(sqrt($vhat*$vhat + $hhat*$hhat));
my $w = cos(sqrt($vhat*$vhat + ($hhat-0.4)*($hhat-0.4)));
my $fx = $ey*$w - $wy*$e;
my $fy = $ex*$w - $wx*$e;
my $b = $fx*$gx + $fy*$gy;
my $c = $fx*$fx + $fy*$fy - $q2;
my $disc = $b*$b - $a*$c; #discriminant
if ($disc == 0.0) { #It's right on the E-W axis
  $z = $b/$a;
  $x = ($gx*$z - $fx)/$q;
  $y = ($fy - $gy*$z)/$q;
  } else {
  $delta = sqrt($disc); 
  $z = ($b + $delta)/$a;
  $x = ($gx*$z - $fx)/$q;
  $y = ($fy - $gy*$z)/$q;
  if ( $vhat * ( $px*$x + $py*$y + $pz*$z) < 0 ) { #wrong direction
    $z = ($b - $delta)/$a;
    $x = ($gx*$z - $fx)/$q;
    $y = ($fy - $gy*$z)/$q;
    };
  }; 
  my $lat=asin($z);
#Use polynomial approximation for inverse mapping
#(sphere to spheroid)
 my $lat2 = $lat*$lat;
 my $earthlat = 0;
 for (my $i=6; $i>=0 ; $i--) {
  $earthlat = ($earthlat + $bi[$i]) * ($i? $lat2 : $lat);
 };
 $earthlat *= 180/$m_pi;
# Adjust Longitude by 52 degrees
 my $lon = atan2($x,$y) * 180/$m_pi;
 my $earthlon = $lon + 52.0000000000000000;
 return ($earthlat,$earthlon);
};
1;
__END__
# Below is stub documentation for your module. You better edit it!
                                                                                
=head1 NAME
                                                                                
Geo::Coordinates::VandH - Convert and Manipulate telco V and H coordinates
                                                                                
=head1 SYNOPSIS
                                                                                 To convert V: 5498 H: 2895 to lat/long coordinates:
										
  use Geo::Coordinates::VandH;
  $blah=new Geo::Coordinates::VandH;
  ($lat,$lon) = $blah->vh2ll(5498,2895);
  printf "%lf,%lf\n",$lat,$lon;
                                                                                
                                                                                
=head1 DESCRIPTION
                                                                               
      Currently this package only supports the translation of V+H to Lat/Long.
      Results are returned in decimal degrees.
      Future versions will do mileage calculation between V+H coordinates, and convert Lat/Long to V+H coordinates.
                                                                                
=head1 AUTHOR
                                                                                
Paul Timmins, E<lt>paul@timmins.netE<gt>
                                                                                
=head1 SEE ALSO
                                                                                
L<perl>. 
                                                                                
=cut

