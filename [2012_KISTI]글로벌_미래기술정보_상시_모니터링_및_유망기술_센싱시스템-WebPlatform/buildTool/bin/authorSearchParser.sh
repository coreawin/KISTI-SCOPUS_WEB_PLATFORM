# ========================================================================
# CreateAuthorSearchData 
#            [파싱모듈로 생성된 authorIDInfo.txt 파일이 있는 디렉토리 경로 - authorSearch.txt가 만들어 지기도 하는 경로]
#            [임시 리파지터리 파일 생성 경로]
# 파싱이 완료된 저자 정보를 이용하여 저자 검색 색인 테이블을 생성할 데이터(authorSearch.txt)를 생성합니다.
# ========================================================================

HOME=../
CLASSPATH=.
for i in `ls ${HOME}lib/*.jar`
do
  CLASSPATH=${CLASSPATH}:${i}
done

AUTHOR_ID_INFO_FILE_DIR=/data/home/scopus/NAS_SCOPUS/scopus_tmp/tmp/target
TMP_REPOSITORY_DIR=_tmp

nohup java -server -Xms2g -Xmx3g -classpath $CLASSPATH re.kisti.mirian.load.search.CreateAuthorSearchData $AUTHOR_ID_INFO_FILE_DIR $TMP_REPOSITORY_DIR & 

