#!/bin/ksh

THOMP=/scratch1/portfolios/BMC/dtc-hwrf/TNE_Thompson_MP/TNE_Thompson_MP_thompson/
GFS_FILES=/scratch1/portfolios/BMC/dtc-hwrf/Mrinal.Biswas/GFS_ANALYSIS



 while read GFS_ANA_FILES; do
          YYYYMMDDHH=`echo ${GFS_ANA_FILES} |cut -d/ -f8| cut -c5-14` 
#     if [[ -e "${MEGA_FILE}" && -e "${GFS_ANA}" ]] 
#       then 
#     echo ${GFS_ANA_FILES}
          gfs_line_nu=`grep ${YYYYMMDDHH} fcstfile|wc -l` 
          ana_line_nu=`grep ${YYYYMMDDHH} anafile|wc -l` 
       if [[ ${gfs_line_nu} -eq 1 && ${ana_line_nu} -eq 1 ]]; then 
          grep ${YYYYMMDDHH} anafile >>anafile_new
          grep ${YYYYMMDDHH} fcstfile >> fcstfile_new
       elif [[ ${gfs_line_nu} -eq 2 && ${ana_line_nu} -eq 1 ]]; then 
          grep ${YYYYMMDDHH} anafile >>anafile_new
          grep ${YYYYMMDDHH} anafile >>anafile_new
          grep ${YYYYMMDDHH} fcstfile >> fcstfile_new
       elif [[ ${gfs_line_nu} -eq 3 && ${ana_line_nu} -eq 1 ]]; then 
          grep ${YYYYMMDDHH} anafile >>anafile_new
          grep ${YYYYMMDDHH} anafile >>anafile_new
          grep ${YYYYMMDDHH} anafile >>anafile_new
          grep ${YYYYMMDDHH} fcstfile >> fcstfile_new
       elif [[ ${gfs_line_nu} -eq 4 && ${ana_line_nu} -eq 1 ]]; then 
          grep ${YYYYMMDDHH} anafile >>anafile_new
          grep ${YYYYMMDDHH} anafile >>anafile_new
          grep ${YYYYMMDDHH} anafile >>anafile_new
          grep ${YYYYMMDDHH} anafile >>anafile_new
          grep ${YYYYMMDDHH} fcstfile >> fcstfile_new
         
      fi
   done < anafile
