CONNECT=scopus/scopus+11@KISTI_SCOPUS5
CONTROL_PATH=../control
DATA_PATH=../target
LOADER_LOG_PATH=../log
LOADER_BAD_PATH=../bad

for fileNames in `ls -d $DATA_PATH/authorSearch.*`; do
     fileName=${fileNames/.\/searchDataFile\//}
     echo sqlldr $CONNECT control=$CONTROL_PATH/authorSearch.ctl data=$fileNames bad=$LOADER_BAD_PATH/$fileName.bad log=$LOADER_LOG_PATH/$fileName.log direct=true;
     sqlldr $CONNECT control=$CONTROL_PATH/authorSearch.ctl data=$fileNames bad=$LOADER_BAD_PATH/$fileName.bad log=$LOADER_LOG_PATH/$fileName.log direct=true;
done 