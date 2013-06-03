package kr.co.tqk.analysis.loader;

public interface WrapTree {

	public void closeResource();

	public TreeIterator<String> getIterator();
}
