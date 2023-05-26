package foren.unilite.modules.human.hpa;

import java.util.ArrayList;
import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class MakeHtml {
	private String htm="";
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	
	public String getHtml(){
		return htm;
	}
	
	public MakeHtml(Hpa940ukrEmailModel vo, 
			Hpa940ukrYearModel yearVo2,	
			List<Hpa940ukrCode1Model>  workVo2,
			List<Hpa940ukrCode2Model>  code2, 
			List<Hpa940ukrCode3Model>  code3, 
			Hpa940ukrModel extra_info){
		String year_yn = extra_info.getYEAR_YN();
		String work_yn = extra_info.getWORK_YN();
		String comments = extra_info.getCOMMENTS();
		String supp_name = extra_info.getSUPP_NAME();
		String pay_yyyymm = extra_info.getPAY_YYYYMM();
		String emailPwd = vo.getEMAIL_PWD();
	
		Hpa940ukrYearModel yearVo = new Hpa940ukrYearModel();
		if(yearVo2 != null)
			yearVo = yearVo2;
		
		makeHeader(pay_yyyymm, supp_name, emailPwd);
		
		makeBasic(vo);

		
		//년월차 잔여현황
		logger.debug("year_yn : " + year_yn);
		if(year_yn.equals("Y")) makeYear(yearVo2);		
		
		//근태현황
		logger.debug("work_yn : " + work_yn);		
		if(work_yn.equals("Y")){
             makeWork3(workVo2, code2, code3); 
             makeTail3(vo, comments);
		}else{
			makeWork2(code2, code3);
			makeTail2(vo, comments);
		}
	}
	
	private void makeHeader(String pay_yyyymm, String supp_name, String emailPwd) {
		htm = "<HTML>                                                                                                                               ";
		htm += "<HEAD><title></title>                                                                                                                ";
		htm += "<meta http-equiv=Content-Type content=text/html; charset=euc-kr>                                                                     ";
		htm += "<STYLE type=text/css>                                                                                                                ";
		htm += "td{ font-family:돋움체;                                                                                                              ";
		htm += "    font-size:12px;                                                                                                                  ";
		htm += "    text-decoration:none;                                                                                                            ";
		htm += "    background-color:white;                                                                                                          ";
		htm += "  }                                                                                                                                  ";
		htm += " .lblTitle {background-color:gray;color:white;}                                                                                      ";
		htm += " .lblLabel {background-color:gray;color:white;}                                                                                      ";
		htm += " </STYLE> </HEAD>";
		htm += " <script type=\"text/javascript\">                                                                                             		 ";
		htm += "	var errCnt = 0;";
		htm += "	var password_sys = '" + emailPwd + "';";
		htm += "	var password_usr = '';";
		htm += "";
		htm += "	while(errCnt < 3) {";
		htm += "		password_usr = prompt('비밀번호를 입력하여주십시오.(주민등록번호 뒤 7자리)');";
		htm += "";
		htm += "		if(password_sys == password_usr) {";
		htm += "			break;";
		htm += "		}";
		htm += "		else {";
		htm += "			errCnt++;";
		htm += "			if(errCnt < 3) {";
		htm += "				alert('비밀번호가 일치하지 않습니다. (' + String(errCnt) + '회 오류)');";
		htm += "			}";
		htm += "			else {";
		htm += "				alert('비밀번호가 일치하지 않습니다. 창을 닫습니다.');";
		htm += "				window.close();";
		htm += "			}";
		htm += "		}";
		htm += "	}";
		htm += " </script>                                                                                             								 ";
		htm += "<body bgcolor=#FFFFFF>                                                                                             ";
		htm += "<table width=1000 border=0 align=center><tr><td>                                                                                     ";
		htm += "<table width=100% border=0><tr><td style=font-weight:bold;font-size:15px;TEXT-DECORATION:underline;color:gray align=center >         ";
		htm += "<span></span>" + pay_yyyymm.substring(0,4) + "." + pay_yyyymm.substring(4) + " " + supp_name +" 명세서 입니다</tr></td>                                                                                ";
		htm += "</table><br>                                                                                                                         ";

	}
	
	private void makeBasic(Hpa940ukrEmailModel vo) {
		htm += "<table id=oTable1 width=100% border=0 CELLPADDING=5 CELLSPACING=1 BGCOLOR=BLACK>                                                     ";
		htm += "<tr><td width=100% height=23 align=left colspan = 4 class=lblTitle> &nbsp; <b>기본인적</b></td> </tr>                                ";
		htm += "<tr>                                                                                                                                 ";
		htm += "<td width=15% height=23 align=center class=lblLabel > 성&nbsp;&nbsp;&nbsp;명</td>                                                    ";
		htm += "<td width=35% height=23 align=left > &nbsp; " + vo.getNAME() +" </td>                                                                             ";
		htm += "<td width=15% height=23 align=center class=lblLabel > 소&nbsp;&nbsp;&nbsp;속</td>                                                    ";
		htm += "<td width=35% height=23 align=leftr > &nbsp; " + vo.getDEPT_NAME() + " </td>                                                                        ";
		htm += "</tr>                                                                                                                                ";
		htm += "<tr>                                                                                                                                 ";
		htm += "<td height=23 align=center class=lblLabel > 사&nbsp;&nbsp;&nbsp;번</td>                                                              ";
		htm += "<td height=23 align=left > &nbsp; "+ vo.getPERSON_NUMB() +" </td>                                                                                      ";
		htm += "<td height=23 align=center class=lblLabel > 직&nbsp;&nbsp;&nbsp;위</td>                                                              ";
		htm += "<td height=23 align=leftr > &nbsp; " + vo.getPOST_NAME() +" </td>                                                                                        ";
		htm += "</tr>                                                                                                                                ";
		htm += "<tr>                                                                                                                                 ";
		htm += "<td height=23 align=center class=lblLabel > 은행명</td>                                                                              ";
		htm += "<td height=23 align=left > &nbsp; "+ vo.getBANK_NAME() + " </td>                                                                                             ";
		htm += "<td height=23 align=center class=lblLabel > 계좌번호</td>                                                                            ";
		htm += "<td height=23 align=leftr > &nbsp; "+vo.getBANK_ACCOUNT1() + " </td>                                                                                            ";
		htm += "</tr>                                                                                                                                ";
		htm += "</table><br> "; 
	}
	
	private void makeYear(Hpa940ukrYearModel yearVo) {
		
		htm += "<table id=oTable1 width=100% border=0 CELLPADDING=5 CELLSPACING=1 BGCOLOR=BLACK>                                                     ";
		htm += "<tr><td width=100% height=23 align=left colspan = 10 class=lblTitle> &nbsp; <b>년월차 잔여현황</b></td> </tr>                        ";
		htm += "<tr>                                                                                                                                 ";
		
		if(yearVo != null){
			htm += "<td width=10% height=23 align=center class=lblLabel > 년차</td>                                                                      ";
			htm += "<td width=10% height=23 align=right > " + yearVo.getMONTH_NUM() + " &nbsp;</td>                                                                                  ";
			htm += "<td width=10% height=23 align=center class=lblLabel > 근속가산 </td>                                                                 ";
			htm += "<td width=10% height=23 align=right > " + yearVo.getYEAR_BONUS_I() + " &nbsp;</td>                                                                                  ";
			htm += "<td width=10% height=23 align=center class=lblLabel > 월차발생</td>                                                                  ";
			htm += "<td width=10% height=23 align=right > " + yearVo.getYEAR_PROV() + " &nbsp;</td>                                                                                  ";
			htm += "<td width=10% height=23 align=center class=lblLabel > 사용일수</td>                                                                  ";
			htm += "<td width=10% height=23 align=right > " + yearVo.getYEAR_USE() + " &nbsp;</td>                                                                                  ";
			htm += "<td width=10% height=23 align=center class=lblLabel > 잔여일수</td>                                                                  ";
			htm += "<td width=10% height=23 align=right > " + yearVo.getYEAR_SAVE() + " &nbsp;</td>                                                                                  ";
			
		}
		else{
			htm += "<td width=10% height=23 align=center class=lblLabel > 년차</td>                                                                      ";
			htm += "<td width=10% height=23 align=right > 0 &nbsp;</td>                                                                                  ";
			htm += "<td width=10% height=23 align=center class=lblLabel > 근속가산 </td>                                                                 ";
			htm += "<td width=10% height=23 align=right > 0 &nbsp;</td>                                                                                  ";
			htm += "<td width=10% height=23 align=center class=lblLabel > 월차발생</td>                                                                  ";
			htm += "<td width=10% height=23 align=right > 0 &nbsp;</td>                                                                                  ";
			htm += "<td width=10% height=23 align=center class=lblLabel > 사용일수</td>                                                                  ";
			htm += "<td width=10% height=23 align=right > 0 &nbsp;</td>                                                                                  ";
			htm += "<td width=10% height=23 align=center class=lblLabel > 잔여일수</td>                                                                  ";
			htm += "<td width=10% height=23 align=right > 0 &nbsp;</td>                                                                                  ";
		}
		
		htm += "</tr>                                                                                                                                ";
		htm += "</table><br>";
		

	}
	
	private void makeWork2(List<Hpa940ukrCode2Model>  code2, List<Hpa940ukrCode3Model>  code3){
		
		htm += "<table width=100% border=0 height=30 CELLPADDING=5 CELLSPACING=1 BGCOLOR=BLACK>                                                      ";
		htm += "<td width=50% height=24 align=center class=lblTitle colspan = 2><b>지 급 내 역</b> </td>                                             ";
		htm += "<td width=50% height=24 align=center class=lblTitle colspan = 2><b>공 제 내 역</b> </td></tr>";

		
		int  b=0, c=0, max=0;
		if(code2 != null) { b=code2.size(); logger.debug("code2 : " + code2.size()); } 
		if(code3 != null) { c=code3.size(); logger.debug("code3 : " + code3.size()); }
		max = b>=c ? b : c;

		
		for (int i=0; i < max; i++)
		{
	    	 htm += "<tr>";
	    	 
	    	 if(i<b){ //2.지급내역
		    	 htm += "<td width=15% height=21 align=left   class=lblLabel> &nbsp; "+code2.get(i).getWAGES_NAME() +"</td>";
		    	 htm += "<td width=35% height=21 align=right >  &nbsp; &nbsp;" + code2.get(i).getAMT() + "</td>";
			 }
		   	 else{
		   		 htm += "<td width=15% height=21 align=left   class=lblLabel> &nbsp; </td>";
		    	 htm += "<td width=35% height=21 align=right >  &nbsp;&nbsp;</td>";
		   	 }
	    	 
	    	 if(i<c){ //3.공제내역
		    	 htm += "<td width=15% height=21 align=left   class=lblLabel> &nbsp; "+code3.get(i).getCODE_NAME() +"</td>";
		    	 htm += "<td width=35% height=21 align=right >" + code3.get(i).getAMT()  + " &nbsp;</td>";
			 }
		   	 else{
		   		 htm += "<td width=15% height=21 align=left   class=lblLabel> &nbsp; </td>";
		    	 htm += "<td width=35% height=21 align=right > &nbsp;</td>";
		   	 }
	    	 htm += "</tr>";
	     }

	}
	
	private void makeWork3(List<Hpa940ukrCode1Model>  code1, List<Hpa940ukrCode2Model>  code2, List<Hpa940ukrCode3Model>  code3){
		//if(workVo==null) workVo.init();
		
		htm += "<table width=100% border=0 height=30 CELLPADDING=5 CELLSPACING=1 BGCOLOR=BLACK>                                                      ";
		htm += "<tr><td width=33% height=24 align=center class=lblTitle colspan = 2><b>근 태 내 역</b></td>                                          ";
		htm += "<td width=33% height=24 align=center class=lblTitle colspan = 2><b>지 급 내 역</b> </td>                                             ";
		htm += "<td width=33% height=24 align=center class=lblTitle colspan = 2><b>공 제 내 역</b> </td></tr>                                        ";
		                                                                                                                            
		int a=0, b=0, c=0, max=0;
		if(code1 != null) { a=code1.size(); logger.debug("code1 : " + code1.size()); }
		if(code2 != null) { b=code2.size(); logger.debug("code2 : " + code2.size()); } 
		if(code3 != null) { c=code3.size(); logger.debug("code3 : " + code3.size()); }
		max = a>=b ? a : b;
		max = max>=c ? max : c;
		
		for (int i=0; i < max; i++)
		{
	    	 htm += "<tr>";
	    	 
	    	 if(i<a)  { //1. 근태항목
		    	 htm += "<td width=15% height=21 align=left   class=lblLabel> &nbsp; "+code1.get(i).getCODE_NAME() +"</td>";
		    	 htm += "<td width=18% height=21 align=right >" + code1.get(i).getDUTY_CODE() + " &nbsp;</td>";
	    	 }
	    	 else{
	    		 htm += "<td width=15% height=21 align=left   class=lblLabel> &nbsp; </td>";
		    	 htm += "<td width=18% height=21 align=right > &nbsp;</td>";
	    	 }
	    	 
	    	 if(i<b){ //2.지급내역
		    	 htm += "<td width=15% height=21 align=left   class=lblLabel> &nbsp; "+code2.get(i).getWAGES_NAME() +"</td>";
		    	 htm += "<td width=18% height=21 align=right >" + code2.get(i).getAMT() + " &nbsp;</td>";
			 }
		   	 else{
		   		 htm += "<td width=15% height=21 align=left   class=lblLabel> &nbsp; </td>";
			    	 htm += "<td width=18% height=21 align=right > &nbsp;</td>";
		   	 }
	    	 
	    	 if(i<c){ //3.공제내역
		    	 htm += "<td width=15% height=21 align=left   class=lblLabel> &nbsp; "+code3.get(i).getCODE_NAME() +"</td>";
		    	 htm += "<td width=18% height=21 align=right >" + code3.get(i).getAMT()  + " &nbsp;</td>";
			 }
		   	 else{
		   		 htm += "<td width=15% height=21 align=left   class=lblLabel> &nbsp; </td>";
		    	 htm += "<td width=18% height=21 align=right > &nbsp;</td>";
		   	 }
	    	 htm += "</tr>";
	     }

		
	}
	
	private void makeTail3(Hpa940ukrEmailModel vo, String comments ){
		
		htm += "<tr>                                                                               ";
		htm += "<td colspan=6></td></tr>                                                           ";
		htm += " <tr>                                                                              ";
		htm += " <td width=15% height=11 align=left  class=lblLabel > &nbsp; 총일수 </td>          ";
		htm += " <td width=18% height=11 align=right >  &nbsp;"+vo.getWEEK_DAY() +"</td>                                ";
		htm += " <td width=15% height=11 align=left  class=lblLabel > &nbsp; 실근무일수 </td>      ";
		htm += " <td width=18% height=11 align=right >  &nbsp;"+vo.getWORK_DAY() +"</td>                                ";
		htm += " <td width=15% height=11 align=left  class=lblLabel >&nbsp;&nbsp;실근무시간</td>   ";
		htm += " <td width=18% height=11 align=right >  &nbsp;"+vo.getWORK_TIME() +"</td></tr>                           ";
		htm += " <tr>                                                                              ";
		htm += " <td height=11 align=left  class=lblLabel > &nbsp; 지급총액 </td>                  ";
		htm += " <td height=11 align=right > &nbsp;"+vo.getSUPP_TOTAL_I() +"</td>                                          ";
		htm += " <td height=11 align=left  class=lblLabel > &nbsp; 공제총액 </td>                  ";
		htm += " <td height=11 align=right > &nbsp;"+vo.getDED_TOTAL_I() +"</td>                                          ";
		htm += " <td height=11 align=left  class=lblLabel >&nbsp;&nbsp;실지급액</td>               ";
		htm += " <td height=11 align=right > &nbsp;"+vo.getREAL_AMOUNT_I() +"</td></tr>                                     ";
		htm += " <tr>                                                                              ";
		htm += " <td width=15% height=70 align=left  class=lblLabel > &nbsp; 비고 </td>            ";
		htm += " <td width=* height=11 align=Left colspan=5> "+comments +"&nbsp;</td>                           ";
		htm += " </td>                                                                             ";
		htm += " </tr>                                                                             ";
		
		
		htm += " </table>                                                                                                                            ";
		htm += " </td></tr></table></body></html>   ";
		
	}
	
private void makeTail2(Hpa940ukrEmailModel vo, String comments ){
		
		htm += "<tr>                                                                               ";
		htm += "<td colspan=4></td></tr>                                                           ";
		htm += " <tr>                                                                              ";
		htm += " <td width=15% height=11 align=left  class=lblLabel > &nbsp; 지급총액 </td>                  ";
		htm += " <td width=35% height=11 align=right > &nbsp;"+vo.getSUPP_TOTAL_I() +"</td>                                          ";
		htm += " <td width=15% height=11 align=left  class=lblLabel > &nbsp; 공제총액 </td>                  ";
		htm += " <td width=35% height=11 align=right > &nbsp;"+vo.getDED_TOTAL_I() +"</td>                                          ";
		htm += " <tr><td height=11 align=left  class=lblLabel > &nbsp;</td> <td height=11 align=right > &nbsp;</td>";
		htm += " <td height=11 align=left  class=lblLabel >&nbsp;&nbsp;실지급액</td>               ";
		htm += " <td height=11 align=right > &nbsp;"+vo.getREAL_AMOUNT_I() +"</td></tr>                                     ";
		htm += " <tr>                                                                              ";
		htm += " <td width=15% height=70 align=left  class=lblLabel > &nbsp; 비고 </td>            ";
		htm += " <td width=* height=11 align=Left colspan=3> "+comments +"&nbsp;</td>                           ";
		htm += " </td>                                                                             ";
		htm += " </tr>                                                                             ";
		
		
		htm += " </table>                                                                                                                            ";
		htm += " </td></tr></table></body></html>   ";
		
	}
	
}
