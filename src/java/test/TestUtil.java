package test;

import foren.framework.utils.ObjUtils;

public class TestUtil {

	
	public static void out(Object ... args ) {
		for(Object arg : args) {
			System.out.print(ObjUtils.getSafeString(arg));
			System.out.print(" ");
		}
		System.out.println(" ");
	}
}
