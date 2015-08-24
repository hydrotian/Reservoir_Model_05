#!/bin/tcsh

set fracfile = ${argv[1]};
set globalrunpath = ${argv[2]};
set localrunpath = ${argv[3]};
set globalmetpath = ${argv[4]};
set localmetpath = ${argv[5]};
set totaldays = ${argv[6]};
set copydays = ${argv[7]};
set skipdays = ${argv[8]};
set simstartyear = ${argv[9]};
set endyear = ${argv[10]};
set bindir = ${argv[11]};
set globalcroppath = /civil/hydro/tizhou/ISI_MIP/run/Input_data/crop_frac
set localcroppath = {$localmetpath/../crop}

set long = `awk '{ print($1) } ' $fracfile `;
set lati = `awk '{ print($2) } ' $fracfile `;


#echo $lon
#echo $lat

set n = `echo $long | awk '{n=split($0, array, " ")} END{print n }'`

echo $n files need to be copied to basin free no irr directories
rm $localrunpath/freeirrig.wb.24hr/*;
rm $localrunpath/noirrig.wb.24hr/*;
rm $localmetpath/*;

set headcut = `echo "$skipdays + $copydays" | bc`
echo $skipdays $copydays $headcut

@ i = 1
while ($i <= $n)

  set nchar =  `echo {$long[$i]} | awk '{print length($0)}'` 
  set nss = `echo ${nchar} '-' 2 | bc -l`
  set lon = `echo {$long[$i]} | awk '{print substr($0,1,'$nss')}'`

  set nchar =  `echo $lati[$i] | awk '{print length($0)}'` 
  set nss = `echo ${nchar} '-' 2 | bc -l`
  set lat = `echo $lati[$i] | awk '{print substr($0,1,'$nss')}'`

  set vicfilenamein = fluxes_{$lat}_{$lon};
  set vicfilenameout = fluxes_$lati[$i]_$long[$i];
  set metfilenamein = forcings_{$lat}_{$lon};
  set metfilenameout = data_$lati[$i]_$long[$i];
  set cropfilenamein = crop_frac_{$lat}_{$lon};
  set cropfilenameout = crop_frac_$lati[$i]_$long[$i];

  cp $globalrunpath/freeirr/$vicfilenamein $localrunpath/freeirrig.wb.24hr/$vicfilenameout
  cp $globalrunpath/noirr/$vicfilenamein $localrunpath/noirrig.wb.24hr/$vicfilenameout
  echo copying $metfilenamein to $metfilenameout from $simstartyear to $endyear which is $copydays days 
  head -n $headcut $globalmetpath/$metfilenamein >! $localmetpath/temp1
  tail -n $copydays $localmetpath/temp1 >! $localmetpath/temp2
  awk '{printf ("%f %f %f %f\n", $1-273.15, $2-273.15, $3, $4*86400)}' $localmetpath/temp2 > $localmetpath/$metfilenameout;
  cp $globalcroppath/$cropfilenamein $localcroppath/$cropfilenameout;
  @ i += 1
end

rm $localmetpath/temp*
echo 'done with copy'