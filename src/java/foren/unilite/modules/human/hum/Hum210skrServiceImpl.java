package foren.unilite.modules.human.hum;

import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;


@Service("hum210skrService")
public class Hum210skrServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	
	
	@ExtDirectMethod(group = "hum")
	public List<Map<String, Object>> selectList1(Map param) throws Exception {
		String arr[] = param.toString().split(",");		
		for(int i=0;i<arr.length;i++){
			System.out.println(arr[i]);
		}
		return (List) super.commonDao.list("hum210skrServiceImpl.selectList1", param);
	}
	
	@ExtDirectMethod(group = "hum")
	public List<Map<String, Object>> selectList2(Map param) throws Exception {
		String arr[] = param.toString().split(",");		
		for(int i=0;i<arr.length;i++){
			System.out.println(arr[i]);
		}
		return (List) super.commonDao.list("hum210skrServiceImpl.selectList2", param);
	}
	
	@ExtDirectMethod(group = "hum")
	public List<Map<String, Object>> selectList3(Map param) throws Exception {
		String arr[] = param.toString().split(",");		
		for(int i=0;i<arr.length;i++){
			System.out.println(arr[i]);
		}
		return (List) super.commonDao.list("hum210skrServiceImpl.selectList3", param);
	}
	
	@ExtDirectMethod(group = "hum")
	public List<Map<String, Object>> selectList4(Map param) throws Exception {
		String arr[] = param.toString().split(",");		
		for(int i=0;i<arr.length;i++){
			System.out.println(arr[i]);
		}
		return (List) super.commonDao.list("hum210skrServiceImpl.selectList4", param);
	}
	
	@ExtDirectMethod(group = "hum")
	public List<Map<String, Object>> selectList5(Map param) throws Exception {
		String arr[] = param.toString().split(",");		
		for(int i=0;i<arr.length;i++){
			System.out.println(arr[i]);
		}
		return (List) super.commonDao.list("hum210skrServiceImpl.selectList5", param);
	}
	
	@ExtDirectMethod(group = "hum")
	public List<Map<String, Object>> selectList6(Map param) throws Exception {
		String arr[] = param.toString().split(",");		
		for(int i=0;i<arr.length;i++){
			System.out.println(arr[i]);
		}
		return (List) super.commonDao.list("hum210skrServiceImpl.selectList6", param);
	}
	
	
}
