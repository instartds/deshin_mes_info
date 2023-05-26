package foren.unilite.modules.equip.eqt;

import java.awt.image.BufferedImage;
import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.imageio.ImageIO;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import ch.ralscha.extdirectspring.annotation.ExtDirectMethod;
import ch.ralscha.extdirectspring.annotation.ExtDirectMethodType;
import ch.ralscha.extdirectspring.bean.ExtDirectFormPostResult;
import foren.framework.extjs.UniliteExtjsUtils;
import foren.framework.model.LoginVO;
import foren.framework.utils.ConfigUtil;
import foren.framework.utils.FileUtil;
import foren.framework.utils.ObjUtils;
import foren.unilite.com.service.impl.TlabAbstractServiceImpl;
import foren.unilite.com.validator.UniDirectValidateException;
import foren.unilite.modules.base.bdc.Bdc100ukrvService;
import foren.unilite.modules.com.fileman.FileMnagerService;
import foren.unilite.modules.crm.cmd.Cmd100ukrvModel;
import foren.unilite.modules.equip.equ.Equ200ukvrModel;
import foren.unilite.modules.human.hum.HumController;

@Service("eqt300ukrvService")
public class Eqt300ukrvServiceImpl extends TlabAbstractServiceImpl {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	/**
	 *
	 * 출하지시정보검색 조회(Master)
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "equit", value = ExtDirectMethodType.FORM_LOAD)
	public Map<String, Object> selectOrderNumMaster(Map param) throws Exception {
		if(param.get("page")!=null)
		{
	    	if(param.get("page").equals("prev"))
	    	{
	    		return this.prevOrderNumMaster(param);
	    	}else if(param.get("page").equals("next")) {
	    		return this.nextOrderNumMaster(param);
	    	}
		}

		return (Map<String, Object>) super.commonDao.select("eqt300ukrvServiceImpl.selectOrderNumMaster", param);
	}
	@ExtDirectMethod(group = "equit", value = ExtDirectMethodType.FORM_LOAD)
	public Map<String, Object> prevOrderNumMaster(Map param) throws Exception {
		param.put("EQU_CODE", param.get("EQU_CODE") == "" || param.get("EQU_CODE") == null ? "ZZZZZZZZZZZZZZ" : param.get("EQU_CODE"));
		return (Map<String, Object>) super.commonDao.select("eqt300ukrvServiceImpl.prevOrderNumMaster", param);
	}
	@ExtDirectMethod(group = "equit", value = ExtDirectMethodType.FORM_LOAD)
	public Map<String, Object> nextOrderNumMaster(Map param) throws Exception {
		param.put("EQU_CODE", param.get("EQU_CODE") == "" || param.get("EQU_CODE") == null ? "ZZZZZZZZZZZZZZ" : param.get("EQU_CODE"));
		return (Map<String, Object>) super.commonDao.select("eqt300ukrvServiceImpl.nextOrderNumMaster", param);
	}
	@ExtDirectMethod(group = "equit", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectMasterList3(Map param,HttpServletRequest request,HttpServletResponse response) throws Exception {
		//HttpSession seesion = request.getSession();

        List<Map<String, Object>> photo=super.commonDao.list("eqt300ukrvServiceImpl.selectMasterList3", param);
       /* String imagePath = (ConfigUtil.getUploadBasePath(HumController.FILE_TYPE_OF_PHOTO) + File.separator).replace("\\", "/");
        File directory = new File(imagePath);
		if (!directory.exists()) {
			directory.mkdirs();
		}
	    for (Map<String, Object> map : photo) {
	    	map.put("IMAGE_PATH", imagePath);
	    	StringBuffer sb=new StringBuffer();
	    	sb.append(map.get("COMP_CODE").toString());
	    	sb.append("_"+map.get("DIV_CODE").toString());
	    	sb.append("_"+map.get("EQU_CODE").toString()+"_"+map.get("SER_NO").toString()+".jpg");
	    	String fileName = sb.toString();
        	File imagefile = new File(imagePath+fileName);
        	if (!imagefile.exists()) {
    			if(map.get("IMG_DATA")!=null&&!map.get("IMG_DATA").equals("")){
 	         	   try {
 	                    byte[] bytes = (byte[]) map.get("IMG_DATA");
 	                    ByteArrayInputStream bais = new ByteArrayInputStream(bytes);
 	                    BufferedImage bi =ImageIO.read(bais);
 	                    File file = new File(imagePath,fileName);//可以是jpg,png,gif格式
 	                    if(bi != null){
 	           				ImageIO.write(bi, "jpg", file);
 	           			}
 	                    map.put("IMG_DATA", fileName);
 	                } catch (IOException e) {
 	                    e.printStackTrace();
 	                }
             	}else{
             		map.put("IMG_DATA", null);
             	}
    		}else{
    			map.put("IMG_DATA", fileName);
    		}
		}*/
        return photo;
	}

	@ExtDirectMethod(group = "equit", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectMasterList4(Map param,HttpServletRequest request,HttpServletResponse response) throws Exception {
		//HttpSession seesion = request.getSession();
        List<Map<String, Object>> photo=super.commonDao.list("eqt300ukrvServiceImpl.selectMasterList4", param);
        return photo;
	}

	/**
	 *
	 *
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "equit", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectMasterList(Map param) throws Exception {
		return super.commonDao.list("eqt300ukrvServiceImpl.selectMasterList", param);
	}


	/**
	 *
	 *
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "equit", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> selectMasterList2(Map param) throws Exception {
		return super.commonDao.list("eqt300ukrvServiceImpl.selectMasterList2", param);
	}

	/**
	 * 장비일상점검등록(eqt200ukrv)
	 * @param paramList	리스트의 create, update, destroy 오퍼레이션별 정보
	 * @param paramMaster 폼(마스터 정보)의 기본 정보
	 * @return 전달받은 파라미터 data 를 갱신하여 돌려준다.
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "equit")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public List<Map> saveAll(List<Map> paramList,  Map paramMaster, LoginVO user) throws Exception {
		logger.debug("[saveAll] paramDetail:" + paramList);
		//출하지시 마스터 출하지시 번호 update
		Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");
		//1.로그테이블에서 사용할 KeyValue 생성
		String keyValue = getLogKey();

		//2.출하지시 로그테이블에 KEY_VALUE, OPR_FLAG 업데이트
		List<Map> dataList = new ArrayList<Map>();
		List<List<Map>> resultList = new ArrayList<List<Map>>();

		for(Map paramData: paramList) {

			dataList = (List<Map>) paramData.get("data");
			String oprFlag = "N";
			if(paramData.get("method").equals("insertMaster"))	oprFlag="N";
			if(paramData.get("method").equals("updateMaster"))	oprFlag="U";
			if(paramData.get("method").equals("deleteMaster"))	oprFlag="D";

			for(Map param:  dataList) {
				param.put("KEY_VALUE", keyValue);
				param.put("OPR_FLAG", oprFlag);
//				if ("N".equals(oprFlag)){   //check ISSUE_REQ_SEQ
//					int issReqSeq  = Integer.parseInt(param.get("ISSUE_REQ_SEQ").toString());
//					Map checkReqSeq = (Map) super.commonDao.select("eqt200ukrvServiceImpl.chkReqSeq",param);
//					if (ObjUtils.isNotEmpty(checkReqSeq)){
//						Map getMaxReqSeq = (Map) super.commonDao.select("eqt200ukrvServiceImpl.getMaxReqSeq",param);
//						issReqSeq = Integer.parseInt(getMaxReqSeq.get("MAX_REQ_SEQ").toString());
//						param.put("ISSUE_REQ_SEQ", getMaxReqSeq);
//					}
//				}
				if(dataMaster.get("TYPE")!=null) {
					if(dataMaster.get("TYPE").equals("A"))
					{
						//L_EQT200T
						param.put("data", super.commonDao.insert("eqt300ukrvServiceImpl.insertLogDetail", param));
					}else if (dataMaster.get("TYPE").equals("B")) {
						//L_EQR200T
						param.put("data", super.commonDao.insert("eqt300ukrvServiceImpl.insertLogDetail2", param));
					}else if (dataMaster.get("TYPE").equals("C")) {
						if(oprFlag.equals("N")){
						//EQR210T
						param.put("data", super.commonDao.insert("eqt300ukrvServiceImpl.insertImage", param));
						}else if(oprFlag.equals("U")){
							//EQR210T
							param.put("data", super.commonDao.insert("eqt300ukrvServiceImpl.deleteImage", param));
						}else if(oprFlag.equals("D")){

						}
					}
				}
			}
		}

		//4.출하지시저장 Stored Procedure 실행
		Map<String, Object> spParam = new HashMap<String, Object>();

		spParam.put("KeyValue", keyValue);
		spParam.put("LangCode", user.getLanguage());
		spParam.put("Type", dataMaster.get("TYPE"));

		super.commonDao.queryForObject("eqt300ukrvServiceImpl.spequitEqt300save", spParam);

		String errorDesc = ObjUtils.getSafeString(spParam.get("ErrorDesc"));



		if(!errorDesc.isEmpty()){
			dataMaster.put("ISSUE_REQ_NUM", "");
			String[] messsage = errorDesc.split(";");
		    throw new  UniDirectValidateException(this.getMessage(messsage[0], user)+ (messsage.length>1?messsage[1]:""));
		} else {
			dataMaster.put("ISSUE_REQ_NUM", ObjUtils.getSafeString(spParam.get("IssueReqNum")));
		}

		paramList.add(0, paramMaster);

		return  paramList;
	}
	/**
	 * 模具图片信息存储
	 * @param paramList	리스트의 create, update, destroy 오퍼레이션별 정보
	 * @param paramMaster 폼(마스터 정보)의 기본 정보
	 * @return 전달받은 파라미터 data 를 갱신하여 돌려준다.
	 * @throws Exception
	 */
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "equit")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public List<Map> saveAll2(List<Map> paramList,  Map paramMaster, LoginVO user) throws Exception {
		logger.debug("[saveAll] paramDetail:" + paramList);
		//출하지시 마스터 출하지시 번호 update
		Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");
		//1.로그테이블에서 사용할 KeyValue 생성
		String keyValue = getLogKey();

		//2.출하지시 로그테이블에 KEY_VALUE, OPR_FLAG 업데이트
		List<Map> dataList = new ArrayList<Map>();
		List<List<Map>> resultList = new ArrayList<List<Map>>();

		for(Map paramData: paramList) {

			dataList = (List<Map>) paramData.get("data");
			String oprFlag = "N";
			if(paramData.get("method").equals("insertImage"))	oprFlag="N";
			if(paramData.get("method").equals("updateImage"))	oprFlag="U";
			if(paramData.get("method").equals("deleteImage"))	oprFlag="D";

			for(Map param:  dataList) {
				param.put("KEY_VALUE", keyValue);
				param.put("OPR_FLAG", oprFlag);
//				if ("N".equals(oprFlag)){   //check ISSUE_REQ_SEQ
//					int issReqSeq  = Integer.parseInt(param.get("ISSUE_REQ_SEQ").toString());
//					Map checkReqSeq = (Map) super.commonDao.select("eqt200ukrvServiceImpl.chkReqSeq",param);
//					if (ObjUtils.isNotEmpty(checkReqSeq)){
//						Map getMaxReqSeq = (Map) super.commonDao.select("eqt200ukrvServiceImpl.getMaxReqSeq",param);
//						issReqSeq = Integer.parseInt(getMaxReqSeq.get("MAX_REQ_SEQ").toString());
//						param.put("ISSUE_REQ_SEQ", getMaxReqSeq);
//					}
//				}
				if(dataMaster.get("TYPE")!=null) {
					param.put("EQU_CODE",dataMaster.get("EQU_CODE"));
					 if (dataMaster.get("TYPE").equals("C")) {
						if(oprFlag.equals("N")){
						//模具图片保存
						param.put("data", super.commonDao.insert("eqt300ukrvServiceImpl.insertImage", param));
						}else if(oprFlag.equals("U")){
							//模具图片修改
							param.put("data", super.commonDao.insert("eqt300ukrvServiceImpl.updateImage", param));
						}else if(oprFlag.equals("D")){

						}
					}
				}
			}
		}


		paramList.add(0, paramMaster);

		return  paramList;
	}

//----- 2023.01.30 Dongsoo Park - (설비일상점검내역 Tab추가작업) Start------- //
	@ExtDirectMethod(value = ExtDirectMethodType.STORE_SYNCALL, group = "equit")
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor={Exception.class})
	public List<Map> saveAll4(List<Map> paramList,  Map paramMaster, LoginVO user) throws Exception {
		logger.debug("[saveAll4] paramDetail:" + paramList);
		//출하지시 마스터 출하지시 번호 update
		Map<String, Object> dataMaster = (Map<String, Object>) paramMaster.get("data");
		//1.로그테이블에서 사용할 KeyValue 생성
		String keyValue = getLogKey();
		  logger.debug("###################22222222222222222222222222222222222");
		//2.출하지시 로그테이블에 KEY_VALUE, OPR_FLAG 업데이트
		List<Map> dataList = new ArrayList<Map>();
		List<List<Map>> resultList = new ArrayList<List<Map>>();

		for(Map paramData: paramList) {

			dataList = (List<Map>) paramData.get("data");
			String oprFlag = "N";
			if(paramData.get("method").equals("insertMaster4"))	oprFlag="N";
			if(paramData.get("method").equals("updateMaster"))	oprFlag="U";
			if(paramData.get("method").equals("deleteMaster"))	oprFlag="D";

			for(Map param:  dataList) {
				if(dataMaster.get("TYPE")!=null) {
					//param.put("EQU_CODE",dataMaster.get("EQU_CODE"));

					  logger.debug("###################1111111111111111111111"+dataMaster.get("TYPE"));

					 if (dataMaster.get("TYPE").equals("C")) {

						if(oprFlag.equals("N")){
							//설비일상점검내역(EQU300T_INSERT)
							param.put("data", super.commonDao.insert("eqt300ukrvServiceImpl.insertMaster4", param));
						}else if(oprFlag.equals("U")){
							//설비일상점검내역(EQU300T_UPDATE)
							param.put("data", super.commonDao.insert("eqt300ukrvServiceImpl.updateMaster4", param));
						}else if(oprFlag.equals("D")){
							//설비일상점검내역(EQU300T_DELETE)
							  logger.debug("###################22222222222222222"+oprFlag.equals("N"));
							param.put("data", super.commonDao.insert("eqt300ukrvServiceImpl.deleteMaster4", param));
						}
					}
				}
			}
		}

		paramList.add(0, paramMaster);
		return  paramList;
	}
//----- 2023.01.30 Dongsoo Park - (설비일상점검내역 Tab추가작업) End------- //

	@ExtDirectMethod(group = "equit", value = ExtDirectMethodType.STORE_MODIFY)
	public List<Map> insertMaster(List<Map> params, LoginVO user) throws Exception {
		return null;
	}
	@ExtDirectMethod(group = "equit", value = ExtDirectMethodType.STORE_MODIFY)
	public List<Map> insertMaster4(List<Map> params, LoginVO user) throws Exception {
		return null;
	}
	@ExtDirectMethod(group = "equit", value = ExtDirectMethodType.STORE_MODIFY)
	public List<Map> updateMaster(List<Map> params, LoginVO user) throws Exception {
		return null;
	}
	@ExtDirectMethod(group = "equit", value = ExtDirectMethodType.STORE_MODIFY)
	public List<Map> deleteMaster(List<Map> params, LoginVO user) throws Exception {
		return null;
	}
	@ExtDirectMethod(group = "equit", value = ExtDirectMethodType.STORE_MODIFY)
	public List<Map> insertImage(List<Map> params, LoginVO user) throws Exception {
		return null;
	}
	@ExtDirectMethod(group = "equit", value = ExtDirectMethodType.STORE_MODIFY)
	public List<Map> updateImage(List<Map> params, LoginVO user) throws Exception {
		return null;
	}
	@ExtDirectMethod(group = "equit", value = ExtDirectMethodType.STORE_MODIFY)
	public List<Map> deleteImage(List<Map> params, LoginVO user) throws Exception {
		return null;
	}


	@ExtDirectMethod( group = "equip", value = ExtDirectMethodType.FORM_POST )
    public ExtDirectFormPostResult uploadPhoto( @RequestParam( "fileUpload" ) MultipartFile file, Eqt200ukvrModel param, LoginVO login ) throws IOException, Exception {

        if (file != null && !file.isEmpty()) {
            logger.debug("File1 Name : " + file.getName());
            logger.debug("File1 Bytes: " + file.getSize());
            String fileExtension = FileUtil.getExtension(file.getOriginalFilename()).toLowerCase();

            if (!"jpg".equals(fileExtension) && !"png".equals(fileExtension) && !"bmp".equals(fileExtension)) {
                throw new UniDirectValidateException(new String("jpg, png, bmp 파일로 올려주세요."));
            }

            String path = ConfigUtil.getUploadBasePath(ConfigUtil.getString("common.upload.equipmentPhoto", "/EquipmentPhoto/"));
            logger.debug("################### fileUpload path : "+path);
            if (file.getSize() > 0) {
            	File dir = new File(path);
            	if(!dir.exists()) {
            		dir.mkdir();
            	}
                Map<String, String> maxSerNo = new HashMap<String, String>();
                maxSerNo = (Map) super.commonDao.select("eqt300ukrvServiceImpl.imagesMaxSerNo", param);
	       	    if(ObjUtils.isNotEmpty(maxSerNo)){
	                param.setSER_NO(ObjUtils.parseInt(maxSerNo.get("MAX_SER_NO"))+1);
	       	    }else{
	       	    	param.setSER_NO(1);
	       	    }

            	String fileFid =   login.getCompCode()+param.getDIV_CODE()+param.getEQU_CODE() + param.getCTRL_TYPE() + ObjUtils.getSafeString(param.getSER_NO());
            	String fileName =   login.getCompCode()+param.getDIV_CODE()+param.getEQU_CODE() + param.getCTRL_TYPE() + ObjUtils.getSafeString(param.getSER_NO()) +'.' + fileExtension;

                File tmpFile = new File(path + "/"+fileName);
                file.transferTo(tmpFile);

                param.setIMAGE_FID(fileFid);
                param.setFILE_NAME(file.getOriginalFilename());		// 파일올릴당시 파일이름
                param.setS_COMP_CODE(login.getCompCode());
                param.setS_USER_ID(login.getUserID());
                param.setFILE_TYPE(fileExtension);
                super.commonDao.insert("eqt300ukrvServiceImpl.insertImages", param);
            }
        }
        ExtDirectFormPostResult extResult = new ExtDirectFormPostResult(true);
        return extResult;
    }
	/**
	 * 이미지리스트
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@ExtDirectMethod(group = "equit", value = ExtDirectMethodType.STORE_READ)
	public List<Map<String, Object>> imagesList(Map param) throws Exception {
		return super.commonDao.list("eqt300ukrvServiceImpl.imagesList", param);
	}

}
