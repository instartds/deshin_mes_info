<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="aep500ukr"  >
	<t:ExtComboStore comboType="BOR120" /> 						<!-- 사업장 -->
    <t:ExtComboStore comboType="AU" comboCode="J661" /> 		<!-- 위임상태 -->
    <t:ExtComboStore items="${COMBO_CARD_NO}" storeId="cardNoList" />               <!--카드번호-->
	
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>
<script type="text/javascript" >

function appMain() {
	
	
   /** Model 정의 
    * @type 
    */
	Unilite.defineModel('Ham101ukrModel', {
		fields: [ 
			{name: 'SEQ',				text: '순번',							type: 'int'},
			{name: 'MND_TYPE',			text: '위임구분(법인카드/결재)',			type: 'string'},
			{name: 'MND_STAT',			text: '상태',							type: 'string',			allowBlank: false, 		editable: false/*,	comboType:'AU', comboCode:'J661'*/},
			{name: 'MND_STAT_CD',		text: '상태코드',						type: 'string',			allowBlank: false},
			{name: 'CARD_NO',			text: '카드번호',						type: 'string',			allowBlank: false,		store: Ext.data.StoreManager.lookup('cardNoList'),		displayField: 'value'},
			{name: 'CARD_NO_IUD',		text: '카드번호(저장용)',				type: 'string'},
			{name: 'MDMN_ID',			text: '사번',							type: 'string',			allowBlank: false, 		editable: false},
			{name: 'MDMN_NM',			text: '성명',							type: 'string',			allowBlank: false, 		editable: false},
			{name: 'MDMN_POS_NM',		text: '직위',							type: 'string', 		editable: false},
			{name: 'MDMN_DEPT_NM',		text: '부서',							type: 'string', 		editable: false},
			{name: 'MND_START_DT',		text: '시작일',						type: 'uniDate',		allowBlank: false},
			{name: 'MND_END_DT',		text: '종료일',						type: 'uniDate',		allowBlank: false},
			{name: 'ATMN_ID',			text: '사번',							type: 'string',			allowBlank: false},
			{name: 'ATMN_NM',			text: '성명',							type: 'string',			allowBlank: false},
			{name: 'ATMN_POS_NM',		text: '직위',							type: 'string',			editable: false},
			{name: 'ATMN_DEPT_NM',		text: '부서',							type: 'string',			editable: false},
			{name: 'MND_CUSE_CNTT',		text: '위임사유',						type: 'string',			allowBlank: false},
			{name: 'MND_EXE_DT',		text: '위임실행일시',					type: 'string', 		editable: false},
			{name: 'MND_RVC_DT',		text: '위임해제일시',					type: 'string', 		editable: false}			
		]
	});
   
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			create: 'aep500ukrService.insertList',				
			read: 'aep500ukrService.selectList',
			update: 'aep500ukrService.updateList',
			destroy: 'aep500ukrService.deleteList',
			syncAll: 'aep500ukrService.saveAll'
		}
	});
	
	
	
   /** Store 정의(Service 정의)
    * @type 
    */               
	var masterStore = Unilite.createStore('aep500ukrMasterStore1',{
		model		: 'Ham101ukrModel',
		uniOpt		: {
           isMaster	: true,          // 상위 버튼 연결 
           editable	: true,          // 수정 모드 사용 
           deletable: false,         // 삭제 가능 여부 
           useNavi	: false          // prev | newxt 버튼 사용
        },
        autoLoad	: false,
        proxy		: directProxy,
		listeners	: {
	        load : function(store) {
	            /*if (store.getCount() > 0) {
	            	setGridSummary(Ext.getCmp('CHKCNT').checked);
	            }*/
	            /*var newValue = panelSearch.getValue('ORI_JOIN_DATE'); 
	            checkVisibleOriJoinDate(newValue);*/
	        }
	    },
	    loadStoreRecords : function()   {
            var param= Ext.getCmp('searchForm').getValues();	
       		param.CRDT_NUM = panelSearch.getField("CRDT_NUM").rawValue;
        	this.load({
               params : param
            });
			Ext.getCmp('btnRelease').disable();
        },
        
        saveStore : function()	{				
			var inValidRecs = this.getInvalidRecords();
            var toCreate = this.getNewRecords();
            var toUpdate = this.getUpdatedRecords();                
			var toDelete = this.getRemovedRecords();

			if(inValidRecs.length == 0 )	{
				config = {
//					params: [paramMaster],
					success: function(batch, option) {
						UniAppManager.app.onQueryButtonDown();
					} 
				};
				this.syncAllDirect(config);				
			}else {    				
				masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		listeners:{
			load: function(store, records, successful, eOpts) {
				
           	}				
		}
		
		/*,
        _onStoreLoad: function ( store, records, successful, eOpts ) {
	    	if(this.uniOpt.isMaster) {
	    		var recLength = 0;
	    		Ext.each(records, function(record, idx){
	    			if(record.get('GUBUN') == '1'){
	    				recLength++;
	    			}
	    		});
		    	if (records) {
			    	UniAppManager.setToolbarButtons('save', false);
					var msg = recLength + Msg.sMB001; //'건이 조회되었습니다.';
			    	//console.log(msg, st);
			    	UniAppManager.updateStatus(msg, true);	
		    	}
	    	}
	    }*/
   });
   


   /** 검색조건 (Search Panel)
    * @type 
    */
	var panelSearch = Unilite.createSearchPanel('searchForm', {		
		title: '검색조건',		
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
			title: '기본정보', 	
   			itemId: 'search_panel1',
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',           	
			items: [{ 
    			fieldLabel: '위임일자',
		        xtype: 'uniDateRangefield',
		        startFieldName: 'MND_START_DT',
		        endFieldName: 'MND_END_DT',
		        startDate: UniDate.get('today'),
        		endDate: UniDate.get('todayForMonth'),
				allowBlank: false,		        
		        onStartDateChange: function(field, newValue, oldValue, eOpts) {
	                	if(panelResult) {
							panelResult.setValue('MND_START_DT',newValue);
	                	}
				    },
			    onEndDateChange: function(field, newValue, oldValue, eOpts) {
			    	if(panelResult) {
			    		panelResult.setValue('MND_END_DT',newValue);
			    	}
			    }
	        }, {
				fieldLabel: '위임상태',
				name:'MND_STAT_CD', 
				xtype: 'uniCombobox',
		        comboType:'AU',
		        comboCode: 'J661',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('MND_STAT_CD', newValue);
					}
				}
			},
			Unilite.popup('Employee',{
				fieldLabel: '위임자',
			  	valueFieldName:'PERSON_NUMB',
			    textFieldName:'NAME',
				validateBlank:false,
				autoPopup:true,
				listeners: {
					onSelected: {
						fn: function(records, type) {
							panelResult.setValue('PERSON_NUMB', panelSearch.getValue('PERSON_NUMB'));
							panelResult.setValue('NAME', panelSearch.getValue('NAME'));				 																							
						},
						scope: this
					},
					onClear: function(type)	{
						panelResult.setValue('PERSON_NUMB', '');
						panelResult.setValue('NAME', '');
					},
					onValueFieldChange: function(field, newValue){
						panelResult.setValue('PERSON_NUMB', newValue);								
					},
					onTextFieldChange: function(field, newValue){
						panelResult.setValue('NAME', newValue);				
					}
				}
			}),{
	            xtype		: 'uniCombobox',
	            fieldLabel	: '카드번호',
	            name		: 'CRDT_NUM',
	            store		: Ext.data.StoreManager.lookup('cardNoList'),
	            valueField	: 'text',
	            displayField: 'value',
//	            width		: 300,
				listeners	: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('CRDT_NUM', newValue);
					}
				}
	        }]
        }]     	
	});
	
	var panelResult = Unilite.createSearchForm('panelResultForm', {
    	hidden: !UserInfo.appOption.collapseLeftSearch,
		region: 'north',
		layout : {type : 'uniTable', columns : 2},
		padding:'1 1 1 1',
		border:true,
    	items: [{ 
			fieldLabel		: '위임일자',
	        xtype			: 'uniDateRangefield',
	        startFieldName	: 'MND_START_DT',
	        endFieldName	: 'MND_END_DT',
	        startDate		: UniDate.get('today'),
    		endDate			: UniDate.get('todayForMonth'),     
			allowBlank		: false,		           	
	        tdAttrs			: {width: 380},  
	        onStartDateChange: function(field, newValue, oldValue, eOpts) {
            	if(panelSearch) {
					panelSearch.setValue('MND_START_DT',newValue);
            	}
		    },
		    onEndDateChange: function(field, newValue, oldValue, eOpts) {
		    	if(panelSearch) {
		    		panelSearch.setValue('MND_END_DT',newValue);
		    	}
		    }
        }, {
			fieldLabel	: '위임상태',
			name		: 'MND_STAT_CD', 
			xtype		: 'uniCombobox',
	        comboType	: 'AU',
	        comboCode	: 'J661',
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('MND_STAT_CD', newValue);
				}
			}
		},
		Unilite.popup('Employee',{
			fieldLabel		: '위임자',
		  	valueFieldName	: 'PERSON_NUMB',
		    textFieldName	: 'NAME',
			validateBlank	: false,
			autoPopup		: true,       	
	        tdAttrs			: {width: 380},  
			listeners		: {
				onSelected: {
					onValueFieldChange: function(field, newValue){
						panelSearch.setValue('PERSON_NUMB', newValue);								
					},
					onTextFieldChange: function(field, newValue){
						panelSearch.setValue('NAME', newValue);				
					}
				}
			}
		}),{
            xtype		: 'uniCombobox',
            fieldLabel	: '카드번호',
            name		: 'CRDT_NUM',
            store		: Ext.data.StoreManager.lookup('cardNoList'),
            valueField	: 'text',
            displayField: 'value',
//            width		: 300,
			listeners	: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('CRDT_NUM', newValue);
				}
			}
        }]
    });
   
    
    
    /** Master Grid1 정의(Grid Panel)
     * @type 
     */
    var masterGrid = Unilite.createGrid('aep500ukrGrid1', {
        store: masterStore,
       	region: 'center',
        layout: 'fit',
    	uniOpt: {
    		expandLastColumn	: true,
		 	useRowNumberer		: true,
		 	copiedRow			: true,
		 	onLoadSelectFirst	: false	
//		 	useContextMenu: true,
        },
		features: [{
			id: 'masterGridSubTotal',
			ftype: 'uniGroupingsummary',
			showSummaryRow: false						
		},{
			id: 'masterGridTotal',
			ftype: 'uniSummary',
			showSummaryRow: false
		}],
		tbar: [{
            xtype	: 'button',
            text	: '해제',  
            name	: 'BTN_RELEASE', 
            id		: 'btnRelease',
            width	: 100,  
//          disabled:true,
            handler : function() {
                var selectedRec = masterGrid.getSelectedRecord();
                if(Ext.isEmpty(selectedRec)){
                	alert ('선택된 데이터가 없습니다.');
                }
                
				Ext.each(selectedRec, function(record,i){ 
	                var param = panelSearch.getValues();
	                param.PERSON_NUMB	= UserInfo.personNumb;
	                param.CARD_NO		= record.get('CARD_NO');
	                param.CARD_NO_IUD	= record.get('CARD_NO_IUD');
	                param.ATMN_ID		= record.get('ATMN_ID');
	                param.SEQ			= record.get('SEQ');
	                param.MND_TYPE		= record.get('MND_TYPE');
	                
	                aep500ukrService.fnReleaseDelegation(param, function(provider, response)	{
						if(provider){
							UniAppManager.updateStatus(Msg.sMB011);									//저장되었습니다.
							masterStore.loadStoreRecords();
							Ext.getCmp('btnRelease').disable();
						}
						Ext.getBody().unmask();
					});	
				});
            }
        },'','',
        '->','->','->','->','->','->','->','->','->','->','->','->','->','->','->','->','->','->','->','->','->','->','->','->','->','->'],
    	viewConfig: {
	        getRowClass: function(record, rowIndex, rowParams, store){
//	        	var cls = '';
//	          	if(record.get('GUBUN') == '2') {	//소계
//					cls = 'x-change-cell_light';
//				}
//				return cls;
	        }
	    },
    	selModel: Ext.create('Ext.selection.CheckboxModel', { checkOnly: false, toggleOnClick: false,
    		listeners: {  
				beforeselect: function(rowSelection, selectRecord, index, eOpts) {
        			if(selectRecord.get('MND_STAT')== '위임'){
    					return true;
    				}else{
    					return false;
    				}
    			},
    			select: function(grid, selectRecord, index, rowIndex, eOpts ){
	    			if (this.selected.getCount() > 0) {
						Ext.getCmp('btnRelease').enable();
	    			}
    			},
    			
	    		deselect:  function(grid, selectRecord, index, eOpts ){
	    			if (this.selected.getCount() <= 0) {
						Ext.getCmp('btnRelease').disable();
	    			}
	    		}
    		}
        }),
        columns: [{
				xtype	: 'rownumberer', 
				sortable: false, 
				width	: 35,
				align	:'center  !important',
				resizable: true
			},
        	{dataIndex: 'MND_STAT',						width: 100},
        	{dataIndex: 'CARD_NO',						width: 150},
        	{dataIndex: 'CARD_NO_IUD',					width: 150,		hidden: true},
        	{
        		text: '위임자',
        		columns:[
        			{dataIndex: 'MDMN_ID',						width: 100},
		        	{dataIndex: 'MDMN_NM',						width: 100},
		        	{dataIndex: 'MDMN_POS_NM',					width: 100},
		        	{dataIndex: 'MDMN_DEPT_NM',					width: 100}
        		]
        	},        	
        	{dataIndex: 'MND_START_DT',					width: 100},
        	{dataIndex: 'MND_END_DT',					width: 100},        	
        	{
        		text: '수임자',
        		columns:[
        			{dataIndex: 'ATMN_ID',						width: 100,
		                'editor' : Unilite.popup('Employee_G',{
		                    validateBlank : true,
		                    autoPopup:true,
		                    listeners: {
		                        'onSelected': {
		                            fn: function(records, type) {
		                                var rtnRecord = masterGrid.uniOpt.currentRecord;    
		                                rtnRecord.set('ATMN_ID', records[0]['PERSON_NUMB']);
		                                rtnRecord.set('ATMN_NM', records[0]['NAME']);
		                                rtnRecord.set('ATMN_POS_NM', records[0]['POSITION_NAME']);  
		                                rtnRecord.set('ATMN_DEPT_NM', records[0]['DEPT_NAME']);  
		                            },
		                            scope: this
		                        },
		                        'onClear': function(type) {
		                            var grdRecord = masterGrid.uniOpt.currentRecord;
		                            grdRecord.set('ATMN_ID','');
		                            grdRecord.set('ATMN_NM','');
		                            grdRecord.set('ATMN_POS_NM','');
		                            grdRecord.set('ATMN_DEPT_NM','');
		                        },
		                        applyextparam: function(popup){ 
		                        }
		                    }
		                })
		            },
		        	{dataIndex: 'ATMN_NM',						width: 100,
			            'editor' : Unilite.popup('Employee_G',{
		                    validateBlank : true,
		                    autoPopup:true,
		                    listeners: {
		                        'onSelected': {
		                            fn: function(records, type) {
		                                var rtnRecord = masterGrid.uniOpt.currentRecord;    
		                                rtnRecord.set('ATMN_ID', records[0]['PERSON_NUMB']);
		                                rtnRecord.set('ATMN_NM', records[0]['NAME']);
		                                rtnRecord.set('ATMN_POS_NM', records[0]['POSITION_NAME']);  
		                                rtnRecord.set('ATMN_DEPT_NM', records[0]['DEPT_NAME']);  
		                            },
		                            scope: this
		                        },
		                        'onClear': function(type) {
		                            var grdRecord = masterGrid.uniOpt.currentRecord;
		                            grdRecord.set('ATMN_ID','');
		                            grdRecord.set('ATMN_NM','');
		                            grdRecord.set('ATMN_POS_NM','');
		                            grdRecord.set('ATMN_DEPT_NM','');
		                        },
		                        applyextparam: function(popup){ 
		                        }   
		                    }
		                })
		            },
		        	{dataIndex: 'ATMN_POS_NM',					width: 100},
		        	{dataIndex: 'ATMN_DEPT_NM',					width: 100}
        		]
        	},        	
        	{dataIndex: 'MND_CUSE_CNTT',				width: 220},
        	{dataIndex: 'MND_EXE_DT',					width: 160},
        	{dataIndex: 'MND_RVC_DT',					width: 160},
        	{dataIndex: 'MND_TYPE',						width: 100		, hidden: true}
        ],
        listeners: {
        	beforeedit: function(editor, e){
        		if(e.record.phantom){
        			if(UniUtils.indexOf(e.field, ['CARD_NO', 'MND_START_DT', 'MND_END_DT', 'ATMN_ID', 'ATMN_NM', 'MND_CUSE_CNTT'])){
	        			return true;
	        			
	        		} else {
	        			return false;
	        		}
        			
        		} else {
        			return false;
        		}
        	}, 
        	edit: function(editor, e) {
				var fieldName = e.field;
				if(e.value == e.originalValue) return false;
				if(fieldName == 'CARD_NO'){
					var record = masterGrid.getSelectedRecord();
					record.set('CARD_NO_IUD', masterGrid.getColumn('CARD_NO').field.rawValue);
				}
			}
    	}
    });
   
   
    
    Unilite.Main( {
      id  			: 'aep500ukrApp',
      borderItems	: [{
         region	: 'center',
         layout	: 'border',
         border	: false,
         items	: [
            	masterGrid, panelResult
         ]
      },
      panelSearch
      ], 
      fnInitBinding : function() {
        panelSearch.setValue('MND_START_DT', UniDate.get('today'));
        panelSearch.setValue('MND_END_DT', UniDate.get('todayForMonth'));
        panelResult.setValue('MND_START_DT', UniDate.get('today'));
        panelResult.setValue('MND_END_DT', UniDate.get('todayForMonth'));

        panelSearch.setValue('PERSON_NUMB', UserInfo.personNumb);
        panelSearch.setValue('NAME', UserInfo.userName);
        panelResult.setValue('PERSON_NUMB', UserInfo.personNumb);
        panelResult.setValue('NAME', UserInfo.userName);

        Ext.getCmp('btnRelease').disable();
		
        UniAppManager.setToolbarButtons(['reset','newData'], true);
		
		var activeSForm ;
		if(!UserInfo.appOption.collapseLeftSearch)	{
			activeSForm = panelSearch;
		}else {
			activeSForm = panelResult;
		}
		activeSForm.onLoadSelectText('MND_START_DT');         
      },
      
      onQueryButtonDown : function()   {
		if(!this.isValidSearchForm()){			//조회전 필수값 입력 여부 체크
			return false;
		}
      	
      	masterGrid.getStore().loadData({});
        masterGrid.getStore().loadStoreRecords();
      },
      
      onNewDataButtonDown : function() {	
            var param = {
                "S_COMP_CODE": UserInfo.compCode,
                "PERSON_NUMB": UserInfo.personNumb
            };
			aep500ukrService.getPositionName(param, function(provider, response)	{
				if(provider){
					Ext.getBody().unmask();
					if (Ext.isEmpty(panelSearch.getValue('CARD_NO'))) {
						var cardNo = ''
					} else {
						var cardNo = panelSearch.getValue('CARD_NO')
					}
					
					if (Ext.isEmpty(provider[0].POSITION_NAME)) {
						var positionName = ''
					} else {
						var positionName = provider[0].POSITION_NAME
					}
					var r = {
						MND_STAT	:   '위임',
						MND_STAT_CD	:	'0',
						CARD_NO		:	cardNo,
						MDMN_ID		:   UserInfo.personNumb,
						MDMN_NM		:	UserInfo.userName,
						MDMN_POS_NM	:   positionName,
						MDMN_DEPT_NM:   UserInfo.deptName,
						MND_START_DT:	UniDate.get('today'),
						MND_END_DT	:	UniDate.get('today'),
						MND_TYPE	:	'10'												//10:법인카드, 20:결재(?)

					};
					masterGrid.createRow(r, '');

			} else {
					UniAppManager.updateStatus('위임자의 직위정보가 누락되었습니다.');					//저장되었습니다.
				}
			});
		},
		
		onSaveDataButtonDown : function() {
			if(!this.isValidSearchForm()){
				return false;
			}

			if (masterGrid.getStore().isDirty()) {
				masterGrid.getStore().saveStore();
			}
		},
		
//		onDeleteDataButtonDown : function()	{
//			var selRow = masterGrid.getSelectedRecord();
//			if(selRow.phantom === true)	{
//				masterGrid.deleteSelectedRow();
//			}else if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
//				masterGrid.deleteSelectedRow();
//			}
//		},
		
		onResetButtonDown : function() {			
			panelSearch.clearForm();
			panelResult.clearForm();
			masterGrid.getStore().loadData({});
			this.fnInitBinding();;
		}
   });
   
   
    function checkVisible(newValue) {
		if (newValue == '2') {
			Ext.getCmp('PAY_GU2').setVisible(true);

		} else {
			Ext.getCmp('PAY_GU2').setVisible(false);
		}
    }

};


</script>