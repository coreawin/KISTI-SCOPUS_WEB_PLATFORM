# ========================================================================
# CreateAffilationSearchData 
#            [�Ľ̸��� ������ affilation.txt ������ �ִ� ���丮 ��� - - affilationSearch.txt�� ����� ���⵵ �ϴ� ���]
#            [�ӽ� �������͸� ���� ���� ���]
# �Ľ��� �Ϸ�� ��� ������ �̿��Ͽ� ��� �˻� ���� ���̺��� ������ ������(affilationSearch.txt)�� �����մϴ�.
# ========================================================================

HOME=../
CLASSPATH=.
for i in `ls ${HOME}lib/*.jar`
do
  CLASSPATH=${CLASSPATH}:${i}
done

AUTHOR_ID_INFO_FILE_DIR=/data/home/scopus/NAS_SCOPUS/scopus_tmp/tmp/target
TMP_REPOSITORY_DIR=./tmp/

nohup java -server -Xms2g -Xmx3g -classpath $CLASSPATH re.kisti.mirian.load.search.CreateAffilationSearchData $AUTHOR_ID_INFO_FILE_DIR $TMP_REPOSITORY_DIR & 

