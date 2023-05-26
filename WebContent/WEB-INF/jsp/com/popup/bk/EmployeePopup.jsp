<%@page language="java" contentType="text/html; charset=utf-8"%>
<%
/**
*	사원 팝업 
*
*/
%>

<t:appConfig pgmId="crm.pop.EmployeePopup"  />
<script type="text/javascript" >
function appMain() {

	/**
	 *   Model 정의 
	 * @type 
	 */
	Unilite.defineModel('EmployeePopupModel', {  
	    fields: [ 	 {name: 'NAME' 				,text:'성명' 			,type:'string'	}
					,{name: 'PERSON_NUMB' 		,text:'사번' 			,type:'string'	}
					,{name: 'POST_CODE' 		,text:'직위CD' 			,type:'string'	}
					,{name: 'POST_CODE_NAME' 	,text:'직위' 			,type:'string'	}
					,{name: 'DEPT_CODE' 		,text:'부서CD' 			,type:'string'	}
					,{name: 'DEPT_NAME' 		,text:'부서' 			,type:'string'	}
					,{name: 'JOIN_DATE' 		,text:'입사일' 			,type:'string'	}
					,{name: 'ABIL_CODE' 		,text:'직책CD' 			,type:'string'	}
					,{name: 'ABIL_NAME' 		,text:'직책' 			,type:'string'	}
					,{name: 'RETR_DATE' 		,text:'퇴사일' 			,type:'string'	}
					,{name: 'SECT_CODE' 		,text:'신고사업장' 		,type:'string'	}
					,{name: 'SECT_NAME' 		,text:'신고사업장명' 	,type:'string'	}
					,{name: 'JOB_CODE' 			,text:'담당업무CD' 		,type:'string'	}
					,{name: 'JOB_NAME' 			,text:'담당업무명' 		,type:'string'	}
					,{name: 'PAY_CODE' 			,text:'급여구분' 		,type:'string'	}
					,{name: 'TAX_CODE' 			,text:'세액구분' 		,type:'string'	}
					,{name: 'OT_KIND' 			,text:'잔업구분자' 		,type:'string'	}
					,{name: 'PAY_PROV_FLAG' 	,text:'지급일구분' 		,type:'string'	}
					,{name: 'EMPLOY_TYPE' 		,text:'사원구분' 		,type:'string'	}
					,{name: 'MED_GRADE' 		,text:'의보등급' 		,type:'string'	}
					,{name: 'ANU_BASE_I' 		,text:'기준소득월액' 	,type:'string'	}
					,{name: 'SPOUSE' 			,text:'배우자' 			,type:'string'	}
					,{name: 'SUPP_AGED_NUM' 	,text:'부양자' 			,type:'string'	}
					,{name: 'BONUS_KIND' 		,text:'상여구분자' 		,type:'string'	}
					,{name: 'REPRE_NUM' 		,text:'주민번호' 		,type:'string'	}
					,{name: 'WOMAN' 			,text:'배우자' 			,type:'string'	}
					,{name: 'ZIP_CODE' 			,text:'우편' 			,type:'string'	}
					,{name: 'KOR_ADDR' 			,text:'주소' 			,type:'string'	}
					,{name: 'DEFORM_NUM' 		,text:'장애' 			,type:'string'	}
					,{name: 'AGED_NUM' 			,text:'경로' 			,type:'string'	}
					,{name: 'BRING_CHILD_NUM' 	,text:'양육' 			,type:'string'	}
					,{name: 'ANNUAL_SALARY_I' 	,text:'연봉' 			,type:'string'	}
					,{name: 'WAGES_STD_I' 		,text:'기본급' 			,type:'string'	}
					,{name: 'BONUS_STD_I' 		,text:'상여' 			,type:'string'	}
					,{name: 'COM_DAY_WAGES' 	,text:'잔업' 			,type:'string'	}
					,{name: 'COM_YEAR_WAGES' 	,text:'년월차' 			,type:'string'	}
					,{name: 'MED_INSUR_NO' 		,text:'의료번호' 		,type:'string'	}
					,{name: 'PAY_PROV_FLAG_DAT' ,text:'급여지급일구분' 	,type:'string'	}
					,{name: 'SEX_CODE' 			,text:'남녀구분' 		,type:'string'	}
					,{name: 'STD_AMOUNT_I_01' 	,text:'표준보수월액(건강보험)' 	,type:'string'	}
					,{name: 'STD_AMOUNT_I_02' 	,text:'표준보수월액(연금보험)' 	,type:'string'	}
					,{name: 'INSUR_AMOUNT_I_01' ,text:'보험료(건강보험)',type:'string'	}
					,{name: 'INSUR_AMOUNT_I_02' ,text:'보험료(연금보험)',type:'string'	}
					,{name: 'TELEPHON' 			,text:'전화번호' 		,type:'string'	}
					,{name: 'DIV_CODE' 			,text:'사업장' 			,type:'string'	}
					,{name: 'MAKE_SALE' 		,text:'제조판관' 		,type:'string'	}
					,{name: 'COST_KIND' 		,text:'직간접' 			,type:'string'	}
					,{name: 'MED_AVG_I' 		,text:'월표준보수액' 	,type:'string'	}
					,{name: 'CHILD_20_NUM' 		,text:'20세이하자녀수' 	,type:'string'	}
					,{name: 'PENS_GRADE' 		,text:'연금등급' 		,type:'string'	}
					,{name: 'NATION_CODE' 		,text:'국가코드' 		,type:'string'	}
					,{name: 'LIVE_GUBUN' 		,text:'거주구분' 		,type:'string'	}
					,{name: 'MED_INSUR_I' 		,type:'string'	}
					,{name: 'ANU_INSUR_I' 		,type:'string'	}
					,{name: 'HIRE_INSUR_TYPE' 	,type:'string'	}
					,{name: 'WORK_COMPEN_YN' 	,type:'string'	}
					,{name: 'REPRE_NUM2' 		,type:'string'	}
					,{name: 'DED_TYPE' 		 	,type:'string'	}
					,{name: 'PAY_GRADE_01'      ,text: '호봉(급)'      ,type: 'string'}
                    ,{name: 'PAY_GRADE_02'      ,text: '호봉(호)'      ,type: 'string'}
                    ,{name: 'PAY_GRADE_03'      ,text: '호봉(직)'      ,type: 'string'}
                    ,{name: 'PAY_GRADE_04'      ,text: '호봉(기)'      ,type: 'string'}
					,{name: 'KNOC' 		        ,text:'직종' 		    ,type: 'string'}
					,{name: 'YEAR_GRADE'        ,text:'근속년(호봉)'     ,type: 'string'}
			]
	});
	
  
	
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
  
	var directMasterStore = Unilite.createStore('emplyeePopupMasterStore',{
			model: 'EmployeePopupModel',
            autoLoad: true,
            proxy: {
                type: 'direct',
                api: {
                	read: 'popupService.employeePopup'
                }
            }
	});
	
	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */

	
	var panelSearch =  Unilite.createSearchForm('searchForm',{
        layout : {type : 'table', columns : 1, tableAttrs: {
            style: {
                width: '100%'
            }
        }},
        items: [ { fieldLabel: '성명', 		name:'NAME'			}
        		,{  		name:'PERSON_NUMB'	}
        		,{ fieldLabel: 'PAY_GUBUN', 		name:'PAY_GUBUN'	}
        		,{ fieldLabel: '기준일', 	name:'BASE_DT',		xType:'uniDate'}]
    });  
	
    /**
     * Master Grid 정의(Grid Panel)
     * @type 
     */
    var masterGrid =  Unilite.createGrid('EmployeePopupGrid', {
    	store: directMasterStore,
        columns:  [  {dataIndex: 'NAME' 				,width:90	,locked:true}
					,{dataIndex: 'PERSON_NUMB' 			,width:100	,locked:true}
					,{dataIndex: 'POST_CODE' 			,width:100	,hidden:true}
					,{dataIndex: 'POST_CODE_NAME' 		,width:100	}
					,{dataIndex: 'DEPT_CODE' 			,width:100	,hidden:true}
					,{dataIndex: 'DEPT_NAME' 			,width:100	}
					,{dataIndex: 'JOIN_DATE' 			,width:100	}
					,{dataIndex: 'ABIL_CODE' 			,width:100	,hidden:true}
					,{dataIndex: 'ABIL_NAME' 			,width:100	}
					,{dataIndex: 'RETR_DATE' 			,width:100	}
					,{dataIndex: 'SECT_CODE' 			,width:100	,hidden:true}
					,{dataIndex: 'SECT_NAME' 			,width:100	}
					,{dataIndex: 'JOB_CODE' 			,width:100	,hidden:true}
					,{dataIndex: 'JOB_NAME' 			,width:100	}
					,{dataIndex: 'PAY_CODE' 			,width:100	,hidden:true}
					,{dataIndex: 'TAX_CODE' 			,width:100	,hidden:true}
					,{dataIndex: 'OT_KIND' 				,width:100	,hidden:true}
					,{dataIndex: 'PAY_PROV_FLAG' 	 	,width:100	,hidden:true}
					,{dataIndex: 'EMPLOY_TYPE' 			,width:100	,hidden:true}
					,{dataIndex: 'MED_GRADE' 			,width:100	,hidden:true}
					,{dataIndex: 'ANU_BASE_I' 		 	,width:100	}
					,{dataIndex: 'SPOUSE' 				,width:100	,hidden:true}
					,{dataIndex: 'SUPP_AGED_NUM'		,width:100	,hidden:true}
					,{dataIndex: 'BONUS_KIND' 		 	,width:100	,hidden:true}
					,{dataIndex: 'REPRE_NUM' 			,width:140	}
					,{dataIndex: 'WOMAN' 				,width:100	,hidden:true}
					,{dataIndex: 'ZIP_CODE' 			,width:100	,hidden:true}
					,{dataIndex: 'KOR_ADDR' 			,width:100	,hidden:true}
					,{dataIndex: 'DEFORM_NUM' 			,width:100	,hidden:true}
					,{dataIndex: 'AGED_NUM' 			,width:100	,hidden:true}
					,{dataIndex: 'BRING_CHILD_NUM' 		,width:100	,hidden:true}
					,{dataIndex: 'ANNUAL_SALARY_I' 		,width:100	,hidden:true}
					,{dataIndex: 'WAGES_STD_I' 			,width:100	,hidden:true}
					,{dataIndex: 'BONUS_STD_I' 			,width:100	,hidden:true}
					,{dataIndex: 'COM_DAY_WAGES' 		,width:100	,hidden:true}
					,{dataIndex: 'COM_YEAR_WAGES' 		,width:100	,hidden:true}
					,{dataIndex: 'MED_INSUR_NO' 		,width:100	,hidden:true}
					,{dataIndex: 'PAY_PROV_FLAG_DAT'	,width:100	,hidden:true}
					,{dataIndex: 'SEX_CODE' 			,width:100	,hidden:true}
					,{dataIndex: 'STD_AMOUNT_I_01' 		,width:100	,hidden:true}
					,{dataIndex: 'STD_AMOUNT_I_02' 		,width:100	,hidden:true}
					,{dataIndex: 'INSUR_AMOUNT_I_01' 	,width:100	,hidden:true}
					,{dataIndex: 'INSUR_AMOUNT_I_02' 	,width:100	,hidden:true}
					,{dataIndex: 'TELEPHON' 			,width:100	,hidden:true}
					,{dataIndex: 'DIV_CODE' 			,width:100	,hidden:true}
					,{dataIndex: 'MAKE_SALE' 			,width:100	,hidden:true}
					,{dataIndex: 'COST_KIND' 			,width:100	,hidden:true}
					,{dataIndex: 'MED_AVG_I' 			,width:120	,hidden:true}
					,{dataIndex: 'CHILD_20_NUM' 		,width:140	}
					,{dataIndex: 'PENS_GRADE' 			,width:100	}
					,{dataIndex: 'NATION_CODE' 			,width:100	}
					,{dataIndex: 'LIVE_GUBUN' 			,width:100	}
					,{dataIndex: 'PAY_GRADE_01'         ,width:100  ,hidden:true}
                    ,{dataIndex: 'PAY_GRADE_02'         ,width:100  ,hidden:true}
					,{dataIndex: 'KNOC' 			    ,width:100	,hidden:true}
					,{dataIndex: 'YEAR_GRADE'           ,width:100  ,hidden:true}
          ] ,
          listeners: {
	          onGridDblClick:function(grid, record, cellIndex, colName) {
	          	var rv = {
					status : "OK",
					data:[record.data]
				};
				window.returnValue = rv;
				window.close();
	          }
          } // listeners
    });
    
    
  	Unilite.PopupMain({
		items : [panelSearch, 	masterGrid],
		id  : 'EmployeePopupApp',
		fnInitBinding : function() {
			var param = window.dialogArguments;
			var frm= Ext.getCmp('searchForm');
			if(param['PERSON_NUMB']!='') frm.setValue('PERSON_NUMB',param['PERSON_NUMB']);
			if(param['NAME']!='') frm.setValue('NAME',param['NAME']);
			
			this._dataLoad();
		},
		 onQueryButtonDown : function()	{
			this._dataLoad();
		},
		_dataLoad : function() {
			var param= Ext.getCmp('searchForm').getValues();
			console.log( param );
			masterGrid.getStore().load({
				params : param
			});
		}
	});

};


</script>
