<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="asc105skr"  >
	<t:ExtComboStore comboType="BOR120" pgmId="asc105skr" /> 	<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="A035" /> 		<!-- 완료여부-->
	<t:ExtComboStore comboType="AU" comboCode="B031" /> 		<!-- 수불생성경로-->
	<t:ExtComboStore comboType="AU" comboCode="CBM600" /> 		<!-- Cost Pool-->
<style type="text/css">

#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>	
</t:appConfig>
<script type="text/javascript" >

function appMain() {

	
	/** Tik110skrvModel_Jack_20170424 **/
	Unilite.defineModel('Tik110skrvModel', {
	    fields: [
	    	{name: 'EXPORTER_NM' 			,text: '<t:message code="system.label.trade.exporter" default="수출자"/>' 			,type: 'string'},
	    	{name: 'NEGO_SER_NO' 			,text: '관리번호' 			,type: 'string'},
	    	{name: 'PAY_DATE' 				,text: '지급일' 			,type: 'uniDate'},
	    	{name: 'TERMS_PRICE' 			,text: '<t:message code="system.label.trade.pricecondition" default="가격조건 "/>' 			,type: 'string'},
	    	{name: 'PAY_METHODE' 			,text: '<t:message code="system.label.trade.payingterm" default="결제방법"/>' 			,type: 'string'},
	    	{name: 'PAY_BANK' 				,text: '지급은행' 			,type: 'string'},
	    	{name: 'PAY_NM' 				,text: '담담자' 			,type: 'string'},
	    	{name: 'COLET_TYPE' 			,text: '지급유형' 			,type: 'string'},
	    	{name: 'PAY_AMT' 				,text: '지급액' 			,type: 'uniPrice'},
	    	{name: 'MONEY_UNIT' 			,text: '<t:message code="system.label.trade.currency" default="화폐 "/>' 				,type: 'string'},
	    	{name: 'PAY_EXCHANGE_RATE' 		,text: '<t:message code="system.label.trade.exchangerate" default="환율"/>' 				,type: 'uniER'},
	    	{name: 'PAY_AMT_WON' 			,text: '원화금액' 			,type: 'uniPrice'},
	    	{name: 'BL_SER_NO' 				,text: '선적번호' 			,type: 'string'},
	    	{name: 'DIV_NAME' 				,text: '<t:message code="system.label.trade.division" default="사업장"/>' 			,type: 'string'}
			]
	});
	
	/* tik110skrvStore
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var masterStore = Unilite.createStore('asc105skrmasterStore',{
		//model: 'Asc105skrModel',
		model: 'Tik110skrvModel',
		uniOpt : {
        	isMaster:	true,			// 상위 버튼 연결 
        	editable:	false,			// 수정 모드 사용 
        	deletable:	false,			// 삭제 가능 여부 
            useNavi:	false			// prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: {
            type: 'direct',
            api: {			
            	   read: 'tik110skrService.selectList'
            }
        },
        loadStoreRecords : function()	{
			var param= Ext.getCmp('searchForm').getValues();			
			this.load({
				params : param
			});
		},
		listeners: {
          	load: function(store, records, successful, eOpts) {
          		var viewLocked = masterGrid.lockedGrid.getView();
				var viewNormal = masterGrid.normalGrid.getView();
				//조회된 데이터가 있을 때, 합계 보이게 설정 / 그리드에 포커스 가도록 변경
				if(store.getCount() > 0){
		   	 		viewLocked.getFeature('masterGridSubTotal').toggleSummaryRow(true);
		   	 		viewLocked.getFeature('masterGridTotal').toggleSummaryRow(true);
		    		viewNormal.getFeature('masterGridSubTotal').toggleSummaryRow(true);
		    		viewNormal.getFeature('masterGridTotal').toggleSummaryRow(true);

		    		masterGrid.focus();
				//조회된 데이터가 없을 때, 합계 안 보이게 설정 / 패널의 첫번째 필드에 포커스 가도록 변경
	    		}else{
					viewLocked.getFeature('masterGridSubTotal').toggleSummaryRow(false);
					viewLocked.getFeature('masterGridTotal').toggleSummaryRow(false);
		    		viewNormal.getFeature('masterGridSubTotal').toggleSummaryRow(false);	
		    		viewNormal.getFeature('masterGridTotal').toggleSummaryRow(false);
					
					var activeSForm ;		
					if(!UserInfo.appOption.collapseLeftSearch)	{	
						activeSForm = panelSearch;	
					}else {		
						activeSForm = panelResult;	
					}		
					activeSForm.onLoadSelectText('FR_DATE');
				}
          	}          		
      	}
	});
	
	/* tik110skrv
	 * 검색조건 (Search Panel)
	 * @type 
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm', {		
		title: '<t:message code="system.label.trade.searchconditon" default="검색조건"/>',
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
			title: '<t:message code="system.label.trade.basisinfo" default="기본정보"/>', 	
   			itemId: 'search_panel1',
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',
		    items : [{
		        fieldLabel: '<t:message code="system.label.trade.division" default="사업장"/>',
		        labelWidth:100, 
			    name:'DIV_CODE',
			    xtype: 'uniCombobox',
				value:UserInfo.divCode,
				comboType:'BOR120',
	//		    width: 325,
			    listeners: {
					change: function(field, newValue, oldValue, eOpts) {      
						/*panelSearch.setValue('ACCNT_DIV_CODE', newValue);*/
						//tik//
						panelResult.setValue('DIV_CODE', newValue);
					}
	     		}
			},{ 
    			fieldLabel: '지급일',
		        xtype: 'uniDateRangefield',
		        labelWidth:100, 
		      	startFieldName: 'FR_DATE',
		        //tik//
		        endFieldName: 'TO_DATE',
				allowBlank: false,
				tdAttrs: {width: 380},
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelResult) {
						/*panelSearch.setValue('DVRY_DATE_FR',newValue);*/
						//tik//
						panelResult.setValue('FR_DATE',newValue);
                	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelResult) {
			    		/*panelSearch.setValue('DVRY_DATE_TO',newValue);*/
			    		//tik//
			    		panelResult.setValue('TO_DATE',newValue);
			    	}
			    }
	        },{
		        fieldLabel: '담담자',
		      	name:'EXPORT_NM', 
			    xtype: 'uniCombobox',
				comboType: 'AU', 
				labelWidth:100, 
				comboCode: 'S010',
			    listeners: {
					change: function(field, newValue, oldValue, eOpts) {      
						/*panelSearch.setValue('ACCNT_DIV_CODE', newValue);*/
						//tik//
						panelResult.setValue('EXPORT_NM', newValue);
					}
	     		}
			},{
				fieldLabel: '수입대금관리번호',
				name: 'NEGO_SER_NO',
				xtype: 'uniTextfield',
				labelWidth:100, 
				readOnly: false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('NEGO_SER_NO', panelSearch.getValue('NEGO_SER_NO'));
					}
				}
			},Unilite.popup('AGENT_CUST', {
				fieldLabel: '<t:message code="system.label.trade.exporter" default="수출자"/>',
				valueFieldName: 'EXPORTER', //EXPORTER
				textFieldName: 'EXPORTER_NM', 
				textFieldWidth:175, 
				labelWidth:100, 
				holdable: 'hold',
				validateBlank:false, 
				popupWidth: 710,
				listeners: {
							onValueFieldChange:function( elm, newValue, oldValue) {						
								panelResult.setValue('EXPORTER', newValue);
								
								if(!Ext.isObject(oldValue)) {
									panelResult.setValue('EXPORTER_NM', '');
									panelSearch.setValue('EXPORTER_NM', '');
								}
							},
							onTextFieldChange:function( elm, newValue, oldValue) {
								panelResult.setValue('EXPORTER_NM', newValue);
								
								if(!Ext.isObject(oldValue)) {
									panelResult.setValue('EXPORTER', '');
									panelSearch.setValue('EXPORTER', '');
								}
							}
						}
			}),{
				fieldLabel: '지급유형',
				xtype: 'uniCombobox',
				name: 'COLET_TYPE',
				comboType: 'AU', 
				comboCode: 'T060',
				labelWidth:100, 
	        	listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						/*panelSearch.setValue('DPR_STS', newValue);*/
						//tik//
						panelResult.setValue('COLET_TYPE', newValue);
					}
				}
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
					} else {
					//	this.mask();		    
	   				}
		  		} else {
  					this.unmask();
  				}
				return r;
  			}
	});  
	
	/**tik110skrv_Jack_20170424**/
	var panelResult = Unilite.createSearchForm('panelResultForm', {		
		region: 'north',
		layout : {type : 'uniTable', columns : 3
//		,tableAttrs: {style: 'border : 1px solid #ced9e7;'/*, width: '100%'*/},
//			tdAttrs: {style: 'border : 1px solid #ced9e7;'/*, align : 'center'*/}
		},
		padding:'1 1 1 1',
		border:true,
		items : [{
		        fieldLabel: '<t:message code="system.label.trade.division" default="사업장"/>',
			    name:'DIV_CODE',
			    xtype: 'uniCombobox',
				labelWidth:100, 
				value:UserInfo.divCode,
				comboType:'BOR120',
	//		    width: 325,
			    listeners: {
					change: function(field, newValue, oldValue, eOpts) {      
						/*panelSearch.setValue('ACCNT_DIV_CODE', newValue);*/
						//tik//
						panelSearch.setValue('DIV_CODE', newValue);
					}
	     		}
			},{ 
    			fieldLabel: '지급일',
		        xtype: 'uniDateRangefield',
		        /*startFieldName: 'DVRY_DATE_FR',*/
		        /*endFieldName: 'DVRY_DATE_TO',*/
		      	//tik//
		      	startFieldName: 'FR_DATE',
		        //tik//
		        endFieldName: 'TO_DATE',
				allowBlank: false,
				tdAttrs: {width: 380},
				onStartDateChange: function(field, newValue, oldValue, eOpts) {
                	if(panelResult) {
						/*panelSearch.setValue('DVRY_DATE_FR',newValue);*/
						//tik//
						panelSearch.setValue('FR_DATE',newValue);
                	}
			    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelResult) {
			    		/*panelSearch.setValue('DVRY_DATE_TO',newValue);*/
			    		//tik//
			    		panelSearch.setValue('TO_DATE',newValue);
			    	}
			    }
	        },{
		        fieldLabel: '담담자',
		      	name:'EXPORT_NM', 
			    xtype: 'uniCombobox',
			    comboType: 'AU', 
				comboCode: 'S010',
			    listeners: {
					change: function(field, newValue, oldValue, eOpts) {      
						/*panelSearch.setValue('ACCNT_DIV_CODE', newValue);*/
						//tik//
						panelSearch.setValue('EXPORT_NM', newValue);
					}
	     		}
			},{
				fieldLabel: '수입대금관리번호',
				name: 'NEGO_SER_NO',
				xtype: 'uniTextfield',
				labelWidth:100, 
				readOnly: false,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelSearch.setValue('NEGO_SER_NO', newValue);
					}
				}
			},
				Unilite.popup('AGENT_CUST', {
				fieldLabel: '<t:message code="system.label.trade.exporter" default="수출자"/>',
				valueFieldName: 'EXPORTER', //EXPORTER
				textFieldName: 'EXPORTER_NM', 
				textFieldWidth:175, 
				
				holdable: 'hold',
				validateBlank:false, 
				popupWidth: 710,
				listeners: {
							onValueFieldChange:function( elm, newValue, oldValue) {						
								panelSearch.setValue('EXPORTER', newValue);
								
								if(!Ext.isObject(oldValue)) {
									panelResult.setValue('EXPORTER_NM', '');
									panelSearch.setValue('EXPORTER_NM', '');
								}
							},
							onTextFieldChange:function( elm, newValue, oldValue) {
								panelSearch.setValue('EXPORTER_NM', newValue);
								
								if(!Ext.isObject(oldValue)) {
									panelResult.setValue('EXPORTER', '');
									panelSearch.setValue('EXPORTER', '');
								}
							}
						}
			}),{
				fieldLabel: '지급유형',
				xtype: 'uniCombobox',
				name: 'COLET_TYPE',
				comboType: 'AU', 
				comboCode: 'T060',
	        	listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('COLET_TYPE', newValue);
					}
				}
			}
		]
	});
    
	
	/* Master Grid1 정의(Grid Panel)
     * @type 
     */

     
	/** tik110skrv_Master Grid_Jack_20170424 **/
    var masterGrid = Unilite.createGrid('tik110skrvGrid', {
    	// for tab    	
        layout : 'fit',
        region:'center',
        flex: 3,
    	store: masterStore,
		selModel	: 'rowmodel',
    	uniOpt: {
    		useGroupSummary: true,
    		useLiveSearch: true,
			useContextMenu: true,
			useMultipleSorting: true,
			useRowNumberer: false,
			expandLastColumn: false,
    		filter: {
				useFilter: false,
				autoCreate: false
			},
			excel: {
				useExcel      : true,			//엑셀 다운로드 사용 여부
				exportGroup   : true, 		//group 상태로 export 여부
				onlyData      : false,
				summaryExport : true
			}
        },
    	features: [ {id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false },
    	           	{id : 'masterGridTotal', 	ftype: 'uniSummary', 	  showSummaryRow: false} ],
        columns:  [{ dataIndex: 'EXPORTER_NM', 			width: 170, 		align: 'center', locked: true},
        		   { dataIndex: 'NEGO_SER_NO', 			width: 180, locked: true},
        		   { dataIndex: 'PAY_DATE', 			width: 120, locked: true},
        		   { dataIndex: 'TERMS_PRICE',			width: 200},
        		   { dataIndex: 'PAY_METHODE', 			width: 170},
        		   { dataIndex: 'PAY_BANK', 			width: 220},
        		   { dataIndex: 'PAY_NM', 				width: 127},
        		   { dataIndex: 'COLET_TYPE', 			width: 160},
        		   { dataIndex: 'PAY_AMT', 				width: 160},
        		   { dataIndex: 'MONEY_UNIT', 			width: 110, 		align: 'center'},
        		   { dataIndex: 'PAY_EXCHANGE_RATE', 	width: 160},
        		   { dataIndex: 'PAY_AMT_WON', 			width: 160},
        		   { dataIndex: 'BL_SER_NO', 			width: 140},
        		   { dataIndex: 'DIV_NAME', 			width: 140,		hidden:true}
        ] 
    });
	
	
	
	/** tik110skrv_main_Jack_20170424 **/
	Unilite.Main( {
		borderItems:[{
			border: false,
			region:'center',
			layout: 'border',
			items:[
				masterGrid, panelResult
			]	
		}		
		,panelSearch
		],
		id  : 'tik110skrvApp',
		fnInitBinding : function(params) {
			
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			panelSearch.setValue('FR_DATE',UniDate.get('startOfMonth'));
			panelSearch.setValue('TO_DATE',UniDate.get('today'));
		
			panelResult.setValue('DIV_CODE',UserInfo.divCode);
			panelResult.setValue('FR_DATE',UniDate.get('startOfMonth'));
			panelResult.setValue('TO_DATE',UniDate.get('today'));
			UniAppManager.setToolbarButtons('detail',false);
			UniAppManager.setToolbarButtons('reset',false);
			UniAppManager.setToolbarButtons('save',false);

			var activeSForm ;		
			if(!UserInfo.appOption.collapseLeftSearch)	{	
				activeSForm = panelSearch;	
			}else {		
				activeSForm = panelResult;	
			}		
			activeSForm.onLoadSelectText('FR_DATE');	

			this.processParams(params);
		},
		checkForNewDetail:function() { 			
			return panelSearch.setAllFieldsReadOnly(true);
        },
		onQueryButtonDown : function()	{		
			if(!UniAppManager.app.checkForNewDetail()){
				return false;
			}else{		
				masterGrid.reset();
				masterStore.clearData();
				
				masterGrid.getStore().loadStoreRecords();
			}
		},
		//링크로 넘어오는 params 받는 부분
        processParams: function(params) {
			this.uniOpt.appParams = params;
			//넘어온 params에 값이 있을때만 아래 내용 적용 (params 중 항상 값이 있는 것으로 조건식 만들기)
			if(params.PGM_ID == 'asc105skr') {
				
				panelSearch.setValue('EXPORTER',params.EXPORTER);
				panelSearch.setValue('NEGO_SER_NO',params.NEGO_SER_NO);
				panelSearch.setValue('EXPORT_NM',params.EXPORT_NM);
				panelSearch.setValue('TO_DATE',params.TO_DATE);
				panelSearch.setValue('COLET_TYPE',params.COLET_TYPE);
				panelSearch.setValue('DIV_CODE',params.DIV_CODE);
				
				panelResult.setValue('EXPORTER',params.EXPORTER);
				panelResult.setValue('NEGO_SER_NO',params.NEGO_SER_NO);
				panelResult.setValue('EXPORT_NM',params.EXPORT_NM);
				panelResult.setValue('FR_DATE',params.FR_DATE);
				panelResult.setValue('TO_DATE',params.TO_DATE);
				panelResult.setValue('COLET_TYPE',params.COLET_TYPE);
				panelResult.setValue('DIV_CODE',params.DIV_CODE);
				this.onQueryButtonDown();

				//masterGrid1.getStore().loadStoreRecords();
			}}
	});
};

</script>
