<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="hrt506ukr"  >
    <t:ExtComboStore comboType="AU" comboCode="H053" opts= 'M;R'/> <!--정산구분-->
    <t:ExtComboStore comboType="AU" comboCode="H168" /> <!--퇴직사유-->
    <t:ExtComboStore comboType="AU" comboCode="H032" opts= 'E;F;G'/>
</t:appConfig>
<style type="text/css">
.x-grid-item-focused  .x-grid-cell-inner:before {
    border: 0px;
}
</style>
	<script type="text/javascript" >
	var activeGrid = '';
	var gwValue;                //그룹웨어 사용여부
	function appMain() {// tab01 form 로드 상태
	var formLoad = false;
	// 정산내역탭 로딩이 된 이후 저장 여부
	var tab01Saved = false;
	
	var gsGWUseYn = '${gsGWUseYN}'; // 그룹웨어 사용여부
	var groupUrl = '${groupUrl}'; //그룹웨어 호출 url
	
	if (gsGWUseYn == '00') {
	    gwValue = true;
	} else {
	    gwValue = false;
	}
	/**
	 *   Model 정의
	 * @type
	 */
	Unilite.defineModel('Hrt506ukrModel1', {
        fields: [ {name: 'RETR_DATE'			,text:'거래처명'			,type:'uniDate'}
                 ,{name: 'RETR_TYPE'			,text:'화폐단위'			,type:'string'}
                 ,{name: 'PERSON_NUMB'			,text:'전일미수'			,type:'string'}
                 ,{name: 'PAY_YYYYMM'			,text:'급여년월'			,type:'string', editable:false}
                 ,{name: 'WAGES_CODE'			,text:'부가세'			    ,type:'string'}
                 ,{name: 'WAGES_NAME'			,text:'지급구분'			,type:'string', editable:false}
                 ,{name: 'AMOUNT_I'				,text:'금액'				,type:'uniPrice'}
                 ,{name: 'PAY_STRT_DATE'		,text:'매출계'			    ,type:'string'}
                 ,{name: 'PAY_LAST_DATE'		,text:'현금입금'			,type:'string'}
                 ,{name: 'WAGES_DAY'			,text:'어음입금'			,type:'string'}
            ]
    });

    Unilite.defineModel('Hrt506ukrModel2', {
        fields: [ {name: 'RETR_DATE'			,text:'거래처명'			,type:'uniDate'}
                 ,{name: 'RETR_TYPE'			,text:'화폐단위'			,type:'string'}
                 ,{name: 'PERSON_NUMB'			,text:'전일미수'			,type:'string'}
                 ,{name: 'PAY_YYYYMM'			,text:'급여년월'			,type:'string', editable:false}
                 ,{name: 'WEL_CODE'				,text:'부가세'			    ,type:'string'}
                 ,{name: 'WEL_NAME'				,text:'지급구분'			,type:'string', editable:false}
                 ,{name: 'GIVE_I'				,text:'금액'				,type:'uniPrice'}
                 ,{name: 'WEL_LEVEL1'			,text:'에누리'			    ,type:'string'}
                 ,{name: 'WEL_LEVEL2'			,text:'에누리'			    ,type:'string'}
                 ,{name: 'APPLY_YYMM'			,text:'에누리'			    ,type:'uniDate'}
                 ,{name: 'PAY_STRT_DATE'		,text:'매출계'			    ,type:'string'}
                 ,{name: 'PAY_LAST_DATE'		,text:'현금입금'			,type:'string'}
                 ,{name: 'WAGES_DAY'			,text:'어음입금'			,type:'string'}
            ]
    });

    Unilite.defineModel('Hrt506ukrModel3', {
        fields: [ {name: 'RETR_DATE'			,text:'거래처명'			,type:'uniDate'}
                 ,{name: 'RETR_TYPE'			,text:'화폐단위'			,type:'string'}
                 ,{name: 'PERSON_NUMB'			,text:'전일미수'			,type:'string'}
                 ,{name: 'BONUS_YYYYMM'			,text:'상여구분'			,type:'string', editable:false}
                 ,{name: 'BONUS_TYPE'			,text:'부가세'			    ,type:'string'}
                 ,{name: 'BONUS_NAME'			,text:'상여구분'			,type:'string', editable:false}
                 ,{name: 'BONUS_I'				,text:'금액'				,type:'uniPrice'}
                 ,{name: 'BONUS_RATE'			,text:'에누리'			    ,type:'string'}
            ]
    });

    Unilite.defineModel('Hrt506ukrModel4', {
        fields: [ {name: 'RETR_DATE'			,text:'거래처명'			,type:'uniDate'}
                 ,{name: 'RETR_TYPE'			,text:'화폐단위'			,type:'string'}
                 ,{name: 'PERSON_NUMB'			,text:'전일미수' 			,type:'string'}
                 ,{name: 'BONUS_YYYYMM'			,text:'년월차년월'		,type:'string'}//, editable:false}
                 //,{name: 'BONUS_TYPE'			,text:'부가세'			,type:'string'}
                 ,{name: 'BONUS_TYPE'			,text:'년월차구분'		,type:'string', comboType:"AU" ,comboCode:"H032", defaultValue:'F'}//, editable:false}
                 ,{name: 'BONUS_RATE'			,text:'에누리세엑'		,type:'string'}
                 ,{name: 'BONUS_I'				,text:'금액'				,type:'uniPrice'}
                 ,{name: 'SUPP_DATE'			,text:'지급일'			,type:'uniDate'}
                 ,{name: 'BONUS_RATE'			,text:'에누리'			,type:'string'}
            ]
    });

    Unilite.defineModel('Hrt506ukrModel5', {
        fields: [ {name: 'SEQ'					,text:'부가세'			,type:'string'}
                 ,{name: 'DIVI_CODE'			,text:'구분'				,type:'string'}
                 ,{name: 'DIVI_NAME'			,text:'구분'				,type:'string'}
                 ,{name: 'DATA_TYPE'			,text:'화폐단위'			,type:'string'}
                 ,{name: 'CONTENT'				,text:'내용' 			,type:'string'}
                 ,{name: 'REMARK'				,text:'산출식'			,type:'string'}
            ]
    });

    Unilite.defineModel('Hrt506ukrModel6', {
        fields: [ {name: 'SUPP_DATE'			,text:'지급일자'         	,type:'string'}
                 ,{name: 'RETR_DATE_FR'			,text:'중간정산기산일(FR)'	,type:'string'}
                 ,{name: 'RETR_DATE_TO'			,text:'중간정산기산일(TO)'	,type:'string'}
                 ,{name: 'RETR_ANNU_I'			,text:'퇴직급여'			,type:'uniPrice'}
                 ,{name: 'IN_TAX_I'				,text:'소득세'			,type:'uniPrice'}
                 ,{name: 'LOCAL_TAX_I'			,text:'지방소득세'		,type:'uniPrice'}
                 ,{name: 'BALANCE_I'			,text:'차인지급액'		,type:'uniPrice'}
                 ,{name: 'REMARK'				,text:'비고'				,type:'string'}
            ]
    });


    /**
     *  산정내역(임원) 콤보박스  Store
     */
    var comboStore = Unilite.createStore('comboStore', {
        fields: ['value', 'text', 'remark'],
        data :  [
                    {'value': 'JOIN_DATE'			,'text': '입사일'				,'remark': ''},
                    {'value': 'RETR_DATE'			,'text': '퇴사일'				,'remark': ''},
                    {'value': 'ORG_RETR_ANNU_I'		,'text': '퇴직급여'			,'remark': ''},
                    {'value': 'ORG_GLORY_AMOUNT_I'	,'text': '명예퇴직급여'		,'remark': ''},
                    {'value': 'ORG_ETC_AMOUNT_I'	,'text': '기타지급'			,'remark': ''},
                    {'value': 'ORG_GROUP_INSUR_I'	,'text': '퇴직보험금'			,'remark': ''},
                    {'value': 'M_SUPP_TOTAL_I'		,'text': '중도정산퇴직금'		,'remark': ''},
                    {'value': 'SUPP_TOTAL_I'		,'text': '실제 퇴직금(a)'		,'remark': ''},
                    {'value': 'Y2011_SUPP_TOTAL_I'	,'text': '2011.12.31 중간정산가정액(b)', 'remark': ''},
                    {'value': 'STD_RETR_ANNU_I'		,'text': '한도대상퇴직금(c)'	,'remark': '실제퇴직금(a) - 2011.12.31 중간정산가정액(b)'},
                    {'value': 'Y_AVG_PAY_I'			,'text': '연평균급여(d)'		,'remark': '퇴직일부터소급(3년급여) / 36 * 12'},
                    {'value': 'CON_RETR_ANNU_I'		,'text': '퇴직소득한도(e)'		,'remark': '연평균급여(d) * 1/10 * 근속년수 * 2배'},
                    {'value': 'PAY_ANNU_I'			,'text': '근로소득간주액(f)'	,'remark': '한도대상퇴직금(c) - 퇴직소득한도(e)'},
                    {'value': 'RETR_ANNU_I'			,'text': '퇴직소득금액'		,'remark': '실제퇴직금(a) - 근로소득간주액(f)'},
                    {'value': 'R_IN_TAX_I'			,'text': '소득세'				,'remark': ''},
                    {'value': 'R_LOCAL_TAX_I'		,'text': '지방소득세'			,'remark': ''},
                    {'value': 'M_RETR_ANNU_I'		,'text': '지급된 중도정산퇴직금','remark': ''}
                ]
    });
	
	var directProxy1 = Ext.create('Unilite.com.data.proxy.UniDirectProxy', {
	    api: {
	        create: 'hrt506ukrService.insertList01',
	        read: 'hrt506ukrService.selectList01',
	        update: 'hrt506ukrService.updateList01',
	        syncAll: 'hrt506ukrService.syncAll01'
	    }
	});
	
	/**
	 * Store 정의(Service 정의)
	 * @type
	 */
	var directMasterStore1 = Unilite.createStore('hrt506ukrMasterStore1', {
	    model: 'Hrt506ukrModel1',
	    uniOpt: {
	        isMaster: true, // 상위 버튼 연결
	        editable: true, // 수정 모드 사용
	        deletable: true, // 삭제 가능 여부
	        useNavi: false // prev | newxt 버튼 사용
	    },
	    autoLoad: false,
	    proxy: directProxy1,
	    loadStoreRecords: function () {
	        var param = Ext.getCmp('panelResultForm').getValues();
	        console.log("directMasterStore1 :: " + param);
	        this.load({
	            params: param
	
	        });
	        var hrt507Btn = panelResult.down('#hrt507btn');
	        hrt507Btn.setDisabled(false);
	    },
	    saveStore: function () {
	        var paramMaster = getParams();
	        var inValidRecs = this.getInvalidRecords();
	        var rv = true;
	        if (inValidRecs.length == 0) {
	            config = {
	                params: [paramMaster],
	                success: function (batch, option) {
	                    directMasterStore1.loadStoreRecords();
	                    search1.saveForm();
	                }
	            };
	            this.syncAllDirect(config);
	        } else {
	            masterGrid1.uniSelectInvalidColumnAndAlert(inValidRecs);
	        }
	    },
	    groupField: 'PAY_YYYYMM',
	    listeners:{
	    	update:function(store, record, operation, modifiedFieldNames, details, eOpts)	{
	    		if(UniUtils.indexOf("AMOUNT_I", modifiedFieldNames))	{
                	fnCalRetrAnnu();
	    		}
	    	}
	    }
	});
	
	var directProxy2 = Ext.create('Unilite.com.data.proxy.UniDirectProxy', {
	    api: {
	        create: 'hrt506ukrService.insertList02',
	        read: 'hrt506ukrService.selectList02',
	        update: 'hrt506ukrService.updateList02',
	        syncAll: 'hrt506ukrService.syncAll02'
	    }
	});
	
	var directMasterStore2 = Unilite.createStore('hrt506ukrMasterStore1', {
	    model: 'Hrt506ukrModel2',
	    uniOpt: {
	        isMaster: true, // 상위 버튼 연결
	        editable: true, // 수정 모드 사용
	        deletable: true, // 삭제 가능 여부
	        useNavi: false // prev | newxt 버튼 사용
	    },
	    autoLoad: false,
	    proxy: directProxy2,
	    loadStoreRecords: function () {
	        var param = Ext.getCmp('panelResultForm').getValues();
	        console.log("directMasterStore2 :: " + param);
	        this.load({
	            params: param
	        });
	    },
	    saveStore: function () {
	        var paramMaster = getParams();
	        var inValidRecs = this.getInvalidRecords();
	        var rv = true;
	        if (inValidRecs.length == 0) {
	            config = {
	                params: [paramMaster],
	                success: function (batch, option) {
	                    directMasterStore2.loadStoreRecords();
	                    search1.saveForm();
	                }
	            };
	            this.syncAllDirect(config);
	        } else {
	            masterGrid2.uniSelectInvalidColumnAndAlert(inValidRecs);
	        }
	    },
	    listeners:{
	    	update:function(store, record, operation, modifiedFieldNames, details, eOpts)	{
	    		if(UniUtils.indexOf("GIVE_I", modifiedFieldNames))	{
                	fnCalRetrAnnu();
	    		}
	    	}
	    }
	});
	
	var directProxy3 = Ext.create('Unilite.com.data.proxy.UniDirectProxy', {
	    api: {
	        create: 'hrt506ukrService.insertList03',
	        read: 'hrt506ukrService.selectList03',
	        update: 'hrt506ukrService.updateList03',
	        syncAll: 'hrt506ukrService.syncAll03'
	    }
	});
	
	var directMasterStore3 = Unilite.createStore('hrt506ukrMasterStore3', {
	    model: 'Hrt506ukrModel3',
	    uniOpt: {
	        isMaster: true, // 상위 버튼 연결
	        editable: true, // 수정 모드 사용
	        deletable: true, // 삭제 가능 여부
	        useNavi: false // prev | newxt 버튼 사용
	    },
	    autoLoad: false,
	    proxy: directProxy3,
	    loadStoreRecords: function () {
	        var param = Ext.getCmp('panelResultForm').getValues();
	        console.log("directMasterStore3 :: " + param);
	        this.load({
	            params: param
	        });
	    },
	    saveStore: function () {
	        var paramMaster = getParams();
	        var inValidRecs = this.getInvalidRecords();
	        var rv = true;
	        if (inValidRecs.length == 0) {
	            config = {
	                params: [paramMaster],
	                success: function (batch, option) {
	                    directMasterStore3.loadStoreRecords();
	                    search1.saveForm();
	                }
	            };
	            this.syncAllDirect(config);
	        } else {
	            masterGrid3.uniSelectInvalidColumnAndAlert(inValidRecs);
	        }
	    },
	    listeners:{
	    	update:function(store, record, operation, modifiedFieldNames, details, eOpts)	{
	    		if(UniUtils.indexOf("BONUS_I", modifiedFieldNames))	{
                	fnCalRetrAnnu();
	    		}
	    	}
	    }
	});
	
	var directProxy4 = Ext.create('Unilite.com.data.proxy.UniDirectProxy', {
	    api: {
	        create: 'hrt506ukrService.insertList04',
	        read: 'hrt506ukrService.selectList04',
	        update: 'hrt506ukrService.updateList04',
	        destroy: 'hrt506ukrService.deleteList04',
	        syncAll: 'hrt506ukrService.syncAll04'
	    }
	});
	
	var directMasterStore4 = Unilite.createStore('hrt506ukrMasterStore4', {
	    model: 'Hrt506ukrModel4',
	    uniOpt: {
	        isMaster: true, // 상위 버튼 연결
	        editable: true, // 수정 모드 사용
	        deletable: true, // 삭제 가능 여부
	        useNavi: false // prev | newxt 버튼 사용
	    },
	    autoLoad: false,
	    proxy: directProxy4,
	    loadStoreRecords: function () {
	        var param = Ext.getCmp('panelResultForm').getValues();
	        //var bunusYyyymm = Ext.getCmp('panelResultForm').getValue('BONUS_YYYYMM').replace('.','');
	        //param.BONUS_YYYYMM = bunusYyyymm;
	        console.log("directMasterStore4 :: " + param);
	        this.load({
	            params: param
	        });
	    },
	    saveStore: function () {
	        var paramMaster = getParams();
	        var inValidRecs = this.getInvalidRecords();
	        var rv = true;
	        if (inValidRecs.length == 0) {
	            config = {
	                params: [paramMaster],
	                success: function (batch, option) {
	                    directMasterStore4.loadStoreRecords();
	                    if (search1.isDirty()) {
	                        search1.saveForm();
	                    }
	                }
	            };
	            this.syncAllDirect(config);
	        } else {
	            masterGrid4.uniSelectInvalidColumnAndAlert(inValidRecs);
	        }
	    },
	    listeners:{
	    	update:function(store, record, operation, modifiedFieldNames, details, eOpts)	{
	    		if(UniUtils.indexOf("BONUS_I", modifiedFieldNames))	{
                	fnCalRetrAnnu();
	    		}
	    	}
	    }
	});
	
	var directMasterStore5 = Unilite.createStore('hrt506ukrMasterStore5', {
	    model: 'Hrt506ukrModel5',
	    uniOpt: {
	        isMaster: false, // 상위 버튼 연결
	        editable: false, // 수정 모드 사용
	        deletable: true, // 삭제 가능 여부
	        useNavi: false // prev | newxt 버튼 사용
	    },
	    autoLoad: false,
	    proxy: {
	        type: 'direct',
	        api: {
	            read: 'hrt506ukrService.selectList05'
	        }
	    },
	    loadStoreRecords: function () {
	        var param = Ext.getCmp('panelResultForm').getValues();
	        console.log(param);
	        this.load({
	            params: param
	        });
	    }
	});
	
	var directMasterStore6 = Unilite.createStore('hrt506ukrMasterStore6', {
	    model: 'Hrt506ukrModel6',
	    uniOpt: {
	        isMaster: false, // 상위 버튼 연결
	        editable: false, // 수정 모드 사용
	        deletable: true, // 삭제 가능 여부
	        useNavi: false // prev | newxt 버튼 사용
	    },
	    autoLoad: false,
	    proxy: {
	        type: 'direct',
	        api: {
	            read: 'hrt506ukrService.selectList06'
	        }
	    },
	    loadStoreRecords: function () {
	        var param = Ext.getCmp('panelResultForm').getValues();
	        console.log(param);
	        this.load({
	            params: param
	        });
	    }
	});
	
	var panelResult = Unilite.createSearchForm('panelResultForm', {
	    hidden: !UserInfo.appOption.collapseLeftSearch,
	    region: 'north',
	    layout: {
	        type: 'uniTable',
	        columns: 5,
	        tableAttrs: {
	            'width': '100%'
	        }
	    },
	    padding: '1 1 1 1',
	    border: true,
	    items: [
	        Unilite.popup('Employee', {
	            valueFieldName: 'PERSON_NUMB',
	            textFieldName: 'NAME',
	            validateBlank: true,
	            allowBlank: false,
	            labelWidth: 118,
	            listeners: {
	                onSelected: {
	                    fn: function (records, type) {
	                    	// 사번/이름 두 필드에서 이벤트가 일어나므로 focus를 옮김
	                    	var field = panelResult.getField('NAME');
	                    	Unilite.focusNextField(field, false);
	                        
	                        Ext.getBody().mask();
	                        hrt501ukrService.checkRetroOTKind({
	                            PERSON_NUMB: records[0].PERSON_NUMB
	                        }, function (responseText, response) {
	                            if (responseText) {
	                                var param = {
	                                    "PERSON_NUMB": records[0].PERSON_NUMB
	                                };
	                                if (!Ext.isEmpty(records[0].RETR_DATE)) {
	                                    panelResult.setValue('RETR_TYPE', 'R');
	                                    panelResult.setValue('RETR_DATE', records[0].RETR_DATE);
	                                } else {
	                                    panelResult.setValue('RETR_TYPE', 'M');
	                                    panelResult.setValue('RETR_DATE', '');
	                                }
	                                panelResult.setValue('OT_KIND', responseText.RETR_OT_KIND);
	
	                                if (panelResult.getValue('OT_KIND').OT_KIND == 'OF') {
	                                    tab.down('#hrt506ukrTab03').setDisabled(false);
	                                } else {
	                                    tab.down('#hrt506ukrTab03').setDisabled(true);
	                                }
	                                var hrt507Btn = panelResult.down('#hrt507btn');
	                                hrt507Btn.setDisabled(false);
	
	                                var hrt507btn1 = panelResult.down('#hrt507btn1');
	                                hrt507btn1.setDisabled(false);
	
	                                var GWBtn = panelResult.down('#GWBtn');
	                                GWBtn.setDisabled(false);
	                                UniAppManager.setToolbarButtons('reset', true);
	
	                                var param = {
	                                    "RETR_TYPE": panelResult.getValue('RETR_TYPE'),
	                                    "PERSON_NUMB": records[0].PERSON_NUMB
	                                };
	
	                                hrt506ukrService.checkRetrDate2(param, function (provider, response) {
	                                    if (provider) {
	                                        if (provider.HRT_CNT > 0) {
	                                            search1.setValue('SUPP_DATE', provider.SUPP_DATE);
	                                            panelResult.setValue('RETR_DATE', provider.RETR_DATE);
	                                            UniAppManager.setToolbarButtons('save', false);
	                                        } else {
	                                            if (panelResult.getValue('RETR_TYPE') == 'R') {
	                                                panelResult.setValue('RETR_DATE', records[0].RETR_DATE);
	                                                UniAppManager.setToolbarButtons('save', false);
	                                            } else {
	                                                search1.setValue('SUPP_DATE', '');
	                                                panelResult.setValue('RETR_DATE', '');
	                                                UniAppManager.setToolbarButtons('save', false);
	                                            }
	                                        }
	                                    }
	                                    Ext.getBody().unmask();
	                                });
	                            } else {
	                                var hrt507Btn = panelResult.down('#hrt507btn');
	                                hrt507Btn.setDisabled(true);
	                                var GWBtn = panelResult.down('#GWBtn');
	                                GWBtn.setDisabled(true);
	                                Ext.getBody().unmask();
	                            }
	                        });
	                    },
	                    scope: this
	                },
	                onClear: function (type) {
	                    var hrt507Btn = panelResult.down('#hrt507btn');
	                    hrt507Btn.setDisabled(true);
	                    var GWBtn = panelResult.down('#GWBtn');
	                    GWBtn.setDisabled(true);
	                }
	            }
	        }), {
	            xtype: 'component'
	        }, {
	            xtype: 'radiogroup',
	            fieldLabel: '퇴직분류',
	            labelWidth: 160,
	            readOnly: true,
	            // colspan:2,
	            id: 'OT_KIND',
	            items: [{
	                boxLabel: '임원',
	                width: 50,
	                name: 'OT_KIND',
	                inputValue: 'OF'
	            }, {
	                boxLabel: '직원',
	                width: 60,
	                name: 'OT_KIND',
	                inputValue: 'ST',
	                checked: true
	            }],
	            listeners: {
	                change: function (field, newValue, oldValue, eOpts) {
	                    console.log("newValue :: " + newValue.OT_KIND);
	                    if (newValue.OT_KIND == 'OF') {
	                        tab.down('#hrt506ukrTab03').setDisabled(false);
	                    } else {
	                        tab.down('#hrt506ukrTab03').setDisabled(true);
	                    }
	                }
	            }
	        }, {
	            xtype: 'component',
	            width: 700,
	            colspan: 2,
	            html: '<b>※중간정산의 경우 정산일과 지급일의 날짜가 다른 경우에는 제외월수 혹은 가산월수를 기재해 주시기 바랍니다.</b>',
	            style: {
	                color: 'red'
	            }
	        }, {
	            fieldLabel: '정산구분',
	            name: 'RETR_TYPE',
	            xtype: 'uniCombobox',
	            comboType: 'AU',
	            comboCode: 'H053',
	            allowBlank: false,
	            labelWidth: 118,
	            listeners: {
	                change: function (field, newValue, oldValue, eOpts) {}
	            }
	        }, {
	            fieldLabel: '정산일',
	            xtype: 'uniDatefield',
	            labelWidth: 100,
	            allowBlank: false,
	            name: 'RETR_DATE',
	            listeners: {
	                change: function (field, newValue, oldValue, eOpts) {
	                    search1.setValue('SUPP_DATE', newValue);
	                    UniAppManager.setToolbarButtons('save', false);
	                    var hrt507btn1 = panelResult.down('#hrt507btn1');
	                    hrt507btn1.setDisabled(false);
	                }
	            }
	        }, {
	            xtype: 'radiogroup',
	            fieldLabel: '세액계산',
	            labelWidth: 160,
	            colspan: 2,
	            items: [{
	                boxLabel: '한다',
	                width: 50,
	                name: 'TAX_CALCU',
	                inputValue: 'Y',
	                checked: true
	            }, {
	                boxLabel: '안한다',
	                width: 60,
	                name: 'TAX_CALCU',
	                inputValue: 'N'
	            }],
	            listeners: {
	                change: function (field, newValue, oldValue, eOpts) {}
	            }
	        }, {
	
	            xtype: 'container',
	            layout: {
	                type: 'uniTable',
	                columns: 2,
	                align: 'right'
	            },
	            items: [{
	                xtype: 'button',
	                itemId: 'hrt507btn1',
	                text: '퇴직금 계산',
	                width: 110,
	                disabled: true,
	                tdAttrs: {
	                    'align': 'right',
	                    'width': '50%',
	                    'style': 'padding-right:10px;'
	                },
	                style: {
	                    'margin-bottom': '3px'
	                },
	                handler: function () {
	                	
	                    var params = getParams();
	                    if(Ext.isEmpty(params.RETR_DATE))	{
	                    	alert('정산일을 입력하세요.');
	                    	var field = panelResult.getField('RETR_DATE');
	                    	if(field)	{
	                    		field.focus();
	                    	}
	                    	return
	                    }
	                    if(Ext.isEmpty(params.SUPP_DATE ))	{
	                    	alert('지급일을 입력하세요.');
	                    	var field = search1.getField('SUPP_DATE');
	                    	if(field)	{
	                    		field.focus();
	                    	}
	                    	return
	                    }
	                    hrt506ukrService.chckHrt500t(params, function (provider, response) {
	                        if (Ext.isEmpty(provider)) {
	                            hrt506ukrService.ProcSt(params, function (provider, response) {
	                                alert('퇴직금 계산을 완료했습니다.');
	                                UniAppManager.app.onQueryButtonDown();
	                            });
	                        } else {
	                            if (confirm('기존 데이터를 삭제하고 계속 진행 하시겠습니까?')) {
	                                params.DELETE_FLAG = 'Y';
	                                hrt506ukrService.ProcSt(params, function (provider, response) {
	                                    alert('퇴직금 계산을 완료했습니다.');
	                                    UniAppManager.app.onQueryButtonDown();
	                                });
	                            }
	                        }
	                    });
	                }
	            }, {
	                xtype: 'button',
	                itemId: 'hrt507btn',
	                text: '퇴직금영수증등록',
	                tdAttrs: {
	                    'align': 'right',
	                    'width': '50%',
	                    'style': 'padding-right:10px;'
	                },
	                style: {
	                    'margin-bottom': '3px'
	                },
	                disabled: true,
	                handler: function () {
	                    var params = {
	                        'PERSON_NUMB': panelResult.getValue('PERSON_NUMB'),
	                        'NAME': panelResult.getValue('NAME'),
	                        'RETR_TYPE': panelResult.getValue('RETR_TYPE'),
	                        'RETR_DATE': UniDate.getDateStr(panelResult.getValue('RETR_DATE')),
	                        'SUPP_DATE': UniDate.getDateStr(search1.getValue('SUPP_DATE'))
	                    }
	
	                    var rec = {
	                        data: {
	                            prgID: 'hrt507ukr',
	                            'text': '퇴직금영수증등록'
	                        }
	                    };
	                    parent.openTab(rec, '/human/hrt507ukr.do', params);
	
	                }
	            }]
	        }, {
	            itemId: 'GWBtn',
	            id: 'GW',
	            xtype: 'button',
	            hidden: gwValue,
	            text: '기안',
	            tdAttrs: {
	                'align': 'right',
	                'style': 'padding-right:10px;'
	            },
	            style: {
	                'margin-bottom': '3px'
	            },
	            handler: function () {
	                var param = panelResult.getValues();
	
	                if (!UniAppManager.app.isValidSearchForm()) {
	                    return false;
	                }
	
	                //param.DRAFT_NO = "0";
	                if (confirm('기안 하시겠습니까?')) {
	                    UniAppManager.app.requestApprove();
	                }
	                //UniAppManager.app.onQueryButtonDown();
	            }
	        }
	    ]
	});
	
	var search1 = Unilite.createSearchForm('search1', {
	    autoScroll: true,
	    border: false,
	    padding: '5 7 0 7',
	    xtype: 'container',
	    flex: 1,
	    api: {
	        load: 'hrt506ukrService.selectFormData01',
	        submit: 'hrt506ukrService.submitFormData01'
	    },
	    trackResetOnLoad: true,
	    layout: {
	        type: 'vbox',
	        align: 'stretch',
	        defaultMargins: '0 0 5 0'
	    },
	    items: [{
	
	        xtype: 'container',
	        layout: {
	            type: 'uniTable',
	            columns: 10
	        },
	        items: [
	        	{ xtype: 'container',
	              html: '<b>■ 근속내역</b>',
	              tdAttrs: {
	                    style: 'border : 0px solid #ced9e7; font: normal 13px "굴림",Gulim,tahoma, arial, verdana, sans-serif;',
	                    align: 'left'
	              },
	              colspan: 10,
	              margin: '0 0 5 0'
	            }, 
	            { xtype: 'uniDatefield', fieldLabel: '정산시작일'		, name: 'JOIN_DATE', labelWidth: 110, colspan: 2}, 
	            { xtype: 'uniDatefield', fieldLabel: '정산(퇴직)일'	    , name: 'RETR_DATE', labelWidth: 166, colspan: 2}, 
	            { xtype: 'uniDatefield', fieldLabel: '지급일'			, name: 'SUPP_DATE', labelWidth: 166, colspan: 2, allowBlank: false,
	              listeners: {
	                    change: function (field, newValue, oldValue, eOpts) {
	                        if (search1.uniOpt.inLoading == false) {
	                            var hrt507btn1 = panelResult.down('#hrt507btn1');
	                            if (!Ext.isEmpty(newValue)) {
	                                UniAppManager.setToolbarButtons('save', false);
	                                hrt507btn1.setDisabled(false);
	                            }
	                        }
	                    }
	                }
	            }, 
	            { xtype: 'uniCombobox', fieldLabel: '사유', name: 'RETR_RESN', comboType: 'AU', comboCode: 'H168',  value: '6', allowBlank: false,labelWidth: 166, colspan: 2}, 
	            { xtype: 'container',
                  defaultType: 'uniNumberfield',
                  layout: {	type: 'hbox',align: 'stretch'},
                  width: 600,
                  margin: 0,
                  colspan: 2,
                  items: [
                  	{ fieldLabel: '2013이후 제외 월/일수',   name: 'EXEP_MONTHS_AF13',  labelWidth: 150, enforceMaxLength: true, value: 0, maxLength: 2, width: 200}, 
	                { xtype: 'component', html: '/', style: {marginTop: '3px !important',  font: '12px "굴림",Gulim,tahoma,arial,verdana,sans-serif'} }, 
	                { name: 'R_EXEP_DAY_AF13',  enforceMaxLength: true, value: 0, maxLength: 2,width: 50}
	              ]
	            }, 
	            { xtype: 'uniTextfield',   fieldLabel: '근속기간(년/월/일)', name: 'YYYYMMDD', labelWidth: 110,colspan: 2, fieldStyle: "text-align:right;"}, 
	            { xtype: 'uniNumberfield', fieldLabel: '근속일수', name: 'LONG_TOT_DAY1',labelWidth: 166, value: 0,colspan: 2}, 
	            { xtype: 'container',
	              defaultType: 'uniNumberfield',
	              layout: { type: 'hbox', align: 'stretch'},
	              width: 300,
	              margin: 0,
	              colspan: 2,
	              items: [
	              	{ fieldLabel: '누진/근속월수',name: 'ADD_MONTH' ,labelWidth: 166 ,suffixTpl: '&nbsp;/&nbsp;' ,width: 220}, 
	              	{ name: 'LONG_TOT_MONTH', width: 50 }
	              ]
	            }, 
	            { xtype: 'uniNumberfield', fieldLabel: '근속년수', name: 'LONG_YEARS',value: '0',labelWidth: 166,width: 230,fieldStyle: "text-align:right;",colspan: 2}, 
	            { xtype: 'container',
	              defaultType: 'uniNumberfield',
	              layout: { type: 'hbox', align: 'stretch'},
	              width: 600,
	              margin: 0,
	              colspan: 2,
	              items: [
	              	{ fieldLabel: '2013이전 제외 월/일수', name: 'EXEP_MONTHS_BE13', labelWidth: 150, enforceMaxLength: true, value: 0, maxLength: 2, width: 200}, 
	              	{ xtype: 'component', html: '/', style: { marginTop: '3px !important',  font: '12px "굴림",Gulim,tahoma,arial,verdana,sans-serif'}}, 
	              	{ name: 'R_EXEP_DAY_BE13', value: 0, enforceMaxLength: true, maxLength: 2, width: 50 }
	              ]
	            }, 
	            // hidden fields
	            { xtype: 'uniNumberfield', 	fieldLabel: '근속년'					, name: 'DUTY_YYYY'				, hidden:true}, 
	            { xtype: 'uniNumberfield', 	fieldLabel: '근속월'					, name: 'LONG_MONTH'			, hidden:true},
	            { xtype: 'uniNumberfield', 	fieldLabel: '근속일'					, name: 'LONG_DAY'				, hidden:true},
	            { xtype: 'uniNumberfield', 	fieldLabel: '3개월총일수'				, name: 'AVG_DAY'				, hidden:true},
	            { xtype: 'uniNumberfield', 	fieldLabel: '급여총액'				, name: 'PAY_TOTAL_I'			, hidden:true},
	            { xtype: 'uniNumberfield', 	fieldLabel: '상여총액'				, name: 'BONUS_TOTAL_I'			, hidden:true},
	            { xtype: 'uniNumberfield', 	fieldLabel: '년월차총액'				, name: 'YEAR_TOTAL_I'			, hidden:true},
	            { xtype: 'uniNumberfield', 	fieldLabel: '퇴직소득정률공제'			, name: 'SPEC_DED_I'			, hidden:true},
	            { xtype: 'uniNumberfield', 	fieldLabel: '(15)퇴직급여_최종'		, name: 'R_ANNU_TOTAL_I'		, hidden:true},
	            { xtype: 'uniNumberfield', 	fieldLabel: '(17)과세대상 퇴직급여(15-16)_최종', name: 'R_TAX_TOTAL_I'	, hidden:true},
	            { xtype: 'uniNumberfield', 	fieldLabel: '(15)퇴직급여_중간'		, name: 'M_ANNU_TOTAL_I'		, hidden:true},
	            { xtype: 'uniNumberfield', 	fieldLabel: '(16)비과세 퇴직급여_중간'	, name: 'M_OUT_INCOME_I'		, hidden:true},
	            { xtype: 'uniNumberfield', 	fieldLabel: '정산(합산)근속연수'		, name: 'S_LONG_YEARS'			, hidden:true}, 
	            { xtype: 'uniNumberfield', 	fieldLabel: '2013이전근속연수'			, name: 'LONG_YEARS_BE13'		, hidden:true}, 
	            { xtype: 'uniNumberfield', 	fieldLabel: '2013이후근속연수'			, name: 'LONG_YEARS_AF13'		, hidden:true}, 
	            { xtype: 'uniTextfield',   	fieldLabel: '최종분-기산일'			, name: 'R_CALCU_END_DATE'		, hidden:true}, 
	            
	            { xtype: 'uniNumberfield', fieldLabel: '실지급액'					, name: 'REAL_AMOUNT_I'			, hidden:true}, 
	            { xtype: 'uniNumberfield', fieldLabel: '차감원천징수세액-소득세'		, name: 'BAL_IN_TAX_I'			, hidden:true}, 
	            { xtype: 'uniNumberfield', fieldLabel: '차감원천징수세액-지방소득세'	, name: 'BAL_LOCAL_TAX_I'		, hidden:true}, 
	            { xtype: 'uniNumberfield', fieldLabel: '차감원천징수세액 - 농특세'	, name: 'BAL_SP_TAX_I'			, hidden:true},
	       
	            //[근속연수 - 중간지급]
				{ xtype: 'uniTextfield', 	fieldLabel: '입사일'					, name: 'M_JOIN_DATE'			, hidden:true },
				{ xtype: 'uniTextfield', 	fieldLabel: '기산일'					, name: 'M_CALCU_END_DATE'     , hidden:true },
				{ xtype: 'uniTextfield', 	fieldLabel: '퇴사일' 					, name: 'M_RETR_DATE'          , hidden:true },
				{ xtype: 'uniTextfield', 	fieldLabel: '지급일' 					, name: 'M_SUPP_DATE'          , hidden:true },
				{ xtype: 'uniNumberfield', 	fieldLabel: '근속월수' 				, name: 'M_LONG_MONTHS'        , hidden:true },
				{ xtype: 'uniNumberfield', 	fieldLabel: '제외월수20121231이전' 	, name: 'M_EXEP_MONTHS_BE13'   , hidden:true },
				{ xtype: 'uniNumberfield', 	fieldLabel: '제외월수20130101이후' 	, name: 'M_EXEP_MONTHS_AF13'   , hidden:true },
				{ xtype: 'uniNumberfield', 	fieldLabel: '제외월수' 				, name: 'M_EXEP_MONTHS'        , hidden:true },
				{ xtype: 'uniNumberfield', 	fieldLabel: '가산월수20121231이전' 	, name: 'M_ADD_MONTHS_BE13'    , hidden:true },
				{ xtype: 'uniNumberfield', 	fieldLabel: '가산월수20130101이후' 	, name: 'M_ADD_MONTHS_AF13'    , hidden:true },
				{ xtype: 'uniNumberfield', 	fieldLabel: '가산월수' 				, name: 'M_ADD_MONTHS'         , hidden:true },
				{ xtype: 'uniNumberfield', 	fieldLabel: '근속연수' 				, name: 'M_LONG_YEARS'         , hidden:true },
				//
				{ xtype: 'uniTextfield', 	fieldLabel: '입사일' 					, name: 'R_JOIN_DATE'          , hidden:true },
				{ xtype: 'uniTextfield', 	fieldLabel: '퇴사일' 					, name: 'R_RETR_DATE'          , hidden:true },
				{ xtype: 'uniTextfield', 	fieldLabel: '지급일' 					, name: 'R_SUPP_DATE'          , hidden:true },
				{ xtype: 'uniNumberfield', 	fieldLabel: '근속월수' 				, name: 'R_LONG_MONTHS'        , hidden:true },
				{ xtype: 'uniNumberfield', 	fieldLabel: '제외월수20121231이전' 	, name: 'R_EXEP_MONTHS_BE13'   , hidden:true },
				{ xtype: 'uniNumberfield', 	fieldLabel: '제외월수20130101이후' 	, name: 'R_EXEP_MONTHS_AF13'   , hidden:true },
				{ xtype: 'uniNumberfield', 	fieldLabel: '제외월수' 				, name: 'R_EXEP_MONTHS'        , hidden:true },
				{ xtype: 'uniNumberfield', 	fieldLabel: ' 가산월수20121231이전' 	, name: 'R_ADD_MONTHS_BE13'    , hidden:true },
				{ xtype: 'uniNumberfield', 	fieldLabel: '가산월수20130101이후' 	, name: 'R_ADD_MONTHS_AF13'    , hidden:true },
				{ xtype: 'uniNumberfield', 	fieldLabel: '가산월수' 				, name: 'R_ADD_MONTHS'         , hidden:true },
				{ xtype: 'uniNumberfield', 	fieldLabel: '근속연수' 				, name: 'R_LONG_YEARS'         , hidden:true },
				//[근속연수 - 정산]
				{ xtype: 'uniTextfield', 	fieldLabel: '입사일' 					, name: 'S_JOIN_DATE'          , hidden:true },
				{ xtype: 'uniTextfield', 	fieldLabel: '기산일' 					, name: 'S_CALCU_END_DATE'     , hidden:true },
				{ xtype: 'uniTextfield', 	fieldLabel: '퇴사일' 					, name: 'S_RETR_DATE'          , hidden:true },
				{ xtype: 'uniNumberfield', 	fieldLabel: '근속월수' 				, name: 'S_LONG_MONTHS'        , hidden:true },
				{ xtype: 'uniNumberfield', 	fieldLabel: '제외월수' 				, name: 'S_EXEP_MONTHS'        , hidden:true },
				{ xtype: 'uniNumberfield', 	fieldLabel: '가산월수' 				, name: 'S_ADD_MONTHS'         , hidden:true },
				{ xtype: 'uniNumberfield', 	fieldLabel: '중복월수' 				, name: 'S_DUPLI_MONTHS'       , hidden:true },
				//[근속연수 - 안분_2012.12.31이전]
				{ xtype: 'uniTextfield', 	fieldLabel: '기산일20121231이전' 		, name: 'CALCU_END_DATE_BE13'  , hidden:true },
				{ xtype: 'uniTextfield', 	fieldLabel: '퇴사일20121231이전	' 	, name: 'RETR_DATE_BE13'       , hidden:true },
				{ xtype: 'uniNumberfield', 	fieldLabel: '근속월수20121231이전' 	, name: 'LONG_MONTHS_BE13'     , hidden:true },
				{ xtype: 'uniNumberfield', 	fieldLabel: '가산월수20121231이전' 	, name: 'ADD_MONTHS_BE13'      , hidden:true },
				//[근속연수 - 안분_2013.01.01이후]
				{ xtype: 'uniTextfield', 	fieldLabel: '기산일20130101이후' 		, name: 'CALCU_END_DATE_AF13'  , hidden:true },
				{ xtype: 'uniTextfield', 	fieldLabel: '퇴사일20130101이후' 		, name: 'RETR_DATE_AF13'       , hidden:true },
				{ xtype: 'uniNumberfield', 	fieldLabel: '근속월수20130101이후' 	, name: 'LONG_MONTHS_AF13'     , hidden:true },
				{ xtype: 'uniNumberfield', 	fieldLabel: '가산월수20130101이후' 	, name: 'ADD_MONTHS_AF13'      , hidden:true },
				
				{ xtype: 'uniNumberfield', 	fieldLabel: '과세표준안분20121231이전' 	, name: 'DIVI_TAX_STD_BE13'    , hidden:true },
				{ xtype: 'uniNumberfield', 	fieldLabel: '과세표준안분20130101이후' 	, name: 'DIVI_TAX_STD_AF13'    , hidden:true },
				{ xtype: 'uniNumberfield', 	fieldLabel: '연평균과세표준20121231이전', name: 'AVG_TAX_STD_BE13'     , hidden:true },
				{ xtype: 'uniNumberfield', 	fieldLabel: '연평균과세표준20130101이후', name: 'AVG_TAX_STD_AF13'     , hidden:true },
				{ xtype: 'uniNumberfield', 	fieldLabel: '환산과세표준20130101이후' 	, name: 'EX_TAX_STD_AF13'      , hidden:true },
				{ xtype: 'uniNumberfield', 	fieldLabel: '환산산출세액20130101이후' 	, name: 'EX_COMP_TAX_AF13'     , hidden:true },
				{ xtype: 'uniNumberfield', 	fieldLabel: '연평균산출세액20121231이전', name: 'AVR_COMP_TAX_BE13'    , hidden:true },
				{ xtype: 'uniNumberfield', 	fieldLabel: '연평균산출세액20130101이후', name: 'AVR_COMP_TAX_AF13'    , hidden:true },
				{ xtype: 'uniNumberfield', 	fieldLabel: '산출세액20121231이전' 	, name: 'COMP_TAX_BE13'        , hidden:true },
				{ xtype: 'uniNumberfield', 	fieldLabel: '산출세액20130101이후' 	, name: 'COMP_TAX_AF13'        , hidden:true },
				{ xtype: 'uniNumberfield', 	fieldLabel: '산출세액' 				, name: 'COMP_TAX_I_16'        , hidden:true },
				
				//임원용 퇴직금 필드
				{ xtype: 'uniNumberfield', 	fieldLabel: '실퇴직금액' 				, name: 'OF_SUPP_TOTAL_I'      , hidden:true },
                { xtype: 'uniNumberfield', 	fieldLabel: '2011년퇴직가정액'			, name: 'OF_Y2011_SUPP_TOTAL_I', hidden:true },  
                { xtype: 'uniNumberfield', 	fieldLabel: '한도계산대상퇴직금액' 		, name: 'OF_STD_RETR_ANNU_I'   , hidden:true },    
                { xtype: 'uniNumberfield', 	fieldLabel: '연평균금액' 				, name: 'OF_Y_AVG_PAY_I'       , hidden:true },       
                { xtype: 'uniNumberfield', 	fieldLabel: '퇴직금한도액'				, name: 'OF_CON_RETR_ANNU_I'   , hidden:true },      
                { xtype: 'uniNumberfield', 	fieldLabel: '퇴직소득액' 				, name: 'OF_RETR_ANNU_I'       , hidden:true }, 
                
	            // 이하 form submit용 hidden field -> detailForm내부의 field
	            { xtype: 'uniNumberfield', 	fieldLabel: '중간정산(과세대상)(B)'		, name: 'M_TAX_TOTAL_I'			, hidden:true} 
	            
	        ]
	    }, {
	        xtype: 'container',
	        margin: '10 0 0 0',
	        layout: {
	            type: 'table',
	            columns: 10,
	            tableAttrs: {  style: 'border : 1px solid #ced9e7;',  width: '100%' },
	            tdAttrs: {  style: 'border : 1px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif; width: 10%;', align: 'center'}
	        },
	        defaults: {
	            width: '97.5%',
	            margin: '2 2 2 2'
	        },
	        items: [
                { xtype: 'component',  html:'퇴직금계산내역', colspan: 2, tdAttrs: {height: 29}},
                { xtype: 'component',  html:'지급내역', colspan: 2},
                { xtype: 'component',  html:'2015.12.31 이전 - 세액내역', colspan: 2},
                { xtype: 'component',  html:'2016.01.01 이후 - 세액내역', colspan: 2},
                { xtype: 'component',  html:'공제내역', colspan: 2},

                { xtype: 'component',  html:'3개월급여'},
                { xtype: 'uniNumberfield', value: 0, name: 'AVG_PAY_3', suffixTpl: '원', readOnly: true/*, fieldCls: 'no-border-text-field'*/},
                { xtype: 'component',  html:'퇴직급여'},
                { xtype: 'uniNumberfield', value: 0, name: 'RETR_ANNU_I', suffixTpl: '원', value:0 ,
                    listeners: {
                    	change:function(field, newValue, oldValue)	{
                    		if(newValue != oldValue && !search1.uniOpt.inLoading)	{
                    			field.changeCheck = true;
                    		}
                    	},
                        blur : function(field, eOpts) {
                        	if(field.changeCheck)	{
                        		fnSuppTotI();
                        		field.changeCheck = false;
                        	}
                        }
                    }
                },
                { xtype: 'component',  html:'과세대상 퇴직급여'},
                { xtype: 'uniNumberfield', value: 0, name: 'SUPP_TOTAL_I1', suffixTpl: '원', readOnly: true},
                { xtype: 'component',  html:'정산퇴직소득'},
                { xtype: 'uniNumberfield', value: 0, name: 'SUPP_TOTAL_I2', suffixTpl: '원', readOnly: true},
                { xtype: 'component',  html:'소득세'},
                { xtype: 'uniNumberfield', value: 0, name: 'IN_TAX_I', suffixTpl: '원', readOnly: true,
                    listeners: {
                    	change:function(field, newValue, oldValue)	{
                    		if(newValue != oldValue && !search1.uniOpt.inLoading)	{
                    			field.changeCheck = true;
                    		}
                    	},
                        blur : function(field, eOpts) {
                        	if(field.changeCheck)	{
                        		fnDedTotI();
                        		field.changeCheck = false;
                        	}
                        }
                    }
               },

                { xtype: 'component',  html:'3개월상여'},
                { xtype: 'uniNumberfield', value: 0, name: 'AVG_BONUS_I_3', suffixTpl: '원', readOnly: true},
                { xtype: 'component',  html:'명예퇴직금'},
                { xtype: 'uniNumberfield', value: 0, name: 'GLORY_AMOUNT_I', suffixTpl: '원',
                    listeners: {
                        change:function(field, newValue, oldValue)	{
                    		if(newValue != oldValue && !search1.uniOpt.inLoading)	{
                    			field.changeCheck = true;
                    		}
                    	},
                        blur : function(field, eOpts) {
                        	if(field.changeCheck)	{
                        		fnSuppTotI();
                        		field.changeCheck = false;
                        	}
                        }
                    }
                },
                { xtype: 'component',  html:'퇴직소득공제'},
                { xtype: 'uniNumberfield', value: 0, name: 'EARN_INCOME_I', suffixTpl: '원', readOnly: true},
                { xtype: 'component',  html:'근속년수공제'},
                { xtype: 'uniNumberfield', value: 0, name: 'INCOME_DED_I', suffixTpl: '원', readOnly: true},
                { xtype: 'component',  html:'지방소득세'},
                { xtype: 'uniNumberfield', value: 0, name: 'LOCAL_TAX_I', suffixTpl: '원', readOnly: true,
                    listeners: {
                    	change:function(field, newValue, oldValue)	{
                    		if(newValue != oldValue && !search1.uniOpt.inLoading)	{
                    			field.changeCheck = true;
                    		}
                    	},
                        blur : function(field, eOpts) {
                        	if(field.changeCheck)	{
                        		fnDedTotI();
                        		field.changeCheck = false;
                        	}
                        }
                    }
                },

                { xtype: 'component',  html:'3개월년차'},
                { xtype: 'uniNumberfield', value: 0, name: 'AVG_YEAR_I_3', suffixTpl: '원', readOnly: true},
                { xtype: 'component',  html:'퇴직보험금'},
                { xtype: 'uniNumberfield', value: 0, name: 'GROUP_INSUR_I', suffixTpl: '원',
                    listeners: {
                        change:function(field, newValue, oldValue)	{
                    		if(newValue != oldValue && !search1.uniOpt.inLoading)	{
                    			field.changeCheck = true;
                    		}
                    	},
                        blur : function(field, eOpts) {
                        	if(field.changeCheck)	{
                        		fnSuppTotI();
                        		field.changeCheck = false;
                        	}
                        }

                    }
                },
                { xtype: 'component',  html:'과세표준'},
                { xtype: 'uniNumberfield', value: 0, name: 'TAX_STD_I', suffixTpl: '원', readOnly: true},
                { xtype: 'component',  html:'환산급여'},
                { xtype: 'uniNumberfield', value: 0, name: 'PAY_TOTAL_I_16', suffixTpl: '원', readOnly: true},
                { xtype: 'component',  html:'소득세환급액'},
                { xtype: 'uniNumberfield', value: 0, name: 'DED_IN_TAX_ADD_I', suffixTpl: '원' , value:0,
                    listeners: {
                    	change:function(field, newValue, oldValue)	{
                    		if(newValue != oldValue && !search1.uniOpt.inLoading)	{
                    			field.changeCheck = true;
                    		}
                    	},
                        blur : function(field, eOpts) {
                        	if(field.changeCheck)	{
                        		fnDedTotI();
                        		field.changeCheck = false;
                        	}
                        }
                    }
                },

                { xtype: 'component',  html:'합계'},
                { xtype: 'uniNumberfield', value: 0, name: 'TOT_WAGES_I', suffixTpl: '원', readOnly: true},
                { xtype: 'component',  html:'비과세소득'},
                { xtype: 'uniNumberfield', value: 0, name: 'OUT_INCOME_I', suffixTpl: '원', value:0,
                    listeners: {
                        change:function(field, newValue, oldValue)	{
                    		if(newValue != oldValue && !search1.uniOpt.inLoading)	{
                    			field.changeCheck = true;
                    		}
                    	},
                        blur : function(field, eOpts) {
                        	if(field.changeCheck)	{
                        		fnSuppTotI();
                        		field.changeCheck = false;
                        	}
                        }
                    }
                },
                { xtype: 'component',  html:'연평균과세표준'},
                { xtype: 'uniNumberfield', value: 0, name: 'AVG_TAX_STD_I', suffixTpl: '원', readOnly: true},
                { xtype: 'component',  html:'환산급여별공제'},
                { xtype: 'uniNumberfield', value: 0, name: 'PAY_TOTAL_DED_I_16', suffixTpl: '원', readOnly: true},
                { xtype: 'component',  html:'지방소득세환급액'},
                { xtype: 'uniNumberfield', value: 0, name: 'DED_IN_LOCAL_ADD_I', suffixTpl: '원', value:0,
                    listeners: {
                    	change:function(field, newValue, oldValue)	{
                    		if(newValue != oldValue && !search1.uniOpt.inLoading)	{
                    			field.changeCheck = true;
                    		}
                    	},
                        blur : function(field, eOpts) {
                        	if(field.changeCheck)	{
                        		fnDedTotI();
                        		field.changeCheck = false;
                        	}
                        }
                    }
                },
                { xtype: 'component',  html:'평균임금'},
                { xtype: 'uniNumberfield', value: 0, name: 'AVG_WAGES_I', suffixTpl: '원', readOnly: true},
                { xtype: 'component',  html:'기타지급'},
                { xtype: 'uniNumberfield', value: 0, name: 'ETC_AMOUNT_I', suffixTpl: '원', value:0,
                    listeners: {
                        change:function(field, newValue, oldValue)	{
                    		if(newValue != oldValue && !search1.uniOpt.inLoading)	{
                    			field.changeCheck = true;
                    		}
                    	},
                        blur : function(field, eOpts) {
                        	if(field.changeCheck)	{
                        		fnSuppTotI();
                        		field.changeCheck = false;
                        	}
                        }
                    }
                },
                { xtype: 'component',  html:'연평균산출세액'},
                { xtype: 'uniNumberfield', value: 0, name: 'AVR_COMP_TAX_I', suffixTpl: '원', readOnly: true},
                { xtype: 'component',  html:'퇴직소득과세표준'},
                { xtype: 'uniNumberfield', value: 0, name: 'TAX_STD_I_16', suffixTpl: '원', readOnly: true},
                { xtype: 'component',  html:'기타공제1'},
                { xtype: 'uniNumberfield', value: 0, name: 'DED_ETC_I', suffixTpl: '원', value:0,
                    listeners: {
                    	change:function(field, newValue, oldValue)	{
                    		if(newValue != oldValue && !search1.uniOpt.inLoading)	{
                    			field.changeCheck = true;
                    		}
                    	},
                        blur : function(field, eOpts) {
                        	if(field.changeCheck)	{
                        		fnDedTotI();
                        		field.changeCheck = false;
                        	}
                        }
                    }
                },

                { xtype: 'component',  html:'근속일수'},
                { xtype: 'uniNumberfield', value: 0, name: 'LONG_TOT_DAY2', readOnly: true, fieldStyle: "text-align:right;"},
                { xtype: 'component',  html:'지급총액'},
                { xtype: 'uniNumberfield', value: 0, name: 'RETR_SUM_I', id: 'RETR_SUM_I', suffixTpl: '원', readOnly: true},
                { xtype: 'component',  html:'산출세액'},
                { xtype: 'uniNumberfield', value: 0, name: 'COMP_TAX_I', suffixTpl: '원', readOnly: true},
                { xtype: 'component',  html:'환산산출세액'},
                { xtype: 'uniNumberfield', value: 0, name: 'CHANGE_COMP_TAX_I_16', suffixTpl: '원', readOnly: true},
                { xtype: 'component',  html:'기타공제2'},
                { xtype: 'uniNumberfield', value: 0, name: 'DED_ETC_I2', suffixTpl: '원', value:0 ,
                    listeners: {
                    	change:function(field, newValue, oldValue)	{
                    		if(newValue != oldValue && !search1.uniOpt.inLoading)	{
                    			field.changeCheck = true;
                    		}
                    	},
                        blur : function(field, eOpts) {
                        	if(field.changeCheck)	{
                        		fnDedTotI();
                        		field.changeCheck = false;
                        	}
                        }
                    }
                },

                { xtype: 'component',  html:'퇴직급여'},
                { xtype: 'uniNumberfield', value: 0, name: 'ORI_RETR_ANNU_I', suffixTpl: '원', readOnly: true},
                { xtype: 'component',  html:'근로소득간주액'},
                { xtype: 'uniNumberfield', value: 0, name: 'OF_PAY_ANNU_I', suffixTpl: '원', readOnly: true  },
                { xtype: 'component',  colspan: 2},
                { xtype: 'component',  html:'산출세액'},
                { xtype: 'uniNumberfield', value: 0, name: 'COMP_TAX_I_161', suffixTpl: '원', readOnly: true},
                { xtype: 'component',  html:'중도정산소득세</br>(근로소득)'},
                { xtype: 'uniNumberfield', value: 0, name: 'DED_ETC_I3', suffixTpl: '원', value:0,
                    listeners: {
                    	change:function(field, newValue, oldValue)	{
                    		if(newValue != oldValue && !search1.uniOpt.inLoading)	{
                    			field.changeCheck = true;
                    		}
                    	},
                        blur : function(field, eOpts) {
                        	if(field.changeCheck)	{
                        		fnDedTotI();
                        		field.changeCheck = false;
                        	}
                        }
                    }
                },

                { xtype: 'component',  colspan: 6},
                { xtype: 'component',  html:'과세연도'},
                { xtype: 'uniTextfield', name: 'CHANGE_TAX_YEAR_16', suffixTpl: '년', readOnly: true, fieldStyle: "text-align:center;"},
                { xtype: 'component',  html:'중도정산지방소득세</br>(근로소득)'},
                { xtype: 'uniNumberfield', value: 0, name: 'DED_ETC_I4', suffixTpl: '원', value : 0,
                    listeners: {
                    	change:function(field, newValue, oldValue)	{
                    		if(newValue != oldValue && !search1.uniOpt.inLoading)	{
                    			field.changeCheck = true;
                    		}
                    	},
                        blur : function(field, eOpts) {
                        	if(field.changeCheck)	{
                        		fnDedTotI();
                        		field.changeCheck = false;
                        	}
                        }
                    }
                },

                { xtype: 'component',  colspan: 6},
                { xtype: 'component',  html:'특례적용산출세액'},
                { xtype: 'uniNumberfield', value: 0, name: 'EXEMPTION_COMP_TAX_I_16', suffixTpl: '원', readOnly: true},
                { xtype: 'component',  html:'건강보험료정산'},
                { xtype: 'uniNumberfield', value: 0, name: 'DED_ETC_I5', suffixTpl: '원', value:0 ,
                    listeners: {
                    	change:function(field, newValue, oldValue)	{
                    		if(newValue != oldValue && !search1.uniOpt.inLoading)	{
                    			field.changeCheck = true;
                    		}
                    	},
                        blur : function(field, eOpts) {
                        	if(field.changeCheck)	{
                        		fnDedTotI();
                        		field.changeCheck = false;
                        	}
                        }
                    }
                },

                { xtype: 'component',  colspan: 6},
                { xtype: 'component',  html:'기납부(기과세이연)'},
                { xtype: 'uniNumberfield', value: 0, name: 'PAY_END_TAX_16', suffixTpl: '원', readOnly: true},
                { xtype: 'uniNumberfield', value: 0, name: 'LOCAL_END_TAX', hidden:true}, // 2018 추가필드
                { xtype: 'component',  html:'장기요양보험료정산'},
                { xtype: 'uniNumberfield', value: 0, name: 'DED_ETC_I6', suffixTpl: '원', value:0 ,
                    listeners: {
                    	change:function(field, newValue, oldValue)	{
                    		if(newValue != oldValue && !search1.uniOpt.inLoading)	{
                    			field.changeCheck = true;
                    		}
                    	},
                        blur : function(field, eOpts) {
                        	if(field.changeCheck)	{
                        		fnDedTotI();
                        		field.changeCheck = false;
                        	}
                        }
                    }},

                { xtype: 'component',  colspan: 6},
                { xtype: 'component',  html:'신고대상세액'},
                { xtype: 'uniNumberfield', value: 0, name: 'CHANGE_TARGET_TAX_I_16', suffixTpl: '원', readOnly: true},
                { xtype: 'component',  html:'공제총액'},
                { xtype: 'uniNumberfield', value: 0, name: 'DED_TOTAL_I', suffixTpl: '원', readOnly: true}
            ]
	    }],
	    listeners: {
	        load: function () {
	            UniAppManager.setToolbarButtons('save', false);
	        },
	        actioncomplete: function (form, action) {
	            UniAppManager.setToolbarButtons('save', false);
	        },
	        uniOnChange: function (basicForm, field, newValue, oldValue) {
	            if (basicForm.isDirty() && newValue != oldValue) {
	                if (basicForm.getField('GLORY_AMOUNT_I').isDirty() || basicForm.getField('RETR_ANNU_I').isDirty() || basicForm.getField('GROUP_INSUR_I').isDirty() || basicForm.getField('DED_IN_TAX_ADD_I').isDirty() || basicForm.getField('OUT_INCOME_I').isDirty() || basicForm.getField('DED_IN_LOCAL_ADD_I').isDirty() || basicForm.getField('ETC_AMOUNT_I').isDirty() || basicForm.getField('DED_ETC_I').isDirty() || basicForm.getField('DED_ETC_I2').isDirty() || basicForm.getField('DED_ETC_I3').isDirty() || basicForm.getField('DED_ETC_I4').isDirty() || basicForm.getField('DED_ETC_I5').isDirty() || basicForm.getField('DED_ETC_I6').isDirty()) {
	                    UniAppManager.setToolbarButtons('save', true);
	                }
	            } else {
	                UniAppManager.setToolbarButtons('save', false);
	            }
	        }
	
	    },
	    saveForm: function () {
	        var person_numb = panelResult.getValue('PERSON_NUMB');
	        //var param = search1.getForm().getValues();
	        var param = {};
	        param.RETR_TYPE = panelResult.getValue('RETR_TYPE');
	        param.PERSON_NUMB = person_numb;
	        param.SUPP_TOTAL_I = search1.getValue('SUPP_TOTAL_I1');
	        param.DEF_TAX_I = detailForm.getValue('DEF_TAX_I');
	        param.LONG_TOT_DAY = search1.getValue('LONG_TOT_DAY1');
	        param.PAY_END_TAX = search1.getValue('PAY_END_TAX_16');
	        param.OT_KIND = panelResult.getValue('OT_KIND').OT_KIND;
	        
			var fields = search1.getForm().getFields();
			
			Ext.each(fields.items, function(field, idx){
				if(field.xtype=='uniNumberfield')	{
					if(Ext.isEmpty(field.getValue()))	{
						field.setValue(0);
					}
				}
			});
			
	        search1.getForm().submit({
	            params: param,
	            success: function (actionform, action) {
	                search1.getForm().wasDirty = false;
	                search1.resetDirtyStatus();
	                UniAppManager.setToolbarButtons('save', false);
	                UniAppManager.updateStatus(Msg.sMB011); // "저장되었습니다.
	            }
	        });
	        // 첫번째 탭에서는 저장 여부를 확인함
	        tab01Saved = true;
	    },
	    loadData: function () {
	        setPanelReadOnly(true);
	        UniAppManager.setToolbarButtons('reset', true);
	        UniAppManager.setToolbarButtons('delete', true);
	        // tab01 form load
	        var param = Ext.getCmp('panelResultForm').getValues();
	        param.SUPP_DATE = UniDate.getDbDateStr(search1.getValue('SUPP_DATE'));
	        param.EXEP_MONTHS_AF13 = search1.getValue('EXEP_MONTHS_AF13');
	        param.R_EXEP_DAY_AF13 = search1.getValue('R_EXEP_DAY_AF13');
	        param.EXEP_MONTHS_BE13 = search1.getValue('EXEP_MONTHS_BE13');
	        param.R_EXEP_DAY_BE13 = search1.getValue('R_EXEP_DAY_BE13');
	        param.RELOAD = 'N';
	        search1.uniOpt.inLoading = true;
	        this.getForm().load({
	            params: param,
	            success: function (form, action) {
	
	                console.log(action);
	                formLoad = true;
	                UniAppManager.setToolbarButtons('delete', true);
	                if (panelResult.getValue('OT_KIND').OT_KIND == 'OF') {
	                    tab.down('#hrt506ukrTab03').setDisabled(false);
	                } else {
	
	                    tab.down('#hrt506ukrTab03').setDisabled(true);
	                }
	
	                // 특정필드를 입력 가능하게 변경
	                search1.getForm().getFields().each(function (field) {
	                    if (field.name == 'RETR_ANNU_I' || field.name == 'GLORY_AMOUNT_I' || field.name == 'GROUP_INSUR_I' || 
	                    	field.name == 'OUT_INCOME_I' || field.name == 'ETC_AMOUNT_I' || field.name == 'DED_IN_TAX_ADD_I' || 
	                    	field.name == 'DED_IN_LOCAL_ADD_I' || field.name == 'DED_ETC_I' || field.name == 'DED_ETC_I2' || 
	                    	field.name == 'DED_ETC_I3' || field.name == 'DED_ETC_I4' || field.name == 'DED_ETC_I5' || 
	                    	field.name == 'DED_ETC_I6' || /*|| field.name == 'RETR_RESN'*/ 
	                    	field.name == 'EXEP_MONTHS_AF13' || field.name == 'R_EXEP_DAY_AF13' ||  
                    		field.name == 'EXEP_MONTHS_BE13' || field.name == 'R_EXEP_DAY_BE13') {
	                        field.setReadOnly(false);
	                    } else {
	                        field.setReadOnly(true);
	                    }
	                });
	
	                //console.log("data :: " + action.result.data.LONG_TOT_DAY);
	                console.log("data :: " + action.result.data.SUPP_TOTAL_I);
	                search1.setValues({
	                    PAY_END_TAX_16: action.result.data.PAY_END_TAX,
	                    LONG_TOT_DAY1: action.result.data.LONG_TOT_DAY,
	                    LONG_TOT_DAY2: action.result.data.LONG_TOT_DAY,
	                    SUPP_TOTAL_I1: action.result.data.SUPP_TOTAL_I,
	                    SUPP_TOTAL_I2: action.result.data.SUPP_TOTAL_I,
	                    COMP_TAX_I_161: action.result.data.COMP_TAX_I_16
	                });
	
	                //하단 폼에 데이터를 입력
	                detailForm.getForm().setValues(action.result.data);
	                detailForm.setValue('COMP_TAX_I_16', action.result.data.DEF_TAX_I);
	                var RETR_SUM_I2 = action.result.data.RETR_ANNU_I + action.result.data.GLORY_AMOUNT_I +
	                    action.result.data.GROUP_INSUR_I + action.result.data.ETC_AMOUNT_I;
	                detailForm.setValue('RETR_SUM_I2', RETR_SUM_I2);
	                detailForm.setValue('RETR_SUM_I3', action.result.data.RETR_SUM_I);
	
	                var PAY_END_TAX = action.result.data.PAY_END_TAX + action.result.data.LOCAL_END_TAX
	                detailForm.setValue('PAY_END_TAX', PAY_END_TAX);
					detailForm.setValue('SUPP_TOTAL_I2', action.result.data.SUPP_TOTAL_I);
					detailForm.setValue('DED_TOTAL_I2', action.result.data.BAL_DED_TOTAL_I);
					detailForm.setValue('OF_PAY_ANNU_I', action.result.data.OF_PAY_ANNU_I);
					
	                var GWBtn = panelResult.down('#GWBtn');
	                GWBtn.setDisabled(false);
	                UniAppManager.setToolbarButtons('save', false);
	                setTabDisable(false);
	                search1.uniOpt.inLoading = false;
	                
	            },
	            failure: function (form, action) {
	                console.log(action);
	                formLoad = false;
	                setTabDisable(true);
	                var GWBtn = panelResult.down('#GWBtn');
	                GWBtn.setDisabled(true);
	                search1.uniOpt.inLoading = false;
	            }
	        });
	    }
	});
	
	var search2 = Unilite.createSearchForm('search2',{
        autoScroll: true,
        border: false,
        padding: '5 7 0 7',
        xtype: 'container',
         flex: 1,
        api: {
            load: 'hrt506ukrService.selectFormData02'
        },
        trackResetOnLoad: true,
        layout:{type:'vbox', align:'stretch', defaultMargins: '0 0 5 0'},
        items: [{
            xtype: 'container',
            margin: '10 0 0 0',
            layout: {
                type: 'table',
                columns:6,
                tableAttrs: {style: 'border : 1px solid #ced9e7;', width: '100%'},
                tdAttrs: {style: 'border : 1px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif;', align : 'center'}
            },
            defaults:{width: '98.5%', margin: '2 2 2 2'},
            items: [
                { xtype: 'component',  html:'2015.12.31 이전 계산 내역', colspan: 6, tdAttrs: {height: 29}},

                { xtype: 'component',  html:'과세내역', colspan: 2, tdAttrs: {height: 29}},
                { xtype: 'component',  html:'법정퇴직'},
                { xtype: 'component',  html:'산출산식', colspan: 3 },

                { xtype: 'component',  html:'퇴직급여액', colspan: 2},
                { xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'A'},
                { xtype: 'component',  html:'퇴직급여액 과세소득', colspan: 3, style: 'text-align:left'},

                { xtype: 'component',  html:'퇴직소득공제', rowspan: 6, tdAttrs: {style: 'border : 1px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif; width: 15%', align : 'center'}},
                { xtype: 'component',  html:'소득공제(ⓐ)', tdAttrs: {style: 'border : 1px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif; width: 15%', align : 'center'}},
                { xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'B', tdAttrs: {style: 'border : 1px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif; width: 15%', align : 'center'}},
                { xtype: 'component',  html:'2011년 귀속부터 퇴직급여액의 40%', colspan: 3, style: 'text-align:left'},

                { xtype: 'component',  html:'근속연수별공제(ⓑ)', rowspan: 4},
                { xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'C'},
                { xtype: 'component',  html:'&nbsp;&nbsp;5년이하', style: 'text-align:left', tdAttrs: {style: 'border : 1px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif; width: 10%', align : 'center'}},
                { xtype: 'component',  html:'&nbsp;&nbsp;30만 * 근속연수', colspan: 2, style: 'text-align:left', tdAttrs: {style: 'border : 1px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif; width: 30%', align : 'center'}},

                { xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'D'},
                { xtype: 'component',  html:'&nbsp;&nbsp;10년이하', style: 'text-align:left'},
                { xtype: 'component',  html:'&nbsp;&nbsp;150만 + {50만 * (근속연수 - 5)}', colspan: 2, style: 'text-align:left'},

                { xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'E'},
                { xtype: 'component',  html:'&nbsp;&nbsp;20년이하', style: 'text-align:left'},
                { xtype: 'component',  html:'&nbsp;&nbsp;400만 + {80만 * (근속연수 - 10)}', colspan: 2, style: 'text-align:left'},

                { xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'F'},
                { xtype: 'component',  html:'&nbsp;&nbsp;20년초과', style: 'text-align:left'},
                { xtype: 'component',  html:'&nbsp;&nbsp;1,200만 + {120만 * (근속연수 - 20)}', colspan: 2, style: 'text-align:left'},

                { xtype: 'component',  html:'계 ((ⓐ) + (ⓑ))'},
                { xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'G'},
                { xtype: 'component',  html:'소득공제(ⓐ) + 근속연수별공제(ⓑ)', colspan: 3, style: 'text-align:left'},

                { xtype: 'component',  html:'과세표준', colspan: 2},
                { xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'H'},
                { xtype: 'component',  html:'퇴직급여액 - 퇴직소득공제', colspan: 3, style: 'text-align:left'},

                { xtype: 'component',  html:'연평균과세표준', colspan: 2},
                { xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'I'},
                { xtype: 'component',  html:'과세표준 / 세법상근속연수', colspan: 3, style: 'text-align:left'},

                { xtype: 'component',  html:'연평균산출세액', rowspan: 5},
                { xtype: 'component',  html:'1천 2백만원 이하'},
                { xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'J'},
                { xtype: 'component',  html:'6%', colspan: 3, style: 'text-align:left'},

                { xtype: 'component',  html:'4천 6백만원 이하'},
                { xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'K'},
                { xtype: 'component',  html:'72만 + {(연평균과세표준 - 1,200만) * 15%}', colspan: 3, style: 'text-align:left'},

                { xtype: 'component',  html:'8천 6백만원 이하'},
                { xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'L'},
                { xtype: 'component',  html:'582만 + {(연평균과세표준 - 4,600만) * 24%}', colspan: 3, style: 'text-align:left'},

                { xtype: 'component',  html:'3억 이하'},
                { xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'M'},
                { xtype: 'component',  html:'1,590만 + {(연평균과세표준 - 8,800만) * 35%}', colspan: 3, style: 'text-align:left'},

                { xtype: 'component',  html:'3억 초과'},
                { xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'N'},
                { xtype: 'component',  html:'9,010만 + {(연평균과세표준 - 3억) * 38%}', colspan: 3, style: 'text-align:left'},

                { xtype: 'component',  html:'산출세액', colspan: 2},
                { xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'O'},
                { xtype: 'component',  html:'연평균산출세액 * 세법상근속연수', colspan: 3, style: 'text-align:left'},


                { xtype: 'component',  html:'2016.01.01 이후 계산 내역 == 퇴직급여액, 근속연수별공제 금액은 2015.12.31 이전 계산내역 참조', colspan: 6, tdAttrs: {height: 29}},

                { xtype: 'component',  html:'환산급여', colspan: 2},
                { xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'P'},
                { xtype: 'component',  html:'((정산퇴직소득 - 근속연수공제) / 정산근속연수) * 12배', colspan: 3, style: 'text-align:left'},

                { xtype: 'component',  html:'환산급여별공제', colspan: 2},
                { xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'Q'},
                { xtype: 'component',  html:'환산급여별공제 프로그램에서 내용 확인 : 기준금액 + ((환산급여 - 기준금액) * 세율)', colspan: 3, style: 'text-align:left'},

                { xtype: 'component',  html:'퇴직소득과세표준', colspan: 2},
                { xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'R'},
                { xtype: 'component',  html:'환산급여 - 환산급여별공제', colspan: 3, style: 'text-align:left'},

                { xtype: 'component',  html:'환산산출세액', colspan: 2},
                { xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'S'},
                { xtype: 'component',  html:'퇴직소득과세표준 * 종합소득세율', colspan: 3, style: 'text-align:left'},

                { xtype: 'component',  html:'산출세액', colspan: 2},
                { xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'T'},
                { xtype: 'component',  html:'(환산산출세액 / 12배) * 정산근속연수', colspan: 3, style: 'text-align:left'},

                { xtype: 'component',  html:'특례적용산출세액', colspan: 2},
                { xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'V'},
                { xtype: 'component',  html:'(2015.12.31 이전의 산출세액 * 80%) + (2016.01.01 이후 산출세액 * 20%)', colspan: 3, style: 'text-align:left'},

                { xtype: 'component',  html:'신고대상액', colspan: 2},
                { xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'W'},
                { xtype: 'component',  html:'특례적용산출세액 - 기납부(또는 기과세이연) 세액 == 소득세', colspan: 3, style: 'text-align:left'}
            ]
        }],
        loadData:function()	{
        	this.getForm().load({
                params: Ext.getCmp('panelResultForm').getValues(),
                success: function (form, action) {
                    console.log(action);
                },
                failure: function (form, action) {
                    console.log(action);
                }
            });
        }
	})
    
    var detailForm = Unilite.createSimpleForm('detailForm', {
        region: 'south',
        xtype: 'container',
        layout: {
            type: 'uniTable',
            columns: 8
        },
        items: [{
            xtype: 'container',
            html: '<b>■ 퇴직금 산출액 및 산출 세액</b>',
            tdAttrs: {
                style: 'border : 0px solid #ced9e7; font: normal 13px "굴림",Gulim,tahoma, arial, verdana, sans-serif;',
                align: 'left'
            },
            colspan: 8,
            margin: '30 0 0 6'
        }, {
            xtype: 'container',
            margin: '5 0 0 0',
            padding: '5 7 20 7',
            layout: {
                type: 'table',
                columns: 6,
                tableAttrs: {
                    style: 'border : 1px solid #ced9e7;',
                    width: '100%'
                },
                tdAttrs: {
                    style: 'border : 1px solid #ced9e7; font: normal 12px "굴림",Gulim,tahoma, arial, verdana, sans-serif; width: 10%;',
                    align: 'center'
                }
            },
            defaults: {
                width: '98.5%',
                margin: '2 2 2 2'
            },
            items: [
            	{ xtype: 'component', html:'지급총액(과세대상)(A)', rowspan: 2},
                { xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, rowspan: 2, name: 'RETR_SUM_I2'},
                { xtype: 'component', html:'중간정산(과세대상)(B)'},
                { xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true				, name: 'M_TAX_TOTAL_I'},
                { xtype: 'component', html:'과세대상 퇴직급여</br>(A) + (B) - (C)', rowspan: 2},
                { xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, rowspan: 2, name: 'SUPP_TOTAL_I2'},


                { xtype: 'component', html:'근로소득간주액(C)'},
                { xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true				, name: 'OF_PAY_ANNU_I'},


                { xtype: 'component', html:'산출세액'},
                //{ xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true, name: 'COMP_TAX_I'},
                { xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true				, name: 'COMP_TAX_I_16'},
                { xtype: 'component', html:'기납부세액(지방소득세포함)ⓑ'},
                { xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true				, name: 'PAY_END_TAX'},
                { xtype: 'component', html:'결정세액'},
                { xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true				, name: 'DEF_TAX_I'},


                { xtype: 'component', html:'지급총액ⓐ'},
                { xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true				, name: 'RETR_SUM_I3'},
                { xtype: 'component', html:'공제총액ⓒ'},
                { xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true				, name: 'DED_TOTAL_I2'},
                { xtype: 'component', html:'실지급액{ⓐ-(ⓒ-ⓑ)}'},
                { xtype: 'uniNumberfield', value:'0', suffixTpl: '원', readOnly:true				, name: 'REAL_AMOUNT_I'}
            ]
        }]
    });
	
    /**
     * Master Grid1 정의(Grid Panel)
     * @type
     */
    //산정내역 tab - 급여내역 그리드
    var masterGrid1 = Unilite.createGrid('hrt506ukrGrid1', {
        title: '급여내역',
        layout: 'fit',
        store: directMasterStore1,
        uniOpt: {
            expandLastColumn: false,
            useRowNumberer: false,
            useMultipleSorting: false,
            state: {
                useState: false,
                useStateList: false
            }
        },
        features: [{
            id: 'masterGridSubTotal1',
            ftype: 'uniGroupingsummary',
            showSummaryRow: true
        }, {
            id: 'masterGridTotal1',
            ftype: 'uniSummary',
            showSummaryRow: true
        }],
        flex: 1,
        columns: [
    		 { dataIndex:'RETR_DATE'    , hidden: true }
            ,{ dataIndex:'RETR_TYPE'    , hidden: true }
            ,{ dataIndex:'PERSON_NUMB'    , hidden: true }
            ,{ dataIndex:'PAY_YYYYMM'    , width: 100, summaryType: 'totaltext',
                summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
                    return Unilite.renderSummaryRow(summaryData, metaData, '소계', '합계');
            }}
            ,{ dataIndex:'WAGES_CODE'    , hidden: true }
            ,{ dataIndex:'WAGES_NAME'    , width: 130}
            ,{ dataIndex:'AMOUNT_I'        , minWidth: 120, flex: 1, summaryType: 'sum'}
            ,{ dataIndex:'PAY_STRT_DATE', hidden: true }
            ,{ dataIndex:'PAY_LAST_DATE', hidden: true }
            ,{ dataIndex:'WAGES_DAY'    , hidden: true }
        ],
        listeners: {
            containerclick: function () {
                UniAppManager.setToolbarButtons('delete', false);
                UniAppManager.setToolbarButtons('newData', false);

            },
            select: function () {
                UniAppManager.setToolbarButtons('delete', false);
                UniAppManager.setToolbarButtons('newData', false);
            },
            cellclick: function () {
                UniAppManager.setToolbarButtons('delete', false);
                UniAppManager.setToolbarButtons('newData', false);
            },
            render: function (grid) {
                var toolbar = grid._getToolBar();
                if (toolbar && toolbar.length > 0) {
                    var summaryIcon = toolbar[0].down('#toggleSummaryBtn');
                    summaryIcon.hide();
                }
            }

        }
    });

    //산정내역 tab - 기타수당내역 그리드
    var masterGrid2 = Unilite.createGrid('hrt506ukrGrid2', {
        // for tab
        title: '기타수당내역',
        layout: 'fit',
        store: directMasterStore2,
        uniOpt: {
            expandLastColumn: false,
            useRowNumberer: false,
            useMultipleSorting: false,
            state: {
                useState: false,
                useStateList: false
            }
        },
        features: [{
            id: 'masterGridSubTotal2',
            ftype: 'uniGroupingsummary',
            showSummaryRow: true
        }, {
            id: 'masterGridTotal2',
            ftype: 'uniSummary',
            showSummaryRow: true
        }],
        flex: 1,
        columns: [
        	{ dataIndex:'RETR_DATE'    , hidden: true }
            ,{ dataIndex:'RETR_TYPE'    , hidden: true }
            ,{ dataIndex:'PERSON_NUMB'    , hidden: true }
            ,{ dataIndex:'PAY_YYYYMM'    , width: 100, summaryType: 'totaltext',
                summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
                    return Unilite.renderSummaryRow(summaryData, metaData, '소계', '합계');
            }}
            ,{ dataIndex:'WEL_CODE'        , hidden: true }
            ,{ dataIndex:'WEL_NAME'        , width: 130}
            ,{ dataIndex:'GIVE_I'        , minWidth: 120, flex: 1, summaryType: 'sum'}
            ,{ dataIndex:'WEL_LEVEL1'    , hidden: true }
            ,{ dataIndex:'WEL_LEVEL2'    , hidden: true }
            ,{ dataIndex:'APPLY_YYMM'    , hidden: true }
            ,{ dataIndex:'PAY_STRT_DATE', hidden: true }
            ,{ dataIndex:'PAY_LAST_DATE', hidden: true }
            ,{ dataIndex:'WAGES_DAY'    , hidden: true }
        ],
        listeners: {
            containerclick: function () {
                UniAppManager.setToolbarButtons('delete', false);
                UniAppManager.setToolbarButtons('newData', false);

            },
            select: function () {
                UniAppManager.setToolbarButtons('delete', false);
                UniAppManager.setToolbarButtons('newData', false);
            },
            cellclick: function () {
                UniAppManager.setToolbarButtons('delete', false);
                UniAppManager.setToolbarButtons('newData', false);
            }

        }
    });

    //산정내역 tab - 상여내역 그리드
    var masterGrid3 = Unilite.createGrid('hrt506ukrGrid3', {
        // for tab
        title: '상여내역',
        layout: 'fit',
        store: directMasterStore3,
        uniOpt: {
            expandLastColumn: false,
            useRowNumberer: false,
            useMultipleSorting: false,
            state: {
                useState: false,
                useStateList: false
            }
        },
        features: [{
            id: 'masterGridSubTotal3',
            ftype: 'uniGroupingsummary',
            showSummaryRow: true
        }, {
            id: 'masterGridTotal3',
            ftype: 'uniSummary',
            showSummaryRow: true
        }],
        flex: 1,
        columns: [
        	 { dataIndex:'RETR_DATE'    , hidden: true }
            ,{ dataIndex:'RETR_TYPE'    , hidden: true }
            ,{ dataIndex:'PERSON_NUMB'    , hidden: true }
            ,{ dataIndex:'BONUS_YYYYMM'    , summaryType: 'totaltext', width: 100,
                summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
                    return Unilite.renderSummaryRow(summaryData, metaData, '소계', '합계');
            }}
            ,{ dataIndex:'BONUS_TYPE'    , hidden: true }
            ,{ dataIndex:'BONUS_NAME'    , width: 130}
            ,{ dataIndex:'BONUS_I'        , minWidth: 120, flex: 1, summaryType: 'sum'}
            ,{ dataIndex:'BONUS_RATE'    , hidden: true }
        ],
        listeners: {
            containerclick: function () {
                UniAppManager.setToolbarButtons('delete', false);
                UniAppManager.setToolbarButtons('newData', false);

            },
            select: function () {
                UniAppManager.setToolbarButtons('delete', false);
                UniAppManager.setToolbarButtons('newData', false);
            },
            cellclick: function () {
                UniAppManager.setToolbarButtons('delete', false);
                UniAppManager.setToolbarButtons('newData', false);
            }

        }
    });

    //산정내역 tab - 년월차내역 그리드
    var masterGrid4 = Unilite.createGrid('hrt506ukrGrid4', {
        // for tab
        title: '년월차내역',
        layout: 'fit',
        store: directMasterStore4,
        uniOpt: {
            expandLastColumn: false,
            useRowNumberer: false,
            useMultipleSorting: false,
            state: {
                useState: false,
                useStateList: false
            }
        },
        features: [{
            id: 'masterGridSubTotal4',
            ftype: 'uniGroupingsummary',
            showSummaryRow: true
        }, {
            id: 'masterGridTotal4',
            ftype: 'uniSummary',
            showSummaryRow: true
        }],
        flex: 1,
        columns: [  
        	{ dataIndex:'RETR_DATE'    , hidden: true }
            ,{ dataIndex:'RETR_TYPE'    , hidden: true }
            ,{ dataIndex:'PERSON_NUMB'    , hidden: true }
            ,{ dataIndex:'BONUS_YYYYMM'    , summaryType: 'totaltext', width: 100,
                summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
                    return Unilite.renderSummaryRow(summaryData, metaData, '소계', '합계');
            }}
            ,{ dataIndex:'BONUS_TYPE'    , width: 130 }
            //,{ dataIndex:'BONUS_NAME'    , width: 130}
            ,{ dataIndex:'BONUS_RATE'    , hidden: true}
            ,{ dataIndex:'BONUS_I'        , minWidth: 120, flex: 1, summaryType: 'sum'}
            ,{ dataIndex:'SUPP_DATE'    , hidden: true }
            ,{ dataIndex:'BONUS_RATE'    , hidden: true }
        ],
        listeners: {
            containerclick: function () {
                UniAppManager.setToolbarButtons('delete', true);
                UniAppManager.setToolbarButtons('newData', true);
                //setButtonState(true);
            },
            select: function () {
                //setButtonState(true);
            },
            cellclick: function () {
                //setButtonState(true);
            },
            beforeedit: function (editor, e) {
                //update시 금액만 수정이 가능하도록함
                if (!e.record.phantom && !e.field == 'BONUS_I') {
                    return false;
                }
            },
            edit: function (editor, e) {
                var fieldName = e.field;
                var num_check = /[0-9]/;
                if (fieldName == 'BONUS_I') {
                    if (!num_check.test(e.value)) {
                        Ext.Msg.alert('확인', '숫자형식이 잘못되었습니다.');
                        e.record.set(fieldName, e.originalValue);
                        return false;
                    }
                }
            },
            render: function (grid, eOpts) {
                grid.getEl().on('click', function (e, t, eOpt) {
                    activeGrid = grid.getItemId();
                });
            }
        }
    });

    var masterGrid5 = Unilite.createGrid('hrt506ukrGrid5', {
        // for tab
        layout: 'fit',
        store: directMasterStore5,
        uniOpt: {
            expandLastColumn: false,
            useRowNumberer: false,
            useMultipleSorting: false,
            state: {
                useState: false,
                useStateList: false
            }
        },
        flex: 1,
        columns: [  
        	 { dataIndex:'SEQ'    , hidden: true }
            ,{ dataIndex:'DIVI_CODE'    , flex: 1,
                editor: {
                    xtype: 'combobox',
                    store: comboStore,
                    lazyRender: true,
                    displayField : 'text',
                    valueField : 'value'
                },
                renderer: function(value) {
                    var record = comboStore.findRecord('value', value);
                    if (record == null || record == undefined ) {
                        return '';
                    } else {
                        return record.data.text;
                    }
                }
             }
            ,{ dataIndex:'DIVI_NAME'    , hidden: true }
            ,{ dataIndex:'DATA_TYPE'    , hidden: true}
            ,{ dataIndex:'CONTENT'        , flex: 1 ,
	             renderer:function(value, metaData, record, rowIndex ,colIndex ,store ,view  ) {
	             		if(record.get("DATA_TYPE") == 'D')	{
	             			return '<div style="text-align:center;">'+UniDate.safeFormat(value)+"</div>";
	             		} else if(record.get("DATA_TYPE") == 'N')	{
	             			return '<div style="text-align:right;">'+Ext.util.Format.number(value,'0,000')+"</div>";
	             		} else {
	             			return value;
	             		}
 	            }
            }
            ,{ dataIndex:'REMARK'    , flex: 6,
                editor: {
                    xtype: 'combobox',
                    store: comboStore,
                    lazyRender: true,
                    displayField : 'remark',
                    valueField : 'value'
                },
                renderer: function(value) {
                    var record = comboStore.findRecord('value', value);
                    if (record == null || record == undefined ) {
                        return '';
                    } else {
                        return record.data.remark;
                    }
                }
             }
        ],
        listeners: {
            containerclick: function () {
                UniAppManager.setToolbarButtons('delete', false);
                UniAppManager.setToolbarButtons('newData', false);

            },
            select: function () {
                UniAppManager.setToolbarButtons('delete', false);
                UniAppManager.setToolbarButtons('newData', false);
            },
            cellclick: function () {
                UniAppManager.setToolbarButtons('delete', false);
                UniAppManager.setToolbarButtons('newData', false);
            }

        }
    });

    var masterGrid6 = Unilite.createGrid('hrt506ukrGrid6', {
        // for tab
        layout: 'fit',
        store: directMasterStore6,
        uniOpt: {
            expandLastColumn: false,
            useRowNumberer: false,
            useMultipleSorting: false,
            state: {
                useState: false,
                useStateList: false
            }
        },
        features: [{
            id: 'masterGridTotal6',
            ftype: 'uniSummary',
            showSummaryRow: false
        }],
        flex: 1,
        columns: [  
        	{ dataIndex:'SUPP_DATE'    , summaryType: 'totaltext' , width: 110, align: 'center'}
            ,{ dataIndex:'RETR_DATE_FR'    , width: 150, align: 'center'}
            ,{ dataIndex:'RETR_DATE_TO'    , width: 150, align: 'center'}
            ,{ dataIndex:'RETR_ANNU_I'    , width: 120, summaryType: 'sum'}
            ,{ dataIndex:'IN_TAX_I'        , width: 120, summaryType: 'sum'}
            ,{ dataIndex:'LOCAL_TAX_I'    , width: 120, summaryType: 'sum'}
            ,{ dataIndex:'BALANCE_I'    , width: 120, summaryType: 'sum'}
            ,{ dataIndex:'REMARK'        , minWidth: 300, flex: 1}
        ],
        listeners: {
            containerclick: function () {
                UniAppManager.setToolbarButtons('delete', false);
                UniAppManager.setToolbarButtons('newData', false);

            },
            select: function () {
                UniAppManager.setToolbarButtons('delete', false);
                UniAppManager.setToolbarButtons('newData', false);
            },
            cellclick: function () {
                UniAppManager.setToolbarButtons('delete', false);
                UniAppManager.setToolbarButtons('newData', false);
            }

        }
    });

    var tab = Unilite.createTabPanel('tabPanel', {
        region: 'center',
        activeTab: 0,
        id: 'tab',
        items: [{
            title: '정산내역',
            id: 'hrt506ukrTab01',
            autoScroll: true,
            layout: {
                type: 'vbox',
                align: 'stretch'
            },
            items: [search1]
        }, {
            title: '산정내역',
            id: 'hrt506ukrTab02',
            xtype: 'container',
            layout: {
                type: 'hbox',
                align: 'stretch'
            },
            items: [masterGrid1, masterGrid2, masterGrid3, masterGrid4]
        }, {
            title: '산정내역(임원)',
            id: 'hrt506ukrTab03',
            xtype: 'container',
            layout: {
                type: 'vbox',
                align: 'stretch'
            },
            items: [masterGrid5]
        }, {
            title: '소득세계산내역',
            id: 'hrt506ukrTab04'
                //                 ,xtype:'container'
                ,
            autoScroll: true,
            layout: {
                type: 'vbox',
                align: 'stretch'
            },
            items: [search2]
        }, {
            title: '중간정산내역',
            id: 'hrt506ukrTab05',
            xtype: 'container',
            layout: {
                type: 'vbox',
                align: 'stretch'
            },
            items: [masterGrid6]
        }],
        listeners: {
            beforetabchange: function (grouptabPanel, newCard, oldCard, eOpts) {
                //                if(Ext.isObject(oldCard)){
                if (!UniAppManager.app.isValidSearchForm()) {
                    return false;
                }

                if (UniAppManager.app._needSave()) {
                    Ext.Msg.confirm('확인', Msg.sMB017 + '\n' + Msg.sMB061, function (btn) {
                        if (btn == 'yes') {
                            search1.saveForm();
                            UniAppManager.app.loadTabData(newCard, newCard.getItemId());
                        } else {
                            Ext.Msg.alert("경고", "저장을 하셔야 합니다.");
                            return false;
                        }
                    });
                }
                //                    var activeTabId = tab.getActiveTab().getId();
                if (newCard.getId() == 'hrt506ukrTab01') {
                    if (search1.isValid()) {

                        search1.loadData()
                    } else {
                        // invalid message
                        var invalid = search1.getForm().getFields().filterBy(function (field) {
                            return !field.validate();
                        });
                        if (invalid.length > 0) {
                            r = false;
                            var labelText = ''

                            if (Ext.isDefined(invalid.items[0]['fieldLabel'])) {
                                var labelText = invalid.items[0]['fieldLabel'] + '은(는)';
                            } else if (Ext.isDefined(invalid.items[0].ownerCt)) {
                                var labelText = invalid.items[0].ownerCt['fieldLabel'] + '은(는)';
                            }
                            Ext.Msg.alert('확인', labelText + Msg.sMB083);
                            invalid.items[0].focus();
                        }
                    }
                } else {
                    setPanelReadOnly(true);
                    if (newCard.getId() == 'hrt506ukrTab02') {
                        masterGrid1.getStore().loadStoreRecords();
                        masterGrid2.getStore().loadStoreRecords();
                        masterGrid3.getStore().loadStoreRecords();
                        masterGrid4.getStore().loadStoreRecords();

                        var view1 = masterGrid1.getView();
                        var view2 = masterGrid2.getView();
                        var view3 = masterGrid3.getView();
                        var view4 = masterGrid4.getView();
                        view1.getFeature('masterGridSubTotal1').toggleSummaryRow(true);
                        view1.getFeature('masterGridTotal1').toggleSummaryRow(true);
                        view2.getFeature('masterGridSubTotal2').toggleSummaryRow(true);
                        view2.getFeature('masterGridTotal2').toggleSummaryRow(true);
                        view3.getFeature('masterGridSubTotal3').toggleSummaryRow(true);
                        view3.getFeature('masterGridTotal3').toggleSummaryRow(true);
                        view4.getFeature('masterGridSubTotal4').toggleSummaryRow(true);
                        view4.getFeature('masterGridTotal4').toggleSummaryRow(true);

                    } else if (newCard.getId() == 'hrt506ukrTab03') {
                        masterGrid5.getStore().loadStoreRecords();
                    } else if (newCard.getId() == 'hrt506ukrTab04') {
                        search2.loadData();
                    } else {
                        masterGrid6.getStore().loadStoreRecords();
                    }
                }
            }
        }
    });

    Unilite.Main({
        borderItems: [{
            region: 'center',
            layout: 'border',
            border: false,
            items: [
                panelResult, tab, detailForm
            ]
        }],
        id: 'hrt506ukrApp',
        fnInitBinding: function (params) {
            panelResult.setValue('RETR_TYPE', 'M');
            panelResult.setValue('RETR_DATE', UniDate.get('today'));
            var GWBtn = panelResult.down('#GWBtn');
            GWBtn.setDisabled(true);
            setTabDisable(true);
            var hrt507Btn = panelResult.down('#hrt507btn');
            hrt507Btn.setDisabled(true);
            var hrt507btn1 = panelResult.down('#hrt507btn1');
            hrt507btn1.setDisabled(true);
            //             UniAppManager.setToolbarButtons('detail',true);
            tab.down('#hrt506ukrTab03').setDisabled(true);
            
            UniAppManager.setToolbarButtons('save', false);

            //초기필드만 활성화
            search1.getForm().getFields().each(function (field) {
            	// JOIN_DATE RETR_DATE YYYYMMDD LONG_TOT_DAY1 ADD_MONTH LONG_TOT_MONTH LONG_YEARS CHANGE_TAX_YEAR_16
                /*if (field.name == 'JOIN_DATE' || field.name == 'RETR_DATE' || || field.name == 'YYYYMMDD' || field.name == 'LONG_TOT_DAY1' || 
                    field.name == 'ADD_MONTH' || field.name == 'LONG_TOT_MONTH' || field.name == 'LONG_YEARS' || 
                    field.name == 'CHANGE_TAX_YEAR_16') {*/
				if (field.name == 'SUPP_DATE' ||  field.name == 'RETR_RESN' ) {
                    field.setReadOnly(false);
                    field.setValue('');
                } else {
					if (field.name == 'JOIN_DATE' || field.name == 'RETR_DATE' ||  field.name == 'YYYYMMDD' || field.name == 'LONG_TOT_DAY1' || 
                    	field.name == 'ADD_MONTH' || field.name == 'LONG_TOT_MONTH' || field.name == 'LONG_YEARS' || 
                    	field.name == 'CHANGE_TAX_YEAR_16'
                    ){
                    	 field.setReadOnly(true);
                    	 field.setValue('');
                    } else if(field.name == 'EXEP_MONTHS_AF13' || field.name == 'R_EXEP_DAY_AF13' ||  
                    		  field.name == 'EXEP_MONTHS_BE13' || field.name == 'R_EXEP_DAY_BE13'
                    ) {
 						field.setReadOnly(false);
	                    field.setValue('0');

                    } else {
	                    field.setReadOnly(true);
	                    field.setValue('0');
                    }
                }

                //Ext.getCmp('LONG_TOT_DAY2').setReadOnly(true);
                //Ext.getCmp('LONG_TOT_DAY2').setValue('0');

                search1.setValue('LONG_YEARS', 0);  //근속연수
                search1.setValue('RETR_RESN', '6'); // 퇴직사유
            });
            if (!Ext.isEmpty(params)) {
                if (params.appId == 'hrt700skrApp') {
                    this.processParams(params);
                }
            }

        },
        onQueryButtonDown: function () {
            var activeTabId = tab.getActiveTab().getId();
            if (panelResult.isValid()) {
                if (activeTabId == 'hrt506ukrTab01') {
                    if (search1.isValid()) {

                        search1.loadData();
                    } else {
                        // invalid message
                        var invalid = search1.getForm().getFields().filterBy(function (field) {
                            return !field.validate();
                        });
                        if (invalid.length > 0) {
                            r = false;
                            var labelText = ''

                            if (Ext.isDefined(invalid.items[0]['fieldLabel'])) {
                                var labelText = invalid.items[0]['fieldLabel'] + '은(는)';
                            } else if (Ext.isDefined(invalid.items[0].ownerCt)) {
                                var labelText = invalid.items[0].ownerCt['fieldLabel'] + '은(는)';
                            }
                            Ext.Msg.alert('확인', labelText + Msg.sMB083);
                            invalid.items[0].focus();
                        }
                    }
                } else {
                    setPanelReadOnly(true);
                    if (activeTabId == 'hrt506ukrTab02') {
                        setTabDisable(false);
                        masterGrid1.getStore().loadStoreRecords();
                        masterGrid2.getStore().loadStoreRecords();
                        masterGrid3.getStore().loadStoreRecords();
                        masterGrid4.getStore().loadStoreRecords();

                    } else if (activeTabId == 'hrt506ukrTab03') {
                        setTabDisable(false);
                        masterGrid5.getStore().loadStoreRecords();
                    } else if (activeTabId == 'hrt506ukrTab04') {
                        setTabDisable(false);
                        search2.loadData();
                    } else {
                        setTabDisable(false);
                        masterGrid6.getStore().loadStoreRecords();
                    }
                }
            } else {
                var invalid = panelResult.getForm().getFields().filterBy(function (field) {
                    return !field.validate();
                });
                if (invalid.length > 0) {
                    r = false;
                    var labelText = ''

                    if (Ext.isDefined(invalid.items[0]['fieldLabel'])) {
                        var labelText = invalid.items[0]['fieldLabel'] + '은(는)';
                    } else if (Ext.isDefined(invalid.items[0].ownerCt)) {
                        var labelText = invalid.items[0].ownerCt['fieldLabel'] + '은(는)';
                    }
                    Ext.Msg.alert('확인', labelText + Msg.sMB083);
                    invalid.items[0].focus();
                }
            }
        },
        onResetButtonDown: function () {
            panelResult.getForm().getFields().each(function (field) {
                field.setReadOnly(false);
            });
            panelResult.getForm().setValues({
                'PERSON_NUMB': ''
            });
            panelResult.getForm().setValues({
                'NAME': ''
            });
            panelResult.getForm().setValues({
                'RETR_DATE': ''
            });
            panelResult.getForm().setValues({
                'RETR_TYPE': ''
            });
            var activeTabId = tab.getActiveTab().getId();
            search1.uniOpt.inLoading = true;
            search1.setValue('SUPP_DATE', '');

            this.fnInitBinding();
            
            setTabDisable(true);
            // 데이터 삭제
            detailForm.getForm().getFields().each(function (field) {
                field.setValue('0');
            });
            
			search1.uniOpt.inLoading = false;
            formLoad = false;
            tab01Saved = false;
            UniAppManager.setToolbarButtons('save', false);
            UniAppManager.setToolbarButtons('delete', false);
        },
        loadTabData: function (tab, itemId) {

            if (tab.getActiveTab().getId() == 'hrt506ukrTab01') {
                UniAppManager.setToolbarButtons('reset', true);
            } else {
                //UniAppManager.setToolbarButtons('reset', false);
                if (tab.getActiveTab().getId() == 'hrt506ukrTab02') {
                    masterGrid1.getStore().loadStoreRecords();
                    masterGrid2.getStore().loadStoreRecords();
                    masterGrid3.getStore().loadStoreRecords();
                    masterGrid4.getStore().loadStoreRecords();

                } else if (tab.getActiveTab().getId() == 'hrt506ukrTab03') {
                    masterGrid5.getStore().loadStoreRecords();
                } else if (tab.getActiveTab().getId() == 'hrt506ukrTab04') {
                    search2.loadData()
                } else if (tab.getActiveTab().getId() == 'hrt506ukrTab05') {
                    masterGrid6.getStore().loadStoreRecords();
                }
            }
        },
        onNewDataButtonDown: function () {
            var param = Ext.getCmp('panelResultForm').getValues();
            var record = {
                RETR_DATE: UniDate.getDateStr(panelResult.getValue('RETR_DATE')),
                RETR_TYPE: panelResult.getValue('RETR_TYPE'),
                PERSON_NUMB: param.PERSON_NUMB,
                SUPP_DATE: UniDate.getDateStr(search1.getValue('SUPP_DATE'))
            };
            masterGrid4.createRow(record);
            UniAppManager.setToolbarButtons('save', true);
        },
        onDeleteDataButtonDown: function () {
            if (tab.getActiveTab().getId() == 'hrt506ukrTab01') {
                var param = {
                    "COMP_CODE": UserInfo.compCode,
                    "PERSON_NUMB": panelResult.getValue('PERSON_NUMB'),
                    "RETR_TYPE": panelResult.getValue('RETR_TYPE'),
                    "RETR_DATE": UniDate.getDateStr(panelResult.getValue('RETR_DATE'))
                };
                Ext.Msg.confirm('삭제', '데이터를 삭제 하시겠습니까?', function (btn) {
                    if (btn == 'yes') {
                        hrt506ukrService.deleteList(param, function (provider, response) {
                        	if(provider)	{
                        		alert('삭제 되었습니다.');
                        		UniAppManager.setToolbarButtons('delete', false);
                        		UniAppManager.app.onResetButtonDown();
                        	} else {
                        	
                        	}
                        });
                    } else {
                        UniAppManager.setToolbarButtons('save', false);
                    }
                });
            } else {
                if (tab.getActiveTab().getId() == 'hrt506ukrTab02') {
                    if (activeGrid == 'hrt506ukrGrid4') {
                        if (masterGrid4.getStore().getCount == 0) return;
                        var selRow = masterGrid4.getSelectionModel().getSelection()[0];
                        Ext.Msg.confirm('삭제', '선택 된 행을 삭제 합니다.\n삭제 하시겠습니까?', function (btn) {
                            if (btn == 'yes') {
                                masterGrid4.deleteSelectedRow();
                                UniAppManager.app.setToolbarButtons('save', true);
                            }
                        });
                    }

                }
            }
        },
        onSaveDataButtonDown: function (config) {
            var activeTabId = tab.getActiveTab().getId();
            if (activeTabId == 'hrt506ukrTab01') {
                var person_numb = panelResult.getForm().findField('PERSON_NUMB').getValue();
                if (person_numb == '') {
                    Ext.Msg.alert('확인', '사번을 입력하십시오.');
                    return false;
                } else {
                    search1.saveForm();
                }
            } else if (activeTabId == 'hrt506ukrTab02') {
                if (masterGrid1.getStore().isDirty()) {
                    directMasterStore1.saveStore();
                }
                if (masterGrid2.getStore().isDirty()) {
                    directMasterStore2.saveStore();
                }
                if (masterGrid3.getStore().isDirty()) {
                    directMasterStore3.saveStore();
                }
                if (masterGrid4.getStore().isDirty()) {
                    directMasterStore4.saveStore();
                }

                ////////////////////////
                //                alert('산정내역tab 저장확인');

            }
        },
        onDetailButtonDown: function () {
            var as = Ext.getCmp('AdvanceSerch');
            if (as.isHidden()) {
                as.show();
            } else {
                as.hide()
            }
        },
        processParams: function (params) {
            //          this.uniOpt.appParams = params;

            if (params && params.PERSON_NUMB) {
                panelResult.setValue('PERSON_NUMB', params.PERSON_NUMB);
                panelResult.setValue('NAME', params.NAME);
                panelResult.setValue('RETR_TYPE', params.CODE_NAME);
                panelResult.setValue('RETR_DATE', params.RETR_DATE);
                search1.setValue('SUPP_DATE', params.SUPP_DATE);

                directMasterStore1.loadStoreRecords();
                directMasterStore2.loadStoreRecords();
                directMasterStore3.loadStoreRecords();
                UniAppManager.app.onQueryButtonDown();
            } else if (params && params.autoLoad) {
                directMasterStore1.loadStoreRecords();
                directMasterStore2.loadStoreRecords();
                directMasterStore3.loadStoreRecords();
            }
        },
        requestApprove: function () { //결재 요청
            var gsWin = window.open('about:blank', 'payviewer', 'width=500,height=500');

            var frm = document.f1;
            var compCode = UserInfo.compCode;
            var userId = UserInfo.userID
            var person_numb = panelResult.getValue('PERSON_NUMB');
            var retr_date = UniDate.getDbDateStr(panelResult.getValue('RETR_DATE'));
            var retr_type = panelResult.getValue('RETR_TYPE');
            //var groupUrl = "http://58.151.163.201:8070/approval/legacyGateway.hi?viewMode=docuDraft&prg_no=hrt506ukr&draft_no=0&sp=EXEC "
            var gwurl = groupUrl + "viewMode=docuDraft&prg_no=hrt506ukr&draft_no=0&sp=EXEC ";
            var spText = 'omegaplus_kdg.unilite.USP_HUMAN_HRT506UKR_fnQuery ' + "'" + compCode + "'" + ', ' + "'" + person_numb + "'" + ', ' + "'" + retr_date + "'" + ', ' + "'" + retr_type + "'" + ', ' + "''" + ', ' + "'" + userId + "'" + ', ' + "'ko'" + ', ' + "''";

            var spCall = encodeURIComponent(spText);

            frm.action = gwurl + spCall /* + Base64.encode()*/ ;
            frm.target = "payviewer";
            frm.method = "post";
            frm.submit();
        }
    });

    // 검색폼을 읽기상태로 만듬
    function setPanelReadOnly(readOnly) {
        panelResult.getForm().getFields().each(function (field) {
            if (field.name != 'TAX_CALCU') {
                field.setReadOnly(readOnly);
            }
        });
    }

    //하위 탭의 이동가능 여부를 설정함
    function setTabDisable(disabled) {
        tab.down('#hrt506ukrTab02').setDisabled(disabled);
        if (panelResult.getField('OT_KIND').getValue().OT_KIND == 'OF') {
        	if(!disabled)	{
            	tab.down('#hrt506ukrTab03').setDisabled(disabled);
        	}
        }
        tab.down('#hrt506ukrTab04').setDisabled(disabled);
        tab.down('#hrt506ukrTab05').setDisabled(disabled);
    }

    // 지급총액 계산
    function fnSuppTotI(newValue) {

        var retrAnnu = 0;
        var stxtGloryAmountI = 0;
        var stxtGroupInsurI = 0;
        var stxtOutIncomeI = 0;
        var sEtcAmount = 0;
        var sOFPayAnnuI = 0;

        //퇴직금
        var RETR_ANNU_I = (newValue && newValue["RETR_ANNU_I"]) ? newValue["RETR_ANNU_I"] : search1.getValue('RETR_ANNU_I');
        retrAnnu = parseInt(RETR_ANNU_I);
        //명예퇴직지급
        var GLORY_AMOUNT_I = (newValue && newValue["GLORY_AMOUNT_I"]) ? newValue["GLORY_AMOUNT_I"] : search1.getValue('GLORY_AMOUNT_I');
        stxtGloryAmountI = parseInt(GLORY_AMOUNT_I);
        //퇴직보험금
        var GROUP_INSUR_I = (newValue && newValue["GROUP_INSUR_I"]) ? newValue["GROUP_INSUR_I"] : search1.getValue('GROUP_INSUR_I');
        stxtGroupInsurI = parseInt(GROUP_INSUR_I);
        //비과세소득
        var OUT_INCOME_I = (newValue && newValue["OUT_INCOME_I"]) ? newValue["OUT_INCOME_I"] : search1.getValue('OUT_INCOME_I');
        stxtOutIncomeI = parseInt(OUT_INCOME_I);
        //기타지급
        var ETC_AMOUNT_I = (newValue && newValue["ETC_AMOUNT_I"]) ? newValue["ETC_AMOUNT_I"] : search1.getValue('ETC_AMOUNT_I');
        sEtcAmount = parseInt(ETC_AMOUNT_I);

        //근로소득 간주액
        var OF_PAY_ANNU_I = (newValue && newValue["OF_PAY_ANNU_I"]) ? newValue["OF_PAY_ANNU_I"] : search1.getValue('OF_PAY_ANNU_I');
        sOFPayAnnuI = parseInt(OF_PAY_ANNU_I);

        
        //지급총액
        search1.setValue('RETR_SUM_I', (retrAnnu + stxtGloryAmountI + stxtGroupInsurI + stxtOutIncomeI + sEtcAmount));
        detailForm.setValue('RETR_SUM_I2', (retrAnnu + stxtGloryAmountI + stxtGroupInsurI + sEtcAmount));
        detailForm.setValue('RETR_SUM_I3', (retrAnnu + stxtGloryAmountI + stxtGroupInsurI + stxtOutIncomeI + sEtcAmount));
		
        // 최종분퇴직급여 재계산
        search1.setValue('R_ANNU_TOTAL_I', (retrAnnu + stxtGloryAmountI + stxtGroupInsurI + stxtOutIncomeI + sEtcAmount - sOFPayAnnuI));
        search1.setValue('R_TAX_TOTAL_I', (retrAnnu + stxtGloryAmountI + stxtGroupInsurI + sEtcAmount - sOFPayAnnuI));

        var params = getParams();
        hrt506ukrService.retireProcStChangedSuppTotal(params, function (responseText, response) {
            if (responseText) {
                setData01(responseText);
            }
        })
    }

    // 공제총액 계산
    function fnDedTotI(data) {
        var inTax = 0;
        var localTax = 0;
        var etcAmount2 = 0;
        var groupInsur2 = 0;
        var gloryAmount2 = 0;

        // 소득세
        var IN_TAX_I = Unilite.nvl(search1.getValue('IN_TAX_I'),0);
        inTax = IN_TAX_I;
        // 지방소득세
        var LOCAL_TAX_I = Unilite.nvl(search1.getValue('LOCAL_TAX_I'),0);
        localTax = LOCAL_TAX_I;
        // 소득세 환급액
        var DED_IN_TAX_ADD_I = Unilite.nvl(search1.getValue('DED_IN_TAX_ADD_I'),0);
        etcAmount2 = DED_IN_TAX_ADD_I;
        // 주민세 환급액
        var DED_IN_LOCAL_ADD_I = Unilite.nvl(search1.getValue('DED_IN_LOCAL_ADD_I'),0);
        groupInsur2 = DED_IN_LOCAL_ADD_I;
        // 기타공제
        var DED_ETC_I = Unilite.nvl(search1.getValue('DED_ETC_I'),0);
        //기타공제2
        var DED_ETC_I2 = Unilite.nvl(search1.getValue('DED_ETC_I2'),0);
 		//퇴직정산소득세'
		var DED_ETC_I3 = Unilite.nvl(search1.getValue('DED_ETC_I3'),0);
 		//퇴직정산지방소득세
        var DED_ETC_I4 = Unilite.nvl(search1.getValue('DED_ETC_I4'),0);
       		//건강보험료정산
        var DED_ETC_I5 = Unilite.nvl(search1.getValue('DED_ETC_I5'),0);
		//장기요양보험료정산
		var DED_ETC_I6 = Unilite.nvl(search1.getValue('DED_ETC_I6'),0);

        gloryAmount2 = DED_ETC_I + DED_ETC_I2 + DED_ETC_I3 + DED_ETC_I4 + DED_ETC_I5 + DED_ETC_I6;
        
        if(!data)	{
	        //공제총액
	        search1.setValue('DED_TOTAL_I', (inTax + localTax + etcAmount2 + groupInsur2 + gloryAmount2));
	        detailForm.setValue('DED_TOTAL_I2', (inTax + localTax + etcAmount2 + groupInsur2 + gloryAmount2));
	        //실지급액
	        var sDedAmount = Unilite.nvl(detailForm.getValue('DED_TOTAL_I2'), 0) - Unilite.nvl(detailForm.getValue('PAY_END_TAX'), 0) ;     
	        detailForm.setValue('REAL_AMOUNT_I', (detailForm.getValue('RETR_SUM_I3') - sDedAmount));
			
        }
        // 폼 서브밋을 위한 히든 필드에 계산된 값을 집어 넣음
        search1.setValue('M_TAX_TOTAL_I', detailForm.getValue('M_TAX_TOTAL_I'));
        search1.setValue('REAL_AMOUNT_I', detailForm.getValue('REAL_AMOUNT_I'));

    }

    function getParams() {
        var params = Ext.getCmp('panelResultForm').getValues();

        params.SUPP_DATE = UniDate.getDateStr(search1.getValue('SUPP_DATE')); // 지급일
        params.R_CALCU_END_DATE = search1.getValue('R_CALCU_END_DATE'); // 최종분-기산일
        params.S_LONG_YEARS = search1.getValue('S_LONG_YEARS'); // 정산(합산)근속연수
        params.LONG_YEARS = search1.getValue('LONG_YEARS'); // 근속연수
        params.LONG_YEARS_BE13 = search1.getValue('LONG_YEARS_BE13'); // 2013이전근속연수
        params.LONG_YEARS_AF13 = search1.getValue('LONG_YEARS_AF13'); // 2013이후근속연수
        params.R_ANNU_TOTAL_I = search1.getValue('R_ANNU_TOTAL_I'); // 최종분-퇴직급여
        params.OUT_INCOME_I = search1.getValue('OUT_INCOME_I'); // 최종분-퇴직급여(비과세)
        params.M_ANNU_TOTAL_I = search1.getValue('M_ANNU_TOTAL_I'); // 중도정산-퇴직급여
        params.M_OUT_INCOME_I = search1.getValue('M_OUT_INCOME_I'); // 중도정산-퇴직급여 (비과세)
       
        if (Ext.isEmpty(search1.getValue('DED_IN_TAX_ADD_I'))) {
            var ded_in_tax_add_i = 0;
            params.DED_IN_TAX_ADD_I = ded_in_tax_add_i; // 소득세환급액
        } else {
            params.DED_IN_TAX_ADD_I = search1.getValue('DED_IN_TAX_ADD_I');
        }
        if (Ext.isEmpty(search1.getValue('DED_IN_LOCAL_ADD_I'))) {
            var ded_in_local_add_i = 0;
            params.DED_IN_LOCAL_ADD_I = ded_in_local_add_i; // 주민세환급액
        } else {
            params.DED_IN_LOCAL_ADD_I = search1.getValue('DED_IN_LOCAL_ADD_I');
        }
        if (Ext.isEmpty(search1.getValue('DED_ETC_I'))) {
            var ded_etc_i = 0;
            params.DED_ETC_I = ded_etc_i; // 기타공제1
        } else {
            params.DED_ETC_I = search1.getValue('DED_ETC_I');
        }
        params.DED_ETC_I2 = search1.getValue('DED_ETC_I2'); // 기타공제2
        params.DED_ETC_I3 = search1.getValue('DED_ETC_I3'); // 중도퇴직정산소득세
        params.DED_ETC_I4 = search1.getValue('DED_ETC_I4'); // 중도퇴직정산지방소득세
        params.DED_ETC_I5 = search1.getValue('DED_ETC_I5'); // 건강보험료정산
        params.DED_ETC_I6 = search1.getValue('DED_ETC_I6'); // 장기요양보험료정산
        params.EXEP_MONTHS_AF13 = search1.getValue('EXEP_MONTHS_AF13'); // 2013이후 제외 월
        params.R_EXEP_DAY_AF13 = search1.getValue('R_EXEP_DAY_AF13'); // 2013이후 제외 일
        params.EXEP_MONTHS_BE13 = search1.getValue('EXEP_MONTHS_BE13'); // 2013이전 제외 월
        params.R_EXEP_DAY_BE13 = search1.getValue('R_EXEP_DAY_BE13'); // 2013이전 제외 일
        params.DUTY_YYYY = search1.getValue('DUTY_YYYY'); // 근속년
        params.LONG_MONTH = search1.getValue('LONG_MONTH'); // 근속월
        params.LONG_DAY = search1.getValue('LONG_DAY'); // 근속일
        params.LONG_TOT_DAY = search1.getValue('LONG_TOT_DAY1'); // 누진근속일수
        params.LONG_TOT_MONTH = search1.getValue('LONG_TOT_MONTH'); // 누진근속월수
        params.RETR_OT_KINE = panelResult.getValue('OT_KIND').OT_KIND; // 퇴직분류
        params.PAY_TOTAL_I = search1.getValue('PAY_TOTAL_I'); // 급여총액
        params.BONUS_TOTAL_I = search1.getValue('BONUS_TOTAL_I'); // 상여총액
        params.INCOME_DED_I = search1.getValue('INCOME_DED_I'); // 근속년수공제
        params.KEY_VALUE = UniDate.getDateStr(new Date());

        params.LOCAL_END_TAX = search1.getValue('LOCAL_END_TAX');
        params.PAY_END_TAX_16 = search1.getValue('PAY_END_TAX_16');
        params.PAY_END_TAX = search1.getValue('PAY_END_TAX_16'); // 기납부세액
        params.DEF_TAX_I = detailForm.getValue('DEF_TAX_I'); // 결정세액

        params.DAVG_ETC3 = Unilite.nvl(directMasterStore2.sum("GIVE_I"), 0); // 기타수당 총액
        
        params.AVG_BONUS_I_3 = search1.getValue('AVG_BONUS_I_3')
        params.AVG_YEAR_I_3 = search1.getValue('AVG_YEAR_I_3')
        params.DELETE_FLAG = '';

        params.SUPP_TOTAL_I = search1.getValue('SUPP_TOTAL_I1'); //과세대상 퇴직급여, 정산퇴직 소득

        return params;
    }

    function setData01(data) {
            console.log('setData01 :: ' + data.SUPP_TOTAL_I);
			search1.setValues(data);
            search1.setValue('SUPP_TOTAL_I1', data.SUPP_TOTAL_I); // 과세대상퇴직급여
            search1.setValue('SUPP_TOTAL_I2', data.SUPP_TOTAL_I); // 정산퇴직 소득
            
            search1.setValue('COMP_TAX_I_161', data.COMP_TAX_I_16); // 산출세액(2016.01.01 이후 - 세액내역)
            

            //하단 폼에 데이터를 입력
            detailForm.getForm().setValues(data);
            detailForm.setValue('COMP_TAX_I_16', data.COMP_TAX_I);
           
			detailForm.setValue('SUPP_TOTAL_I2', data.SUPP_TOTAL_I);
			detailForm.setValue('DED_TOTAL_I2', data.BAL_DED_TOTAL_I);  

	        //퇴직금
	        var retrAnnu = parseInt(search1.getValue('RETR_ANNU_I'));
	        //명예퇴직지급
	        var stxtGloryAmountI = parseInt(search1.getValue('GLORY_AMOUNT_I'));
	        //퇴직보험금
	        var stxtGroupInsurI = parseInt(search1.getValue('GROUP_INSUR_I'));
	        //비과세소득
	        var stxtOutIncomeI = parseInt(search1.getValue('OUT_INCOME_I'));
	        //기타지급
	        var sEtcAmount = parseInt(search1.getValue('ETC_AMOUNT_I'));
	        //근로소득 간주액
	        var sOFPayAnnuI = parseInt(search1.getValue('OF_PAY_ANNU_I'));
	
	        
	        // 최종분퇴직급여 재계산
	        search1.setValue('R_ANNU_TOTAL_I', (retrAnnu + stxtGloryAmountI + stxtGroupInsurI + stxtOutIncomeI + sEtcAmount - sOFPayAnnuI));
	        search1.setValue('R_TAX_TOTAL_I', (retrAnnu + stxtGloryAmountI + stxtGroupInsurI + sEtcAmount - sOFPayAnnuI));
        
            // 공제총액 계산
            fnDedTotI(data);
        }
        //급여/기타수당/상여/년월차 변경시 퇴직급여 재계산
    function fnCalRetrAnnu() {

        var dAvgPay3 = 0,
            dAvgEtc3 = 0,
            dAvgBonusI3 = 0,
            dAvgYearI3 = 0,
            dLongTotDay = 0;

        //급여내역      BONUS_I
        dAvgPay3 = Unilite.nvl(directMasterStore1.sum("AMOUNT_I"), 0);

        //기타수당
        dAvgEtc3 = Unilite.nvl(directMasterStore2.sum("GIVE_I"), 0);

        //상여내역
        dAvgBonusI3 = Unilite.nvl(directMasterStore3.sum("BONUS_I"), 0);

        //년월차
        dAvgYearI3 = Unilite.nvl(directMasterStore4.sum("BONUS_I"), 0);

        //근속일수
        if (!Ext.isEmpty(search1.getValue("LONG_TOT_DAY1"))) {
            dLongTotDay = search1.getValue("LONG_TOT_DAY1");
        }

        //dAvgPay3		: 급여총액
        //dBonusTotalI	: 상여총액
        //dYearTotalI	: 년월차총액
        //dAvgPay3		: 3개월급여
        //dAvgBonusI3	: 3개월상여
        //dAvgYearI3		: 3개월년월차

        var nAvgBonusI3 = UniHuman.fix((dAvgBonusI3 / 4));
        var nAvgYearI3 = UniHuman.fix((dAvgYearI3 / 4));
        
        search1.setValue("PAY_TOTAL_I", (dAvgPay3 + dAvgEtc3));
        search1.setValue("BONUS_TOTAL_I", dAvgBonusI3);
        search1.setValue("YEAR_TOTAL_I", dAvgYearI3);

        search1.setValue("AVG_PAY_3", (dAvgPay3 + dAvgEtc3));
        search1.setValue("AVG_BONUS_I_3", UniHuman.fix((dAvgBonusI3 / 4)));
        search1.setValue("AVG_YEAR_I_3", UniHuman.fix((dAvgYearI3 / 4)));

        search1.setValue("TOT_WAGES_I", (dAvgPay3 + dAvgEtc3 + nAvgBonusI3 + nAvgYearI3));
        search1.setValue("AVG_WAGES_I", (UniHuman.fix((dAvgPay3 + dAvgEtc3 + nAvgBonusI3 + nAvgYearI3) / 3)));

        var params = getParams();
        hrt506ukrService.retireProcStChangedPayment(params, function (responseText, response) {
            if (responseText) {
                var checkSave = false;
                if (UniAppManager.app._needSave()) {
                    checkSave = true;
                }
                search1.setValue("RETR_ANNU_I", responseText.RETR_ANNU_I);
                search1.setValue("ORI_RETR_ANNU_I", responseText.RETR_ANNU_I);
                //search1 uniOnChange 에서 변경되는 것을 그리드 저장 여부에 맞도록 수정
                if (checkSave) {
                    UniAppManager.setToolbarButtons('save', true);
                }
                fnSuppTotI({"RETR_ANNU_I": responseText.RETR_ANNU_I});
            }
        });

    }
};
</script>
<form id="f1" name="f1" action="" method="post" onSubmit="return false;" >
<input type="hidden" id="loginid" name="loginid" value="superadmin" />
<input type="hidden" id="fmpf" name="fmpf" value="" />
<input type="hidden" id="fmbd" name="fmbd" runat="server" />
</form>