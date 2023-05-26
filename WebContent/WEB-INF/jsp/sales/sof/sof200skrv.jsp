<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="sof200skrv"  >
	<t:ExtComboStore comboType="AU" comboCode="B031" opts= '1;5'/> <!--생성경로 -->
	<t:ExtComboStore comboType="AU" comboCode="S010" /> <!-- 영업담당 -->      
	<t:ExtComboStore comboType="BOR120"  pgmId="sof200skrv"/> 			<!-- 사업장 -->  
	<t:ExtComboStore comboType="AU" comboCode="B055" /> <!-- 거래처분류 -->       
	<t:ExtComboStore comboType="AU" comboCode="S002" /> <!--판매유형-->
	<t:ExtComboStore comboType="AU" comboCode="B056" /> <!--지역-->
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL1}" storeId="itemLeve1Store" />
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL2}" storeId="itemLeve2Store" />
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL3}" storeId="itemLeve3Store" />
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>

<script type="text/javascript" >

function appMain() {
	/**
	 *   Model 정의 
	 * @type 
	 */

	Unilite.defineModel('Sof200skrvModel', {
		
	    fields: [
			//20190513 추가: OUT_DIV_CODE
			{name: 'OUT_DIV_CODE'		,text: '<t:message code="system.label.sales.issuedivision" default="출고사업장"/>'	,type: 'string',comboType: 'BOR120'},
			{name: 'CUSTOM_CODE' 		,text: '<t:message code="system.label.sales.custom" default="거래처"/>' 		,type: 'string'},
    		{name: 'CUSTOM_NAME' 		,text: '<t:message code="system.label.sales.customname" default="거래처명"/>' 			,type: 'string'},
    		{name: 'ITEM_CODE' 			,text: '<t:message code="system.label.sales.item" default="품목"/>' 			,type: 'string'},
    		{name: 'ITEM_NAME' 			,text: '<t:message code="system.label.sales.itemname" default="품목명"/>' 			,type: 'string'},
    		{name: 'ITEM_NAME1' 		,text: '<t:message code="system.label.sales.itemname" default="품목명"/>1' 			,type: 'string'},
    		{name: 'SPEC' 				,text: '<t:message code="system.label.sales.spec" default="규격"/>' 			,type: 'string'},
    		{name: 'ORDER_UNIT' 		,text: '<t:message code="system.label.sales.unit" default="단위"/>' 			,type: 'string', displayField: 'value'},
    		{name: 'TRANS_RATE' 		,text: '<t:message code="system.label.sales.containedqty" default="입수"/>' 			,type: 'uniQty'},
    		{name: 'DVRY_DATE' 			,text: '<t:message code="system.label.sales.deliverydate" default="납기일"/>' 			,type: 'uniDate'},
    		
    		{name: 'PRODT_PLAN_DATE'	, text: '<t:message code="system.label.sales.plandate" default="계획일"/>'				, type: 'uniDate'},

    		{name: 'DVRY_TIME' 			,text: '<t:message code="system.label.sales.deliverytime" default="납기시간"/>' 			,type: 'uniDate'},
    		{name: 'ORDER_UNIT_Q' 		,text: '<t:message code="system.label.sales.soqty" default="수주량"/>' 			,type: 'uniQty'},
    		{name: 'ORDER_REM_Q' 		,text: '<t:message code="system.label.sales.undeliveryqty" default="미납량"/>' 			,type: 'uniQty'},
//	    	{name: 'GOOD_STOCK_Q' 		,text: '양품재고' 			,type: 'uniQty'},
    		{name: 'STOCK_UNIT' 		,text: '<t:message code="system.label.sales.inventoryunit" default="재고단위"/>' 			,type: 'string', displayField: 'value'},
    		{name: 'STOCK_Q' 			,text: '<t:message code="system.label.sales.inventoryunitqty2" default="재고단위수량"/>' 		,type: 'uniQty'},
    		{name: 'MONEY_UNIT' 		,text: '<t:message code="system.label.sales.currency" default="화폐"/>' 			,type: 'string'},
    		{name: 'ORDER_P' 			,text: '<t:message code="system.label.sales.price" default="단가"/>' 			,type: 'uniUnitPrice'},
    		{name: 'ORDER_REM_O' 		,text: '<t:message code="system.label.sales.unissuedamount" default="미납액"/>' 			,type: 'uniPrice'},
    		{name: 'EXCHG_RATE_O' 		,text: '<t:message code="system.label.sales.exchangerate" default="환율"/>' 			,type: 'uniER'},
    		{name: 'ORDER_REM_LOC_O' 	,text: '<t:message code="system.label.sales.exchangeamount" default="환산액"/>' 			,type: 'uniPrice'},
    		{name: 'DIFF_FLAG' 	        ,text: '금액검토' 			,type: 'string'},
    		{name: 'ORDER_NUM' 			,text: '<t:message code="system.label.sales.sono" default="수주번호"/>' 			,type: 'string'},
    		{name: 'SER_NO' 			,text: '<t:message code="system.label.sales.seq" default="순번"/>' 			,type: 'integer'},
    		{name: 'ORDER_DATE' 		,text: '<t:message code="system.label.sales.sodate" default="수주일"/>' 			,type: 'uniDate'},
    		{name: 'CLOSE_REMARK' 		,text: '미납/마감사유' 			,type: 'string'},
    		{name: 'ORDER_TYPE_NM' 		,text: '<t:message code="system.label.sales.sellingtype" default="판매유형"/>CD' 		,type: 'string'},
    		{name: 'ORDER_TYPE' 		,text: '<t:message code="system.label.sales.sellingtype" default="판매유형"/>' 			,type: 'string', comboType:"AU", comboCode:"S002"},
    		{name: 'PROJECT_NO'			,text: '<t:message code="system.label.sales.projectno" default="프로젝트번호"/>'		,type: 'string'},
    		{name: 'PO_NUM' 			,text: '<t:message code="system.label.sales.pono2" default="P/O 번호"/>' 			,type: 'string'},
    		{name: 'ORDER_PRSN_NM' 		,text: '<t:message code="system.label.sales.salescharge" default="영업담당"/>CD' 		,type: 'string'},
    		{name: 'ORDER_PRSN' 		,text: '<t:message code="system.label.sales.salescharge" default="영업담당"/>' 			,type: 'string', comboType:"AU", comboCode:"S010"},
    		{name: 'SORT_KEY' 			,text: 'SORTKEY' 		,type: 'string'},
    		{name: 'COMP_CODE' 			,text: '<t:message code="system.label.sales.compcode" default="법인코드"/>' 			,type: 'string'},
    		{name: 'DIV_CODE' 			,text: '<t:message code="system.label.sales.division" default="사업장"/>' 			,type: 'string'}	    		
		]
	});
	
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore1 = Unilite.createStore('sof200skrvMasterStore1',{
			model: 'Sof200skrvModel',
			uniOpt : {
            	isMaster: true,			// 상위 버튼 연결 
            	editable: false,			// 수정 모드 사용 
            	deletable:false,			// 삭제 가능 여부 
	            useNavi : false			// prev | next 버튼 사용
            },
            autoLoad: false,
            proxy: {
                type: 'direct',
                api: {			
                	   read: 'sof200skrvService.selectList'                	
                }
            }
			,loadStoreRecords : function()	{
				var param= Ext.getCmp('searchForm').getValues();	
				var authoInfo = pgmInfo.authoUser;				//권한정보(N-전체,A-자기사업장>5-자기부서)
				var deptCode = UserInfo.deptCode;	//부서코드
				if(authoInfo == "5" && Ext.isEmpty(panelSearch.getValue('DEPT_CODE'))){
					param.DEPT_CODE = deptCode;
				}
				console.log( param );
				this.load({
					params : param
				});
				
			},
			groupField: 'CUSTOM_NAME'
			,listeners:{
				load:function( store, records, successful, operation, eOpts )	{
					if(records && records.length > 0){
						masterGrid.setShowSummaryRow(true);
					}
				}
			}
			
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
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',
		    items : [{					
    			fieldLabel: '<t:message code="system.label.sales.division" default="사업장"/>',
    			name:'DIV_CODE',
    			xtype: 'uniCombobox',
    			comboType:'BOR120',
    			allowBlank:false,
				listeners: {
					change: function(combo, newValue, oldValue, eOpts) {	
						combo.changeDivCode(combo, newValue, oldValue, eOpts);						
						panelResult.setValue('DIV_CODE', newValue);
					}
				}
    		}, {
                fieldLabel: '<t:message code="system.label.sales.sodate" default="수주일"/>',
                startFieldName: 'ORDER_DATE_FR',
                endFieldName: 'ORDER_DATE_TO',
                xtype: 'uniDateRangefield',
                width: 315,
                startDate: UniDate.get('startOfMonth'),
                endDate: UniDate.get('today'),                  
                onStartDateChange: function(field, newValue, oldValue, eOpts) {
                    if(panelResult) {
                        panelResult.setValue('ORDER_DATE_FR',newValue);
                        //panelSearch.getField('ISSUE_REQ_DATE_FR').validate();
                    }
                },
                onEndDateChange: function(field, newValue, oldValue, eOpts) {
                    if(panelResult) {
                        panelResult.setValue('ORDER_DATE_TO',newValue);
                        //panelSearch.getField('ISSUE_REQ_DATE_TO').validate();
                        
                    }
                }
            }, { 
    			fieldLabel: '<t:message code="system.label.sales.deliverydate" default="납기일"/>',
		        xtype: 'uniDateRangefield',
		        startFieldName: 'DVRY_DATE_FR',
		        endFieldName: 'DVRY_DATE_TO',
		        width: 470,              	
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
	        },
			Unilite.popup('AGENT_CUST',{
				fieldLabel: '<t:message code="system.label.sales.custom" default="거래처"/>',
				valueFieldName	: 'CUSTOM_CODE',
				textFieldName	: 'CUSTOM_NAME',
				validateBlank	: false,
				listeners: {
					onValueFieldChange: function(field, newValue, oldValue){
						panelResult.setValue('CUSTOM_CODE', newValue);

						if(!Ext.isObject(oldValue)) {
							panelSearch.setValue('CUSTOM_NAME', '');
							panelResult.setValue('CUSTOM_NAME', '');
						}
					},
					onTextFieldChange: function(field, newValue, oldValue){
						panelResult.setValue('CUSTOM_NAME', newValue);

						if(!Ext.isObject(oldValue)) {
							panelSearch.setValue('CUSTOM_CODE', '');
							panelResult.setValue('CUSTOM_CODE', '');
						}
					}
				}
			}),
			Unilite.popup('DIV_PUMOK',{
				fieldLabel		: '<t:message code="system.label.sales.item" default="품목"/>',
				valueFieldName	: 'ITEM_CODE',
				textFieldName	: 'ITEM_NAME',
				validateBlank	: false,
				listeners: {
					onValueFieldChange: function(field, newValue, oldValue){
						panelResult.setValue('ITEM_CODE', newValue);
						
						if(!Ext.isObject(oldValue)) {
							panelSearch.setValue('ITEM_NAME', '');
							panelResult.setValue('ITEM_NAME', '');
						}
					},
					onTextFieldChange: function(field, newValue, oldValue){
						panelResult.setValue('ITEM_NAME', newValue);
						
						if(!Ext.isObject(oldValue)) {
							panelSearch.setValue('ITEM_CODE', '');
							panelResult.setValue('ITEM_CODE', '');
						}
					},
					applyextparam: function(popup){
						popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
					}
				}
			}),
			Unilite.popup('PROJECT',{
				fieldLabel: '<t:message code="system.label.sales.projectno" default="프로젝트번호"/>',
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
/*                Unilite.popup('DEPT',{ 
                    fieldLabel: '<t:message code="system.label.sales.department" default="부서"/>', 
                    valueFieldName: 'DEPT_CODE',
                    textFieldName: 'DEPT_NAME',
                    listeners: {
                        onSelected: {
                            fn: function(records, type) {
                                panelResult.setValue('DEPT_CODE', panelSearch.getValue('DEPT_CODE'));
                                panelResult.setValue('DEPT_NAME', panelSearch.getValue('DEPT_NAME'));                                                                                                           
                            },
                            scope: this
                        },
                        onClear: function(type) {
                            panelResult.setValue('DEPT_CODE', '');
                            panelResult.setValue('DEPT_NAME', '');
                        },
                        applyextparam: function(popup){                         
                            var authoInfo = pgmInfo.authoUser;              //권한정보(N-전체,A-자기사업장>5-자기부서)
                            var deptCode = UserInfo.deptCode;   //부서정보
                            var divCode = '';                   //사업장
                            
                            if(authoInfo == "A"){   
                                popup.setExtParam({'DEPT_CODE': ""});
                                popup.setExtParam({'DIV_CODE': UserInfo.divCode});
                                
                            }else if(authoInfo == "N" || Ext.isEmpty(authoInfo)){   //전체권한
                                popup.setExtParam({'DEPT_CODE': ""});
                                popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
                                
                            }else if(authoInfo == "5"){     //부서권한
                                popup.setExtParam({'DEPT_CODE': deptCode});
                                popup.setExtParam({'DIV_CODE': UserInfo.divCode});
                            }
                        }
                    }
            })*/
            ]		
		}, {
			title:'<t:message code="system.label.sales.additionalinfo" default="추가정보"/>',
			id: 'search_panel2',
			itemId:'search_panel2',
	    	defaultType: 'uniTextfield',
	    	layout: {type: 'uniTable', columns: 1},
			items:[{
    			fieldLabel: '<t:message code="system.label.sales.salescharge" default="영업담당"/>'	,
    			name:'ORDER_PRSN', 
    			xtype: 'uniCombobox', 
    			comboType:'AU',
    			comboCode:'S010',
				onChangeDivCode: function(combo, newValue, oldValue, eOpts, divCode){
					if(eOpts){
						combo.filterByRefCode('refCode1', newValue, eOpts.parent);
					}else{
						combo.divFilterByRefCode('refCode1', newValue, divCode);
					}
				}
    		}, {
    			fieldLabel: '<t:message code="system.label.sales.majorgroup" default="대분류"/>',
    			name: 'TXTLV_L1',
    			xtype: 'uniCombobox',
    			store: Ext.data.StoreManager.lookup('itemLeve1Store'),
    			child: 'TXTLV_L2'
    		}, {
    			fieldLabel: '<t:message code="system.label.sales.middlegroup" default="중분류"/>',
    			name: 'TXTLV_L2',
    			xtype: 'uniCombobox' ,
    			store: Ext.data.StoreManager.lookup('itemLeve2Store') , 
    			child: 'TXTLV_L3'
    		}, {
    			fieldLabel: '<t:message code="system.label.sales.minorgroup" default="소분류"/>',
    			name: 'TXTLV_L3',
    			xtype: 'uniCombobox' ,
    			store: Ext.data.StoreManager.lookup('itemLeve3Store'),
				parentNames:['TXTLV_L1','TXTLV_L2'],
	            levelType:'ITEM'
    		}, {
        		fieldLabel: '<t:message code="system.label.sales.undeliveryqty" default="미납량"/>',
        		name:'FR_ORDER_QTY' ,
        		suffixTpl:'&nbsp;<t:message code="system.label.sales.over" default="이상"/>'
    		}, {
        		fieldLabel: '~',
        		name:'TO_ORDER_QTY' ,
        		suffixTpl:'&nbsp;<t:message code="system.label.sales.below" default="이하"/>'
    		}, {
        		fieldLabel: '<t:message code="system.label.sales.customclass" default="거래처분류"/>',
        		name:'AGENT_TYPE',
        		xtype: 'uniCombobox',
        		comboType:'AU',
        		comboCode:'B055'
    		}, {
    			fieldLabel: '<t:message code="system.label.sales.area" default="지역"/>',
    			name:'AREA_TYPE',
    			xtype: 'uniCombobox',
    			comboType:'AU',
    			comboCode:'B056'
    		}, {
    			fieldLabel: '<t:message code="system.label.sales.sellingtype" default="판매유형"/>'	,
    			name:'ORDER_TYPE',
    			xtype: 'uniCombobox',
    			comboType:'AU',
    			comboCode:'S002'
    		},
    			Unilite.popup('ITEM_GROUP',{
    			fieldLabel: '<t:message code="system.label.sales.repmodel" default="대표모델"/>',
    			textFieldName:'ITEM_GROUP_CODE',
    			valueFieldName:'ITEM_GROUP_NAME',
    			
    			validateBlank:false,
    			popupWidth: 710
    	   }), {
    			fieldLabel: '<t:message code="system.label.sales.creationpath" default="생성경로"/>',
    			name:'CREATE_LOC',
    			xtype: 'uniCombobox',
    			comboType:'AU',
    			comboCode:'B031'
    		}, {
			    xtype: 'radiogroup',
			    fieldLabel: '<t:message code="system.label.sales.status" default="상태"/>',			    
			    colspan: 2,
			    items : [{
			    	boxLabel: '<t:message code="system.label.sales.whole" default="전체"/>',
			    	name: 'STATUS',
			    	inputValue: 'A',
			    	checked: true,
			    	width:60
			    }, {
			    	boxLabel: '<t:message code="system.label.sales.unapproved" default="미승인"/>',
			    	name: 'STATUS' ,
			    	inputValue: 'N',
			    	width:60
			    }, {boxLabel: '<t:message code="system.label.sales.approved" default="승인"/>',
			    	name: 'STATUS',
			    	inputValue: '6',
			    	width:80
			    }, {boxLabel: '<t:message code="system.label.sales.giveback" default="반려"/>',
			    	name: 'STATUS' ,
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
			name:'DIV_CODE',
			xtype: 'uniCombobox',
			comboType:'BOR120',
			allowBlank:false,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('DIV_CODE', newValue);
				}
			}
		}, {
            fieldLabel: '<t:message code="system.label.sales.sodate" default="수주일"/>',
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
        },{ 
			fieldLabel: '<t:message code="system.label.sales.deliverydate" default="납기일"/>',
	        xtype: 'uniDateRangefield',
	        startFieldName: 'DVRY_DATE_FR',
	        endFieldName: 'DVRY_DATE_TO',
	        width: 315,
	        startDate: UniDate.get('startOfMonth'),
	        endDate: UniDate.get('today'),                	
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
        },
		Unilite.popup('AGENT_CUST',{
			fieldLabel: '<t:message code="system.label.sales.custom" default="거래처"/>',
			valueFieldName	: 'CUSTOM_CODE',
			textFieldName	: 'CUSTOM_NAME',
			validateBlank	: false,
			
			listeners: {
				onValueFieldChange: function(field, newValue, oldValue){
					panelSearch.setValue('CUSTOM_CODE', newValue);

					if(!Ext.isObject(oldValue)) {
						panelSearch.setValue('CUSTOM_NAME', '');
						panelResult.setValue('CUSTOM_NAME', '');
					}
				},
				onTextFieldChange: function(field, newValue, oldValue){
					panelSearch.setValue('CUSTOM_NAME', newValue);

					if(!Ext.isObject(oldValue)) {
						panelSearch.setValue('CUSTOM_CODE', '');
						panelResult.setValue('CUSTOM_CODE', '');
					}
				}
			}
		}),
		Unilite.popup('DIV_PUMOK',{
			fieldLabel		: '<t:message code="system.label.sales.item" default="품목"/>',
			valueFieldName	: 'ITEM_CODE',
			textFieldName	: 'ITEM_NAME',
			validateBlank	: false,
			listeners: {
				onValueFieldChange: function(field, newValue, oldValue){
					panelSearch.setValue('ITEM_CODE', newValue);
					
					if(!Ext.isObject(oldValue)) {
						panelSearch.setValue('ITEM_NAME', '');
						panelResult.setValue('ITEM_NAME', '');
					}
				},
				onTextFieldChange: function(field, newValue, oldValue){
					panelSearch.setValue('ITEM_NAME', newValue);
					
					if(!Ext.isObject(oldValue)) {
						panelSearch.setValue('ITEM_CODE', '');
						panelResult.setValue('ITEM_CODE', '');
					}
				},
				applyextparam: function(popup){
					popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
				}
			}
	    }), 
	    		Unilite.popup('PROJECT',{
				fieldLabel: '<t:message code="system.label.sales.projectno" default="프로젝트번호"/>',
				valueFieldName:'PJT_CODE',
			    textFieldName:'PJT_NAME',
	       		DBvalueFieldName: 'PJT_CODE',
			    DBtextFieldName: 'PJT_NAME',
				validateBlank: false,
				autoPopup: true,
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
				})
/*            Unilite.popup('DEPT',{ 
            fieldLabel: '<t:message code="system.label.sales.department" default="부서"/>', 
            valueFieldName: 'DEPT_CODE',
            textFieldName: 'DEPT_NAME',
            listeners: {
                onSelected: {
                    fn: function(records, type) {
                        panelSearch.setValue('DEPT_CODE', panelResult.getValue('DEPT_CODE'));
                        panelSearch.setValue('DEPT_NAME', panelResult.getValue('DEPT_NAME'));                                                                                                           
                    },
                    scope: this
                },
                onClear: function(type) {
                    panelSearch.setValue('DEPT_CODE', '');
                    panelSearch.setValue('DEPT_NAME', '');
                },
                applyextparam: function(popup){                         
                    var authoInfo = pgmInfo.authoUser;              //권한정보(N-전체,A-자기사업장>5-자기부서)
                    var deptCode = UserInfo.deptCode;   //부서정보
                    var divCode = '';                   //사업장
                    
                    if(authoInfo == "A"){   
                        popup.setExtParam({'DEPT_CODE': ""});
                        popup.setExtParam({'DIV_CODE': UserInfo.divCode});
                        
                    }else if(authoInfo == "N" || Ext.isEmpty(authoInfo)){   //전체권한
                        popup.setExtParam({'DEPT_CODE': ""});
                        popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
                        
                    }else if(authoInfo == "5"){     //부서권한
                        popup.setExtParam({'DEPT_CODE': deptCode});
                        popup.setExtParam({'DIV_CODE': UserInfo.divCode});
                    }
                }
            }
        })*/
        ]	
    });
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    
    var masterGrid = Unilite.createGrid('sof200skrvGrid1', {
    	// for tab    	
        layout : 'fit',
        region:'center',
    	store: directMasterStore1,
    	features: [ {id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false },
    	           	{id : 'masterGridTotal', 	ftype: 'uniSummary', 	  showSummaryRow: false} ],
        columns:  [
        	//20190513 추가: OUT_DIV_CODE
			{dataIndex: 'OUT_DIV_CODE',		width: 120 },
       		{ dataIndex: 'CUSTOM_CODE', 	width:66, locked:false},
			{ dataIndex: 'CUSTOM_NAME', 	width:133, locked:false,
				summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
				return Unilite.renderSummaryRow(summaryData, metaData, '<t:message code="system.label.sales.subtotal" default="소계"/>', '<t:message code="system.label.sales.total" default="총계"/>');
			}},
			{ dataIndex: 'ITEM_CODE', 		width:120, locked:false},
			{ dataIndex: 'ITEM_NAME', 		width:200, locked:false},
			{ dataIndex: 'ITEM_NAME1', 		width:200, hidden: true},
			{ dataIndex: 'SPEC', 			width:150},
			{ dataIndex: 'ORDER_UNIT', 		width:53, align:'center'},
			{ dataIndex: 'TRANS_RATE', 		width:53, align:'right'},
			{ dataIndex: 'DVRY_DATE', 		width:80},
			
			{ dataIndex: 'PRODT_PLAN_DATE', 		width:80},
			
			{ dataIndex: 'DVRY_TIME', 		width:53, hidden:true},
			{ dataIndex: 'ORDER_UNIT_Q', 	width:80, summaryType:'sum'},
			{ dataIndex: 'ORDER_REM_Q', 	width:80, summaryType:'sum'},
//			{ dataIndex: 'GOOD_STOCK_Q', 	width:106, align:'right', summaryType:'sum'},
			{ dataIndex: 'STOCK_UNIT', 		width:53, hidden:true},
			{ dataIndex: 'STOCK_Q', 		width:106, hidden:true},
			{ dataIndex: 'MONEY_UNIT', 		width:53, align:'center'},
			{ dataIndex: 'ORDER_P', 		width:113},
			{ dataIndex: 'ORDER_REM_O', 	width:120},
			{ dataIndex: 'EXCHG_RATE_O', 	width:66, align:'right'},
			{ dataIndex: 'ORDER_REM_LOC_O', width:120, summaryType:'sum'},
			{ dataIndex: 'DIFF_FLAG', 	    width:100, align:'center', hidden:true},
			{ dataIndex: 'ORDER_NUM', 		width:113},
			{ dataIndex: 'SER_NO', 			width:58},
			{ dataIndex: 'ORDER_DATE', 		width:80},
			{ dataIndex: 'ORDER_TYPE', 		width:100},
			{ dataIndex: 'CLOSE_REMARK', 		width:200},
			{ dataIndex: 'ORDER_TYPE_NM', 	width:133, hidden:true},
			{ dataIndex: 'PROJECT_NO',		width:100},
			{ dataIndex: 'PO_NUM', 			width:86},
			{ dataIndex: 'ORDER_PRSN', 		width:100, align:'center'},
			{ dataIndex: 'ORDER_PRSN_NM', 	width:133, hidden:true},
			{ dataIndex: 'SORT_KEY', 		width:133, hidden:true},
			{ dataIndex: 'COMP_CODE', 		width:133, hidden:true},
			{ dataIndex: 'DIV_CODE', 		width:133, hidden:true} 
        ] 
    });   
	
	
    Unilite.Main( {
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
		id  : 'sof200skrvApp',
		fnInitBinding : function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
//			panelSearch.setValue('DEPT_CODE', UserInfo.deptCode);
//			panelSearch.setValue('DEPT_NAME', UserInfo.deptName);
			panelSearch.setValue('DVRY_DATE_TO', UniDate.get('today'));
			panelSearch.setValue('DVRY_DATE_FR', UniDate.get('startOfMonth', panelSearch.getValue('DVRY_DATE_TO')));
			
			panelResult.setValue('DIV_CODE',UserInfo.divCode);
//			panelResult.setValue('DEPT_CODE', UserInfo.deptCode);
//			panelResult.setValue('DEPT_NAME', UserInfo.deptName);
			panelResult.setValue('DVRY_DATE_TO', UniDate.get('today'));
			panelResult.setValue('DVRY_DATE_FR', UniDate.get('startOfMonth', panelSearch.getValue('DVRY_DATE_TO')));
			
			var field = panelSearch.getField('ORDER_PRSN');
			field.fireEvent('changedivcode', field, UserInfo.divCode, null, null, "DIV_CODE");
		},
		onQueryButtonDown : function()	{
			if(!panelSearch.setAllFieldsReadOnly(true)){
	    		return false;
	    	}
	    	directMasterStore1.loadStoreRecords();
		},
		onDetailButtonDown:function() {
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
			masterGrid.reset();
			directMasterStore1.clearData();
			this.fnInitBinding();
			
		}
	});

};
</script>