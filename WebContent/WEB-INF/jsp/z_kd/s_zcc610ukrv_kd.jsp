<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_zcc610ukrv_kd"  >
    <t:ExtComboStore comboType="BOR120"  pgmId="s_zcc610ukrv_kd"  />             <!-- 사업장 -->
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
	var activeGridId = 'dummyGrid';
	var searchInfoWindow; // 검색창
    var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
        api: {
            read: 's_zcc610ukrv_kdService.selectDetail',
            update: 's_zcc610ukrv_kdService.updateDetail',
            syncAll: 's_zcc610ukrv_kdService.saveAll'
        }
    });
    var directSubProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
        api: {
            read: 's_zcc610ukrv_kdService.selectSubDetail',
            create: 's_zcc610ukrv_kdService.insertSubDetail',
            update: 's_zcc610ukrv_kdService.updateSubDetail',
            destroy: 's_zcc610ukrv_kdService.deleteSubDetail',
            syncAll: 's_zcc610ukrv_kdService.saveSubAll'
        }
    });
    Unilite.defineModel('detailModel', {
        fields: [
            {name: 'COMP_CODE'            ,text:'법인코드'                 ,type: 'string'},
            {name: 'DIV_CODE'             ,text:'사업장'                   ,type: 'string'},
            {name: 'ENTRY_NUM'            ,text:'관리번호'                 ,type: 'string'},
            {name: 'SER_NO'            	,text:'순번'                   ,type: 'int'},
            {name: 'DEPT_TYPE'            ,text:'부서구분'                 ,type: 'string', comboType:'AU', comboCode:'WZ32' },
            
            {name: 'ENTRY_DATE'    			,text:'등록일자'           	,type: 'uniDate'},
            {name: 'ITEM_CODE'    			,text:'품번'           	,type: 'string'},
            {name: 'ITEM_NAME'    		,text:'품명'            		,type: 'string'},
            {name: 'CUSTOM_CODE'          ,text:'납품업체'             	,type: 'string'},
            {name: 'CUSTOM_NAME'          ,text:'업체명'              	,type: 'string'},
            {name: 'MAKE_QTY'             ,text:'수량'                 	,type: 'float', decimalPrecision: 0, format:'0,000'},          
            {name : 'MAKE_UNIT',       text : '단위',                type : 'string'},
            {name: 'WIRE_P'             ,text:'와이어'                 	,type: 'float', decimalPrecision: 0, format:'0,000'},
            {name: 'LASER_P'             ,text:'레이저'                 ,type: 'float', decimalPrecision: 0, format:'0,000'},
            {name: 'COAT_P'             ,text:'코팅'                 	,type: 'float', decimalPrecision: 0, format:'0,000'},
            {name: 'WIRE_S_P'             ,text:'와이어S'               ,type: 'float', decimalPrecision: 0, format:'0,000'},
            {name: 'ETC_P'             ,text:'기타'                 	,type: 'float', decimalPrecision: 0, format:'0,000'},
            {name: 'MATERIAL_AMT'             ,text:'재료비'            ,type: 'float', decimalPrecision: 0, format:'0,000'},
            {name: 'MAKE_AMT'             ,text:'가공비'                ,type: 'float', decimalPrecision: 0, format:'0,000'},
            {name: 'ETC_AMT'             ,text:'기타'                 ,type: 'float', decimalPrecision: 0, format:'0,000'},
            {name: 'COST_AMT'             ,text:'합계금액'               ,type: 'float', decimalPrecision: 0, format:'0,000'},
            {name: 'COLLECT_CNT'             ,text:'수금등록데이터'         ,type: 'float', decimalPrecision: 0, format:'0,000'},
            {name: 'EST_AMT'             ,text:'견적가'                 ,type: 'float', decimalPrecision: 0, format:'0,000'},
            {name: 'MARGIN_AMT'             ,text:'마진금액'             ,type: 'float', decimalPrecision: 0, format:'0,000'},
            {name: 'TEMP_AMT'             ,text:'임시가'                ,type: 'float', decimalPrecision: 0, format:'0,000'},
            {name: 'NEGO_AMT'             ,text:'네고가'                ,type: 'float', decimalPrecision: 0, format:'0,000'},
            {name: 'DELIVERY_QTY'             ,text:'납품수량'           ,type: 'float', decimalPrecision: 0, format:'0,000'},
            {name: 'DELIVERY_AMT'             ,text:'납품액'            ,type: 'float', decimalPrecision: 0, format:'0,000'},
            {name: 'DELIVERY_DATE'             ,text:'납품일자'           ,type: 'uniDate'},
            {name: 'MAKE_END_YN'             ,text:'제작완료'              ,type: 'string', comboType:'AU', comboCode:'B131' },
            {name: 'CLOSE_YN'             ,text:'완료여부'                ,type: 'string', comboType:'AU', comboCode:'B131' },
            {name: 'DELIVERY_YN'             ,text:'납품완료'                ,type: 'string', comboType:'AU', comboCode:'B131' },
            {name: 'REMARK'             ,text:'비고'                 		,type: 'string'},
            {name: 'EST_REMARK'             ,text:'견적비고'                 		,type: 'string'}
        ]
    });
    var detailStore = Unilite.createStore('detailStore',{
        model: 'detailModel',
        uniOpt : {
            isMaster:  true,            // 상위 버튼 연결
            editable:  false,            // 수정 모드 사용
            deletable: false,            // 삭제 가능 여부
            useNavi :  false            // prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: directProxy,
        loadStoreRecords : function()   {
            var param= panelSearch.getValues();
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
            if(inValidRecs.length == 0 )    {
                 config = {
                    success: function(batch, option) {
    					var selectDetailGrid = detailGrid.getSelectedRecord();
                    	subStore.loadStoreRecords(selectDetailGrid);
                     }
                };
                this.syncAllDirect(config);
            } else {
                var grid = Ext.getCmp('detailGrid');
                grid.uniSelectInvalidColumnAndAlert(inValidRecs);
            }
        }
    });

    var panelSearch = Unilite.createSearchForm('panelSearch',{
        region: 'north',
        layout : {type : 'uniTable', columns : 5},
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
			xtype: 'uniDateRangefield',
			startFieldName: 'ENTRY_DATE_FR',
			endFieldName: 'ENTRY_DATE_TO',
			startDate: UniDate.get('startOfMonth'),
			endDate: UniDate.get('today')
		},{
            fieldLabel: '완료여부',
            name:'CLOSE_YN',
            xtype: 'uniCombobox',
            comboType:'AU',
            comboCode:'B131',
            colspan:2
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
		})]
    });

    var detailGrid = Unilite.createGrid('detailGrid', {
        layout : 'fit',
        region: 'center',
        store: detailStore,
        uniOpt: {
            expandLastColumn: true,
            useMultipleSorting: false,
            useGroupSummary: true,
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
            { dataIndex: 'COMP_CODE'                                   ,width: 100,hidden:true},
            { dataIndex: 'DIV_CODE'                                    ,width: 100,hidden:true},
            { dataIndex: 'ENTRY_NUM'                                   ,width: 80},
            { dataIndex: 'SER_NO'                                      ,width: 50},
            { dataIndex: 'DEPT_TYPE'                                      ,width: 100},

            { dataIndex: 'ENTRY_DATE'                                  ,width: 100},
            { dataIndex: 'ITEM_CODE'                                   ,width: 100},
            { dataIndex: 'ITEM_NAME'                                   ,width: 200},
            { dataIndex: 'CUSTOM_CODE'                                 ,width: 100},
            { dataIndex: 'CUSTOM_NAME'                                 ,width: 100},
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
            { dataIndex: 'EST_AMT'                                    ,width: 100,hidden:true},
            { dataIndex: 'MARGIN_AMT'                                    ,width: 100,hidden:true},
            { dataIndex: 'TEMP_AMT'                                    ,width: 100,hidden:true},
            { dataIndex: 'NEGO_AMT'                                    ,width: 100,hidden:true},
            { dataIndex: 'DELIVERY_QTY'                                    ,width: 100,hidden:true},
            { dataIndex: 'DELIVERY_AMT'                                    ,width: 100,hidden:true},
            { dataIndex: 'DELIVERY_DATE'                                    ,width: 100,hidden:true},
            { dataIndex: 'CLOSE_YN'                                    ,width: 100,hidden:true},
            { dataIndex: 'DELIVERY_YN'                                    ,width: 100,hidden:true},
            { dataIndex: 'MAKE_END_YN'                                 ,width: 100},
            { dataIndex: 'REMARK'                                    ,width: 300},
            { dataIndex: 'EST_REMARK'                                    ,width: 300,hidden:true}
        ],
        listeners: {
        	beforeselect: function(){
		    	if(subStore.isDirty()){
		    		Unilite.messageBox('수금등록내역을 입력중입니다. 먼저 저장해주세요.');
		    		return false;
		    	}
        	},
			selectionchangerecord:function(selected)	{
				subForm.setActiveRecord(selected);
				subForm.enable();
				subGrid.enable();
				if(Ext.isEmpty(selected.get('EST_AMT')) && Ext.isEmpty(selected.get('DELIVERY_QTY'))){
					subForm.setValue('DELIVERY_QTY',selected.get('MAKE_QTY'));
				}
				if(Ext.isEmpty(selected.get('EST_AMT'))){
					subForm.setValue('DELIVERY_DATE',UniDate.get('today'));
				}
				subStore.loadStoreRecords(selected);
				if(selected.get('DELIVERY_YN') == 'Y'){	//납품완료
					fnSubFormControl(true);
					
				}else{
					
					if(BsaCodeInfo.gsAuthorityLevel == '15'){
						fnSubFormControl(false);	
						
					}
				}
				
				if(selected.get('CLOSE_YN') == 'Y'){ //완료여부
					
					subGrid.disable();
					subForm.getField('EST_REMARK').setReadOnly(true);
				}else{
					
					if(BsaCodeInfo.gsAuthorityLevel == '15'){
						
						subGrid.enable();
						subForm.getField('EST_REMARK').setReadOnly(false);
					}
				}
				
				
//				if(BsaCodeInfo.gsAuthorityLevel != '15'){
//					fnSubFormControl(true);
//					if(selected.get('CLOSE_YN') == 'Y'){
//						subGrid.disable();
//					}
//					return false;
//				}else{
//					fnSubFormControl(false);
//					return false;
//				}
//				
				
//				}else{
//					fnSubFormControl(false);
//					return false;
//				}

    			/* if(BsaCodeInfo.gsAuthorityLevel != '15'){
					if(selected.get('MAKE_END_YN') != 'Y'){
						subForm.disable();
						subGrid.disable();
						return false;
					}
					if(selected.get('DELIVERY_YN') == 'Y' && selected.get('CLOSE_YN') == 'Y'){
						subGrid.disable();
						return false;
					}else if(selected.get('DELIVERY_YN') == 'Y' && selected.get('CLOSE_YN') == 'N'){
						subGrid.enable();
						return false;
					}else{
						subGrid.disable();
						return false;
					}
    			} */
			},
			render: function(grid, eOpts){
			 	var girdNm = grid.getItemId();
			    grid.getEl().on('click', function(e, t, eOpt) {
			    	var oldGrid = Ext.getCmp(activeGridId);
			    	if(subStore.isDirty()){
			    		return false;
			    	}
			    	grid.changeFocusCls(oldGrid);
			    	activeGridId = girdNm;
	    			UniAppManager.setToolbarButtons(['newData','delete'],false);
			    });
			 }
        }
    });

    var subForm = Unilite.createSearchForm('subForm',{
        region: 'center',
        layout : {type : 'uniTable', columns : 3},
        masterGrid: detailGrid,
        border:false,
    	padding:'20 90 20 1',
    	width:850,
        items: [{
            fieldLabel: '견적가',
			name:'EST_AMT',
			xtype:'uniNumberfield',
			decimalPrecision: 0,
			format:'0,000',
			allowBlank:false,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					setTimeout( function() {
    					var selectDetailGrid = detailGrid.getSelectedRecord();
    					if(!Ext.isEmpty(newValue) && newValue != 0){
							subForm.setValue('MARGIN_AMT',newValue - selectDetailGrid.get('COST_AMT'));
    					}
					}, 50 );
//					setTimeout( function() {
//    					var selectDetailGrid = detailGrid.getSelectedRecord();
//    					if(!Ext.isEmpty(selectDetailGrid.get('EST_AMT')) && selectDetailGrid.get('EST_AMT') != 0){
//							subForm.setValue('MARGIN_AMT',newValue - selectDetailGrid.get('COST_AMT'));
//    					}
//					}, 50 );
				}
			}
		},{
            fieldLabel: '마진금액',
			name:'MARGIN_AMT',
			xtype:'uniNumberfield',
			decimalPrecision: 0,
			format:'0,000',
			colspan:2,
			readOnly: true
		},{
            fieldLabel: '임시가',
			name:'TEMP_AMT',
			xtype:'uniNumberfield',
			decimalPrecision: 0,
			format:'0,000',
			colspan:3
		},{
            fieldLabel: '네고가',
			name:'NEGO_AMT',
			xtype:'uniNumberfield',
			decimalPrecision: 0,
			format:'0,000',
			allowBlank:false,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					subForm.setValue('DELIVERY_AMT',newValue * subForm.getValue('DELIVERY_QTY'));
				}
			}
		},{
            fieldLabel: '납품수량',
			name:'DELIVERY_QTY',
			xtype:'uniNumberfield',
			decimalPrecision: 0,
			format:'0,000',
			colspan:2,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					subForm.setValue('DELIVERY_AMT',newValue * subForm.getValue('NEGO_AMT'));
				}
			}
		},{
            fieldLabel: '납품액',
			name:'DELIVERY_AMT',
			xtype:'uniNumberfield',
			decimalPrecision: 0,
			format:'0,000',
			readOnly: true
		},{
            fieldLabel: '납품일자',
            name: 'DELIVERY_DATE',
            xtype: 'uniDatefield',
            value: UniDate.get('today'),
			colspan:1
        },{
            fieldLabel: '납품완료',
            name:'DELIVERY_YN',
            xtype: 'uniCombobox',
            comboType:'AU',
            comboCode:'B131',
            allowBlank:false,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					
					setTimeout( function() {
						 if(detailStore.isDirty() == true){ 
						
							if(newValue == 'Y'){
								if(Ext.isEmpty(subForm.getValue('DELIVERY_AMT')) || subForm.getValue('DELIVERY_AMT') == 0 || Ext.isEmpty(subForm.getValue('DELIVERY_DATE')) ){
									Unilite.messageBox('납품액과 납품금액을 먼저 입력하세요');
									subForm.setValue('DELIVERY_YN','N');
								}else{
									fnSubFormControl(true);
								}
							}else{
								if(BsaCodeInfo.gsAuthorityLevel != '15'){
									Unilite.messageBox('납품내역 수정은 전산팀으로 문의하세요');
									subForm.setValue('DELIVERY_YN','Y');
								}else{
									fnSubFormControl(false);
								}
							}
						 }
					}, 50 );
				}
			}
        },{
            fieldLabel: '수금액',
			name:'SUM_COLLECT_AMT',
			xtype:'uniNumberfield',
			decimalPrecision: 0,
			format:'0,000',
			readOnly: true
		},{
            fieldLabel: '수금일자',
            name: 'MAX_COLLECT_DATE',
            xtype: 'uniDatefield',
            value: UniDate.get('today'),
			readOnly: true
        },{
            fieldLabel: '완료여부',
            name:'CLOSE_YN',
            xtype: 'uniCombobox',
            comboType:'AU',
            comboCode:'B131',
            allowBlank:false,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					
					setTimeout( function() {
						 if(detailStore.isDirty() == true){ 
							if(newValue == 'Y'){
								
								if(BsaCodeInfo.gsAuthorityLevel != '15'){
									Unilite.messageBox('수금완료 처리는 전산팀으로 문의하세요');
									subForm.setValue('CLOSE_YN','N');
								}else{
									subGrid.disable();
									subForm.getField('EST_REMARK').setReadOnly(true);
								}
							}else{
								if(BsaCodeInfo.gsAuthorityLevel != '15'){
									Unilite.messageBox('완료내역 수정은 전산팀으로 문의하세요');
									subForm.setValue('CLOSE_YN','Y');
								}else{
									subGrid.enable();
									subForm.getField('EST_REMARK').setReadOnly(false);
								}
							}
						 }
					}, 50 );
				}
			}
        },{
            fieldLabel: '미수금액',
			name:'NO_COLLECT_AMT',
			xtype:'uniNumberfield',
			decimalPrecision: 0,
			format:'0,000',
			readOnly: true,
			colspan:3
		},{
            fieldLabel: '비고',
            name:'EST_REMARK',
            xtype: 'uniTextfield',
            width:740,
			colspan:3
        }],
		listeners:{
			render: function(form, eOpts){
			 	var girdNm = detailGrid.getItemId();
			    form.getEl().on('click', function(e, t, eOpt) {
			    	var oldGrid = Ext.getCmp(activeGridId);
			    	if( subStore.isDirty() )	{
			    		Unilite.messageBox('수금등록내역을 입력중입니다. 먼저 저장해주세요.');
			    		return false;
			    	}
			    	detailGrid.changeFocusCls(oldGrid);
			    	activeGridId = girdNm;
	    			UniAppManager.setToolbarButtons(['newData','delete'],false);
		    	});
			}
		}
    });

    Unilite.defineModel('subModel', {
        fields: [
            {name: 'COMP_CODE'            ,text:'법인코드'         ,type: 'string',editable:false},
            {name: 'DIV_CODE'             ,text:'사업장'          ,type: 'string',editable:false},
            {name: 'ENTRY_NUM'            ,text:'관리번호'         ,type: 'string',editable:false},
            {name: 'SER_NO'            	,text:'관리순번'                   ,type: 'int',editable:false},
            {name: 'EST_SEQ'              ,text:'순번'            ,type: 'int',editable:false},
            {name: 'COLLECT_DATE'    	  ,text:'수금일자'         ,type: 'uniDate',allowBlank:false},
            {name: 'COLLECT_QTY'    	  ,text:'수량'           ,type: 'float', decimalPrecision: 0, format:'0,000'},
            {name: 'COLLECT_AMT'    	  ,text:'금액'           	,type: 'float', decimalPrecision: 0, format:'0,000',allowBlank:false},
            {name: 'REMARK'    			  ,text:'비고'           	,type: 'string'}
        ]
    });

    var subStore = Unilite.createStore('subStore',{
        model: 'subModel',
        uniOpt : {
            isMaster:  false,            // 상위 버튼 연결
            editable:  true,            // 수정 모드 사용
            deletable: false,            // 삭제 가능 여부
            useNavi :  false            // prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: directSubProxy,
        loadStoreRecords: function(selectDetailGrid) {
            var param= {};
			param.DIV_CODE = selectDetailGrid.get('DIV_CODE');
			param.ENTRY_NUM = selectDetailGrid.get('ENTRY_NUM');
			param.SER_NO = selectDetailGrid.get('SER_NO');
            this.load({
				params : param,
				callback : function(records, operation, success) {
					if(success) {
						subForm.setValue('SUM_COLLECT_AMT',subStore.data.sum('COLLECT_AMT'));
						subForm.setValue('MAX_COLLECT_DATE',subStore.data.max('COLLECT_DATE'));
						subForm.setValue('NO_COLLECT_AMT', subForm.getValue('DELIVERY_AMT')-subStore.data.sum('COLLECT_AMT'));
						if(BsaCodeInfo.gsAuthorityLevel != '15'){
							if(selectDetailGrid.get('MAKE_END_YN') == 'Y'){
								if(selectDetailGrid.get('CLOSE_YN') == 'Y'){
									subGrid.disable();
								}else{
									subGrid.enable();
								}
							}
    					}
					}
				}
            });
        },
        saveStore : function()  {
            var inValidRecs = this.getInvalidRecords();
            var rv = true;
            var toCreate = this.getNewRecords();
            var toUpdate = this.getUpdatedRecords();
            var toDelete = this.getRemovedRecords();
            var list = [].concat(toUpdate, toCreate);
            if(inValidRecs.length == 0 )    {
                 config = {
                    success: function(batch, option) {
        				var selectDetailGrid = detailGrid.getSelectedRecord();
						subStore.loadStoreRecords(selectDetailGrid);
						if(subForm.getValue('DELIVERY_AMT')-subStore.data.sum('COLLECT_AMT') == 0){
							var param = {
								S_COMP_CODE : selectDetailGrid.get('COMP_CODE'),
								DIV_CODE : selectDetailGrid.get('DIV_CODE'),
								ENTRY_NUM : selectDetailGrid.get('ENTRY_NUM'),
								SER_NO : selectDetailGrid.get('SER_NO')
							}
							s_zcc610ukrv_kdService.closeYnUpdate(param, function(provider, response) {
								if(provider) {
									subForm.setValue('CLOSE_YN','Y');
									detailStore.commitChanges();
								}
							});
						}
                     }
                };
                this.syncAllDirect(config);
            } else {
                var grid = Ext.getCmp('subGrid');
                grid.uniSelectInvalidColumnAndAlert(inValidRecs);
            }
        }
    });

    var subGrid = Unilite.createGrid('subGrid', {
        layout : 'fit',
        region: 'center',
        store: subStore,
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
        dockedItems : [{
			xtype	: 'toolbar',
			dock	: 'top',
			items	: [{
				xtype	: 'uniBaseButton',
				text	: '<t:message code="system.label.base.add" default="추가"/>',
				tooltip	: '<t:message code="system.label.base.add" default="추가"/>',
				iconCls	: 'icon-new',
				width	: 26,
				height	: 26,
				itemId	: 'sub_newData',
				handler: function() {
	        		var selectDetailGrid = detailGrid.getSelectedRecord();
	        		if(Ext.isEmpty(selectDetailGrid)){
	        			Unilite.messageBox('금형제작내역을 선택해주세요.');
	        			return false;
	        		}
		            var compCode        = UserInfo.compCode;
		            var divCode         = selectDetailGrid.get('DIV_CODE');
		            var entryNum        = selectDetailGrid.get('ENTRY_NUM');
		            var serNo        = selectDetailGrid.get('SER_NO');
		            var seq             = subStore.max('EST_SEQ');
		            if(!seq) seq = 1;
		            else seq += 1;
		            var r = {
		                COMP_CODE:	compCode,
		                DIV_CODE:	divCode,
		                ENTRY_NUM:	entryNum,
		                SER_NO : serNo,
		                EST_SEQ:	seq
		            };
		            subGrid.createRow(r);
	        	}
			},{
				xtype		: 'uniBaseButton',
				text		: '<t:message code="system.label.base.delete" default="삭제"/>',
				tooltip		: '<t:message code="system.label.base.delete" default="삭제"/>',
				iconCls		: 'icon-delete',
				width		: 26,
				height		: 26,
				itemId		: 'sub_delete',
				handler	: function() {
		    		var selectDetailGrid = detailGrid.getSelectedRecord();
		    		if(!Ext.isEmpty(selectDetailGrid)){
			    		if(selectDetailGrid.get('CLOSE_YN') == 'Y'){
			    			Unilite.messageBox('납품내역이 완료된 데이터입니다. 삭제가 불가능합니다.');
			    			return false;
			    		}
		    		}
		        	var selRow = subGrid.getSelectedRecord();
		    		if(!Ext.isEmpty(selRow)){
			            if(selRow.phantom === true) {
			                subGrid.deleteSelectedRow();
			            } else if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
			                subGrid.deleteSelectedRow();
			            }
		    		}
		        }
			},{
				xtype		: 'uniBaseButton',
				text		: '<t:message code="system.label.base.save" default="저장 "/>',
				tooltip		: '<t:message code="system.label.base.save" default="저장 "/>',
				iconCls		: 'icon-save',
				width		: 26,
				height		: 26,
				itemId		: 'sub_save',
				handler	: function() {
					subStore.saveStore();
				}
			}]
		}],
		features: [
			{id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false},
		    {id : 'masterGridTotal' ,   ftype: 'uniSummary', 	     showSummaryRow: true}
		],
        columns:  [
            { dataIndex: 'COMP_CODE'                              ,width: 100,hidden:true},
            { dataIndex: 'DIV_CODE'                               ,width: 100,hidden:true},
            { dataIndex: 'ENTRY_NUM'                              ,width: 100,hidden:true},
            { dataIndex: 'SER_NO'                                ,width: 100,hidden:true},
            { dataIndex: 'EST_SEQ'                                ,width: 80,
            	summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
					return Unilite.renderSummaryRow(summaryData, metaData, '', '합계');
				}
            },
            { dataIndex: 'COLLECT_DATE'                           ,width: 100},
            { dataIndex: 'COLLECT_QTY'                            ,width: 100,summaryType:'sum'},
            { dataIndex: 'COLLECT_AMT'                            ,width: 100,summaryType:'sum'},
            { dataIndex: 'REMARK'                                 ,width: 300}
        ],
        listeners: {
			render: function(grid, eOpts){
			 	var girdNm = grid.getItemId();
			    grid.getEl().on('click', function(e, t, eOpt) {
			    	var oldGrid = Ext.getCmp(activeGridId);
			    	if( detailStore.isDirty() )	{
			    		Unilite.messageBox('납품내역을 입력중입니다. 먼저 저장해주세요.');
			    		return false;
			    	}
			    	grid.changeFocusCls(oldGrid);
			    	activeGridId = girdNm;
			    	UniAppManager.setToolbarButtons(['newData','delete'],false);
			    });
			 }
        }
    });

    function fnSubFormControl(flag){
    	subForm.getField('EST_AMT').setReadOnly(flag);
    	subForm.getField('TEMP_AMT').setReadOnly(flag);
    	subForm.getField('NEGO_AMT').setReadOnly(flag);
    	subForm.getField('DELIVERY_QTY').setReadOnly(flag);
    	subForm.getField('DELIVERY_DATE').setReadOnly(flag);
    	
    	
    }

    Unilite.Main( {
        borderItems:[{
            region:'center',
            layout: 'border',
            border: false,
            items:[
                panelSearch, detailGrid
            ]
        },{
            layout: {type: 'hbox', align: 'stretch'},
            region: 'south',
            split:true,
            items: [subForm,subGrid]
		}],
        id  : 's_zcc610ukrv_kdApp',
        fnInitBinding : function() {
            this.setDefault();
        },
        onQueryButtonDown : function()  {
            if(!panelSearch.getInvalidMessage()) return;   //필수체크
            detailStore.loadStoreRecords();
	    	detailGrid.changeFocusCls(Ext.getCmp('subGrid'));
	    	activeGridId = detailGrid.getItemId();
	    	UniAppManager.setToolbarButtons(['newData','delete'],false);
        },
        onResetButtonDown: function() {
            panelSearch.clearForm();
//            detailStore.clearData();
//            detailGrid.reset();
            detailGrid.getStore().loadData({});
            subForm.clearForm();
//            subStore.clearData();
//            subGrid.reset();
            subGrid.getStore().loadData({});
            this.setDefault();
        },
        onSaveDataButtonDown: function () {
			detailStore.saveStore();
        },
        setDefault: function() {
	    	detailGrid.changeFocusCls(Ext.getCmp('subGrid'));
	    	activeGridId = detailGrid.getItemId();
            panelSearch.setValue('DIV_CODE',UserInfo.divCode);
            panelSearch.setValue('ENTRY_DATE_FR', UniDate.get('startOfMonth'));
            panelSearch.setValue('ENTRY_DATE_TO', UniDate.get('today'));
            panelSearch.setValue('WORK_TYPE', '1');
            panelSearch.setValue('CLOSE_YN', 'N');
//            if(BsaCodeInfo.gsAuthorityLevel != '15'){
//            	subForm.getField('CLOSE_YN').setReadOnly(true);
//            	subForm.getField('DELIVERY_YN').setReadOnly(true);
//            }else{
//            	subForm.getField('CLOSE_YN').setReadOnly(false);
//            	subForm.getField('DELIVERY_YN').setReadOnly(false);
//            }
            UniAppManager.setToolbarButtons(['save', 'newData','delete'],false);
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
}
</script>