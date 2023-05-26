<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="w_sof100skrv_yp"  >	
	<t:ExtComboStore comboType="BOR120" pgmId="w_sof100skrv_yp"/> 			<!-- 사업장 -->  
	<t:ExtComboStore comboType="AU" comboCode="S010" /> <!--영업담당 -->
	<t:ExtComboStore comboType="AU" comboCode="B055" /> <!-- 거래처분류 -->      
	<t:ExtComboStore comboType="AU" comboCode="B056" /> <!-- 지역 -->       
	<t:ExtComboStore comboType="AU" comboCode="S002" /> <!--판매유형-->
	<t:ExtComboStore comboType="AU" comboCode="B059" /> <!--과세구분-->
	<t:ExtComboStore comboType="AU" comboCode="S011" /> <!--마감유형-->
	<t:ExtComboStore comboType="AU" comboCode="B031" opts= '1;5' /> <!--생성경로-->
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL1}" storeId="itemLeve1Store" />
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL2}" storeId="itemLeve2Store" />
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL3}" storeId="itemLeve3Store" />
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
#search_panel2 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
#search_panel3 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
#search_panel4 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >

function appMain() {     
	/**
	 *   Model 정의 
	 * @type  
	 */
	Unilite.defineModel('W_sof100skrv_ypModel', {
	    fields: [
			{name: 'DVRY_DATE1'				,text:'납기일'		,type:'uniDate',convert:dateToString},
			{name: 'DVRY_TIME1'				,text:'납기시간'		,type:'string'},
			{name: 'ITEM_CODE'		 		,text:'품목코드' 		,type:'string'},
			{name: 'ITEM_NAME'		 		,text:'품목명' 		,type:'string'},
			{name: 'CUSTOM_CODE1'		 	,text:'거래처코드'		,type:'string'},
			{name: 'CUSTOM_NAME1'		 	,text:'거래처명' 		,type:'string'},
			{name: 'SPEC'			 		,text:'규격' 			,type:'string'},
			{name: 'ORDER_UNIT'		 		,text:'단위' 			,type:'string', displayField: 'value'},
			{name: 'PRICE_TYPE'		 		,text:'단가구분' 		,type:'string'},
			{name: 'TRANS_RATE'		 		,text:'입수' 			,type:'string'},
			{name: 'ORDER_UNIT_Q'	 		,text:'수주량' 		,type:'uniQty'},
			{name: 'ORDER_WGT_Q'	 		,text:'수주량(중량)' 	,type:'uniQty'},
			{name: 'ORDER_VOL_Q'	 		,text:'수주량(부피)' 	,type:'uniQty'},
			{name: 'STOCK_UNIT'		 		,text:'재고단위' 		,type:'string', displayField: 'value'},
			{name: 'STOCK_Q'		 		,text:'재고단위수주량' 	,type:'uniQty'},
			{name: 'MONEY_UNIT'		 		,text:'화폐' 			,type:'string'},
			{name: 'ORDER_P'		 		,text:'단가' 			,type:'uniUnitPrice'},
			{name: 'ORDER_WGT_P'	 		,text:'단가(중량)' 	,type:'uniUnitPrice'},
			{name: 'ORDER_VOL_P'	 		,text:'단가(부피)' 	,type:'uniUnitPrice'},
			{name: 'ORDER_O'		 		,text:'수주액' 		,type:'uniFC'},
			{name: 'EXCHG_RATE_O'	 		,text:'환율' 			,type:'uniER'},
			{name: 'SO_AMT_WON'		 		,text:'환산액' 		,type:'uniPrice'},
			{name: 'TAX_TYPE'		 		,text:'과세구분' 		,type:'string', comboType:'AU', comboCode:'B059'},
			{name: 'ORDER_TAX_O'	 		,text:'세액' 			,type:'uniPrice'},
			{name: 'WGT_UNIT'		 		,text:'중량단위' 		,type:'string'},
			{name: 'UNIT_WGT'		 		,text:'단위중량' 		,type:'string'},
			{name: 'VOL_UNIT'		 		,text:'부피단위' 		,type:'string'},
			{name: 'UNIT_VOL'		 		,text:'단위부피' 		,type:'string'},
			{name: 'CUSTOM_CODE2'	 		,text:'거래처코드' 	    ,type:'string'},
			{name: 'CUSTOM_NAME2'	 		,text:'거래처명' 		,type:'string'},
			{name: 'ORDER_DATE'		 		,text:'수주일' 		,type:'uniDate',convert:dateToString},
			{name: 'ORDER_TYPE'		 		,text:'판매유형' 		,type:'string',comboType:"AU", comboCode:"S002"},
			{name: 'ORDER_TYPE_NM'	 		,text:'판매유형' 		,type:'string'},
			{name: 'ORDER_NUM'		 		,text:'수주번호' 		,type:'string'},
			{name: 'SER_NO'			 		,text:'순번' 			,type:'integer'},
			{name: 'ORDER_PRSN'		 		,text:'영업담당' 		,type:'string',comboType:"AU", comboCode:"S010"},
			{name: 'ORDER_PRSN_NM'	 		,text:'영업담당' 		,type:'string'},
			{name: 'PROJECT_NO'             ,text:'프로젝트번호'    ,type:'string'},
			{name: 'PO_NUM'			 		,text:'P/O NO' 		,type:'string'},
			{name: 'DVRY_DATE2'		 		,text:'납기일' 		,type:'uniDate',convert:dateToString},
			{name: 'DVRY_TIME'		 		,text:'납기시간' 		,type:'uniTime'},
			{name: 'DVRY_CUST_NM'	 		,text:'배송처' 		,type:'string'},
			{name: 'PROD_END_DATE'	 		,text:'생산완료요청일' 	,type:'uniDate',convert:dateToString},
			{name: 'PROD_Q'			 		,text:'생산요청량' 	,type:'uniQty'},
			{name: 'ORDER_STATUS'	 		,text:'마감' 			,type:'string',comboType:"AU", comboCode:"S011"},
			{name: 'REMARK'					,text:'비고'			,type:'string'},
			{name: 'SORT_KEY'		 		,text:'SORTKEY' 	,type:'string'},
			{name: 'CREATE_LOC'		 		,text:'CREATE_LOC' 	,type:'string'}
		]
	});
	
	// GroupField string type으로 변환
	function dateToString(v, record){
		return UniDate.safeFormat(v);
	 }
	
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore1 = Unilite.createStore('w_sof100skrv_ypMasterStore1', {
		model: 'W_sof100skrv_ypModel',
		uniOpt: {
           	isMaster: true,			// 상위 버튼,상태바 연결 
           	editable: false,		// 수정 모드 사용 
           	deletable:false,		// 삭제 가능 여부 
            useNavi: false			// prev | newxt 버튼 사용
		},
        autoLoad: false,
        proxy: {
        	type: 'direct',
            api: {			
            	read: 'w_sof100skrv_ypService.selectList1'                	
		    }
		},
		loadStoreRecords: function() {
			var param= Ext.getCmp('searchForm').getValues();
			var authoInfo = pgmInfo.authoUser;				//권한정보(N-전체,A-자기사업장>5-자기부서)
/*			var deptCode = UserInfo.deptCode;	//부서코드
			if(authoInfo == "5" && Ext.isEmpty(panelSearch.getValue('DEPT_CODE'))){
				param.DEPT_CODE = deptCode;
			}
			console.log( param );*/
			this.load({
				params: param
			});
		},
		groupField: 'ITEM_NAME'
	});

	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */
	/*
	 * 
	var panelSearch = Unilite.createSearchPanel('searchForm', {          
		title: '검색조건',         
		defaultType: 'uniSearchSubPanel',
		items: [{     
			title: '기본정보',   
			itemId: 'search_panel1',
		}]
	});
	
	
			borderItems:[ 
	 		 masterGrid,
			 panelSearch
		],
	
	*/	
	var panelSearch = Unilite.createSearchPanel('searchForm', {		
		title: '검색조건',		
        defaultType: 'uniSearchSubPanel',
        collapsed: UserInfo.appOption.collapseLeftSearch,//true,
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
	    	items: [{ 
				fieldLabel: '<t:message code="unilite.msg.sMS631" default="사업장"/>',
				name: 'DIV_CODE',
				xtype: 'uniCombobox',
				comboType: 'BOR120',
				allowBlank: false,
				value: UserInfo.divCode,
				listeners: {
					change: function(combo, newValue, oldValue, eOpts) {	
						combo.changeDivCode(combo, newValue, oldValue, eOpts);
						var field = panelResult.getField('ORDER_PRSN');	
						field.fireEvent('changedivcode', field, newValue, oldValue, eOpts);//panelResult의 필터링 처리 위해..
						panelResult.setValue('DIV_CODE', newValue);
					}
				}
			}, {
				fieldLabel: '수주일',
				startFieldName: 'ORDER_DATE_FR',
				endFieldName: 'ORDER_DATE_TO',
				xtype: 'uniDateRangefield',
				width: 315,
				startDate: UniDate.get('startOfMonth'),
				endDate: UniDate.get('today'),                	
                onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelResult) {
						panelResult.setValue('ORDER_DATE_FR',newValue);
						//panelResult.getField('ISSUE_REQ_DATE_FR').validate();
                	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelResult) {
			    		panelResult.setValue('ORDER_DATE_TO',newValue);
			    		//panelResult.getField('ISSUE_REQ_DATE_TO').validate();
			    		
			    	}
			    }
			}, { 
		    	fieldLabel: '납기일',
	         	xtype: 'uniDateRangefield',
	         	startFieldName: 'DVRY_DATE_FR',
	         	endFieldName: 'DVRY_DATE_TO',	
	         	width: 315,							               
	         	colspan: 2,                	
                onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelResult) {
						panelResult.setValue('DVRY_DATE_FR',newValue);
						//panelResult.getField('ISSUE_REQ_DATE_FR').validate();
                	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelResult) {
			    		panelResult.setValue('DVRY_DATE_TO',newValue);
			    		//panelResult.getField('ISSUE_REQ_DATE_TO').validate();
			    		
			    	}
			    }
			}, {
				fieldLabel: '판매유형',
				name:'ORDER_TYPE',	
				xtype: 'uniCombobox', 
				comboType:'AU',
				comboCode:'S002',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('ORDER_TYPE', newValue);
					}
				}
			}, {
				fieldLabel: '영업담당',
				name:'ORDER_PRSN',
				xtype: 'uniCombobox', 
				comboType:'AU',
				comboCode:'S010',
				multiSelect: true,
				typeAhead: false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('ORDER_PRSN', newValue);
					}
				},
				onChangeDivCode: function(combo, newValue, oldValue, eOpts, divCode){
					if(eOpts){
						combo.filterByRefCode('refCode1', newValue, eOpts.parent);
					}else{
						combo.divFilterByRefCode('refCode1', newValue, divCode);
					}
				}
				}, Unilite.popup('PROJECT',{
				fieldLabel: '프로젝트번호',
				valueFieldName:'PJT_CODE',
			    textFieldName:'PJT_NAME',
	       		DBvalueFieldName: 'PJT_CODE',
			    DBtextFieldName: 'PJT_NAME',
				validateBlank: false,
//				allowBlank:false,
				textFieldOnly: false,
				listeners: {
					onSelected: {
						fn: function(records, type) {
							panelResult.setValue('PJT_CODE', panelSearch.getValue('PJT_CODE'));
							panelResult.setValue('PJT_NAME', panelSearch.getValue('PJT_NAME'));
                    	},
						scope: this
					},
					onClear: function(type)	{
						panelResult.setValue('PJT_CODE', '');
						panelResult.setValue('PJT_NAME', '');
					},
					applyextparam: function(popup) {
					},
					change: function(field, newValue, oldValue, eOpts) {
					}
				}
				})
/*				,
				Unilite.popup('DEPT', { 
				fieldLabel: '부서', 
				valueFieldName: 'DEPT_CODE',
		   	 	textFieldName: 'DEPT_NAME',
				
				holdable: 'hold',
				listeners: {
					onSelected: {
						fn: function(records, type) {
							panelResult.setValue('DEPT_CODE', panelSearch.getValue('DEPT_CODE'));
							panelResult.setValue('DEPT_NAME', panelSearch.getValue('DEPT_NAME'));
                    	},
						scope: this
					},
					onClear: function(type)	{
						panelResult.setValue('DEPT_CODE', '');
						panelResult.setValue('DEPT_NAME', '');
					},
					applyextparam: function(popup){							
						var authoInfo = pgmInfo.authoUser;				//권한정보(N-전체,A-자기사업장>5-자기부서)
						var deptCode = UserInfo.deptCode;	//부서정보
						var divCode = '';					//사업장
						
						if(authoInfo == "A"){	//자기사업장	
							popup.setExtParam({'DEPT_CODE': ""});
							popup.setExtParam({'DIV_CODE': UserInfo.divCode});
							
						}else if(authoInfo == "N" || Ext.isEmpty(authoInfo)){	//전체권한
							popup.setExtParam({'DEPT_CODE': ""});
							popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
							
						}else if(authoInfo == "5"){		//부서권한
							popup.setExtParam({'DEPT_CODE': UserInfo.deptCode});
							popup.setExtParam({'DIV_CODE': UserInfo.divCode});
						}
					}
				}
			})*/
			]	
   		}, {
   			title:'거래처정보',
   			id: 'search_panel2',
			itemId:'search_panel2',
        	defaultType: 'uniTextfield',
        	layout: {type: 'uniTable', columns: 1},
			items:[
				Unilite.popup('AGENT_CUST',{
				fieldLabel: '거래처',				
				validateBlank: false,
				readOnly: true,
				extParam: {'CUSTOM_TYPE':'3'},
				listeners: {
					applyextparam: function(popup) {
						popup.setExtParam({'CUSTOM_TYPE':'3'});
					}
				}
			}),{
				fieldLabel: '거래처분류',
				name:'AGENT_TYPE',	
				xtype: 'uniCombobox', 
				comboType:'AU',
				comboCode:'B055'  
			}, {
				fieldLabel: '지역',
				name:'AREA_TYPE', 	
				xtype: 'uniCombobox', 
				comboType:'AU',
				comboCode:'B056'  
			}]
		}, {	
			title:'품목정보',
        	defaultType: 'uniTextfield',
        	id: 'search_panel3',
        	itemId:'search_panel3',
        	layout: {type: 'uniTable', columns: 1},
			items:[
				Unilite.popup('DIV_PUMOK',{
	        	fieldLabel: '품목코드',
	        	valueFieldName: 'ITEM_CODE', 
				textFieldName: 'ITEM_NAME', 
				validateBlank: false,
	        	listeners: {
					applyextparam: function(popup){							
						popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
					},
					onValueFieldChange: function(field, newValue){
                        panelResult.setValue('ITEM_CODE', newValue);                             
                    },
                    onTextFieldChange: function(field, newValue){
                        panelResult.setValue('ITEM_NAME', newValue);             
                    }
//					onSelected: {
//                        fn: function(records, type) {
//                            panelResult.setValue('ITEM_CODE', panelSearch.getValue('ITEM_CODE'));
//                            panelResult.setValue('ITEM_NAME', panelSearch.getValue('ITEM_NAME'));
//                        },
//                        scope: this
//                    },
//                    onClear: function(type) {
//                        panelResult.setValue('ITEM_CODE', '');
//                        panelResult.setValue('ITEM_NAME', '');
//                    }
				}
		   }),
				Unilite.popup('ITEM_GROUP',{
				fieldLabel: '대표모델코드',
				valueFieldName: 'ITEM_GROUP',
				textFieldName: 'ITEM_GROUP_NAME',
				validateBlank:false, 
				popupWidth: 710,
				colspan: 2
			}),{
				fieldLabel: '대분류',
				name: 'TXTLV_L1', 
				xtype: 'uniCombobox',  
				store: Ext.data.StoreManager.lookup('itemLeve1Store'), 
				child: 'TXTLV_L2'
			}, {
				fieldLabel: '중분류',
				name: 'TXTLV_L2', 
				xtype: 'uniCombobox',  
				store: Ext.data.StoreManager.lookup('itemLeve2Store'), 
				child: 'TXTLV_L3'
			}, {
				fieldLabel: '소분류',
				name: 'TXTLV_L3', 
				xtype: 'uniCombobox',  
				store: Ext.data.StoreManager.lookup('itemLeve3Store'), 
				parentNames:['TXTLV_L1','TXTLV_L2'],
	            levelType:'ITEM'
				
			}]
		}, {	
			title:'수주정보',
			id: 'search_panel4',
			itemId:'search_panel4',			
    		defaultType: 'uniTextfield',
    		layout: {type: 'uniTable', columns: 1},
    		items:[{
		 	 	xtype: 'container',
	   			defaultType: 'uniNumberfield',
				layout: {type: 'hbox', align:'stretch'},
				width:325,
				margin:0,
				items:[{
					fieldLabel:'수주량',
					suffixTpl:'&nbsp;~&nbsp;',
					name: 'FR_ORDER_QTY',
					width:218
				}, {
					name: 'TO_ORDER_QTY',
					width:107
				}]
			}, {
		 	 	xtype: 'container',
	   			defaultType: 'uniNumberfield',
				layout: {type: 'hbox', align:'stretch'},
				width:325,
				margin:0,
				items:[{
					fieldLabel:'수주번호',
					suffixTpl:'&nbsp;~&nbsp;',
					name: 'FR_ORDER_NUM',
					width:218
				}, {
					name: 'TO_ORDER_NUM',
					width:107
				}] 
			}, {
				fieldLabel: '생성경로',
				name:'TXT_CREATE_LOC', 
				xtype: 'uniCombobox', 
				comboType:'AU',
				comboCode:'B031'
			}, {
	    		xtype: 'radiogroup',		            		
	    		fieldLabel: '마감여부',
	    		id: 'ORDER_STATUS',
//	    		name: 'ORDER_STATUS',
	    		items: [{
	    			boxLabel: '전체',
	    			width: 50,
	    			name: 'ORDER_STATUS',
	    			inputValue: '%',
	    			checked: true
	    		}, {
	    			boxLabel: '마감',
	    			width: 60, name: 'ORDER_STATUS',
	    			inputValue: 'Y'
	    		}, {
	    			boxLabel: '미마감',
	    			width: 80, name: 'ORDER_STATUS',
	    			inputValue: 'N'
	    		}]
	        }, {
	    		fieldLabel: '상태',
	    		xtype: 'radiogroup',
	    		id: 'rdoSelect2',
//	    		name: 'rdoSelect2',
	    		items: [{
	    			boxLabel: '전체',
	    			width: 50,
	    			name: 'rdoSelect2', 
	    			inputValue: 'A',
	    			checked: true
	    		}, {
	    			boxLabel: '미승인', 
	    			width: 60, name: 'rdoSelect2',
	    			inputValue: 'N'
	    		}, {
	    			boxLabel: '승인',
	    			width: 50, name: 'rdoSelect2',
	    			inputValue: '6'
	    		}, {
	    			boxLabel: '반려',
	    			width: 50, name: 'rdoSelect2',
	    			inputValue: '5'
	    		}]
    		}]
	    }],		
	    setAllFieldsReadOnly: function(b) {
			var r= true
			if(b) {
				var invalid = this.getForm().getFields().filterBy(function(field) {
																	return !field.validate();
																});
   				if(invalid.length > 0) {
					r=false;
   					var labelText = ''
   	
					if(Ext.isDefined(invalid.items[0]['fieldLabel'])) {
   						var labelText = invalid.items[0]['fieldLabel']+'은(는)';
   					} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
   						var labelText = invalid.items[0].ownerCt['fieldLabel']+'은(는)';
   					}

				   	alert(labelText+Msg.sMB083);
				   	invalid.items[0].focus();
				}
	  		}
			return r;
  		}
	});
	
	var panelResult = Unilite.createSearchForm('resultForm',{
    	region: 'north',
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
		hidden: !UserInfo.appOption.collapseLeftSearch,
		items: [{ 
				fieldLabel: '<t:message code="unilite.msg.sMS631" default="사업장"/>',
				name: 'DIV_CODE',
				xtype: 'uniCombobox',
				comboType: 'BOR120',
				allowBlank: false,
				value: UserInfo.divCode,
				listeners: {
					change: function(combo, newValue, oldValue, eOpts) {	
						combo.changeDivCode(combo, newValue, oldValue, eOpts);
						var field = panelSearch.getField('ORDER_PRSN');	
						field.fireEvent('changedivcode', field, newValue, oldValue, eOpts);//panelResult의 필터링 처리 위해..
						panelSearch.setValue('DIV_CODE', newValue);
					}
				}
			}, {
				fieldLabel: '수주일',
				startFieldName: 'ORDER_DATE_FR',
				endFieldName: 'ORDER_DATE_TO',
				xtype: 'uniDateRangefield',
				width: 315,
				startDate: UniDate.get('startOfMonth'),
				endDate: UniDate.get('today'),                	
                onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelSearch) {
						panelSearch.setValue('ORDER_DATE_FR',newValue);
						//panelSearch.getField('ISSUE_REQ_DATE_FR').validate();
                	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelSearch) {
			    		panelSearch.setValue('ORDER_DATE_TO',newValue);
			    		//panelSearch.getField('ISSUE_REQ_DATE_TO').validate();
			    		
			    	}
			    }
			}, { 
		    	fieldLabel: '납기일',
	         	xtype: 'uniDateRangefield',
	         	startFieldName: 'DVRY_DATE_FR',
	         	endFieldName: 'DVRY_DATE_TO',	
	         	width: 315,							               
	         	colspan: 2,                	
                onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelSearch) {
						panelSearch.setValue('DVRY_DATE_FR',newValue);
						//panelSearch.getField('ISSUE_REQ_DATE_FR').validate();
                	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelSearch) {
			    		panelSearch.setValue('DVRY_DATE_TO',newValue);
			    		//panelSearch.getField('ISSUE_REQ_DATE_TO').validate();
			    		
			    	}
			    }
			}, {
				fieldLabel: '판매유형',
				name:'ORDER_TYPE',	
				xtype: 'uniCombobox', 
				comboType:'AU',
				comboCode:'S002',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('ORDER_TYPE', newValue);
					}
				}
			}, {
				fieldLabel: '영업담당',
				name:'ORDER_PRSN',
				xtype: 'uniCombobox', 
				comboType:'AU',
				comboCode:'S010',
				multiSelect: true,
				typeAhead: false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('ORDER_PRSN', newValue);
					}
				},
				onChangeDivCode: function(combo, newValue, oldValue, eOpts, divCode){
					if(eOpts){
						combo.filterByRefCode('refCode1', newValue, eOpts.parent);
					}else{
						combo.divFilterByRefCode('refCode1', newValue, divCode);
					}
				}
			},
			 Unilite.popup('DIV_PUMOK',{
                fieldLabel: '품목코드',
                valueFieldName: 'ITEM_CODE', 
                textFieldName: 'ITEM_NAME', 
                validateBlank: false,
                listeners: {
                    applyextparam: function(popup){                         
                        popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
                    },
                    onValueFieldChange: function(field, newValue){
                        panelSearch.setValue('ITEM_CODE', newValue);                             
                    },
                    onTextFieldChange: function(field, newValue){
                        panelSearch.setValue('ITEM_NAME', newValue);             
                    }
//                    onSelected: {
//                        fn: function(records, type) {
//                        	panelSearch.setValue('ITEM_CODE', panelResult.getValue('ITEM_CODE'));
//                        	panelSearch.setValue('ITEM_NAME', panelResult.getValue('ITEM_NAME'));
//                        },
//                        scope: this
//                    },
//                    onClear: function(type) {
//                    	panelSearch.setValue('ITEM_CODE', '');
//                        panelSearch.setValue('ITEM_NAME', '');
//                    }
                }
           })/*,
				Unilite.popup('PROJECT',{
				fieldLabel: '프로젝트번호',
				valueFieldName:'PJT_CODE',
			    textFieldName:'PJT_NAME',
	       		DBvalueFieldName: 'PJT_CODE',
			    DBtextFieldName: 'PJT_NAME',
				validateBlank: false,
//				allowBlank:false,
				textFieldOnly: false,
				listeners: {
					onSelected: {
						fn: function(records, type) {
							panelSearch.setValue('PJT_CODE', panelResult.getValue('PJT_CODE'));
							panelSearch.setValue('PJT_NAME', panelResult.getValue('PJT_NAME'));
                    	},
						scope: this
					},
					onClear: function(type)	{
						panelSearch.setValue('PJT_CODE', '');
						panelSearch.setValue('PJT_NAME', '');
					},
					applyextparam: function(popup) {
					},
					change: function(field, newValue, oldValue, eOpts) {
					}
				}
				})*/

/*			Unilite.popup('DEPT', { 
			fieldLabel: '부서', 
			valueFieldName: 'DEPT_CODE',
	   	 	textFieldName: 'DEPT_NAME',
			
			holdable: 'hold',
			listeners: {
				onSelected: {
					fn: function(records, type) {
						panelSearch.setValue('DEPT_CODE', panelResult.getValue('DEPT_CODE'));
						panelSearch.setValue('DEPT_NAME', panelResult.getValue('DEPT_NAME'));
                	},
					scope: this
				},
				onClear: function(type)	{
					panelSearch.setValue('DEPT_CODE', '');
					panelSearch.setValue('DEPT_NAME', '');
				},
				applyextparam: function(popup){							
					var authoInfo = pgmInfo.authoUser;				//권한정보(N-전체,A-자기사업장>5-자기부서)
					var deptCode = UserInfo.deptCode;	//부서정보
					var divCode = '';					//사업장
					
					if(authoInfo == "A"){	//자기사업장	
						popup.setExtParam({'DEPT_CODE': ""});
						popup.setExtParam({'DIV_CODE': UserInfo.divCode});
						
					}else if(authoInfo == "N" || Ext.isEmpty(authoInfo)){	//전체권한
						popup.setExtParam({'DEPT_CODE': ""});
						popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
						
					}else if(authoInfo == "5"){		//부서권한
						popup.setExtParam({'DEPT_CODE': UserInfo.deptCode});
						popup.setExtParam({'DIV_CODE': UserInfo.divCode});
					}
				}
			}
		})*/
		]	
    });
	/**
     * Master Grid1 정의(Grid Panel),
     * @type 
     */
    var masterGrid = Unilite.createGrid('w_sof100skrv_ypGrid1', {
    	layout: 'fit', 
    	//layout: 'border', //fit->border 로 변경 5.0.1
    	//split: false,		//locking split panel
    	region:'center',
        uniOpt: {
            useGroupSummary: false,
            useLiveSearch: true,
            useContextMenu: true,
            useMultipleSorting: true,
            useRowNumberer: false,
            expandLastColumn: false,
            filter: {
                useFilter: false,
                autoCreate: false
            },
            state: {
                useState: false,         //그리드 설정 버튼 사용 여부
                useStateList: false      //그리드 설정 목록 사용 여부
            }
        },   			  
    	store: directMasterStore1,
        features: [ {id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false },
    	           	{id : 'masterGridTotal', 	ftype: 'uniSummary', 	  showSummaryRow: false} ],
            
        columns: [        
			{dataIndex: 'ITEM_CODE'		 		, width: 100, locked: false}, 				
			{dataIndex: 'ITEM_NAME'		 		, width: 200, locked: false}, 				
			{dataIndex: 'SPEC'			 		, width: 150, locked: false}, 				
			{dataIndex: 'ORDER_UNIT'		 	, width: 53, locked: false, align: 'center'}, 				
			{dataIndex: 'PRICE_TYPE'		 	, width: 80, hidden: true}, 				
			{dataIndex: 'TRANS_RATE'		 	, width: 60, align: 'right',
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
            		return Unilite.renderSummaryRow(summaryData, metaData, '소계', '총계');
            }}, 				
			{dataIndex: 'ORDER_UNIT_Q'	 		, width: 80, summaryType: 'sum'}, 				
			{dataIndex: 'ORDER_WGT_Q'	 		, width: 106, hidden: true},		
			{dataIndex: 'ORDER_VOL_Q'	 		, width: 106, hidden: true},				
			{dataIndex: 'STOCK_UNIT'		 	, width: 53, hidden: true}, 				
			{dataIndex: 'STOCK_Q'		 		, width: 106,hidden: true}, 				
			{dataIndex: 'MONEY_UNIT'		 	, width: 53}, 				
			{dataIndex: 'ORDER_P'		 		, width: 106}, 				
			{dataIndex: 'ORDER_WGT_P'	 		, width: 106, hidden: true}, 				
			{dataIndex: 'ORDER_VOL_P'	 		, width: 106, hidden: true},				
//			{dataIndex: 'ORDER_O'		 		, width: 120, summaryType: 'sum'}, 				
			{dataIndex: 'ORDER_O'               , width: 120},
			{dataIndex: 'EXCHG_RATE_O'	 		, width: 66, align: 'right'}, 				
			{dataIndex: 'SO_AMT_WON'		 	, width: 120, summaryType: 'sum'}, 				
			{dataIndex: 'TAX_TYPE'		 		, width: 100, align: 'center'}, 				
//			{dataIndex: 'ORDER_TAX_O'	 		, width: 125, summaryType: 'sum'}, 				
			{dataIndex: 'ORDER_TAX_O'           , width: 125},
			{dataIndex: 'WGT_UNIT'		 		, width: 66, hidden: true}, 				
			{dataIndex: 'UNIT_WGT'		 		, width: 80, hidden: true}, 				
			{dataIndex: 'VOL_UNIT'		 		, width: 66, hidden: true}, 				
			{dataIndex: 'UNIT_VOL'		 		, width: 80, hidden: true}, 				
			{dataIndex: 'CUSTOM_CODE2'	 		, width: 100}, 				
			{dataIndex: 'CUSTOM_NAME2'	 		, width: 133}, 				
			{dataIndex: 'ORDER_DATE'		 	, width: 93}, 				
			{dataIndex: 'ORDER_TYPE'		 	, width: 100}, 				
			{dataIndex: 'ORDER_TYPE_NM'	 		, width: 133, hidden: true}, 				
			{dataIndex: 'ORDER_NUM'		 		, width: 110}, 				
			{dataIndex: 'SER_NO'			 	, width: 53, align:'center'}, 				
			{dataIndex: 'ORDER_PRSN'		 	, width: 66}, 				
			{dataIndex: 'ORDER_PRSN_NM'	 		, width:133, hidden: true}, 				
			{dataIndex: 'PROJECT_NO'            , width:100},
			{dataIndex: 'PO_NUM'			 	, width:86}, 				
			{dataIndex: 'DVRY_DATE2'		 	, width:93}, 				
			{dataIndex: 'DVRY_TIME'		 		, width:66, hidden: true}, 				
			{dataIndex: 'DVRY_CUST_NM'	 		, width:100}, 				
			{dataIndex: 'PROD_END_DATE'	 		, width:106}, 				
			{dataIndex: 'PROD_Q'			 	, width:90, summaryType: 'sum'}, 				
			{dataIndex: 'ORDER_STATUS'	 		, width:90},				
			{dataIndex: 'SORT_KEY'		 		, width:106, hidden: true}, 				
			{dataIndex: 'CREATE_LOC'		 	, width:106, hidden: true},
			{dataIndex: 'REMARK'				, width:200}
		] 
    });

    Unilite.Main({
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
				masterGrid, panelResult
			]
		},
			panelSearch  	
		],
		id: 'w_sof100skrv_ypApp',
		fnInitBinding: function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
//			panelSearch.setValue('DEPT_CODE', UserInfo.deptCode);
//        	panelSearch.setValue('DEPT_NAME', UserInfo.deptName);
        	panelSearch.setValue('ORDER_DATE_TO', UniDate.get('today'));
			panelSearch.setValue('ORDER_DATE_FR', UniDate.get('startOfMonth', panelSearch.getValue('ORDER_DATE_TO')));
        	
			panelResult.setValue('DIV_CODE',UserInfo.divCode);
//        	panelResult.setValue('DEPT_CODE', UserInfo.deptCode);
//        	panelResult.setValue('DEPT_NAME', UserInfo.deptName); 
        	panelResult.setValue('ORDER_DATE_TO', UniDate.get('today'));
			panelResult.setValue('ORDER_DATE_FR', UniDate.get('startOfMonth', panelSearch.getValue('ORDER_DATE_TO')));		
			
//			panelSearch.getField('ORDER_STATUS').setValue('%');
//			panelSearch.getField('rdoSelect2').setValue('A');
			
			var pCombo	= panelSearch.getField('DIV_CODE');
			var combo 	= panelSearch.getField('ORDER_PRSN').filterByRefCode('refCode1', pCombo.getValue(), pCombo);
			
			var field = panelSearch.getField('ORDER_PRSN');
			field.fireEvent('changedivcode', field, UserInfo.divCode, null, null, "DIV_CODE");
			var field = panelResult.getField('ORDER_PRSN');
			field.fireEvent('changedivcode', field, UserInfo.divCode, null, null, "DIV_CODE");
			
			panelSearch.setValue('CUSTOM_CODE', '${gsCustomCode}');
            panelSearch.setValue('CUSTOM_NAME', '${gsCustomName}');
//            panelSearch.setValue('ORDER_PRSN', '${gsBusiPrsn}');
//            panelSearch.setValue('ORDER_TYPE', '95');
            panelResult.setValue('CUSTOM_CODE', '${gsCustomCode}');
            panelResult.setValue('CUSTOM_NAME', '${gsCustomName}');
//            panelResult.setValue('ORDER_PRSN', '${gsBusiPrsn}');
//            panelResult.setValue('ORDER_TYPE', '95');
            
            panelSearch.getField('CUSTOM_CODE').setReadOnly(true);
            panelSearch.getField('CUSTOM_NAME').setReadOnly(true);
//            panelResult.getField('CUSTOM_CODE').setReadOnly(true);
//            panelResult.getField('CUSTOM_NAME').setReadOnly(true);
		},
		onQueryButtonDown: function()	{
			if(!panelSearch.setAllFieldsReadOnly(true)){
	    		return false;
	    	}
			masterGrid.getStore().loadStoreRecords();
			//var viewLocked = masterGrid.lockedGrid.getView();
			var viewNormal = masterGrid.getView();
			//console.log("viewLocked : ",viewLocked);
			console.log("viewNormal : ",viewNormal);
		    //viewLocked.getFeature('masterGridSubTotal').toggleSummaryRow(true);
		    //viewLocked.getFeature('masterGridTotal').toggleSummaryRow(true);
		    viewNormal.getFeature('masterGridSubTotal').toggleSummaryRow(true);
		    viewNormal.getFeature('masterGridTotal').toggleSummaryRow(true);
		},
		onResetButtonDown: function() {
			panelSearch.clearForm();
			panelResult.clearForm();
			masterGrid.getStore().loadData({})
			this.fnInitBinding();			
		}
	});
};
</script>
