package foren.unilite.modules.pos.pos;


import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.sql.Blob;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.imageio.ImageIO;

import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.model.LoginVO;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;



@Service("pos101skrvService")
public class Pos101skrvServiceImpl  extends TlabAbstractServiceImpl {

	/**
	 * 
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "ssd")
	public List<Map<String, Object>>  selectsaleList(Map param) throws Exception {
	
		return  super.commonDao.list("pos101skrvServiceImpl.selectsaleList", param);
	}
	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "ssd")
	public List<Map<String, Object>>  selectpayList(Map param) throws Exception {
	
		return  super.commonDao.list("pos101skrvServiceImpl.selectpayList", param);
	}
	
	public File  getSign(Map param, LoginVO user) throws Exception	{
		param.put("S_COMP_CODE", user.getCompCode());
		Map<String, Object> r = (Map<String, Object>)super.commonDao.select("pos101skrvServiceImpl.getSign", param);
		//Blob immAsBlob = (Blob)r.get("SIGN_DATA");
		File sign = File.createTempFile(param.get("COLLECT_NUM").toString(), ".JPG");
		FileOutputStream oImg = new FileOutputStream(sign);
		oImg.write((byte[])r.get("SIGN_DATA"));
		oImg.flush();
		oImg.close();
		return  sign;
		
}
	
}
