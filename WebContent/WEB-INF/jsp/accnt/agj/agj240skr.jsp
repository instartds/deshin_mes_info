<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="agj240skr"  >
	<t:ExtComboStore comboType="BOR120" /> 	<!-- 사업장 -->   
	<t:ExtComboStore comboType="AU" comboCode="A011" /> <!-- 입력경로 -->      
	<t:ExtComboStore comboType="AU" comboCode="A014" /> <!-- 승인상태 -->
	<t:ExtComboStore comboType="AU" comboCode="A023" /> <!--결의회계구분-->
	<t:ExtComboStore comboType="AU" comboCode="B055" /> <!--거래처분류-->
	
	
<style type="text/css">

#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>	
</t:appConfig>
<script type="text/javascript" >
var baseInfo = {
    gsChargeDivi    : '${gsChargeDivi}'         // 1:회계부서, 2:현업부서
}

function appMain() {
	var postitWindow;		// 각주팝업
	var changedate;
	var exSlipPgmId = '${exSlipPgmID}';
	var exSlipPgmLink = '/accnt/' + exSlipPgmId + '.do';
	
	if(Ext.isEmpty(exSlipPgmId)) {
		exSlipPgmId = 'agj106ukr';
		exSlipPgmLink = '/accnt/agj106ukr.do';
	}

	/* Model 정의 
	 * @type 
	 */
	Unilite.defineModel('Agj240skrModel', {		
	    fields: [{name: 'GUBUN'			 	,text: 'GUBUN'			,type: 'string'}, 				
	    		 {name: 'AC_DATE'		 	,text: '전표일' 			,type: 'uniDate'},	    		
				 {name: 'SLIP_NUM'		 	,text: '번호' 			,type: 'string'},	
			 	 {name: 'SLIP_SEQ'		 	,text: '순번' 			,type: 'string'},  
			 	 {name: 'ACCNT'			 	,text: '계정코드' 			,type: 'string'},  
			 	 {name: 'ACCNT_NAME'		,text: '계정과목명' 		,type: 'string'},  
			 	 {name: 'DR_AMT_I'		 	,text: '차변금액' 			,type: 'uniPrice'},  
			 	 {name: 'CR_AMT_I'		 	,text: '대변금액' 			,type: 'uniPrice'},
			 	 {name: 'REMARK'			,text: '적요' 			,type: 'string'}, 
			 	 {name: 'CUSTOM_CODE'       ,text: '거래처코드'          ,type: 'string'},  
                 {name: 'CUSTOM_NAME'       ,text: '거래처명'           ,type: 'string'}, 
                 {name: 'DIV_NAME'          ,text: '사업장'            ,type: 'string'},  
			 	 {name: 'DEPT_CODE'		 	,text: '귀속부서코드' 		,type: 'string'},  
			 	 {name: 'DEPT_NAME'   	 	,text: '귀속부서명' 			,type: 'string'},  
			 	 {name: 'EX_DATE'		 	,text: '회계일'        	,type: 'uniDate'},  
			 	 {name: 'EX_NUM'			,text: '번호' 			,type: 'string'},  
			 	 {name: 'MONEY_UNIT'		,text: '화폐단위' 			,type: 'string'},  
			 	 {name: 'EXCHG_RATE_O'	 	,text: '환율' 			,type: 'uniER'},  
			 	 {name: 'FOR_AMT_I'		 	,text: '외화금액' 			,type: 'uniFC'},  
			 	 {name: 'CHARGE_CODE'		,text: '입력자코드' 			,type: 'string'},
			 	 {name: 'CHARGE_NAME'	 	,text: '입력자' 			,type: 'string'},  
			 	 {name: 'CHARGE_DIVI'	 	,text: '입력자 사용부서' 		,type: 'string'},
			 	 {name: 'INPUT_DATE'		,text: '입력일' 			,type: 'uniDate'},  
			 	 {name: 'AP_CHARGE_NAME'	,text: '승인자' 			,type: 'string'},  
			 	 {name: 'AP_DATE'		 	,text: '승인일' 			,type: 'uniDate'},			 	 	
			 	 {name: 'AC_DATE_FR'		,text: '승인시작일' 			,type: 'uniDate'},			 	 	
			 	 {name: 'AC_DATE_TO'		,text: '승인종료일' 			,type: 'uniDate'},			 	 	
			 	 {name: 'AC_CODE1'        	,text: '관리항목1' 			,type: 'string'},  
			 	 {name: 'AC_DATA1'        	,text: '관리항목1' 			,type: 'string'},  
			 	 {name: 'AC_DATA_NAME1'   	,text: '관리항목명1' 		,type: 'string'},  
			 	 {name: 'AC_CODE2'        	,text: '관리항목2' 			,type: 'string'},  
			 	 {name: 'AC_DATA2'        	,text: '관리항목2' 			,type: 'string'},  
			 	 {name: 'AC_DATA_NAME2'   	,text: '관리항목명2' 		,type: 'string'},  
			 	 {name: 'AC_CODE3'        	,text: '관리항목3' 			,type: 'string'},  
			 	 {name: 'AC_DATA3'        	,text: '관리항목3' 			,type: 'string'},  
			 	 {name: 'AC_DATA_NAME3'   	,text: '관리항목명3' 		,type: 'string'},  
			 	 {name: 'AC_CODE4'        	,text: '관리항목4' 			,type: 'string'},  
			 	 {name: 'AC_DATA4'        	,text: '관리항목4' 			,type: 'string'},  
			 	 {name: 'AC_DATA_NAME4'   	,text: '관리항목명4' 		,type: 'string'},  
			 	 {name: 'AC_CODE5'        	,text: '관리항목5' 			,type: 'string'},  
			 	 {name: 'AC_DATA5'        	,text: '관리항목5' 			,type: 'string'},  
			 	 {name: 'AC_DATA_NAME5'   	,text: '관리항목명5' 		,type: 'string'},  
			 	 {name: 'AC_CODE6'        	,text: '관리항목6' 			,type: 'string'},  
			 	 {name: 'AC_DATA6'        	,text: '관리항목6' 			,type: 'string'},  
			 	 {name: 'AC_DATA_NAME6'   	,text: '관리항목명6' 		,type: 'string'},  
			 	 {name: 'PROOF_KIND'		,text: '증빙유형' 			,type: 'string'},  
			 	 {name: 'CREDIT_NUM'		,text: '카드번호/현금영수증'	,type: 'string'},  
			 	 {name: 'CREDIT_NUM_EXPOS'   , text: '신용카드/현금영수증번호'  ,type: 'string', defaultValue:'***************'}, 
			 	 {name: 'REASON_CODE'	 	,text: '불공제사유' 			,type: 'string'},  
				 {name: 'SLIP_TYPE'	 		,text: '전표구분' 			,type: 'string'},
				 {name: 'INCLUDE_DELETE'	,text: '수정이력삭제표시' 		,type: 'string'},
				 {name: 'POSTIT_YN'	 		,text: 'POSTIT_YN'		,type: 'string'},
				 {name: 'POSTIT'	 		,text: 'POSTIT'			,type: 'string'},
				 {name: 'POSTIT_USER_ID' 	,text: 'POSTIT_USER_ID' ,type: 'string'},  
				 {name: 'INPUT_PATH'		,text: 'INPUT_PATH' 	,type: 'string'},
				 {name: 'MOD_DIVI'	 		,text: 'MOD_DIVI' 		,type: 'string'},  
				 {name: 'DIV_CODE'			,text: 'DIV_CODE'	,type: 'string'},
				 {name: 'AUTO_NUM'			,text: 'AUTO_NUM'		,type: 'string'},
				 {name: 'INPUT_DIVI'	 	,text: 'INPUT_DIVI'		,type: 'string'},  
				 {name: 'TOTAL'				,text: '합계(전표수)'	,type: 'int'},
				 {name: 'SUM_DR_AMT_I'		,text: '합계(대변합계)'		,type: 'uniPrice'},
				 {name: 'SUM_CR_AMT_I'	 	,text: '합계(차변합계)'		,type: 'uniPrice'},
				 {name: 'AP_STS'			,text: '승인여부'		,type: 'string'}
		]
	});
	
	/* Store 정의(Service 정의)
	 * @type 
	 */					
	var masterStore = Ext.create('Ext.data.BufferedStore',{		
		storeId :'agj240skrmasterStore',
		uniOpt : {
			isMaster :	true,			// 상위 버튼 연결 
			editable :	false,			// 수정 모드 사용 
			deletable:	false,			// 삭제 가능 여부 
			useNavi  :	false			// prev | newxt 버튼 사용
		},
		pageSize: 1000,
	    leadingBufferZone:0,
	    trailingBufferZone:0,
	    scrollToLoadBuffer:0,
	    clearOnPageLoad:true,
	
	    isSortable: false,
    	buffered :false,
    	remoteSort: true, 
    	
		model: 'Agj240skrModel',
		
        proxy: Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
            
            api: {			
        	   read: 'agj240skrService.selectList'                 	
            },
            reader: {
                rootProperty: 'records',
                totalProperty: 'total'
            },
            extraParams:{
            	'Init':true
            }
        }),
        addProxyParams:function(form, params)	{
        	var formParams = form.getValues();
        	if(params)	{
        		Ext.apply(formParams, params);
        	}
        	this.getProxy().setExtraParams(formParams)
        },
        loadStoreRecords : function()	{
			this.addProxyParams(Ext.getCmp('searchForm'))
			//console.log( param );
			this.load();
		},
		listeners: {
			
          	load: function(store, records, successful, eOpts) {
          		if(records!=null && records.length == 1 && records[0].get("Init") === true)		{
          			store.removeAll(true);
          			masterGrid.reset();
          			return;
          		}
          		if(records!=null && records.length > 0 && records[0].get("Init") !== true)		{
          			masterGrid.setSummaryData(records[0]);
          		}
//          		store.setAutoLoad(true);
          		
//				var viewNormal = masterGrid.getView();
				if(records && records.length > 0){
//		    		viewNormal.getFeature('masterGridTotal').toggleSummaryRow(true);
		    		masterGrid.focus();
				}else{
//		    		viewNormal.getFeature('masterGridTotal').toggleSummaryRow(false);	
					var activeSForm ;		
					if(!UserInfo.appOption.collapseLeftSearch)	{	
						activeSForm = panelSearch;	
					}else {		
						activeSForm = panelResult;	
					}		
					activeSForm.onLoadSelectText('AC_DATE_FR');		
				}
          	}          		
      	}
	});
	
    var panelFileDown = Unilite.createForm('ExcelFileDownForm', {
        url: CPATH+'/accnt/agj240excel.do',
        colspan: 2,
        layout: {type: 'uniTable', columns: 1},
        height: 30,
        padding: '0 0 0 0',
        disabled:false,
        autoScroll: false,
        standardSubmit: true,  
        items:[{
            xtype: 'uniTextfield',
            name: 'AC_DATE_FR'
        },{
            xtype: 'uniTextfield',
            name: 'AC_DATE_TO'
        },{
            xtype: 'uniTextfield',
            name: 'INPUT_DATE_FR'
        },{
            xtype: 'uniTextfield',
            name: 'INPUT_DATE_TO'
        },{
            name:'ACCNT_DIV_CODE', 
            xtype: 'uniCombobox',
            multiSelect: true, 
            typeAhead: false,
            comboType:'BOR120'
        },{
            xtype: 'uniTextfield',
            name: 'IN_DEPT_CODE'
        },{
            xtype: 'uniTextfield',
            name: 'IN_DEPT_NAME'
        },{
            xtype: 'uniTextfield',
            name: 'CUSTOM_CODE'
        },{
            xtype: 'uniTextfield',
            name: 'CUSTOM_NAME'
        },{
            xtype: 'uniTextfield',
            name: 'SLIP_TYPE'
        },{
            xtype: 'uniTextfield',
            name: 'AP_STS'
        },{
            xtype: 'uniTextfield',
            name: 'AGENT_TYPE'
        },{
            xtype: 'uniTextfield',
            name: 'DEPT_CODE'
        },{
            xtype: 'uniTextfield',
            name: 'DEPT_NAME'
        },{
            xtype: 'uniTextfield',
            name: 'MONEY_UNIT'
        },{
            xtype: 'uniTextfield',
            name: 'ACCNT'
        },{
            xtype: 'uniTextfield',
            name: 'ACCNT_NAME'
        },{
            xtype: 'uniTextfield',
            name: 'INPUT_PATH'
        },{
            xtype: 'uniTextfield',
            name: 'SLIP_NUM_FR'
        },{
            xtype: 'uniTextfield',
            name: 'SLIP_NUM_TO'
        },{
            xtype: 'uniTextfield',
            name: 'INCLUDE_DELETE'
            
        },{
            xtype: 'uniTextfield',
            name: 'POSTIT'
        },{
            xtype: 'uniTextfield',
            name: 'EX_NUM_FR'
        },{
            xtype: 'uniTextfield',
            name: 'EX_NUM_TO'
        },{
            xtype: 'uniTextfield',
            name: 'AMT_I_FR'
        },{
            xtype: 'uniTextfield',
            name: 'AMT_I_TO'
        },{
            xtype: 'uniTextfield',
            name: 'FOR_AMT_I_FR'
        },{
            xtype: 'uniTextfield',
            name: 'FOR_AMT_I_TO'
        },{
            xtype: 'uniTextfield',
            name: 'CHARGE_CODE'
        },{
            xtype: 'uniTextfield',
            name: 'CHARGE_NAME'
        },{
            xtype: 'uniTextfield',
            name: 'REMARK'
        },{
            xtype: 'uniTextfield',
            name: 'POSTIT_YN'
        },{
            xtype: 'uniTextfield',
            name: 'INCLUD_YN'
        }]
    });
    
	/* 검색조건 (Search Panel)
	 * @type 
	 */    
	var panelSearch = Unilite.createSearchPanel('searchForm', {		
		title: '검색조건',
        defaultType: 'uniSearchSubPanel',
        collapsed:true,
        listeners: {
	        collapse: function () {
	            panelResult.show();
	        },
	        expand: function() {
	        	panelResult.hide();
	        }
        },
		items: [{	
			title: '기본정보', 	
   			itemId: 'search_panel1',
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',
		    items : [{ 
    			fieldLabel: '전표일',
		        xtype: 'uniDateRangefield',
		        startFieldName: 'AC_DATE_FR',
		        endFieldName: 'AC_DATE_TO',
		        width: 470,
		        startDate: UniDate.get('today'),
		        endDate: UniDate.get('today'),
		        allowBlank: false,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelResult) {
						panelResult.setValue('AC_DATE_FR',newValue);
			    	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelResult) {
			    		panelResult.setValue('AC_DATE_TO',newValue);
			    	}
			    }
	        }, { 
    			fieldLabel: '입력일',
		        xtype: 'uniDateRangefield',
		        startFieldName: 'INPUT_DATE_FR',
		        endFieldName: 'INPUT_DATE_TO',
		        width: 470,
		        startDate: UniDate.get(''),
		        endDate: UniDate.get(''),
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelResult) {
							panelResult.setValue('INPUT_DATE_FR',newValue);
	                	}
				    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelResult) {
			    		panelResult.setValue('INPUT_DATE_TO',newValue);
			    	}
			    }
	        },{
		        fieldLabel: '사업장',
			    name:'ACCNT_DIV_CODE', 
			    xtype: 'uniCombobox',
				multiSelect: true, 
				typeAhead: false,
				value:UserInfo.divCode,
				comboType:'BOR120',
			    width: 325,
			    colspan:2,
			    listeners: {
					change: function(field, newValue, oldValue, eOpts) {      
						panelResult.setValue('ACCNT_DIV_CODE', newValue);
					}
				}
		    },   
	        	Unilite.popup('DEPT',{
		        fieldLabel: '입력부서',
		        validateBlank:true,
		        autoPopup:true,
			    valueFieldName:'IN_DEPT_CODE',
			    textFieldName:'IN_DEPT_NAME',
	        	listeners: {
					onValueFieldChange: function(field, newValue){
						panelResult.setValue('IN_DEPT_CODE', newValue);								
					},
					onTextFieldChange: function(field, newValue){
						panelResult.setValue('IN_DEPT_NAME', newValue);				
					},
					applyextparam: function(popup){							
						popup.setExtParam({'ACCNT_DIV_CODE': panelSearch.getValue('ACCNT_DIV_CODE')});
					}
				}
		    }),
        	//CUST 팝업 오류로 임시로 BCM100t [RETURN_CODE]컬럼 추가(추후 확인)
        	Unilite.popup('CUST',{
		        fieldLabel: '거래처',
		        allowBlank:true,
				autoPopup:false,
				validateBlank:false,
		        /*extParam:{'CUSTOM_TYPE':'3'}*/
			    valueFieldName:'CUSTOM_CODE',
			    textFieldName:'CUSTOM_NAME',
				extParam: {'CUSTOM_TYPE': ['1','2','3']},
				listeners: {
					onValueFieldChange: function(field, newValue, oldValue){
						panelResult.setValue('CUSTOM_CODE', newValue);
						
						if(!Ext.isObject(oldValue)) {
							panelResult.setValue('CUSTOM_NAME', '');
							panelSearch.setValue('CUSTOM_NAME', '');
						}
					},
					onTextFieldChange: function(field, newValue, oldValue){
						panelResult.setValue('CUSTOM_NAME', newValue);
						
						if(!Ext.isObject(oldValue)) {
							panelResult.setValue('CUSTOM_CODE', '');
							panelSearch.setValue('CUSTOM_CODE', '');
						}
					},
					applyextparam: function(popup){							
						popup.setExtParam({'ACCNT_DIV_CODE': panelSearch.getValue('ACCNT_DIV_CODE')});
					}
				}		        
		    }),{
				xtype: 'container',
				layout: {type: 'uniTable', column: 2},
				items: [{
					fieldLabel: '전표구분',
					xtype: 'uniCombobox',
					name: 'SLIP_TYPE',
					comboType: 'AU',
					comboCode:'A023',
					width: 172,
		        	allowBlank: false,
		        	value: '1',
		        	listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.setValue('SLIP_TYPE', newValue);
						}
					}
				}, {
					fieldLabel: '승인여부',
					xtype: 'uniCombobox',
					name: 'AP_STS',
					comboType: 'AU',
					comboCode:'A014',
					labelWidth: 50,
					width: 153,
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.setValue('AP_STS', newValue);
						}
					}
				}]
			},{
                fieldLabel: '거래처분류',
                xtype: 'uniCombobox',
                name: 'AGENT_TYPE',
                comboType: 'AU',
                comboCode:'B055',
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {                        
                        panelResult.setValue('AGENT_TYPE', newValue);
                    }
                }
            },
			Unilite.popup('DEPT',{
                fieldLabel: '귀속부서',
                validateBlank:true,
		        autoPopup:true,
                valueFieldName:'DEPT_CODE',
                textFieldName:'DEPT_NAME',
                listeners: {
                    onValueFieldChange: function(field, newValue){
                        panelResult.setValue('DEPT_CODE', newValue);                              
                    },
                    onTextFieldChange: function(field, newValue){
                        panelResult.setValue('DEPT_NAME', newValue);              
                    }
                }
            }),
            {
                fieldLabel: '화폐단위',
                xtype: 'uniCombobox',
                name: 'MONEY_UNIT',
                comboType: 'AU',
                comboCode:'B004',
		 		displayField: 'value',
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {                        
                        panelResult.setValue('MONEY_UNIT', newValue);
                    }
                }
            },
            Unilite.popup('ACCNT',{
		    	fieldLabel: '계정과목',
		    	valueFieldName: 'ACCNT',
		    	textFieldName: 'ACCNT_NAME',
                listeners: {
                    onValueFieldChange: function(field, newValue){
                        panelResult.setValue('ACCNT', newValue);                              
                    },
                    onTextFieldChange: function(field, newValue){
                        panelResult.setValue('ACCNT_NAME', newValue);              
                    }
                }		    	
		    }), {
    			fieldLabel: '입력경로',
    			name:'INPUT_PATH', 
    			xtype: 'uniCombobox', 
    			comboType:'AU',
    			comboCode:'A011',
    			width:325,
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {                        
                        panelResult.setValue('INPUT_PATH', newValue);
                    }
                }    			
    		},{
			    xtype: 'container',
				layout: {type : 'uniTable', columns : 3},
				width:325,
				items :[{
					fieldLabel:'회계번호', 
					xtype: 'uniTextfield',
					name: 'SLIP_NUM_FR', 
					width:203,
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.setValue('SLIP_NUM_FR', newValue);
						}
					}					
				},{
					xtype:'component', 
					html:'~',
					style: {
						marginTop: '3px !important',
						font: '12px "굴림",Gulim,tahoma,arial,verdana,sans-serif'
					}
				},{
					fieldLabel:'', 
					xtype: 'uniTextfield',
					name: 'SLIP_NUM_TO', 
					width: 112,
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.setValue('SLIP_NUM_TO', newValue);
						}
					}						
				}]
			}]
		}, {	
			title: '추가정보', 	
   			itemId: 'search_panel2',
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',
		    items : [{
				fieldLabel: '조건',
				name: 'CHECK',
				id: 'CHECK_ID',
				xtype: 'uniCheckboxgroup', 
				width: 400, 
				items: [{
		        	boxLabel: '수정삭제이력표시',
		        	name: 'INCLUDE_DELETE',
		        	uncheckedValue: 'N',
	        		inputValue: 'Y'
		        },{
		        	boxLabel: '각주',
		        	name: 'POSTIT_YN',
		        	uncheckedValue: 'N',
	        		inputValue: 'Y',
	        		listeners: {
       				 	change: function(field, newValue, oldValue, eOpts) {
       				 		if(panelSearch.getValue('POSTIT_YN')) {
								panelSearch.getField('POSTIT').setReadOnly(false);
       				 		} else {
								panelSearch.getField('POSTIT').setReadOnly(true);
       				 		}
						}
		        	}
				}]
			}, {
		    	xtype: 'uniTextfield',
		    	fieldLabel: '각주',
		    	width: 325,
		    	readOnly: true,
		    	name:'POSTIT'
		    }, {
			    xtype: 'container',
				layout: {type : 'uniTable', columns : 3},
				width:325,
				items :[{
					fieldLabel:'결의번호', 
					xtype: 'uniTextfield',
					name: 'EX_NUM_FR', 
					width:203
				},{
					xtype:'component', 
					html:'~',
					style: {
						marginTop: '3px !important',
						font: '12px "굴림",Gulim,tahoma,arial,verdana,sans-serif'
					}
				},{
					fieldLabel:'', 
					xtype: 'uniTextfield',
					name: 'EX_NUM_TO', 
					width: 112
				}]
			}, {
			    xtype: 'container',
				layout: {type : 'uniTable', columns : 3},
				width:325,
				items :[{
					fieldLabel:'금액', 
					xtype: 'uniTextfield',
					name: 'AMT_I_FR', 
					width:203
				},{
					xtype:'component', 
					html:'~',
					style: {
						marginTop: '3px !important',
						font: '12px "굴림",Gulim,tahoma,arial,verdana,sans-serif'
					}
				},{
					fieldLabel:'', 
					xtype: 'uniTextfield',
					name: 'AMT_I_TO', 
					width: 112
				}]
			}, {
			    xtype: 'container',
				layout: {type : 'uniTable', columns : 3},
				width:325,
				items :[{
					fieldLabel:'외화금액', 
					xtype: 'uniTextfield',
					name: 'FOR_AMT_I_FR', 
					width:203
				},{
					xtype:'component', 
					html:'~',
					style: {
						marginTop: '3px !important',
						font: '12px "굴림",Gulim,tahoma,arial,verdana,sans-serif'
					}
				},{
					fieldLabel:'', 
					xtype: 'uniTextfield',
					name: 'FOR_AMT_I_TO', 
					width: 112
				}]
			},{
			    xtype: 'uniTextfield',
			    name: 'REMARK',
			    fieldLabel: '적요',
			    width: 325
			},
		    	Unilite.popup('ACCNT_PRSN',{
		    	fieldLabel: '입력자',
		    	validateBlank:false,
		    	valueFieldName:'CHARGE_CODE',
			    textFieldName:'CHARGE_NAME'
		    }),
		    {
				fieldLabel: ' ',
				name: '',
				xtype: 'checkboxgroup', 
				width: 400, 
				items: [{
		        	boxLabel: '하위부서포함',
		        	name: 'INCLUD_YN',
		        	uncheckedValue: 'N',
	        		inputValue: 'Y'
		        }]
			}]		
		}]
	});  
	
	var panelResult = Unilite.createSearchForm('panelResultForm', {		
		region: 'north',
		layout : {type : 'uniTable', columns : 3		
//		,tableAttrs: {style: 'border : 1px solid #ced9e7;'/*, width: '100%'*/},
//			tdAttrs: {style: 'border : 1px solid #ced9e7;'/*, align : 'center'*/}
		},
		padding:'1 1 1 1',
		border:true,
		items : [{ 
			fieldLabel: '전표일',
	        xtype: 'uniDateRangefield',
	        startFieldName: 'AC_DATE_FR',
	        endFieldName: 'AC_DATE_TO',
	        //width: 470,
	        tdAttrs: {width: 380},  
	        startDate: UniDate.get('today'),
	        endDate: UniDate.get('today'),
	        allowBlank: false,
			onStartDateChange: function(field, newValue, oldValue, eOpts) {
		    	if(panelSearch) {
					panelSearch.setValue('AC_DATE_FR',newValue);
		    	}
		    },
		    onEndDateChange: function(field, newValue, oldValue, eOpts) {
		    	if(panelSearch) {
		    		panelSearch.setValue('AC_DATE_TO',newValue);
		    	}
		    }
        },   
        	Unilite.popup('DEPT',{
	        fieldLabel: '입력부서',
	        validateBlank:true,
		    autoPopup:true,
		    valueFieldName:'IN_DEPT_CODE',
		    textFieldName:'IN_DEPT_NAME',
	        tdAttrs: {width: 380},  
        	listeners: {
				onValueFieldChange: function(field, newValue){
					panelSearch.setValue('IN_DEPT_CODE', newValue);								
				},
				onTextFieldChange: function(field, newValue){
					panelSearch.setValue('IN_DEPT_NAME', newValue);				
				},
				applyextparam: function(popup){							
					popup.setExtParam({'ACCNT_DIV_CODE': panelResult.getValue('ACCNT_DIV_CODE')});
				}
			}
	    }),{
	        fieldLabel: '사업장',
		    name:'ACCNT_DIV_CODE', 
		    xtype: 'uniCombobox',
			multiSelect: true, 
			typeAhead: false,
			value:UserInfo.divCode,
			comboType:'BOR120',
		    width: 325,
		    listeners: {
				change: function(field, newValue, oldValue, eOpts) {      
				panelSearch.setValue('ACCNT_DIV_CODE', newValue);
				}
     		}
		}, { 
			fieldLabel: '입력일',
	        xtype: 'uniDateRangefield',
	        startFieldName: 'INPUT_DATE_FR',
	        endFieldName: 'INPUT_DATE_TO',
	        //width: 470,
	        startDate: UniDate.get(''),
	        endDate: UniDate.get(''),
			onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelSearch) {
						panelSearch.setValue('INPUT_DATE_FR',newValue);
                	}
			    },
		    onEndDateChange: function(field, newValue, oldValue, eOpts) {
		    	if(panelSearch) {
		    		panelSearch.setValue('INPUT_DATE_TO',newValue);
		    	}
		    }
        },
        //CUST 팝업 오류로 임시로 BCM100t [RETURN_CODE]컬럼 추가(추후 확인)
        Unilite.popup('CUST',{
	        fieldLabel: '거래처',
	        allowBlank:true,
			autoPopup:false,
			validateBlank:false,
	        //extParam:{'CUSTOM_TYPE':'3'}, //1, 2, 3 나오게 하는 로직은 아직 구현이 안 됨
			/*CUSTOM_TYPE [전체:"", 공통:"1", 매입:"2", 매출:"3", 금융:"4", 멀티:"('1', '2', ~)"]*/
		    valueFieldName:'CUSTOM_CODE',
		    textFieldName:'CUSTOM_NAME',
			extParam: {'CUSTOM_TYPE': ['1','2','3']},
        	listeners: {
				onValueFieldChange: function(field, newValue, oldValue){
					panelSearch.setValue('CUSTOM_CODE', newValue);
					
					if(!Ext.isObject(oldValue)) {
						panelResult.setValue('CUSTOM_NAME', '');
						panelSearch.setValue('CUSTOM_NAME', '');
					}
				},
				onTextFieldChange: function(field, newValue, oldValue){
					panelSearch.setValue('CUSTOM_NAME', newValue);
					
					if(!Ext.isObject(oldValue)) {
						panelResult.setValue('CUSTOM_CODE', '');
						panelSearch.setValue('CUSTOM_CODE', '');
					}
				},
				applyextparam: function(popup){							
					popup.setExtParam({'ACCNT_DIV_CODE': panelResult.getValue('ACCNT_DIV_CODE')});
				}
			}		        
	    }),{
			xtype: 'container',
			layout: {type: 'uniTable', column: 2},
			items: [{
				fieldLabel: '전표구분',
				xtype: 'uniCombobox',
				name: 'SLIP_TYPE',
				comboType: 'AU',
				comboCode:'A023',
				width: 172,
	        	allowBlank: false,
	        	value: '1',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
	                    panelSearch.setValue('SLIP_TYPE', newValue);
	                    if(newValue == '1'){
	                        masterGrid.getColumn('AC_DATE').setText('회계일');
	                        masterGrid.getColumn('EX_DATE').setText('결의일');
	                    }
	                    if(newValue == '2'){
	                        masterGrid.getColumn('AC_DATE').setText('결의일');
	                        masterGrid.getColumn('EX_DATE').setText('회계일');
	                    }
                    }
                }
			}, {
				fieldLabel: '승인여부',
				xtype: 'uniCombobox',
				name: 'AP_STS',
				comboType: 'AU',
				comboCode:'A014',
				labelWidth: 70,
				width: 152,
				listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('AP_STS', newValue);
					}
				}
			}]
		},{
            fieldLabel: '거래처분류',
            xtype: 'uniCombobox',
            name: 'AGENT_TYPE',
            comboType: 'AU',
            comboCode:'B055',
            listeners: {
                change: function(field, newValue, oldValue, eOpts) {                        
                    panelSearch.setValue('AGENT_TYPE', newValue);
                }
            }
        },
        Unilite.popup('DEPT',{
            fieldLabel: '귀속부서',
            validateBlank:true,
		    autoPopup:true,
            valueFieldName:'DEPT_CODE',
            textFieldName:'DEPT_NAME',
            listeners: {
                onValueFieldChange: function(field, newValue){
                    panelSearch.setValue('DEPT_CODE', newValue);                              
                },
                onTextFieldChange: function(field, newValue){
                    panelSearch.setValue('DEPT_NAME', newValue);              
                }
            }
        }),
        {
            fieldLabel: '화폐단위',
            xtype: 'uniCombobox',
            name: 'MONEY_UNIT',
            comboType: 'AU',
            comboCode:'B004',
		 	displayField: 'value',
            listeners: {
                change: function(field, newValue, oldValue, eOpts) {                        
                    panelSearch.setValue('MONEY_UNIT', newValue);
                }
            }
        },
        Unilite.popup('ACCNT',{
	    	fieldLabel: '계정과목',
	    	valueFieldName: 'ACCNT',
	    	textFieldName: 'ACCNT_NAME',
	    	autoPopup: true,
            listeners: {
                onValueFieldChange: function(field, newValue){
                    panelSearch.setValue('ACCNT', newValue);                              
                },
                onTextFieldChange: function(field, newValue){
                    panelSearch.setValue('ACCNT_NAME', newValue);              
                }
            }		    	
	    }), {
			fieldLabel: '입력경로',
			name:'INPUT_PATH', 
			xtype: 'uniCombobox', 
			comboType:'AU',
			comboCode:'A011',
			width:325,
            listeners: {
                change: function(field, newValue, oldValue, eOpts) {                        
                    panelSearch.setValue('INPUT_PATH', newValue);
                }
            }    			
		},{
		    xtype: 'container',
			layout: {type : 'uniTable', columns : 3},
			width:325,
			items :[{
				fieldLabel:'회계번호', 
				xtype: 'uniTextfield',
				name: 'SLIP_NUM_FR', 
				width:203,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('SLIP_NUM_FR', newValue);
					}
				}					
			},{
				xtype:'component', 
				html:'~',
				style: {
					marginTop: '3px !important',
					font: '12px "굴림",Gulim,tahoma,arial,verdana,sans-serif'
				}
			},{
				fieldLabel:'', 
				xtype: 'uniTextfield',
				name: 'SLIP_NUM_TO', 
				width: 112,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('SLIP_NUM_TO', newValue);
					}
				}						
			}]        
		}]
	});    
   
	/* Master Grid1 정의(Grid Panel)
     * @type 
     */
	var masterGrid = Unilite.createGrid('agj240skrGrid', {
		layout: 'fit',
        region:'center',
    	store: masterStore,
		selModel:'rowmodel',
		uniOpt : {								
		    useLiveSearch: false,			
		    onLoadSelectFirst: false,				
		    dblClickToEdit: false,			
		    useGroupSummary: false,			
			useContextMenu: false,		
			useRowNumberer: true,		
			expandLastColumn: false,			
			useRowContext: true,
		    filter: {					
				useFilter: false,	
				autoCreate: false	
			},
			excel: {
				useExcel: false,			//엑셀 다운로드 사용 여부
				exportGroup: false, 		//group 상태로 export 여부
				onlyData:false
			}
			
        },
        sortableColumns : false,
    	/*features: [ {id : 'masterGridSubTotal', ftype: 'uniGroupingsummary',	showSummaryRow: false },
    	           	{id : 'masterGridTotal', 	ftype: 'uniSummary',			showSummaryRow: false, 	  		dock : 'top'} ],
    	*/
        setSummaryData:function(record)	{
        	var me = this;
        	var drAmtField = me.down("#sum_drAmtI");
        	var crAmtField = me.down("#sum_crAmtI");
        	if(record){
	        	
	        	drAmtField.setValue(Ext.util.Format.number(record.get("SUM_DR_AMT_I"), UniFormat.Price));
	        	crAmtField.setValue(Ext.util.Format.number(record.get("SUM_CR_AMT_I"), UniFormat.Price));
        	}else {
	        	drAmtField.setValue(0);
	        	crAmtField.setValue(0);
        	}
        },
        tbar:[{
        	xtype: 'displayfield',
	        fieldLabel: '차변합계',
	        labelAlign : 'right',
	        itemId:'sum_drAmtI',
	        width:250,
	        name: 'SUM_DR_AMT_I',
	        value: 0
    	},'-',{
    		xtype: 'displayfield',
	        fieldLabel: '대변합계',
	        labelAlign : 'right',
	        itemId:'sum_crAmtI',
	        name: 'SUM_DR_AMT_I',
	        width:250,
	        value: 0
    	}],
        columns:  [ 
//        { dataIndex:'SLIP_TYPE'        	, 	width:80}, 	
//				{ dataIndex:'AP_STS'       	, 	width:80},				
//			{ dataIndex:'INPUT_PATH'       	, 	width:80}, 			
//			{ dataIndex:'INPUT_DIVI'       	, 	width:80}, 
			//{ dataIndex:'GUBUN'			 	, 	width:46,	hidden:true}, 				
			//{ dataIndex:'AUTO_NUM'		 	, 	width:46,	hidden:true}, 				
	   		{ dataIndex:'AC_DATE'		 	, 	width:80,	locked:true,	
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
				       return Unilite.renderSummaryRow(summaryData, metaData, '합계', '합계');
		    	}
	   		}, 				
			{ dataIndex:'SLIP_NUM'		 	, 	width:46,	locked:true,	align: 'center'}, 				
			{ dataIndex:'SLIP_SEQ'		 	, 	width:46,	locked:true,	align: 'center'}, 				
			{ dataIndex:'ACCNT'				, 	width:100,	locked:true}, 				
			{ dataIndex:'ACCNT_NAME'		, 	width:140,	locked:true}, 		
			{ dataIndex:'DR_AMT_I'          ,   width:100,  locked:true},              
            { dataIndex:'CR_AMT_I'          ,   width:100,  locked:true},     
            { dataIndex:'REMARK'            ,   width:333 ,
                renderer:function(value, metaData, record)  {
                    var r = value;
                    if(record.get('POSTIT_YN') == 'Y') r ='<img src="'+CPATH+'/resources/images/PostIt.gif"/>'+value
                    return r;
                }
            },                
            { dataIndex:'CUSTOM_CODE'       ,   width:80},               
            { dataIndex:'CUSTOM_NAME'       ,   width:180},
            { dataIndex:'DIV_NAME'          ,   width:100},  
			{ dataIndex:'DEPT_CODE'			, 	width:86    }, 				
			{ dataIndex:'DEPT_NAME'   	 	, 	width:100   }, 
			{ dataIndex:'AC_CODE1'        	, 	width:80,	hidden:true}, 
			{ dataIndex: 'AC_DATA1'      	,width:100,
				renderer:function(value, metaData, record)	{
					var r = value;
					if(record.data.AC_FORMAT1 == 'I'){
						r = '<div align="right">'+ Ext.util.Format.number(value, UniFormat.Price)+'</div>'
					} else if(record.data.AC_FORMAT1 == 'O'){
						r = '<div align="right">'+ Ext.util.Format.number(value, UniFormat.FC)+'</div>'
					} else if(record.data.AC_FORMAT1 == 'R'){
						r = '<div align="right">'+ Ext.util.Format.number(value, UniFormat.ER)+'</div>'
					} else if(record.data.AC_FORMAT1 == 'P'){
						r = '<div align="right">'+ Ext.util.Format.number(value, UniFormat.Price)+'</div>'
					} else if(record.data.AC_FORMAT1 == 'Q'){ 
						r = '<div align="right">'+ Ext.util.Format.number(value, UniFormat.Qty)+'</div>'
					}
					return r;
				}
			}, 				
			{ dataIndex:'AC_DATA_NAME1'   	, 	width:120   }, 				
			{ dataIndex:'AC_CODE2'        	, 	width:80,	hidden:true}, 				
			{ dataIndex: 'AC_DATA2'      	,width:100,
				renderer:function(value, metaData, record)	{
					var r = value;
					if(record.data.AC_FORMAT2 == 'I'){
						r = '<div align="right">'+ Ext.util.Format.number(value, UniFormat.Price)+'</div>'
					} else if(record.data.AC_FORMAT2 == 'O'){
						r = '<div align="right">'+ Ext.util.Format.number(value, UniFormat.FC)+'</div>'
					} else if(record.data.AC_FORMAT2 == 'R'){
						r = '<div align="right">'+ Ext.util.Format.number(value, UniFormat.ER)+'</div>'
					} else if(record.data.AC_FORMAT2 == 'P'){
						r = '<div align="right">'+ Ext.util.Format.number(value, UniFormat.Price)+'</div>'
					} else if(record.data.AC_FORMAT2 == 'Q'){ 
						r = '<div align="right">'+ Ext.util.Format.number(value, UniFormat.Qty)+'</div>'
					}
					return r;
				}
			}, 				
			{ dataIndex:'AC_DATA_NAME2'   	, 	width:120   }, 				
			{ dataIndex:'AC_CODE3'        	, 	width:80,	hidden:true}, 				
			{ dataIndex: 'AC_DATA3'      	,width:100,
				renderer:function(value, metaData, record)	{
					var r = value;
					if(record.data.AC_FORMAT3 == 'I'){
						r = '<div align="right">'+ Ext.util.Format.number(value, UniFormat.Price)+'</div>'
					} else if(record.data.AC_FORMAT3 == 'O'){
						r = '<div align="right">'+ Ext.util.Format.number(value, UniFormat.FC)+'</div>'
					} else if(record.data.AC_FORMAT3 == 'R'){
						r = '<div align="right">'+ Ext.util.Format.number(value, UniFormat.ER)+'</div>'
					} else if(record.data.AC_FORMAT3 == 'P'){
						r = '<div align="right">'+ Ext.util.Format.number(value, UniFormat.Price)+'</div>'
					} else if(record.data.AC_FORMAT3 == 'Q'){ 
						r = '<div align="right">'+ Ext.util.Format.number(value, UniFormat.Qty)+'</div>'
					}
					return r;
				}
			}, 				
			{ dataIndex:'AC_DATA_NAME3'   	, 	width:120   }, 				
			{ dataIndex:'AC_CODE4'        	, 	width:80,	hidden:true}, 				
			{ dataIndex: 'AC_DATA4'      	,width:100,
				renderer:function(value, metaData, record)	{
					var r = value;
					if(record.data.AC_FORMAT4 == 'I'){
						r = '<div align="right">'+ Ext.util.Format.number(value, UniFormat.Price)+'</div>'
					} else if(record.data.AC_FORMAT4 == 'O'){
						r = '<div align="right">'+ Ext.util.Format.number(value, UniFormat.FC)+'</div>'
					} else if(record.data.AC_FORMAT4 == 'R'){
						r = '<div align="right">'+ Ext.util.Format.number(value, UniFormat.ER)+'</div>'
					} else if(record.data.AC_FORMAT4 == 'P'){
						r = '<div align="right">'+ Ext.util.Format.number(value, UniFormat.Price)+'</div>'
					} else if(record.data.AC_FORMAT4 == 'Q'){ 
						r = '<div align="right">'+ Ext.util.Format.number(value, UniFormat.Qty)+'</div>'
					}
					return r;
				}
			}, 				
			{ dataIndex:'AC_DATA_NAME4'   	, 	width:120   }, 				
			{ dataIndex:'AC_CODE5'        	, 	width:80,	hidden:true}, 				
			{ dataIndex: 'AC_DATA5'      	,width:100,
				renderer:function(value, metaData, record)	{
					var r = value;
					if(record.data.AC_FORMAT5 == 'I'){
						r = '<div align="right">'+ Ext.util.Format.number(value, UniFormat.Price)+'</div>'
					} else if(record.data.AC_FORMAT5 == 'O'){
						r = '<div align="right">'+ Ext.util.Format.number(value, UniFormat.FC)+'</div>'
					} else if(record.data.AC_FORMAT5 == 'R'){
						r = '<div align="right">'+ Ext.util.Format.number(value, UniFormat.ER)+'</div>'
					} else if(record.data.AC_FORMAT5 == 'P'){
						r = '<div align="right">'+ Ext.util.Format.number(value, UniFormat.Price)+'</div>'
					} else if(record.data.AC_FORMAT5 == 'Q'){ 
						r = '<div align="right">'+ Ext.util.Format.number(value, UniFormat.Qty)+'</div>'
					}
					return r;
				}
			}, 				
			{ dataIndex:'AC_DATA_NAME5'   	, 	width:120   }, 				
			{ dataIndex:'AC_CODE6'        	, 	width:80,	hidden:true}, 				
			{ dataIndex: 'AC_DATA6'      	,width:100,
				renderer:function(value, metaData, record)	{
					var r = value;
					if(record.data.AC_FORMAT6 == 'I'){
						r = '<div align="right">'+ Ext.util.Format.number(value, UniFormat.Price)+'</div>'
					} else if(record.data.AC_FORMAT6 == 'O'){
						r = '<div align="right">'+ Ext.util.Format.number(value, UniFormat.FC)+'</div>'
					} else if(record.data.AC_FORMAT6 == 'R'){
						r = '<div align="right">'+ Ext.util.Format.number(value, UniFormat.ER)+'</div>'
					} else if(record.data.AC_FORMAT6 == 'P'){
						r = '<div align="right">'+ Ext.util.Format.number(value, UniFormat.Price)+'</div>'
					} else if(record.data.AC_FORMAT6 == 'Q'){ 
						r = '<div align="right">'+ Ext.util.Format.number(value, UniFormat.Qty)+'</div>'
					}
					return r;
				}
			}, 				
			{ dataIndex:'AC_DATA_NAME6'   	, 	width:120   },
			{ dataIndex:'PROOF_KIND'		, 	width:133   }, 				
			//{ dataIndex:'CREDIT_NUM'		, 	width:140,	hidden: true}, 	
			{ dataIndex:'CREDIT_NUM_EXPOS'  ,	width:120  , align:'center'},
			{ dataIndex:'REASON_CODE'	 	, 	width:146   }, 				
			{ dataIndex:'EX_DATE'		 	, 	width:80    }, 				
			{ dataIndex:'EX_NUM'			, 	width:66,	align: 'center'}, 				
			{ dataIndex:'MONEY_UNIT'		, 	width:66    }, 				
			{ dataIndex:'EXCHG_RATE_O'	 	, 	width:66    }, 				
			{ dataIndex:'FOR_AMT_I'			, 	width:80    }, 				
			{ dataIndex:'CHARGE_NAME'	 	, 	width:66    }, 				
			{ dataIndex:'INPUT_DATE'		, 	width:80    }, 				
			{ dataIndex:'AP_CHARGE_NAME'	,   width:66    },
			{ dataIndex:'AP_DATE'			,   width:80    }
							
//			{ dataIndex:'POSTIT_YN'        	, 	width:80,	hidden:true}, 				
//			{ dataIndex:'POSTIT'        	, 	width:80,	hidden:true}, 				
//			{ dataIndex:'POSTIT_USER_ID'   	, 	width:80,	hidden:true}, 				
//			{ dataIndex:'INPUT_PATH'       	, 	width:80,	hidden:true}, 				
//			{ dataIndex:'MOD_DIVI'        	, 	width:80,	hidden:true}, 				
//			{ dataIndex:'DIV_CODE'   	, 	width:80,	hidden:true}, 				
//			{ dataIndex:'INPUT_DIVI'       	, 	width:80,	hidden:true}, 				
			
        ],
		listeners: {
          	//각주 이미지 툴바에 정의
			render:function(grid, eOpt)	{
    			grid.getEl().on('click', function(e, t, eOpt) {
			    	activeGrid = grid.getItemId();
			    });
//			    var b = isTbar;
			    var i=0;
//			    if(b)	{
//			    	i=0;
//			    }
    			var tbar = grid._getToolBar();
    			tbar[0].insert(i++,{
		        	xtype: 'uniBaseButton',
		        	iconCls: 'icon-postit',
		        	width: 26, height: 26,
		        	tooltip:'각주',
		        	handler:function()	{
		        		openPostIt(grid);
		        	}
		        });
		        tbar[0].insert(tbar.length + 1, {
                    xtype: 'uniBaseButton',
                    iconCls: 'icon-excel',
                    width: 26, 
                    height: 26,
                    tooltip: '엑셀 다운로드',
                    handler: function() { 
                    	var form = panelFileDown;

                        form.setValue('AC_DATE_FR',    UniDate.getDbDateStr(panelSearch.getValue('AC_DATE_FR')));         // 전표시작일
                        form.setValue('AC_DATE_TO',    UniDate.getDbDateStr(panelSearch.getValue('AC_DATE_TO')));         // 전표종료일
                        form.setValue('INPUT_DATE_FR',    UniDate.getDbDateStr(panelSearch.getValue('INPUT_DATE_FR')));   // 입력종료일
                        form.setValue('INPUT_DATE_TO',    UniDate.getDbDateStr(panelSearch.getValue('INPUT_DATE_TO')));   // 입력종료일
                        form.setValue('ACCNT_DIV_CODE',      panelSearch.getValue('ACCNT_DIV_CODE'));            // 사업장
                        form.setValue('IN_DEPT_CODE', panelSearch.getValue('IN_DEPT_CODE'));                     // 입력부서
                        form.setValue('IN_DEPT_NAME', panelSearch.getValue('IN_DEPT_NAME'));                     // 입력부서
                        form.setValue('CUSTOM_CODE', panelSearch.getValue('CUSTOM_CODE'));          // 거래처
                        form.setValue('CUSTOM_NAME', panelSearch.getValue('CUSTOM_NAME'));          // 거래처
                        form.setValue('SLIP_TYPE', panelSearch.getValue('SLIP_TYPE'));              // 전표구분
                        form.setValue('AP_STS', panelSearch.getValue('AP_STS'));                    // 승인여부
                        form.setValue('AGENT_TYPE', panelSearch.getValue('AGENT_TYPE'));            // 거래처분류
                        form.setValue('DEPT_CODE', panelSearch.getValue('DEPT_CODE'));              // 귀속부서
                        form.setValue('DEPT_NAME', panelSearch.getValue('DEPT_NAME'));              // 귀속부서
                        form.setValue('MONEY_UNIT', panelSearch.getValue('MONEY_UNIT'));            // 화폐단위
                        form.setValue('ACCNT', panelSearch.getValue('ACCNT'));                      // 계정과목
                        form.setValue('ACCNT_NAME', panelSearch.getValue('ACCNT_NAME'));            // 계정과목
                        form.setValue('INPUT_PATH', panelSearch.getValue('INPUT_PATH'));            // 입력경로
                        form.setValue('SLIP_NUM_FR', panelSearch.getValue('SLIP_NUM_FR'));          // 회계번호
                        form.setValue('SLIP_NUM_TO', panelSearch.getValue('SLIP_NUM_TO'));          // 회계번호
                        if(panelSearch.getValue('INCLUDE_DELETE') == false){
                            form.setValue('INCLUDE_DELETE','N');    // 수정삭제이력표시
                        }
                        else{
                        	form.setValue('INCLUDE_DELETE','Y');    // 수정삭제이력표시
                        }
                        form.setValue('POSTIT', panelSearch.getValue('POSTIT'));                    // 각주
                        form.setValue('EX_NUM_FR', panelSearch.getValue('EX_NUM_FR'));              // 결의번호
                        form.setValue('EX_NUM_TO', panelSearch.getValue('EX_NUM_TO'));              // 결의번호
                        form.setValue('AMT_I_FR', panelSearch.getValue('AMT_I_FR'));                // 금액
                        form.setValue('AMT_I_TO', panelSearch.getValue('AMT_I_TO'));                // 금액
                        form.setValue('FOR_AMT_I_FR', panelSearch.getValue('FOR_AMT_I_FR'));        // 외화금액
                        form.setValue('FOR_AMT_I_TO', panelSearch.getValue('FOR_AMT_I_TO'));        // 외화금액
                        form.setValue('CHARGE_CODE', panelSearch.getValue('CHARGE_CODE'));          // 입력자
                        form.setValue('CHARGE_NAME', panelSearch.getValue('CHARGE_NAME'));          // 입력자
                        form.setValue('REMARK', panelSearch.getValue('REMARK'));                    // 적요
                        
                        if(panelSearch.getValue('POSTIT_YN') == false){
                            form.setValue('POSTIT_YN','N');    // 각주
                        }
                        else{
                            form.setValue('POSTIT_YN','Y');     // 각주
                        }
                        
                        if(panelSearch.getValue('INCLUD_YN') == false){
                            form.setValue('INCLUD_YN','N');    // 하위부서포함
                        }
                        else{
                            form.setValue('INCLUD_YN','Y');     // 하위부서포함
                        }
                        
                        var param = form.getValues();
                        
                        form.submit({
                            params: param,
                            success:function(comp, action)  {
                                Ext.getBody().unmask();
                            },
                            failure: function(form, action){
                                Ext.getBody().unmask();
                            }                   
                        }); 
                    }
                });
    		},
    		
	      	itemmouseenter:function(view, record, item, index, e, eOpts )	{          		
//	        	view.ownerGrid.setCellPointer(view, item);							//마우스 오른쪽 링크기능 삭제 (20170110)
    		},
    		
    		//신용카드/현금영수증 번호 확인을 위해 해당 컬럼은 번호보기, 나머지는 링크이동 시 이용
        	beforecelldblclick : function( view, td, cellIndex, record, tr, rowIndex, e, eOpts )	{
        		var columnName = view.eventPosition.column.dataIndex;

        		if(columnName == 'CREDIT_NUM_EXPOS'){
        			view.ownerGrid.openCryptCardNoPopup(record);    
        		} else {
					var modDivi		= record.data['MOD_DIVI'];
					var slipType	= record.data['SLIP_TYPE'];
					var inputDivi	= record.data['INPUT_DIVI'];
					var inputPath	= record.data['INPUT_PATH'];
					var apSts		= record.data['AP_STS'];
					//2016.12.23수정
					//20181008 수정
					if (Ext.isEmpty(modDivi)){	//수정삭제여부  빈값이 정상
						if (slipType == '1'){	//회계전표일떄
							if(inputDivi == '2' ){		//번호별 회계전표 화면 관련
								masterGrid.gotoAgj205ukr();
							} else {	//일반 회계전표 화면 관련
								masterGrid.gotoAgj200ukr();
							}
						} else {		//결의전표일때
							if(apSts == '2'){		//  승인
								if(inputDivi == '2' ){			//번호별 회계전표 화면 관련
									masterGrid.gotoAgj205ukr();
								} else if (inputDivi == '3'){	//INPUT_DIVI가 '3'일 경우 결의미결반제입력으로 이동
		            				masterGrid.gotoAgj110ukr();
								} else {						//일반 회계전표 화면 관련
									masterGrid.gotoAgj200ukr();
								}
							} else {			//	미승인
								if(inputDivi == '2' ){			//번호별 결의전표 화면 관련
									masterGrid.gotoAgj105ukr();
								} else if (inputDivi == '3'){	//INPUT_DIVI가 '3'일 경우 결의미결반제입력으로 이동
		            				masterGrid.gotoAgj110ukr();
								} else {						//일반 결의전표 화면 관련
									masterGrid.gotoAgj100ukr();
								}
							}
						}
					}				
				}        	
	        }  
		},
		openCryptCardNoPopup:function( record )	{
			if(record)	{
				var params = {'CRDT_FULL_NUM': record.get('CREDIT_NUM'), 'GUBUN_FLAG': '1', 'INPUT_YN': 'N'}
				Unilite.popupCipherComm('grid', record, 'CREDIT_NUM_EXPOS', 'CREDIT_NUM', params);
			}
				
		},
		gotoAgj100ukr:function()	{
    		var record = masterGrid.getSelectedRecord();
    		var param = {
    			'PGM_ID'			: 'agj240skr',
				'AC_DATE_FR'		: record.data['AC_DATE'],
				'AC_DATE_TO'		: record.data['AC_DATE'],
				
				'INPUT_PATH'		: record.data['INPUT_PATH'],
				
				'EX_NUM'			: record.data['SLIP_NUM'],
			
				'AP_STS'			: record.data['AP_STS'],
				'CHARGE_CODE'		: record.data['CHARGE_CODE'],
				'CHARGE_NAME'		: record.data['CHARGE_NAME'],
				'DEPT_CODE'			: record.data['DEPT_CODE'],
				'DEPT_NAME'			: record.data['DEPT_NAME'],
				'DIV_CODE'			: record.data['DIV_CODE']
    		};
	  		var rec1 = {data : {prgID : 'agj100ukr', 'text':''}};
			parent.openTab(rec1, '/accnt/agj100ukr.do', param);
    	},
		gotoAgj105ukr:function()	{
    		var record = masterGrid.getSelectedRecord();
    		var param = {
    			'PGM_ID'			: 'agj240skr',
				'AC_DATE'		: record.data['AC_DATE'],
				'EX_NUM'			: record.data['SLIP_NUM'],
				'INPUT_PATH'		: record.data['INPUT_PATH'],
				'AP_STS'			: record.data['AP_STS'],
				'CHARGE_CODE'		: record.data['CHARGE_CODE']
    		};
    		
	  		var rec1 = {data : {prgID : exSlipPgmId, 'text':''}};
			parent.openTab(rec1, exSlipPgmLink, param);
    	},
		gotoAgj110ukr:function()	{
    		var record = masterGrid.getSelectedRecord();
    		var param = {
    			'PGM_ID'			: 'agj240skr',
				'AC_DATE_FR'		: record.data['AC_DATE'],
				'AC_DATE_TO'		: record.data['AC_DATE'],
				'EX_DATE_FR'		: record.data['EX_DATE'],
				'EX_DATE_TO'		: record.data['EX_DATE'],
				'INPUT_PATH'		: record.data['INPUT_PATH'],
				'SLIP_NUM'			: record.data['SLIP_NUM'],
				'EX_NUM'			: record.data['SLIP_NUM'],
				'SLIP_SEQ'			: record.data['SLIP_SEQ'],
				'AP_STS'			: record.data['AP_STS'],
				'CHARGE_CODE'		: record.data['CHARGE_CODE'],
				'CHARGE_NAME'		: record.data['CHARGE_NAME'],
				'DEPT_CODE'			: record.data['DEPT_CODE'],
				'DEPT_NAME'			: record.data['DEPT_NAME'],
				'DIV_CODE'			: record.data['DIV_CODE'],
				'SLIP_DIVI'			: record.data['DIV_CODE']
    		};
	  		var rec1 = {data : {prgID : 'agj110ukr', 'text':''}};
			parent.openTab(rec1, '/accnt/agj110ukr.do', param);
    	},    	
		gotoAgj200ukr:function()	{
    		var record = masterGrid.getSelectedRecord();
    		if(record.data['SLIP_TYPE'] == '1'){
    			var param = {
	    			'PGM_ID'			: 'agj240skr',
					'AC_DATE_FR'		: record.data['AC_DATE'],
					'AC_DATE_TO'		: record.data['AC_DATE'],
					'EX_DATE_FR'		: record.data['EX_DATE'],
					'EX_DATE_TO'		: record.data['EX_DATE'],
					'INPUT_PATH'		: record.data['INPUT_PATH'],
					'SLIP_NUM'			: record.data['SLIP_NUM'],
//					'EX_NUM'			: record.data['EX_NUM'],
					'CHARGE_CODE'		: record.data['CHARGE_CODE'],
					'CHARGE_NAME'		: record.data['CHARGE_NAME'],
					'SLIP_TYPE'			: record.data['SLIP_TYPE']
	    		};
    		}else{
	    		var param = {
	    			'PGM_ID'			: 'agj240skr',
					'AC_DATE_FR'		: record.data['EX_DATE'],
					'AC_DATE_TO'		: record.data['EX_DATE'],
					'INPUT_PATH'		: record.data['INPUT_PATH'],
					'SLIP_NUM'			: record.data['EX_NUM'],
//					'EX_NUM'			: record.data['SLIP_NUM'],
					'CHARGE_CODE'		: record.data['CHARGE_CODE'],
					'CHARGE_NAME'		: record.data['CHARGE_NAME'],
					'SLIP_TYPE'			: record.data['SLIP_TYPE']
	    		};
    		}
	  		var rec1 = {data : {prgID : 'agj200ukr', 'text':''}};							
			parent.openTab(rec1, '/accnt/agj200ukr.do', param);
    	},
		gotoAgj205ukr:function()	{
    		var record = masterGrid.getSelectedRecord();
    		
    		if(record.data['SLIP_TYPE'] == '1'){
	    		var param = {
	    			'PGM_ID'			: 'agj240skr',
					'AC_DATE'		: record.data['AC_DATE'],
					'SLIP_NUM'			: record.data['SLIP_NUM'],
					'INPUT_PATH'		: record.data['INPUT_PATH'],
					'AP_STS'			: record.data['AP_STS'],
					'CHARGE_CODE'		: record.data['CHARGE_CODE']
	    		};
    		
    		}else{
	    		var param = {
	    			'PGM_ID'			: 'agj240skr',
					'AC_DATE'		: record.data['EX_DATE'],
					'SLIP_NUM'			: record.data['EX_NUM'],
					'INPUT_PATH'		: record.data['INPUT_PATH'],
					'AP_STS'			: record.data['AP_STS'],
					'CHARGE_CODE'		: record.data['CHARGE_CODE']
	    		};
    		}
	  		var rec1 = {data : {prgID : 'agj205ukr', 'text':''}};							
			parent.openTab(rec1, '/accnt/agj205ukr.do', param);
    	},
    	viewConfig: {
	        getRowClass: function(record, rowIndex, rowParams, store){
	        	var cls = '';
	        	
				if(record.get('MOD_DIVI') == 'D'){
					cls = 'x-change-celltext_red';	
				}
				return cls;
	        }
	    }
    });	 
    
	function openPostIt(grid)	{
		var record = grid.getSelectedRecord();
		if(record){
		    if(!postitWindow) {
				postitWindow = Ext.create('widget.uniDetailWindow', {
	                title: '각주',
	                width: 350,				                
	                height:100,
	            	
	                layout: {type:'vbox', align:'stretch'},	                
	                items: [{
	                	itemId:'remarkSearch',
	                	xtype:'uniSearchForm',
	                	items:[{	
                			fieldLabel:'각주',
                			labelWidth:60,
                			name : 'POSTIT',
                			width:300
                		}]
               		}],
	                tbar:  [
				         '->',{
							itemId : 'submitBtn',
							text: '확인',
							handler: function() {
								var postIt = postitWindow.down('#remarkSearch').getValue('POSTIT');
								var aGrid =grid;
								var record = aGrid.getSelectedRecord();
								var param = {
					 				SLIP_TYPE	: panelSearch.getValue('SLIP_TYPE'),
						 			AUTO_NUM	: record.get('AUTO_NUM'),
//									EX_NUM		: record.get('EX_NUM'),
//									EX_SEQ		: record.get('EX_SEQ'),
									SLIP_NUM	: record.get('SLIP_NUM'),
									SLIP_SEQ	: record.get('SLIP_SEQ'),
									EX_DATE	: UniDate.getDbDateStr(record.get('AC_DATE')),
									POSTIT		: postIt
								};
								agj240skrService.updatePostIt(param, function(provider, response){});
								postitWindow.hide();
								UniAppManager.app.onQueryButtonDown();
							},
							disabled: false
						},{
							itemId : 'closeBtn',
							text: '닫기',
							handler: function() {
								postitWindow.hide();
							},
							disabled: false
						},{
							itemId : 'deleteBtn',
							text: '삭제',
							handler: function() {
								var aGrid =grid;
								var record = aGrid.getSelectedRecord();
								var param = {
					 				SLIP_TYPE	: panelSearch.getValue('SLIP_TYPE'),
						 			AUTO_NUM	: record.get('AUTO_NUM'),
//									EX_NUM		: record.get('EX_NUM'),
//									EX_SEQ		: record.get('EX_SEQ'),
									SLIP_NUM	: record.get('SLIP_NUM'),
									SLIP_SEQ	: record.get('SLIP_SEQ'),
									EX_DATE	: UniDate.getDbDateStr(record.get('AC_DATE'))
								};
								agj240skrService.deletePostIt(param, function(provider, response){});
								postitWindow.hide();
								UniAppManager.app.onQueryButtonDown();
							},
							disabled: false
						}
				    ],
					listeners : {
						beforehide: function(me, eOpt)	{
							postitWindow.down('#remarkSearch').clearForm();
	        			},
	        			beforeclose: function( panel, eOpts )	{
							postitWindow.down('#remarkSearch').clearForm();
	        			},
	        			show: function( panel, eOpts )	{
	        			 	var aGrid = grid
							var record = aGrid.getSelectedRecord();
							
							var param = {
					 			SLIP_TYPE	: panelSearch.getValue('SLIP_TYPE'),
					 			AUTO_NUM	: record.get('AUTO_NUM'),
//								EX_NUM		: record.get('EX_NUM'),
//								EX_SEQ		: record.get('EX_SEQ'),
								SLIP_NUM	: record.get('SLIP_NUM'),
								SLIP_SEQ	: record.get('SLIP_SEQ'),
								EX_DATE	: UniDate.getDbDateStr(record.get('AC_DATE'))
							};
							agj240skrService.getPostIt(param, function(provider, response){
						
								var form = postitWindow.down('#remarkSearch');
								form.setValue('POSTIT', provider['POSTIT']);
//								form.setValue('POSTIT_YN', provider['POSTIT_YN']);
//								form.setValue('POSTIT_USER_ID', provider['POSTIT_USER_ID']);
							});
	        			}
					}		
				});
			}	
			postitWindow.center();
			postitWindow.show();
		}
	}
    
    Unilite.Main( {
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
				masterGrid, panelResult
			]	
		}		
		,panelSearch
		],
		id  : 'agj240skrApp',
		fnInitBinding : function() {
			panelSearch.setValue('ACCNT_DIV_CODE',UserInfo.divCode);
			panelResult.setValue('ACCNT_DIV_CODE',UserInfo.divCode);
			panelSearch.setValue('AC_DATE_FR', UniDate.get('today'));	
			panelSearch.setValue('AC_DATE_TO', UniDate.get('today'));	
			panelResult.setValue('AC_DATE_FR', UniDate.get('today'));	
			panelResult.setValue('AC_DATE_TO', UniDate.get('today'));
			panelSearch.setValue('SLIP_TYPE', '1');
            masterGrid.getColumn('AC_DATE').setText('회계일');
			masterGrid.getColumn('EX_DATE').setText('결의일');
                
			if(baseInfo.gsChargeDivi == '1'){
                panelSearch.getField('IN_DEPT_CODE').setReadOnly(false);
                panelSearch.getField('IN_DEPT_NAME').setReadOnly(false);
                panelResult.getField('IN_DEPT_CODE').setReadOnly(false);
                panelResult.getField('IN_DEPT_NAME').setReadOnly(false);
                
			}else{
                panelSearch.getField('IN_DEPT_CODE').setReadOnly(true);
                panelSearch.getField('IN_DEPT_NAME').setReadOnly(true);
                panelResult.getField('IN_DEPT_CODE').setReadOnly(true);
                panelResult.getField('IN_DEPT_NAME').setReadOnly(true);
			
				panelSearch.setValue('IN_DEPT_CODE',UserInfo.deptCode);
	            panelSearch.setValue('IN_DEPT_NAME',UserInfo.deptName);
	            panelResult.setValue('IN_DEPT_CODE',UserInfo.deptCode);
	            panelResult.setValue('IN_DEPT_NAME',UserInfo.deptName);
			}
			
			UniAppManager.setToolbarButtons('detail',false);
			UniAppManager.setToolbarButtons('reset',false);
			UniAppManager.setToolbarButtons('save',false);
			
			/*  
			var viewNormal = masterGrid.getView();;
		    viewNormal.getFeature('masterGridTotal').toggleSummaryRow(false);
		    */
			
			var activeSForm ;		
			if(!UserInfo.appOption.collapseLeftSearch)	{	
				activeSForm = panelSearch;	
			}else {		
				activeSForm = panelResult;	
			}		
			activeSForm.onLoadSelectText('AC_DATE_FR');		
		},
		onQueryButtonDown : function()	{		
			if(!this.isValidSearchForm()){
				return false;
			}
			masterGrid.setSummaryData(null);
//			masterGrid.reset();
//			var viewNormal = masterGrid.getView();
//			viewNormal.getFeature('masterGridTotal').toggleSummaryRow(true);
			masterGrid.getStore().loadStoreRecords();

				/* 쿼리에서 처리 안할 때 사용했으나.....;; 링크 구현 중에 문제로 주석처리 (쿼리에서 분개하는 방식으로 변경)
	       		 if(panelSearch.getValue('SLIP_DIVI')== "1") {
					var param= panelSearch.getValues();		// callback함수 처리, 레코드생성하면서 insert
	       			agj240skrService.selectList(param, function(provider, response){
	      				var store = masterGrid.getStore();
						var records = response.result;
						store.insert(0, records);
	       			});
	       		}else{
					var param= panelSearch.getValues();		// callback함수 처리, 레코드생성하면서 insert
	       			agj240skrService.selectList2(param, function(provider, response){
	      				var store = masterGrid.getStore();
						var records = response.result;
						store.insert(0, records);
	   				});
	   			};*/
//				UniAppManager.setToolbarButtons('reset', true);
		},

		onResetButtonDown: function() {			
			this.suspendEvents();
			panelSearch.clearForm();
			panelResult.clearForm();
			masterGrid.reset();
			masterStore.clearData();
			this.fnInitBinding();
		},
        onSaveAsExcelButtonDown: function() {
        	alert('');
//            masterGrid.downloadExcelXml();
        }
	});
};

</script>
