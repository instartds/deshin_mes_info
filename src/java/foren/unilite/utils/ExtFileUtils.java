package foren.unilite.utils;

import java.io.File;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import foren.framework.utils.FileUtil;

public class ExtFileUtils extends FileUtil {
    private static final Log logger = LogFactory.getLog(FileUtil.class);
    
    /**
     * 파일을 삭제 한다.
     * 
     * @param path 폴더명
     * @param fileName 파일명
     * @return 삭제 여부
     */
    public static boolean delFile( String fullFilePath ) {
        boolean res = false;
        try {
            File file = new File(fullFilePath);
            if(file.exists()) {
                res = file.delete();
                logger.debug("delete file in path : '" + fullFilePath + "' is " + res + ".");
            } else {
                logger.debug("파일을 찾을 수 없습니다.");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        return res;
    }
    
    public static void main(String[] args) {
        String filePath = "c:\\home\\asmanager\\OmegaPlus\\upload\\csv\\015b6c31327d442c69fd201cb0000000.bin";
        ExtFileUtils.delFile(filePath);
    }
}
