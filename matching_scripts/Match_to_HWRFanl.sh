#!/bin/ksh

#THP=/scratch1/portfolios/BMC/dtc-hwrf/TNE_Thompson_MP/TNE_Thompson_MP_thompson/
#GFS=/scratch1/portfolios/BMC/dtc-hwrf/Mrinal.Biswas/GFS_ANALYSIS
#CTL=/scratch1/portfolios/BMC/dtc-hwrf/TNE_Thompson_MP/TNE_Thompson_MP_control/

set -x
HDGF=/pan2/projects/dtc-hurr/Christina.Holt/TNE_RRTMG_PCl/MET_anl/HWRF_data/HDGF
HDRF=/pan2/projects/dtc-hurr/Christina.Holt/TNE_RRTMG_PCl/MET_anl/HWRF_data/HDRF
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
rm hwrf_vx_filelist/*filelist.f*

#for expt in $HDRF $HDGF ; do
for expt in $HDRF ; do
   for HWRF_ANL in `ls $expt/*/*/ -d` ; do
       exname=`echo ${expt} | rev | cut -c 1-4 | rev`
       sid=`echo ${HWRF_ANL} | rev | cut -c 2-4 | rev`
       anl_time=`echo ${HWRF_ANL} | rev | cut -c 6-15 | rev`
       if [[ -e ${HWRF_ANL}/d01_mega_025.f120 ]] ; then
       for (( fhr = 24 ; fhr <= 126; fhr += 24 )) ; do
          if [[ $fhr -lt 10 ]] ; then ; fhr=0$fhr ; fi
          valid_time=`~/bin/ndate.exe $fhr ${anl_time}`

	# If both the forecast and analysis file exist....
	  if [[ -e ${HWRF_ANL}/d01_mega_025.f${fhr} ]] && [[ -e ${expt}/${valid_time}/${sid}/d01_mega_025.f00 ]] ; then
              anl=`wgrib`
                  echo ${HWRF_ANL}/d01_mega_025.f${fhr} >> hwrf_vx_filelist/${exname}_fcst_filelist.f$fhr  
                  echo ${expt}/${valid_time}/${sid}/d01_mega_025.f00 >> hwrf_vx_filelist/${exname}_anl_filelist.f$fhr  
          fi
       done
       fi
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
