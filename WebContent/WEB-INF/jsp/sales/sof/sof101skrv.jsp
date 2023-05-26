<%@page language="java" contentType="text/html; charset=utf-8"%>

<t:appConfig pgmId="sof101skrv"  >
	<t:ExtComboStore comboType="BOR120" pgmId="sof101skrv" /> 			<!-- 사업장 --> 
	<t:ExtComboStore comboType="AU" comboCode="S010" /> <!--영업담당 -->
	<t:ExtComboStore comboType="AU" comboCode="S002" /> <!--판매유형-->
	<t:ExtComboStore comboType="AU" comboCode="S065" /> <!--주문구분-->	
	<t:ExtComboStore comboType="AU" comboCode="B055" /> <!-- 거래처분류 -->
	<t:ExtComboStore comboType="AU" comboCode="B034" /><!-- 결제조건-->
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
	Unilite.defineModel('Sof101skrvModel', {
	    fields: [{name: 'ORDER_DATE'      			,text:'수주일자' 	,type:'uniDate',convert:dateToString},
				 {name: 'CUSTOM_CODE'     			,text:'<t:message code="system.label.sales.custom" default="거래처"/>' 	,type:'string'},
				 {name: 'CUSTOM_NAME'     			,text:'<t:message code="system.label.sales.customname" default="거래처명"/>' 	,type:'string'},
				 {name: 'RECEIPT_DAY'   			,text:'결제조건' 	,type:'string',comboType:'AU', comboCode:'B034'},
				 {name: 'ITEM_CODE'       			,text:'<t:message code="system.label.sales.item" default="품목"/>' 		,type:'string'},
				 {name: 'ITEM_NAME'       			,text:'<t:message code="system.label.sales.itemname" default="품목명"/>' 	,type:'string'},
				 {name: 'SPEC'            			,text:'<t:message code="system.label.sales.spec" default="규격"/>' 		,type:'string'},
				 {name: 'ORDER_UNIT'      			,text:'<t:message code="system.label.sales.unit" default="단위"/>' 		,type:'string', displayField: 'value'},
				 {name: 'TRANS_RATE'      			,text:'<t:message code="system.label.sales.containedqty" default="입수"/>' 		,type:'string'},
				 {name: 'DVRY_DATE'       			,text:'<t:message code="system.label.sales.deliverydate" default="납기일"/>' 	,type:'uniDate',convert:dateToString},
				 {name: 'ORDER_Q'         			,text:'<t:message code="system.label.sales.soqty" default="수주량"/>' 	,type:'uniQty'},
				 {name: 'ORDER_P'         			,text:'<t:message code="system.label.sales.soprice" default="수주단가"/>' 	,type:'uniUnitPrice'},
				 {name: 'ORDER_O'         			,text:'<t:message code="system.label.sales.soamount" default="수주액"/>' 	,type:'uniUnitPrice'},
				 {name: 'INOUT_DATE'       			,text:'출고일' 	,type:'uniDate',convert:dateToString},
				 {name: 'INOUT_Q'         			,text:'<t:message code="system.label.sales.issueqty" default="출고량"/>' 	,type:'uniQty'},
				 {name: 'INOUT_P'         			,text:'<t:message code="system.label.sales.issueprice" default="출고단가"/>' 	,type:'uniUnitPrice'},
				 {name: 'INOUT_I'         			,text:'출고액' 	,type:'uniUnitPrice'},
				 {name: 'RETURN_Q'        			,text:'<t:message code="system.label.sales.returnqty" default="반품량"/>' 	,type:'uniQty'},
				 {name: 'RETURN_P'        			,text:'반품단가' 	,type:'uniUnitPrice'},
				 {name: 'RETURN_I'        			,text:'반품액' 	,type:'uniUnitPrice'},
				 {name: 'SALE_Q'          			,text:'<t:message code="system.label.sales.salesqty" default="매출량"/>' 	,type:'uniQty'},
				 {name: 'SALE_P'          			,text:'매출단가' 	,type:'uniUnitPrice'},
				 {name: 'SALE_AMT_O'      			,text:'<t:message code="system.label.sales.salesamount" default="매출액"/>' 	,type:'uniUnitPrice'},
				 {name: 'ORDER_TYPE'   			,text:'<t:message code="system.label.sales.sellingtype" default="판매유형"/>' 	,type:'string',comboType:'AU', comboCode:'S002'},
				 {name: 'SO_KIND'      			,text:'<t:message code="system.label.sales.ordertype" default="주문구분"/>' 	,type:'string',comboType:'AU', comboCode:'S065'},
				 {name: 'ORDER_PRSN'   			,text:'<t:message code="system.label.sales.salescharge" default="영업담당"/>' 	,type:'string',comboType:'AU', comboCode:'S010'},
				 {name: 'ORDER_NUM'       			,text:'<t:message code="system.label.sales.sono" default="수주번호"/>' 	,type:'string'},
				 {name: 'SER_NO'          			,text:'<t:message code="system.label.sales.seq" default="순번"/>' 		,type:'integer'},
				 {name: 'STATUS'          			,text:'상태' 		,type:'string',comboType:'AU', comboCode:'S046'},
				 {name: 'ORDER_STATUS_NM' 			,text:'<t:message code="system.label.sales.closingyn" default="마감여부"/>' 	,type:'string'},
				 {name: 'CUSTOMER_ID'     			,text:'주문자ID' 	,type:'string'},
				 {name: 'RECEIVER_ID'     			,text:'수신자ID' 	,type:'string'},
				 {name: 'RECEIVER_NAME'   			,text:'수신자명' 	,type:'string'},
				 {name: 'TELEPHONE_NUM1'  			,text:'전화번호1' 	,type:'string'},
				 {name: 'TELEPHONE_NUM2'  			,text:'전화번호2' 	,type:'string'},
				 {name: 'FAX_NUM'         			,text:'팩스번호' 	,type:'string'},
				 {name: 'ZIP_NUM'         			,text:'우편번호' 	,type:'string'},
				 {name: 'ADDRESS'         			,text:'<t:message code="system.label.sales.address" default="주소"/>' 		,type:'string'}
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
	var directMasterStore1 = Unilite.createStore('sof101skrvMasterStore1',{
			model: 'Sof101skrvModel',
			uniOpt: {
            	isMaster: true,			// 상위 버튼 연결 
            	editable: false,			// 수정 모드 사용 
            	deletable:false,			// 삭제 가능 여부 
	            useNavi: false			// prev | next 버튼 사용
            },
            autoLoad: false,
            proxy: {
                type: 'direct',
                api: {			
                	   read: 'sof101skrvService.selectList1'                	
                }
            }
			,loadStoreRecords: function()	{
				var param= Ext.getCmp('searchForm').getValues();			
				console.log( param );
				this.load({
					params: param
				});
				
			},
			groupField: 'ORDER_DATE'
			
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
        		xtype:'container',
        		layout:{type:'uniTable', columns:1},
        		items:[{
        			fieldLabel: '<t:message code="system.label.sales.division" default="사업장"/>',
        			name:'DIV_CODE',
        			xtype: 'uniCombobox',
        			comboType:'BOR120',
        			allowBlank:false,
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
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
				}, {
					fieldLabel: '<t:message code="system.label.sales.sellingtype" default="판매유형"/>',
					name: 'TXT_ORDER_TYPE',
					xtype:'uniCombobox',
					comboType:'AU',
					comboCode:'S002',
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.setValue('TXT_ORDER_TYPE', newValue);
						}
					}
				}, {
					fieldLabel: '<t:message code="system.label.sales.ordertype" default="주문구분"/>',
					name: 'SO_KIND',
					xtype:'uniCombobox',
					comboType:'AU',
					comboCode:'S065',
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							panelResult.setValue('SO_KIND', newValue);
						}
					}
				},
					Unilite.popup('AGENT_CUST',{
					fieldLabel		: '<t:message code="system.label.sales.custom" default="거래처"/>',
					name			: 'CUSTOM_CODE',
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
					name			: 'ITEM_CODE',
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
		},{
			title:'<t:message code="system.label.sales.additionalinfo" default="추가정보"/>',
			id: 'search_panel2',
			itemId:'search_panel2',
	    	defaultType: 'uniTextfield',
	    	layout: {type: 'uniTable', columns: 1},
			items:[,
					Unilite.popup('DEPT',{
					fieldLabel: '<t:message code="system.label.sales.department" default="부서"/>',
					name:'TREE_CODE'/*,
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
						}
					}*/
			}),{
				fieldLabel: '<t:message code="system.label.sales.salescharge" default="영업담당"/>',
				name:'ORDER_PRSN',
				xtype: 'uniCombobox',
				comboType:'AU',
				comboCode:'S010'
			}, {
				fieldLabel: '<t:message code="system.label.sales.customclass" default="거래처분류"/>',
				name:'AGENT_TYPE',
				xtype: 'uniCombobox',
				comboType:'AU',
				comboCode:'B055'  
			},
				Unilite.popup('AGENT_CUST',{
				fieldLabel: '<t:message code="system.label.sales.summarycustom" default="집계거래처"/>',
				
				validateBlank:false,
				valueFieldName:'TXT_MANAGE_CUST_CODE',
				textFieldName:'TXT_MANAGE_CUST_NAME',
				width:400,
				id:'sof101skrvCustPopup2',
				extParam:{'CUSTOM_TYPE':'3'},
				listeners: {
					onValueFieldChange: function(field, newValue, oldValue){
						if(!Ext.isObject(oldValue)) {
							panelSearch.setValue('TXT_MANAGE_CUST_NAME', '');
						}
					},
					onTextFieldChange: function(field, newValue, oldValue){
						if(!Ext.isObject(oldValue)) {
							panelSearch.setValue('TXT_MANAGE_CUST_CODE', '');
						}
					}
				}
			}),{
				fieldLabel: '<t:message code="system.label.sales.majorgroup" default="대분류"/>',
				name: 'ITEM_LEVEL1',
				xtype: 'uniCombobox',
				store: Ext.data.StoreManager.lookup('itemLeve1Store'),
				child: 'ITEM_LEVEL2'
			}, {
				fieldLabel: '<t:message code="system.label.sales.middlegroup" default="중분류"/>',name: 'ITEM_LEVEL2',
				xtype: 'uniCombobox',
				store: Ext.data.StoreManager.lookup('itemLeve2Store'),
				child: 'ITEM_LEVEL3'
			}, {
				fieldLabel: '<t:message code="system.label.sales.minorgroup" default="소분류"/>',
				name: 'ITEM_LEVEL3',
				xtype: 'uniCombobox',
				store: Ext.data.StoreManager.lookup('itemLeve3Store')
			},
				Unilite.popup('ITEM2',{
				fieldLabel: '대표품목',
				name: 'ITEM_GROUP', 
				 
				validateBlank:false,
				popupWidth: 710
			}),{
				fieldLabel: '주문번호',
				name:'TXT_SO_NUM',
				width:325
			}, {
				fieldLabel: '주문자',
				name:'TXT_CUSTOMER_ID',
				width:325
			}, {
				fieldLabel: '전화번호1',
				name:'TXT_TELPHONE1',
				width:325
			}, {
				fieldLabel: '전화번호2',
				name:'TXT_TELPHONE2',
				width:325
			}, {
				fieldLabel: '<t:message code="system.label.sales.address" default="주소"/>',
				name:'TXT_ADDRESS',
				width:325
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
		layout : {type : 'uniTable', columns : 4},
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
		}, {
			fieldLabel: '<t:message code="system.label.sales.sellingtype" default="판매유형"/>',
			name: 'TXT_ORDER_TYPE',
			xtype:'uniCombobox',
			comboType:'AU',
			comboCode:'S002',
			colspan:2,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('TXT_ORDER_TYPE', newValue);
				}
			}
		}, {
			fieldLabel: '<t:message code="system.label.sales.ordertype" default="주문구분"/>',
			name: 'SO_KIND',
			xtype:'uniCombobox',
			comboType:'AU',
			comboCode:'S065',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('SO_KIND', newValue);
				}
			}
		},
			Unilite.popup('AGENT_CUST',{
			fieldLabel: '<t:message code="system.label.sales.custom" default="거래처"/>',
			name: 'CUSTOM_CODE',
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
			name: 'ITEM_CODE',
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
		}),{
            xtype: 'component',  
            html:'※ 수주단가와 매출단가가 다른경우',
            tdAttrs: {width:500},
            margin: '0 0 0 90',
            style: {
                marginTop: '3px !important',
                font: '12px "굴림",Gulim,tahoma,arial,verdana,sans-serif',
                color: 'red'
            }
        }/*,
			Unilite.popup('DEPT',{
			fieldLabel: '<t:message code="system.label.sales.department" default="부서"/>',
			name:'TREE_CODE',
			
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
				}
			}
		})*/]
    });
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    var masterGrid = Unilite.createGrid('sof101skrvGrid1', {
    	// for tab
    	region: 'center',
        layout: 'fit',
    	store: directMasterStore1,
    	features: [ {id: 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false },
    	           	{id: 'masterGridTotal', 	ftype: 'uniSummary', 	  showSummaryRow: false} ],
        columns: [  { dataIndex: 'ORDER_DATE'      , 				width:80,
						summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
		              	return Unilite.renderSummaryRow(summaryData, metaData, '일자계', '<t:message code="system.label.sales.total" default="총계"/>');
                    }}, 				
					{ dataIndex: 'CUSTOM_CODE'     , 				width:66, align:'center'  }, 				
					{ dataIndex: 'CUSTOM_NAME'     , 				width:133 },
					{ dataIndex: 'RECEIPT_DAY'     , 				width:120 },
					{ dataIndex: 'ITEM_CODE'       , 				width:120 }, 				
					{ dataIndex: 'ITEM_NAME'       , 				width:166 }, 				
					{ dataIndex: 'SPEC'            , 				width:133 }, 				
					{ dataIndex: 'ORDER_UNIT'      , 				width:66, align:'center' }, 				
					{ dataIndex: 'TRANS_RATE'      , 				width:66, align:'right' }, 				
					{ dataIndex: 'DVRY_DATE'       , 				width:86 }, 				
					{ dataIndex: 'ORDER_Q'         , 				width:106, summaryType:'sum' }, 				
					{ dataIndex: 'ORDER_P'         , 				width:106 }, 				
					{ dataIndex: 'ORDER_O'         , 				width:106, summaryType:'sum' }, 
					{ dataIndex: 'INOUT_DATE'      , 				width:80 },
					{ dataIndex: 'INOUT_Q'         , 				width:106, summaryType:'sum' }, 				
					{ dataIndex: 'INOUT_P'         , 				width:106 }, 				
					{ dataIndex: 'INOUT_I'         , 				width:106, summaryType:'sum' }, 				
					{ dataIndex: 'RETURN_Q'        , 				width:106, summaryType:'sum' }, 				
					{ dataIndex: 'RETURN_P'        , 				width:106 }, 				
					{ dataIndex: 'RETURN_I'        , 				width:106, summaryType:'sum' }, 				
					{ dataIndex: 'SALE_Q'          , 				width:106, summaryType:'sum' }, 				
					{ dataIndex: 'SALE_P'          , 				width:106 }, 				
					{ dataIndex: 'SALE_AMT_O'      , 				width:106, summaryType:'sum' }, 				
					{ dataIndex: 'ORDER_TYPE'   , 				width:106 }, 				
					{ dataIndex: 'SO_KIND'      , 				width:106 }, 				
					{ dataIndex: 'ORDER_PRSN'   , 				width:106 }, 				
					{ dataIndex: 'ORDER_NUM'       , 				width:106 }, 				
					{ dataIndex: 'SER_NO'          , 				width:66, align:'center' }, 				
					{ dataIndex: 'STATUS'          , 				width:106 }, 				
					{ dataIndex: 'ORDER_STATUS_NM' , 				width:106 }, 				
					{ dataIndex: 'CUSTOMER_ID'     , 				width:106 }, 				
					{ dataIndex: 'RECEIVER_ID'     , 				width:106 }, 				
					{ dataIndex: 'RECEIVER_NAME'   , 				width:106 }, 				
					{ dataIndex: 'TELEPHONE_NUM1'  , 				width:106 }, 				
					{ dataIndex: 'TELEPHONE_NUM2'  , 				width:106 }, 				
					{ dataIndex: 'FAX_NUM'         , 				width:106 }, 				
					{ dataIndex: 'ZIP_NUM'         , 				width:106 }, 				
					{ dataIndex: 'ADDRESS'         , 				width:266 } 
		], 
		viewConfig:{
			getRowClass : function(record,rowIndex,rowParams,store){
				var cls = '';
				if(record.get('SALE_Q') > 0 && record.get('ORDER_P')!=record.get('SALE_P')){		//매출량이 있을때 수주단가와 매출단가가 다른경우
					cls = 'x-change-cell_row3';
				}
				return cls;
			}
		}
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
		fnInitBinding: function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			panelResult.setValue('DIV_CODE',UserInfo.divCode);
			UniAppManager.setToolbarButtons('reset',false);
		},
		onQueryButtonDown: function()	{	
			if(!panelSearch.setAllFieldsReadOnly(true)){
	    		return false;
	    	}
			directMasterStore1.loadStoreRecords();
			
		 	//var viewLocked = masterGrid.lockedGrid.getView();
			//var viewNormal = masterGrid.normalGrid.getView();
			//viewLocked.getFeature('masterGridSubTotal').toggleSummaryRow(true);
			//viewLocked.getFeature('masterGridTotal').toggleSummaryRow(true);
			//viewNormal.getFeature('masterGridSubTotal').toggleSummaryRow(true);
			//viewNormal.getFeature('masterGridTotal').toggleSummaryRow(true);
				
		},onDetailButtonDown:function() {
			var as = Ext.getCmp('AdvanceSerch');	
			if(as.isHidden())	{
				as.show();
			}else {
				as.hide()
			}
		}
	});
};
</script>