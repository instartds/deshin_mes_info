package test;

import java.io.File;

public class FilePathTest {

    public static void main(String[] args)  throws Exception{
        
        TestUtil.out("File.separator" , File.separator);
        String fileName = "d:\\test\\test01.txt";
        test(fileName);
        fileName = "d:\\test\\t2\\..\\test01.txt";
        test(fileName);
    }
    
    private static  void test(String fileName) throws Exception {
        File file = new File(fileName);
        TestUtil.out("=====" , fileName);
        TestUtil.out(" file.getName()",  file.getName());
        TestUtil.out(" file.getName()",  file.getName());
        TestUtil.out(" file.getParent()",  file.getParent());
        TestUtil.out(" file.getCanonicalFile().getParent()",  file.getCanonicalFile().getParent());
        TestUtil.out(" file.getPath()",  file.getPath());
        TestUtil.out(" file.getAbsolutePath()",  file.getAbsolutePath());
        TestUtil.out(" file.getCanonicalPath()",  file.getCanonicalPath());
    }
    
    
}
