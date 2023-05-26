package foren.unilite.modules.accnt.aisc;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

@Service("aisc115skrvService")
public class Aisc115skrvServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());

	@ExtDirectMethod(group = "Accnt", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectList(Map param) throws Exception {
		String[] dprYymmList = new String[12];
		for(int i=0 ; i <12 ; i++)	{
			if(i < 9)	{
				dprYymmList[i]= param.get("DPR_YEAR") + "0" + String.valueOf(i+1);
			} else {
				dprYymmList[i]= param.get("DPR_YEAR") + String.valueOf(i+1);
			}
		}
		param.put("DPR_YYMM_LIST", dprYymmList);
		return (List) super.commonDao.list("aisc115skrvServiceImpl.selectList", param);
	}

}

