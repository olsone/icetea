#!perl
# write a wav file 8 bit samples

$sample = chr(64) x 100 . chr(192) x 100;
$samples = $sample x 100;

# read icarus verilog output:
local $/ = undef;
open FILE,"<sample1.wav" || die "can't read sample1.wav";
$samples = <FILE>;
close FILE;

# build wav file
$subchunk1size = chr(16).chr(0)x3;
$audioformat = chr(1).chr(0);
$numchannels = chr(1).chr(0);
$samplerate = chr(68) .chr(172) . chr(0) . chr(0); # 44100
$byterate = $samplerate;
$blockalign = chr(1).chr(0);
$bitspersample = chr(8) . chr(0);
$subchunk1 = "fmt " . $subchunk1size . $audioformat . $numchannels . $samplerate . $byterate . $blockalign . $bitspersample;

$subchunk2size = pack("l", length($samples) * 1 * 1);
print "subchunk2size = ",unpack("l", $subchunk2size),"\n";
$subchunk2 = "data" . $subchunk2size . $samples;

$totalsize = pack("l", length($subchunk1)+length($subchunk2)+4+8+8);

$wav = "RIFF".$totalsize."WAVE" . $subchunk1 . $subchunk2;

print "subchunk1 is size ",length($subchunk1),"\n";
print "subchunk2 is size ",length($subchunk2),"\n";
print "wav is size ",length($wav),"\n";

open FILE,">sample.wav";
print FILE $wav;
close FILE;

# analyze samples

map { $cnt{$_}++; } split(//, $samples);
foreach $i (sort keys %cnt) {
  printf("%3d %5d\n", ord($i), $cnt{$i});
}
