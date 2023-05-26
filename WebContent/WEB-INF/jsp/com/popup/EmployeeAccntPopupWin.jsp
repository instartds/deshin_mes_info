<%@page language="java" contentType="application/javascript; charset=utf-8"%>
<%
// 거래처 팝업
request.setAttribute("PKGNAME","Unilite.app.popup.EmployeeAccntPopup");
%>



	/**
	 *   Model 정의 
	 * @type 
	 */
Unilite.defineModel('${PKGNAME}.EmployeePopupModel', {  
    fields: [ 	 {name: 'NAME' 						,text:'<t:message code="system.label.common.name" default="명"/>' 			,type:'string'	}
				,{name: 'PERSON_NUMB' 		,text:'<t:message code="system.label.common.personnumb" default="사번"/>' 			,type:'string'	}
				,{name: 'POST_CODE' 				,text:'<t:message code="system.label.common.postcode" default="직위"/>CD' 			,type:'string'	}
				,{name: 'POST_CODE_NAME' 	,text:'<t:message code="system.label.common.postcode" default="직위"/>' 			,type:'string'	}
				,{name: 'DEPT_CODE' 				,text:'<t:message code="system.label.common.department" default="부서"/>CD' 			,type:'string'	}
				,{name: 'DEPT_NAME' 				,text:'<t:message code="system.label.common.department" default="부서"/>' 			,type:'string'	}
				,{name: 'JOIN_DATE' 					,text:'<t:message code="system.label.common.joindate" default="입사일"/>' 			,type:'uniDate'	}
				,{name: 'ABIL_CODE' 					,text:'<t:message code="system.label.common.abil" default="직책"/>CD' 			,type:'string'	}
				,{name: 'ABIL_NAME' 				,text:'<t:message code="system.label.common.abil" default="직책"/>' 			,type:'string'	}
				,{name: 'RETR_DATE' 				,text:'<t:message code="system.label.common.retrdate" default="퇴사일"/>' 			,type:'string'	}
				,{name: 'SECT_CODE' 				,text:'<t:message code="system.label.common.declaredivisioncode" default="신고사업장"/>' 		,type:'string'	}
				,{name: 'SECT_NAME' 				,text:'<t:message code="system.label.common.declaredivisionname" default="신고사업장명"/>' 	,type:'string'	}
				,{name: 'JOB_CODE' 					,text:'<t:message code="system.label.common.jobnamecode" default="담당업무코드"/>' 		,type:'string'	}
				,{name: 'JOB_NAME' 					,text:'<t:message code="system.label.common.jobname" default="담당업무명"/>' 		,type:'string'	}
				,{name: 'PAY_CODE' 					,text:'<t:message code="system.label.common.paycode" default="급여구분"/>' 		,type:'string'	}
				,{name: 'TAX_CODE' 					,text:'<t:message code="system.label.common.taxtype" default="세액구분"/>' 		,type:'string'	}
				,{name: 'OT_KIND' 					,text:'<t:message code="system.label.common.otkind" default="잔업구분자"/>' 		,type:'string'	}
				,{name: 'PAY_PROV_FLAG' 		,text:'<t:message code="system.label.common.payprovflag" default="지급일구분"/>' 		,type:'string'	}
				,{name: 'EMPLOY_TYPE' 			,text:'<t:message code="system.label.common.employtype" default="사원구분"/>' 		,type:'string'	}
				,{name: 'MED_GRADE' 				,text:'<t:message code="system.label.common.medgrade" default="의보등급"/>' 		,type:'string'	}
				,{name: 'ANU_BASE_I' 				,text:'<t:message code="system.label.common.anubasei" default="기준소득월액"/>' 	,type:'string'	}
				,{name: 'SPOUSE' 						,text:'<t:message code="system.label.common.spouse" default="배우자"/>' 			,type:'string'	}
				,{name: 'SUPP_AGED_NUM' 		,text:'<t:message code="system.label.common.suppnum" default="부양자"/>' 			,type:'string'	}
				,{name: 'BONUS_KIND' 				,text:'<t:message code="system.label.common.bonuskind" default="상여구분자"/>' 		,type:'string'	}
				,{name: 'REPRE_NUM_EXPOS'  ,text:'<t:message code="system.label.common.socialsecuritynumber" default="주민번호"/>' 		,type:'string'	}
				,{name: 'REPRE_NUM_MASK'   ,text:'<t:message code="system.label.common.socialsecuritynumber" default="주민번호"/>'        ,type:'string' , defaultValue: '***************'  }
				,{name: 'REPRE_NUM'         		,text:'<t:message code="system.label.common.bankaccount" default="계좌번호"/>(DB)'        ,type:'string'  }
				,{name: 'WOMAN' 					,text:'<t:message code="system.label.common.spouse" default="배우자"/>' 			,type:'string'	}
				,{name: 'ZIP_CODE' 					,text:'<t:message code="system.label.common.zipcode" default="우편번호"/>' 			,type:'string'	}
				,{name: 'KOR_ADDR' 				,text:'<t:message code="system.label.common.address" default="주소"/>' 			,type:'string'	}
				,{name: 'DEFORM_NUM' 			,text:'<t:message code="system.label.common.hitch" default="장애"/>' 			,type:'string'	}
				,{name: 'AGED_NUM' 				,text:'<t:message code="system.label.common.path" default="경로"/>' 			,type:'string'	}
				,{name: 'BRING_CHILD_NUM' 	,text:'<t:message code="system.label.common.bringchildnum" default="양육"/>' 			,type:'string'	}
				,{name: 'ANNUAL_SALARY_I' 	,text:'<t:message code="system.label.common.annualsalaryi" default="연봉"/>' 			,type:'string'	}
				,{name: 'WAGES_STD_I' 			,text:'<t:message code="system.label.common.wagesstdi" default="기본급"/>' 			,type:'string'	}
				,{name: 'BONUS_STD_I' 			,text:'<t:message code="system.label.common.bonusi" default="상여"/>' 			,type:'string'	}
				,{name: 'COM_DAY_WAGES' 	,text:'<t:message code="system.label.common.overtime" default="잔업"/>' 			,type:'string'	}
				,{name: 'COM_YEAR_WAGES' 	,text:'<t:message code="system.label.common.yeari" default="년월차"/>' 			,type:'string'	}
				,{name: 'MED_INSUR_NO' 		,text:'<t:message code="system.label.common.medinsurno" default="의료번호"/>' 		,type:'string'	}
				,{name: 'PAY_PROV_FLAG_DAT' ,text:'<t:message code="system.label.common.payprovflag2" default="급여지급일구분"/>' 	,type:'string'	}
				,{name: 'SEX_CODE' 					,text:'<t:message code="system.label.common.sexcode" default="남녀구분"/>' 		,type:'string'	}
				,{name: 'STD_AMOUNT_I_01' 	,text:'<t:message code="system.label.common.stdamounti" default="표준보수월액"/>(<t:message code="system.label.common.healthinsur" default="건강보험"/>)' 	,type:'string'	}
				,{name: 'STD_AMOUNT_I_02' 	,text:'<t:message code="system.label.common.stdamounti" default="표준보수월액"/>(<t:message code="system.label.common.pensioninsur" default="연금보험"/>)' 	,type:'string'	}
				,{name: 'INSUR_AMOUNT_I_01' ,text:'<t:message code="system.label.common.insurusei" default="보험료"/>(<t:message code="system.label.common.healthinsur" default="건강보험"/>)',type:'string'	}
				,{name: 'INSUR_AMOUNT_I_02' ,text:'<t:message code="system.label.common.insurusei" default="보험료"/>(<t:message code="system.label.common.pensioninsur" default="연금보험"/>)',type:'string'	}
				,{name: 'TELEPHON' 					   ,text:'<t:message code="system.label.common.telephone" default="전화번호"/>' 		,type:'string'	}
				,{name: 'DIV_CODE' 					   ,text:'<t:message code="system.label.common.division" default="사업장"/>' 			,type:'string'	}
				,{name: 'MAKE_SALE' 					,text:'<t:message code="system.label.common.makesale" default="제조판관"/>' 		,type:'string'	}
				,{name: 'COST_KIND' 					,text:'<t:message code="system.label.common.costkind" default="직간접"/>' 			,type:'string'	}
				,{name: 'MED_AVG_I' 					,text:'<t:message code="system.label.common.medavgi" default="월표준보수액"/>' 	,type:'string'	}
				,{name: 'CHILD_20_NUM' 			,text:'<t:message code="system.label.common.child20num" default="20세이하 자녀 수"/>' 	,type:'string'	}
				,{name: 'PENS_GRADE' 					,text:'<t:message code="system.label.common.pensgrade" default="국민연금등급"/>' 		,type:'string'	}
				,{name: 'NATION_CODE' 				,text:'<t:message code="system.label.common.countrycode" default="국가코드"/>' 		,type:'string'	}
				,{name: 'LIVE_GUBUN' 					,text:'<t:message code="system.label.common.livegubun" default="거주구분"/>' 		,type:'string'	}
				,{name: 'MED_INSUR_I' 		,type:'string'	}
				,{name: 'ANU_INSUR_I' 		,type:'string'	}
				,{name: 'HIRE_INSUR_TYPE' 	,type:'string'	}
				,{name: 'WORK_COMPEN_YN' 	,type:'string'	}
				,{name: 'REPRE_NUM2' 		,type:'string'	}
				,{name: 'DED_TYPE' 		 	,type:'string'	}
			]
	});

/**
 * 검색조건 (Search Panel)
 * @type 
 */
Ext.define('${PKGNAME}', {
    extend: 'Unilite.com.BaseJSPopupApp',
    constructor : function(config) {
        var me = this;
        if (config) {
            Ext.apply(me, config);
        }
	    /**
	     * 검색조건 (Search Panel)
	     * @type 
	     */
	    var wParam = this.param;
	    var t1= false, t2 = false;
	    if( Ext.isDefined(wParam)) {
	        if(wParam['TYPE'] == 'VALUE') {
	            t1 = true;
	            t2 = false;
	            
	        } else {
	            t1 = false;
	            t2 = true;
	            
	        }
	    }


		me.panelSearch =  Unilite.createSearchForm('',{
		    layout : {type : 'table', columns : 2, tableAttrs: {
		        style: {
		            width: '100%'
		        }
		    }},
		    items: [ /*{ fieldLabel: '성명', 		name:'NAME'			}
		    		,{  		name:'PERSON_NUMB'	}*/
		    		 { fieldLabel: '<t:message code="system.label.common.basisdate" default="기준일"/>', 		name:'BASE_DT',		xtype:'uniDatefield', value: new Date()}
		    		,{ fieldLabel: '<t:message code="system.label.common.paygubun" default="고용형태"/>', 	name:'PAY_GUBUN',	xtype:'uniTextfield', hidden: true} // 1 : 정규직 , 2 : 비정규직
		    		,{ fieldLabel: '<t:message code="system.label.common.inquirycondition" default="조회조건"/>',     name:'TXT_SEARCH',  xtype: 'uniTextfield' ,
                        listeners:{
                            specialkey: function(field, e){
                                if (e.getKey() == e.ENTER) {
                                   me.onQueryButtonDown();
                                }
                            }
                        }
                    }
		    		,{ fieldLabel: '법무담당관련',     name:'ADD_QUERY',   xtype: 'uniTextfield', hidden: true}
		    		
		    		]
		});  
		
		/**
		 * Master Grid 정의(Grid Panel)
		 * @type 
		 */
		me.masterGrid =  Unilite.createGrid('', {
			store: Unilite.createStoreSimple('${PKGNAME}.emplyeePopupMasterStore',{
							model: '${PKGNAME}.EmployeePopupModel',
					        autoLoad: true,
					        proxy: {
					            type: 'direct',
					            api: {
					            	read: 'popupService.employeePopup'
					            }
					        }
					}),
			uniOpt:{
                state: {
					useState: false,
					useStateList: false	
                },
				pivot : {
					use : false
				}
	        },
			selModel:'rowmodel',
		    columns:  [  {dataIndex: 'NAME' 				,width:110	,locked:true}
						,{dataIndex: 'PERSON_NUMB' 			,width:110	,locked:true}
						,{dataIndex: 'POST_CODE' 			,width:100	,hidden:true}
						,{dataIndex: 'POST_CODE_NAME' 		,width:120	}
						,{dataIndex: 'DEPT_CODE'	 		,width:100	,hidden:true}
						,{dataIndex: 'DEPT_NAME' 			,width:200	}

		    ] ,
		    listeners: {
				onGridDblClick:function(grid, record, cellIndex, colName) {
					var rv = {
						status : "OK",
						data:[record.data]
					};
					me.returnData(rv);
				},
//                beforecelldblclick:function  (grid , td , cellIndex , record , tr , rowIndex , e , eOpts ) {                    
//                    var records = me.masterGrid.store.data.items;
//                    Ext.each(records, function(record,i) {
//                        if(record.data['REPRE_NUM_MASK'] != '***************'){
//                            record.set('REPRE_NUM_MASK','***************');
//                        }
//                    });
//                },
				onGridKeyDown: function(grid, keyCode, e) {
					if(e.getKey() == Ext.EventObject.ENTER) {
						var selectRecord = grid.getSelectedRecord();
						var rv = {
							status : "OK",
							data:[selectRecord.data]
						};
						me.returnData(rv);
					}
				}
			}
		});
		config.items = [me.panelSearch,	me.masterGrid];
     	me.callParent(arguments);

    },	
	initComponent : function(){    
    	var me  = this;
        
        me.masterGrid.focus();
        
    	this.callParent();    	
    },
	fnInitBinding : function(param) {
		var me = this;		
		var frm= me.panelSearch.getForm();		
		var fieldTxt = frm.findField('TXT_SEARCH');
		var frm= me.panelSearch.getForm();
		var fieldTxt = frm.findField('TXT_SEARCH');
		me.panelSearch.setValues(param);
		if(param['TYPE'] == 'VALUE') {
        	if(!Ext.isEmpty(param['PERSON_NUMB'])){
        		fieldTxt.setValue(param['PERSON_NUMB']);        	
        	}
        }else{
        	if(!Ext.isEmpty(param['PERSON_NUMB'])){
        		fieldTxt.setValue(param['PERSON_NUMB']);        	
        	}
        	if(!Ext.isEmpty(param['NAME'])){
        		fieldTxt.setValue(param['NAME']);
        	}
        }
//		var me = this;
//		var frm= me.panelSearch;
//        //console.log("frm:", frm);
//		if(param['PERSON_NUMB']!='') frm.setValue('PERSON_NUMB',param['PERSON_NUMB']);
//		if(param['NAME']!='') frm.setValue('NAME',param['NAME']);
		
		this._dataLoad();
	},
	 onQueryButtonDown : function()	{
		this._dataLoad();
	},
	onSubmitButtonDown : function()	{
        var me = this;
		var selectRecord = me.masterGrid.getSelectedRecord();
	 	var rv ;
		if(selectRecord)	{
		 	rv = {
				status : "OK",
				data:[selectRecord.data]
			};
		}
		me.returnData(rv);
	},
	_dataLoad : function() {
		var me = this;
		var param= me.panelSearch.getValues();
		console.log( "_dataLoad: ", param );
		me.isLoading = true;
		me.masterGrid.getStore().load({
			params : param,
			callback:function()	{
				me.isLoading = false;
			}
		});
	}
});

