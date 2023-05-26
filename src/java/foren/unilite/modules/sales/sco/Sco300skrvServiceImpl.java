package foren.unilite.modules.sales.sco;

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

@Service("sco300skrvService")
public class Sco300skrvServiceImpl  extends TlabAbstractServiceImpl {

	/**
	 * 수금현황 조회 : 그리드 조회 목록
	 * @param param 검색항목
	 * @return
	 * @throws Exception
	 */	
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "ssa")
	public List<Map<String, Object>>  selectList(Map param) throws Exception {
		
		return  super.commonDao.list("sco300skrvServiceImpl.selectList", param);
	}

	public File  getSign(Map param, LoginVO user) throws Exception	{
			param.put("S_COMP_CODE", user.getCompCode());
			Map<String, Object> r = (Map<String, Object>)super.commonDao.select("sco300skrvServiceImpl.getSign", param);
			//Blob immAsBlob = (Blob)r.get("SIGN_DATA");
			File sign = File.createTempFile(param.get("COLLECT_NUM").toString(), ".JPG");
			FileOutputStream oImg = new FileOutputStream(sign);
			oImg.write((byte[])r.get("SIGN_DATA"));
			oImg.flush();
			oImg.close();
			return  sign;
			
	}
}
