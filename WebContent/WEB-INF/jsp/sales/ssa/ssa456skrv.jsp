<%@page language="java" contentType="text/html; charset=utf-8"%>

<t:appConfig pgmId="ssa456skrv"  >
	<t:ExtComboStore comboType="BOR120" pgmId="ssa456skrv"  /> 			<!-- 사업장 -->  
	<t:ExtComboStore comboType="AU" comboCode="S010" /> <!--영업담당 -->
	<t:ExtComboStore comboType="AU" comboCode="B056" /> <!-- 지역 -->    
	<t:ExtComboStore comboType="AU" comboCode="B055" /> <!-- 거래처분류 -->
	<t:ExtComboStore comboType="AU" comboCode="S007" /> <!--출고유형-->
	<t:ExtComboStore comboType="AU" comboCode="S024" /> <!--국내:부가세유형-->
	<t:ExtComboStore comboType="AU" comboCode="S118" /> <!--해외:부가세유형-->
	<t:ExtComboStore comboType="AU" comboCode="S002" /> <!--판매유형-->
	<t:ExtComboStore comboType="AU" comboCode="B020" /> <!--품목유형-->
	<t:ExtComboStore comboType="AU" comboCode="S003" /> <!--단가구분-->
	<t:ExtComboStore comboType="AU" comboCode="B031"  opts= '1;5'/> <!--생성경로-->
	<t:ExtComboStore comboType="AU" comboCode="B059" /> <!--과세여부-->
	<t:ExtComboStore comboType="AU" comboCode="S024" /> <!--부가세유형-->
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL1}" storeId="itemLeve1Store" />
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL2}" storeId="itemLeve2Store" />
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL3}" storeId="itemLeve3Store" />
</t:appConfig>

<script type="text/javascript" >

function appMain() {
	/**
	 *   Model 정의 
	 * @type 
	 */	    			
	Unilite.defineModel('ssa456skrvModel1', {
	    fields: [ {name: 'LEVEL_NAME'			,type: 'string'}, 
				  {name: 'SALE_AMT_O'			,type: 'int'}]

	});
	
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					             
	var directMasterStore1 = Unilite.createStore('ssa456skrvMasterStore1',{
		model: 'ssa456skrvModel1',
		uniOpt: {
        	isMaster: true,			// 상위 버튼 연결 
        	editable: false,			// 수정 모드 사용 
        	deletable: false,			// 삭제 가능 여부 
            useNavi: false			// prev | next 버튼 사용
        },
        autoLoad: false,
        proxy: {
            type: 'direct',
            api: {			
            	   read: 'ssa456skrvService.selectList1'                	
            }
        }
		,loadStoreRecords: function()	{			
			var param= Ext.getCmp('searchForm').getValues();
			var authoInfo = pgmInfo.authoUser;				//권한정보(N-전체,A-자기사업장>5-자기부서)
			var deptCode = UserInfo.deptCode;	//부서코드
			if(authoInfo == "5" && Ext.isEmpty(panelSearch.getValue('DEPT_CODE'))){
				param.DEPT_CODE = deptCode;
			}
			console.log( param );
			this.load({
				params: param
			});			
		},
		//groupField: 'SALE_CUSTOM_NAME'
	});
	
	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm', {          
		title: '<t:message code="system.label.sales.searchconditon" default="검색조건"/>',         
		defaultType: 'uniSearchSubPanel',
		collapsed: UserInfo.appOption.collapseLeftSearch,
        listeners: {
	        collapse: function () {
	        	panelResult.show();
	        },
	        expand: function() {
	        	panelResult.hide();
	        }
	    },
		items: [{     
			title: '<t:message code="system.label.sales.basisinfo" default="기본정보"/>',   
			itemId: 'search_panel1',
			layout: {type: 'vbox', align: 'stretch'},
        	items: [{	
        		xtype: 'container',
        		layout: {type: 'uniTable', columns:1},
        		items: [{
        			fieldLabel: '<t:message code="system.label.sales.division" default="사업장"/>',
        			name: 'DIV_CODE',
        			xtype: 'uniCombobox',
        			comboType: 'BOR120',
        			value: UserInfo.divCode,
        			allowBlank: false,
					listeners: {
						change: function(combo, newValue, oldValue, eOpts) {	
							combo.changeDivCode(combo, newValue, oldValue, eOpts);
							var field = panelResult.getField('SALE_PRSN');	
							field.fireEvent('changedivcode', field, newValue, oldValue, eOpts);//panelResult의 필터링 처리 위해..
							panelResult.setValue('DIV_CODE', newValue);
						}
					}
        		},
				Unilite.popup('DEPT', { 
					fieldLabel: '<t:message code="system.label.sales.department" default="부서"/>', 
					valueFieldName: 'DEPT_CODE',
			   	 	textFieldName: 'DEPT_NAME',
					
					holdable: 'hold',
					allowBlank: false,
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
								popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
								
							}else if(authoInfo == "5"){		//부서권한
								popup.setExtParam({'DEPT_CODE': UserInfo.deptCode});
								popup.setExtParam({'DIV_CODE': UserInfo.divCode});
							}
						}
					}
				}),
        			Unilite.popup('AGENT_CUST',{
        			fieldLabel: '<t:message code="system.label.sales.custom" default="거래처"/>',
        			
					valueFieldName: 'SALE_CUSTOM_CODE',
					textFieldName: 'SALE_CUSTOM_NAME',
					listeners: {
						onSelected: {
							fn: function(records, type) {
								panelResult.setValue('SALE_CUSTOM_CODE', panelSearch.getValue('SALE_CUSTOM_CODE'));
								panelResult.setValue('SALE_CUSTOM_NAME', panelSearch.getValue('SALE_CUSTOM_NAME'));				 																							
							},
							scope: this
						},
						onClear: function(type)	{
							panelResult.setValue('SALE_CUSTOM_CODE', '');
							panelResult.setValue('SALE_CUSTOM_NAME', '');
						}
					}
				}),{
					fieldLabel: '<t:message code="system.label.sales.salescharge" default="영업담당"/>'	,
					name: 'SALE_PRSN',
					xtype: 'uniCombobox',
					comboType: 'AU',
					comboCode: 'S010',
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.setValue('SALE_PRSN', newValue);
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
					Unilite.popup('DIV_PUMOK', {
					fieldLabel: '<t:message code="system.label.sales.item" default="품목"/>',
					
					listeners: {
						onSelected: {
							fn: function(records, type) {
								panelResult.setValue('ITEM_CODE', panelSearch.getValue('ITEM_CODE'));
								panelResult.setValue('ITEM_NAME', panelSearch.getValue('ITEM_NAME'));				 																							
							},
							scope: this
						},
						onClear: function(type)	{
							panelResult.setValue('ITEM_CODE', '');
							panelResult.setValue('ITEM_NAME', '');
						},
						applyextparam: function(popup){							
						popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
					}
					}
				}),{
					xtype: 'uniTextfield',
					name: 'PROJECT_NO',
					fieldLabel: '<t:message code="system.label.sales.manageno" default="관리번호"/>',
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.setValue('PROJECT_NO', newValue);
						}
					}
				}, {
					fieldLabel: '<t:message code="system.label.sales.salesdate" default="매출일"/>',
	 		        width: 315,
	                xtype: 'uniDateRangefield',
	                startFieldName: 'SALE_FR_DATE',
	                endFieldName: 'SALE_TO_DATE',
	                //startDate: UniDate.get('startOfMonth'),
	                startDate: UniDate.get('today'),
	                endDate: UniDate.get('today'),                	
	                onStartDateChange: function(field, newValue, oldValue, eOpts) {
	                	if(panelResult) {
							panelResult.setValue('SALE_FR_DATE',newValue);
							//panelResult.getField('ISSUE_REQ_DATE_FR').validate();							
	                	}
				    },
				    onEndDateChange: function(field, newValue, oldValue, eOpts) {
				    	if(panelResult) {
				    		panelResult.setValue('SALE_TO_DATE',newValue);
				    		//panelResult.getField('ISSUE_REQ_DATE_TO').validate();				    		
				    	}
				    }
	            }]	
			}]	            			 
		},{
			title:'<t:message code="system.label.sales.additionalinfo" default="추가정보"/>',
			id: 'search_panel2',
			itemId:'search_panel2',
	    	defaultType: 'uniTextfield',
	    	layout: {type: 'uniTable', columns: 1},
			items:[{
					fieldLabel: '<t:message code="system.label.sales.itemaccount" default="품목계정"/>',
					name: 'ITEM_ACCOUNT',
					xtype: 'uniCombobox',
					comboType: 'AU',
					comboCode: 'B020'/*,
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.setValue('ITEM_ACCOUNT', newValue);
						}
					}*/
				}, {
            		xtype: 'radiogroup',
            		fieldLabel: '매출기표유무',
            		//name: 'SALE_YN',
            		items: [{
            			boxLabel: '<t:message code="system.label.sales.whole" default="전체"/>',
            			width: 50,
            			name: 'SALE_YN',
            			inputValue: 'A',
            			checked: true  
            		}, {
            			boxLabel: '<t:message code="system.label.sales.slipposting" default="기표"/>', 
            			width: 50,
            			name: 'SALE_YN',
            			inputValue: 'Y'
            		}, {
            			boxLabel: '<t:message code="system.label.sales.notslipposting" default="미기표"/>',
            			width: 70,
            			name: 'SALE_YN',
            			inputValue: 'N'
            		}]/*,
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							//panelResult.getField('SALE_YN').setValue({SALE_YN: newValue});
							panelResult.getField('SALE_YN').setValue(newValue.SALE_YN);
						}
					}*/
	           },{
	           		fieldLabel: '<t:message code="system.label.sales.creationpath" default="생성경로"/>',
	           		name: 'TXT_CREATE_LOC',
	           		xtype: 'uniCombobox',
	           		comboType: 'AU',
	           		comboCode: 'B031'/*,
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.setValue('TXT_CREATE_LOC', newValue);
						}
					}*/
	           	}, {
	           		fieldLabel: '<t:message code="system.label.sales.vattype" default="부가세유형"/>',
	           		name: 'BILL_TYPE',
	           		xtype: 'uniCombobox',
	           		comboType: 'AU',
	           		comboCode: 'S024'/*,
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.setValue('BILL_TYPE', newValue);
						}
					}*/
           	}, {		 	 
		 	 	fieldLabel: '<t:message code="system.label.sales.customclass" default="거래처분류"/>'	,
		 	 	name: 'AGENT_TYPE',
		 	 	xtype: 'uniCombobox',
		 	 	comboType: 'AU',
		 	 	comboCode: 'B055'  
		 	 },
		 	 	Unilite.popup('ITEM_GROUP',{ 
		 	 	fieldLabel: '<t:message code="system.label.sales.repmodel" default="대표모델"/>', 
		 	 	textFieldName: 'ITEM_GROUP_CODE', 
		 	 	valueFieldName: 'ITEM_GROUP_NAME',
		 	 	 validateBlank: false,
		 	 	popupWidth: 710
		 	 }), {
		 	 	fieldLabel: '<t:message code="system.label.sales.issuetype" default="출고유형"/>',
		 	 	name: 'INOUT_TYPE_DETAIL',
		 	 	xtype: 'uniCombobox',
		 	 	comboType: 'AU',
		 	 	comboCode: 'S007'
		 	 }, {
	 	 		fieldLabel: '<t:message code="system.label.sales.area" default="지역"/>',
	 	 		name: 'AREA_TYPE',
	 	 		xtype: 'uniCombobox',
	 	 		comboType: 'AU',
	 	 		comboCode: 'B056'  
	 	 	},
	 	 		Unilite.popup('AGENT_CUST',{
	 	 		fieldLabel: '<t:message code="system.label.sales.summarycustom" default="집계거래처"/>',
	 	 		validateBlank: false,
	 	 		
	 	 		valueFieldName: 'MANAGE_CUSTOM',
	 	 		textFieldName: 'MANAGE_CUSTOM_NAME',
				id: 'ssa456skrvvCustPopup',
				extParam: {'CUSTOM_TYPE': ''}
			}),{
				fieldLabel: '<t:message code="system.label.sales.sellingtype" default="판매유형"/>'	,
				name: 'ORDER_TYPE',
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'S002'
			}, { 
				fieldLabel: '<t:message code="system.label.sales.majorgroup" default="대분류"/>',
				name: 'ITEM_LEVEL1', 
				xtype: 'uniCombobox',
				store: Ext.data.StoreManager.lookup('itemLeve1Store'),
				child: 'ITEM_LEVEL2'
			}, {
				fieldLabel: '<t:message code="system.label.sales.middlegroup" default="중분류"/>',
				name: 'ITEM_LEVEL2',
				xtype: 'uniCombobox',
				store: Ext.data.StoreManager.lookup('itemLeve2Store'),
				child: 'ITEM_LEVEL3'
			}, {
				fieldLabel: '<t:message code="system.label.sales.minorgroup" default="소분류"/>',
				name: 'ITEM_LEVEL3', 
				xtype: 'uniCombobox',
				store: Ext.data.StoreManager.lookup('itemLeve3Store'),
				parentNames:['ITEM_LEVEL1','ITEM_LEVEL2'],
	            levelType:'ITEM'
			}, { 
		 	 	xtype: 'container',
				layout: {type: 'hbox', align: 'stretch'},
				width: 325,
				defaultType: 'uniTextfield',	            			 				
				items: [{
					fieldLabel: '<t:message code="system.label.sales.salesno" default="매출번호"/>',
					suffixTpl: '&nbsp;~&nbsp;',
					name: 'BILL_FR_NO',
					width: 218
				}, {
					hideLabel: true,
					name: 'BILL_TO_NO',
					width: 107
				}] 
	        }, { 
		 	    xtype: 'container',
			    layout: {type: 'hbox', align: 'stretch'},
			    width: 325,
			    defaultType: 'uniTextfield',	            			 				
			    items: [{
			  		fieldLabel: '<t:message code="system.label.sales.billno" default="계산서번호"/>',
			  		suffixTpl: '&nbsp;~&nbsp;',
			  		name: 'PUB_FR_NUM',
					width: 218
			  	}, {
			  	hideLabel: true,
			  	name: 'PUB_TO_NUM',
			  	width: 107
			  	}] 
	        }, {
	        	fieldLabel: '<t:message code="system.label.sales.salesqty" default="매출량"/>',
	        	name: 'SALE_FR_Q',
	        	suffixTpl: '&nbsp;이상'
	        }, {
	        	fieldLabel: ' ',
	        	name: 'SALE_TO_Q',
	        	suffixTpl: '&nbsp;이하'
	        }, {
		        fieldLabel: '<t:message code="system.label.sales.issuedate" default="출고일"/>',
	             xtype: 'uniDateRangefield',
	             startFieldName: 'INOUT_FR_DATE',
	             endFieldName: 'INOUT_TO_DATE',
	             width: 315							              
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
   						var labelText = invalid.items[0]['fieldLabel']+' : ';
   					} else if(Ext.isDefined(invalid.items[0].ownerCt)) {
   						var labelText = invalid.items[0].ownerCt['fieldLabel']+' : ';
   					}

				   	Unilite.messageBox(labelText+'<t:message code="system.message.sales.datacheck001" default="필수입력 항목입니다."/>');
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
			fieldLabel: '<t:message code="system.label.sales.division" default="사업장"/>',
			name: 'DIV_CODE',
			xtype: 'uniCombobox',
			comboType: 'BOR120',
			value: UserInfo.divCode,
			allowBlank: false,
			listeners: {
				change: function(combo, newValue, oldValue, eOpts) {	
					combo.changeDivCode(combo, newValue, oldValue, eOpts);
					var field = panelSearch.getField('SALE_PRSN');	
					field.fireEvent('changedivcode', field, newValue, oldValue, eOpts);//panelResult의 필터링 처리 위해..
					panelSearch.setValue('DIV_CODE', newValue);
				}
			}
		},
		Unilite.popup('DEPT', { 
			fieldLabel: '<t:message code="system.label.sales.department" default="부서"/>', 
			valueFieldName: 'DEPT_CODE',
	   	 	textFieldName: 'DEPT_NAME',
			
			holdable: 'hold',
			allowBlank: false,
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
		}),
		Unilite.popup('AGENT_CUST',{
			fieldLabel: '<t:message code="system.label.sales.custom" default="거래처"/>',
			
			extParam: {'CUSTOM_TYPE': '3'},
			valueFieldName: 'SALE_CUSTOM_CODE',
			textFieldName: 'SALE_CUSTOM_NAME',
			listeners: {
				onSelected: {
					fn: function(records, type) {
						panelSearch.setValue('SALE_CUSTOM_CODE', panelResult.getValue('SALE_CUSTOM_CODE'));
						panelSearch.setValue('SALE_CUSTOM_NAME', panelResult.getValue('SALE_CUSTOM_NAME'));				 																							
					},
					scope: this
				},
				onClear: function(type)	{
					panelSearch.setValue('SALE_CUSTOM_CODE', '');
					panelSearch.setValue('SALE_CUSTOM_NAME', '');
				}/*,  거래처팝업 고객구분(AGENT_TYPE) 의 필터 처리
				applyextparam: function(popup){
					if(Ext.isDefined(panelSearch)){
						popup.setExtParam({'AGENT_CUST_FILTER': ['3']});
					}
				}*/
			}
		}), {
			fieldLabel: '<t:message code="system.label.sales.salesdate" default="매출일"/>',
	        width: 315,
            xtype: 'uniDateRangefield',
            allowBlank: false,
            startFieldName: 'SALE_FR_DATE',
            endFieldName: 'SALE_TO_DATE',
            //startDate: UniDate.get('startOfMonth'),
            startDate: UniDate.get('today'),
            endDate: UniDate.get('today'),                	
            onStartDateChange: function(field, newValue, oldValue, eOpts) {
            	if(panelSearch) {
					panelSearch.setValue('SALE_FR_DATE',newValue);
					//panelSearch.getField('ISSUE_REQ_DATE_FR').validate();
					
            	}
		    },
		    onEndDateChange: function(field, newValue, oldValue, eOpts) {
		    	if(panelSearch) {
		    		panelSearch.setValue('SALE_TO_DATE',newValue);
		    		//panelSearch.getField('ISSUE_REQ_DATE_TO').validate();				    		
		    	}
		    }
        },{
			fieldLabel: '<t:message code="system.label.sales.salescharge" default="영업담당"/>'	,
			name: 'SALE_PRSN',
			xtype: 'uniCombobox',
			comboType: 'AU',
			comboCode: 'S010',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('SALE_PRSN', newValue);
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
			Unilite.popup('DIV_PUMOK', {
			fieldLabel: '<t:message code="system.label.sales.item" default="품목"/>',
			
			listeners: {
				onSelected: {
					fn: function(records, type) {
						panelSearch.setValue('ITEM_CODE', panelResult.getValue('ITEM_CODE'));
						panelSearch.setValue('ITEM_NAME', panelResult.getValue('ITEM_NAME'));				 																							
					},
					scope: this
				},
				onClear: function(type)	{
					panelSearch.setValue('ITEM_CODE', '');
					panelSearch.setValue('ITEM_NAME', '');
				},
				applyextparam: function(popup){							
					popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
				}
			}
		})
		/*, {
			fieldLabel: '<t:message code="system.label.sales.itemaccount" default="품목계정"/>',
			name: 'ITEM_ACCOUNT',
			xtype: 'uniCombobox',
			comboType: 'AU',
			comboCode: 'B020',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('ITEM_ACCOUNT', newValue);
				}
			}
		}, {
    		xtype: 'radiogroup',
    		fieldLabel: '매출기표유무',
    		//name: 'SALE_YN',
    		items: [{
    			boxLabel: '<t:message code="system.label.sales.whole" default="전체"/>',
    			width: 50,
    			name: 'SALE_YN',
    			inputValue: 'A',
    			checked: true  
    		}, {
    			boxLabel: '<t:message code="system.label.sales.slipposting" default="기표"/>', 
    			width: 50,
    			name: 'SALE_YN',
    			inputValue: 'Y'
    		}, {
    			boxLabel: '<t:message code="system.label.sales.notslipposting" default="미기표"/>',
    			width: 70,
    			name: 'SALE_YN',
    			inputValue: 'N'
    		}],
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					//panelSearch.getField('SALE_YN').setValue({SALE_YN: newValue});
					panelSearch.getField('SALE_YN').setValue(newValue.SALE_YN);
				}
			}
       },{
       		fieldLabel: '<t:message code="system.label.sales.creationpath" default="생성경로"/>',
       		name: 'TXT_CREATE_LOC',
       		xtype: 'uniCombobox',
       		comboType: 'AU',
       		comboCode: 'B031',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('TXT_CREATE_LOC', newValue);
				}
			}
       	}, {
       		fieldLabel: '<t:message code="system.label.sales.vattype" default="부가세유형"/>',
       		name: 'BILL_TYPE',
       		xtype: 'uniCombobox',
       		comboType: 'AU',
       		comboCode: 'S024',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('BILL_TYPE', newValue);
				}
			}
       	}*/]	
    });

	
	/**
     * Master Chart1 정의(Chart Panel)
     * @type 
     */

	var chart2 = {
		id:'chart2',
        xtype: 'chart',
        width: '100%',
        height: 290,
        flex:1,
        padding: '20 20 20 20',
        style: 'background: #fff',
        animate: true,
        shadow: false,
        store: directMasterStore1,
        insetPadding: 40, 
       
        axes: [{
            type: 'Numeric',
            position: 'bottom',
            fields: ['SALE_AMT_O'],
            grid: true,
            label: {
//                renderer: Ext.util.Format.numberRenderer('0,000')
            },
        }, {
            type: 'Category',
            position: 'left',
            fields: ['LEVEL_NAME'],
            grid: true
            
        }],
        series: [{
            type: 'bar',
            axis: 'bottom',
            xField: 'LEVEL_NAME',
            yField: 'SALE_AMT_O',
            renderer: function(sprite, record, attr, index, store) {
                return Ext.apply(attr, {
                    fill: 'green'
                });
            },
            style: {
                opacity: 0.60
            },
//            colorSet: ['#0000FF'],
            highlight: {
                fill: '#000',
                'stroke-width': 2,
                stroke: '#fff'
            },
            tips: {
                trackMouse: true,
                style: 'background: #FFF',
                height: 20,
                renderer: function(storeItem, item) {
                    this.setTitle(storeItem.get('LEVEL_NAME') + ': ' + storeItem.get('SALE_AMT_O'));
                }
            }
        }]
    };	
	

	/**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
/*     
    var masterGrid = Unilite.createGrid('ssa456skrvGrid1', {
    	// for tab
    	region: 'center',
        //layout: 'fit',    
		syncRowHeight: false,   
		// Yoon 추가
		plugins: [
			{
				ptype: 'bufferedrenderer',
				trailingBufferZone: 100,
				leadingBufferZone: 100
			}
		],
		// Yoon end
		uniOpt:{onLoadSelectFirst: false},
    	store: directMasterStore1,
    	//features: [ {id: 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false },
    	//           	{id: 'masterGridTotal', 	ftype: 'uniSummary',  showSummaryRow: false} ],
        columns:  [        
               		{ dataIndex: 'SALE_CUSTOM_CODE'	    ,		   	width: 80, locked: false  }, 			
					{ dataIndex: 'SALE_CUSTOM_NAME'			,		   	width: 100, locked: false }, 	
					{ dataIndex: 'BILL_TYPE'				,		   	width: 80},	
					{ dataIndex: 'SALE_DATE'				,		   	width: 80}, 				     
					{ dataIndex: 'INOUT_TYPE_DETAIL'	 	,		   	width: 123},				     
					{ dataIndex: 'ITEM_CODE'				,		   	width: 123}, 				     
					{ dataIndex: 'ITEM_NAME'				,		   	width: 123 },					
					{ dataIndex: 'SPEC'						,		   	width: 123 }, 				 
					{ dataIndex: 'SALE_UNIT'				,		   	width: 53, align: 'center'}, 				     
					{ dataIndex: 'PRICE_TYPE'				,		   	width: 53, hidden: true}, 			
					{ dataIndex: 'TRANS_RATE'				,		   	width: 53, align: 'right'},						
					{ dataIndex: 'SALE_Q'					,		   	width: 80 }, 
					{ dataIndex: 'SALE_P'					,		   	width: 113 }, 				 
					{ dataIndex: 'DISCOUNT_RATE'			,		   	width: 106 }, 					     	
					{ dataIndex: 'SALE_LOC_AMT_I'			,		   	width: 113,  }, 				     
					{ dataIndex: 'TAX_TYPE'					,		   	width: 80, align: 'center'}, 			     
					{ dataIndex: 'TAX_AMT_O'				,		   	width: 113 },					     
					{ dataIndex: 'SUM_SALE_AMT'				,		   	width: 113 },
					{ dataIndex: 'CONSIGNMENT_FEE'			,		   	width: 113},
					{ dataIndex: 'MONEY_UNIT'				,		   	width: 80}, 					     
					{ dataIndex: 'EXCHG_RATE_O'				,		   	width: 80, align: 'right'},		
					{ dataIndex: 'SALE_LOC_AMT_F'			,		   	width: 113 },  					 
					{ dataIndex: 'ORDER_TYPE'				,		   	width: 100 }, 	     
					{ dataIndex: 'CUSTOM_CODE'				,		   	width: 80}, 				     
					{ dataIndex: 'CUSTOM_NAME'				,		   	width: 113 },
					{ dataIndex: 'SALE_WGT_Q'				,		   	width: 100, hidden: true }, 			
					{ dataIndex: 'SALE_VOL_Q'				,		   	width: 80, hidden: true},				     
					{ dataIndex: 'SALE_FOR_WGT_P'			,		   	width: 113, hidden: true }, 	
					{ dataIndex: 'SALE_FOR_VOL_P'			,		   	width: 113, hidden: true}, 				 
					{ dataIndex: 'DIV_CODE'					,		   	width: 100 }, 				 
					{ dataIndex: 'SALE_PRSN'				,		   	width: 100}, 				     
					{ dataIndex: 'MANAGE_CUSTOM'			,		   	width: 80}, 				     
					{ dataIndex: 'MANAGE_CUSTOM_NM'			,		   	width: 113 },				     
					{ dataIndex: 'AREA_TYPE'				,		   	width: 66 },			         
					{ dataIndex: 'AGENT_TYPE'				,		   	width: 113 },
					{ dataIndex: 'PROJECT_NO'				,		   	width: 113}, 				     
					{ dataIndex: 'PUB_NUM'					,		   	width: 80}, 				     
					{ dataIndex: 'EX_NUM'					,		   	width: 93 }, 				     
					{ dataIndex: 'BILL_NUM'					,		   	width: 106 }, 				 
					{ dataIndex: 'ORDER_NUM'				,		   	width: 106 }, 					 
					{ dataIndex: 'PRICE_YN'					,	    	width: 106 },					
					{ dataIndex: 'WGT_UNIT'					,	    	width: 106, hidden: true },
					{ dataIndex: 'UNIT_WGT'					,	    	width: 106, hidden: true },
					{ dataIndex: 'VOL_UNIT'					,	    	width: 106, hidden: true },
					{ dataIndex: 'UNIT_VOL'					,	    	width: 106, hidden: true },
					{ dataIndex: 'COMP_CODE'				,	    	width: 106, hidden: true },
					{ dataIndex: 'BILL_SEQ'					,	    	width: 106, hidden: true },
					{ dataIndex: 'CREATE_LOC'				,		   	width: 80 }
					
          ] 
    }); */   
	Unilite.Main( {
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
				chart2, panelResult
			]
		},
			panelSearch  	
		],
		fnInitBinding: function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
//			panelSearch.setValue('DEPT_CODE', UserInfo.deptCode);
//        	panelSearch.setValue('DEPT_NAME', UserInfo.deptName);
        	panelSearch.setValue('SALE_TO_DATE', UniDate.get('today'));
        	panelSearch.setValue('SALE_FR_DATE', UniDate.get('today'));
        	//panelSearch.setValue('SALE_FR_DATE', UniDate.get('startOfMonth', panelSearch.getValue('SALE_TO_DATE')));
     	
        	var field = panelSearch.getField('SALE_PRSN');
			field.fireEvent('changedivcode', field, UserInfo.divCode, null, null, "DIV_CODE");
		},
		onQueryButtonDown: function()	{
			if(!panelSearch.setAllFieldsReadOnly(true)){
	    		return false;
	    	}
			directMasterStore1.loadStoreRecords();
/* 			var viewLocked = masterGrid.getView();
			var viewNormal = masterGrid.getView();
			viewLocked.getFeature('masterGridSubTotal').toggleSummaryRow(true);
			viewLocked.getFeature('masterGridTotal').toggleSummaryRow(true);
			viewNormal.getFeature('masterGridSubTotal').toggleSummaryRow(true);
			viewNormal.getFeature('masterGridTotal').toggleSummaryRow(true); */			
	
		},		
		onDetailButtonDown: function() {
			var as = Ext.getCmp('AdvanceSerch');	
			if(as.isHidden())	{
				as.show();
			}else {
				as.hide()
			}
		},
		onResetButtonDown: function() {
			panelSearch.clearForm();
			panelResult.clearForm();
			chart2.getStore().loadData({})
			this.fnInitBinding();
			
		}
	});

};


</script>
