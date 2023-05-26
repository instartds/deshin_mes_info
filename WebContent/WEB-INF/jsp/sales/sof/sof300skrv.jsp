<%--
'   프로그램명 : 품목별 출고진행현황 (영업)
'
'   작  성  자 : (주)포렌 개발실
'   작  성  일 :
'
'   최종수정자 :
'   최종수정일 :
'
'   버      전 : OMEGA Plus V6.0.0
--%>

<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="sof300skrv"  >
	<t:ExtComboStore comboType="AU" comboCode="S010" /> <!--영업담당 -->
	<t:ExtComboStore comboType="BOR120"  pgmId="sof300skrv" /> 			<!-- 사업장 -->  
	<t:ExtComboStore comboType="AU" comboCode="B055" /> <!-- 거래처분류 -->      
	<t:ExtComboStore comboType="AU" comboCode="B056" /> <!-- 지역 -->       
	<t:ExtComboStore comboType="AU" comboCode="S002" /> <!--판매유형-->
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

	Unilite.defineModel('Sof300skrvModel', {
	    fields: [
	             {name: 'CUSTOM_CODE'     		,text:'<t:message code="system.label.sales.custom" 			  default="거래처"/>'		,type:'string'},
	    		 {name: 'CUSTOM_NAME'     		,text:'<t:message code="system.label.sales.customname" default="거래처명"/>'		,type:'string'},
	    		 {name: 'ITEM_CODE'       		,text:'<t:message code="system.label.sales.item" default="품목"/>'		,type:'string'},
	    		 {name: 'ITEM_NAME'       		,text:'<t:message code="system.label.sales.itemname" default="품목명"/>'		,type:'string'},
	    		 {name: 'SPEC'            		,text:'<t:message code="system.label.sales.spec" default="규격"/>'			,type:'string'},
	    		 {name: 'ORDER_UNIT'      		,text:'<t:message code="system.label.sales.unit" default="단위"/>'			,type:'string', displayField: 'value'},
	    		 {name: 'TRANS_RATE'      		,text:'<t:message code="system.label.sales.containedqty" default="입수"/>'			,type:'string'},
	    		 {name: 'ORDER_DATE'      		,text:'<t:message code="system.label.sales.sodate" default="수주일"/>'		,type:'uniDate'},
				 {name: 'DEPT_CODE'				,text:'<t:message code="system.label.sales.department" default="부서"/>'		,type:'string'},
	    		 {name: 'DVRY_DATE'       		,text:'<t:message code="system.label.sales.deliverydate" default="납기일"/>'		,type:'uniDate'},
	    		 {name: 'DVRY_TIME'       		,text:'<t:message code="system.label.sales.deliverytime" default="납기시간"/>'		,type:'string'},
	    		 {name: 'ORDER_UNIT_Q'    		,text:'<t:message code="system.label.sales.soqty" default="수주량"/>'		,type:'uniQty'},
	    		 {name: 'ISSUE_REQ_Q'     		,text:'<t:message code="system.label.sales.shipmentorderqty" default="출하지시량"/>'		,type:'uniQty'},
	    		 {name: 'OUTSTOCK_Q'      		,text:'<t:message code="system.label.sales.issueqty" default="출고량"/>'		,type:'uniQty'},
	    		 {name: 'RETURN_Q'        		,text:'<t:message code="system.label.sales.returnqty" default="반품량"/>'		,type:'uniQty'},
	    		 {name: 'SALE_Q'          		,text:'<t:message code="system.label.sales.salesqty" default="매출량"/>'		,type:'uniQty'},
	    		 {name: 'STOCK_UNIT'      		,text:'<t:message code="system.label.sales.inventoryunit" default="재고단위"/>'		,type:'string', displayField: 'value'},
	    		 {name: 'STOCK_Q'         		,text:'재고단위수주량'	,type:'string'},
	    		 {name: 'ORDER_TYPE'      		,text:'<t:message code="system.label.sales.sellingtype" default="판매유형"/>'		,type:'string', comboType:"AU", comboCode:"S002"},
	    		 {name: 'ORDER_TYPE_NM'   		,text:'판매유형CD'		,type:'string'},
	    		 {name: 'ORDER_PRSN'      		,text:'<t:message code="system.label.sales.salescharge" default="영업담당"/>'		,type:'string', comboType:"AU", comboCode:"S010"},
	    		 {name: 'ORDER_PRSN_NM'   		,text:'영업담당CD'		,type:'string'},
	    		 {name: 'ORDER_NUM'       		,text:'<t:message code="system.label.sales.sono" default="수주번호"/>'		,type:'string'},
	    		 {name: 'SER_NO'          		,text:'<t:message code="system.label.sales.seq" default="순번"/>'			,type:'integer'},
	    		 {name: 'PROJECT_NO'       		,text:'<t:message code="system.label.sales.projectno" default="프로젝트번호"/>'	,type:'string'},
	    		 {name: 'ORDER_STATUS'    		,text:'마감여부CD'		,type:'string'},
	    		 {name: 'STATUS'          		,text:'상태'			,type:'string', comboType:"AU", comboCode:"S046"},
	    		 {name: 'ORDER_STATUS_NM' 		,text:'<t:message code="system.label.sales.closingyn" default="마감여부"/>'		,type:'string'},
	    		 {name: 'REMARK'          		,text:'<t:message code="system.label.sales.remarks" default="비고"/>'			,type:'string'},
	    		 {name: 'SORT_KEY'		 		,text:'SORTKEY'		,type:'string'}	    			
			]
	});	
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore1 = Unilite.createStore('sof300skrvMasterStore1',{
			model: 'Sof300skrvModel',
			uniOpt : {
            	isMaster: true,			// 상위 버튼 연결 
            	editable: false,			// 수정 모드 사용 
            	deletable:false,			// 삭제 가능 여부 
	            useNavi : false			// prev | next 버튼 사용
	            	//비고(*) 사용않함
            },
            autoLoad: false,
            proxy: {
                type: 'direct',
                api: {			
                	   read: 'sof300skrvService.selectList'                	
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
			groupField: 'CUSTOM_NAME',
			listeners:{
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
			layout : {type : 'vbox', align : 'stretch'},
        	items : [{	
        		xtype:'container',
        		layout: {type : 'uniTable', columns : 1},
        		items:[{
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
				    xtype: 'uniDateRangefield',
				    startFieldName: 'ORDER_DATE_FR',
				    endFieldName: 'ORDER_DATE_TO',
				    startDate: UniDate.get('startOfMonth'),
				    endDate: UniDate.get('today'),
				    width:315,                	
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
				},
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
/*			   Unilite.popup('DEPT', { 
				   		fieldLabel: '<t:message code="system.label.sales.department" default="부서"/>', 
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
				     		onClear: function(type) {
				        		panelResult.setValue('DEPT_CODE', '');
				        		panelResult.setValue('DEPT_NAME', '');
				     		},
				     		applyextparam: function(popup){							
								var authoInfo = pgmInfo.authoUser;				//권한정보(N-전체,A-자기사업장>5-자기부서)
								var deptCode = UserInfo.deptCode;	//부서정보
								var divCode = '';					//사업장
								
								if(authoInfo == "A"){	
									popup.setExtParam({'DEPT_CODE': ""});
									popup.setExtParam({'DIV_CODE': UserInfo.divCode});
									
								}else if(authoInfo == "N" || Ext.isEmpty(authoInfo)){	//전체권한
									popup.setExtParam({'DEPT_CODE': ""});
									popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
									
								}else if(authoInfo == "5"){		//부서권한
									popup.setExtParam({'DEPT_CODE': deptCode});
									popup.setExtParam({'DIV_CODE': UserInfo.divCode});
								}
							}
				    	}
						
			   })*/
			   , 
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
					fieldLabel: '<t:message code="system.label.sales.item" default="품목"/>',
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
				})]	
        	 }]
		}, {			
			title:'<t:message code="system.label.sales.additionalinfo" default="추가정보"/>',
			id: 'search_panel2',
			itemId:'search_panel2',
	    	defaultType: 'uniTextfield',
	    	layout: {type: 'uniTable', columns: 1},
			items:[{
        		xtype: 'container',
        		defaultType: 'uniTextfield',
        		layout: {type: 'uniTable', columns: 1},
        		id : 'AdvanceSerch',
        		items: [{
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
        		} ,{
        			fieldLabel: '<t:message code="system.label.sales.issueqty" default="출고량"/>',
        			name:'FR_OUT_STOCK',
        			suffixTpl:'&nbsp;이상'
        		}, {
        			fieldLabel: '<t:message code="system.label.sales.customclass" default="거래처분류"/>',
        			name:'AGENT_TYPE',
        			xtype: 'uniCombobox',
        			comboType:'AU',
        			comboCode:'B055'
        		}, {
        			fieldLabel: '~',
        			name:'TO_OUT_STOCK' ,
        			suffixTpl:'&nbsp;이하'
        		}, {
        			fieldLabel: '<t:message code="system.label.sales.area" default="지역"/>',
        			name:'AREA_TYPE',
        			xtype: 'uniCombobox',
        			comboType:'AU',
        			comboCode:'B056'
        		}, {
        			fieldLabel: '<t:message code="system.label.sales.majorgroup" default="대분류"/>',
        			name: 'ITEM_LEVEL1' ,
        			xtype: 'uniCombobox' ,
        			store: Ext.data.StoreManager.lookup('itemLeve1Store'),
        			child: 'TXTLV_L2'
        		}, { 
        			fieldLabel: '<t:message code="system.label.sales.middlegroup" default="중분류"/>',
        			name: 'ITEM_LEVEL2' ,
        			xtype: 'uniCombobox' ,
        			store: Ext.data.StoreManager.lookup('itemLeve2Store'),
        			child: 'TXTLV_L3'
        		}, {
        			fieldLabel: '<t:message code="system.label.sales.minorgroup" default="소분류"/>',
        			name: 'ITEM_LEVEL3' ,
        			xtype: 'uniCombobox' ,
        			store: Ext.data.StoreManager.lookup('itemLeve3Store'),
        			colspan: 2, 
					parentNames:['ITEM_LEVEL1','ITEM_LEVEL2'],
		            levelType:'ITEM'
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
        	  		xtype: 'radiogroup',		            		
				    fieldLabel: '상태(임시)',						            		
				    id: 'rdoSelect',						            		
				    items : [{
				    	boxLabel: '<t:message code="system.label.sales.whole" default="전체"/>',
				    	width: 50,
				    	name: 'rdoSelect',
				    	inputValue: 'A',
				    	checked: true
				    } ,{
				    	boxLabel: '미승인',
				    	width: 60,
				    	name: 'rdoSelect',
				    	inputValue: 'N'
				    } ,{
				    	boxLabel: '승인(완료)',
				    	width: 80,
				    	name: 'rdoSelect' ,
				    	inputValue: '6'
				    } ,{
				    	boxLabel: '반려',
				    	width: 50,
				    	name: 'rdoSelect' ,
				    	inputValue: '5'
				    }]
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
				change: function(combo, newValue, oldValue, eOpts) {	
					combo.changeDivCode(combo, newValue, oldValue, eOpts);
					panelSearch.setValue('DIV_CODE', newValue);
				}
			}
		},{
			fieldLabel: '<t:message code="system.label.sales.sodate" default="수주일"/>',
		    xtype: 'uniDateRangefield',
		    startFieldName: 'ORDER_DATE_FR',
		    endFieldName: 'ORDER_DATE_TO',
		    startDate: UniDate.get('startOfMonth'),
		    endDate: UniDate.get('today'),
		    width:315,                	
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
		},
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

/*		Unilite.popup('DEPT', { 
		   		fieldLabel: '<t:message code="system.label.sales.department" default="부서"/>', 
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
		     		onClear: function(type) {
		        		panelSearch.setValue('DEPT_CODE', '');
		        		panelSearch.setValue('DEPT_NAME', '');
		     		},
					applyextparam: function(popup){							
						var authoInfo = pgmInfo.authoUser;				//권한정보(N-전체,A-자기사업장>5-자기부서)
						var deptCode = UserInfo.deptCode;	//부서정보
						var divCode = '';					//사업장
						
						if(authoInfo == "A"){	
							popup.setExtParam({'DEPT_CODE': ""});
							popup.setExtParam({'DIV_CODE': UserInfo.divCode});
							
						}else if(authoInfo == "N" || Ext.isEmpty(authoInfo)){	//전체권한
							popup.setExtParam({'DEPT_CODE': ""});
							popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
							
						}else if(authoInfo == "5"){		//부서권한
							popup.setExtParam({'DEPT_CODE': deptCode});
							popup.setExtParam({'DIV_CODE': UserInfo.divCode});
						}
					}
		    	}
	   })*/
		, 
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
			fieldLabel: '<t:message code="system.label.sales.item" default="품목"/>',
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
		})]	
	});

	
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    
    var masterGrid = Unilite.createGrid('sof300skrvGrid1', {
    	// for tab    	
        layout : 'fit',
        region: 'center',
        uniOpt:{
         expandLastColumn: false
        },
        features: [ {id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false },
    	           	{id : 'masterGridTotal', 	ftype: 'uniSummary', 	  showSummaryRow: false} ],
    	store: directMasterStore1,
        columns:  [  { dataIndex: 'CUSTOM_CODE'     			,      		width: 100, hidden:true, locked:true  }, 				
					 { dataIndex: 'CUSTOM_NAME'     			,      		width: 133, locked:true,
						summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
		              	return Unilite.renderSummaryRow(summaryData, metaData, '거래처계', '<t:message code="system.label.sales.total" default="총계"/>');
                    }}, 				
					 { dataIndex: 'ITEM_CODE'       			,      		width: 120, locked:true  }, 				
					 { dataIndex: 'ITEM_NAME'       			,      		width: 200, locked:true  }, 				
					 { dataIndex: 'SPEC'            			,      		width: 133  }, 				
					 { dataIndex: 'ORDER_UNIT'      			,      		width: 58, align:'center'  }, 				
					 { dataIndex: 'TRANS_RATE'      			,      		width: 60, align:'right'  }, 				
					 { dataIndex: 'ORDER_DATE'      			,      		width: 86  }, 				
					 { dataIndex: 'DVRY_DATE'       			,      		width: 86  }, 				
					 { dataIndex: 'DVRY_TIME'       			,      		width: 60, hidden:true  }, 				
					 { dataIndex: 'ORDER_UNIT_Q'    			,      		width: 80, summaryType:'sum'  }, 				
					 { dataIndex: 'ISSUE_REQ_Q'     			,      		width: 100, summaryType:'sum'  },				
					 { dataIndex: 'OUTSTOCK_Q'      			,      		width: 80, summaryType:'sum'  }, 				
					 { dataIndex: 'RETURN_Q'        			,      		width: 80, summaryType:'sum'  }, 				
					 { dataIndex: 'SALE_Q'          			,      		width: 80, summaryType:'sum'  }, 				
					 { dataIndex: 'STOCK_UNIT'      			,      		width: 66, hidden:true  }, 				
					 { dataIndex: 'STOCK_Q'         			,      		width: 106, hidden:true  }, 				
					 { dataIndex: 'ORDER_TYPE_NM'      			,      		width: 66, hidden:true  }, 				
					 { dataIndex: 'ORDER_TYPE'   				,      		width: 133  }, 				
					 { dataIndex: 'ORDER_PRSN_NM'      			,      		width: 66, hidden:true  }, 				
					 { dataIndex: 'ORDER_PRSN'   				,      		width: 133  }, 				
					 { dataIndex: 'ORDER_NUM'       			,      		width: 100  }, 				
					 { dataIndex: 'SER_NO'          			,      		width: 66, align:'center'  }, 	
					 { dataIndex: 'PROJECT_NO'       			,      		width: 100  }, 
					 { dataIndex: 'ORDER_STATUS'    			,      		width: 100, hidden:true  }, 				
					 { dataIndex: 'STATUS'          			,      		width: 66  }, 				
					 { dataIndex: 'ORDER_STATUS_NM' 			,      		width: 66  }, 				
					 { dataIndex: 'REMARK'          			,      		width: 200  }, 				
					 { dataIndex: 'SORT_KEY'		 			,      		width: 133, hidden:true  } 				

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
		id  : 'sof300skrvApp',
		fnInitBinding : function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			panelSearch.setValue('DEPT_CODE',UserInfo.deptCode);
			panelSearch.setValue('DEPT_NAME',UserInfo.deptName);
			panelSearch.setValue('ORDER_DATE_TO', UniDate.get('today'));
			panelSearch.setValue('ORDER_DATE_FR', UniDate.get('startOfMonth', panelSearch.getValue('ORDER_DATE_TO')));
			
			panelResult.setValue('DIV_CODE',UserInfo.divCode);
			panelResult.setValue('DEPT_CODE',UserInfo.deptCode);
			panelResult.setValue('DEPT_NAME',UserInfo.deptName);
			panelResult.setValue('ORDER_DATE_TO', UniDate.get('today'));
			panelResult.setValue('ORDER_DATE_FR', UniDate.get('startOfMonth', panelSearch.getValue('ORDER_DATE_TO')));
			
			var field = panelSearch.getField('ORDER_PRSN');
			field.fireEvent('changedivcode', field, UserInfo.divCode, null, null, "DIV_CODE");
		},
		onQueryButtonDown : function()	{			
			if(!panelSearch.setAllFieldsReadOnly(true)){
	    		return false;
	    	}
			masterGrid.reset();
			masterGrid.getStore().loadStoreRecords();
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
			masterGrid.getStore().loadData({})
			this.fnInitBinding();
			
		}
	});
};
</script>