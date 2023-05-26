<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="hum101rkr"  >
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="B014" /> <!-- 조달구분 -->
	<t:ExtComboStore comboType="AU" comboCode="B019" /> <!-- 국내외구분 --> 
	<t:ExtComboStore comboType="AU" comboCode="M201" /> <!-- 구매담당 -->
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>	
</t:appConfig>
<script type="text/javascript" >

var outDivCode = UserInfo.divCode;

function appMain() {
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'hum101rkrService.selectMaster',
			update: 'hum101rkrService.updateDetail',
			create: 'hum101rkrService.insertDetail',
			destroy: 'hum101rkrService.deleteDetail',
			syncAll: 'hum101rkrService.saveAll'
		}
	});

	/**
	 *   Model 정의 
	 * @type 
	 */
	Unilite.defineModel('Hum101rkrModel', {
	    fields: [
	    	{name: 'PERSON_NUMB'			    ,text: '사번' 				,type: 'string'},
	    	{name: 'NAME'	    				,text: '성명' 			,type: 'string'},
	    	{name: 'DEPT_CODE'		 			,text: '부서코드' 			,type: 'string'},
	    	{name: 'DEPT_NAME'		   		 	,text: '부서이름' 				,type: 'string'},
	    	{name: 'POST_CODE'			    	,text: '직책코드' 				,type: 'string'},
	    	{name: 'CODE_NAME'			    	,text: '직책이름' 					,type: 'string'},
	    	{name: 'JOIN_DATE'				    ,text: '입사일자' 					,type: 'uniDate'},
	    	{name: 'RETR_DATE'		    		,text: '퇴사일자' 			,type: 'uniDate'},
	    	{name: 'WORK_PERIOD'			    ,text: '근속일수' 					,type: 'string'}
		]
	});
	
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var MasterStore = Unilite.createStore('hum101rkrMasterStore',{
			model: 'Hum101rkrModel',
			uniOpt : {
            	isMaster: false,			// 상위 버튼 연결 
            	editable: false,			// 수정 모드 사용 
            	deletable: false,			// 삭제 가능 여부 
	            useNavi : false			// prev | newxt 버튼 사용
            },
            autoLoad: false,
//            proxy: directProxy
            proxy: {
                type: 'direct',
                api: {			
                	   read: 'hum101rkrService.selectList'                	
                }
            }
			,loadStoreRecords : function()	{
				var param= Ext.getCmp('searchForm').getValues();			
				console.log( param );
				this.load({
					params : param
				});
			}
			,saveStore : function(config)	{	
				var inValidRecs = this.getInvalidRecords();
				var toCreate = this.getNewRecords();
            	var toUpdate = this.getUpdatedRecords();
            	console.log("toUpdate",toUpdate);

            	var rv = true;
       	
            	if(inValidRecs.length == 0 )	{										
					config = {
						success: function(batch, option) {								
							panelResult.resetDirtyStatus();
							UniAppManager.setToolbarButtons('save', false);			
						 } 
					};					
					this.syncAllDirect(config);
				}else {
					masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
				}
			},
			listeners: {
	           	load: function(store, records, successful, eOpts) {
	           		var count = masterGrid.getStore().getCount();  
	           		if(count > 0){
		           		UniAppManager.setToolbarButtons(['print'], true);
	           		}else{
	           			UniAppManager.setToolbarButtons(['print'], false);
	           		}
	           		
	           	}
			}			

			//groupField: 'CUSTOM_NAME'
	});

	/**
	 * 검색조건 (Search Panel)
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
				fieldLabel: '사번',
				name: 'PERSON_NUMB',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('PERSON_NUMB', newValue);
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
	
	var panelResult = Unilite.createSearchForm('panelResultForm', {		
    	//hidden: !UserInfo.appOption.collapseLeftSearch,
		region: 'north',
		layout : {type : 'uniTable', columns : 4},
		padding:'1 1 1 1',
		border:true,
	    items : [{
				fieldLabel: '사번',
				name: 'PERSON_NUMB',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('PERSON_NUMB', newValue);
					}
				} 				
			}
		],
		
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
     * Master Grid 정의
     * @type 
     */    
    var masterGrid = Unilite.createGrid('hum101rkrGrid', {
    	// for tab    	
        layout : 'fit',
        region:'center',
        uniOpt:{	expandLastColumn: true,
        			useRowNumberer: true,
                    useMultipleSorting: true
        },
//        tbar: [{
//        	text:'상세보기',
//        	handler: function() {
//        		var record = masterGrid.getSelectedRecord();
//	        	if(record) {
//	        		openDetailWindow(record);
//	        	}
//        	}
//        }],
    	store: MasterStore,
    	features: [ {id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false },
    	           	{id : 'masterGridTotal', 	ftype: 'uniSummary', 	  showSummaryRow: false} ],
        columns:  [        
               		 { dataIndex: 'PERSON_NUMB'			  			  				 , 	width:80},
               		 { dataIndex: 'NAME'	  			  				     , 	width:86, locked: true},
               		 { dataIndex: 'DEPT_CODE'		  			  				     , 	width:86, locked: true , hidden: true},
               		 { dataIndex: 'DEPT_NAME'		  			  				     , 	width:160, locked: true},
               		 { dataIndex: 'POST_CODE'				  			  				 , 	width:135, hidden: true},
               		 { dataIndex: 'CODE_NAME'		  			  				 , 	width:106},
               		 { dataIndex: 'JOIN_DATE'			  			  				 , 	width:56},
               		 { dataIndex: 'RETR_DATE'			  			  				 , 	width:56},
               		 { dataIndex: 'WORK_PERIOD'			  			  				 , 	width:86}
        ],
		listeners: {
        	beforeedit: function( editor, e, eOpts ) {
        		if(e.record.phantom == false) {
        		 	if(UniUtils.indexOf(e.field, ['DEPT_CODE']))
				   	{
						return false;
      				} else {
      					return true;
      				}
        		} else {
        			if(UniUtils.indexOf(e.field))
				   	{
						return true;
      				}
        		}
        	} 	
        }
        //, 
//        setItemData: function(record, dataClear, grdRecord) {   
//            var grdRecord = this.uniOpt.currentRecord;
//            if(dataClear) {                
//                grdRecord.set('ITEM_CODE'			, '');
//                grdRecord.set('ITEM_NAME'           , '');
//                grdRecord.set('STOCK_UNIT'      	, '');
//                grdRecord.set('BASIS_DATE'           , '');
//                grdRecord.set('SUPPLY_TYPE'      	, '');
//                grdRecord.set('DOM_FORIGN'           , '');               
//                
//            } else {
//                grdRecord.set('ITEM_CODE'          , record['ITEM_CODE']);
//                grdRecord.set('ITEM_NAME'          , record['ITEM_NAME']);
//                grdRecord.set('STOCK_UNIT'      	, record['STOCK_UNIT']);
//                grdRecord.set('BASIS_DATE'      	, UniDate.get('tomorrow'));
//                grdRecord.set('SUPPLY_TYPE'      	, record['SUPPLY_TYPE']);
//                grdRecord.set('DOM_FORIGN'      	, record['DOM_FORIGN']);                
//            }
//        }        
    });   
	
    Unilite.Main( {
		borderItems:[{
			border: false,
			region: 'center',
			layout: 'border',
			items:[
				masterGrid, panelResult
			]
		}	 
		,panelSearch
		],
		id  : 'hum101rkrApp',
		fnInitBinding : function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			
			//UniAppManager.setToolbarButtons('newData', true);
			//UniAppManager.setToolbarButtons('detail',false);
			//UniAppManager.setToolbarButtons('reset',false);
		},
		
		onQueryButtonDown : function()	{			
			if(panelSearch.setAllFieldsReadOnly(true) == false){
				return false;
			}
			if(panelResult.setAllFieldsReadOnly(true) == false){
				return false;
			}
			MasterStore.loadStoreRecords();
			
//			var viewLocked = masterGrid.lockedGrid.getView();
//			var viewNormal = masterGrid.normalGrid.getView();
//			console.log("viewLocked : ",viewLocked);
//			console.log("viewNormal : ",viewNormal);
//		    viewLocked.getFeature('masterGridSubTotal').toggleSummaryRow(true);
//		    viewLocked.getFeature('masterGridTotal').toggleSummaryRow(true);
//		    viewNormal.getFeature('masterGridSubTotal').toggleSummaryRow(true);
//		    viewNormal.getFeature('masterGridTotal').toggleSummaryRow(true);
		},
		onPrintButtonDown: function() {
//			var param= Ext.getCmp('searchForm').getValues();
			var win = Ext.create('widget.PDFPrintWindow', {
				url: CPATH+'/hum/hum101rkrPrint.do',
				prgID: 'hum101rkr',
				extParam: {
					PERSON_NUMB		: panelSearch.getValue('PERSON_NUMB'),
					LANG            : UserInfo.userLang
				}
				});
			win.center();
			win.show();   				
		},
		
		onDeleteDataButtonDown: function() {
			if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
				masterGrid.deleteSelectedRow();
			}
		},
		
		/*confirmSaveData: function(config)	{	// 저장하기전 원복 시키는 작업
			if(confirm(Msg.sMB061))	{
				this.onSaveDataButtonDown(config);
			} else {
				//this.rejectSave();
			}
		},*/
		
		onSaveDataButtonDown: function(config) {	// 저장 버튼
			MasterStore.saveStore();
		}		
		
//		onDetailButtonDown:function() {
//			var as = Ext.getCmp('AdvanceSerch');	
//			if(as.isHidden())	{
//				as.show();
//			}else {
//				as.hide()
//			}
//		}
	});
};

</script>
