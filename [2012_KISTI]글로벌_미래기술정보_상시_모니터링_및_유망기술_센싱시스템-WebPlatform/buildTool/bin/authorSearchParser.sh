# ========================================================================
# CreateAuthorSearchData 
#            [�Ľ̸��� ������ authorIDInfo.txt ������ �ִ� ���丮 ��� - authorSearch.txt�� ����� ���⵵ �ϴ� ���]
#            [�ӽ� �������͸� ���� ���� ���]
# �Ľ��� �Ϸ�� ���� ������ �̿��Ͽ� ���� �˻� ���� ���̺��� ������ ������(authorSearch.txt)�� �����մϴ�.
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

