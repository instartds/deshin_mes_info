<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_pmp100ukrv_kd"  >
	<t:ExtComboStore comboType="BOR120" pgmId="s_pmp100ukrv_kd" /> 			<!-- 사업장 -->  
	<t:ExtComboStore items="${COMBO_WS_LIST}" storeId="wsList" /> <!-- 작업장 --> 
	<t:ExtComboStore comboType="AU" comboCode="B013"  /> <!-- 단위 -->  
	<t:ExtComboStore comboType="AU" comboCode="B014"  /> <!-- 조달구분 -->  
	<t:ExtComboStore comboType="AU" comboCode="A" /> 	<!-- 가공창고 -->  
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>
<script type="text/javascript" >

var searchInfoWindow;	// searchInfoWindow : 조회창
var referProductionPlanWindow;	// 생산계획참조

var BsaCodeInfo = {

	gsAutoType:         '${gsAutoType}',            // "P005"	'생산자동채번여부
	gsChildStockPopYN : '${gsChildStockPopYN}',     //'자재부족수량 팝업 호출여부
	gsShowBtnReserveYN: '${gsShowBtnReserveYN}',	//'BOM PATH 관리여부
	gsManageLotNoYN   : '${gsManageLotNoYN}',       //'재고와 작업지시LOT 연계여부
	
	grsManageLotNo    : '${grsManageLotNo}',         // LOT 연계여부
		gsLotNoInputMethod : '${gsLotNoInputMethod}',// grsManageLotNo(0)
        gsLotNoEssential   : '${gsLotNoEssential}',  // grsManageLotNo(1)
        gsEssItemAccount   : '${gsEssItemAccount}'   // grsManageLotNo(2)
};

function appMain() {
	
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 's_pmp100ukrv_kdService.selectDetailList',
			update: 's_pmp100ukrv_kdService.updateDetail',
			create: 's_pmp100ukrv_kdService.insertDetail',
			destroy: 's_pmp100ukrv_kdService.deleteDetail',
			syncAll: 's_pmp100ukrv_kdService.saveAll'
		}
	});
	
	var masterForm = Unilite.createSearchPanel('s_pmp100ukrv_kdMasterForm', {
		title: '검색조건',
        defaultType: 'uniSearchSubPanel',
        collapsed: UserInfo.appOption.collapseLeftSearch,
        listeners: {
	        collapse: function () {
	            panelResult.show();
	        },
	        expand: function() {
	        	panelResult.hide();
	        },
	        dirtychange: function(basicForm, dirty, eOpts) {
				console.log("onDirtyChange");
				UniAppManager.setToolbarButtons('save', true);
			}
        },
		items: [{	
			title: '기본정보', 	
   			itemId: 'search_panel1',
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',
		    items: [{
        		fieldLabel: '사업장',
        		name: 'DIV_CODE',
        		value : UserInfo.divCode,
        		xtype: 'uniCombobox',
        		comboType: 'BOR120',
        		allowBlank: false,
        		listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('DIV_CODE', newValue);
					}
        		}
			},{
				fieldLabel: '작업장',
				name: 'WORK_SHOP_CODE',
				xtype: 'uniCombobox',
				store: Ext.data.StoreManager.lookup('wsList'),
		 		allowBlank:false,
		 		listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('WORK_SHOP_CODE', newValue);
					}
        		}
			},
				Unilite.popup('DIV_PUMOK',{ 
			        	fieldLabel: '품목코드',
			        	valueFieldName: 'ITEM_CODE', 
						textFieldName: 'ITEM_NAME', 
			        	listeners: {
							onSelected: {
								fn: function(records, type) {
									console.log('records : ', records);
									panelResult.setValue('ITEM_CODE', panelSearch.getValue('ITEM_CODE'));
									panelResult.setValue('ITEM_NAME', panelSearch.getValue('ITEM_NAME'));	
		                    	},
								scope: this
							},
							onClear: function(type)	{
								panelResult.setValue('ITEM_CODE', '');
								panelResult.setValue('ITEM_NAME', '');
							}
						}
			}),{
				fieldLabel : ' ',
				name:'SPEC',
				xtype:'uniTextfield',
				readOnly:true,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('SPEC', newValue);
					}
        		}
			},{
		 		fieldLabel: '작업지시일',
		 		xtype: 'uniDatefield',
		 		name: 'START_WKORD_DATE',
		 		value: new Date(),
		 		allowBlank:false,
		 		listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('START_WKORD_DATE', newValue);
					}
        		}
			},{
		    	fieldLabel: '작업지시량',
			 	xtype: 'uniTextfield',
			 	name: 'WKORD_Q',
		 		allowBlank:false,
		 		listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('WKORD_Q', newValue);
					}
        		}
			},{
				fieldLabel : ' ',
				name:'PROG_UNIT',
				xtype:'uniTextfield',
				readOnly:true,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('PROG_UNIT', newValue);
					}
        		}
			},{
		 		fieldLabel: '착수예정일',
		 		xtype: 'uniDatefield',
		 		name: 'PRODT_START_DATE',
		 		value: new Date(),
		 		allowBlank:false,
		 		listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('PRODT_START_DATE', newValue);
					}
        		}
			},{
		 		fieldLabel: '완료예정일',
		 		xtype: 'uniDatefield',
		 		name: 'PRODT_END_DATE',
		 		value: new Date(),
		 		allowBlank:false,
		 		listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('PRODT_END_DATE', newValue);
					}
        		}
			},
				Unilite.popup('DIV_PUMOK',{ 
			        	fieldLabel: '관리번호',
			        	valueFieldName: 'TEST_CODE', 
						textFieldName: 'TEST_NAME', 
			        	listeners: {
							onSelected: {
								fn: function(records, type) {
									console.log('records : ', records);
									panelResult.setValue('TEST_CODE', panelSearch.getValue('TEST_CODE'));
									panelResult.setValue('TEST_NAME', panelSearch.getValue('TEST_NAME'));	
		                    	},
								scope: this
							},
							onClear: function(type)	{
								panelResult.setValue('TEST_CODE', '');
								panelResult.setValue('TEST_NAME', '');
							}
						}
			}),
				Unilite.popup('DIV_PUMOK',{ 
			        	fieldLabel: '프로젝트',
			        	valueFieldName: 'PROJECT_CODE', 
						textFieldName: 'PROJECT_NAME', 
			        	listeners: {
							onSelected: {
								fn: function(records, type) {
									console.log('records : ', records);
									panelResult.setValue('PROJECT_CODE', panelSearch.getValue('PROJECT_CODE'));
									panelResult.setValue('PROJECT_NAME', panelSearch.getValue('PROJECT_NAME'));	
		                    	},
								scope: this
							},
							onClear: function(type)	{
								panelResult.setValue('PROJECT_CODE', '');
								panelResult.setValue('PROJECT_NAME', '');
							}
						}
			}),
				Unilite.popup('DIV_PUMOK',{ 
			        	fieldLabel: 'LOT_NO',
			        	valueFieldName: 'LOT_CODE', 
						textFieldName: 'LOT_NAME', 
			        	listeners: {
							onSelected: {
								fn: function(records, type) {
									console.log('records : ', records);
									panelResult.setValue('LOT_CODE', panelSearch.getValue('LOT_CODE'));
									panelResult.setValue('LOT_NAME', panelSearch.getValue('LOT_NAME'));	
		                    	},
								scope: this
							},
							onClear: function(type)	{
								panelResult.setValue('LOT_CODE', '');
								panelResult.setValue('LOT_NAME', '');
							}
						}
			}),{
		    	fieldLabel: '비고',
			 	xtype: 'uniTextfield',
			 	name: 'REMARK',
			 	listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('REMARK', newValue);
					}
        		}
			}]
		},{
			title: '참고사항',	
   			itemId: 'search_panel2',
   			//collapsed: true,
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',
		    items: [{
		    	fieldLabel: '수주번호',
			 	xtype: 'uniTextfield',
			 	name: 'ORDER_NUM',
			 	readOnly: true
			},{
		    	fieldLabel: '수주량',
			 	xtype: 'uniTextfield',
			 	name: 'ORDER_Q',
			 	readOnly: true
			},{
		    	fieldLabel: '납기일',
			 	xtype: 'uniTextfield',
			 	name: 'DVRY_DATE',
			 	readOnly: true
			},{
		    	fieldLabel: '거래처',
			 	xtype: 'uniTextfield',
			 	name: 'CUSTOM_CODE',
			 	readOnly: true
			}]		            			 
	    }],
		fnCreditCheck: function() {
			if(BsaCodeInfo.gsCustCrYn=='Y' && BsaCodeInfo.gsCreditYn=='Y') {
				if(this.getValue('TOT_ORDER_AMT') > this.getValue('REMAIN_CREDIT')) {
					alert('<t:message code="unilite.msg.sMS284" default="해당 업체에 대한 여신액이 부족합니다. 추가여신액 설정을 선행하시고 작업하시기 바랍니다."/>');
					return false;
				}
			}
			return true;
		},
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
					} else {
						this.mask();		    
	   				}
		  		} else {
  					this.unmask();
  				}
				return r;
  			}
	});
	
	
	var panelResult = Unilite.createSearchForm('panelResultForm', {
    	hidden: !UserInfo.appOption.collapseLeftSearch,
		region: 'north',
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
	    	items: [{
        		fieldLabel: '사업장',
        		name: 'DIV_CODE',
        		value : UserInfo.divCode,
        		xtype: 'uniCombobox',
        		comboType: 'BOR120',
        		allowBlank: false,
        		colspan:3,
        		listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						masterForm.setValue('DIV_CODE', newValue);
					}
        		}
			},{
				fieldLabel: '작업장',
				name: 'WORK_SHOP_CODE',
				xtype: 'uniCombobox',
				store: Ext.data.StoreManager.lookup('wsList'),
		 		allowBlank:false,
		 		colspan:3,
		 		listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						masterForm.setValue('WORK_SHOP_CODE', newValue);
					}
        		}
			},{
    			xtype: 'container',
    			layout: { type: 'uniTable', columns: 3},
    			defaultType: 'uniTextfield',
    			defaults : {enforceMaxLength: true},
    			colspan:3,
    			items:[
    				Unilite.popup('DIV_PUMOK',{ 
			        	fieldLabel: '품목코드',
			        	valueFieldName: 'ITEM_CODE', 
						textFieldName: 'ITEM_NAME',
						allowBlank:false,
			        	listeners: {
							onSelected: {
								fn: function(records, type) {
									console.log('records : ', records);
									masterForm.setValue('SPEC',records[0]["SPEC"]);
									panelResult.setValue('SPEC',records[0]["SPEC"]);								
									masterForm.setValue('PROG_UNIT',records[0]["STOCK_UNIT"]);
									panelResult.setValue('PROG_UNIT',records[0]["STOCK_UNIT"]);								

									masterForm.setValue('ITEM_CODE', panelResult.getValue('ITEM_CODE'));
									masterForm.setValue('ITEM_NAME', panelResult.getValue('ITEM_NAME'));	
		                    	},
								scope: this
							},
							onClear: function(type)	{
								masterForm.setValue('ITEM_CODE', '');
								masterForm.setValue('ITEM_NAME', '');	
								masterForm.setValue('SPEC','');
								masterForm.setValue('PROG_UNIT','');
								
								panelResult.setValue('SPEC','');
								panelResult.setValue('PROG_UNIT','');
								
							},
							applyextparam: function(popup){							
								popup.setExtParam({'DIV_CODE': masterForm.getValue('DIV_CODE')});
							}
						}
			   }),{
					name:'SPEC',
					xtype:'uniTextfield',
					readOnly:true,
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							masterForm.setValue('SPEC', newValue);
						}
	        		}
				}]
	    	},{
		 		fieldLabel: '작업지시일',
		 		xtype: 'uniDatefield',
		 		value: new Date(),
		 		name: 'START_WKORD_DATE',
		 		allowBlank:false,
		 		listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						masterForm.setValue('START_WKORD_DATE', newValue);
					}
        		}
			},{
    			xtype: 'container',
    			layout: { type: 'uniTable', columns: 3},
    			defaultType: 'uniTextfield',
    			defaults : {enforceMaxLength: true},
    			colspan:2,
    			items:[{
			    	fieldLabel: '작업지시량',
				 	xtype: 'uniNumberfield',
				 	name: 'WKORD_Q',
				 	value: '0.00',
				 	allowBlank:false,
				 	listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							masterForm.setValue('WKORD_Q', newValue);
							
							var cgWkordQ = panelResult.getValue('WKORD_Q');	
							
							
							if(Ext.isEmpty(cgWkordQ)) return false;
							var records = detailStore.data.items;
							
							Ext.each(records, function(record,i){					
								record.set('WKORD_Q',(cgWkordQ * record.get("PROG_UNIT_Q")));
							});
						}
	        		}
				},{
					name:'PROG_UNIT',
					xtype:'uniTextfield',
					width: 50,
					readOnly:true,
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {						
							masterForm.setValue('PROG_UNIT', newValue);
						}
	        		}
				}]
	    	},{
		 		fieldLabel: '착수예정일',
		 		xtype: 'uniDatefield',
		 		value: new Date(),
		 		name: 'PRODT_START_DATE',
		 		allowBlank:false,
		 		listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						masterForm.setValue('PRODT_START_DATE', newValue);
					}
        		}
			},
				Unilite.popup('DIV_PUMOK',{ 
			        	fieldLabel: '관리번호',
			        	valueFieldName: 'TEST_CODE', 
						textFieldName: 'TEST_NAME', 
			        	listeners: {
							onSelected: {
								fn: function(records, type) {
									console.log('records : ', records);
									masterForm.setValue('TEST_CODE', panelResult.getValue('TEST_CODE'));
									masterForm.setValue('TEST_NAME', panelResult.getValue('TEST_NAME'));	
		                    	},
								scope: this
							},
							onClear: function(type)	{
								masterForm.setValue('TEST_CODE', '');
								masterForm.setValue('TEST_NAME', '');
							}
						}
			}),
				Unilite.popup('DIV_PUMOK',{ 
			        	fieldLabel: '프로젝트',
			        	valueFieldName: 'PROJECT_CODE', 
						textFieldName: 'PROJECT_NAME', 
			        	listeners: {
							onSelected: {
								fn: function(records, type) {
									console.log('records : ', records);
									masterForm.setValue('PROJECT_CODE', panelResult.getValue('PROJECT_CODE'));
									masterForm.setValue('PROJECT_NAME', panelResult.getValue('PROJECT_NAME'));	
		                    	},
								scope: this
							},
							onClear: function(type)	{
								masterForm.setValue('PROJECT_CODE', '');
								masterForm.setValue('PROJECT_NAME', '');
							}
						}
			}),{
		 		fieldLabel: '완료예정일',
		 		xtype: 'uniDatefield',
		 		value: new Date(),
		 		name: 'PRODT_END_DATE',
		 		allowBlank:false,
		 		listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						masterForm.setValue('PRODT_END_DATE', newValue);
					}
        		}
			},
				Unilite.popup('DIV_PUMOK',{ 
			        	fieldLabel: 'LOT_NO',
			        	valueFieldName: 'LOT_CODE', 
						textFieldName: 'LOT_NAME', 
			        	listeners: {
							onSelected: {
								fn: function(records, type) {
									console.log('records : ', records);
									masterForm.setValue('LOT_CODE', panelResult.getValue('LOT_CODE'));
									masterForm.setValue('LOT_NAME', panelResult.getValue('LOT_NAME'));	
		                    	},
								scope: this
							},
							onClear: function(type)	{
								masterForm.setValue('LOT_CODE', '');
								masterForm.setValue('LOT_NAME', '');
							}
						}
			}),{
		    	fieldLabel: '비고',
			 	xtype: 'uniTextfield',
			 	name: 'REMARK',
			 	listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						masterForm.setValue('REMARK', newValue);
					}
        		}
			}]
	});
	
	
	
	/**
	 * Model 정의
	 * 
	 * @type
	 */
	Unilite.defineModel('s_pmp100ukrv_kdDetailModel', {
	    fields: [  	 
	    	{name: 'GUBUN'					,text: '선택'				,type:'string'},
			{name: 'DIV_CODE'				,text: '사업장'			,type:'string'},
			{name: 'WORK_SHOP_CODE'			,text: '작업장'			,type:'string'},
			{name: 'ITEM_CODE'			 	,text: '품목코드'			,type:'string'},
			{name: 'ITEM_NAME'				,text: '품명'				,type:'string'},
			{name: 'SPEC'					,text: '규격'				,type:'string'},
			{name: 'STOCK_UNIT'		  		,text: '단위'				,type:'string'},
			{name: 'PRODT_START_DATE'		,text: '차수예정일'			,type:'uniDate'},
			{name: 'PRODT_END_DATE'			,text: '완료예정일'			,type:'uniDate'},
			{name: 'WKORD_Q'				,text: '작업지시량'			,type:'uniQty'},
			{name: 'SUPPLY_TYPE'			,text: '조달구분'			,type:'string'},	
			{name: 'WKORD_NUM'			 	,text: '작지번호'			,type:'string'},
			{name: 'WK_PLAN_NUM'			,text: '생산계획번호'		,type:'string'},
			{name: 'PRODUCT_LDTIME'			,text: '제조L/T'			,type:'string'},
			{name: 'SEQ_NO'			   		,text: '번호'				,type:'string'},
			{name: 'REF_GUBUN'			  	,text: '반영구분'			,type:'string'},
			{name: 'PROJECT_NO'				,text: '프로젝트번호'		,type:'string'},		
			{name: 'PJT_CODE'				,text: '프로젝트번호'		,type:'string'},
			{name: 'REMARK'					,text: '비고'				,type:'string'},
			{name: 'LOT_NO'					,text: 'LOT_NO'			    ,type:'string'}
		]
	});
	
	Unilite.defineModel('s_pmp100ukrv_kdDetailModel2', {
	    fields: [  	 
	    	{name: 'LINE_SEQ'        	,text: '공정순서'			,type:'string'},
			{name: 'PROG_WORK_CODE'  	,text: '공정코드'			,type:'string'},
			{name: 'PROG_WORK_NAME'  	,text: '공정명'			    ,type:'string'},
			{name: 'PROG_UNIT_Q'      	,text: '원단위량'			,type:'uniQty'},
			{name: 'WKORD_Q'         	,text: '작업지시량'			,type:'uniQty'},
			{name: 'PROG_UNIT'       	,text: '단위'				,type:'string'},
			{name: 'PROG_RATE'       	,text: '공정진척율'			,type:'string'},
			{name: 'DIV_CODE'        	,text: '사업장'			    ,type:'string'},
			{name: 'WKORD_NUM'       	,text: '작지번호'			,type:'string'},
			{name: 'WORK_SHOP_CODE'  	,text: '작업장'		 	    ,type:'string'},
			{name: 'PRODT_START_DATE'	,text: '차수예정일'			,type:'uniDate'},	
			{name: 'PRODT_END_DATE'   	,text: '완료예정일'			,type:'uniDate'},
			{name: 'PRODT_WKORD_DATE'	,text: '작업시작일'			,type:'uniDate'},
			{name: 'ITEM_CODE'       	,text: '품목'				,type:'string'},
			{name: 'REMARK'          	,text: '비고'				,type:'string'},
			{name: 'LOT_NO'            	,text: 'LOT NO'			    ,type:'string'},
			{name: 'WK_PLAN_NUM'     	,text: '계획번호'			,type:'string'},		
			{name: 'LINE_End_YN'     	,text: '최종공정여부'		,type:'string'},
			{name: 'ITEM_NAME'       	,text: '품명'				,type:'string'},
			{name: 'SPEC'              	,text: '규격'				,type:'string'},
			{name: 'WORK_END_YN'     	,text: '마감여부'			,type:'string'},		
			{name: 'TOP_WKORD_NUM'   	,text: '관리번호'			,type:'string'}
		]
	});
	/**
	 * Store 정의(Service 정의)
	 * 
	 * @type
	 */					
	var detailStore = Unilite.createStore('s_pmp100ukrv_kdDetailStore', {
		model: 's_pmp100ukrv_kdDetailModel',
		autoLoad: false,
		uniOpt: {
			isMaster: true,			// 상위 버튼 연결
			editable: true,			// 수정 모드 사용
			deletable: true,		// 삭제 가능 여부
			useNavi : false			// prev | next 버튼 사용
		},
		
		proxy: {
                type: 'direct',
                api: {
                	read    : 's_pmp100ukrv_kdService.selectDetailList1'
                }
            },

		/*
		 * syncAll 수정 proxy: { type: 'direct', api: { read:
		 * 's_pmp100ukrv_kdService.selectDetailList', update:
		 * 's_pmp100ukrv_kdService.updateDetail', create:
		 * 's_pmp100ukrv_kdService.insertDetail', destroy:
		 * 's_pmp100ukrv_kdService.deleteDetail', syncAll:
		 * 's_pmp100ukrv_kdService.syncAll' } },
		 */

		
		listeners: {
		},
		loadStoreRecords: function() {
			var param= masterForm.getValues();			
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
			
			// 1. 마스터 정보 파라미터 구성
			var paramMaster= masterForm.getValues();	// syncAll 수정
			
			if(inValidRecs.length == 0) {
					config = {
							params: [paramMaster],
							success: function(batch, option) {
								// 2.마스터 정보(Server 측 처리 시 가공)
								var master = batch.operations[0].getResultSet();
								masterForm.setValue("ORDER_NUM", master.ORDER_NUM);
								
								// 3.기타 처리
								masterForm.getForm().wasDirty = false;
								masterForm.resetDirtyStatus();
								console.log("set was dirty to false");
								UniAppManager.setToolbarButtons('save', false);		

							 } 
					};
				// }
				// this.syncAll(config);
				this.syncAllDirect(config);
			} else {
                var grid = Ext.getCmp('s_pmp100ukrv_kdGrid');
                grid.uniSelectInvalidColumnAndAlert(inValidRecs);
				// alert(Msg.sMB083);
			}
		}
	});
	
	
	var detailStore2 = Unilite.createStore('s_pmp100ukrv_kdDetailStore2', {
		model: 's_pmp100ukrv_kdDetailModel2',
		autoLoad: false,
		uniOpt: {
			isMaster: true,			// 상위 버튼 연결
			editable: true,			// 수정 모드 사용
			deletable: true,		// 삭제 가능 여부
			useNavi : false			// prev | next 버튼 사용
		},
		
		proxy: {
                type: 'direct',
                api: {
                	read    : 's_pmp100ukrv_kdService.selectDetailList2'
                }
            },
		loadStoreRecords: function() {
			var param= masterForm.getValues();			
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

			var orderNum = masterForm.getValue('ORDER_NUM');
			Ext.each(list, function(record, index) {
				if(record.data['ORDER_NUM'] != orderNum) {
					record.set('ORDER_NUM', orderNum);
				}
			})
			console.log("this.data.filterBy(this.filterInvalidNewRecords).items : ", this.data.filterBy(this.filterInvalidNewRecords));
			
			// 1. 마스터 정보 파라미터 구성
			var paramMaster= masterForm.getValues();	// syncAll 수정
			
			if(inValidRecs.length == 0) {
					config = {
							params: [paramMaster],
							success: function(batch, option) {
								// 2.마스터 정보(Server 측 처리 시 가공)
								var master = batch.operations[0].getResultSet();
								masterForm.setValue("ORDER_NUM", master.ORDER_NUM);
								
								// 3.기타 처리
								masterForm.getForm().wasDirty = false;
								masterForm.resetDirtyStatus();
								console.log("set was dirty to false");
								UniAppManager.setToolbarButtons('save', false);		

							 } 
					};
				// }
				// this.syncAll(config);
				this.syncAllDirect(config);
			} else {
                var grid = Ext.getCmp('s_pmp100ukrv_kdGrid');
                grid.uniSelectInvalidColumnAndAlert(inValidRecs);
				// alert(Msg.sMB083);
			}
		}
	});

    var detailGrid = Unilite.createGrid('s_pmp100ukrv_kdGrid', {
    	layout: 'fit',
        region:'north',
        uniOpt: {
			expandLastColumn: true,
			useRowNumberer: false,
			onLoadSelectFirst : false
        },
        tbar: [{
			xtype: 'splitbutton',
           	itemId:'refTool',
			text: '참조...',
			iconCls : 'icon-referance',
			menu: Ext.create('Ext.menu.Menu', {
				items: [{
					itemId: 'requestBtn',
					text: '생산계획참조',
					handler: function() {
						openProductionPlanWindow();
						
					}
				},{
					itemId: 'workBtn',
					text: '일괄작지전개',
					handler: function() {	
					}
				},{
					itemId: 'dismemberBtn',
					text: '작지분할',
					handler: function() {	
					}
				}]
			})
		}/*,{
			xtype: 'splitbutton',
           	itemId:'procTool',
			text: '프로세스...',
			iconCls : 'icon-referance',
			menu: Ext.create('Ext.menu.Menu', {
				items: [{
					itemId: 'selectAllBtn',
					text: '전체선택',
					handler: function() {
						openProductionPlanWindow();
						
						}
				},{
					itemId: 'preparationDirectiveBtn',
					text: '제조지시서출력',
					handler: function() {
						openProductionPlanWindow();
						
						}
				}]
			})
		}*/
		],
		selModel :   Ext.create('Ext.selection.CheckboxModel', { checkOnly : true, toggleOnClick:false }), 
    	store: detailStore,
        columns: [        		
			{dataIndex: 'GUBUN'					, width: 40  , hidden: true}, 							
			{dataIndex: 'DIV_CODE'				, width: 80  , hidden: true}, 							
			{dataIndex: 'WORK_SHOP_CODE'	 	, width: 113}, 								
			{dataIndex: 'ITEM_CODE'				, width: 120}, 												
			{dataIndex: 'ITEM_NAME'				, width: 140},
			{dataIndex: 'SPEC'					, width: 140}, 							
			{dataIndex: 'STOCK_UNIT'			, width: 100}, 													
			{dataIndex: 'PRODT_START_DATE'		, width: 100}, 												
			{dataIndex: 'PRODT_END_DATE'		, width: 100},
			{dataIndex: 'WKORD_Q'				, width: 100}, 							
			{dataIndex: 'SUPPLY_TYPE'			, width: 75}, 	
			{dataIndex: 'WKORD_NUM'				, width: 100},
			{dataIndex: 'WK_PLAN_NUM'			, width: 100}, 							
			{dataIndex: 'PRODUCT_LDTIME'		, width: 66 , hidden: true}, 													
			{dataIndex: 'SEQ_NO'				, width: 66 , hidden: true}, 												
			{dataIndex: 'REF_GUBUN'				, width: 53 , hidden: true},
			{dataIndex: 'PROJECT_NO'			, width: 66 , hidden: true}, 							
			{dataIndex: 'PJT_CODE'				, width: 66 , hidden: true}, 
			{dataIndex: 'REMARK'				, width: 66 , hidden: true},
			{dataIndex: 'LOT_NO'				, width: 66 , hidden: true}
		], 
		listeners: {	
          		
       	},
		disabledLinkButtons: function(b) {
		},
		setItemData: function(record, dataClear) {
       		var grdRecord = detailGrid.uniOpt.currentRecord;
       		if(dataClear) {
       			grdRecord.set('ITEM_CODE'		,"");
       			grdRecord.set('ITEM_NAME'		,"");
				grdRecord.set('SPEC'			,""); 
				grdRecord.set('ORDER_UNIT'		,"");
				grdRecord.set('STOCK_UNIT'		,"");
				grdRecord.set('ORDER_Q'			,0);
				grdRecord.set('ORDER_P'			,0);
				grdRecord.set('ORDER_WGT_Q'		,0);
				grdRecord.set('ORDER_WGT_P'		,0);
				grdRecord.set('ORDER_VOL_Q'		,0);
				grdRecord.set('ORDER_VOL_P'		,0); 
				grdRecord.set('ORDER_O'			,0);
				grdRecord.set('PROD_SALE_Q'		,0);
				grdRecord.set('PROD_Q'			,0);
				grdRecord.set('STOCK_Q'			,0);
				grdRecord.set('DISCOUNT_RATE'	,0);
				grdRecord.set('WGT_UNIT'		,"");
				grdRecord.set('UNIT_WGT'		,0);
				grdRecord.set('VOL_UNIT'		,"");
				grdRecord.set('UNIT_VOL'		,0);
       		} else {
       			grdRecord.set('ITEM_CODE'			, record['ITEM_CODE']);
       			grdRecord.set('ITEM_NAME'			, record['ITEM_NAME']);
       			grdRecord.set('ITEM_ACCOUNT'		, record['ITEM_ACCOUNT']);
				grdRecord.set('SPEC'				, record['SPEC']); 
				grdRecord.set('ORDER_UNIT'			, record['SALE_UNIT']);
				grdRecord.set('STOCK_UNIT'			, record['STOCK_UNIT']);
				grdRecord.set('REF_WH_CODE'			, record['WH_CODE']);
				grdRecord.set('REF_STOCK_CARE_YN'	, record['STOCK_CARE_YN']);
				// grdRecord.set('OUT_DIV_CODE' ,record['DIV_CODE']);
				grdRecord.set('WGT_UNIT'			, record['WGT_UNIT']);
				grdRecord.set('UNIT_WGT'			, record['UNIT_WGT']);
				grdRecord.set('VOL_UNIT'			, record['VOL_UNIT']);
				grdRecord.set('UNIT_VOL'			, record['UNIT_VOL']);
				grdRecord.set('ORDER_NUM'			, masterForm.getValue('ORDER_NUM'));
				
       		}
		},
		setEstiData:function(record) {
       		var grdRecord = detailGrid.uniOpt.currentRecord;
       
       		// grdRecord.set('DIV_CODE' , record['DIV_CODE']);
			grdRecord.set('ORDER_NUM'			, masterForm.getValue('ORDER_NUM'));
			grdRecord.set('ITEM_CODE'			, record['ITEM_CODE']);	
			grdRecord.set('ITEM_NAME'			, record['ITEM_NAME']);	
			grdRecord.set('ITEM_ACCOUNT'		, record['ITEM_ACCOUNT']);	
			grdRecord.set('SPEC'				, record['SPEC']);	
			grdRecord.set('ORDER_UNIT'			, record['ESTI_UNIT']);	
			grdRecord.set('TRANS_RATE'			, record['TRANS_RATE']);	
			grdRecord.set('ORDER_Q'				, record['ESTI_QTY']);	
			grdRecord.set('ORDER_P'				, record['ESTI_PRICE']);	
			grdRecord.set('SCM_FLAG_YN'			, 'N');	
			if(masterForm.getValue('TAX_TYPE') != 50)	
			{
				grdRecord.set('TAX_TYPE'		,masterForm.getValue('TAX_TYPE').TAX_TYPE);	
			}
			if(Ext.isEmpty(masterForm.getValue('DVRY_DATE')))	{
				
				grdRecord.set('DVRY_DATE'		,masterForm.getValue('ORDER_DATE'));
			}else {
				grdRecord.set('DVRY_DATE'		,masterForm.getValue('DVRY_DATE'));
			}
			grdRecord.set('DISCOUNT_RATE'		, 0);	
			grdRecord.set('REF_WH_CODE'			, record['WH_CODE']);	
			grdRecord.set('REF_STOCK_CARE_YN'	, record['STOCK_CARE_YN']);	
			grdRecord.set('OUT_DIV_CODE'		, UserInfo.divCode);	
			grdRecord.set('STOCK_UNIT'			, record['STOCK_UNIT']);	
			grdRecord.set('ACCOUNT_YNC'			, 'Y');	
			
			if(Ext.isEmpty(masterForm.getValue('SALE_CUST_CD')))	{
				grdRecord.set('SALE_CUST_CD'		,masterForm.getValue('CUSTOM_CODE'));
			}else {
				grdRecord.set('SALE_CUST_CD'		,masterForm.getValue('SALE_CUST_CD'));
			}
			
			if(Ext.isEmpty(masterForm.getValue('SALE_CUST_NM')))	{
				grdRecord.set('CUSTOM_NAME'		,masterForm.getValue('CUSTOM_NAME'));
			}else {
				grdRecord.set('CUSTOM_NAME'		,masterForm.getValue('SALE_CUST_NM'));
			}
			grdRecord.set('PROD_PLAN_Q'			, 0);	
			grdRecord.set('ESTI_NUM'			, record['ESTI_NUM']);	
			grdRecord.set('ESTI_SEQ'			, record['ESTI_SEQ']);	
			grdRecord.set('REF_ORDER_DATE'		, masterForm.getValue('ORDER_DATE'));	
			grdRecord.set('REF_ORD_CUST'		, masterForm.getValue('CUSTOM_CODE'));	
			grdRecord.set('REF_ORDER_TYPE'		, masterForm.getValue('ORDER_TYPE'));
			grdRecord.set('REF_PROJECT_NO'		, masterForm.getValue('PLAN_NUM'));
			grdRecord.set('REF_TAX_INOUT'		, masterForm.getValue('TAX_TYPE').TAX_TYPE);
			// FIXME gsExchageRate값 설정
			// grdRecord.set('REF_EXCHG_RATE_O' ,gsExchageRate);
			grdRecord.set('REF_REMARK'			, masterForm.getValue('REMARK'));
			grdRecord.set('ORIGIN_Q'			, record['ESTI_QTY']);	
			grdRecord.set('REF_BILL_TYPE'		, masterForm.getValue('BILL_TYPE'));
			grdRecord.set('REF_RECEIPT_SET_METH', masterForm.getValue('RECEIPT_METH'));	
			grdRecord.set('WGT_UNIT'			, record['WGT_UNIT']);	
			grdRecord.set('UNIT_WGT'			, record['UNIT_WGT']);	
			grdRecord.set('VOL_UNIT'			, record['VOL_UNIT']);	
			grdRecord.set('UNIT_VOL'			, record['UNIT_VOL']);

			UniSales.fnGetPriceInfo(grdRecord
									,'R'
									,UserInfo.compCode
									,masterForm.getValue('CUSTOM_CODE')
									,CustomCodeInfo.gsAgentType
									,record['ITEM_CODE']
									,BsaCodeInfo.gsMoneyUnit
									,record['ESTI_UNIT']
									,record['STOCK_UNIT']
									,record['TRANS_RATE']
									,masterForm.getValue('ORDER_DATE')
									,grdRecord.get('ORDER_Q')
									,record['WGT_UNIT']
									,record['VOL_UNIT']
									,record['UNIT_WGT']
									,record['UNIT_VOL']
									,record['PRICE_TYPE']
									);
			
			// 수주수량/단가(중량) 재계산
			var	sUnitWgt   = grdRecord.get('UNIT_WGT');
			var	sOrderWgtQ = grdRecord.set('ORDER_WGT_Q', (grdRecord.get('ORDER_Q') * sUnitWgt));
			
			if( sUnitWgt == 0)	{ 
				grdRecord.set('ORDER_WGT_P'		,0);
			} else {
				grdRecord.set('ORDER_WGT_P', (grdRecord.get('ORDER_P') / sUnitWgt))
			}
			
			// 수주수량/단가(부피) 재계산
			var	sUnitVol   = grdRecord.get('UNIT_VOL');
			var	sOrderVolQ = grdRecord.set('ORDER_VOL_Q', (grdRecord.get('ORDER_Q') * sUnitVol));
			
			if( sUnitVol == 0)	{ 
				grdRecord.set('ORDER_VOL_P'		,0);
			} else {
				grdRecord.set('ORDER_VOL_P', (grdRecord.get('ORDER_P') / sUnitVol))
			}
			
			/*
			 * 
			 * Call top.fraBody1.fnOrderAmtCal(lRow, "Q") Call
			 * top.fraBody1.fnStockQ(lRow) //현재고량 조회
			 */
			
			var dStockQ = 0;
			var dOrderQ = 0;
			var lTrnsRate = grdRecord.get('TRANS_RATE');
			
			if(!Ext.isEmpty(grdRecord.get('STOCK_Q')))	{
				dStockQ = grdRecord.get('STOCK_Q');
			}
			
			if(!Ext.isEmpty(grdRecord.get('ORDER_Q')))	{
				dOrderQ = grdRecord.get('ORDER_Q');
			}
			
			if(dStockQ > 0 )	{
				if(dStockQ > dOrderQ)	{	// '재고량 > 수주량
					grdRecord.set('PROD_SALE_Q'		,0);	
					grdRecord.set('PROD_Q'		,0);	
					grdRecord.set('PROD_END_DATE'		,'');	
				} else {
					if(grdRecord.get('ITEM_ACCOUNT')=="00")	{
						grdRecord.set('PROD_SALE_Q'		,0);	
						grdRecord.set('PROD_Q'		,0);	
						grdRecord.set('PROD_END_DATE'		,'');
					}else {
						if(lTrnsRate > 0 )	{
							grdRecord.set('PROD_SALE_Q'		,((dOrderQ * lTrnsRate - dStockQ) / lTrnsRate));	
							grdRecord.set('PROD_Q'			,(dOrderQ * lTrnsRate - dStockQ ) );	
							grdRecord.set('PROD_END_DATE'		,grdRecord.get('DVRY_DATE'));
						}
					}
				}
			}else {
				if(grdRecord.get('ITEM_ACCOUNT')=="00")	{
						grdRecord.set('PROD_SALE_Q'		,0);	
						grdRecord.set('PROD_Q'		,0);	
						grdRecord.set('PROD_END_DATE'		,'');
					}else {
						if(lTrnsRate > 0 )	{
							grdRecord.set('PROD_SALE_Q'		,dOrderQ);	
							grdRecord.set('PROD_Q'			,(dOrderQ * lTrnsRate ) );	

						}
					}
			}
			
			if(BsaCodeInfo.gsProdtDtAutoYN=='Y')	{
				var dProdtQ = 0;
				if(!Ext.isEmpty(grdRecord.get('PROD_SALE_Q')))	{				
					dProdtQ = grdRecord.get('PROD_SALE_Q');
				}
				
				if(dProdtQ > 0) {
					grdRecord.set('PROD_END_DATE'		,grdRecord.get('DVRY_DATE'));
				}
				
			}
		},
		setRefData: function(record) {
       		var grdRecord = detailGrid.uniOpt.currentRecord;
       
       		grdRecord.set('DIV_CODE'			, record['DIV_CODE']);
			grdRecord.set('ORDER_NUM'			, masterForm.getValue('ORDER_NUM'));
			grdRecord.set('ITEM_CODE'			, record['ITEM_CODE']);	
			grdRecord.set('ITEM_NAME'			, record['ITEM_NAME']);	
			grdRecord.set('ITEM_ACCOUNT'		, record['ITEM_ACCOUNT']);	
			grdRecord.set('SPEC'				, record['SPEC']);	
			grdRecord.set('ORDER_UNIT'			, record['ORDER_UNIT']);	
			grdRecord.set('TRANS_RATE'			, record['TRANS_RATE']);	
			grdRecord.set('ORDER_Q'				, record['ORDER_Q']);	
			grdRecord.set('ORDER_P'				, record['ORDER_P']);	
			grdRecord.set('SCM_FLAG_YN'			, 'N');	
			
			if(masterForm.getValue('TAX_TYPE') != 50)	
			{
				grdRecord.set('TAX_TYPE'		,record['TAX_TYPE']);	
			}
			if(Ext.isEmpty(masterForm.getValue('DVRY_DATE')))	{
				
				grdRecord.set('DVRY_DATE'		,masterForm.getValue('ORDER_DATE'));
			}else {
				grdRecord.set('DVRY_DATE'		,masterForm.getValue('DVRY_DATE'));
			}
			grdRecord.set('DISCOUNT_RATE'		, 0);	
			grdRecord.set('REF_WH_CODE'			, record['WH_CODE']);	
			grdRecord.set('REF_STOCK_CARE_YN'	, record['STOCK_CARE_YN']);	
			grdRecord.set('OUT_DIV_CODE'		, record['OUT_DIV_CODE']);	
			grdRecord.set('STOCK_UNIT'			, record['STOCK_UNIT']);	
			grdRecord.set('ACCOUNT_YNC'			, record['ACCOUNT_YNC']);	
			
			
			if(Ext.isEmpty(masterForm.getValue('SALE_CUST_CD')))	{
				grdRecord.set('SALE_CUST_CD'		,masterForm.getValue('CUSTOM_CODE'));
			}else {
				grdRecord.set('SALE_CUST_CD'		,masterForm.getValue('SALE_CUST_CD'));
			}
			
			if(Ext.isEmpty(masterForm.getValue('SALE_CUST_NM')))	{
				grdRecord.set('CUSTOM_NAME'		,masterForm.getValue('CUSTOM_NAME'));
			}else {
				grdRecord.set('CUSTOM_NAME'		,masterForm.getValue('SALE_CUST_NM'));
			}			
			
			grdRecord.set('DVRY_CUST_CD'		, record['DVRY_CUST_CD']);	
			grdRecord.set('DVRY_CUST_NAME'		, record['DVRY_CUST_NAME']);	
			grdRecord.set('PRICE_YN'			, record['PRICE_YN']);
			grdRecord.set('PROD_PLAN_Q'			, 0);	
			grdRecord.set('DISCOUNT_RATE'		, record['DISCOUNT_RATE']);
			grdRecord.set('PRE_ACCNT_YN'		, record['PRE_ACCNT_YN']);
			grdRecord.set('REF_ORDER_DATE'		, masterForm.getValue('ORDER_DATE'));	
			grdRecord.set('REF_ORD_CUST'		, masterForm.getValue('CUSTOM_CODE'));	
			grdRecord.set('REF_ORDER_TYPE'		, masterForm.getValue('ORDER_TYPE'));
			grdRecord.set('REF_PROJECT_NO'		, masterForm.getValue('PLAN_NUM'));
			grdRecord.set('REF_TAX_INOUT'		, masterForm.getValue('TAX_TYPE').TAX_TYPE);
			// FIXME gsExchageRate값 설정
			// grdRecord.set('REF_EXCHG_RATE_O' ,gsExchageRate);
			grdRecord.set('REF_REMARK'			, masterForm.getValue('REMARK'));
			grdRecord.set('ORIGIN_Q'			, record['ORDER_Q']);	
			grdRecord.set('REF_BILL_TYPE'		, masterForm.getValue('BILL_TYPE'));
			grdRecord.set('REF_RECEIPT_SET_METH', masterForm.getValue('RECEIPT_METH'));	
			grdRecord.set('WGT_UNIT'			, record['WGT_UNIT']);	
			grdRecord.set('UNIT_WGT'			, record['UNIT_WGT']);	
			grdRecord.set('VOL_UNIT'			, record['VOL_UNIT']);	
			grdRecord.set('UNIT_VOL'			, record['UNIT_VOL']);
			
			UniSales.fnGetPriceInfo(grdRecord
									,'R'
									,UserInfo.compCode
									,masterForm.getValue('CUSTOM_CODE')
									,CustomCodeInfo.gsAgentType
									,record['ITEM_CODE']
									,BsaCodeInfo.gsMoneyUnit
									,record['ORDER_UNIT']
									,record['STOCK_UNIT']
									,record['TRANS_RATE']
									,masterForm.getValue('ORDER_DATE')
									,grdRecord.get('ORDER_Q')
									,grdRecord.get('WGT_UNIT')
									,grdRecord.get('VOL_UNIT')
									,grdRecord.get('UNIT_WGT')
									,grdRecord.get('UNIT_VOL')
									,grdRecord.get('PRICE_TYPE')
									);

			UniAppManager.app.fnOrderAmtCal(grdRecord, "Q")
			UniSales.fnStockQ(grdRecord, UserInfo.compCode, record['OUT_DIV_CODE'], null,record['ITEM_CODE'],record['WH_CODE'])	;				
			// FIXME fnStockQ가 실행 후 STOCK_Q 값을 가져온 후 아래 로직을 실행해야 함..
			
			var dStockQ = 0;
			var dOrderQ = 0;
			var lTrnsRate = grdRecord.get('TRANS_RATE');
			
			if(!Ext.isEmpty(grdRecord.get('STOCK_Q')))	{
				dStockQ = grdRecord.get('STOCK_Q');
			}
			
			if(!Ext.isEmpty(grdRecord.get('ORDER_Q')))	{
				dOrderQ = grdRecord.get('ORDER_Q');
			}
			
			if(dStockQ > 0 )	{
				if(dStockQ > dOrderQ)	{	// '재고량 > 수주량
					grdRecord.set('PROD_SALE_Q'		,0);	
					grdRecord.set('PROD_Q'		,0);	
					grdRecord.set('PROD_END_DATE'		,'');	
				} else {
					if(grdRecord.get('ITEM_ACCOUNT')=="00")	{
						grdRecord.set('PROD_SALE_Q'		,0);	
						grdRecord.set('PROD_Q'		,0);	
						grdRecord.set('PROD_END_DATE'		,'');
					}else {
						if(lTrnsRate > 0 )	{
							grdRecord.set('PROD_SALE_Q'		,((dOrderQ * lTrnsRate - dStockQ) / lTrnsRate));	
							grdRecord.set('PROD_Q'			,(dOrderQ * lTrnsRate - dStockQ ) );	
							grdRecord.set('PROD_END_DATE'		,grdRecord.get('DVRY_DATE'));
						}
					}
				}
			}else {
				if(grdRecord.get('ITEM_ACCOUNT')=="00")	{
						grdRecord.set('PROD_SALE_Q'		,0);	
						grdRecord.set('PROD_Q'		,0);	
						grdRecord.set('PROD_END_DATE'		,'');
					}else {
						if(lTrnsRate > 0 )	{
							grdRecord.set('PROD_SALE_Q'		,dOrderQ);	
							grdRecord.set('PROD_Q'			,(dOrderQ * lTrnsRate ) );	

						}
					}
			}
			
			if(BsaCodeInfo.gsProdtDtAutoYN=='Y')	{
				var dProdtQ = 0;
				if(!Ext.isEmpty(grdRecord.get('PROD_SALE_Q')))	{				
					dProdtQ = grdRecord.get('PROD_SALE_Q');
				}
				
				if(dProdtQ > 0) {
					grdRecord.set('PROD_END_DATE'		,grdRecord.get('DVRY_DATE'));
				}
				
			}
       	}
    });
    
    
    var detailGrid2 = Unilite.createGrid('s_pmp100ukrv_kdGrid2', {
    	layout: 'fit',
        region:'center',
        uniOpt: {
			expandLastColumn: true,
			useRowNumberer: false
        },
        
    	store: detailStore2,
        columns: [        			
			{dataIndex: 'LINE_SEQ'        	, width: 100}, 							
			{dataIndex: 'PROG_WORK_CODE'  	, width: 120}, 							
			{dataIndex: 'PROG_WORK_NAME'   	, width: 150}, 								
			{dataIndex: 'PROG_UNIT_Q'     	, width: 120}, 												
			{dataIndex: 'WKORD_Q'         	, width: 140},
			{dataIndex: 'PROG_UNIT'       	, width: 140}, 							
			{dataIndex: 'PROG_RATE'       	, width: 53 , hidden: true}, 													
			{dataIndex: 'DIV_CODE'        	, width: 73 , hidden: true}, 												
			{dataIndex: 'WKORD_NUM'       	, width: 73 , hidden: true},
			{dataIndex: 'WORK_SHOP_CODE'  	, width: 80 , hidden: true}, 							
			{dataIndex: 'PRODT_START_DATE'	, width: 75 , hidden: true}, 	
			{dataIndex: 'PRODT_END_DATE'  	, width: 100, hidden: true},
			{dataIndex: 'PRODT_WKORD_DATE'	, width: 140, hidden: true},
			{dataIndex: 'ITEM_CODE'       	, width: 140, hidden: true}, 							
			{dataIndex: 'REMARK'          	, width: 53 , hidden: true}, 													
			{dataIndex: 'LOT_NO'          	, width: 73 , hidden: true}, 						
			{dataIndex: 'WK_PLAN_NUM'     	, width: 100, hidden: true}, 							
			{dataIndex: 'LINE_End_YN'     	, width: 66 , hidden: true}, 													
			{dataIndex: 'ITEM_NAME'       	, width: 66 , hidden: true}, 												
			{dataIndex: 'SPEC'            	, width: 53 , hidden: true},
			{dataIndex: 'WORK_END_YN'     	, width: 66 , hidden: true}, 							
			{dataIndex: 'TOP_WKORD_NUM'   	, width: 66 , hidden: true}
		],listeners: {	
          		
       	},
		disabledLinkButtons: function(b) {

		},
		setItemData: function(record, dataClear) {
       		var grdRecord = detailGrid.uniOpt.currentRecord;
       		if(dataClear) {
       			grdRecord.set('ITEM_CODE'		,"");
       			grdRecord.set('ITEM_NAME'		,"");
				grdRecord.set('SPEC'			,""); 
				grdRecord.set('ORDER_UNIT'		,"");
				grdRecord.set('STOCK_UNIT'		,"");
				grdRecord.set('ORDER_Q'			,0);
				grdRecord.set('ORDER_P'			,0);
				grdRecord.set('ORDER_WGT_Q'		,0);
				grdRecord.set('ORDER_WGT_P'		,0);
				grdRecord.set('ORDER_VOL_Q'		,0);
				grdRecord.set('ORDER_VOL_P'		,0); 
				grdRecord.set('ORDER_O'			,0);
				grdRecord.set('PROD_SALE_Q'		,0);
				grdRecord.set('PROD_Q'			,0);
				grdRecord.set('STOCK_Q'			,0);
				grdRecord.set('DISCOUNT_RATE'	,0);
				grdRecord.set('WGT_UNIT'		,"");
				grdRecord.set('UNIT_WGT'		,0);
				grdRecord.set('VOL_UNIT'		,"");
				grdRecord.set('UNIT_VOL'		,0);
       		} else {
       			grdRecord.set('ITEM_CODE'			, record['ITEM_CODE']);
       			grdRecord.set('ITEM_NAME'			, record['ITEM_NAME']);
       			grdRecord.set('ITEM_ACCOUNT'		, record['ITEM_ACCOUNT']);
				grdRecord.set('SPEC'				, record['SPEC']); 
				grdRecord.set('ORDER_UNIT'			, record['SALE_UNIT']);
				grdRecord.set('STOCK_UNIT'			, record['STOCK_UNIT']);
				grdRecord.set('REF_WH_CODE'			, record['WH_CODE']);
				grdRecord.set('REF_STOCK_CARE_YN'	, record['STOCK_CARE_YN']);
				// grdRecord.set('OUT_DIV_CODE' ,record['DIV_CODE']);
				grdRecord.set('WGT_UNIT'			, record['WGT_UNIT']);
				grdRecord.set('UNIT_WGT'			, record['UNIT_WGT']);
				grdRecord.set('VOL_UNIT'			, record['VOL_UNIT']);
				grdRecord.set('UNIT_VOL'			, record['UNIT_VOL']);
				grdRecord.set('ORDER_NUM'			, masterForm.getValue('ORDER_NUM'));
				
				UniSales.fnStockQ(grdRecord, UserInfo.compCode, grdRecord.get('OUT_DIV_CODE'), null, grdRecord.get('ITEM_CODE'),  grdRecord.get('REF_WH_CODE'));
       		}
		},
		setEstiData:function(record) {
       		var grdRecord = detailGrid.uniOpt.currentRecord;
       
       		// grdRecord.set('DIV_CODE' , record['DIV_CODE']);
			grdRecord.set('ORDER_NUM'			, masterForm.getValue('ORDER_NUM'));
			grdRecord.set('ITEM_CODE'			, record['ITEM_CODE']);	
			grdRecord.set('ITEM_NAME'			, record['ITEM_NAME']);	
			grdRecord.set('ITEM_ACCOUNT'		, record['ITEM_ACCOUNT']);	
			grdRecord.set('SPEC'				, record['SPEC']);	
			grdRecord.set('ORDER_UNIT'			, record['ESTI_UNIT']);	
			grdRecord.set('TRANS_RATE'			, record['TRANS_RATE']);	
			grdRecord.set('ORDER_Q'				, record['ESTI_QTY']);	
			grdRecord.set('ORDER_P'				, record['ESTI_PRICE']);	
			grdRecord.set('SCM_FLAG_YN'			, 'N');	
			if(masterForm.getValue('TAX_TYPE') != 50)	
			{
				grdRecord.set('TAX_TYPE'		,masterForm.getValue('TAX_TYPE').TAX_TYPE);	
			}
			if(Ext.isEmpty(masterForm.getValue('DVRY_DATE')))	{
				
				grdRecord.set('DVRY_DATE'		,masterForm.getValue('ORDER_DATE'));
			}else {
				grdRecord.set('DVRY_DATE'		,masterForm.getValue('DVRY_DATE'));
			}
			grdRecord.set('DISCOUNT_RATE'		, 0);	
			grdRecord.set('REF_WH_CODE'			, record['WH_CODE']);	
			grdRecord.set('REF_STOCK_CARE_YN'	, record['STOCK_CARE_YN']);	
			grdRecord.set('OUT_DIV_CODE'		, UserInfo.divCode);	
			grdRecord.set('STOCK_UNIT'			, record['STOCK_UNIT']);	
			grdRecord.set('ACCOUNT_YNC'			, 'Y');	
			
			if(Ext.isEmpty(masterForm.getValue('SALE_CUST_CD')))	{
				grdRecord.set('SALE_CUST_CD'		,masterForm.getValue('CUSTOM_CODE'));
			}else {
				grdRecord.set('SALE_CUST_CD'		,masterForm.getValue('SALE_CUST_CD'));
			}
			
			if(Ext.isEmpty(masterForm.getValue('SALE_CUST_NM')))	{
				grdRecord.set('CUSTOM_NAME'		,masterForm.getValue('CUSTOM_NAME'));
			}else {
				grdRecord.set('CUSTOM_NAME'		,masterForm.getValue('SALE_CUST_NM'));
			}
			grdRecord.set('PROD_PLAN_Q'			, 0);	
			grdRecord.set('ESTI_NUM'			, record['ESTI_NUM']);	
			grdRecord.set('ESTI_SEQ'			, record['ESTI_SEQ']);	
			grdRecord.set('REF_ORDER_DATE'		, masterForm.getValue('ORDER_DATE'));	
			grdRecord.set('REF_ORD_CUST'		, masterForm.getValue('CUSTOM_CODE'));	
			grdRecord.set('REF_ORDER_TYPE'		, masterForm.getValue('ORDER_TYPE'));
			grdRecord.set('REF_PROJECT_NO'		, masterForm.getValue('PLAN_NUM'));
			grdRecord.set('REF_TAX_INOUT'		, masterForm.getValue('TAX_TYPE').TAX_TYPE);
			// FIXME gsExchageRate값 설정
			// grdRecord.set('REF_EXCHG_RATE_O' ,gsExchageRate);
			grdRecord.set('REF_REMARK'			, masterForm.getValue('REMARK'));
			grdRecord.set('ORIGIN_Q'			, record['ESTI_QTY']);	
			grdRecord.set('REF_BILL_TYPE'		, masterForm.getValue('BILL_TYPE'));
			grdRecord.set('REF_RECEIPT_SET_METH', masterForm.getValue('RECEIPT_METH'));	
			grdRecord.set('WGT_UNIT'			, record['WGT_UNIT']);	
			grdRecord.set('UNIT_WGT'			, record['UNIT_WGT']);	
			grdRecord.set('VOL_UNIT'			, record['VOL_UNIT']);	
			grdRecord.set('UNIT_VOL'			, record['UNIT_VOL']);

			UniSales.fnGetPriceInfo(grdRecord
									,'R'
									,UserInfo.compCode
									,masterForm.getValue('CUSTOM_CODE')
									,CustomCodeInfo.gsAgentType
									,record['ITEM_CODE']
									,BsaCodeInfo.gsMoneyUnit
									,record['ESTI_UNIT']
									,record['STOCK_UNIT']
									,record['TRANS_RATE']
									,masterForm.getValue('ORDER_DATE')
									,grdRecord.get('ORDER_Q')
									,record['WGT_UNIT']
									,record['VOL_UNIT']
									,record['UNIT_WGT']
									,record['UNIT_VOL']
									,record['PRICE_TYPE']
									);
			
			// 수주수량/단가(중량) 재계산
			var	sUnitWgt   = grdRecord.get('UNIT_WGT');
			var	sOrderWgtQ = grdRecord.set('ORDER_WGT_Q', (grdRecord.get('ORDER_Q') * sUnitWgt));
			
			if( sUnitWgt == 0)	{ 
				grdRecord.set('ORDER_WGT_P'		,0);
			} else {
				grdRecord.set('ORDER_WGT_P', (grdRecord.get('ORDER_P') / sUnitWgt))
			}
			
			// 수주수량/단가(부피) 재계산
			var	sUnitVol   = grdRecord.get('UNIT_VOL');
			var	sOrderVolQ = grdRecord.set('ORDER_VOL_Q', (grdRecord.get('ORDER_Q') * sUnitVol));
			
			if( sUnitVol == 0)	{ 
				grdRecord.set('ORDER_VOL_P'		,0);
			} else {
				grdRecord.set('ORDER_VOL_P', (grdRecord.get('ORDER_P') / sUnitVol))
			}
			
			/*
			 * 
			 * Call top.fraBody1.fnOrderAmtCal(lRow, "Q") Call
			 * top.fraBody1.fnStockQ(lRow) //현재고량 조회
			 */
			
			var dStockQ = 0;
			var dOrderQ = 0;
			var lTrnsRate = grdRecord.get('TRANS_RATE');
			
			if(!Ext.isEmpty(grdRecord.get('STOCK_Q')))	{
				dStockQ = grdRecord.get('STOCK_Q');
			}
			
			if(!Ext.isEmpty(grdRecord.get('ORDER_Q')))	{
				dOrderQ = grdRecord.get('ORDER_Q');
			}
			
			if(dStockQ > 0 )	{
				if(dStockQ > dOrderQ)	{	// '재고량 > 수주량
					grdRecord.set('PROD_SALE_Q'		,0);	
					grdRecord.set('PROD_Q'		,0);	
					grdRecord.set('PROD_END_DATE'		,'');	
				} else {
					if(grdRecord.get('ITEM_ACCOUNT')=="00")	{
						grdRecord.set('PROD_SALE_Q'		,0);	
						grdRecord.set('PROD_Q'		,0);	
						grdRecord.set('PROD_END_DATE'		,'');
					}else {
						if(lTrnsRate > 0 )	{
							grdRecord.set('PROD_SALE_Q'		,((dOrderQ * lTrnsRate - dStockQ) / lTrnsRate));	
							grdRecord.set('PROD_Q'			,(dOrderQ * lTrnsRate - dStockQ ) );	
							grdRecord.set('PROD_END_DATE'		,grdRecord.get('DVRY_DATE'));
						}
					}
				}
			}else {
				if(grdRecord.get('ITEM_ACCOUNT')=="00")	{
						grdRecord.set('PROD_SALE_Q'		,0);	
						grdRecord.set('PROD_Q'		,0);	
						grdRecord.set('PROD_END_DATE'		,'');
					}else {
						if(lTrnsRate > 0 )	{
							grdRecord.set('PROD_SALE_Q'		,dOrderQ);	
							grdRecord.set('PROD_Q'			,(dOrderQ * lTrnsRate ) );	

						}
					}
			}
			
			if(BsaCodeInfo.gsProdtDtAutoYN=='Y')	{
				var dProdtQ = 0;
				if(!Ext.isEmpty(grdRecord.get('PROD_SALE_Q')))	{				
					dProdtQ = grdRecord.get('PROD_SALE_Q');
				}
				
				if(dProdtQ > 0) {
					grdRecord.set('PROD_END_DATE'		,grdRecord.get('DVRY_DATE'));
				}
				
			}
		},
		setRefData: function(record) {
       		var grdRecord = detailGrid.uniOpt.currentRecord;
       
       		grdRecord.set('DIV_CODE'			, record['DIV_CODE']);
			grdRecord.set('ORDER_NUM'			, masterForm.getValue('ORDER_NUM'));
			grdRecord.set('ITEM_CODE'			, record['ITEM_CODE']);	
			grdRecord.set('ITEM_NAME'			, record['ITEM_NAME']);	
			grdRecord.set('ITEM_ACCOUNT'		, record['ITEM_ACCOUNT']);	
			grdRecord.set('SPEC'				, record['SPEC']);	
			grdRecord.set('ORDER_UNIT'			, record['ORDER_UNIT']);	
			grdRecord.set('TRANS_RATE'			, record['TRANS_RATE']);	
			grdRecord.set('ORDER_Q'				, record['ORDER_Q']);	
			grdRecord.set('ORDER_P'				, record['ORDER_P']);	
			grdRecord.set('SCM_FLAG_YN'			, 'N');	
			
			if(masterForm.getValue('TAX_TYPE') != 50)	
			{
				grdRecord.set('TAX_TYPE'		,record['TAX_TYPE']);	
			}
			if(Ext.isEmpty(masterForm.getValue('DVRY_DATE')))	{
				
				grdRecord.set('DVRY_DATE'		,masterForm.getValue('ORDER_DATE'));
			}else {
				grdRecord.set('DVRY_DATE'		,masterForm.getValue('DVRY_DATE'));
			}
			grdRecord.set('DISCOUNT_RATE'		, 0);	
			grdRecord.set('REF_WH_CODE'			, record['WH_CODE']);	
			grdRecord.set('REF_STOCK_CARE_YN'	, record['STOCK_CARE_YN']);	
			grdRecord.set('OUT_DIV_CODE'		, record['OUT_DIV_CODE']);	
			grdRecord.set('STOCK_UNIT'			, record['STOCK_UNIT']);	
			grdRecord.set('ACCOUNT_YNC'			, record['ACCOUNT_YNC']);	
			
			
			if(Ext.isEmpty(masterForm.getValue('SALE_CUST_CD')))	{
				grdRecord.set('SALE_CUST_CD'		,masterForm.getValue('CUSTOM_CODE'));
			}else {
				grdRecord.set('SALE_CUST_CD'		,masterForm.getValue('SALE_CUST_CD'));
			}
			
			if(Ext.isEmpty(masterForm.getValue('SALE_CUST_NM')))	{
				grdRecord.set('CUSTOM_NAME'		,masterForm.getValue('CUSTOM_NAME'));
			}else {
				grdRecord.set('CUSTOM_NAME'		,masterForm.getValue('SALE_CUST_NM'));
			}			
			
			grdRecord.set('DVRY_CUST_CD'		, record['DVRY_CUST_CD']);	
			grdRecord.set('DVRY_CUST_NAME'		, record['DVRY_CUST_NAME']);	
			grdRecord.set('PRICE_YN'			, record['PRICE_YN']);
			grdRecord.set('PROD_PLAN_Q'			, 0);	
			grdRecord.set('DISCOUNT_RATE'		, record['DISCOUNT_RATE']);
			grdRecord.set('PRE_ACCNT_YN'		, record['PRE_ACCNT_YN']);
			grdRecord.set('REF_ORDER_DATE'		, masterForm.getValue('ORDER_DATE'));	
			grdRecord.set('REF_ORD_CUST'		, masterForm.getValue('CUSTOM_CODE'));	
			grdRecord.set('REF_ORDER_TYPE'		, masterForm.getValue('ORDER_TYPE'));
			grdRecord.set('REF_PROJECT_NO'		, masterForm.getValue('PLAN_NUM'));
			grdRecord.set('REF_TAX_INOUT'		, masterForm.getValue('TAX_TYPE').TAX_TYPE);
			// FIXME gsExchageRate값 설정
			// grdRecord.set('REF_EXCHG_RATE_O' ,gsExchageRate);
			grdRecord.set('REF_REMARK'			, masterForm.getValue('REMARK'));
			grdRecord.set('ORIGIN_Q'			, record['ORDER_Q']);	
			grdRecord.set('REF_BILL_TYPE'		, masterForm.getValue('BILL_TYPE'));
			grdRecord.set('REF_RECEIPT_SET_METH', masterForm.getValue('RECEIPT_METH'));	
			grdRecord.set('WGT_UNIT'			, record['WGT_UNIT']);	
			grdRecord.set('UNIT_WGT'			, record['UNIT_WGT']);	
			grdRecord.set('VOL_UNIT'			, record['VOL_UNIT']);	
			grdRecord.set('UNIT_VOL'			, record['UNIT_VOL']);
			
			UniSales.fnGetPriceInfo(grdRecord
									,'R'
									,UserInfo.compCode
									,masterForm.getValue('CUSTOM_CODE')
									,CustomCodeInfo.gsAgentType
									,record['ITEM_CODE']
									,BsaCodeInfo.gsMoneyUnit
									,record['ORDER_UNIT']
									,record['STOCK_UNIT']
									,record['TRANS_RATE']
									,masterForm.getValue('ORDER_DATE')
									,grdRecord.get('ORDER_Q')
									,grdRecord.get('WGT_UNIT')
									,grdRecord.get('VOL_UNIT')
									,grdRecord.get('UNIT_WGT')
									,grdRecord.get('UNIT_VOL')
									,grdRecord.get('PRICE_TYPE')
									);

			UniAppManager.app.fnOrderAmtCal(grdRecord, "Q")
			UniSales.fnStockQ(grdRecord, UserInfo.compCode, record['OUT_DIV_CODE'], null,record['ITEM_CODE'],record['WH_CODE'])	;				
			// FIXME fnStockQ가 실행 후 STOCK_Q 값을 가져온 후 아래 로직을 실행해야 함..
			
			var dStockQ = 0;
			var dOrderQ = 0;
			var lTrnsRate = grdRecord.get('TRANS_RATE');
			
			if(!Ext.isEmpty(grdRecord.get('STOCK_Q')))	{
				dStockQ = grdRecord.get('STOCK_Q');
			}
			
			if(!Ext.isEmpty(grdRecord.get('ORDER_Q')))	{
				dOrderQ = grdRecord.get('ORDER_Q');
			}
			
			if(dStockQ > 0 )	{
				if(dStockQ > dOrderQ)	{	// '재고량 > 수주량
					grdRecord.set('PROD_SALE_Q'		,0);	
					grdRecord.set('PROD_Q'		,0);	
					grdRecord.set('PROD_END_DATE'		,'');	
				} else {
					if(grdRecord.get('ITEM_ACCOUNT')=="00")	{
						grdRecord.set('PROD_SALE_Q'		,0);	
						grdRecord.set('PROD_Q'		,0);	
						grdRecord.set('PROD_END_DATE'		,'');
					}else {
						if(lTrnsRate > 0 )	{
							grdRecord.set('PROD_SALE_Q'		,((dOrderQ * lTrnsRate - dStockQ) / lTrnsRate));	
							grdRecord.set('PROD_Q'			,(dOrderQ * lTrnsRate - dStockQ ) );	
							grdRecord.set('PROD_END_DATE'		,grdRecord.get('DVRY_DATE'));
						}
					}
				}
			}else {
				if(grdRecord.get('ITEM_ACCOUNT')=="00")	{
						grdRecord.set('PROD_SALE_Q'		,0);	
						grdRecord.set('PROD_Q'		,0);	
						grdRecord.set('PROD_END_DATE'		,'');
					}else {
						if(lTrnsRate > 0 )	{
							grdRecord.set('PROD_SALE_Q'		,dOrderQ);	
							grdRecord.set('PROD_Q'			,(dOrderQ * lTrnsRate ) );	

						}
					}
			}
			
			if(BsaCodeInfo.gsProdtDtAutoYN=='Y')	{
				var dProdtQ = 0;
				if(!Ext.isEmpty(grdRecord.get('PROD_SALE_Q')))	{				
					dProdtQ = grdRecord.get('PROD_SALE_Q');
				}
				
				if(dProdtQ > 0) {
					grdRecord.set('PROD_END_DATE'		,grdRecord.get('DVRY_DATE'));
				}
				
			}
       }
    });
    
    
    // 생산계획 참조
    var productionPlanSearch = Unilite.createSearchForm('productionPlanForm', {
            layout :  {type : 'uniTable', columns : 2},
			    items: [{
		        	fieldLabel: '사업장',
		        	name: 'DIV_CODE',
		        	xtype: 'uniCombobox', 
		        	comboType: 'BOR120',
		        	hidden:true
		        },{
		        	fieldLabel: '작업장',
		        	name: 'WORK_SHOP_CODE',
		        	xtype: 'uniCombobox', 
		        	store: Ext.data.StoreManager.lookup('wsList')
		        },{
		        	fieldLabel: '계획일자', 
		            xtype: 'uniDateRangefield',   
		            startFieldName: 'PRODT_PLAN_DATE_FR',
					endFieldName: 'PRODT_PLAN_DATE_TO',
		            width: 315,
		            startDate: UniDate.get('startOfMonth'),
		            endDate: UniDate.get('today'),
		        	allowBlank:false
				},
					Unilite.popup('DIV_PUMOK',{
						fieldLabel: '품목',
						validateBlank:false,
						valueFieldName: 'ITEM_CODE',
		        		textFieldName:'ITEM_NAME'
			})]
	});		
    
    Unilite.defineModel('s_pmp100ukrv_kdProductionPlanModel', {
    	fields: [ 	 
	    	{name: 'GUBUN'        			, text: '선택'			    , type: 'string'},
	    	{name: 'DIV_CODE'				, text: '제조처'			, type: 'string'},
			{name: 'WORK_SHOP_CODE'			, text: '작업장'			, type: 'string'},
			{name: 'WK_PLAN_NUM'			, text: '생산계획번호'		, type: 'string'},
			{name: 'ITEM_CODE' 				, text: '품목'			    , type: 'string'},
			{name: 'ITEM_NAME' 				, text: '품목명'			, type: 'string'},
			{name: 'SPEC' 					, text: '규격'			    , type: 'string'},
			{name: 'STOCK_UNIT'				, text: '단위'			    , type: 'string'},
			{name: 'WK_PLAN_Q' 				, text: '계획량'			, type: 'uniQty'},
			{name: 'PRODUCT_LDTIME'			, text: '제조L/T'			, type: 'string'},
			{name: 'PRODT_START_DATE'		, text: '착수예정일'		, type: 'uniDate'},
			{name: 'PRODT_PLAN_DATE'		, text: '계획완료일'		, type: 'uniDate'},
			{name: 'ORDER_NUM'	 			, text: '수주번호'			, type: 'string'},
			{name: 'ORDER_DATE' 			, text: '수주일'			, type: 'string'},
			{name: 'ORDER_Q' 				, text: '수주량'			, type: 'uniQty'},
			{name: 'CUSTOM_CODE'	 		, text: '거래처명'			, type: 'string'},
			{name: 'DVRY_DATE' 				, text: '납기일'			, type: 'uniDate'},
			{name: 'PROJECT_NO' 			, text: '프로젝트번호'		, type: 'string'},
			{name: 'PJT_CODE' 				, text: '프로젝트번호'		, type: 'string'}
		]
	});	
    
	var productionPlanStore = Unilite.createStore('s_pmp100ukrv_kdProductionPlanStore', {
			model: 's_pmp100ukrv_kdProductionPlanModel',
            autoLoad: false,
            uniOpt : {
            	isMaster: false,			// 상위 버튼 연결
            	editable: false,			// 수정 모드 사용
            	deletable:false,			// 삭제 가능 여부
	            useNavi : false			// prev | newxt 버튼 사용
            },
            proxy: {
                type: 'direct',
                api: {
                	read    : 's_pmp100ukrv_kdService.selectEstiList'
                }
            },
            listeners:{
            	load:function(store, records, successful, eOpts)	{
            			if(successful)	{
            			   var masterRecords = detailStore.data.filterBy(detailStore.filterNewOnly);  
            			   var estiRecords = new Array();
            			   
            			   if(masterRecords.items.length > 0)	{
            			   	console.log("store.items :", store.items);
            			   	console.log("records", records);
            			   	
	            			   Ext.each(records, 
	            			   			function(item, i)	{           			   								
			   								Ext.each(masterRecords.items, function(record, i)	{
			   										console.log("record :", record);
			   										
			   										if( (record.data['ESTI_NUM'] == item.data['ESTI_NUM']) 
			   											&& (record.data['ESTI_SEQ'] == item.data['ESTI_SEQ'])
			   											)	
			   										{
			   												estiRecords.push(item);
			   										}
			   								});
	            			   								
	            			   			});
	            			   store.remove(estiRecords);
            			   }
            			}
            	}
            }
            ,loadStoreRecords : function()	{
				var param= productionPlanSearch.getValues();			
				console.log( param );
				this.load({
					params : param
				});
			}
	});
	
	
	var productionPlanGrid = Unilite.createGrid('s_pmp100ukrv_kdproductionPlanGrid', {
    	layout : 'fit',
    	store: productionPlanStore,
    	selModel :   Ext.create('Ext.selection.CheckboxModel', { checkOnly : true, toggleOnClick:false }), 
			uniOpt:{
	        	onLoadSelectFirst : false
	        },
        columns: [
        	{dataIndex: 'GUBUN'        		      	, width:0  ,hidden: true},
			{dataIndex: 'DIV_CODE'			      	, width:0  ,hidden: true},
	        {dataIndex: 'WORK_SHOP_CODE'		    , width:100},
	        {dataIndex: 'WK_PLAN_NUM'		      	, width:100,hidden: true},
	        {dataIndex: 'ITEM_CODE' 			    , width:100},
	        {dataIndex: 'ITEM_NAME' 			    , width:126},
	        {dataIndex: 'SPEC' 				      	, width:120},
	        {dataIndex: 'STOCK_UNIT'			    , width:40},
	        {dataIndex: 'WK_PLAN_Q' 			    , width:73},
	        {dataIndex: 'PRODUCT_LDTIME'		    , width:53},
	        {dataIndex: 'PRODT_START_DATE'      	, width:73},
	        {dataIndex: 'PRODT_PLAN_DATE'	      	, width:73},
	        {dataIndex: 'ORDER_NUM'	 		      	, width:93},
	        {dataIndex: 'ORDER_DATE' 		      	, width:73},
	        {dataIndex: 'ORDER_Q' 			      	, width:73},
	        {dataIndex: 'CUSTOM_CODE'	       		, width:100},
	        {dataIndex: 'DVRY_DATE' 			    , width:73 ,hidden: true},
	        {dataIndex: 'PROJECT_NO' 		      	, width:80 ,hidden: true},
	        {dataIndex: 'PJT_CODE' 			      	, width:80 ,hidden: true}		
		],
		listeners: {
	          onGridDblClick: function(grid, record, cellIndex, colName) {
		          	this.returnData(record);
		          	//detailGrid.getStore().setProxy(directProxy3);  /* proxy 변경 후 조회 */ 
		          	detailGrid.getStore().loadStoreRecords();
		          	referProductionPlanWindow.hide();
	          }
          },
          	returnData: function(record)	{
	          	if(Ext.isEmpty(record))	{
	          		record = this.getSelectedRecord();
	          	}
	          	masterForm.setValues({'DIV_CODE':record.get('DIV_CODE'),   /*사업장*/		  'WKORD_NUM':record.get('WKORD_NUM'),  			 /*작업지시번호*/
	          						  'WORK_SHOP_CODE':record.get('WORK_SHOP_CODE'), /* 작업장*/'ITEM_CODE':record.get('ITEM_CODE'),				 /*품목코드*/
	          						  'ITEM_NAME':record.get('ITEM_NAME'),	/*품목명*/		  'SPEC':record.get('SPEC'), 						 /*규격*/
	          						  'PRODT_START_DATE':record.get('PRODT_START_DATE'),
	          						  'PRODT_END_DATE':record.get('PRODT_PLAN_DATE'),		  'LOT_NO':record.get('LOT_NO'),
	          						  'WKORD_Q':record.get('WK_PLAN_Q'),					  'PROG_UNIT':record.get('STOCK_UNIT'),
	          						  'PROJECT_NO':record.get('PROJECT_NO'),				  'ANSWER':record.get('REMARK'),
	          						  'PJT_CODE':record.get('PJT_CODE'),					  'WORK_END_YN':record.get('WORK_END_YN'),
	          						  'ORDER_NUM':record.get('ORDER_NUM'), 	/* 수주번호*/		  'ORDER_Q':record.get('ORDER_Q'),  				/* 수주량*/
	          						  'DVRY_DATE':record.get('DVRY_DATE'),  /* 납기일*/		  'CUSTOM':record.get('CUSTOM_CODE'),
	          						  /*'REWORK_YN':record.get('REWORK_YN'),*/				  'PROG_UNIT':record.get('STOCK_UNIT'),
	          						  'EXCHG_TYPE':record.get('STOCK_EXCHG_TYPE')
	          						  });
	          	
	          						  
				panelResult.setValues({'ITEM_CODE':record.get('ITEM_CODE'),	/*품목*/		 'ITEM_NAME':record.get('ITEM_NAME'),  
									   'PROJECT_NO':record.get('PROJECT_NO'),			 'LOT_NO':record.get('LOT_NO'),
									   'PJT_CODE':record.get('PJT_CODE'),				 'WORK_END_YN':record.get('WORK_END_YN'),
									   'WKORD_Q':record.get('WK_PLAN_Q'),				 'PRODT_START_DATE':record.get('PRODT_START_DATE')
	          						   });

	          						   
	          						   
	          	masterForm.getField('DIV_CODE').setReadOnly( true );
				masterForm.getField('WORK_SHOP_CODE').setReadOnly( true );
				masterForm.getField('ITEM_CODE').setReadOnly( true );
				masterForm.getField('ITEM_NAME').setReadOnly( true );
				masterForm.getField('SPEC').setReadOnly( true );
				masterForm.getField('PROG_UNIT').setReadOnly( true );
				
				
				panelResult.getField('DIV_CODE').setReadOnly( true );
				panelResult.getField('WORK_SHOP_CODE').setReadOnly( true );
				panelResult.getField('ITEM_CODE').setReadOnly( true );
				panelResult.getField('ITEM_NAME').setReadOnly( true );
				panelResult.getField('SPEC').setReadOnly( true );
				panelResult.getField('PROG_UNIT').setReadOnly( true );
          }	
         
    });

    
	function openProductionPlanWindow() {    		
  		//if(!UniAppManager.app.checkForNewDetail()) return false;
		
		
		productionPlanSearch.setValue('DIV_CODE', masterForm.getValue('DIV_CODE'));

		if(!referProductionPlanWindow) {
			referProductionPlanWindow = Ext.create('widget.uniDetailWindow', {
                title: '생산계획정보',
                width: 830,				                
                height: 580,
                layout:{type:'vbox', align:'stretch'},
                
                items: [productionPlanSearch, productionPlanGrid],
                tbar:  ['->',
								        {	itemId : 'saveBtn',
											text: '조회',
											handler: function() {
												productionPlanStore.loadStoreRecords();
											},
											disabled: false
										}, 
										{	itemId : 'confirmBtn',
											text: '수주적용',
											handler: function() {
												productionPlanGrid.returnData();
											},
											disabled: false
										},
										{	itemId : 'confirmCloseBtn',
											text: '수주적용 후 닫기',
											handler: function() {
												productionPlanGrid.returnData();
												referProductionPlanWindow.hide();
											},
											disabled: false
										},{
											itemId : 'closeBtn',
											text: '닫기',
											handler: function() {
												referProductionPlanWindow.hide();
											},
											disabled: false
										}
							    ]
							,
                listeners : {beforehide: function(me, eOpt)	{
                							// requestSearch.clearForm();
                							// requestGrid,reset();
                						},
                			 beforeclose: function( panel, eOpts )	{
											// requestSearch.clearForm();
                							// requestGrid,reset();
                			 			},
                			 beforeshow: function ( me, eOpts )	{
                			 	productionPlanStore.loadStoreRecords();
                			 }
                }
			})
		}
		
		referProductionPlanWindow.show();
    }
    
      Unilite.Main ({
		borderItems: [{
         	region:'center',
         	layout: 'border',
         	border: false,
         	items:[
           		panelResult, detailGrid, detailGrid2
         	]	
      	},
      	masterForm     
      	],
		id: 's_pmp100ukrv_kdApp',
		fnInitBinding: function() {
			UniAppManager.setToolbarButtons(['reset'], true);
			UniAppManager.setToolbarButtons(['query', 'newData'], false);
			detailGrid.disabledLinkButtons(false);
			
			this.setDefault();
		},
		onQueryButtonDown: function() {
			detailGrid.getStore().loadStoreRecords();
			detailGrid2.getStore().loadStoreRecords();
		},	
		onNewDataButtonDown: function()	{
		},
		onResetButtonDown: function() {
			masterForm.clearForm();
			panelResult.clearForm();
			masterForm.setAllFieldsReadOnly(false);
			panelResult.setAllFieldsReadOnly(false);
			detailGrid.reset();
			detailGrid2.reset();
			this.fnInitBinding();
			//masterForm.getField('CUSTOM_CODE').focus();
		},
		onSaveDataButtonDown: function(config) {
			var orderNo = masterForm.getValue('ORDER_NUM');
			if(Ext.isEmpty(orderNo)) {
				if(detailStore.data.length == 0) {
					alert('수주상세정보를 입력하세요.');
					return;
				}
			}
			
			/**
			 * 여신한도 확인
			 */ 
			if(!masterForm.fnCreditCheck())	{
				return ;
			}
			
			/*
			 * syncAll 수정 var param= masterForm.getValues();
			 * masterForm.getForm().submit({ params : param, success :
			 * function(form, action) {
			 * 
			 * masterForm.setValue("ORDER_NUM", action.result.ORDER_NUM);
			 * if(detailStore.isDirty()) { detailStore.saveStore(config); }else {
			 * masterForm.getForm().wasDirty = false;
			 * masterForm.resetDirtyStatus();
			 * UniAppManager.setToolbarButtons('save', false);
			 * 
			 * UniAppManager.updateStatus(Msg.sMB011);// "저장되었습니다.");
			 * 
			 * Ext.getBody().unmask(); }
			 *  } });
			 */
			
			detailStore.saveStore();
		},
		onDeleteDataButtonDown: function() {
			var selRow = detailGrid.getSelectedRecord();
			if(selRow.phantom === true)	{
				detailGrid.deleteSelectedRow();
			}else if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
				if(selRow.get('ISSUE_REQ_Q') > 0 || selRow.get('OUTSTOCK_Q') > 0 ) {
					alert('<t:message code="unilite.msg.sMS216" default="출고가 진행중인 수주내역은 삭제가 불가능합니다."/>');
				}else {
					detailGrid.deleteSelectedRow();
				}
			}
			// fnOrderAmtSum 호출(grid summary 이용)
		},
		onDetailButtonDown: function() {
			var as = Ext.getCmp('s_pmp100ukrv_kdAdvanceSerch');	
			if(as.isHidden())	{
				as.show();
			} else {
				as.hide()
			}
		},
		rejectSave: function() {
			var rowIndex = detailGrid.getSelectedRowIndex();
			detailGrid.select(rowIndex);
			detailStore.rejectChanges();
			
			if(rowIndex >= 0){
				detailGrid.getSelectionModel().select(rowIndex);
				var selected = detailGrid.getSelectedRecord();
				
				var selected_doc_no = selected.data['DOC_NO'];
  				bdc100ukrvService.getFileList(
					{DOC_NO : selected_doc_no},
					function(provider, response) {															
					}
				);
			}
			detailStore.onStoreActionEnable();

		},
		confirmSaveData: function(config)	{
			var fp = Ext.getCmp('s_pmp100ukrv_kdFileUploadPanel');
        	if(detailStore.isDirty() || fp.isDirty())	{
				if(confirm(Msg.sMB061))	{
					this.onSaveDataButtonDown(config);
				} else {
					this.rejectSave();
				}
			}
		},
		setDefault: function() {
        	masterForm.setValue('DIV_CODE',UserInfo.divCode);
        	masterForm.setValue('ORDER_DATE',new Date());
        	masterForm.setValue('TAX_TYPE','1');
        	masterForm.setValue('STATUS','1');
        	
        	masterForm.setValue('START_WKORD_DATE',new Date());
        	masterForm.setValue('PRODT_START_DATE',new Date());
        	masterForm.setValue('PRODT_END_DATE',new Date());
        	masterForm.setValue('WKORD_Q',0);
        	
        	panelResult.setValue('START_WKORD_DATE',new Date());
        	panelResult.setValue('PRODT_START_DATE',new Date());
        	panelResult.setValue('PRODT_END_DATE',new Date());
        	panelResult.setValue('WKORD_Q',0);
        	
        	
        	masterForm.getField('DIV_CODE').setReadOnly( false );
			masterForm.getField('WORK_SHOP_CODE').setReadOnly( false );
			masterForm.getField('ITEM_CODE').setReadOnly( false );
			masterForm.getField('ITEM_NAME').setReadOnly( false );
			
			panelResult.getField('DIV_CODE').setReadOnly( false );
			panelResult.getField('WORK_SHOP_CODE').setReadOnly( false );
			panelResult.getField('ITEM_CODE').setReadOnly( false );
			panelResult.getField('ITEM_NAME').setReadOnly( false );
        	
			masterForm.getForm().wasDirty = false;
			masterForm.resetDirtyStatus();											
			UniAppManager.setToolbarButtons('save', false);	
		},
        checkForNewDetail:function() { 
			if(BsaCodeInfo.gsAutoType=='N' && Ext.isEmpty(masterForm.getValue('CUSTOM_CODE')))	{
				alert('<t:message code="unilite.msg.sMSR213" default="거래처"/>:<t:message code="unilite.msg.sMB083" default="필수입력값입니다."/>');
				return false;
			}
			
			/**
			 * 여신한도 확인
			 */ 
			if(!masterForm.fnCreditCheck())	{
				return false;
			}
			
			/**
			 * 마스터 데이타 수정 못 하도록 설정
			 */
			return masterForm.setAllFieldsReadOnly(true);
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