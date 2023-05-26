package foren.unilite.modules.human;

import java.io.File;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import foren.framework.utils.ConfigUtil;

public class HumanUtils {
	public static   Logger	logger	= LoggerFactory.getLogger(HumanUtils.class);
	public final static String FILE_TYPE_OF_PHOTO = "employeePhoto";
	
	/**
	 * 사번으로 img파일 가져 오기
	 * @param personNumb
	 * @return
	 */
	public static File getHumanPhoto(String personNumb) {
		String path = ConfigUtil.getUploadBasePath(FILE_TYPE_OF_PHOTO);
		logger.debug("Get HumanPhoto {}.jpg from  {}", personNumb, path );
		File photo = new File(path, personNumb+".jpg");
		
		return photo;
	}
}
