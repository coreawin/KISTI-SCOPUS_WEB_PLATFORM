# ========================================================================
# BulkLoader [Ȩ ���丮]
#            [�ε��� �ҽ� ������ �����ϴ� ���丮]
#            [�ε��� ������ ������ Ÿ��: 1-SCOPUS, 2-DWPI]
#            [��Ʈ���� ĳ�� ũ��: 12���� ��Ʈ���� ����, 1024*1024*64=67108864 �̻� ����]
#            [�������� ó�� ����: true-ó��, false-��ŵ]
#			  [Scopus Data �Ľ�: true-���ο� ������(2009�� 1��), false-�� ������]
# ������ BulkLoading �մϴ�.
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

