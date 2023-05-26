<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_zcc800ukrv_kd"  >
    <t:ExtComboStore comboType="BOR120"  pgmId="s_zcc800ukrv_kd"  />             <!-- 사업장 -->
    <t:ExtComboStore comboType="AU" comboCode="WZ08" /> <!-- 외주/자재구분  -->
</t:appConfig>
<script type="text/javascript" charset="UTF-8" src='<c:url value="/resources/plupload/plupload.full.js" />' >
</script>
<script type="text/javascript" >

var masterSaveFlag = '';
var detailWindow; // 의뢰서작성디테일팝업
var BsaCodeInfo = {
	gsDefaultMoney: '${gsDefaultMoney}'
};
function appMain() {
	var groupUrl = '${groupUrl}'; //그룹웨어 호출 url
	var searchInfoWindow; // 검색창
    var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
        api: {
            read: 's_zcc800ukrv_kdService.selectDetail',
            create: 's_zcc800ukrv_kdService.insertDetail',
            update: 's_zcc800ukrv_kdService.updateDetail',
            destroy: 's_zcc800ukrv_kdService.deleteDetail',
            syncAll: 's_zcc800ukrv_kdService.saveAll'
        }
    });

    /**
     *   Model 정의
     * @type
     */
    Unilite.defineModel('searchInfoModel', {
        fields: [
            {name: 'COMP_CODE'            ,text:'법인코드'                 ,type: 'string'},
            {name: 'DIV_CODE'             ,text:'사업장'                   ,type: 'string'},
            {name: 'REQ_NUM'              ,text:'의뢰번호'               ,type: 'string'},
            {name: 'REQ_DATE'             ,text:'의뢰일'                   ,type: 'uniDate'},
            {name: 'CUSTOM_CODE'          ,text:'거래처코드'               ,type: 'string'},
            {name: 'CUSTOM_NAME'          ,text:'거래처명'                 ,type: 'string'},
            {name: 'MOMEY_UNIT'          ,text:'MOMEY_UNIT'                 ,type: 'string'},
            {name: 'MAKE_GUBUN'          ,text:'가공구분'                 ,type: 'string', comboType:'AU', comboCode:'WZ21'},
            {name: 'REQ_GUBUN'            ,text:'외주/자재구분'            ,type: 'string', comboType:'AU', comboCode:'WZ08'},
//            {name: 'ITEM_CODE'            ,text:'품목코드'                 ,type: 'string'},
            {name: 'ITEM_NAME'            ,text:'품목명'                   ,type: 'string'},
            {name: 'DEPT_CODE'            ,text:'부서코드'                 ,type: 'string'},
            {name: 'DEPT_NAME'            ,text:'부서명'                 ,type: 'string'},
            {name: 'PERSON_NUMB'          ,text:'담당자코드'                 ,type: 'string'},
            {name: 'PERSON_NAME'          ,text:'담당자명'                   ,type: 'string'},
            {name: 'REMARK'               ,text:'비고'                     ,type: 'string'}
        ]
    });
    Unilite.defineModel('detailModel', {
        fields: [
            {name: 'COMP_CODE'             ,text:'법인코드'                ,type: 'string',editable:false},
            {name: 'DIV_CODE'              ,text:'사업장'                 ,type: 'string',editable:false},
            {name: 'REQ_NUM'               ,text:'의뢰번호'                ,type: 'string',editable:false},
            {name: 'REQ_SEQ'               ,text:'의뢰순번'                ,type: 'int',allowBlank:false,editable:false},
            {name: 'HM_CODE'               ,text:'항목(부품)명'             ,type: 'string', comboType:'AU', comboCode:'WZ22',allowBlank:false},
            {name: 'MATERIAL'              ,text:'재질'                 	,type: 'string',editable:false},
            {name: 'CHILD_ITEM_CODE'       ,text:'품목코드'           		,type: 'string',allowBlank:false},
            {name: 'CHILD_ITEM_NAME'       ,text:'품목명'            		,type: 'string',editable:false},
            {name: 'CHILD_ITEM_SPEC'       ,text:'규격'             	    ,type: 'string',editable:false},
            {name: 'UNIT'            	   ,text:'단위'                   ,type: 'string',editable:false},
            {name: 'GARO_NUM'              ,text:'가로'                   ,type: 'float', decimalPrecision: 2, format:'0,000.00'},
            {name: 'GARO_NUM_UNIT'         ,text:'단위'                   ,type: 'string',editable:false},
            {name: 'SERO_NUM'              ,text:'세로'                   ,type: 'float', decimalPrecision: 2, format:'0,000.00'},
            {name: 'SERO_NUM_UNIT'         ,text:'단위'                   ,type: 'string',editable:false},
            {name: 'THICK_NUM'             ,text:'두께'                   ,type: 'float', decimalPrecision: 2, format:'0,000.00'},
            {name: 'THICK_NUM_UNIT'        ,text:'단위'                   ,type: 'string',editable:false},
            {name: 'BJ_NUM'                ,text:'비중'                   ,type: 'float', decimalPrecision: 2, format:'0,000.00'},
            {name: 'CAL_QTY'               ,text:'환산수량'                 ,type: 'float', decimalPrecision: 2, format:'0,000.00'},
            {name: 'CAL_UNIT'            ,text:'환산단위'                 ,type: 'string',editable:false},
            {name: 'PURCHASE_P'            ,text:'개별단가'                 ,type: 'float', decimalPrecision: 6, format:'0,000.00',editable:false},
            {name: 'PRICE'                 ,text:'환산단가'                 	 ,type: 'float', decimalPrecision: 6, format:'0,000.00',editable:false},
            {name: 'AMT'            	   ,text:'금액'                 	 ,type: 'float', decimalPrecision: 0, format:'0,000',editable:false},
            {name: 'QTY'      			   ,text:'수량'                 	 ,type: 'float', decimalPrecision: 2, format:'0,000.00',allowBlank:false},
            {name: 'DELIVERY_DATE'         ,text:'납기일자'                  ,type: 'uniDate',allowBlank:false},
            {name: 'REMARK'                ,text:'비고'                 	  ,type: 'string'},
            {name: 'MAKE_GUBUN_REF1'       ,text:'가로_FLAG'                ,type: 'string',editable:false},
            {name: 'MAKE_GUBUN_REF2'       ,text:'세로_FLAG'                ,type: 'string',editable:false},
            {name: 'MAKE_GUBUN_REF3'       ,text:'두께_FLAG'          	  ,type: 'string',editable:false},
            {name: 'GW_DOCU_NUM'           ,text: '기안문서번호'         		  ,type: 'string'},
            {name: 'GW_FLAG'               ,text: '기안여부'           		  ,type: 'string',comboType:'AU', comboCode:'WB17'},
            {name: 'DRAFT_NO'              ,text: 'DRAFT_NO'        	  ,type: 'string'}
        ]
    });

    /**
     * Store 정의(Service 정의)
     * @type
     */
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
                read: 's_zcc800ukrv_kdService.selectSearchInfo'
            }
        },
        loadStoreRecords : function()   {
            var param= searchInfoForm.getValues();
            this.load({
                  params : param
            });
        },groupField:'CUSTOM_NAME'
        
        
        
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
                  params : param,
              	// NEW ADD
  				callback: function(records, operation, success){
  					console.log(records);
  					if(success){
  						if(detailStore.getCount() == 0){
  							Ext.getCmp('GW').setDisabled(true);
  						}else if(detailStore.getCount() != 0){
  							UniBase.fnGwBtnControl('GW',detailStore.data.items[0].data.GW_FLAG);
  						}
  					}
  				}
  				//END
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
						masterForm.setValue("REQ_NUM", master.REQ_NUM);
						var record = detailGrid.getSelectedRecord();
						if(detailGrid.getStore().getCount() == 0 || record.get('GW_FLAG')== 3) {
                		    Ext.getCmp('GW').setDisabled(true);
                		} else if(detailGrid.getStore().getCount() != 0) {
                    		Ext.getCmp('GW').setDisabled(false);
                		}
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
            fieldLabel: '의뢰번호',
            name:'REQ_NUM',
            xtype: 'uniTextfield',
            readOnly: true
        },{
            fieldLabel: '의뢰일',
            name: 'REQ_DATE',
            xtype: 'uniDatefield',
            value: UniDate.get('today'),
            allowBlank: false
        },
        Unilite.popup('CUST', {
			fieldLabel: '<t:message code="system.label.purchase.custom" default="거래처"/>',
			valueFieldName:'CUSTOM_CODE',
	    	textFieldName:'CUSTOM_NAME',
			allowBlank: false,
			listeners: {
				onSelected: {
					fn: function(records, type) {
						masterForm.setValue('MONEY_UNIT', Unilite.nvl(records[0]["MONEY_UNIT"],BsaCodeInfo.gsDefaultMoney));
                	},
					scope: this
				},
				onClear: function(type)	{
					masterForm.setValue('MONEY_UNIT', '');
				}
			}
		}),{
            fieldLabel: '화폐단위',
            name:'MONEY_UNIT',
            xtype: 'uniTextfield',
            readOnly: true,
            hidden: true
        },
//        Unilite.popup('DIV_PUMOK',{
//            fieldLabel: '품목코드',
//            allowBlank: false,
//            valueFieldName: 'ITEM_CODE',
//            textFieldName: 'ITEM_NAME',
//            autoPopup:true,
//            colspan:2,
//            listeners: {
//                applyextparam: function(popup){
//                    popup.setExtParam({'DIV_CODE': masterForm.getValue('DIV_CODE')});
//                }
//            }
//        }),
        {
            fieldLabel: '품명',
            name:'ITEM_NAME',
            xtype: 'uniTextfield',
			allowBlank: false,
            width: 652,
            colspan:2
        },{
            fieldLabel: '가공구분',
            name:'MAKE_GUBUN',
            allowBlank: false,
            xtype: 'uniCombobox',
            comboType:'AU',
            comboCode:'WZ21'
        },
        Unilite.popup('DEPT', {
            fieldLabel: '부서',
            valueFieldName: 'DEPT_CODE',
            textFieldName: 'DEPT_NAME',
            autoPopup:true,
            allowBlank:false,
            listeners: {
                applyextparam: function(popup){
                    var authoInfo = pgmInfo.authoUser;              //권한정보(N-전체,A-자기사업장>5-자기부서)
                    var deptCode = UserInfo.deptCode;   //부서정보
                    var divCode = '';                   //사업장
                    if(authoInfo == "A"){   //자기사업장
                        popup.setExtParam({'DEPT_CODE': ""});
                        popup.setExtParam({'DIV_CODE': UserInfo.divCode});
                    }else if(authoInfo == "N" || Ext.isEmpty(authoInfo)){   //전체권한
                        popup.setExtParam({'DEPT_CODE': ""});
                        popup.setExtParam({'DIV_CODE': masterForm.getValue('DIV_CODE')});
                    }else if(authoInfo == "5"){     //부서권한
                        popup.setExtParam({'DEPT_CODE': UserInfo.deptCode});
                        popup.setExtParam({'DIV_CODE': UserInfo.divCode});
                    }
                }
            }
        }),
        Unilite.popup('Employee',{
                fieldLabel: '담당자',
                valueFieldName:'PERSON_NUMB',
                textFieldName:'PERSON_NAME',
                validateBlank:false,
                autoPopup:true,
                allowBlank:false,
                listeners: {
                    onSelected: {
                        fn: function(records, type) {
                            var param= Ext.getCmp('masterForm').getValues();
                            s_zcc800ukrv_kdService.selectPersonDept(param, function(provider, response)  {
                                if(!Ext.isEmpty(provider)){
                                    masterForm.setValue('DEPT_CODE', provider[0].DEPT_CODE);
                                    masterForm.setValue('DEPT_NAME', provider[0].DEPT_NAME);
                                }
                            });
                        },
                        scope: this
                    },
                    onClear: function(type) {
                        masterForm.setValue('PERSON_NUMB', '');
                        masterForm.setValue('PERSON_NAME', '');
                    },
                    applyextparam: function(popup){
                        popup.setExtParam({'DEPT_SEARCH': masterForm.getValue('DEPT_NAME')});
                    }
                }
        }),{
            fieldLabel: '비고',
            name:'REMARK',
            xtype: 'textareafield',
            width: 980,
            height : 40,
            colspan:3
        },{
            fieldLabel: '기안여부TEMP',
            name:'GW_TEMP',
            xtype: 'uniTextfield',
            hidden: true
        }],
		listeners:{
			uniOnChange:function( form ) {
				if(form.isDirty() && !form.uniOpt.inLoading)	{
					if(!Ext.isEmpty(form.getValue('REQ_NUM'))){
						UniAppManager.setToolbarButtons('save', true);
					}
				}
			}
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
        },
    	api: {
//	 		load: 's_zcc800ukrv_kdService.selectForm'	,
	 		submit: 's_zcc800ukrv_kdService.syncMaster'
		}
    });

    var searchInfoForm = Unilite.createSearchForm('searchInfoForm', {     // 검색 팝업창
        layout: {type: 'uniTable', columns : 3},
//        trackResetOnLoad: true,
        items: [{
            fieldLabel: '사업장',
            name:'DIV_CODE',
            xtype: 'uniCombobox',
            comboType:'BOR120',
            allowBlank:false,
            value: UserInfo.divCode
        },
        Unilite.popup('AGENT_CUST', {
            fieldLabel:'거래처',
            valueFieldName: 'CUSTOM_CODE',
            textFieldName: 'CUSTOM_NAME'
        }),
        {
			fieldLabel: '의뢰일자',
			xtype: 'uniDateRangefield',
			startFieldName: 'REQ_DATE_FR',
			endFieldName: 'REQ_DATE_TO',
			startDate: UniDate.get('startOfMonth'),
			endDate: UniDate.get('today')
		},{
            fieldLabel: '가공구분',
            name:'MAKE_GUBUN',
            xtype: 'uniCombobox',
            comboType:'AU',
            comboCode:'WZ21'
        },{
            fieldLabel: '품명',
            name:'ITEM_NAME',
            xtype: 'uniTextfield'
        },{
            fieldLabel: '의뢰번호',
            name:'REQ_NUM',
            xtype: 'uniTextfield'
        }]
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
    	tbar: [{
            itemId : 'GWBtn',
            id:'GW',
            iconCls : 'icon-referance'  ,
            text:'기안',
            handler: function() {
                var param = masterForm.getValues();
                param.DRAFT_NO = UserInfo.compCode + masterForm.getValue('REQ_NUM');
                if(confirm('기안 하시겠습니까?')) {
                	s_zcc800ukrv_kdService.selectGwData(param, function(provider, response) {
                        if(Ext.isEmpty(provider[0]) || provider[0].GW_FLAG != '1' || provider[0].GW_FLAG != '3') {

                        	masterForm.setValue('GW_TEMP', '기안중');
                        	s_zcc800ukrv_kdService.makeDraftNum(param, function(provider2, response)   {
                                UniAppManager.app.requestApprove();
                            });
                        } else {
                            alert('이미 기안된 자료입니다.');
                            return false;
                        }
                    });
                }
                UniAppManager.app.onQueryButtonDown();
            }
        }],
        columns:  [
            { dataIndex: 'COMP_CODE'                               ,width: 80, hidden: true},
            { dataIndex: 'DIV_CODE'                                ,width: 80, hidden: true},
            { dataIndex: 'REQ_NUM'                                 ,width: 100, hidden: true},
            { dataIndex: 'REQ_SEQ'                                 ,width: 80},
            { dataIndex: 'HM_CODE'                                 ,width: 100,
		        listeners: {
					render:function(elm){
						elm.editor.on('select',function(combo, record, eOpts)  {
							var currRecord = detailGrid.uniOpt.currentRecord;
							currRecord.set('MATERIAL',combo.valueCollection.items[0].data.refCode1);
							currRecord.set('QTY',combo.valueCollection.items[0].data.refCode9);
							detailGrid.getColumn('MATERIAL').focus();
						})
					}
		        }
        	},
            { dataIndex: 'MATERIAL'                                ,width: 100},
            { dataIndex: 'CHILD_ITEM_CODE'                         ,width: 100,
            	editor: Unilite.popup('DIV_PUMOK_G', {
                    textFieldName: 'ITEM_CODE',
                    DBtextFieldName: 'ITEM_CODE',
		    		autoPopup: true,
                    listeners: {'onSelected': {
                            fn: function(records, type) {
                                console.log('records : ', records);
                                Ext.each(records, function(record,i) {
                                    console.log('record',record);
                                    if(i==0) {
                                        detailGrid.setItemData(record,false, detailGrid.uniOpt.currentRecord);
                                    } else {
                                        UniAppManager.app.onNewDataButtonDown();
                                        detailGrid.setItemData(record,false, detailGrid.getSelectedRecord());
                                    }
                                });
                            },
                            scope: this
                        },
                        'onClear': function(type) {
                            detailGrid.setItemData(null,true, detailGrid.uniOpt.currentRecord);
                        },
                        applyextparam: function(popup){
                            popup.setExtParam({'DIV_CODE': masterForm.getValue('DIV_CODE')});
                            popup.setExtParam({'SELMODEL': 'MULTI'});
                        }
                    }
                })
            },
            { dataIndex: 'CHILD_ITEM_NAME'                         ,width: 200},
            { dataIndex: 'CHILD_ITEM_SPEC'                         ,width: 100},
            { dataIndex: 'UNIT'                                    ,width: 80},
            { dataIndex: 'GARO_NUM'                                ,width: 100},
            { dataIndex: 'GARO_NUM_UNIT'                           ,width: 80},
            { dataIndex: 'SERO_NUM'                                ,width: 100},
            { dataIndex: 'SERO_NUM_UNIT'                           ,width: 80},
            { dataIndex: 'THICK_NUM'                               ,width: 100},
            { dataIndex: 'THICK_NUM_UNIT'                          ,width: 80},
            { dataIndex: 'BJ_NUM'                                  ,width: 100},
            { dataIndex: 'CAL_QTY'                                 ,width: 100},
            { dataIndex: 'CAL_UNIT'                              ,width: 80},
            { dataIndex: 'PURCHASE_P'                              ,width: 120},
            { dataIndex: 'PRICE'                                   ,width: 120},
            { dataIndex: 'AMT'                                     ,width: 120},
            { dataIndex: 'QTY'                            		   ,width: 100},
            { dataIndex: 'DELIVERY_DATE'                           ,width: 100},
            { dataIndex: 'REMARK'                                  ,width: 250},
            { dataIndex: 'MAKE_GUBUN_REF1'                         ,width: 100, hidden: true},
            { dataIndex: 'MAKE_GUBUN_REF2'                         ,width: 100, hidden: true},
            { dataIndex: 'MAKE_GUBUN_REF3'                         ,width: 100, hidden: true},
            { dataIndex: 'GW_DOCU_NUM'          , width: 100},
            { dataIndex: 'GW_FLAG'              , width: 100},
            { dataIndex:'DRAFT_NO'              , width: 100}
        ],
        listeners: {
            beforeedit: function( editor, e, eOpts ) {
                if(masterForm.getValue('MAKE_GUBUN') == '09'){
                    if(UniUtils.indexOf(e.field, ['CAL_QTY', 'CHILD_ITEM_CODE', 'HM_CODE', 'QTY', 'DELIVERY_DATE', 'REMARK', 'GW_DOCU_NUM', 'GW_FLAG', 'DRAFT_NO'])){
                        return true;
                    }else{
                    	return false;
                    }
                }else{
                	if(UniUtils.indexOf(e.field, ['CAL_QTY'])){
                        return false;
                    }
    //				if(e.record.phantom.record.phantom) {
    //				}
    				if( masterForm.getValue('GW_TEMP') == '기안중' || e.record.data.GW_FLAG == '3'){
    					return false;
    				}
    				if(e.record.data.MAKE_GUBUN_REF1 != 'Y' && e.record.data.MAKE_GUBUN_REF1 != 'P'){
    					if(UniUtils.indexOf(e.field, ['GARO_NUM'])){
    						return false;
    					}
    				}
    				if(e.record.data.MAKE_GUBUN_REF2 != 'Y' && e.record.data.MAKE_GUBUN_REF2 != 'P'){
    					if(UniUtils.indexOf(e.field, ['SERO_NUM'])){
    						return false;
    					}
    				}
                	if(e.record.data.MAKE_GUBUN_REF3 != 'Y' && e.record.data.MAKE_GUBUN_REF3 != 'P' && e.record.data.MAKE_GUBUN_REF3 != 'E'){
    					if(UniUtils.indexOf(e.field, ['THICK_NUM'])){
    						return false;
    					}
    				}
				}
            },
			onGridDblClick:function(grid, record, cellIndex, colName) {
   				 openDetailWindow();
			},
			selectionchangerecord:function(selected)	{
//				detailSubForm.setActiveRecord(selected);  최초에 행 하나 추가후 더블클릭 팝업 열시 정상작동 안함..
			}
        },
		setItemData: function(record, dataClear, grdRecord) {
       		if(dataClear) {
       			grdRecord.set('CHILD_ITEM_CODE'			,"");
       			grdRecord.set('CHILD_ITEM_NAME'			,"");
       			grdRecord.set('CHILD_ITEM_SPEC'			,"");
       			grdRecord.set('UNIT'			,"");

       			grdRecord.set('GARO_NUM'			,0);
       			grdRecord.set('SERO_NUM'			,0);
       			grdRecord.set('THICK_NUM'			,0);
       			grdRecord.set('CAL_QTY'			,0);
       			grdRecord.set('PRICE'			,0);
       			grdRecord.set('AMT'			,0);
       			grdRecord.set('QTY'			,0);

       			grdRecord.set('DELIVERY_DATE'			,'');

       		} else {
       			grdRecord.set('CHILD_ITEM_CODE'			, record['ITEM_CODE']);
       			grdRecord.set('CHILD_ITEM_NAME'			, record['ITEM_NAME']);;
				grdRecord.set('CHILD_ITEM_SPEC'			, record['SPEC']);
				grdRecord.set('UNIT'					, record['ORDER_UNIT']);
//				grdRecord.set('STOCK_UNIT'				, record['STOCK_UNIT']);

				var param = {
					"ITEM_CODE"	: record['ITEM_CODE'],
					"CUSTOM_CODE" : masterForm.getValue('CUSTOM_CODE'),
					"DIV_CODE"	: masterForm.getValue('DIV_CODE'),
					"MONEY_UNIT"  : masterForm.getValue('MONEY_UNIT'),
					"ORDER_UNIT"  : record['ORDER_UNIT'],
					"REQ_DATE"   : UniDate.getDbDateStr(masterForm.getValue('REQ_DATE'))
				};
				s_zcc800ukrv_kdService.fnOrderPrice(param, function(provider, response) {
					if(!Ext.isEmpty(provider)){
						grdRecord.set('PURCHASE_P', provider['ORDER_P']);
					}else{
						grdRecord.set('PURCHASE_P', 0);
					}
				})

       			grdRecord.set('GARO_NUM'			,0);
       			grdRecord.set('SERO_NUM'			,0);
       			grdRecord.set('THICK_NUM'			,0);
       			grdRecord.set('CAL_QTY'			,0);
       			grdRecord.set('PRICE'			,0);
       			grdRecord.set('AMT'			,0);
       			grdRecord.set('QTY'			,0);

       			var calcDate = UniDate.add(UniDate.add(masterForm.getValue('REQ_DATE'), {days: record['PURCH_LDTIME']}));
				grdRecord.set('DELIVERY_DATE'		, UniDate.getDbDateStr(calcDate));

       		}
		}
    });
    var detailSubForm = Unilite.createSearchForm('detailSubForm', {
        height:400,
        width: 850,
//        masterGrid : detailGrid,
		region		: 'center',
		autoScroll	: false,
		border		: true,
		padding		: '1 1 1 1',
		layout		: {type: 'uniTable', columns: 3, tdAttrs: {valign:'top'}},
        items:[{
			fieldLabel: '의뢰번호',
			xtype: 'uniTextfield',
			name: 'REQ_NUM',
			readOnly: true
		},{
			fieldLabel: '순번',
			xtype: 'uniTextfield',
			name: 'REQ_SEQ',
			readOnly: true,
			colspan:2
		},{
          	padding: '16 0 0 0',
            fieldLabel: '항목(부품)명',
            name:'HM_CODE',
            allowBlank: false,
            xtype: 'uniCombobox',
            comboType:'AU',
            comboCode:'WZ22',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					if(!Ext.isEmpty(detailSubForm.getField("HM_CODE").valueCollection.items[0])){
						detailSubForm.setValue('MATERIAL',detailSubForm.getField("HM_CODE").valueCollection.items[0].data.refCode1);
						detailSubForm.setValue('QTY',detailSubForm.getField("HM_CODE").valueCollection.items[0].data.refCode9);
					}
				}
			}
        },{

          	padding: '16 0 0 0',
			fieldLabel: '재질',
			xtype: 'uniTextfield',
			name: 'MATERIAL',
			readOnly: true,
			colspan:2
		},{
			xtype: 'container',
			layout: { type: 'uniTable', columns: 4},
			defaultType: 'uniTextfield',
			colspan: 3,
          	padding: '16 0 0 0',
			items:[
				Unilite.popup('DIV_PUMOK',{
					fieldLabel: '<t:message code="system.label.product.item" default="품목"/>',
					valueFieldName: 'CHILD_ITEM_CODE',
					textFieldName: 'CHILD_ITEM_NAME',
					allowBlank:false,
					listeners: {
						onSelected: {
							fn: function(records, type) {
								detailSubForm.setValue('CHILD_ITEM_SPEC',records[0]["SPEC"]);
								detailSubForm.setValue('UNIT',records[0]["ORDER_UNIT"]);
//								detailSubForm.setValue('STOCK_UNIT',records[0]["STOCK_UNIT"]);
								var param = {
									"ITEM_CODE"	: records[0]['ITEM_CODE'],
									"CUSTOM_CODE" : masterForm.getValue('CUSTOM_CODE'),
									"DIV_CODE"	: masterForm.getValue('DIV_CODE'),
									"MONEY_UNIT"  : masterForm.getValue('MONEY_UNIT'),
									"ORDER_UNIT"  : records[0]["ORDER_UNIT"],
									"REQ_DATE"   : UniDate.getDbDateStr(masterForm.getValue('REQ_DATE'))
								};
								s_zcc800ukrv_kdService.fnOrderPrice(param, function(provider, response) {
									if(!Ext.isEmpty(provider)){
										detailSubForm.setValue('PURCHASE_P', provider['ORDER_P']);
									}else{
										detailSubForm.setValue('PURCHASE_P', 0);
									}
								})
								detailSubForm.setValue('GARO_NUM'			,0);
				       			detailSubForm.setValue('SERO_NUM'			,0);
				       			detailSubForm.setValue('THICK_NUM'			,0);
				       			detailSubForm.setValue('CAL_QTY'			,0);
				       			detailSubForm.setValue('PRICE'			,0);
				       			detailSubForm.setValue('AMT'			,0);
				       			detailSubForm.setValue('QTY'			,0);

				       			var calcDate = UniDate.add(UniDate.add(masterForm.getValue('REQ_DATE'), {days:records[0]['PURCH_LDTIME']}));
								detailSubForm.setValue('DELIVERY_DATE'		, UniDate.getDbDateStr(calcDate));

							},
							scope: this
						},
						onClear: function(type) {
							detailSubForm.setValue('CHILD_ITEM_SPEC','');
							detailSubForm.setValue('UNIT','');
//							detailSubForm.setValue('STOCK_UNIT','');
							detailSubForm.setValue('PURCHASE_P', 0);

							detailSubForm.setValue('GARO_NUM'		,0);
			       			detailSubForm.setValue('SERO_NUM'		,0);
			       			detailSubForm.setValue('THICK_NUM'		,0);
			       			detailSubForm.setValue('CAL_QTY'		,0);
			       			detailSubForm.setValue('PRICE'			,0);
			       			detailSubForm.setValue('AMT'			,0);
			       			detailSubForm.setValue('QTY'			,0);

			       			detailSubForm.setValue('DELIVERY_DATE'			,'');
						},
						applyextparam: function(popup){
							popup.setExtParam({'DIV_CODE': detailSubForm.getValue('DIV_CODE')});
						}
					}
			}),{
				name:'CHILD_ITEM_SPEC',
				xtype:'uniTextfield',
				readOnly:true
			},{
                name:'UNIT',
                xtype: 'uniTextfield',
                width:  50,
                readOnly: true
            }]
		},{
			xtype: 'container',
			layout: { type: 'uniTable', columns: 2},
			defaultType: 'uniTextfield',
			colspan: 3,
          	padding: '16 0 0 0',
			items:[{
                fieldLabel: '가로',
				name:'GARO_NUM',
				xtype:'uniNumberfield',
				decimalPrecision: 2,
				format:'0,000.00',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						if(!Ext.isEmpty(newValue)){
							if(Ext.isEmpty(detailSubForm.getValue('CHILD_ITEM_CODE'))){
								Unilite.messageBox('품목을 먼저 입력해주십시오.');		//확인필요
								detailSubForm.setValue('GARO_NUM',0);
							}else{
								UniAppManager.app.calcFn(newValue, '1', 'F');
							}
						}
					}
				}
			},{
                name:'GARO_NUM_UNIT',
                xtype: 'uniTextfield',
                width: 50,
                readOnly: true
            }]
		},{
			xtype: 'container',
			layout: { type: 'uniTable', columns: 2},
			defaultType: 'uniTextfield',
			colspan: 3,
			items:[{
                fieldLabel: '세로',
				name:'SERO_NUM',
				xtype:'uniNumberfield',
				decimalPrecision: 2,
				format:'0,000.00',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						if(!Ext.isEmpty(newValue)){
							if(Ext.isEmpty(detailSubForm.getValue('CHILD_ITEM_CODE'))){
								Unilite.messageBox('품목을 먼저 입력해주십시오.');
								detailSubForm.setValue('SERO_NUM',0);
							}else{
								UniAppManager.app.calcFn(newValue, '2', 'F');
							}
						}
					}
				}
			},{
                name:'SERO_NUM_UNIT',
                xtype: 'uniTextfield',
                width: 50,
                readOnly: true
            }]
		},{
			xtype: 'container',
			layout: { type: 'uniTable', columns: 2},
			defaultType: 'uniTextfield',
			colspan: 3,
			items:[{
                fieldLabel: '두께',
				name:'THICK_NUM',
				xtype:'uniNumberfield',
				decimalPrecision: 2,
				format:'0,000.00',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						if(!Ext.isEmpty(newValue)){
							if(Ext.isEmpty(detailSubForm.getValue('CHILD_ITEM_CODE'))){
								Unilite.messageBox('품목을 먼저 입력해주십시오.');
								detailSubForm.setValue('THICK_NUM',0);
							}else{
								var record = detailGrid.getSelectedRecord();
								if(record.get('MAKE_GUBUN_REF3') == 'Y' || record.get('MAKE_GUBUN_REF3') == 'P'  ){
									UniAppManager.app.calcFn(newValue, '3', 'F');
								}
							}
						}
					}
				}
			},{
                name:'THICK_NUM_UNIT',
                xtype: 'uniTextfield',
                width: 50,
                readOnly: true
            }]
		},{
            fieldLabel: '비중',
			name:'BJ_NUM',
			xtype:'uniNumberfield',
			decimalPrecision: 2,
			format:'0,000.00',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					if(!Ext.isEmpty(newValue)){
						if(Ext.isEmpty(detailSubForm.getValue('CHILD_ITEM_CODE'))){
							Unilite.messageBox('품목을 먼저 입력해주십시오.');
							detailSubForm.setValue('BJ_NUM',0);
						}else{
							UniAppManager.app.calcFn(newValue, '4', 'F');
						}
					}
				}
			}
//			readOnly: true
		},{
            fieldLabel: '개별단가',
			name:'PURCHASE_P',
			xtype:'uniNumberfield',
			decimalPrecision: 2,
			format:'0,000.00',
			colspan:2,
			readOnly: true
		},{
			xtype: 'container',
			layout: { type: 'uniTable', columns: 2},
			defaultType: 'uniTextfield',
			items:[{
	            fieldLabel: '환산수량',
				name:'CAL_QTY',
				xtype:'uniNumberfield',
				decimalPrecision: 2,
				format:'0,000.00',
				readOnly: true,
				listeners: {
                change: function(field, newValue, oldValue, eOpts) {
                        if(!Ext.isEmpty(newValue)){
                            if(Ext.isEmpty(detailSubForm.getValue('CHILD_ITEM_CODE'))){
                                Unilite.messageBox('품목을 먼저 입력해주십시오.');
                            }else{
                                UniAppManager.app.calcFn(newValue, '', 'F');
                            }
                        }
                    }
                }
			},{
                name:'CAL_UNIT',
                xtype: 'uniTextfield',
                width: 50,
                readOnly: true
            }]
		},{
            fieldLabel: '환산단가',
			name:'PRICE',
			xtype:'uniNumberfield',
			decimalPrecision: 2,
			format:'0,000.00',
			readOnly: true
		},{
            fieldLabel: '금액',
			name:'AMT',
			xtype:'uniNumberfield',
			readOnly: true
		},{
          	padding: '16 0 0 0',
            fieldLabel: '수량',
			name:'QTY',
			xtype:'uniNumberfield',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					if(masterForm.getValue('MAKE_GUBUN') == '10'){
						if(!Ext.isEmpty(newValue)){
							if(Ext.isEmpty(detailSubForm.getValue('CHILD_ITEM_CODE'))){
								Unilite.messageBox('품목을 먼저 입력해주십시오.');
								detailSubForm.setValue('QTY',0);
							}else{
								UniAppManager.app.calcFn(newValue, '5', 'F');
							}
						}
					}
				}
			}
		},{
          	padding: '16 0 0 0',
            fieldLabel: '납기일자',
			name:'DELIVERY_DATE',
			xtype:'uniDatefield',
			allowBlank:false,
			colspan:2
		},{
          	padding: '16 0 0 0',
            fieldLabel: '비고',
            name:'REMARK',
            xtype: 'uniTextfield',
			colspan:3,
            width: 785
        }]
    });
    function openDetailWindow() {
		if(!detailWindow) {
			detailWindow = Ext.create('widget.uniDetailWindow', {
				title: '의뢰서디테일팝업',
				width: 850,
				height: 450,
				resizable:false,
				layout: {type:'vbox', align:'stretch'},
				items: [detailSubForm],
				tbar:  ['->', {
					id : 'closeBtn',
					width: 100,
					text: '확인',
					handler: function() {

						var detailRecord = detailGrid.getSelectedRecord();

						detailRecord.set('REQ_NUM',detailSubForm.getValue('REQ_NUM'));
						detailRecord.set('REQ_SEQ',detailSubForm.getValue('REQ_SEQ'));
						detailRecord.set('HM_CODE',detailSubForm.getValue('HM_CODE'));
						detailRecord.set('MATERIAL',detailSubForm.getValue('MATERIAL'));
						detailRecord.set('CHILD_ITEM_CODE',detailSubForm.getValue('CHILD_ITEM_CODE'));
						detailRecord.set('CHILD_ITEM_NAME',detailSubForm.getValue('CHILD_ITEM_NAME'));
						detailRecord.set('CHILD_ITEM_SPEC',detailSubForm.getValue('CHILD_ITEM_SPEC'));
						detailRecord.set('UNIT',detailSubForm.getValue('UNIT'));
						detailRecord.set('GARO_NUM',detailSubForm.getValue('GARO_NUM'));
						detailRecord.set('GARO_NUM_UNIT',detailSubForm.getValue('GARO_NUM_UNIT'));
						detailRecord.set('SERO_NUM',detailSubForm.getValue('SERO_NUM'));
						detailRecord.set('SERO_NUM_UNIT',detailSubForm.getValue('SERO_NUM_UNIT'));
						detailRecord.set('THICK_NUM',detailSubForm.getValue('THICK_NUM'));
						detailRecord.set('THICK_NUM_UNIT',detailSubForm.getValue('THICK_NUM_UNIT'));
						detailRecord.set('BJ_NUM',detailSubForm.getValue('BJ_NUM'));
						detailRecord.set('PURCHASE_P',detailSubForm.getValue('PURCHASE_P'));
						detailRecord.set('CAL_QTY',detailSubForm.getValue('CAL_QTY'));
						detailRecord.set('CAL_UNIT',detailSubForm.getValue('CAL_UNIT'));
						detailRecord.set('PRICE',detailSubForm.getValue('PRICE'));
						detailRecord.set('AMT',detailSubForm.getValue('AMT'));
						detailRecord.set('QTY',detailSubForm.getValue('QTY'));
						detailRecord.set('DELIVERY_DATE',detailSubForm.getValue('DELIVERY_DATE'));
						detailRecord.set('REMARK',detailSubForm.getValue('REMARK'));

						detailWindow.hide();

						/*
						detailSubForm.getField('WORK_Q').setConfig('allowBlank', true);
						detailSubForm.getField('GOOD_WORK_Q').focus();
						detailSubForm.getField('WORK_Q').focus();
						detailSubForm.clearForm();
						resultsAddWindow.hide();
						masterGrid10.reset();
						directMasterStore10.commitChanges();*/
					},
					disabled: false
				}],
				listeners: {
					beforehide: function(me, eOpt) {
					},
					beforeclose: function( panel, eOpts ) {
					},
					beforeshow: function( panel, eOpts )	{

						var detailRecord = detailGrid.getSelectedRecord();
						detailSubForm.setValue('REQ_NUM', detailRecord.get('REQ_NUM'));
						detailSubForm.setValue('REQ_SEQ', detailRecord.get('REQ_SEQ'));
						detailSubForm.setValue('HM_CODE', detailRecord.get('HM_CODE'));
						detailSubForm.setValue('MATERIAL', detailRecord.get('MATERIAL'));
						detailSubForm.setValue('CHILD_ITEM_CODE', detailRecord.get('CHILD_ITEM_CODE'));
						detailSubForm.setValue('CHILD_ITEM_NAME', detailRecord.get('CHILD_ITEM_NAME'));
						detailSubForm.setValue('CHILD_ITEM_SPEC', detailRecord.get('CHILD_ITEM_SPEC'));
						detailSubForm.setValue('UNIT', detailRecord.get('UNIT'));
						detailSubForm.setValue('GARO_NUM', detailRecord.get('GARO_NUM'));
						detailSubForm.setValue('GARO_NUM_UNIT', detailRecord.get('GARO_NUM_UNIT'));
						detailSubForm.setValue('SERO_NUM', detailRecord.get('SERO_NUM'));
						detailSubForm.setValue('SERO_NUM_UNIT', detailRecord.get('SERO_NUM_UNIT'));
						detailSubForm.setValue('THICK_NUM', detailRecord.get('THICK_NUM'));
						detailSubForm.setValue('THICK_NUM_UNIT', detailRecord.get('THICK_NUM_UNIT'));
						detailSubForm.setValue('BJ_NUM', detailRecord.get('BJ_NUM'));
						detailSubForm.setValue('PURCHASE_P', detailRecord.get('PURCHASE_P'));
						detailSubForm.setValue('CAL_QTY', detailRecord.get('CAL_QTY'));
						detailSubForm.setValue('CAL_UNIT', detailRecord.get('CAL_UNIT'));
						detailSubForm.setValue('PRICE', detailRecord.get('PRICE'));
						detailSubForm.setValue('AMT', detailRecord.get('AMT'));
						detailSubForm.setValue('QTY', detailRecord.get('QTY'));
						detailSubForm.setValue('DELIVERY_DATE', detailRecord.get('DELIVERY_DATE'));
						detailSubForm.setValue('REMARK', detailRecord.get('REMARK'));

						if(detailRecord.get('MAKE_GUBUN_REF1') == 'Y'){
	        				detailSubForm.getField('GARO_NUM').setReadOnly(false);
						}else{
	        				detailSubForm.getField('GARO_NUM').setReadOnly(true);
						}
						if(detailRecord.get('MAKE_GUBUN_REF2') == 'Y'){
	        				detailSubForm.getField('SERO_NUM').setReadOnly(false);
						}else{
	        				detailSubForm.getField('SERO_NUM').setReadOnly(true);
						}
						if(detailRecord.get('MAKE_GUBUN_REF3') == 'Y' || detailRecord.get('MAKE_GUBUN_REF3') == 'P' || detailRecord.get('MAKE_GUBUN_REF3') == 'E' ){
	        				detailSubForm.getField('THICK_NUM').setReadOnly(false);
						}else{
	        				detailSubForm.getField('THICK_NUM').setReadOnly(true);
						}
						if(masterForm.getValue('MAKE_GUBUN') == '09'){
                            detailSubForm.getField('CAL_QTY').setReadOnly(false);
                            detailSubForm.getField('BJ_NUM').setReadOnly(true);
                        }else{
                            detailSubForm.getField('CAL_QTY').setReadOnly(true);
                            detailSubForm.getField('BJ_NUM').setReadOnly(false);
                        }
					}
				}
			})
		}
		detailWindow.center();
		detailWindow.show();
	}

    var searchInfoGrid = Unilite.createGrid('searchInfoGrid', {
        layout : 'fit',
        region: 'center',
        store: searchInfoStore,
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
            { dataIndex: 'COMP_CODE'                            ,width: 80, hidden: true},
            { dataIndex: 'DIV_CODE'                             ,width: 80, hidden: true},
            { dataIndex: 'REQ_NUM'                              ,width: 100},
            { dataIndex: 'REQ_DATE'                             ,width: 80},
            { dataIndex: 'CUSTOM_CODE'                          ,width: 110},
            { dataIndex: 'CUSTOM_NAME'                          ,width: 200},
            { dataIndex: 'MOMEY_UNIT'                           ,width: 100, hidden: true},
            { dataIndex: 'MAKE_GUBUN'                           ,width: 100},
            { dataIndex: 'REQ_GUBUN'                            ,width: 100, hidden: true},
//            { dataIndex: 'ITEM_CODE'                            ,width: 110},
            { dataIndex: 'ITEM_NAME'                            ,width: 200},
            { dataIndex: 'DEPT_CODE'                            ,width: 110},
            { dataIndex: 'DEPT_NAME'                            ,width: 200},
            { dataIndex: 'PERSON_NUMB'                          ,width: 110},
            { dataIndex: 'PERSON_NAME'                          ,width: 200},
            { dataIndex: 'REMARK'                               ,width: 200}
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
            masterForm.setValues({'DIV_CODE':record.get('DIV_CODE')});
            masterForm.setValues({'REQ_NUM':record.get('REQ_NUM')});
            masterForm.setValues({'REQ_DATE':record.get('REQ_DATE')});
            masterForm.setValues({'CUSTOM_CODE':record.get('CUSTOM_CODE')});
            masterForm.setValues({'CUSTOM_NAME':record.get('CUSTOM_NAME')});
            masterForm.setValues({'MONEY_UNIT':record.get('MONEY_UNIT')});
            masterForm.setValues({'MAKE_GUBUN':record.get('MAKE_GUBUN')});
            masterForm.setValues({'REQ_GUBUN':record.get('REQ_GUBUN')});
//            masterForm.setValues({'ITEM_CODE':record.get('ITEM_CODE')});
            masterForm.setValues({'ITEM_NAME':record.get('ITEM_NAME')});
            masterForm.setValues({'DEPT_CODE':record.get('DEPT_CODE')});
            masterForm.setValues({'DEPT_NAME':record.get('DEPT_NAME')});
            masterForm.setValues({'PERSON_NUMB':record.get('PERSON_NUMB')});
            masterForm.setValues({'PERSON_NAME':record.get('PERSON_NAME')});
            masterForm.setValues({'REMARK':record.get('REMARK')});

        	UniAppManager.app.masterFormDisableFn('1');
        }
    });

    function openSearchInfoWindow() {   //검색팝업창
        if(!searchInfoWindow) {
            searchInfoWindow = Ext.create('widget.uniDetailWindow', {
                title: '의뢰번호 검색',
                width: 1080,
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
                    }, {
                        itemId : 'searchCloseBtn',
                        text: '닫기',
                        handler: function() {
                            searchInfoWindow.hide();
                        },
                        disabled: false
                    }
                ],
                listeners: {beforehide: function(me, eOpt)
                    {
                        searchInfoForm.clearForm();
                        searchInfoGrid.getStore().loadData({});
                    },
                    beforeclose: function( panel, eOpts ) {
                        searchInfoForm.clearForm();
                        searchInfoGrid.getStore().loadData({});
                    },
                    beforeshow: function( panel, eOpts )    {
                        searchInfoForm.setValue('DIV_CODE',masterForm.getValue('DIV_CODE'));
				        searchInfoForm.setValue('REQ_DATE_FR', UniDate.get('startOfMonth'));
				        searchInfoForm.setValue('REQ_DATE_TO', UniDate.get('today'));
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
        id  : 's_zcc800ukrv_kdApp',
        fnInitBinding : function() {
            this.setDefault();
        },
        onQueryButtonDown : function()  {
        	var reqNum = masterForm.getValue('REQ_NUM');
        	masterForm.setValue('GW_TEMP', '');
        	if(Ext.isEmpty(reqNum)) {
                openSearchInfoWindow()
            } else {
                var param= masterForm.getValues();
                detailStore.loadStoreRecords();
            }
        },
        onResetButtonDown: function() {
            masterForm.setAllFieldsReadOnly(false);
            masterForm.clearForm();
            detailGrid.reset();
            detailStore.clearData();
            this.setDefault();
        },
        onNewDataButtonDown: function() {

            if(!masterForm.getInvalidMessage()) return;   //필수체크
            var param = masterForm.getValues();
            s_zcc800ukrv_kdService.selectGwData(param, function(provider, response) {
                if(Ext.isEmpty(provider[0]) || provider[0].GW_FLAG != '1' || provider[0].GW_FLAG != '3') {
                	   var compCode        = UserInfo.compCode;
                       var divCode         = masterForm.getValue('DIV_CODE');
                       var seq             = detailStore.max('REQ_SEQ');
                       if(!seq) seq = 1;
                       else seq += 1;
                       var reqNum          = masterForm.getValue('REQ_NUM');

                       var makeGubunRef1 = masterForm.getField("MAKE_GUBUN").valueCollection.items[0].data.refCode1;	//가로
                       var garoNumUnit = masterForm.getField("MAKE_GUBUN").valueCollection.items[0].data.refCode4;	//가로단위
                       var makeGubunRef2 = masterForm.getField("MAKE_GUBUN").valueCollection.items[0].data.refCode2;	//세로
                       var seroNumUnit = masterForm.getField("MAKE_GUBUN").valueCollection.items[0].data.refCode5;	//세로단위
                       var makeGubunRef3 = masterForm.getField("MAKE_GUBUN").valueCollection.items[0].data.refCode3;	//두께
                       var thickNumUnit = masterForm.getField("MAKE_GUBUN").valueCollection.items[0].data.refCode6;	//두께단위
                       var bjNum = masterForm.getField("MAKE_GUBUN").valueCollection.items[0].data.refCode7;	//비중
                       
                       var makeGubunRef8 = masterForm.getField("MAKE_GUBUN").valueCollection.items[0].data.refCode8;	//단위(환산)

                       var r = {
                           COMP_CODE:	compCode,
                           DIV_CODE:	divCode,
                           REQ_SEQ:	seq,
                           REQ_NUM:	reqNum,

                           MAKE_GUBUN_REF1:	makeGubunRef1,
                           GARO_NUM_UNIT:		garoNumUnit,
                           MAKE_GUBUN_REF2:	makeGubunRef2,
                           SERO_NUM_UNIT:		seroNumUnit,
                           MAKE_GUBUN_REF3:	makeGubunRef3,
                           THICK_NUM_UNIT:		thickNumUnit,
                           BJ_NUM:				bjNum,
                           
                           CAL_UNIT: makeGubunRef8
                           
                       };
                       detailGrid.createRow(r);
           			UniAppManager.app.masterFormDisableFn('1');
                }else {
                    alert('이미 기안된 자료입니다.');
                    return false;
                }
            })

        },
        onDeleteDataButtonDown: function() {
        	var selRow = detailGrid.getSelectedRecord();
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
            masterForm.setValue('REQ_DATE', UniDate.get('today'));
            UniAppManager.setToolbarButtons(['save', 'newData','deleteAll'],false);
            UniAppManager.setToolbarButtons(['newData'],true);
            Ext.getCmp('GW').setDisabled(true);
            this.masterFormDisableFn('2');
        },
        requestApprove: function(){     //결재 요청
            var gsWin = window.open('about:blank','payviewer','width=500,height=500');

            var frm         = document.f1;
            var compCode    = UserInfo.compCode;
            var divCode     = masterForm.getValue('DIV_CODE');
            var reqNum  	= masterForm.getValue('REQ_NUM');
            var spText      = 'EXEC omegaplus_kdg.unilite.USP_GW_S_ZCC800UKRV_KD ' + "'" + compCode + "'" + ', ' + "'" + divCode + "'" + ', ' + "'" + reqNum + "'";
            var spCall      = encodeURIComponent(spText);

            /* frm.action   = groupUrl + "viewMode=docuDraft" + "&prg_no=s_mre100ukrv_kd&draft_no=" + UserInfo.compCode + masterForm.getValue('REQ_NUM') + "&sp=" + spCall/* + Base64.encode();
            frm.target   = "payviewer";
            frm.method   = "post";
            frm.submit(); */
            var gwurl = groupUrl + "viewMode=docuDraft" + "&prg_no=s_zcc800ukrv_kd&draft_no=" + UserInfo.compCode + masterForm.getValue('REQ_NUM') + "&sp=" + spCall/* + Base64.encode()*/;
            UniBase.fnGw_Call(gwurl,frm,'GW');
        },
        calcFn: function (newValue, gubun1, gubun2) {
        	//20200903 로직추가
        	//가공구분이 금형자재일경우(값'10') 환산수량 계산식에 수량필드도 곱하도록 변경,기존로직은 유지
			//가공구분이 금형자재일경우(값'10') 환산수량 필드포맷 소수점 첫째자리 아래 버림,기존은둘째자리 아래 버림으로 변경
        	
        	var selectRecord = detailGrid.getSelectedRecord();
        	var mgr1 = selectRecord.get('MAKE_GUBUN_REF1');
        	var mgr2 = selectRecord.get('MAKE_GUBUN_REF2');
        	var mgr3 = selectRecord.get('MAKE_GUBUN_REF3');
        	var calQty = 0;
        	var unitP = 0;//단가
        	var seroNum = 0;
        	var garoNum = 0;
        	var thickNum = 0;

        	var bjNum = 0;
        	
        	var qty = 0;
        	
        	
        	
        	if(gubun2 == 'F'){
	        	seroNum = detailSubForm.getValue('SERO_NUM');
				garoNum = detailSubForm.getValue('GARO_NUM');
				thickNum = detailSubForm.getValue('THICK_NUM');
        		unitP = detailSubForm.getValue('PURCHASE_P');
        		bjNum = detailSubForm.getValue('BJ_NUM');
        		
        		qty = detailSubForm.getValue('QTY');

        	}else if(gubun2 == 'G'){
        		seroNum = selectRecord.get('SERO_NUM');
				garoNum = selectRecord.get('GARO_NUM');
				thickNum = selectRecord.get('THICK_NUM');
        		unitP = selectRecord.get('PURCHASE_P');
        		bjNum = selectRecord.get('BJ_NUM');
        		
        		qty = selectRecord.get('QTY');

        	}
        	if(gubun1 == '1'){ //가로 입력시
        		calQty = newValue;
        		if(mgr2 == 'Y'){
        			calQty = calQty * seroNum;
        		}
        		if(mgr3 == 'Y'){
        			calQty = calQty * thickNum;
        		}else if(mgr3 == 'P'){// 두께 플래그가 P이면 개별단가 * 두께 를 단가에 set
        			unitP = unitP * thickNum;
        		}
        	}else if(gubun1 == '2'){ //세로 입력시
        		calQty = newValue;
        		if(mgr1 == 'Y'){
        			calQty = calQty * garoNum;
        		}
        		if(mgr3 == 'Y'){
        			calQty = calQty * thickNum;
        		}else if(mgr3 == 'P'){// 두께 플래그가 P이면 개별단가 * 두께 를 단가에 set
        			unitP = unitP * thickNum;
        		}
        	}else if(gubun1 == '3'){ //두께 입력시
        		if(mgr3 == 'P'){// 두께 플래그가 P이면 개별단가 * 두께 를 단가에 set
        			unitP = unitP * newValue;
	        		if(mgr1 == 'Y' && mgr2 != 'Y'){
	        			calQty = garoNum;
	        		}else if(mgr1 != 'Y' && mgr2 == 'Y'){
	        			calQty = seroNum;
	        		}else if(mgr1 == 'Y' && mgr2 == 'Y'){
	        			calQty = garoNum * seroNum;
	        		}
        		}else{
	        		calQty = newValue;
	        		if(mgr1 == 'Y'){
	        			calQty = calQty * garoNum;
	        		}
	        		if(mgr2 == 'Y'){
	        			calQty = calQty * seroNum;
	        		}
        		}
        	}

        	if(gubun1 == '4'){ //비중 입력시
//        		if(newValue)  비중값이 0일때는?
        		calQty = newValue / 1000000;
        		if(mgr1 == 'Y'){
        			calQty = calQty * garoNum;
        		}
        		if(mgr2 == 'Y'){
        			calQty = calQty * seroNum;
        		}
        		if(mgr3 == 'Y'){
        			calQty = calQty * thickNum;
        		}else if(mgr3 == 'P'){// 두께 플래그가 P이면 개별단가 * 두께 를 단가에 set
        			unitP = unitP * thickNum;
        		}
        	}else if(!Ext.isEmpty(bjNum) && bjNum != 0){	//기존에 비중값이 있을경우
    			calQty = calQty * bjNum / 1000000;
        	}
        	
        	if(gubun1 == '5'){ //수량 입력시 
        		qty = newValue;
        		
        		if(mgr3 == 'P'){// 두께 플래그가 P이면 개별단가 * 두께 를 단가에 set
        			unitP = unitP * thickNum;
	        		if(mgr1 == 'Y' && mgr2 != 'Y'){
	        			calQty = garoNum;
	        		}else if(mgr1 != 'Y' && mgr2 == 'Y'){
	        			calQty = seroNum;
	        		}else if(mgr1 == 'Y' && mgr2 == 'Y'){
	        			calQty = garoNum * seroNum;
	        		}
        		}else{
	        		calQty = thickNum;
	        		if(mgr1 == 'Y'){
	        			calQty = calQty * garoNum;
	        		}
	        		if(mgr2 == 'Y'){
	        			calQty = calQty * seroNum;
	        		}
        		}
        		
        		if(!Ext.isEmpty(bjNum) && bjNum != 0){	//기존에 비중값이 있을경우
	    			calQty = calQty * bjNum / 1000000;
	        	}
        		
        	}
        	
    		if(masterForm.getValue('MAKE_GUBUN') == '10'){
    			calQty = calQty * qty;
    			calQty = Math.floor(calQty * 10)/10;
    		}else{
    			calQty = Math.floor(calQty * 100)/100;
    		}
    		
    		if(masterForm.getValue('MAKE_GUBUN') == '09'){
                calQty = newValue;
            }
        	
        	if(gubun2 == 'G'){ // 그리드
        		if(Ext.isEmpty(mgr1) && Ext.isEmpty(mgr2) && Ext.isEmpty(mgr3) && masterForm.getValue('MAKE_GUBUN') != '09'){
	        		selectRecord.set('CAL_QTY',1);		//환산수량 set
        		}else{
	        		selectRecord.set('CAL_QTY',calQty);		//환산수량 set
        		}
	        	selectRecord.set('PRICE',unitP);		//단가 set

                selectRecord.set('AMT',unitP * calQty);		// 금액  set
        	}else if(gubun2 == 'F'){ // 폼
        		if(Ext.isEmpty(mgr1) && Ext.isEmpty(mgr2) && Ext.isEmpty(mgr3)&& masterForm.getValue('MAKE_GUBUN') != '09'){
	        		detailSubForm.setValue('CAL_QTY',1);		//환산수량 set
        		}else{
	        		detailSubForm.setValue('CAL_QTY',calQty);		//환산수량 set
        		}
	        	detailSubForm.setValue('PRICE',unitP);		//단가 set

	        	detailSubForm.setValue('AMT',unitP * calQty);		// 금액  set
        	}
        },

        masterFormDisableFn: function (gubun) {
        	if(gubun == '1'){
	        	masterForm.getField('DIV_CODE').setReadOnly(true);
	        	masterForm.getField('REQ_DATE').setReadOnly(true);
	        	masterForm.getField('CUSTOM_CODE').setReadOnly(true);
	        	masterForm.getField('CUSTOM_NAME').setReadOnly(true);
	        	masterForm.getField('MAKE_GUBUN').setReadOnly(true);
//	        	masterForm.getField('REQ_GUBUN').setReadOnly(true);
//	        	masterForm.getField('ITEM_CODE').setReadOnly(true);
//	        	masterForm.getField('ITEM_NAME').setReadOnly(true);
	        	masterForm.getField('DEPT_CODE').setReadOnly(true);
	        	masterForm.getField('DEPT_NAME').setReadOnly(true);
	        	masterForm.getField('PERSON_NUMB').setReadOnly(true);
	        	masterForm.getField('PERSON_NAME').setReadOnly(true);
//	        	masterForm.getField('REMARK').setReadOnly(true);
        	}else{
	        	masterForm.getField('DIV_CODE').setReadOnly(false);
	        	masterForm.getField('REQ_DATE').setReadOnly(false);
	        	masterForm.getField('CUSTOM_CODE').setReadOnly(false);
	        	masterForm.getField('CUSTOM_NAME').setReadOnly(false);
	        	masterForm.getField('MAKE_GUBUN').setReadOnly(false);
//	        	masterForm.getField('REQ_GUBUN').setReadOnly(false);
//	        	masterForm.getField('ITEM_CODE').setReadOnly(false);
//	        	masterForm.getField('ITEM_NAME').setReadOnly(false);
	        	masterForm.getField('DEPT_CODE').setReadOnly(false);
	        	masterForm.getField('DEPT_NAME').setReadOnly(false);
	        	masterForm.getField('PERSON_NUMB').setReadOnly(false);
	        	masterForm.getField('PERSON_NAME').setReadOnly(false);
//	        	masterForm.getField('REMARK').setReadOnly(false);
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
				case "GARO_NUM" : //가로
					if(Ext.isEmpty(record.get('CHILD_ITEM_CODE'))){
						rv='품목코드를 먼저 입력해주십시오.';
						break;
					}
					if(record.get('MAKE_GUBUN_REF1') == 'Y'){
						UniAppManager.app.calcFn(newValue, '1', 'G');
					}
				break;

				case "SERO_NUM" : //세로
					if(Ext.isEmpty(record.get('CHILD_ITEM_CODE'))){
						rv='품목코드를 먼저 입력해주십시오.';
						break;
					}
					if(record.get('MAKE_GUBUN_REF2') == 'Y'){
						UniAppManager.app.calcFn(newValue, '2', 'G');
					}
				break;

				case "THICK_NUM" : //두께
					if(Ext.isEmpty(record.get('CHILD_ITEM_CODE'))){
						rv='품목코드를 먼저 입력해주십시오.';
						break;
					}
					if(record.get('MAKE_GUBUN_REF3') == 'Y' || record.get('MAKE_GUBUN_REF3') == 'P'  ){
						UniAppManager.app.calcFn(newValue, '3', 'G');
					}
				break;

				case "BJ_NUM" : //비중
					if(Ext.isEmpty(record.get('CHILD_ITEM_CODE'))){
						rv='품목코드를 먼저 입력해주십시오.';
						break;
					}
					UniAppManager.app.calcFn(newValue, '4', 'G');
				break;
				
				case "QTY" : //수량
					if(masterForm.getValue('MAKE_GUBUN') == '10'){
						if(Ext.isEmpty(record.get('CHILD_ITEM_CODE'))){
							rv='품목코드를 먼저 입력해주십시오.';
							break;
						}
						UniAppManager.app.calcFn(newValue, '5', 'G');
					}
				break;
				
				case "CAL_QTY" : //환산수량
                    if(masterForm.getValue('MAKE_GUBUN') == '09'){
                        if(Ext.isEmpty(record.get('CHILD_ITEM_CODE'))){
                            rv='품목코드를 먼저 입력해주십시오.';
                            break;
                        }
                        UniAppManager.app.calcFn(newValue, '', 'G');
                    }
                break;
			}
			return rv;
		}
	});
}
</script>
<form id="f1" name="f1" action="" method="post" onSubmit="return false;" >
<input type="hidden" id="loginid" name="loginid" value="superadmin" />
<input type="hidden" id="fmpf" name="fmpf" value="" />
<input type="hidden" id="fmbd" name="fmbd" runat="server" />
</form>