package foren.unilite.modules.base.bdc;

import java.util.List;
import java.util.Map;
import foren.framework.model.LoginVO;

public interface Bdc100ukrvService {

	/**
	 * 모든 타입의 데이타 입력
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public Integer  syncAll(Map param) throws Exception ;

	
	/**
	 * 통합 파일 관리 목록 조회
	 * @param param
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, Object>> selectList(Map param) throws Exception ;
	
	
	/**
	 * 조회수 Update
	 * @param param
	 * @param login
	 * @return
	 * @throws Exception
	 */
	public int updateReadCnt(Map param, LoginVO login) throws Exception ;


	/**
	 * 통합 파일 관리 데이타 신규 입력
	 * @param paramList
	 * @param login
	 * @return
	 * @throws Exception
	 */
	public List<Map>  insertMulti(List<Map> paramList, LoginVO login) throws Exception ;
	
	
	/**
	 *  통합 파일 관리 데이타 수정
	 * @param paramList
	 * @param login
	 * @return
	 * @throws Exception
	 */
	public List<Map>  updateMulti(List<Map> paramList, LoginVO login) throws Exception ;
	
	/**
	 *  통합 파일 관리 데이타 삭제
	 * @param paramList
	 * @param login
	 * @return
	 * @throws Exception
	 */
	public List<Map>  deleteMulti(List<Map> paramList,  LoginVO login) throws Exception ;
	
	/**
	 * 문서에 입력된 파일 목록
	 * @param param 
	 * @param login
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, Object>> getFileList(Map param,  LoginVO login) throws Exception ;
	
	/**
	 * 통합파일관리 대분류
	 * @param param
	 * @param login
	 * @return
	 * @throws Exception
	 */
	public List<Map>  getDocLevel1(Map param) throws Exception ;
	
	/**
	 * 통합파일관리 중분류
	 * @param param
	 * @param login
	 * @return
	 * @throws Exception
	 */
	public List<Map>  getDocLevel2(Map param) throws Exception ;
	
	/**
	 * 통합파일 관리 소분류
	 * @param param
	 * @param login
	 * @return
	 * @throws Exception
	 */
	public List<Map>  getDocLevel3(Map param) throws Exception ;
	
}
