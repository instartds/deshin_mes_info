<%--
'   프로그램명 : 작업지시 일괄마감 (생산)
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
<t:appConfig pgmId="pmp181ukrv"  >
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->  
	<t:ExtComboStore items="${COMBO_WS_LIST}" storeId="wsList" /> <!-- 작업장 --> 
	<t:ExtComboStore comboType="AU" comboCode="P001"  /> <!-- 상태 -->
	<t:ExtComboStore comboType="AU" comboCode="P113"  /> <!-- 공정여부 -->
	<t:ExtComboStore comboType="WU" />        <!-- 작업장-->
	
</t:appConfig>

<script type="text/javascript" >

var SearchInfoWindow;	//
var BsaCodeInfo = {
};
var cgWorkShopCode ='';
var searchOrderWindow;


function appMain() {
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read:		'pmp181ukrvService.selectDetailList',
			update:		'pmp181ukrvService.updateDetail',
			syncAll:	'pmp181ukrvService.saveAll'
		}
	});
	
	var panelSearch = Unilite.createSearchPanel('pmp181ukrvpanelSearch', {
		title: '<t:message code="system.label.product.searchconditon" default="검색조건"/>',
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
			title: '<t:message code="system.label.product.basisinfo" default="기본정보"/>', 	
   			itemId: 'search_panel1',
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',
		    items: [{
		        fieldLabel: '<t:message code="system.label.product.division" default="사업장"/>',
		        name:'DIV_CODE', 
		        xtype: 'uniCombobox', 
		        comboType:'BOR120' ,
		        allowBlank:false,
		        value:UserInfo.divCode,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('DIV_CODE', newValue);
						panelSearch.setValue('WORK_SHOP_CODE','');
					}
				}
			},{
				fieldLabel: '<t:message code="system.label.product.workcenter" default="작업장"/>',
				name: 'WORK_SHOP_CODE',
				xtype: 'uniCombobox',
				value: 'WC00',
				comboType: 'WU',
		 		allowBlank:false,
		 		listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('WORK_SHOP_CODE', newValue);
					},
                    beforequery:function( queryPlan, eOpts )   {
                        var store = queryPlan.combo.store;
                        var prStore = panelResult.getField('WORK_SHOP_CODE').store;
                        store.clearFilter();
                        prStore.clearFilter();
                        if(!Ext.isEmpty(panelSearch.getValue('DIV_CODE'))){
                            store.filterBy(function(record){
                                return record.get('option') == panelSearch.getValue('DIV_CODE');
                            });
                            prStore.filterBy(function(record){
                                return record.get('option') == panelSearch.getValue('DIV_CODE');
                            });
                        }else{
                            store.filterBy(function(record){
                                return false;   
                            });
                            prStore.filterBy(function(record){
                                return false;   
                            });
                        }
                    }
				}
			},{
				xtype: 'radiogroup',		            		
				fieldLabel: '<t:message code="system.label.product.status" default="상태"/>',
				items: [{
					boxLabel: '<t:message code="system.label.product.whole" default="전체"/>', 
					width: 70, 
					name: 'STATUS_CODE',
					inputValue: '',
					checked: true 
				},{
					boxLabel : '<t:message code="system.label.product.process" default="진행"/>', 
					width: 70,
					name: 'STATUS_CODE',
					inputValue: '2'
				},{
					boxLabel : '완료', 
					width: 70,
					name: 'STATUS_CODE',
					inputValue: '9'
				},{
					boxLabel: '<t:message code="system.label.product.closing" default="마감"/>', 
					width: 70, 
					name: 'STATUS_CODE',
					inputValue: '8'
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.getField('STATUS_CODE').setValue(newValue.STATUS_CODE);
						
						UniAppManager.app.onQueryButtonDown();
					}
				}
			},{
				xtype: 'radiogroup',		            		
				fieldLabel: '<t:message code="system.label.product.subcontractyn" default="외주여부"/>',						            		
				items: [{
					boxLabel: '<t:message code="system.label.product.yes" default="예"/>', 
					width: 70, 
					name: 'OUT_ORDER_YN',
					inputValue: 'Y'
				},{
					boxLabel : '<t:message code="system.label.product.no" default="아니오"/>', 
					width: 80,
					name: 'OUT_ORDER_YN',
					inputValue: 'N',
					checked: true 
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.getField('OUT_ORDER_YN').setValue(newValue.OUT_ORDER_YN);
						
						UniAppManager.app.onQueryButtonDown();
					}
				}
			},{ 
	        	fieldLabel: '<t:message code="system.label.product.completiondate" default="완료예정일"/>',
				xtype: 'uniDateRangefield',  
				startFieldName: 'PRODT_END_DATE_FR',
				endFieldName: 'PRODT_END_DATE_TO',
				startDate: UniDate.get('startOfMonth'),
				endDate: UniDate.get('endOfMonth'),
				width: 315,
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
	        	if(panelResult) {
					panelResult.setValue('PRODT_END_DATE_FR',newValue);
	        		}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelResult) {
			    		panelResult.setValue('PRODT_END_DATE_TO',newValue);
			    	}
				}
		    }]
		},{
			title: '<t:message code="system.label.product.additionalsearch" default="추가검색"/>',	
   			itemId: 'search_panel2',
//   			collapsed: true,
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',
		    items: [{
				xtype: 'container',
				layout: {type : 'uniTable', columns : 3},
				width:600,
				items :[{
					fieldLabel:'<t:message code="system.label.product.workorderno" default="작업지시번호"/>', 
					xtype: 'uniTextfield',
					name: 'WKORD_NUM_FR', 
					width:210
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
					name: 'WKORD_NUM_TO', 
					width:120
				}]
			},
				Unilite.popup('ITEM',{ 
					fieldLabel: '<t:message code="system.label.product.item" default="품목"/>', 
					validateBlank:false,
					textFieldName: 'ITEM_NAME',
					valueFieldName: 'ITEM_CODE'
			}),				
				Unilite.popup('CUST',{ 
					fieldLabel: '<t:message code="system.label.product.custom" default="거래처"/>', 
					valueFieldName: 'CUSTOM_CODE', 
					textFieldName: 'CUSTOM_NAME',
					validateBlank:false
			}),{ 
	        	fieldLabel: '<t:message code="system.label.product.deliverydate" default="납기일"/>',
				xtype: 'uniDateRangefield',  
				startFieldName: 'DVRY_DATE_FR',
				endFieldName: 'DVRY_DATE_TO',
				startDate: UniDate.get(''),
				endDate: UniDate.get(''),
				width: 315,
				textFieldWidth:170
			},{ 
	        	fieldLabel: '<t:message code="system.label.product.sodate" default="수주일"/>',
				xtype: 'uniDateRangefield',  
				startFieldName: 'ORDER_DATE_FR',
				endFieldName: 'ORDER_DATE_TO',
				startDate: UniDate.get(''),
				endDate: UniDate.get(''),
				width: 315,
				textFieldWidth:170
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
					Unilite.messageBox(labelText+Msg.sMB083);
		        	invalid.items[0].focus();
		     	} else {
		      		//this.mask();
		      		var fields = this.getForm().getFields();
		      		Ext.each(fields.items, function(item) {
		       			if(Ext.isDefined(item.holdable) ) {
		         			if (item.holdable == 'hold') {
		         				item.setReadOnly(true); 
		        			}
		       			} 
		       			if(item.isPopupField) {
		        			var popupFC = item.up('uniPopupField') ;       
		        			if(popupFC.holdable == 'hold') {
		         				popupFC.setReadOnly(true);
		        			}
		       			}
		      		})
		       	}
		    } else {
		    	//this.unmask();
		       	var fields = this.getForm().getFields();
		     	Ext.each(fields.items, function(item) {
		      		if(Ext.isDefined(item.holdable) ) {
		        		if (item.holdable == 'hold') {
		        			item.setReadOnly(false);
		       			}
		      		} 
		      		if(item.isPopupField) {
		       			var popupFC = item.up('uniPopupField') ; 
		       			if(popupFC.holdable == 'hold' ) {
		        			item.setReadOnly(false);
		      			}
		      		}
		     	})
		    }
		    return r;
		},
		setLoadRecord: function(record) {
			var me = this;   
		   	me.uniOpt.inLoading=false;
		    me.setAllFieldsReadOnly(true);
		}
	}); 
	
	var panelResult = Unilite.createSearchForm('resultForm',{
    	region: 'north',
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
		items: [{
	        fieldLabel: '<t:message code="system.label.product.division" default="사업장"/>',
	        name:'DIV_CODE', 
	        xtype: 'uniCombobox', 
	        comboType:'BOR120' ,
	        allowBlank:false,
	        value:UserInfo.divCode,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('DIV_CODE', newValue);
					panelResult.setValue('WORK_SHOP_CODE','');
				}
			}
		},{
			fieldLabel: '<t:message code="system.label.product.workcenter" default="작업장"/>',
			name: 'WORK_SHOP_CODE',
			xtype: 'uniCombobox',
				value: 'WC00',
				comboType: 'WU',
	 		allowBlank:false,
	 		colspan:2,
	 		listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('WORK_SHOP_CODE', newValue);
				},
                beforequery:function( queryPlan, eOpts )   {
                    var store = queryPlan.combo.store;
                    var prStore = panelSearch.getField('WORK_SHOP_CODE').store;
                    store.clearFilter();
                    prStore.clearFilter();
                    if(!Ext.isEmpty(panelResult.getValue('DIV_CODE'))){
                        store.filterBy(function(record){
                            return record.get('option') == panelResult.getValue('DIV_CODE');
                        });
                        prStore.filterBy(function(record){
                            return record.get('option') == panelResult.getValue('DIV_CODE');
                        });
                    }else{
                        store.filterBy(function(record){
                            return false;   
                        });
                        prStore.filterBy(function(record){
                            return false;   
                        });
                    }
                }
			}
		},{
			xtype: 'radiogroup',		            		
			fieldLabel: '<t:message code="system.label.product.status" default="상태"/>',
			comboType: 'AU', 
			comboCode: 'P001',
			items: [{
				boxLabel: '<t:message code="system.label.product.whole" default="전체"/>', 
				width: 70, 
				name: 'STATUS_CODE',
				inputValue: '',
				checked: true 
			},{
				boxLabel : '<t:message code="system.label.product.process" default="진행"/>', 
				width: 70,
				name: 'STATUS_CODE',
				inputValue: '2'
			},{
				boxLabel : '완료', 
				width: 70,
				name: 'STATUS_CODE',
				inputValue: '9'
			},{
				boxLabel: '<t:message code="system.label.product.closing" default="마감"/>', 
				width: 70, 
				name: 'STATUS_CODE',
				inputValue: '8'
			}],
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.getField('STATUS_CODE').setValue(newValue.STATUS_CODE);
					
					UniAppManager.app.onQueryButtonDown();
				}
			}
		},{
			xtype: 'radiogroup',		            		
			fieldLabel: '<t:message code="system.label.product.subcontractyn" default="외주여부"/>',						            		
			items: [{
				boxLabel: '<t:message code="system.label.product.yes" default="예"/>', 
				width: 70, 
				name: 'OUT_ORDER_YN',
				inputValue: 'Y'
			},{
				boxLabel : '<t:message code="system.label.product.no" default="아니오"/>', 
				width: 80,
				name: 'OUT_ORDER_YN',
				inputValue: 'N',
				checked: true 
			}],
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.getField('OUT_ORDER_YN').setValue(newValue.OUT_ORDER_YN);
					
					UniAppManager.app.onQueryButtonDown();
				}
			}
		},{ 
        	fieldLabel: '<t:message code="system.label.product.completiondate" default="완료예정일"/>',
			xtype: 'uniDateRangefield',  
			startFieldName: 'PRODT_END_DATE_FR',
			endFieldName: 'PRODT_END_DATE_TO',
			startDate: UniDate.get('startOfMonth'),
			endDate: UniDate.get('endOfMonth'),
			width: 315,
			onStartDateChange: function(field, newValue, oldValue, eOpts) {
        	if(panelSearch) {
				panelSearch.setValue('PRODT_END_DATE_FR',newValue);
        		}
		    },
		    onEndDateChange: function(field, newValue, oldValue, eOpts) {
		    	if(panelSearch) {
		    		panelSearch.setValue('PRODT_END_DATE_TO',newValue);
		    	}
			}
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
					Unilite.messageBox(labelText+Msg.sMB083);
		        	invalid.items[0].focus();
		     	} else {
		      		//this.mask();
		      		var fields = this.getForm().getFields();
		      		Ext.each(fields.items, function(item) {
		       			if(Ext.isDefined(item.holdable) ) {
		         			if (item.holdable == 'hold') {
		         				item.setReadOnly(true); 
		        			}
		       			} 
		       			if(item.isPopupField) {
		        			var popupFC = item.up('uniPopupField') ;       
		        			if(popupFC.holdable == 'hold') {
		         				popupFC.setReadOnly(true);
		        			}
		       			}
		      		})
		       	}
		    } else {
		    	//this.unmask();
		       	var fields = this.getForm().getFields();
		     	Ext.each(fields.items, function(item) {
		      		if(Ext.isDefined(item.holdable) ) {
		        		if (item.holdable == 'hold') {
		        			item.setReadOnly(false);
		       			}
		      		} 
		      		if(item.isPopupField) {
		       			var popupFC = item.up('uniPopupField') ; 
		       			if(popupFC.holdable == 'hold' ) {
		        			item.setReadOnly(false);
		      			}
		      		}
		     	})
		    }
		    return r;
		},
		setLoadRecord: function(record) {
			var me = this;   
		   	me.uniOpt.inLoading=false;
		    me.setAllFieldsReadOnly(true);
		}	
    });
	
	/**
	 *   Model 정의 
	 * @type  
	 */
	Unilite.defineModel('pmp181ukrvDetailModel', {
	    fields: [  	 
	    	{name: 'COMP_CODE'        		,text: '<t:message code="system.label.product.compcode" default="법인코드"/>'			,type:'string'},
			{name: 'DIV_CODE'         		,text: '<t:message code="system.label.product.division" default="사업장"/>'			    ,type:'string'},
			{name: 'STATUS_CODE'     		,text: '<t:message code="system.label.product.status" default="상태"/>'			,type:'string' , comboType: 'AU', comboCode: 'P001'},
			{name: 'STATUS_NAME'       		,text: '<t:message code="system.label.product.status" default="상태"/>'			    ,type:'string'},
			{name: 'OUT_ORDER_YN'    		,text: '<t:message code="system.label.product.subcontractyn" default="외주여부"/>'			,type:'string' , comboType: 'AU', comboCode: 'P113'},
			{name: 'TOP_WKORD_NUM'   		,text: '<t:message code="system.label.product.wholeworkorderno" default="일괄작지번호"/>'	,type:'string'},
			{name: 'WKORD_NUM'       		,text: '<t:message code="system.label.product.workorderno" default="작업지시번호"/>'		,type:'string'},
			{name: 'ITEM_CODE'        		,text: '<t:message code="system.label.product.item" default="품목"/>'			,type:'string'},
			{name: 'ITEM_NAME'        		,text: '<t:message code="system.label.product.itemname" default="품목명"/>'			    ,type:'string'},
			{name: 'SPEC'            		,text: '<t:message code="system.label.product.spec" default="규격"/>'				,type:'string'},	
			{name: 'PRODT_START_DATE' 	 	,text: '<t:message code="system.label.product.plannedstartdate" default="착수예정일"/>'			,type:'uniDate'},
			{name: 'PRODT_END_DATE'	  		,text: '<t:message code="system.label.product.completiondate" default="완료예정일"/>'			,type:'uniDate'},
			
			{name: 'PRODT_PRSN'   		,text: '작업자'               	,type:'string', comboType:'AU', comboCode:'P505'},
			
			{name: 'WKORD_Q'           		,text: '<t:message code="system.label.product.workorderqty" default="작업지시량"/>'			,type:'uniQty'},
			{name: 'PRODT_Q'          		,text: '<t:message code="system.label.product.productionqty" default="생산량"/>'			    ,type:'uniQty'},
			{name: 'BAL_Q'           		,text: '<t:message code="system.label.product.balanceqty" default="잔량"/>'				,type:'uniQty'},	
			{name: 'PROG_UNIT'        	 	,text: '<t:message code="system.label.product.unit" default="단위"/>'				,type:'string'},
			{name: 'ORDER_NUM'         		,text: '<t:message code="system.label.product.sono" default="수주번호"/>'			,type:'string'},
			{name: 'SEQ'               		,text: '<t:message code="system.label.product.seq" default="순번"/>'				,type:'string'},
			{name: 'ORDER_Q'         		,text: '<t:message code="system.label.product.soqty" default="수주량"/>'			    ,type:'uniQty'},
			{name: 'PROD_Q'            		,text: '<t:message code="system.label.product.productionrequestqty" default="생산요청량"/>'			,type:'uniQty'},
			{name: 'DVRY_DATE'       		,text: '<t:message code="system.label.product.deliverydate" default="납기일"/>'			    ,type:'uniDate'},	
			{name: 'PROD_END_DATE'   		,text: '<t:message code="system.label.product.productionrequestdate" default="생산요청일"/>'			,type:'uniDate'},
			{name: 'CUSTOM_NAME'       		,text: '<t:message code="system.label.product.customname" default="거래처명"/>'			,type:'string'},
			{name: 'LOT_NO'          		,text: '<t:message code="system.label.product.lotno" default="LOT번호"/>'			    ,type:'string'},
			{name: 'REMARK'           		,text: '<t:message code="system.label.product.remarks" default="비고"/>'				,type:'string'},
			{name: 'PROJECT_NO'      		,text: '<t:message code="system.label.product.projectno" default="프로젝트번호"/>'		,type:'string'},	
			{name: 'PJT_CODE'         	 	,text: '<t:message code="system.label.product.projectno" default="프로젝트번호"/>'		,type:'string'},
			{name: 'ORDER_YN'          		,text: '<t:message code="system.label.product.orderstatus" default="오더상태"/>'			,type:'string'}
		]
	});
	
    // 검색 모델(디테일)
    Unilite.defineModel('orderNoDetailModel', {
        fields: [
             { name: 'DIV_CODE'     ,text:'<t:message code="unilite.msg.sMS631" default="사업장"/>'           ,type: 'string' ,comboType:'BOR120'}
            ,{ name: 'ITEM_CODE'    ,text:'<t:message code="unilite.msg.sMR004" default="품목코드"/>'       	,type: 'string' }
            ,{ name: 'ITEM_NAME'    ,text:'<t:message code="unilite.msg.sMR349" default="품명"/>'     		,type: 'string' }
            ,{ name: 'SPEC'         ,text:'<t:message code="unilite.msg.sMSR033" default="규격"/>'    		,type: 'string' }

            ,{ name: 'ORDER_DATE'   ,text:'<t:message code="unilite.msg.sMS122" default="수주일"/>'        	,type: 'uniDate'}
            ,{ name: 'DVRY_DATE'    ,text:'<t:message code="unilite.msg.sMS123" default="납기일"/>'        	,type: 'uniDate'}

            ,{ name: 'ORDER_Q'      ,text:'<t:message code="unilite.msg.sMS543" default="수주량"/>'        	,type: 'uniQty' }
            ,{ name: 'ORDER_TYPE'   ,text:'<t:message code="unilite.msg.sMS832" default="판매유형"/>'       	,type: 'string' ,comboType:'AU', comboCode:'S002'}
            ,{ name: 'ORDER_PRSN'   ,text:'<t:message code="unilite.msg.sMS669" default="수주담당"/>'       	,type: 'string' ,comboType:'AU', comboCode:'S010'}
            ,{ name: 'PO_NUM'       ,text:'<t:message code="unilite.msg.sMSR281" default="PO번호"/>'      	,type: 'string' }
            ,{ name: 'PROJECT_NO'   ,text:'<t:message code="unilite.msg.sMR161" default="프로젝트번호"/>'       	,type: 'string' }
            ,{ name: 'ORDER_NUM'    ,text:'<t:message code="unilite.msg.sMS533" default="수주번호"/>'       	,type: 'string' }
            ,{ name: 'SER_NO'       ,text:'<t:message code="unilite.msg.sMS783" default="수주순번"/>'       	,type: 'string' }
            ,{ name: 'CUSTOM_CODE'  ,text:'<t:message code="unilite.msg.sMSR213" default="거래처"/>'       	,type: 'string' }
            ,{ name: 'CUSTOM_NAME'  ,text:'<t:message code="unilite.msg.sMSR279" default="거래처명"/>'      	,type: 'string' }
            ,{ name: 'COMP_CODE'    ,text:'COMP_CODE'       ,type: 'string' }
            ,{ name: 'PJT_CODE'     ,text:'프로젝트코드'        	                                         		,type: 'string' }
            ,{ name: 'PJT_NAME'     ,text:'프로젝트'                                                        	,type: 'string' }
            ,{ name: 'FR_DATE'      ,text:'시작일'			                                                  	,type: 'string' }
            ,{ name: 'TO_DATE'      ,text:'종료일'         	                                              	,type: 'string' }
        ]
    });	
	  
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var detailStore = Unilite.createStore('pmp181ukrvDetailStore', {
		model: 'pmp181ukrvDetailModel',
		autoLoad: false,
		uniOpt: {
			isMaster: true,			// 상위 버튼 연결
			editable: true, 		// 수정 모드 사용   // temporarily false
			deletable: false,		// 삭제 가능 여부
			useNavi : false			// prev | next 버튼 사용
		},
		proxy: directProxy,
		loadStoreRecords: function() {
			var param= panelSearch.getValues();
			console.log(param);
			this.load({
				params : param
			});
		},
		saveStore: function() {				
			var inValidRecs = this.getInvalidRecords();
			console.log("inValidRecords : ", inValidRecs);

			var toCreate = this.getNewRecords();
       		var toUpdate = this.getUpdatedRecords();        		
       		var toDelete = this.getRemovedRecords();
       		var list = [].concat(toUpdate, toCreate);
			console.log("list:", list);

			console.log("this.data.filterBy(this.filterInvalidNewRecords).items : ", this.data.filterBy(this.filterInvalidNewRecords));
			
			//1. 마스터 정보 파라미터 구성
			var paramMaster= panelSearch.getValues();	//syncAll 수정
			
			if(inValidRecs.length == 0) {
				//if(config==null) {
					/* syncAll 수정
					 * config = {
							success: function() {
											detailForm.getForm().wasDirty = false;
											detailForm.resetDirtyStatus();
											console.log("set was dirty to false");
											UniAppManager.setToolbarButtons('save', false);						
									   } 
							  };*/
				config = {
					params: [paramMaster],
					success: function(batch, option) {
						panelSearch.getForm().wasDirty = false;
						panelSearch.resetDirtyStatus();
						console.log("set was dirty to false");
						UniAppManager.setToolbarButtons('save', false);		
						UniAppManager.app.onQueryButtonDown();
					} 
				};
				//}
				//this.syncAll(config);
				this.syncAllDirect(config);
			} else {
				var grid = Ext.getCmp('pmp181ukrvGrid');
				grid.uniSelectInvalidColumnAndAlert(inValidRecs);
				// alert(Msg.sMB083);
			}
		}
	});
	
 // 검색 스토어(디테일)
    var orderNoDetailStore = Unilite.createStore('orderNoDetailStore', {
        model: 'orderNoDetailModel',
        autoLoad: false,
        uniOpt: {
            isMaster: false, // 상위 버튼 연결
            editable: false, // 수정 모드 사용
            deletable: false, // 삭제 가능 여부
            useNavi: false // prev | newxt 버튼 사용
        },
        proxy: {
            type: 'direct',
            api: {
                read: 'sof100ukrvService.selectOrderNumDetailList'
            }
        },
        loadStoreRecords: function() {
            var param = orderNoSearch.getValues();
            var authoInfo = pgmInfo.authoUser; // 권한정보(N-전체,A-자기사업장>5-자기부서)
            var deptCode = UserInfo.deptCode; // 부서코드
            if (authoInfo == "5" && Ext.isEmpty(orderNoSearch.getValue('DEPT_CODE'))) {
                param.DEPT_CODE = deptCode;
            }
            var outdivCode = panelResult.getValue('DIV_CODE'); //수주검색에 출고사업장 조건 추가
            param.OUT_DIV_CODE = outdivCode;

            console.log(param);
            this.load({
                params: param
            });
        }
    });		
	
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    var detailGrid = Unilite.createGrid('pmp181ukrvGrid', {
    	layout: 'fit',
        region:'center',
        uniOpt: {
			expandLastColumn: false,
			useRowNumberer: true,
			onLoadSelectFirst : true,
			useGroupSummary: false,
			useLiveSearch: true,
			useContextMenu: true,
    		filter: {
				useFilter: true,
				autoCreate: true
			},			
			
			copiedRow: true			
        },

    	store: detailStore,
    	selModel: 'rowmodel',
	    features: [ {id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: true },
    	           	{id : 'masterGridTotal', 	ftype: 'uniSummary', 	  showSummaryRow: true} ],    
        columns: [        		
			{dataIndex: 'COMP_CODE'         	, width: 100 , hidden : true}, 							
			{dataIndex: 'DIV_CODE'           	, width: 100 , hidden : true}, 								
			{dataIndex: 'STATUS_CODE'      		, width: 66  , locked : true}, 												
			{dataIndex: 'STATUS_NAME'       	, width: 66  , hidden : true},
			{dataIndex: 'OUT_ORDER_YN'    		, width: 66  , locked : true},
			{dataIndex: 'TOP_WKORD_NUM'     	, width: 120 , locked : true}, 							
			{dataIndex: 'WKORD_NUM'         	, width: 120 , locked : true,
        		summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
			       return Unilite.renderSummaryRow(summaryData, metaData, '<t:message code="system.label.purchase.subtotal" default="소계"/>', '<t:message code="system.label.purchase.total" default="총계"/>');
            	}
            }, 							
			{dataIndex: 'ITEM_CODE'          	, width: 100}, 								
			{dataIndex: 'ITEM_NAME'        		, width: 133}, 												
			{dataIndex: 'SPEC'              	, width: 133},
			{dataIndex: 'PRODT_START_DATE'		, width: 86}, 		
			{dataIndex: 'PRODT_END_DATE'	   	, width: 86}, 				
			
			{dataIndex: 'PRODT_PRSN'           	, width: 80 },
			
			{dataIndex: 'WKORD_Q'           	, width: 100 , summaryType: 'sum'}, 							
			{dataIndex: 'PRODT_Q'            	, width: 80 , summaryType: 'sum'}, 								
			{dataIndex: 'BAL_Q'            		, width: 80 , summaryType: 'sum'}, 												
			{dataIndex: 'PROG_UNIT'         	, width: 53 , align:'center'},
			{dataIndex: 'ORDER_NUM'       		, width: 100}, 		
			{dataIndex: 'SEQ'               	, width: 53 , align:'center'}, 							
			{dataIndex: 'ORDER_Q'           	, width: 100 }, 							
			{dataIndex: 'PROD_Q'             	, width: 100}, 								
			{dataIndex: 'DVRY_DATE'        		, width: 100}, 												
			{dataIndex: 'PROD_END_DATE'     	, width: 100},
			{dataIndex: 'CUSTOM_NAME'     		, width: 133}, 		
			{dataIndex: 'LOT_NO'            	, width: 100}, 							
			{dataIndex: 'REMARK'            	, width: 200}, 							
			{dataIndex: 'PROJECT_NO'         	, width: 100}, 								
//			{dataIndex: 'PJT_CODE'         		, width: 100}, 												
			{dataIndex: 'ORDER_YN'          	, width: 66 , hidden: true}
		],
		listeners: {
			beforeedit  : function( editor, e, eOpts ) {
      		if(e.record.phantom || !e.record.phantom)	{
					if (UniUtils.indexOf(e.field, 
											['COMP_CODE','DIV_CODE','STATUS_CODE','STATUS_NAME','OUT_ORDER_YN','TOP_WKORD_NUM',
											 'WKORD_NUM','ITEM_CODE','ITEM_NAME','SPEC','PRODT_START_DATE','PRODT_END_DATE','WKORD_Q',
											 'PRODT_Q','BAL_Q','PROG_UNIT','ORDER_NUM','SEQ','ORDER_Q','PROD_Q','DVRY_DATE','PROD_END_DATE',
											 'CUSTOM_NAME','LOT_NO','REMARK','PROJECT_NO','PJT_CODE','ORDER_YN']))
							return false;
				}
			}, 
            onGridDblClick: function(grid, record, cellIndex, colName) {
//			                    	 if(Ext.isEmpty(record.get("ORDER_NUM"))){
			                         openSearchOrderWindow();
//			                    	 } 			                    	 

            }   			
       	},
		disabledLinkButtons: function(b) {
		}
    });
  
      var orderNoDetailGrid = Unilite.createGrid('sof100ukrvOrderNoDetailGrid', {
        layout: 'fit',
        store: orderNoDetailStore,
        uniOpt: {
            useRowNumberer: false
        },
        columns: [
        	 { dataIndex: 'DIV_CODE'			,  width: 80 }
            ,{ dataIndex: 'ITEM_CODE'			,  width: 120 }
            ,{ dataIndex: 'ITEM_NAME'			,  width: 150 }
            ,{ dataIndex: 'SPEC'				,  width: 150 }
            ,{ dataIndex: 'ORDER_DATE'			,  width: 80 }
            ,{ dataIndex: 'DVRY_DATE'			,  width: 80 		,hidden:true}
            ,{ dataIndex: 'ORDER_Q'				,  width: 80 }
            ,{ dataIndex: 'ORDER_TYPE'			,  width: 90 }
            ,{ dataIndex: 'ORDER_PRSN'			,  width: 90 		,hidden:true}
            ,{ dataIndex: 'PO_NUM'				,  width: 100 }
            ,{ dataIndex: 'PROJECT_NO'			,  width: 90 }
            ,{ dataIndex: 'ORDER_NUM'			,  width: 120 }
            ,{ dataIndex: 'SER_NO'				,  width: 70 		,hidden:true}
            ,{ dataIndex: 'CUSTOM_CODE'			,  width: 120	 	,hidden:true}
            ,{ dataIndex: 'CUSTOM_NAME'			,  width: 200 }
            ,{ dataIndex: 'COMP_CODE'			,  width: 80 		,hidden:true}
            ,{ dataIndex: 'PJT_CODE'			,  width: 120 		,hidden:true}
            ,{ dataIndex: 'PJT_NAME'			,  width: 200 }
            ,{ dataIndex: 'FR_DATE'				,  width: 80	 	,hidden:true}
            ,{ dataIndex: 'TO_DATE'				,  width: 80 		,hidden:true}
        ],
        listeners: {
            onGridDblClick: function(grid, record, cellIndex, colName) {
			    orderNoDetailGrid.returnData(record)	     
				searchOrderWindow.hide();
            }
        } ,
        returnData: function(record) {
            if (Ext.isEmpty(record)) {
                record = this.getSelectedRecord();
            }
            var param= {
                'DIV_CODE': panelResult.getValue('DIV_CODE'),
                'ORDER_NUM': record.get('ORDER_NUM'),
                'SER_NO': record.get('SER_NO')
            }
            
            var grdRecord = detailGrid.uniOpt.currentRecord;
            
   			pmp181ukrvService.fnPmp100tCheck(param, function(provider, response) {
				if(!Ext.isEmpty(provider)){
					if(!Ext.isEmpty(provider[0].WKORD_NUM)){
						var swkordNum = provider[0].WKORD_NUM;
						Ext.MessageBox.show({
							msg : '이미 타 작업지시정보(' + swkordNum  + ')에 수주번호가 등록되어 있습니다. 그래도 계속 진행하시겠습니까?' ,
							icon: Ext.Msg.WARNING,
							buttons : Ext.MessageBox.OKCANCEL,
							fn : function(buttonId) {
								switch (buttonId) {
									case 'ok' :									
										grdRecord.set('ORDER_NUM',record.get('ORDER_NUM'));   
										grdRecord.set('SEQ',record.get('SER_NO'));
										break;
									case 'cancel' :
										grdRecord.set('ORDER_NUM','');   
										grdRecord.set('SEQ',0);									
										break;
								}
							},
							scope : this
						}); // MessageBox
						}
					
				}else{
						grdRecord.set('ORDER_NUM',record.get('ORDER_NUM'));   
						grdRecord.set('SEQ',record.get('SER_NO'));					
						
					}
			});            

        }
    });
      
    function openSearchOrderWindow() {
        if (!searchOrderWindow) {
            searchOrderWindow = Ext.create('widget.uniDetailWindow', {
                title: '수주번호검색',
                width: 1000,
                height: 580,
                layout: {
                    type: 'vbox',
                    align: 'stretch'
                },
                items: [orderNoSearch, orderNoDetailGrid],
                tbar: [
                       '->',{
                    itemId: 'searchBtn',
                    text: '조회',
                    handler: function() {
                        orderNoDetailStore.loadStoreRecords();
                    },
                    disabled: false
                }, {
                    itemId: 'closeBtn',
                    text: '닫기',
                    handler: function() {
                        searchOrderWindow.hide();
                    },
                    disabled: false
                }],
                listeners: {
                    beforehide: function(me, eOpt) {
                        orderNoSearch.clearForm();
                        orderNoDetailGrid.reset();
                        orderNoDetailStore.clearData();
                    },
                    beforeclose: function(panel, eOpts) {
                    },
                    show: function(panel, eOpts) {
                    	orderNoSearch.setValue('DIV_CODE', panelResult.getValue('DIV_CODE'));
                    	orderNoSearch.setValue('FR_ORDER_DATE', UniDate.get('startOfMonth'));
                    	orderNoSearch.setValue('TO_ORDER_DATE', UniDate.get('today'));
                    }
                }
            })
        }
        searchOrderWindow.center();
        searchOrderWindow.show();
    }
    
	var orderNoSearch = Unilite.createSearchForm('orderNoSearchForm', {
	    layout: {
	        type: 'uniTable',
	        columns: 3
	    },
	    trackResetOnLoad: true,
	    items: [{
	            fieldLabel: '<t:message code="unilite.msg.sMS631" default="사업장"/>',
	            name: 'DIV_CODE',
	            xtype: 'uniCombobox',
	            comboType: 'BOR120',
	            value: UserInfo.divCode,
	            allowBlank: false,
	            listeners: {
	                change: function(combo, newValue, oldValue, eOpts) {
	                    combo.changeDivCode(combo, newValue, oldValue, eOpts);
	                    var field = orderNoSearch.getField('ORDER_PRSN');
	                    field.fireEvent('changedivcode', field, newValue, oldValue, eOpts); // panelResult의
	                    // 필터링
	                    // 처리
	                    // 위해..
	                }
	            }
	        }, {
	            fieldLabel: '<t:message code="unilite.msg.sMS122" default="수주일"/>',
	            xtype: 'uniDateRangefield',
	            startFieldName: 'FR_ORDER_DATE',
	            endFieldName: 'TO_ORDER_DATE',
	            width: 350,
	            startDate: UniDate.get('startOfMonth'),
	            endDate: UniDate.get('today'),
	            colspan: 2
	        }, {
	            fieldLabel: '<t:message code="unilite.msg.sMS573" default="sMS669"/>',
	            name: 'ORDER_PRSN',
	            xtype: 'uniCombobox',
	            comboType: 'AU',
	            comboCode: 'S010',
	            onChangeDivCode: function(combo, newValue, oldValue, eOpts, divCode) {
	                if (eOpts) {
	                    combo.filterByRefCode('refCode1', newValue, eOpts.parent);
	                } else {
	                    combo.divFilterByRefCode('refCode1', newValue, divCode);
	                }
	            }
	        },
	        Unilite.popup('AGENT_CUST', {
	            fieldLabel: '<t:message code="unilite.msg.sMSR213" default="거래처"/>',
	            validateBlank: false,
	            colspan: 2,
	            listeners: {
	                applyextparam: function(popup) {
	                    popup.setExtParam({
	                        'AGENT_CUST_FILTER': ['1', '3']
	                    });
	                    popup.setExtParam({
	                        'CUSTOM_TYPE': ['1', '3']
	                    });
	                }
	            }
	        }),
	        // Unilite.popup('AGENT_CUST',{fieldLabel:'프로젝트' , valueFieldName:'PROJECT_NO',
	        // textFieldName:'PROJECT_NAME', validateBlank: false}),
	        Unilite.popup('DIV_PUMOK', {
	            colspan: 2,
	            listeners: {
	                applyextparam: function(popup) {
	                    popup.setExtParam({
	                        'DIV_CODE': orderNoSearch.getValue('DIV_CODE')
	                    });
	                }
	            }
	        }),
	        {
	            fieldLabel: '<t:message code="unilite.msg.sMS832" default="판매유형"/>',
	            name: 'ORDER_TYPE',
	            xtype: 'uniCombobox',
	            comboType: 'AU',
	            comboCode: 'S002'
	        },
	        {
	            fieldLabel: '<t:message code="unilite.msg.sMSR281" default="PO번호"/>',
	            name: 'PO_NUM'
	        }
	    ]
	}); // createSearchForm   
	

	

    Unilite.Main({
		id: 'pmp181ukrvApp',
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
				panelResult, detailGrid
			]	
		}		
		,panelSearch 
		],
		fnInitBinding: function() {
			UniAppManager.setToolbarButtons(['prev', 'next'], false);
			detailGrid.disabledLinkButtons(false);

			this.setDefault();
			
		},
		onQueryButtonDown: function() {
			if(panelSearch.setAllFieldsReadOnly(true) == false)   // 필수값을 체크
			{
        		return false;
			}	
			else
			{
				detailStore.loadStoreRecords();
				panelSearch.setAllFieldsReadOnly(false);
			}
		},
		onNewDataButtonDown: function()	{
			//if(!this.checkForNewDetail()) return false;
				/**
				 * Detail Grid Default 값 설정
				 */
				 var orderNum = panelSearch.getValue('ORDER_NUM')
				 
				 var seq = detailStore.max('SER_NO');
            	 if(!seq) seq = 1;
            	 else  seq += 1;
            	 
            	 var taxType ='1';
            	 if(panelSearch.getValue('BILL_TYPE')=='50')	{
            	 	taxType ='2';
            	 }
            	 
            	 var r = {
					ORDER_NUM: orderNum,
					SER_NO: seq
		        };
				detailGrid.createRow(r, 'ITEM_CODE', -1);
				panelSearch.setAllFieldsReadOnly(true);
			},
		onResetButtonDown: function() {
			this.suspendEvents();
			panelSearch.clearForm();
			panelSearch.setAllFieldsReadOnly(false);
			detailGrid.reset();
		
			this.fnInitBinding();
		},
		onSaveDataButtonDown: function(config) {
			var records = detailGrid.getSelectedRecords();
                var me = this;
                Ext.each(records, function(record,i) {
                    var param= {
                        'DIV_CODE': record.get('DIV_CODE'),
                        'WKORD_NUM': record.get('WKORD_NUM'),
                        'ORDER_NUM': record.get('ORDER_NUM'),
                        'SEQ': record.get('SEQ')
                    }
                    pmp181ukrvService.updateDetail(param, function(provider, response) {
                        if(provider) {  
                            me.setDisabled(true);                           
                        }
                        UniAppManager.app.onQueryButtonDown();
                    });
                });
			//detailStore.saveStore();
		},
		onDeleteDataButtonDown: function() {
			detailGrid.deleteSelectedRow();
		},
		setDefault: function() {
        	panelSearch.setValue('DIV_CODE',UserInfo.divCode);
        	panelSearch.setValue('PRODT_END_DATE_FR',UniDate.get('startOfMonth'));
        	panelSearch.setValue('PRODT_END_DATE_TO',UniDate.get('endOfMonth'));
        	
        	panelResult.setValue('DIV_CODE',UserInfo.divCode);
        	panelResult.setValue('PRODT_END_DATE_FR',UniDate.get('startOfMonth'));
        	panelResult.setValue('PRODT_END_DATE_TO',UniDate.get('endOfMonth'));
			
        	var param = {'COMP_CODE' : UserInfo.compCode, 'DIV_CODE' : UserInfo.divCode}
			
			pmp181ukrvService.fnWorkShopCode(param, function(provider, response) {
				if(!provider){
					cgWorkShopCode = provider[0].TREE_CODE; 
					
					panelSearch.setValue('WORK_SHOP_CODE', cgWorkShopCode);
					panelSearch.setValue('WORK_SHOP_CODE', cgWorkShopCode)
				}
			});
        	
			panelSearch.getForm().wasDirty = false;
			panelSearch.resetDirtyStatus();											
			UniAppManager.setToolbarButtons('save', false);	
		}
	});
		
    /**
	 * Validation
	 */
	Unilite.createValidator('validator01', {
		store: detailStore,
		grid: detailGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			switch(fieldName) {
			
			}
			return rv;
		}
	}); // validator
}
</script>