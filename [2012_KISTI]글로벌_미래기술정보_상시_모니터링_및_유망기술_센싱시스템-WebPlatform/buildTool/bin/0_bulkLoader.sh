# ========================================================================
# BulkLoader [홈 디렉토리]
#            [로딩할 소스 파일이 존재하는 디렉토리]
#            [로딩할 파일의 데이터 타입: 1-SCOPUS, 2-DWPI]
#            [비트리의 캐시 크기: 12개의 비트리가 존재, 1024*1024*64=67108864 이상 권장]
#            [압축파일 처리 여부: true-처리, false-스킵]
#			  [Scopus Data 파싱: true-새로운 데이터(2009년 1월), false-구 데이터]
# 파일을 BulkLoading 합니다.
# ========================================================================

HOME=../
LIB=.:$HOME/lib/mirian_loader.jar:$HOME/lib/tqk_common.jar:$HOME/lib/ojdbc14.jar:$HOME/lib/activation.jar:$HOME/lib/tar.jar
HOME_DIR=$HOME
SOURCE_DIR=/data/home/scopus/NAS_SCOPUS/scopus_tmp/raw_data
SOURCE_TYPE=1
TREE_CACHE_SIZE=67108864
LOADING_COMPRESS=true
NEW_SCOPUS_DATA=true
TARGET_DIR=/data/home/scopus/NAS_SCOPUS/scopus_tmp/tmp/target
WORK_DIR=/data/home/scopus/scopus/ScopusAtKisti_Parsing_Distribution/work

nohup java -server -Xms512m -Xmx1024m -classpath $LIB re.kisti.mirian.load.BulkLoader $HOME_DIR $SOURCE_DIR $SOURCE_TYPE $TREE_CACHE_SIZE $LOADING_COMPRESS $NEW_SCOPUS_DATA $TARGET_DIR $WORK_DIR & 

