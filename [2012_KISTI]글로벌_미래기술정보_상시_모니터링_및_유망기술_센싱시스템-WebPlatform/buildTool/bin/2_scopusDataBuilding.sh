CONNECT=scopus/scopus+11@KISTI5
CONTROL_PATH=../control
DATA_PATH=/data/home/scopus/NAS_SCOPUS/scopus_tmp/tmp/target
LOADER_LOG_PATH=../log
LOADER_BAD_PATH=../bad

for fileNames in `ls -d $DATA_PATH/author.*`; do
     fileName=${fileNames/$DATA_PATH/}  
     echo sqlldr $CONNECT control=$CONTROL_PATH/author.ctl data=$fileNames bad=$LOADER_BAD_PATH/$fileName.bad log=$LOADER_LOG_PATH/$fileName.log direct=true;
     sqlldr $CONNECT control=$CONTROL_PATH/author.ctl data=$fileNames bad=$LOADER_BAD_PATH/$fileName.bad log=$LOADER_LOG_PATH/$fileName.log direct=true;
     
done 

for fileNames in `ls -d $DATA_PATH/document.*`; do
     fileName=${fileNames/$DATA_PATH/}  
     echo sqlldr $CONNECT control=$CONTROL_PATH/document.ctl data=$fileNames bad=$LOADER_BAD_PATH/$fileName.bad log=$LOADER_LOG_PATH/$fileName.log direct=true;
     sqlldr $CONNECT control=$CONTROL_PATH/document.ctl data=$fileNames bad=$LOADER_BAD_PATH/$fileName.bad log=$LOADER_LOG_PATH/$fileName.log direct=true;
     
done
 
for fileNames in `ls -d $DATA_PATH/documentStatus.*`; do
     fileName=${fileNames/$DATA_PATH/}  
     echo sqlldr $CONNECT control=$CONTROL_PATH/documentStatus.ctl data=$fileNames bad=$LOADER_BAD_PATH/$fileName.bad log=$LOADER_LOG_PATH/$fileName.log direct=true;
     sqlldr $CONNECT control=$CONTROL_PATH/documentStatus.ctl data=$fileNames bad=$LOADER_BAD_PATH/$fileName.bad log=$LOADER_LOG_PATH/$fileName.log direct=true;
     
done 

for fileNames in `ls -d $DATA_PATH/classificationOthers.*`; do
     fileName=${fileNames/$DATA_PATH/}  
     echo sqlldr $CONNECT control=$CONTROL_PATH/classificationOthers.ctl data=$fileNames bad=$LOADER_BAD_PATH/$fileName.bad log=$LOADER_LOG_PATH/$fileName.log direct=true;
     sqlldr $CONNECT control=$CONTROL_PATH/classificationOthers.ctl data=$fileNames bad=$LOADER_BAD_PATH/$fileName.bad log=$LOADER_LOG_PATH/$fileName.log direct=true;
     
done 

for fileNames in `ls -d $DATA_PATH/classificationAsjc.*`; do
     fileName=${fileNames/$DATA_PATH/}
     echo sqlldr $CONNECT control=$CONTROL_PATH/classificationAsjc.ctl data=$fileNames bad=$LOADER_BAD_PATH/$fileName.bad log=$LOADER_LOG_PATH/$fileName.log direct=true;
     sqlldr $CONNECT control=$CONTROL_PATH/classificationAsjc.ctl data=$fileNames bad=$LOADER_BAD_PATH/$fileName.bad log=$LOADER_LOG_PATH/$fileName.log direct=true errors=500000;
     
done

for fileNames in `ls -d $DATA_PATH/authorKeyword.*`; do
     fileName=${fileNames/$DATA_PATH/}  
     echo sqlldr $CONNECT control=$CONTROL_PATH/authorKeyword.ctl data=$fileNames bad=$LOADER_BAD_PATH/$fileName.bad log=$LOADER_LOG_PATH/$fileName.log direct=true;
     sqlldr $CONNECT control=$CONTROL_PATH/authorKeyword.ctl data=$fileNames bad=$LOADER_BAD_PATH/$fileName.bad log=$LOADER_LOG_PATH/$fileName.log direct=true;
     
done 


for fileNames in `ls -d $DATA_PATH/indexKeyword.*`; do
     fileName=${fileNames/$DATA_PATH/}  
     echo sqlldr $CONNECT control=$CONTROL_PATH/indexKeyword.ctl data=$fileNames bad=$LOADER_BAD_PATH/$fileName.bad log=$LOADER_LOG_PATH/$fileName.log direct=true;
     sqlldr $CONNECT control=$CONTROL_PATH/indexKeyword.ctl data=$fileNames bad=$LOADER_BAD_PATH/$fileName.bad log=$LOADER_LOG_PATH/$fileName.log direct=true;
     
done 


for fileNames in `ls -d $DATA_PATH/affilation.*`; do
     fileName=${fileNames/$DATA_PATH/}  
     echo sqlldr $CONNECT control=$CONTROL_PATH/affilation.ctl data=$fileNames bad=$LOADER_BAD_PATH/$fileName.bad log=$LOADER_LOG_PATH/$fileName.log direct=true;
     sqlldr $CONNECT control=$CONTROL_PATH/affilation.ctl data=$fileNames bad=$LOADER_BAD_PATH/$fileName.bad log=$LOADER_LOG_PATH/$fileName.log direct=true;
     
done 


for fileNames in `ls -d $DATA_PATH/authorGroup.*`; do
     fileName=${fileNames/$DATA_PATH/}  
     echo sqlldr $CONNECT control=$CONTROL_PATH/authorGroup.ctl data=$fileNames bad=$LOADER_BAD_PATH/$fileName.bad log=$LOADER_LOG_PATH/$fileName.log direct=true;
     sqlldr $CONNECT control=$CONTROL_PATH/authorGroup.ctl data=$fileNames bad=$LOADER_BAD_PATH/$fileName.bad log=$LOADER_LOG_PATH/$fileName.log direct=true;
     
done 


for fileNames in `ls -d $DATA_PATH/citation.*`; do
     fileName=${fileNames/$DATA_PATH/}  
     echo sqlldr $CONNECT control=$CONTROL_PATH/citation.ctl data=$fileNames bad=$LOADER_BAD_PATH/$fileName.bad log=$LOADER_LOG_PATH/$fileName.log direct=true;
     sqlldr $CONNECT control=$CONTROL_PATH/citation.ctl data=$fileNames bad=$LOADER_BAD_PATH/$fileName.bad log=$LOADER_LOG_PATH/$fileName.log direct=true;
     
done 


for fileNames in `ls -d $DATA_PATH/reference.*`; do
     fileName=${fileNames/$DATA_PATH/}  
     echo sqlldr $CONNECT control=$CONTROL_PATH/reference.ctl data=$fileNames bad=$LOADER_BAD_PATH/$fileName.bad log=$LOADER_LOG_PATH/$fileName.log direct=true errors=100000
     sqlldr $CONNECT control=$CONTROL_PATH/reference.ctl data=$fileNames bad=$LOADER_BAD_PATH/$fileName.bad log=$LOADER_LOG_PATH/$fileName.log direct=true errors=100000
     echo ping -c 20 -i 30 kr.yahoo.com
done 

for fileNames in `ls -d $DATA_PATH/correspondAuthor.*`; do
     fileName=${fileNames/$DATA_PATH/}  
     echo sqlldr $CONNECT control=$CONTROL_PATH/correspondAuthor.ctl data=$fileNames bad=$LOADER_BAD_PATH/$fileName.bad log=$LOADER_LOG_PATH/$fileName.log direct=true;
     sqlldr $CONNECT control=$CONTROL_PATH/correspondAuthor.ctl data=$fileNames bad=$LOADER_BAD_PATH/$fileName.bad log=$LOADER_LOG_PATH/$fileName.log direct=true;
     
done 

