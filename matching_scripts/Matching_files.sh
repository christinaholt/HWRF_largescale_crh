#!/bin/ksh

#THP=/scratch1/portfolios/BMC/dtc-hwrf/TNE_Thompson_MP/TNE_Thompson_MP_thompson/
#GFS=/scratch1/portfolios/BMC/dtc-hwrf/Mrinal.Biswas/GFS_ANALYSIS
#CTL=/scratch1/portfolios/BMC/dtc-hwrf/TNE_Thompson_MP/TNE_Thompson_MP_control/

set -x
HDGF=/pan2/projects/dtc-hurr/Christina.Holt/TNE_RRTMG_PCl/MET_anl/HWRF_data/HDGF/
HDRF=/pan2/projects/dtc-hurr/Christina.Holt/TNE_RRTMG_PCl/MET_anl/HWRF_data/HDRF/
GFS=/pan2/projects/dtc-hurr/Christina.Holt/TNE_RRTMG_PCl/MET_anl/GFS_data

# Create the analysis


#VARS=( HGT TMP RH SPFH UGRD VGRD WIND )
#VARS=( UGRD VGRD )
#VARS=( PRMSL )
#VARS=( SPFH TMP  )
#LEVS=(1000 850 700 500 250)
#LEVS=(700 500 250)
#LEVS=( MSL )
LEVS=( 1000 )

#rm filelists/*filelist.f*
#rm filelists/*SPFH_2_* filelists/*TMP_2_*
#rm filelists/*GRD_10_*
#rm filelists/*MSLP_*
rm filelists/*_1000_*

for expt in $HDRF $HDGF ; do
   for HWRF_ANL in `ls $expt/*/*/ -d` ; do
       if [[ $expt = $HDRF ]] ; then
          exname=HDRF
       elif [[ $expt = $HDGF ]] ; then
          exname=HDGF
       fi
       anl_time=`echo $HWRF_ANL | rev | cut -c 6-15 | rev`
       for (( fhr = 0 ; fhr <= 126; fhr += 24 )) ; do
          if [[ $fhr -lt 10 ]] ; then ; fhr=0$fhr ; fi
          valid_time=`~/bin/ndate.exe $fhr ${anl_time}`
          if [[ -e $GFS/${valid_time}/gfs.${valid_time}.mega_025.f00 ]] && [[ -e ${HWRF_ANL}/d01_mega_025.f${fhr} ]] ; then
            for var in ${VARS[@]} ; do 
             for lev in ${LEVS[@]} ; do
             hwrf_yes=1
	     gfs_yes=1
             if [[ -z `wgrib $GFS/${valid_time}/gfs.${valid_time}.mega_025.f00 | grep $var | grep "$lev" ` ]] ; then ; gfs_yes=0 ; fi
             if [[ -z `wgrib ${HWRF_ANL}/d01_mega_025.f${fhr} | grep $var | grep "$lev" ` ]] ; then ; hwrf_yes=0 ; fi
  	     if [[ ( ${hwrf_yes} -ne 0 ) && ( ${gfs_yes} -ne 0 ) ]]; then
             echo ${HWRF_ANL}/d01_mega_025.f$fhr >> filelists/${exname}_${var}_${lev}_filelist.f${fhr}
             echo $GFS/${valid_time}/gfs.${valid_time}.mega_025.f00 >> filelists/GFS_${exname}_${var}_${lev}_filelist.f${fhr}
#             echo ${HWRF_ANL}/d01_mega_025.f$fhr >> filelists/${exname}_${var}_filelist.f${fhr}
#             echo $GFS/${valid_time}/gfs.${valid_time}.mega_025.f00 >> filelists/GFS_${exname}_${var}_filelist.f${fhr}
	     if [[ -e $GFS/${valid_time}/gfs.${valid_time}.mega_025.f00 && -e ${HWRF_ANL}/d01_mega_025.f${fhr} && -e $GFS/${anl_time}/gfs.${anl_time}.mega_025.f${fhr} ]] ; then 
                  echo $GFS/${anl_time}/gfs.${anl_time}.mega_025.f${fhr} >> filelists/GFS_GFS_${var}_filelist.f${fhr}	
                  echo $GFS/${valid_time}/gfs.${valid_time}.mega_025.f00 >> filelists/GFS_${var}_filelist.f${fhr}	
	     fi
             fi
	     done
            done
          fi
       done
   done

done
#for GFS_ANA in `ls ${GFS_FILES}/gfs.2012*00.mega_dom.grb` ; do
#	echo $GFS_ANA >>anafile
#done 
#for FHR in 000 ; do
#	for MEGA_FILE in `ls $THOMP/???/20*/postprd/${FHR}/d01_mega_025_sel.${FHR}` ; do
#		echo $MEGA_FILE >>thompson.${FHR}
#	done 
#done 
