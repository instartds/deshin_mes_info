package foren.unilite.modules.accnt.agj;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

@Service("agj245skrService")
public class Agj245skrServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	
	/**
	 * 전표 조회 
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "Accnt", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectList(Map param) throws Exception {
		return (List) super.commonDao.list("agj245skrServiceImpl.selectList", param);
	}
	
	@ExtDirectMethod(group = "Accnt", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectList2(Map param) throws Exception {
		return (List) super.commonDao.list("agj245skrServiceImpl.selectList2", param);
	}
	/* 각주 조회 (전표조회 쿼리 실행)
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "accnt", value = ExtDirectMethodType.STORE_READ)
	public Object  getPostIt(Map param) throws Exception {
		return  super.commonDao.select("agj245skrServiceImpl.getPostIt", param);
	}
	
	/* 각주 수정(전표조회 쿼리 실행)
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "accnt", value = ExtDirectMethodType.STORE_READ)
	public Object  updatePostIt(Map param) throws Exception {
		return  super.commonDao.select("agj245skrServiceImpl.updatePostIt", param);
	}
	
	/* 각주 삭제(전표조회 쿼리 실행)
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "accnt", value = ExtDirectMethodType.STORE_READ)
	public Object  deletePostIt(Map param) throws Exception {
		return  super.commonDao.select("agj245skrServiceImpl.deletePostIt", param);
	}

}
