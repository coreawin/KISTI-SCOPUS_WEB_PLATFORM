package kr.co.tqk.analysis.loader;

import java.util.Iterator;

import com.tqk.ontobase.core.common.CoreException;
import com.tqk.ontobase.core.common.btree.BTree;
import com.tqk.ontobase.core.common.btree.BTreeNode;
import com.tqk.ontobase.core.util.array.ByteArrayUtil;
import com.tqk.ontobase.core.util.vector.ByteVector;

public class TreeIterator<K> implements Iterator<K> {

	private BTree btree = null;
	private BTreeNode node = null;
	int count = 0;

	public TreeIterator(BTree btree) {
		this.btree = btree;
		try {
			node = btree.getFirstLeafNode();
		} catch (CoreException e) {
			e.printStackTrace();
		}
	}

	/**
	 * 특정 키 이후부터 이터레이션을 생성한다.<br>
	 * 
	 * @param btree
	 * @param _nextKey
	 */
	public TreeIterator(BTree btree, String _nextKey) {
		this.btree = btree;
		try {
			byte[] key = ByteArrayUtil.stringToByte(_nextKey);
			node = btree.findNode(key, 0, key.length);
			count = node.moreThan(key, 0, key.length);
		} catch (CoreException e) {
			e.printStackTrace();
		}
	}

	public boolean hasNext() {
		if(count==-1) return false;
		if (count > node.getCount() - 1) {
			try {
				node = btree.loadNode(node.getLink());
				count = 0;
			} catch (CoreException e) {
				e.printStackTrace();
			}
		}
		if (node == null)
			return false;
		
		return true;
	}

	@SuppressWarnings("unchecked")
	public K next() {
		byte[] key = node.getKey(count++);
		if (key != null) {
			return (K) ByteArrayUtil.readString(key, 0, key.length);
		}
		return null;
	}

	public void remove() {

	}

}
