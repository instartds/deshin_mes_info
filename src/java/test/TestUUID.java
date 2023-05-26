package test;

import foren.framework.lib.uuid.GrouponUUID;

public class TestUUID {
	public static void main(String[] args) {
		// creating UUID

		// checking the value of random UUID
		//LocUUID.useSequentialIds();
		GrouponUUID uuid = null;// new GrouponUUID();
		for (int i = 0; i < 10; i++) {
			uuid = new GrouponUUID();
			System.out.println(i + " UUID value: " + uuid + " : " + uuid.getTimeOrderUUID());
		}
	}
}
