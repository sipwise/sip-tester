#!/bin/ksh

scriptName=${0##*/}

# Packaging
if [ `uname -s` = "Linux" ]
then 
  if [ -f /usr/bin/dpkg ]
  then
    TARGET_FORMAT="deb"
  else
    TARGET_FORMAT="rpm"
  fi
else
  TARGET_FORMAT="depot"
fi

#NAME_LIST="pcapplay-ossl"

LIST_DIRECTORY=sipp-epm-list
PROJECT_NAME=sipp
PROJECT_VERSION=3.2
TARGET_NAME=$1

echo "****** ${TARGET_FORMAT}"
echo "****** ${PROJECT_NAME}"
echo "****** ${PROJECT_VERSION}"


case ${TARGET_FORMAT} in 
   deb | rpm )
     TOOL_FORMAT=${TARGET_FORMAT}
     TOOL_SYSTEM=linux
     LIBPCAP_NAME=libpcap
   ;;

   depot)
     TOOL_FORMAT=swinstall
     TOOL_SYSTEM=hpux
     LIBPCAP_NAME=ixLibpcap
   ;;

   *)
     echo "Unknown [${TARGET_FORMAT}]"
     exit 1
     ;;

esac


#for target_name in ${NAME_LIST}
#do

  if test ! -f ${PROJECT_NAME}-${TARGET_NAME}.list
  then
     cat ${LIST_DIRECTORY}/${PROJECT_NAME}-${TARGET_NAME}.list | \
	  sed -e 's/tool-version/'${PROJECT_VERSION}'/' | \
	  sed -e 's/tool-format/'${TOOL_FORMAT}'/' | \
	  sed -e 's/tool-system/'${TOOL_SYSTEM}'/' | \
          sed -e 's/pcap/'${LIBPCAP_NAME}'/' | \
	  sed -e 's/build-version/build-'${PROJECT_VERSION}'/g' > ${PROJECT_NAME}-${TARGET_NAME}.list
  fi

  epm -vv -f ${TOOL_FORMAT} ${PROJECT_NAME}-${TARGET_NAME}

#done

