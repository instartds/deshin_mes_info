package foren.unilite.modules.human.hpb;

import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;

@Service("hpb400rkrService")
@SuppressWarnings({ "rawtypes", "unchecked" })
public class Hpb400rkrServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());


	/**
	 * 거주자 사업소득(발행자보고용) - 20200810 추가
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "hpb")
	public List<Map<String, Object>> selectList1( Map param ) throws Exception {
		return super.commonDao.list("hpb400rkrService.selectList1", param);
	}
	//거주자 사업소득(발행자보고용): sub_report1 - 20200810 추가
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "hpb")
	public List<Map<String, Object>> selectList1sub1( Map param ) throws Exception {
		return super.commonDao.list("hpb400rkrService.selectList1sub1", param);
	}
	//거주자 사업소득(발행자보고용): sub_report2 - 20200810 추가
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "hpb")
	public List<Map<String, Object>> selectList1sub2( Map param ) throws Exception {
		return super.commonDao.list("hpb400rkrService.selectList1sub2", param);
	}

	/**
	 * 거주자 사업소득(소득자/발행자보관용) - 20200810 추가
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "hpb")
	public List<Map<String, Object>> selectList2( Map param ) throws Exception {
		return super.commonDao.list("hpb400rkrService.selectList2", param);
	}




	/**
	 * 거주자 기타소득(발행자보고용) - 20200810 추가
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "hpb")
	public List<Map<String, Object>> selectList3( Map param ) throws Exception {
		return super.commonDao.list("hpb400rkrService.selectList3", param);
	}
	//거주자 기타소득(발행자보고용): sub_report1 - 20200810 추가
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "hpb")
	public List<Map<String, Object>> selectList3sub1( Map param ) throws Exception {
		return super.commonDao.list("hpb400rkrService.selectList3sub1", param);
	}
	//거주자 기타소득(발행자보고용): sub_report2 - 20200810 추가
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "hpb")
	public List<Map<String, Object>> selectList3sub2( Map param ) throws Exception {
		return super.commonDao.list("hpb400rkrService.selectList3sub2", param);
	}

	/**
	 * 거주자 기타소득(소득자/발행자보관용) - 20200810 추가
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "hpb")
	public List<Map<String, Object>> selectList4( Map param ) throws Exception {
		return super.commonDao.list("hpb400rkrService.selectList4", param);
	}




	/**
	 * 비거주자 사업기타소득(발행자보고용) - 20200810 추가
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "hpb")
	public List<Map<String, Object>> selectList5( Map param ) throws Exception {
		return super.commonDao.list("hpb400rkrService.selectList5", param);
	}
	//비거주자 사업기타소득(발행자보고용): sub_report1 - 20200810 추가
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "hpb")
	public List<Map<String, Object>> selectList5sub1( Map param ) throws Exception {
		return super.commonDao.list("hpb400rkrService.selectList5sub1", param);
	}
	//비거주자 사업기타소득(발행자보고용): sub_report2 - 20200810 추가
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "hpb")
	public List<Map<String, Object>> selectList5sub2( Map param ) throws Exception {
		return super.commonDao.list("hpb400rkrService.selectList5sub2", param);
	}

	/**
	 * 비거주자 사업기타소득(소득자/발행자보관용) - 20200810 추가
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "hpb")
	public List<Map<String, Object>> selectList7( Map param ) throws Exception {
		return super.commonDao.list("hpb400rkrService.selectList7", param);
	}




	/**
	 * 사업기타소득 > 소득별지급조서출력 > 이자배당소득 마스터
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "hpb")
	public List<Map<String, Object>> selectList6Header( Map param ) throws Exception {
		return super.commonDao.list("hpb400rkrService.selectList6Header", param);
	}

	/**
	 * 사업기타소득 > 소득별지급조서출력 > 이자배당소득 디테일
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "hpb")
	public List<Map<String, Object>> selectList6( Map param ) throws Exception {
		return super.commonDao.list("hpb400rkrService.selectList6", param);
	}




	/**
	 * 지급일자별 집계표 출력 - 20200807 추가
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_READ, group = "hpb")
	public List<Map<String, Object>> selectList8( Map param ) throws Exception {
		return super.commonDao.list("hpb400rkrService.selectList8", param);
	}
}