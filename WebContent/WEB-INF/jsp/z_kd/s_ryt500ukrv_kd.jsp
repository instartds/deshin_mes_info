<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_ryt500ukrv_kd"  >
    <t:ExtComboStore comboType="BOR120"  pgmId="s_ryt500ukrv_kd"  />            <!-- 사업장 -->
    <t:ExtComboStore comboType="AU" comboCode="B004" />                         <!-- 화폐단위-->
    <t:ExtComboStore comboType="AU" comboCode="B131" />                         <!-- BOM적용여부 -->
    <t:ExtComboStore comboType="AU" comboCode="WR04" />                         <!-- 수량/금액-->
    <t:ExtComboStore comboType="AU" comboCode="WR01" />                         <!-- 비율/단가 -->
    <t:ExtComboStore comboType="AU" comboCode="B010" />                         <!-- 사용-->
     <t:ExtComboStore comboType="AU" comboCode="BS90" /> <!--작업년도-->
</t:appConfig>
<script type="text/javascript" >

var selectedMasterGrid = 's_ryt500ukrv_kdGrid';
var gwFlag = '';
var cellClickChk = '0';
function appMain() {

    var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
        api: {
            read: 's_ryt500ukrv_kdService.selectList',
            create: 's_ryt500ukrv_kdService.insertDetail',
           update: 's_ryt500ukrv_kdService.updateDetail',
           destroy: 's_ryt500ukrv_kdService.deleteAll',
            syncAll: 's_ryt500ukrv_kdService.saveAll'
        }
    });

    var directProxy2 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
        api: {
            read: 's_ryt500ukrv_kdService.selectList2',
            create 	: 's_ryt500ukrv_kdService.insertDetail2',
            update: 's_ryt500ukrv_kdService.updateDetail2',
            destroy: 's_ryt500ukrv_kdService.deleteDetail2',
            syncAll: 's_ryt500ukrv_kdService.saveAll2'
        }
    });

    /**
     *   Model 정의
     * @type
     */
    Unilite.defineModel('s_ryt500ukrv_kdModel', {
        fields: [
            {name: 'COMP_CODE'              ,text: '법인코드'              ,type: 'string'},
            {name: 'DIV_CODE'               ,text: '사업자코드'             ,type: 'string'},
            {name: 'CUSTOM_CODE'            ,text: '거래처코드'             ,type: 'string'},
            {name: 'CUSTOM_NAME'            ,text: '거래처명'              ,type: 'string'},
            {name: 'CON_FR_YYMM'            ,text: '정산시작월'             ,type: 'uniMonth'},
            {name: 'CON_TO_YYMM'            ,text: '정산종료월'             ,type: 'uniMonth'},
            {name: 'GUBUN1'                 ,text: '정산기준'             ,type: 'string', comboType:'AU', comboCode:'WR05'},
            {name: 'MONEY_UNIT'             ,text: '화폐'                ,type: 'string', comboType:'AU', comboCode:'B004', displayField: 'value'},
            {name: 'MONEY_UNIT_ORI'         ,text: '국가화폐'                ,type: 'string', comboType:'AU', comboCode:'B004', displayField: 'value'},
            {name: 'EXCHG_RATE_O'           ,text: '환율'                ,type: 'float', allowBlank: true, decimalPrecision: 4, format: '0,000,000.0000'},
            {name: 'EXCHG_RATE_O2'          ,text: '환율TEMP'            ,type: 'float', format: '0,000,000.0000'},
            {name: 'CAL_YN'                 ,text: '정산여부'              ,type: 'string', comboType:'AU', comboCode:'B010'},   // 정산여부
            {name: 'CAL_DATE'               ,text: '정산일자'              ,type: 'uniDate'},
            {name: 'QTY_SELL_FOR'           ,text: '매출수량'               ,type: 'uniQty'},
            {name: 'AMT_SELL_WON'           ,text: '매출액'           ,type: 'uniFC'},
            {name: 'AMT_SELL_FOR'           ,text: '매출액(외화)'           ,type: 'uniFC'},
            {name: 'AMT_DEDUCT_FOR'         ,text: '차감총액'          ,type: 'uniFC'},
            {name: 'AMT_NET_SELL_FOR'       ,text: '순매가'           ,type: 'uniFC'},
            {name: 'AMT_ROYALTY_FOR'        ,text: '로열티(외화)'           ,type: 'uniFC'},
            {name: 'AMT_ROYALTY'            ,text: '로열티(자사)'           ,type: 'uniPrice'},
            {name: 'GUBUN2'                 ,text: '수량금액구분'            ,type: 'string', comboType:'AU', comboCode:'WR04'},
            {name: 'GUBUN3'                 ,text: 'BOM적용'              ,type: 'string', comboType:'AU', comboCode:'B131'},
            {name: 'RYT_P'                  ,text: '단가'                 ,type: 'uniUnitPrice'},
            {name: 'CHK'                    ,text: '선택'                 ,type: 'string'},
            {name: 'WORK_YEAR'              ,text: '작업년도'         		 ,type: 'string'},
            {name: 'WORK_SEQ'               ,text: '반기'            	     ,type: 'string'},
            {name: 'CONFIRM_YN'             ,text: '확정여부'         		 ,type: 'string', comboType:'AU', comboCode:'B010'},
            {name: 'BALANCE_NUM'            ,text: '정산번호'            	 ,type: 'string'},
            {name: 'GW_DOCU_NUM'           ,text: '기안문서번호'         		  ,type: 'string'},
            {name: 'GW_FLAG'               ,text: '기안여부'           		  ,type: 'string',comboType:'AU', comboCode:'WB17'},
            {name: 'DRAFT_NO'              ,text: 'DRAFT_NO'        	  ,type: 'string'},
        ]
    });

    Unilite.defineModel('s_ryt500ukrv_kdModel2', {
        fields: [
            {name: 'COMP_CODE'              ,text: '법인코드'               ,type: 'string' , editable: false},
            {name: 'DIV_CODE'               ,text: '사업자코드'             ,type: 'string', editable: false},
            {name: 'SELL_MONTH'             ,text: '매출년월'               ,type: 'string', editable: false},
            {name: 'ITEM_CODE'              ,text: '품목코드'               ,type: 'string', editable: false},
            {name: 'ITEM_NAME'              ,text: '품목명'                 ,type: 'string', editable: false},
            {name: 'SPEC'                   ,text: '규격'                   ,type: 'string', editable: false},
            {name: 'SALES_CUSTOM_CODE'      ,text: '매출처코드'             ,type: 'string', editable: false},
            {name: 'SALES_CUSTOM_NAME'      ,text: '매출처명'               ,type: 'string', editable: false},
            {name: 'QTY_SELL'               ,text: '매출수량'               ,type: 'uniQty', editable: true},
            {name: 'D_AMT_SELL_WON'         ,text: '매출액'           ,type: 'uniFC', editable: true},
            {name: 'D_AMT_SELL_FOR'         ,text: '매출액(외화)'           ,type: 'uniFC', editable: true},
            {name: 'D_AMT_DEDUCT_FOR'       ,text: '차감총액'         ,type: 'uniFC', editable: false},
            {name: 'CUSTOM_CODE'            ,text: '거래처코드'             ,type: 'string', editable: false},
            {name: 'CUSTOM_NAME'            ,text: '거래처명'               ,type: 'string', editable: false},
            {name: 'CON_FR_YYMM'            ,text: '정산시작월'             ,type: 'string', editable: false},
            {name: 'CON_TO_YYMM'            ,text: '정산종료월'             ,type: 'string', editable: false},
            {name: 'GUBUN1'                 ,text: '비율/단가'              ,type: 'string', comboType:'AU', comboCode:'WR01', editable: false},
            {name: 'RATE_N'                 ,text: '로열티'                   ,type: 'uniPercent', editable: false},
            {name: 'RYT_P'                  ,text: '단가'                   ,type: 'uniUnitPrice', editable: false},
            {name: 'D_AMT_NET_SELL_FOR'     ,text: '순매가'           ,type: 'uniFC', editable: false},
            {name: 'D_AMT_ROYALTY_FOR'      ,text: '로열티(외화)'           ,type: 'uniFC', editable: false},
            {name: 'D_AMT_ROYALTY_WON'      ,text: '로열티(원화)'           ,type: 'uniFC', editable: false},
            {name: 'WORK_YEAR'              ,text: '작업년도'              ,type: 'string', editable: false},
            {name: 'WORK_SEQ'               ,text: '반기'              ,type: 'string', editable: false},
            {name: 'MONEY_UNIT'             ,text: '화폐'              ,type: 'string', editable: false},
            {name: 'EXCHG_RATE_O'           ,text: '환율'              ,type: 'string', editable: false},
            {name: 'BALANCE_NUM'            ,text: '정산번호'            	 ,type: 'string'}
        ]
    });

    /**
     * Store 정의(Service 정의)
     * @type
     */
    var directMasterStore = Unilite.createStore('s_ryt500ukrv_kdMasterStore1',{
        model: 's_ryt500ukrv_kdModel',
        uniOpt : {
            isMaster:  true,            // 상위 버튼 연결
            editable:  true,            // 수정 모드 사용
            deletable: true,           // 삭제 가능 여부
            useNavi :  false            // prev | newxt 버튼 사용
        },
        autoLoad: true,
        proxy: directProxy,
        loadStoreRecords : function()   {
            var param= panelResult.getValues();
            this.load({
                  params : param
            });
        },
        saveStore: function(gsRecord, gsConfrim) {
            var inValidRecs = this.getInvalidRecords();
            console.log("inValidRecords : ", inValidRecs);

            var toCreate = this.getNewRecords();
            var toUpdate = this.getUpdatedRecords();
            var toDelete = this.getRemovedRecords();
            var list = [].concat(toUpdate, toCreate);
            console.log("inValidRecords : ", inValidRecs);
            console.log("list:", list);
            console.log("this.data.filterBy(this.filterInvalidNewRecords).items : ", this.data.filterBy(this.filterInvalidNewRecords));

            //1. 마스터 정보 파라미터 구성
            var paramMaster= panelResult.getValues();    //syncAll 수정
           if(!Ext.isEmpty(gsRecord)){
        	   paramMaster.CON_FR_YYMM = UniDate.getDbDateStr(gsRecord.get('CON_FR_YYMM')).substring(0,6);
               paramMaster.CON_TO_YYMM = UniDate.getDbDateStr(gsRecord.get('CON_TO_YYMM')).substring(0,6);
           }
            paramMaster.SAVE_TYPE	= gsConfrim; //gsConfrim이 CALC이면 로얄티정산, CONFIRM이면 확정용도

            if(inValidRecs.length == 0) {
                config = {
                    params: [paramMaster],
                    success: function(batch, option) {
                        panelResult.getForm().wasDirty = false;
                        panelResult.resetDirtyStatus();
                        console.log("set was dirty to false");
                        UniAppManager.setToolbarButtons('save', false);
//                        UniAppManager.app.onQueryButtonDown();
                    }
                };
                this.syncAllDirect(config);
            } else {
                masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
            }
        },
        listeners:{
    		 	load: function(store, records, successful, eOpts) {
    		 		if(!Ext.isEmpty(records)){
    		 			var records = directMasterStore.data.items;
      		 			cellClickChk = '1';
    		 			masterGrid.fireEvent('cellclick','','','',records[0]);
    		 			cellClickChk = '0';
	    		 		gwFlag = records[0].get('GW_FLAG');
	    		 		rateUnitPchk = records[0].get('GUBUN1');
	    		 		saveRate = records[0].get('EXCHG_RATE_O');
	    		 		saveMoneyUnit = records[0].get('MONEY_UNIT_ORI');
						console.log(saveRate);
						console.log(saveMoneyUnit);
	               		if(gwFlag == '3' ){
	               			//UniAppManager.setToolbarButtons('save', false);
	               			Ext.getCmp('CAL_BTN').setDisabled(true);
	               		}

// 						if(rateUnitPchk == 'R'){
// 							masterGrid2.getColumn('RYT_P').setVisible(false);
// 							masterGrid2.getColumn('RATE_N').setVisible(true);
// 						}else{
// 							masterGrid2.getColumn('RATE_N').setVisible(false);
// 							masterGrid2.getColumn('RYT_P').setVisible(true);
// 						}
						if(!Ext.isEmpty(saveRate)){
							Ext.getCmp('EXCHG_RATE_O1').setValue(saveRate);
						}
						if(!Ext.isEmpty(saveMoneyUnit)){
							Ext.getCmp('MONEY_UNIT_ORI').setValue(saveMoneyUnit);
						}

    		 		}
    			}/*,
    			update : function( store, record, operation, modifiedFieldNames, details, eOpts ){
    				UniAppManager.setToolbarButtons('save', true);
    			},
    			datachanged : function(store,  eOpts) {
    				if( directDetailStore.isDirty() || store.isDirty())	{
    					UniAppManager.setToolbarButtons('save', true);
    				}else {
    					UniAppManager.setToolbarButtons('save', false);
    				}
    			} */
    		}
    }); // End of var directMasterStore1



    var directMasterStore2 = Unilite.createStore('s_ryt500ukrv_kdMasterStore2',{
        model: 's_ryt500ukrv_kdModel2',
        uniOpt : {
            isMaster:  true,            // 상위 버튼 연결
            editable:  true,           // 수정 모드 사용
            deletable: true,           // 삭제 가능 여부
            useNavi :  false            // prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: directProxy2,
        loadStoreRecords : function(param)   {
            this.load({
                  params : param,
                  callback : function(records,options,success) {
  					if(success) {
						if(directMasterStore.isDirty()){
							UniAppManager.setToolbarButtons('save', true);
						}else{
							UniAppManager.setToolbarButtons('save', false);
						}
  					}
  				}
            });
        },
		saveStore: function() {
            var inValidRecs = this.getInvalidRecords();
            console.log("inValidRecords : ", inValidRecs);

            var toCreate = this.getNewRecords();
            var toUpdate = this.getUpdatedRecords();
            var toDelete = this.getRemovedRecords();
            var list = [].concat(toUpdate, toCreate);
            console.log("inValidRecords : ", inValidRecs);
            console.log("list:", list);
            console.log("this.data.filterBy(this.filterInvalidNewRecords).items : ", this.data.filterBy(this.filterInvalidNewRecords));

            //1. 마스터 정보 파라미터 구성
            var paramMaster= panelResult.getValues();    //syncAll 수정
            if(inValidRecs.length == 0) {
                config = {
                    params: [paramMaster],
                    success: function(batch, option) {
                        panelResult.getForm().wasDirty = false;
                        panelResult.resetDirtyStatus();
                        console.log("set was dirty to false");
                        UniAppManager.setToolbarButtons('save', false);
                        UniAppManager.app.onQueryButtonDown();
                    }
                };
                this.syncAllDirect(config);
            } else {
                masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
            }
        },
        listeners:{
		 	load: function(store, records, successful, eOpts) {
		 		if(!Ext.isEmpty(records)){
               		if(gwFlag == '3' ){
               			//UniAppManager.setToolbarButtons(['newData','save','delete','deleteAll'], false);
               			Ext.getCmp('CAL_BTN').setDisabled(true);
	
               		}
               	    var record = masterGrid.getSelectedRecord();
               		Ext.getCmp('EXCHG_RATE_O1').setValue(record.get('EXCHG_RATE_O'));
		 		}
			}
		}
    });

    /**
     * 검색조건 (Search Panel)
     * @type
     */
    var panelResult = Unilite.createSearchForm('resultForm',{
        region: 'north',
        layout : {type : 'uniTable', columns : 3},
        padding:'1 1 1 1',
        border:true,
        hidden: !UserInfo.appOption.collapseLeftSearch,
        items: [{
                fieldLabel: '사업장',
                name:'DIV_CODE',
                xtype: 'uniCombobox',
                comboType:'BOR120',
                allowBlank:false,
                value: UserInfo.divCode
            },{
				fieldLabel: '작업년도',
				name: 'WORK_YEAR',
				xtype: 'uniCombobox',
				comboType : 'AU',
			    comboCode : 'BS90',
				holdable: 'hold',
				value: new Date().getFullYear(),
				allowBlank: false
	    	},{
				fieldLabel	: '반기',
				name		: 'WORK_SEQ',
				xtype		: 'uniCombobox',
				comboType	: 'AU',
				comboCode	: 'Z004',
				value:'1',
				holdable: 'hold',
				allowBlank: true
			},Unilite.popup('AGENT_CUST', {
                fieldLabel: '거래처',
                allowBlank:false,
                listeners: {
                    applyextparam: function(popup){
                        popup.setExtParam({
                            'DIV_CODE':   panelResult.getValue('DIV_CODE'),
                            'ADD_QUERY1': "A.CUSTOM_CODE IN ((SELECT CUSTOM_CODE FROM S_RYT100T_KD WHERE COMP_CODE = ",
                            'ADD_QUERY2': " AND DIV_CODE = ",
                            'ADD_QUERY3': "))"
                        });   //WHERE절 추카 쿼리
                    }
                }
            }),{
                fieldLabel: '정산여부',
                xtype: 'uniRadiogroup',
                width:280,
                allowBlank:false,
                comboType:'AU',
                comboCode:'B010',
                //value: "N",
                name: 'CAL_YN',
    			listeners: {
    				change: function(field, newValue, oldValue, eOpts) {

    				}
    			}
            },{
                fieldLabel: '작업기간',
                xtype: 'uniMonthRangefield',
                startFieldName: 'CON_FR_YYMM',
                endFieldName: 'CON_TO_YYMM',
                allowBlank:true,
                hidden:true

//                startDate: UniDate.get('startOfMonth'),
//                endDate: UniDate.get('today')
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

    var masterGrid = Unilite.createGrid('s_ryt500ukrv_kdmasterGrid', {
        layout : 'fit',
//        region: 'center',
        store: directMasterStore,
        selModel: 'rowmodel',
//        flex: 3.3,
        uniOpt: {
            useGroupSummary: false,
            useLiveSearch: true,
            useContextMenu: true,
            useMultipleSorting: true,
            useRowNumberer: false,
            expandLastColumn: false,
            onLoadSelectFirst: true,
            filter: {
                useFilter: false,
                autoCreate: false
            }
        },
        selModel:   Ext.create('Ext.selection.CheckboxModel', {
        	checkOnly: false,
        	toggleOnClick: false,
            listeners: {
                select: function(grid, selectRecord, index, rowIndex, eOpts ){
                   selectRecord.set('CHK','Y');
                    if(gwFlag != '3'){
                    	Ext.getCmp('CAL_BTN').setDisabled(false);
                    }else if(gwFlag == '3'){
                    	//UniAppManager.setToolbarButtons(['newData','save','delete','deleteAll'], false);
                    }
                },
                deselect:  function(grid, selectRecord, index, eOpts ){
                  selectRecord.set('CHK' , '');
                  //  Ext.getCmp('CAL_BTN').setDisabled(true);
                  //  selectRecord.set('EXCHG_RATE_O' , selectRecord.get('EXCHG_RATE_O2'));
                }
            }
        }),
        tbar: [{
            itemId : 'CAL_BTN',
            id:'CAL_BTN',
            text:'로얄티 정산',
            handler: function() {
                var record = masterGrid.getSelectedRecord();
                if(Ext.isEmpty(record)){
                	alert('선택한 데이터가 없습니다.');
                	return false;
                }
                if(gwFlag == '3'){
                	alert('기안 완료된 데이터는 변경할 수 없습니다.');
                	return false;
                }
                if(Ext.isEmpty(panelResult.getValue('WORK_SEQ'))){
                	alert('로얄티 정산을 할 경우 반기는 필수입니다.');
                	return false;
                }
            	if(Ext.isEmpty(record.get('CAL_DATE'))) {
                    directMasterStore.saveStore(record, 'CALC');
                    panelResult.setValue('CAL_YN', "Y");
            	} else {
            	   if(confirm('정산된 자료입니다. 재정산 하시겠습니까?')) {
            	       directMasterStore.saveStore(record, 'CALC');
            	       panelResult.setValue('CAL_YN', "Y");
            	   }
            	}
            }
        }],
        columns:  [
            { dataIndex: 'COMP_CODE'                   ,           width: 80, hidden: true},
            { dataIndex: 'DIV_CODE'                    ,           width: 80, hidden: true},
            { dataIndex: 'BALANCE_NUM'                 ,           width: 80, hidden: true},
            { dataIndex: 'CUSTOM_CODE'                 ,           width: 110},
            { dataIndex: 'CUSTOM_NAME'                 ,           width: 150},
            { dataIndex: 'CON_FR_YYMM'           , width: 100                 , align: 'center', xtype:'uniMonthColumn',
            	editor:{xtype:'uniMonthfield',format: 'Y.m' },
	            renderer : function(val, metaData, record, rowIndex, colIndex, store, view) {
	            	if(!Ext.isEmpty(val)){
						return UniDate.getDbDateStr(val).substring(0, 4) + '.' + UniDate.getDbDateStr(val).substring(4, 6);
					}
				}
            },
            { dataIndex: 'CON_TO_YYMM'           , width: 100                 , align: 'center', xtype:'uniMonthColumn',
                editor:{xtype:'uniMonthfield',format: 'Y.m' },
	            renderer : function(val, metaData, record, rowIndex, colIndex, store, view) {
	            	if(!Ext.isEmpty(val)){
						return UniDate.getDbDateStr(val).substring(0, 4) + '.' + UniDate.getDbDateStr(val).substring(4, 6);
					}
				}
            },
            { dataIndex: 'CONFIRM_YN'                  , width: 80, align: 'center'}, // 확정여부
            { dataIndex: 'CAL_YN'                      , width: 80, align: 'center'}, // 정산여부
            { dataIndex: 'GUBUN1'                      , width: 80, align: 'center'},
            { dataIndex: 'MONEY_UNIT'                  , width: 66, align: 'center'},
            { dataIndex: 'MONEY_UNIT_ORI'              , width: 66, hidden: true},
            { dataIndex: 'EXCHG_RATE_O'                , width: 80, hidden: false},
            { dataIndex: 'EXCHG_RATE_O2'               , width: 66, hidden: true},
            { dataIndex: 'CAL_DATE'                    , width: 100},
            { dataIndex: 'QTY_SELL_FOR'                , width: 120},
            { dataIndex: 'AMT_SELL_WON'                , width: 120},
            { dataIndex: 'AMT_SELL_FOR'                , width: 120},
            { dataIndex: 'AMT_DEDUCT_FOR'              , width: 120},
            { dataIndex: 'AMT_NET_SELL_FOR'            , width: 120},
            { dataIndex: 'AMT_ROYALTY_FOR'             , width: 120},
            { dataIndex: 'AMT_ROYALTY'                 , width: 120},
            { dataIndex: 'WORK_YEAR'                   , width: 100, hidden: true},
            { dataIndex: 'WORK_SEQ'                    , width: 100, hidden: true},
            { dataIndex: 'GUBUN2'                      , width: 100, hidden: true},
            { dataIndex: 'GUBUN3'                      , width: 100, hidden: true},
            { dataIndex: 'RYT_P'                       , width: 100, hidden: true},
            { dataIndex: 'CHK'                         , width: 100, hidden: true},
            { dataIndex: 'GW_DOCU_NUM'          	   , width: 100},
            { dataIndex: 'GW_FLAG'              	   , width: 100},
            { dataIndex: 'DRAFT_NO'              	   , width: 100}

        ],
        listeners: {
        	beforeedit  : function( editor, e, eOpts ) {
        		if(e.record.phantom == false) {
        			if(UniUtils.indexOf(e.field, ['CONFIRM_YN'])){

            			return true;

            		}
        			if(e.record.CONFIRM_YN == 'Y'){
        				return false;
        			}
        			if(UniUtils.indexOf(e.field, ['CON_FR_YYMM', 'CON_TO_YYMM'])){
            			if( panelResult.getValue('WORK_SEQ') == '3'&& e.record.CONFIRM_YN != 'Y' ){
            				return true;
            			}else{
            				return false;
            			}
            		} else {
                        return false;
            		}
        		}
            },
            select: function() {

                selectedGrid = 's_ryt500ukrv_kdGrid';
                UniAppManager.setToolbarButtons(['newData'], false);
            },
            cellclick: function( view, td, cellIndex, record, tr, rowIndex, e, eOpts , colName) {
				//if(cellClickChk == '1'){
	            /* 	selectedGrid = 's_ryt500ukrv_kdGrid';
	                UniAppManager.setToolbarButtons(['newData'], false);
	                var param = {
	                        DIV_CODE       : record.get('DIV_CODE'),
	                        WORK_YEAR      : record.data.WORK_YEAR,
	                        WORK_SEQ       : record.data.WORK_SEQ,
	                        CUSTOM_CODE    : record.get('CUSTOM_CODE'),
	                        CON_FR_YYMM    : record.get('CON_FR_YYMM'),
	                        CON_TO_YYMM    : record.get('CON_TO_YYMM'),
	                        GUBUN1         : record.get('GUBUN1'),
	                        GUBUN3         : record.get('GUBUN3'),
	                        EXCHG_RATE_O   : record.get('EXCHG_RATE_O'),
	                        BALANCE_NUM    : record.get('BALANCE_NUM')
	                    }
	                directMasterStore2.loadStoreRecords(param); */
				//}
            },
            render: function(grid, eOpts) {
                var girdNm = grid.getItemId();
                grid.getEl().on('click', function(e, t, eOpt) {
                    selectedMasterGrid = 's_ryt500ukrv_kdGrid';

                    if(gwFlag == '3'){
                    	//UniAppManager.setToolbarButtons(['newData','save','delete','deleteAll'], false);
                    }
                });
            },selectionchange:function( model1, selected, eOpts ){
            	selectedGrid = 's_ryt500ukrv_kdGrid';
                UniAppManager.setToolbarButtons(['newData'], false);

                var record = masterGrid.getSelectedRecord();
				if(!Ext.isEmpty(record)){
					if(!Ext.isEmpty(record.get('CAL_DATE'))) {
	            		 var param = {
	                             DIV_CODE       : selected[0].get('DIV_CODE'),
	                             WORK_YEAR      : selected[0].data.WORK_YEAR,
	                             WORK_SEQ       : selected[0].data.WORK_SEQ,
	                             CUSTOM_CODE    : selected[0].data.CUSTOM_CODE,
	                             CON_FR_YYMM    : selected[0].data.CON_FR_YYMM,
	                             CON_TO_YYMM    : selected[0].data.CON_TO_YYMM,
	                             GUBUN1         : selected[0].data.GUBUN1,
	                             GUBUN3         : selected[0].data.GUBUN3,
	                             EXCHG_RATE_O   : selected[0].data.EXCHG_RATE_O,
	                             BALANCE_NUM    : selected[0].data.BALANCE_NUM
	                         }
	                     directMasterStore2.loadStoreRecords(param);
	            	}
				}
				
				

            }
/*             selectionchange:function( model1, selected, eOpts ){

            	if(selected.length > 0) {

                    var record = selected[0];
                    var param = {
                        DIV_CODE       : record.data.DIV_CODE,
                        WORK_YEAR      : record.data.WORK_YEAR,
                        WORK_SEQ       : record.data.WORK_SEQ,
                        CUSTOM_CODE    : record.data.CUSTOM_CODE,
                        CON_FR_YYMM    : record.data.CON_FR_YYMM,
                        CON_TO_YYMM    : record.data.CON_TO_YYMM,
                        GUBUN1         : record.data.GUBUN1
                    }

                    directMasterStore2.loadStoreRecords(param);
                    var record = masterGrid.getSelectedRecord();
//                    record.set('CAL_YN'   , 'Y');
//                    record.set('CAL_DATE' , UniDate.get('today'));
                    record.set('CHK'      , 'Y');
                }
            } */
        }
    });

    var masterGrid2 = Unilite.createGrid('s_ryt500ukrv_kdmasterGrid2', {
        layout : 'fit',
        region: 'south',
        store: directMasterStore2,
        uniOpt: {
            expandLastColumn: false,
            useMultipleSorting: true,
            useGroupSummary: false,
            useLiveSearch: true,
            useContextMenu: true,
            useRowNumberer: false,
            filter: {
                useFilter: true,
                autoCreate: true
            }
        },tbar : [  {
            fieldLabel: '화폐',
            id:'MONEY_UNIT_ORI',
            fieldStyle: 'text-align: center;',
            labelAlign : 'right',
            xtype: 'uniCombobox',
            comboType:'AU',
            comboCode:'B004',
            displayField: 'value',
            allowBlank:true,
            holdable: 'hold',
            listeners: {
                change: function(field, newValue, oldValue, eOpts) {
                  // UniAppManager.app.fnExchngRateO();
                },
                blur: function( field, The, eOpts )    {
                  // UniAppManager.app.fnExchngRateO();
                }
            }
        },
        {
            id: 'EXCHG_RATE_O1',
            xtype: 'uniNumberfield',
            labelAlign : 'right',
            allowBlank:true,
            decimalPrecision: 4,
            value: 1,
            holdable: 'hold'
        },{
            itemId : 'EXCHG_SET',
            id:'EXCHG_SET',
            text:'적용',
            width:70,
            handler: function() {
            	if(masterGrid2.getStore().getCount() > 0){
            		var records = masterGrid2.getStore().data.items;
            		var exchgRateO1 =  Ext.getCmp('EXCHG_RATE_O1').getValue();
            		var moneyUnit = Ext.getCmp('MONEY_UNIT_ORI').getValue();
            		var dAmtSellFor;
            		var dAmtNetSellFor;
            		var dAmtRoyaltyFor;
            		Ext.each(records, function(record,idx) {
            			dAmtSellFor = record.get('D_AMT_SELL_FOR');
            			dAmtNetSellFor = record.get('D_AMT_NET_SELL_FOR');
            			dAmtRoyaltyFor = record.get('D_AMT_ROYALTY_FOR');
//             			exchgRateO1 = record.get("EXCHG_RATE_O1");
	            		if(moneyUnit != 'KRW'){
// 	            				record.set('D_AMT_SELL_FOR', Math.round(dAmtSellFor * exchgRateO1));
// 		            			record.set('D_AMT_NET_SELL_FOR', Math.round(dAmtNetSellFor * exchgRateO1));
		            			record.set('D_AMT_ROYALTY_WON', Math.round(dAmtRoyaltyFor * exchgRateO1));

	            		}else{
// 	            			if(exchgRateO != 0){
// 	            				record.set('D_AMT_SELL_FOR', dAmtSellFor / exchgRateO);
// 		            			record.set('D_AMT_NET_SELL_FOR', dAmtNetSellFor / exchgRateO);
// 		            			record.set('D_AMT_ROYALTY_FOR', dAmtRoyaltyFor / exchgRateO);

// 	            			}else{
// 	            				record.set('D_AMT_SELL_FOR', 0);
// 		            			record.set('D_AMT_NET_SELL_FOR',0);
// 		            			record.set('D_AMT_ROYALTY_FOR',0);

// 	            			}
	            		}

	            		record.set('MONEY_UNIT', moneyUnit);
            			record.set('EXCHG_RATE_O', exchgRateO1);
            		});
            	}
            }
        } ],
        columns:  [
            { dataIndex: 'COMP_CODE'                 ,           width: 80, hidden: true},
            { dataIndex: 'DIV_CODE'                  ,           width: 80, hidden: true},
            { dataIndex: 'BALANCE_NUM'               ,           width: 80, hidden: true},
            { dataIndex: 'SELL_MONTH'                ,           width: 80},
            { dataIndex: 'ITEM_CODE'                 ,           width: 110},
            { dataIndex: 'ITEM_NAME'                 ,           width: 150},
            { dataIndex: 'SPEC'                      ,           width: 150},
            { dataIndex: 'SALES_CUSTOM_CODE'         ,           width: 110, hidden: true},
            { dataIndex: 'SALES_CUSTOM_NAME'         ,           width: 150, hidden: true},
            { dataIndex: 'QTY_SELL'                  ,           width: 100},
            { dataIndex: 'D_AMT_SELL_WON'            ,           width: 150},
            { dataIndex: 'D_AMT_SELL_FOR'            ,           width: 150},
            { dataIndex: 'D_AMT_DEDUCT_FOR'          ,           width: 150},
            { dataIndex: 'D_AMT_NET_SELL_FOR'        ,           width: 150},
            { dataIndex: 'CUSTOM_CODE'               ,           width: 150, hidden: true},
            { dataIndex: 'CUSTOM_NAME'               ,           width: 200, hidden: true},
            { dataIndex: 'CON_FR_YYMM'               ,           width: 100, hidden: true},
            { dataIndex: 'CON_TO_YYMM'               ,           width: 100, hidden: true},
            { dataIndex: 'GUBUN1'                    ,           width: 100, align: 'center'},
            { dataIndex: 'RATE_N'                    ,           width: 80},
            { dataIndex: 'RYT_P'                     ,           width: 100, hidden: true},
            
            { dataIndex: 'D_AMT_ROYALTY_FOR'         ,           width: 150},
            { dataIndex: 'D_AMT_ROYALTY_WON'         ,           width: 150},
            { dataIndex: 'WORK_YEAR'                 ,           width: 100, hidden: true},
            { dataIndex: 'WORK_SEQ'                  ,           width: 100, hidden: true},
            { dataIndex: 'MONEY_UNIT'                  ,           width: 100, hidden: true},
            { dataIndex: 'EXCHG_RATE_O'                  ,           width: 100, hidden: true}
        ],
        listeners: {
            beforeedit  : function( editor, e, eOpts ) {
                var record = masterGrid.getSelectedRecord();
            	if(e.record.phantom) {
                    if(UniUtils.indexOf(e.field, ['QTY_SELL' , 'D_AMT_SELL_FOR']))
                    {
                        return true;
                    } else {
                        return false;
                    }
                } else {
                    if(record.get('CONFIRM_YN') == 'Y'){
                    	return false;
                    }
                	if(UniUtils.indexOf(e.field, ['']))
                    {
                        return false;
                    } else {
                        return true;
                    }
                }
            },
            select: function() {
                selectedGrid = 's_ryt500ukrv_kdGrid2';
                UniAppManager.setToolbarButtons(['newData'], false);
            },
            cellclick: function() {
            	if(gwFlag == '3'){
            		masterGrid2.getColumn('QTY_SELL').setConfig('editable',false);
           			masterGrid2.getColumn('D_AMT_SELL_FOR').setConfig('editable',false);
                    //UniAppManager.setToolbarButtons(['newData','save','delete','deleteAll'], false);
            	}
            	selectedGrid = 's_ryt500ukrv_kdGrid2';
                UniAppManager.setToolbarButtons(['newData'], false);
            },
            render: function(grid, eOpts) {
                var girdNm = grid.getItemId();
                var store = grid.getStore();
                grid.getEl().on('click', function(e, t, eOpt) {
                /*     selectedMasterGrid = 's_ryt500ukrv_kdGrid2';
                    if( directMasterStore2.isDirty())	{
						UniAppManager.setToolbarButtons('save', true);
					} */

                });
            }
        }
    });


    Unilite.Main( {
        borderItems:[{
            region:'center',
            layout: 'border',
            border: false,
            items:[{
                    region : 'center',
                    xtype : 'container',
                    layout : 'fit',
                    items : [ masterGrid ]
                },
                panelResult, masterGrid2
            ]
        }
        ],
        id  : 's_ryt500ukrv_kdApp',
        fnInitBinding : function() {
            panelResult.setValue('DIV_CODE',UserInfo.divCode);
            UniAppManager.setToolbarButtons(['save', 'newData','deleteAll'],false);
            UniAppManager.setToolbarButtons('newData', true);
            gwFlag = '';
            this.setDefault();
        },
        onQueryButtonDown : function()  {
            if(panelResult.setAllFieldsReadOnly(true) == false){
                return false;
            }
            if(panelResult.setAllFieldsReadOnly(true) == false){
                return false;
            }
            if(panelResult.getValue('CAL_YN') == 'Y' && Ext.isEmpty(panelResult.getValue('WORK_SEQ'))){
				alert('로얄티 정산을 할 경우에는 반기 구분은 필수 입니다.');
            }
            directMasterStore.loadStoreRecords();
            UniAppManager.setToolbarButtons(['reset'], true);
        },
        onResetButtonDown: function() {
            panelResult.setAllFieldsReadOnly(false);
            panelResult.clearForm();
            masterGrid.reset();
            masterGrid2.reset();
            directMasterStore.clearData();
            directMasterStore2.clearData();
            this.setDefault();
            UniAppManager.setToolbarButtons(['save', 'reset'], false);
        },
        onNewDataButtonDown: function() {       // 행추가
        	if(selectedMasterGrid == 's_ryt500ukrv_kdGrid') {
                var compCode      = UserInfo.compCode;
                var divCode       = panelResult.getValue('DIV_CODE');
                var conDate       = UniDate.get('today');
                var flag          = 'N';
                var workYear = panelResult.getValue('WORK_YEAR');
                var workSeq = panelResult.getValue('WORK_SEQ');

                var r = {
                    COMP_CODE      : compCode,
                    DIV_CODE       : divCode,
                    CON_DATE       : conDate,
                    FLAG           : flag,
                    WORK_YEAR : workYear,
                    WORK_SEQ : workSeq
                }
                masterGrid.createRow(r);
            } else {
                var record       = masterGrid.getSelectedRecord();
                var compCode     = UserInfo.compCode;
                var divCode      = record.get('DIV_CODE');
                var customCode   = record.get('CUSTOM_CODE');
                var seq = directMasterStore2.max('SEQ');
                    if(!seq) seq = 1;
                    else seq += 1;
                var conDate      = record.get('CON_DATE');
                var rateN        = 0;

                var r = {
                    COMP_CODE      : compCode,
                    DIV_CODE       : divCode,
                    CUSTOM_CODE    : customCode,
                    SEQ            : seq,
                    CON_DATE       : conDate,
                    RATE_N         : rateN
                }
                masterGrid2.createRow(r);
            }
        },
        onSaveDataButtonDown: function () {

        	if(gwFlag == '3'){
        		alert('기안 완료된 데이터는 변경할 수 없습니다.');
        		return false;
        	}else if(directMasterStore2.isDirty() && !directMasterStore.isDirty()){
        		directMasterStore2.saveStore();
        	}else if(directMasterStore.isDirty() && !directMasterStore2.isDirty()){
        		directMasterStore.saveStore('','CONFIRM');
        	}else {
        		directMasterStore2.saveStore();
        		directMasterStore.saveStore('','CONFIRM');

        	}
        },
        setDefault: function() {
            //directMasterStore.clearData();
            masterGrid.getStore().loadData({});
            masterGrid2.getStore().loadData({});
            panelResult.setValue('DIV_CODE',UserInfo.divCode);
            //panelResult.setValue('CON_FR_YYMM', UniDate.get('startOfYear'));
            //panelResult.setValue('CON_TO_YYMM', UniDate.get('today'));
            panelResult.setValue('WORK_YEAR',    new Date().getFullYear());
            panelResult.setValue('WORK_SEQ',    '1');
            panelResult.setValue('CAL_YN',    'N');
            Ext.getCmp('CAL_BTN').setDisabled(true);
// 			masterGrid2.getColumn('RYT_P').setVisible(true);
			masterGrid2.getColumn('RATE_N').setVisible(true);
			Ext.getCmp('MONEY_UNIT_ORI').setValue('KRW');
			Ext.getCmp('EXCHG_RATE_O1').setValue('1');

        } ,
        onDeleteDataButtonDown : function()	{
        	var record = masterGrid.getSelectedRecord();
        	if(gwFlag == '3'){
        		alert('기안 완료된 데이터는 삭제할 수 없습니다.');
        		return false;
        	}else if(record.get('CONFIRM_YN') == 'Y'){
        		alert('확정된 데이터는 삭제할 수 없습니다.');
        		return false;
        	}else{
    			masterGrid.deleteSelectedRow();
    			UniAppManager.setToolbarButtons(['save'], true);
        	}
		},

        fnExchngRateO:function() {
        	var param = {
        		"AC_DATE"    : UniDate.getDbDateStr(masterGrid.getStore().data.items[0].data.CAL_DATE),
                "MONEY_UNIT" : Ext.getCmp('MONEY_UNIT_ORI').getValue()
        	};
            s_mre101ukrv_kdService.fnExchgRateO(param, function(provider, response) {

                Ext.getCmp('EXCHG_RATE_O1').setValue( provider[0].BASE_EXCHG);

            });
        }

    });
    Unilite.createValidator('validator01', {
		store: directMasterStore,
		grid: masterGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt, editor, e) {
			if(newValue == oldValue){
				return false;
			}
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record, 'editor':editor, 'e':e});
			var rv = true;
			switch(fieldName) {
			    case "CONFIRM_YN" :
			    	//  UniAppManager.setToolbarButtons(['save'], true);
					break;

			}
			return rv;
		}
	});

    Unilite.createValidator('validator02', {
		store: directMasterStore2,
		grid: masterGrid2,
		validate: function( type, fieldName, newValue, oldValue, record, eopt, editor, e) {
			if(newValue == oldValue){
				return false;
			}
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record, 'editor':editor, 'e':e});
			var rv = true;
			switch(fieldName) {
			    case "D_AMT_SELL_FOR" :
			    	if(newValue <= 0){
						rv='<t:message code="unilite.msg.sMB076"/>';
						break;
					}

					record.set('D_AMT_NET_SELL_FOR', newValue - record.get('D_AMT_DEDUCT_FOR'));
					record.set('D_AMT_ROYALTY_FOR',  record.get('D_AMT_NET_SELL_FOR') * (record.get('RATE_N') / 100));
					break;

			}
			return rv;
		}
	});

}
</script>