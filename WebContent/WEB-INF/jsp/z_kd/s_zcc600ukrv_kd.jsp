<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_zcc600ukrv_kd"  >
    <t:ExtComboStore comboType="BOR120"  pgmId="s_zcc600ukrv_kd"  />             <!-- 사업장 -->  
    <t:ExtComboStore comboType="AU" comboCode="WZ08" /> <!-- 외주/자재구분  -->
    <t:ExtComboStore comboType="AU" comboCode="WZ32" /> <!-- 부서구분  -->
</t:appConfig>
<script type="text/javascript" charset="UTF-8" src='<c:url value="/resources/plupload/plupload.full.js" />' >
</script>
<script type="text/javascript" >

var masterSaveFlag = '';
//var detailWindow; // 의뢰서작성디테일팝업
var BsaCodeInfo = {	
	gsAuthorityLevel: '${gsAuthorityLevel}'
};
function appMain() {
	var searchInfoWindow; // 검색창
    var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
        api: {
            read: 's_zcc600ukrv_kdService.selectDetail',
            create: 's_zcc600ukrv_kdService.insertDetail',
            update: 's_zcc600ukrv_kdService.updateDetail',
            destroy: 's_zcc600ukrv_kdService.deleteDetail',
            syncAll: 's_zcc600ukrv_kdService.saveAll'
        }
    });
    
    Unilite.defineModel('searchInfoModel', {
        fields: [
            {name: 'COMP_CODE'            ,text:'법인코드'            ,type: 'string'},
            {name: 'DIV_CODE'             ,text:'사업장'             ,type: 'string'},
            {name: 'ENTRY_NUM'            ,text:'관리번호'            ,type: 'string'},
            {name: 'SER_NO'            	,text:'관리순번'                 ,type: 'int'},
            {name: 'ITEM_CODE'    			,text:'품번'           		,type: 'string'},
            {name: 'ITEM_NAME'    		,text:'품명'            		,type: 'string'},
            {name: 'CUSTOM_CODE'          ,text:'납품업체'             ,type: 'string'},
            {name: 'CUSTOM_NAME'          ,text:'업체명'              ,type: 'string'},
            {name: 'MAKE_QTY'             ,text:'수량'                 		,type: 'float', decimalPrecision: 0, format:'0,000'},
            {name: 'MAKE_UNIT',       text : '단위',                type : 'string'},
            {name: 'COST_AMT'             ,text:'제작금액'                 	,type: 'float', decimalPrecision: 0, format:'0,000'},
            {name: 'MAKE_END_YN'             ,text:'제작완료'                 	,type: 'string', comboType:'AU', comboCode:'B131' },
            {name: 'REMARK'          ,text:'비고'              ,type: 'string'}
            
        ]
    }); 
    Unilite.defineModel('detailModel', {
        fields: [
            {name: 'COMP_CODE'            ,text:'법인코드'                 ,type: 'string',editable:false},
            {name: 'DIV_CODE'             ,text:'사업장'                   ,type: 'string',allowBlank:false,editable:false},
            {name: 'ENTRY_NUM'            ,text:'관리번호'                 ,type: 'string',editable:false},
            {name: 'SER_NO'            	,text:'관리순번'                 ,type: 'int',allowBlank:false,editable:false},
            {name: 'ITEM_CODE'    			,text:'품번'           		,type: 'string',allowBlank:false},
            {name: 'ITEM_NAME'    		,text:'품명'            		,type: 'string'},
            {name: 'CUSTOM_CODE'          ,text:'납품업체'             ,type: 'string',allowBlank:false},
            {name: 'CUSTOM_NAME'          ,text:'업체명'              ,type: 'string'},
            {name: 'MAKE_QTY'             ,text:'수량'                 		,type: 'float', decimalPrecision: 0, format:'0,000',allowBlank:false},
            {name : 'MAKE_UNIT',       text : '단위',                type : 'string'},
            {name: 'WIRE_P'             ,text:'와이어'                 		,type: 'float', decimalPrecision: 0, format:'0,000'},
            {name: 'LASER_P'             ,text:'레이저'                 		,type: 'float', decimalPrecision: 0, format:'0,000'},
            {name: 'COAT_P'             ,text:'코팅'                 		,type: 'float', decimalPrecision: 0, format:'0,000'},
            {name: 'WIRE_S_P'             ,text:'와이어S'                 	,type: 'float', decimalPrecision: 0, format:'0,000'},
            {name: 'ETC_P'             ,text:'기타'                 		,type: 'float', decimalPrecision: 0, format:'0,000'},
            {name: 'MATERIAL_AMT'             ,text:'재료비'                 		,type: 'float', decimalPrecision: 0, format:'0,000'},
            {name: 'MAKE_AMT'             ,text:'가공비'                 		,type: 'float', decimalPrecision: 0, format:'0,000'},
            {name: 'ETC_AMT'             ,text:'기타'                 		,type: 'float', decimalPrecision: 0, format:'0,000'},
            {name: 'COST_AMT'             ,text:'합계금액'                 	,type: 'float', decimalPrecision: 0, format:'0,000'},
            {name: 'EST_AMT'             ,text:'견적가'                 	,type: 'float', decimalPrecision: 0, format:'0,000'},
            {name: 'COLLECT_CNT'             ,text:'수금등록데이터'                 	,type: 'float', decimalPrecision: 0, format:'0,000'},
            {name: 'MAKE_END_YN'             ,text:'제작완료'                 	,type: 'string',allowBlank:false, comboType:'AU', comboCode:'B131' },

            {name: 'REMARK'          ,text:'비고'              ,type: 'string'}
        ]
    }); 
    
    var searchInfoStore = Unilite.createStore('searchInfoStore',{
        model: 'searchInfoModel',
        uniOpt : {
            isMaster:  true,            // 상위 버튼 연결 
            editable:  false,            // 수정 모드 사용 
            deletable: false,            // 삭제 가능 여부 
            useNavi :  false            // prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: {
            type: 'direct',
            api: {
                read: 's_zcc600ukrv_kdService.selectSearchInfo'
            }
        },
        loadStoreRecords : function()   {   
            var param= searchInfoForm.getValues();
            this.load({
                  params : param
            });         
        }
//        groupField:'ENTRY_NUM'
    });
    
    var detailStore = Unilite.createStore('detailStore',{
        model: 'detailModel',
        uniOpt : {
            isMaster:  true,            // 상위 버튼 연결 
            editable:  true,            // 수정 모드 사용 
            deletable: true,            // 삭제 가능 여부 
            useNavi :  false            // prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: directProxy,
        loadStoreRecords : function()   {   
            var param= masterForm.getValues();
            this.load({
                  params : param
            });         
        },
        saveStore : function()  {   
            var inValidRecs = this.getInvalidRecords();                
            var rv = true;
            var toCreate = this.getNewRecords();
            var toUpdate = this.getUpdatedRecords();                
            var toDelete = this.getRemovedRecords();
            var list = [].concat(toUpdate, toCreate);
            var paramMaster = masterForm.getValues();
            paramMaster.masterSaveFlag = masterSaveFlag;
            if(inValidRecs.length == 0 )    {
                 config = {
                    params: [paramMaster],
                    success: function(batch, option) {
						var master = batch.operations[0].getResultSet();
						masterForm.setValue("ENTRY_NUM", master.ENTRY_NUM);
                        if(detailStore.getCount() == 0){
                            UniAppManager.app.onResetButtonDown();
                        }else{
                        	UniAppManager.app.onQueryButtonDown();
        					UniAppManager.app.masterFormDisableFn('1');
                        }
                        masterSaveFlag = '';
                     } 
                };
                this.syncAllDirect(config);
            } else {
                var grid = Ext.getCmp('detailGrid');
                grid.uniSelectInvalidColumnAndAlert(inValidRecs);
            }
        }
    });
    
    var masterForm = Unilite.createSearchForm('masterForm',{
        region: 'north',
        layout : {type : 'uniTable', columns : 3},
        padding:'1 1 1 1',
        border:true,
        items: [{
            fieldLabel: '사업장',
            name:'DIV_CODE',
            xtype: 'uniCombobox',
            comboType:'BOR120',
            allowBlank:false,
            value: UserInfo.divCode
        },{
			fieldLabel: '작업구분',
			xtype: 'radiogroup',
			id: 'rdoSelect',
			items: [{
				boxLabel	: '개발금형',
				name		: 'WORK_TYPE',
				inputValue	: '1',
				width		: 80
			},{
				boxLabel	: '시작샘플',
				name		: 'WORK_TYPE',
				inputValue	: '2',
				width		: 80
			}],
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					UniAppManager.app.setHiddenColumn(newValue.WORK_TYPE);
				}
			}
		},{
            fieldLabel: '등록일자',
            name: 'ENTRY_DATE',
            xtype: 'uniDatefield',
            value: UniDate.get('today'),
            allowBlank: false
        },{
            fieldLabel: '부서구분',
            name:'DEPT_TYPE',
            xtype: 'uniCombobox',
            comboType:'AU',
            comboCode:'WZ32',
            allowBlank: false
        },{
            fieldLabel: '관리번호',
            name:'ENTRY_NUM',   
            xtype: 'uniTextfield'
        }],
		listeners:{
			uniOnChange:function( form ) {
				if(form.isDirty() && !form.uniOpt.inLoading)	{
					if(form.getField('ENTRY_NUM').readOnly == true){
						if(!Ext.isEmpty(form.getValue('ENTRY_NUM'))){
							UniAppManager.setToolbarButtons('save', true);
						}
					}
				}
			}
		},
    	api: {
//	 		load: 's_zcc600ukrv_kdService.selectForm'	,
	 		submit: 's_zcc600ukrv_kdService.syncMaster'	
		}
    });
    
    var searchInfoForm = Unilite.createSearchForm('searchInfoForm', {     // 검색 팝업창
        layout: {type: 'uniTable', columns : 4},
        items: [{
            fieldLabel: '사업장',
            name:'DIV_CODE',
            xtype: 'uniCombobox',
            comboType:'BOR120',
            allowBlank:false,
            value: UserInfo.divCode
        },{
			fieldLabel: '작업구분',
			xtype: 'radiogroup',
			id: 'rdo',
			items: [{
				boxLabel	: '개발금형',
				name		: 'WORK_TYPE',
				inputValue	: '1',
				width		: 80
//				checked: true
			},{
				boxLabel	: '시작샘플',
				name		: 'WORK_TYPE',
				inputValue	: '2',
				width		: 80
			}]
		},{
			fieldLabel: '등록일자',
			xtype: 'uniDateRangefield',
			startFieldName: 'ENTRY_DATE_FR',
			endFieldName: 'ENTRY_DATE_TO',
			startDate: UniDate.get('startOfMonth'),
			endDate: UniDate.get('today')
		},
		
		{
			fieldLabel: '완료여부',
            name:'MAKE_END_YN',
			xtype:'uniCombobox',
			comboType:'AU',
			comboCode:'B131'
			
		},{
            fieldLabel: '부서구분',
            name:'DEPT_TYPE',
            xtype: 'uniCombobox',
            comboType:'AU',
            comboCode:'WZ32'
        },{
            fieldLabel: '관리번호',
            name:'ENTRY_NUM',   
            xtype: 'uniTextfield'
        },{
            fieldLabel: '품번',
            name:'ITEM_CODE',   
            xtype: 'uniTextfield'
        },
        Unilite.popup('CUST',{
			fieldLabel		: '납품업체',
			valueFieldName	: 'CUSTOM_CODE',
			textFieldName	: 'CUSTOM_NAME'
		})
        
        
        ]
    });
    
    var detailGrid = Unilite.createGrid('detailGrid', { 
        layout : 'fit',   
        region: 'center',                          
        store: detailStore,
        uniOpt: {
            expandLastColumn: true,
            useMultipleSorting: false,
            useGroupSummary: false,
            useLiveSearch: true,
            useContextMenu: true,
            useRowNumberer: true,
            onLoadSelectFirst: true,
            filter: {
                useFilter: true,
                autoCreate: true
            }
        },
        columns:  [ 
            { dataIndex: 'COMP_CODE'                                   ,width: 100,hidden:true},
            { dataIndex: 'DIV_CODE'                                    ,width: 100,hidden:true},
            { dataIndex: 'ENTRY_NUM'                                   ,width: 100},
            { dataIndex: 'SER_NO'                                      ,width: 100},
            { dataIndex: 'ITEM_CODE'                                   ,width: 100},
            { dataIndex: 'ITEM_NAME'                                   ,width: 200},
            { dataIndex: 'CUSTOM_CODE'                                 ,width: 100,
            	editor: Unilite.popup('AGENT_CUST_G',{
            		autoPopup: true,
					listeners:{
					'onSelected': {
						fn: function(records, type  ){
							var grdRecord = detailGrid.uniOpt.currentRecord;
							grdRecord.set('CUSTOM_CODE',records[0]['CUSTOM_CODE']);
							grdRecord.set('CUSTOM_NAME',records[0]['CUSTOM_NAME']);
						},
						scope: this
					  },
					'onClear' : function(type)	{
							var grdRecord = detailGrid.uniOpt.currentRecord;
							grdRecord.set('CUSTOM_CODE','');
							grdRecord.set('CUSTOM_NAME','');
					  }
					}
				})
            },
            { dataIndex: 'CUSTOM_NAME'                                 ,width: 100,
            	editor: Unilite.popup('AGENT_CUST_G',{
            		autoPopup: true,
					listeners:{
					'onSelected': {
						fn: function(records, type  ){
							var grdRecord = detailGrid.uniOpt.currentRecord;
							grdRecord.set('CUSTOM_CODE',records[0]['CUSTOM_CODE']);
							grdRecord.set('CUSTOM_NAME',records[0]['CUSTOM_NAME']);
						},
						scope: this
					  },
					'onClear' : function(type)	{
							var grdRecord = detailGrid.uniOpt.currentRecord;
							grdRecord.set('CUSTOM_CODE','');
							grdRecord.set('CUSTOM_NAME','');
					  }
					}
				})
            },
            { dataIndex: 'MAKE_QTY'                                    ,width: 100},
            { dataIndex: 'MAKE_UNIT'                                    ,width: 100},
            
            { dataIndex: 'WIRE_P'                                      ,width: 100,hidden:true},
            { dataIndex: 'LASER_P'                                     ,width: 100,hidden:true},
            { dataIndex: 'COAT_P'                                      ,width: 100,hidden:true},
            { dataIndex: 'WIRE_S_P'                                    ,width: 100,hidden:true},
            { dataIndex: 'ETC_P'                                       ,width: 100,hidden:true},
            
            { dataIndex: 'MATERIAL_AMT'                                ,width: 100,hidden:false},
            { dataIndex: 'MAKE_AMT'                                    ,width: 100,hidden:false},
            { dataIndex: 'ETC_AMT'                                     ,width: 100,hidden:false},
            { dataIndex: 'COST_AMT'                                    ,width: 100},
            { dataIndex: 'MAKE_END_YN'                                 ,width: 100},
            { dataIndex: 'REMARK'                                    ,width: 100}
        ],
        listeners: {
        	beforeedit: function( editor, e, eOpts ) {
        		
        		if(e.record.data.MAKE_END_YN == 'Y'){
            		if(UniUtils.indexOf(e.field, ['MAKE_END_YN'])){
            			return true;
            		}else{
            			return false;
            		}
        		}else{
        			return true;
        		}
        		
        		
     /*       	if(Ext.getCmp('rdoSelect').getValue().WORK_TYPE == '2'){
            		if(UniUtils.indexOf(e.field, ['WIRE_P','LASER_P','COAT_P','WIRE_S_P','ETC_P'])){
						return false;
					}
    				if(UniUtils.indexOf(e.field, ['MATERIAL_AMT','MAKE_AMT','ETC_AMT'])){
						if(e.record.data.EST_AMT != 0 || e.record.data.MAKE_END_YN == 'Y' ){
		        			if(BsaCodeInfo.gsAuthorityLevel == '15'){//관리자
								return true;
		        			}else { //일반사용자
								return false;
		        			}
		        		}
					}
            	}else {
            		if(UniUtils.indexOf(e.field, ['MATERIAL_AMT','MAKE_AMT','ETC_AMT'])){
						return false;
					}
    				if(UniUtils.indexOf(e.field, ['WIRE_P','LASER_P','COAT_P','WIRE_S_P','ETC_P'])){
						if(e.record.data.EST_AMT != 0 || e.record.data.MAKE_END_YN == 'Y'){
		        			if(BsaCodeInfo.gsAuthorityLevel == '15'){//관리자
								return true;
		        			}else { //일반사용자
								return false;
		        			}
		        		}
					}
            	}*/
        		
            }
        }
    });
    var searchInfoGrid = Unilite.createGrid('searchInfoGrid', { 
        layout : 'fit',   
        region: 'center',                          
        store: searchInfoStore,
        uniOpt: {
            expandLastColumn: true,
            useMultipleSorting: false,
            useGroupSummary: false,
            useLiveSearch: true,
            useContextMenu: true,
            useRowNumberer: true,
            onLoadSelectFirst: true,
            filter: {
                useFilter: true,
                autoCreate: true
            }
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
        selModel:'rowmodel',
        columns:  [ 
            { dataIndex: 'COMP_CODE'                            ,width: 80, hidden: true},
            { dataIndex: 'DIV_CODE'                             ,width: 80, hidden: true},
            { dataIndex: 'ENTRY_NUM'                                ,width: 100},
            { dataIndex: 'SER_NO'                                   ,width: 80},
            { dataIndex: 'ITEM_CODE'                                ,width: 100},
            { dataIndex: 'ITEM_NAME'                                ,width: 200},
            { dataIndex: 'CUSTOM_CODE'                              ,width: 100},
            { dataIndex: 'CUSTOM_NAME'                              ,width: 200},
            { dataIndex: 'MAKE_QTY'                                 ,width: 100},
            { dataIndex: 'MAKE_UNIT'                               ,width: 100},
            { dataIndex: 'COST_AMT'                                 ,width: 100},
            { dataIndex: 'MAKE_END_YN'                              ,width: 80},
            { dataIndex: 'REMARK'                                   ,width: 200}
        ],
        listeners: {    
            onGridDblClick:function(grid, record, cellIndex, colName) {
                searchInfoGrid.returnData(record);
                UniAppManager.app.onQueryButtonDown();
                searchInfoWindow.hide();
            }
        },
        returnData: function(record)   {
            if(Ext.isEmpty(record)) {
                record = this.getSelectedRecord();
            }
            masterForm.setValue('DIV_CODE',record.get('DIV_CODE'));
            masterForm.setValue('ENTRY_NUM',record.get('ENTRY_NUM'));
            masterForm.setValue('ENTRY_DATE',record.get('ENTRY_DATE'));
            masterForm.setValue('WORK_TYPE',record.get('WORK_TYPE'));
            masterForm.setValue('DEPT_TYPE',record.get('DEPT_TYPE'));
        	UniAppManager.app.masterFormDisableFn('1');
        }   
    });
    
    function openSearchInfoWindow() {   //검색팝업창
        if(!searchInfoWindow) {
            searchInfoWindow = Ext.create('widget.uniDetailWindow', {
                title: '관리번호 검색',
                width: 1200,                             
                height: 580,
                layout: {type:'vbox', align:'stretch'},                 
                items: [searchInfoForm, searchInfoGrid], 
                tbar:  ['->',
                    {itemId : 'searchQueryBtn',
                    text: '조회',
                    handler: function() {
            			if(!searchInfoForm.getInvalidMessage()) return;   //필수체크
                        searchInfoStore.loadStoreRecords();
                    },
                    disabled: false
                    },{
                        itemId : 'searchCloseBtn',
                        text: '닫기',
                        handler: function() {
                            searchInfoWindow.hide();
                        },
                        disabled: false
                    }
                ],
                listeners: {
                	beforehide: function(me, eOpt) {
                        searchInfoForm.clearForm();
//            			searchInfoStore.clearData(); 
//                        searchInfoGrid.reset();
                        searchInfoGrid.getStore().loadData({});
                    },
                    beforeclose: function(panel, eOpts) {
                        searchInfoForm.clearForm();
//                        searchInfoStore.clearData();
//                        searchInfoGrid.reset();
                        searchInfoGrid.getStore().loadData({});
                    },
                    beforeshow: function(panel, eOpts) {
                        searchInfoForm.setValue('DIV_CODE',masterForm.getValue('DIV_CODE'));
				        searchInfoForm.setValue('ENTRY_DATE_FR', UniDate.get('startOfMonth'));                
				        searchInfoForm.setValue('ENTRY_DATE_TO', UniDate.get('today'));
                        searchInfoForm.setValue('WORK_TYPE',Ext.getCmp('rdoSelect').getValue().WORK_TYPE);
                    }
                }       
            })
        }
        searchInfoWindow.show();
        searchInfoWindow.center();
    }
    Unilite.Main( {
        borderItems:[{
                region:'center',
                layout: 'border',
                border: false,
                items:[
                    detailGrid, masterForm
                ]
            }   
        ],
        id  : 's_zcc600ukrv_kdApp',
        fnInitBinding : function() {
            this.setDefault();
        },
        onQueryButtonDown : function()  {
        	var reqNum = masterForm.getValue('ENTRY_NUM');
            if(Ext.isEmpty(reqNum)) {
                openSearchInfoWindow() 
            } else {
                var param= masterForm.getValues();
                detailStore.loadStoreRecords();
            }
        },
        onResetButtonDown: function() {
            masterForm.clearForm();
            detailStore.clearData();
            detailGrid.reset();
            this.setDefault();
        },
        onNewDataButtonDown: function() {
            if(!masterForm.getInvalidMessage()) return;   //필수체크
            var compCode        = UserInfo.compCode; 
            var divCode         = masterForm.getValue('DIV_CODE'); 
            var seq             = detailStore.max('SER_NO');
            if(!seq) seq = 1;
            else seq += 1;
            var entryNum          = masterForm.getValue('ENTRY_NUM');
            var r = {
                COMP_CODE:	compCode,
                DIV_CODE:	divCode,
                SER_NO:	seq,
                ENTRY_NUM:	entryNum,
                MAKE_END_YN: 'N'
            };
            detailGrid.createRow(r);
			UniAppManager.app.masterFormDisableFn('1');
        },
        onDeleteDataButtonDown: function() {
        	var selRow = detailGrid.getSelectedRecord();
        	if(BsaCodeInfo.gsAuthorityLevel == '15'){//관리자
        		if(selRow.get('COLLECT_CNT') > 0){
        			Unilite.messageBox('수금내역이 존재합니다. 삭제 할 수 없습니다.');
        			return;
        		}
        	}else{//일반사용자
        		if(selRow.get('EST_AMT') != 0){
        			Unilite.messageBox('견적가가 존재합니다. 삭제 할 수 없습니다.');
        			return;
        		}
        	}
            if(selRow.phantom === true) {
                detailGrid.deleteSelectedRow();
            } else if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
                detailGrid.deleteSelectedRow();
            }
        },
        onSaveDataButtonDown: function () {
            if(!masterForm.getInvalidMessage()) return;   //필수체크
        	if(Ext.isEmpty(detailStore.data.items)){
        		masterSaveFlag = 'D';
        	}
        	if(!detailStore.isDirty())	{
				if(masterForm.isDirty())	{
		       		masterForm.getForm().submit({
					params : masterForm.getValues(),
						success : function(form, action) {
			 				masterForm.getForm().wasDirty = false;
							masterForm.resetDirtyStatus();											
							UniAppManager.setToolbarButtons('save', false);	
			            	UniAppManager.updateStatus(Msg.sMB011);// 저장되었습니다
						}	
					});
				}
       		}else{
	            detailStore.saveStore();
       		}
        },
        setDefault: function() {
            masterForm.setValue('DIV_CODE',UserInfo.divCode);
            masterForm.setValue('ENTRY_DATE', UniDate.get('today'));
            masterForm.setValue('WORK_TYPE', '1');
            UniAppManager.setToolbarButtons(['save', 'newData','deleteAll'],false);
            UniAppManager.setToolbarButtons(['newData'],true);
            this.masterFormDisableFn('2');
        },
        masterFormDisableFn: function (gubun) {
        	if(gubun == '1'){
	        	masterForm.getField('DIV_CODE').setReadOnly(true);
	        	masterForm.getField('ENTRY_NUM').setReadOnly(true);
	        	masterForm.getField('ENTRY_DATE').setReadOnly(true);
	        	Ext.getCmp('rdoSelect').setReadOnly(true);
	        	masterForm.getField('DEPT_TYPE').setReadOnly(true);
        	}else{
	        	masterForm.getField('DIV_CODE').setReadOnly(false);
	        	masterForm.getField('ENTRY_NUM').setReadOnly(false);
	        	masterForm.getField('ENTRY_DATE').setReadOnly(false);
	        	Ext.getCmp('rdoSelect').setReadOnly(false);
	        	masterForm.getField('DEPT_TYPE').setReadOnly(false);
        	}
        },
        setHiddenColumn: function(newValue) {
        	if(newValue == '1'){
        		detailGrid.getColumn('WIRE_P').setHidden(true);
                detailGrid.getColumn('LASER_P').setHidden(true);
                detailGrid.getColumn('COAT_P').setHidden(true);
                detailGrid.getColumn('WIRE_S_P').setHidden(true);
                detailGrid.getColumn('ETC_P').setHidden(true);
                detailGrid.getColumn('MATERIAL_AMT').setHidden(false);
                detailGrid.getColumn('MAKE_AMT').setHidden(false);
                detailGrid.getColumn('ETC_AMT').setHidden(false);
            } else {
            	
                detailGrid.getColumn('WIRE_P').setHidden(false);
                detailGrid.getColumn('LASER_P').setHidden(false);
                detailGrid.getColumn('COAT_P').setHidden(false);
                detailGrid.getColumn('WIRE_S_P').setHidden(false);
                detailGrid.getColumn('ETC_P').setHidden(false);
                detailGrid.getColumn('MATERIAL_AMT').setHidden(true);
                detailGrid.getColumn('MAKE_AMT').setHidden(true);
                detailGrid.getColumn('ETC_AMT').setHidden(true);
            }
        }
    });
	Unilite.createValidator('validator01', {
		store: detailStore,
		grid: detailGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
		console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			switch(fieldName) {
				case "WIRE_P" : //와이어
					if(Ext.getCmp('rdoSelect').getValue().WORK_TYPE == '2'){
						var costAmt = 0;
						costAmt = newValue + record.get('LASER_P') + record.get('COAT_P') + record.get('WIRE_S_P') + record.get('ETC_P') ;
						record.set('COST_AMT' , costAmt);
					}
				break;
				case "LASER_P" : //와이어
					if(Ext.getCmp('rdoSelect').getValue().WORK_TYPE == '2'){
						var costAmt = 0;
						costAmt = record.get('WIRE_P') + newValue + record.get('COAT_P') + record.get('WIRE_S_P') + record.get('ETC_P') ;
						record.set('COST_AMT' , costAmt);
					}
				break;
				case "COAT_P" : //와이어
					if(Ext.getCmp('rdoSelect').getValue().WORK_TYPE == '2'){
						var costAmt = 0;
						costAmt = record.get('WIRE_P') + record.get('LASER_P') + newValue + record.get('WIRE_S_P') + record.get('ETC_P') ;
						record.set('COST_AMT' , costAmt);
					}
				break;
				case "WIRE_S_P" : //와이어
					if(Ext.getCmp('rdoSelect').getValue().WORK_TYPE == '2'){
						var costAmt = 0;
						costAmt = record.get('WIRE_P') + record.get('LASER_P') + record.get('COAT_P') + newValue + record.get('ETC_P') ;
						record.set('COST_AMT' , costAmt);
					}
				break;
				case "ETC_P" : //와이어
					if(Ext.getCmp('rdoSelect').getValue().WORK_TYPE == '2'){
						var costAmt = 0;
						costAmt = record.get('WIRE_P') + record.get('LASER_P') + record.get('COAT_P') + record.get('WIRE_S_P') + newValue ;
						record.set('COST_AMT' , costAmt);
					}
				break;
				case "MATERIAL_AMT" : //와이어
					if(Ext.getCmp('rdoSelect').getValue().WORK_TYPE == '1'){
						var costAmt = 0;
						costAmt = newValue + record.get('MAKE_AMT') + record.get('ETC_AMT');
						record.set('COST_AMT' , costAmt);
					}
				break;
				case "MAKE_AMT" : //와이어
					if(Ext.getCmp('rdoSelect').getValue().WORK_TYPE == '1'){
						var costAmt = 0;
						costAmt = record.get('MATERIAL_AMT') + newValue + record.get('ETC_AMT');
						record.set('COST_AMT' , costAmt);
					}
				break;
				case "ETC_AMT" : //와이어
					if(Ext.getCmp('rdoSelect').getValue().WORK_TYPE == '1'){
						var costAmt = 0;
						costAmt = record.get('MATERIAL_AMT') + record.get('MAKE_AMT') + newValue;
						record.set('COST_AMT' , costAmt);
					}
				break;
				case "MAKE_END_YN" : //제작완료
					if(record.obj.phantom == false && newValue == 'N'){
						if(BsaCodeInfo.gsAuthorityLevel != '15'){//관리자
							rv='완료내역 수정은 전산팀으로 문의하세요';
							break;
						}
					}
				break;
				
			}
			return rv;
		}
	});
}
</script>