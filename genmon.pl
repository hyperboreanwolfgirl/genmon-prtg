#	Returns XML formatted data from Genmon for PRTG
#	Skylar Gasai / https://github.com/sky-nyan/genmon-prtg
#
#	This program is free software: you can redistribute it and/or modify
#	it under the terms of the GNU General Public License as published by
#	the Free Software Foundation, either version 3 of the License, or
#	(at your option) any later version.
#
#	This program is distributed in the hope that it will be useful,
#	but WITHOUT ANY WARRANTY; without even the implied warranty of
#	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#	GNU General Public License for more details.
#
#	You should have received a copy of the GNU General Public License
#	along with this program.  If not, see <http://www.gnu.org/licenses/>.
#    
use LWP::Simple;
use Data::Dumper;
use JSON qw( decode_json );


print '<?xml version="1.0" encoding="Windows-1252" ?>' . "\n";
print "<prtg>\n";

my $ua = LWP::UserAgent->new;


my $content = $ua->get("http://url.to.your.genmon/cmd/status_json");

our $json = decode_json( $content->decoded_content );
#print Dumper($json);


print "<text>" . $json->{Status}->[0]->{Engine}->[1]->{'Engine State'}
	. " : " . $json->{Status}->[0]->{Engine}->[0]->{'Switch State'}
	. " : " . $json->{Status}->[0]->{Engine}->[2]->{'System In Alarm'} 
	. "</text>\n";


my $battery_voltage = $json->{Status}->[0]->{Engine}->[3]->{'Battery Voltage'};
$battery_voltage =~ s/\sV//;
my $engine_rpm = $json->{Status}->[0]->{Engine}->[4]->{'RPM'};
$engine_rpm =~ s/\s//;
my $frequency = $json->{Status}->[0]->{Engine}->[5]->{'Frequency'};
$frequency =~ s/\sHz//;
my $output_voltage = $json->{Status}->[0]->{Engine}->[6]->{'Output Voltage'};
$output_voltage =~ s/\sV//;
my $output_current = $json->{Status}->[0]->{Engine}->[7]->{'Output Current'};
$output_current =~ s/\sA//;
my $output_power = $json->{Status}->[0]->{Engine}->[8]->{'Output Power (Single Phase)'};
$output_power =~ s/\skW//;
my $utility_voltage = $json->{Status}->[1]->{Line}->[0]->{'Utility Voltage'};
$utility_voltage =~ s/\sV//;

print "<result>\n";
print "<channel>Battery Voltage</channel>\n";
print "<customUnit>V DC</customUnit>\n";
print "<float>1</float>\n";
print "<LimitMode>1</LimitMode>\n";
print "<LimitMaxWarning>15</LimitMaxWarning>\n";
print "<LimitMaxError>16</LimitMaxError>\n";
print "<LimitMinWarning>12</LimitMinWarning>\n";
print "<LimitMinError>11</LimitMinError>\n";
print "<value>" . $battery_voltage . "</value>\n";
print "</result>\n";

print "<result>\n";
print "<channel>Engine RPM</channel>\n";
print "<customUnit>RPM</customUnit>\n";
print "<float>0</float>\n";
print "<value>" . $engine_rpm . "</value>\n";
print "</result>\n";

print "<result>\n";
print "<channel>Frequency</channel>\n";
print "<customUnit>Hz</customUnit>\n";
print "<float>1</float>\n";
print "<value>" . $frequency . "</value>\n";
print "</result>\n";

print "<result>\n";
print "<channel>Output Voltage</channel>\n";
print "<customUnit>V AC</customUnit>\n";
print "<float>1</float>\n";
print "<value>" . $output_voltage . "</value>\n";
print "</result>\n";

print "<result>\n";
print "<channel>Output Current</channel>\n";
print "<customUnit>A</customUnit>\n";
print "<float>1</float>\n";
print "<value>" . $output_current . "</value>\n";
print "</result>\n";

print "<result>\n";
print "<channel>Output Power</channel>\n";
print "<customUnit>kW</customUnit>\n";
print "<float>1</float>\n";
print "<value>" . $output_power . "</value>\n";
print "<LimitMode>1</LimitMode>\n";
print "<LimitMaxWarning>19</LimitMaxWarning>\n";
print "<LimitMaxError>20</LimitMaxError>\n";
print "</result>\n";

print "<result>\n";
print "<channel>Utility Voltage</channel>\n";
print "<customUnit>V AC</customUnit>\n";
print "<float>1</float>\n";
print "<value>" . $utility_voltage . "</value>\n";
print "<LimitMode>1</LimitMode>\n";
print "<LimitMaxWarning>249</LimitMaxWarning>\n";
print "<LimitMaxError>255</LimitMaxError>\n";
print "<LimitMinWarning>231</LimitMinWarning>\n";
print "<LimitMinError>225</LimitMinError>\n";
print "</result>\n";

print "</prtg>";
