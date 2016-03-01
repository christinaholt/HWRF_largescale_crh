#!/usr/bin/env ksh93
#
# Create matching files from gfs and a run (thompson or control)
# for MET-TC input.

HWRF_SCRIPTS=/scratch1/portfolios/BMC/dtc-hwrf/Mrinal.Biswas/HWRF/hwrf-utilities/scripts
GFS=/scratch1/portfolios/BMC/dtc-hwrf/Mrinal.Biswas/GFS_ANALYSIS
CTL=/scratch1/portfolios/BMC/dtc-hwrf/TNE_Thompson_MP/TNE_Thompson_MP_control
THP=/scratch1/portfolios/BMC/dtc-hwrf/TNE_Thompson_MP/TNE_Thompson_MP_thompson

. ${HWRF_SCRIPTS}/funcs/init
trap - ERR

# Loop through all forecast hours and create their files.

typeset -Z 3 fhr

#	for (( fhr = 0 ; fhr <= 126; fhr += 24 )) ; do
#	#echo $fhr
#	ls $CTL/???/20*/postprd/${fhr}/d01_mega_025_sel.${fhr} > HC35.$fhr
#	ls $THP/???/20*/postprd/${fhr}/d01_mega_025_sel.${fhr} > HDTR.$fhr
#done
#
#for f in HC35 HDTR; do
#	for (( fhr = 0 ; fhr <= 126; fhr += 24)) ; do
#		for date in $(awk -F '/' '{print $9}' $f.$fhr) ; do
#			tmp_date=$(jdn $date)
#			(( tmp_date += fhr / 24.0 ))
#			v_date=$(gtime -s $tmp_date)
#			gfile=$GFS/gfs.${v_date:0:12}.mega_dom.grb
#			echo $gfile >> gfs_$f.$fhr
#		done
#	done
#done

for (( fhr = 0 ; fhr <= 126; fhr += 24)) ; do
	for line in $(<HC35.$fhr) ; do 
		date=$(echo $line | awk -F '/' '{print $9}')
		s_d=$(echo $line | awk -F '/' '{printf("%s/%s", $8, $9)}')
 echo $s_d
		hdtr=$(/bin/grep "$s_d" HDTR.$fhr)
		if [ "x$hdtr" != "x" ] ; then
			tmp_date=$(jdn $date)
			(( tmp_date += fhr / 24.0 ))
			v_date=$(gtime -s $tmp_date)
			gfile=$GFS/gfs.${v_date:0:12}.mega_dom.grb
			echo $gfile >> gfs_HC35_HDTR.$fhr
			echo $line >> HC35_c.$fhr
			echo $hdtr >> HDTR_c.$fhr
		fi
	done
done
