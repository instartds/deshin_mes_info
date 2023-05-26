<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_zcc200skrv_kd"  >
    <t:ExtComboStore comboType="BOR120"  pgmId="s_zcc200skrv_kd"  />             <!-- 사업장 -->
    <t:ExtComboStore comboType="AU" comboCode="B004"/>              <!-- 화폐단위 -->
    <t:ExtComboStore comboType="AU" comboCode="B010"/>              <!-- 사용 -->
    <t:ExtComboStore comboType="AU" comboCode="B013"/>              <!-- 단위  --> 
    <t:ExtComboStore comboType="AU" comboCode="B004"/>              <!-- 기준화폐 -->
    <t:ExtComboStore comboType="AU" comboCode="WB04"/>              <!-- 차종  -->
    <t:ExtComboStore comboType="AU" comboCode="WZ02"/>              <!-- 구분  -->
    <t:ExtComboStore comboType="AU" comboCode="WZ05"/>              <!-- 부품명 -->
    <t:ExtComboStore comboType="AU" comboCode="WZ07"/>              <!-- 재질  -->
	<t:ExtComboStore items="${COMBO_GW_STATUS}" storeId="gwStatus" />  <!-- 그룹웨어결재상태 -->
</t:appConfig>
<script type="text/javascript" >

function appMain() {
    
    var groupUrl = '${groupUrl}'; //그룹웨어 호출 url
    /**
     *   Model 정의 
     * @type 
     */
    Unilite.defineModel('s_zcc200skrv_kdModel', {
        fields: [
            {name : 'COMP_CODE',        text : '법인코드',      type: 'string'},
            {name : 'DIV_CODE',         text : '사업장',       type: 'string', comboType: 'BOR120'},
        	{name : 'EST_DATE',         text : '견적일자',      type: 'uniDate'},
            {name : 'EST_NUM',          text : '견적번호',      type: 'string'},
            {name : 'CUSTOM_CODE',      text : '거래처코드',    type: 'string'},
            {name : 'CUSTOM_NAME',      text : '거래처명',      type: 'string'},
            {name : 'ITEM_CODE',        text : '품번',      type: 'string'},
            {name : 'ITEM_NAME',        text : '품명',       type: 'string'},
            {name : 'CAR_TYPE',         text : '차종',        type: 'string', comboType:'AU', comboCode:'WB04'},
            {name : 'PROG_WORK_NAME',   text : '공정명',        type: 'string'},
            {name : 'CALC1',            text : '제조원가',        type: 'float', decimalPrecision: 0, format:'0,000'},
            {name : 'CALC2',            text : '관리/이윤',        type: 'float', decimalPrecision: 0, format:'0,000'},
            {name : 'CALC3',            text : '총합계',        type: 'float', decimalPrecision: 0, format:'0,000'},
            {name : 'REMARK',           text : '비고',        type: 'string'},
            {name : 'DEPT_NAME',        text : '부서명',       type: 'string'},
            {name : 'PERSON_NAME',      text : '담당자명',       type: 'string'},
            {name: 'GW_FLAG'                ,text: '기안여부'                ,type: 'string', store:Ext.data.StoreManager.lookup("gwStatus")},
            
            {name : 'T4_1',      text : 'T4_1',       type: 'string'},
            {name : 'T6_1',      text : 'T6_1',       type: 'string'}

        ]
    }); 
    
    Unilite.defineModel('s_zcc200skrv_kdModel2', {
        fields: [
            {name : 'COMP_CODE',        text : '법인코드',      type: 'string'},
            {name : 'DIV_CODE',         text : '사업장',       type: 'string', comboType: 'BOR120'},
            {name : 'EST_NUM',          text : '견적번호',      type: 'string'},
            {name : 'EST_SEQ',          text : '견적순번',      type: 'int'},
            {name : 'GUBUN_CODE',       text : '부품명',       type: 'string', comboType:'AU', comboCode:'WZ05'},
            {name : 'JAEGIL',           text : '재질',        type: 'string', comboType:'AU', comboCode:'WZ07'},
            {name : 'STOCK_UNIT',       text : '단위',        type: 'string', comboType:'AU', comboCode:'B013'},
            {name : 'GARO_NUM',         text : '가로',        type: 'int'},
            {name : 'SERO_NUM',         text : '세로',        type: 'int'},
            {name : 'DUGE_NUM',         text : '높이',        type: 'int'},
            {name : 'UNIT_Q',           text : '개수',        type: 'float', decimalPrecision: 0, format:'0,000'},
            {name : 'QTY_HH',           text : '소요량',       type: 'uniQty'},
            {name : 'PRICE_RATE',       text : '단가',        type: 'float', decimalPrecision: 0, format:'0,000'},
            {name : 'AMT_O',            text : '금액',        type: 'float', decimalPrecision: 0, format:'0,000'},
            {name : 'REMARK',           text : '비고',        type: 'string'}
        ]
    });

    
    Unilite.defineModel('s_zcc200skrv_kdModel3', {
        fields: [
            {name : 'EST_NUM',          text : '견적번호',      type: 'string'},
            {name : 'EST_SEQ',          text : '순번',      type: 'int'},
            {name : 'COMP_CODE',        text : '법인코드',      type: 'string'},
            {name : 'DIV_CODE',         text : '사업장',       type: 'string', comboType: 'BOR120'},
            {name : 'GUBUN',            text : '구분',        type: 'string', comboType:'AU', comboCode:'WZ02'},
            {name : 'GUBUN_CODE',       text : '가공공정명',       type: 'string', comboType:'AU', comboCode:'WZ06'},
            {name : 'JAEGIL',           text : '재질',        type: 'string', comboType:'AU', comboCode:'WZ07'},
            {name : 'UNIT_Q',           text : '개수',        type: 'uniQty'},
            {name : 'STOCK_UNIT',       text : '단위',        type: 'string', comboType:'AU', comboCode:'B013'},
            {name : 'QTY_HH',           text : '시간',       type: 'float', decimalPrecision: 0, format:'0,000'},
            {name : 'PRICE_RATE',       text : '임율',        type: 'float', decimalPrecision: 0, format:'0,000'},
            {name : 'AMT_O',            text : '금액',        type: 'float', decimalPrecision: 0, format:'0,000'},
            {name : 'GARO_NUM',         text : '가로',        type: 'int'},
            {name : 'SERO_NUM',         text : '세로',        type: 'int'},
            {name : 'DUGE_NUM',         text : '두께',        type: 'int'},
            {name : 'REMARK',           text : '비고',        type: 'string'}
        ]
    }); 
    
    /**
     * Store 정의(Service 정의)
     * @type 
     */
    var directMasterStore1 = Unilite.createStore('s_zcc200skrv_kdMasterStore1', {
        model: 's_zcc200skrv_kdModel',
        uniOpt : {
            isMaster:  true,            // 상위 버튼 연결 
            editable:  false,            // 수정 모드 사용 
            deletable: false,            // 삭제 가능 여부 
            useNavi :  false            // prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: {
            type: 'direct',
            api: {read: 's_zcc200skrv_kdService.selectList'}
        },
        loadStoreRecords : function()   {
            var param = panelResult.getValues();
            this.load({
                  params : param
            });         
        },
        groupField:'CUSTOM_NAME'
    }); // End of var directMasterStore1 
    
    var directMasterStore2 = Unilite.createStore('s_zcc200skrv_kdMasterStore2',{
        model: 's_zcc200skrv_kdModel2',
        uniOpt : {
            isMaster:  true,            // 상위 버튼 연결 
            editable:  false,            // 수정 모드 사용 
            deletable: false,            // 삭제 가능 여부 
            useNavi :  false            // prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: {
            type: 'direct',
            api: {read: 's_zcc200skrv_kdService.selectDetail1'}
        },
        loadStoreRecords : function(param)   {   
            this.load({
                  params : param
            });         
        },
        listeners: {
            load: function(store, records, successful, eOpts) {
            }
        }
    }); // End of var directMasterStore1
    
    var directMasterStore3 = Unilite.createStore('s_zcc200skrv_kdMasterStore3',{
        model: 's_zcc200skrv_kdModel3',
        uniOpt : {
            isMaster:  true,            // 상위 버튼 연결 
            editable:  false,            // 수정 모드 사용 
            deletable: false,            // 삭제 가능 여부 
            useNavi :  false            // prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: {
            type: 'direct',
            api: {read: 's_zcc200skrv_kdService.selectDetail2'}
        },
        loadStoreRecords : function(param)   {   
            this.load({
                  params : param
            });         
        },
        listeners: {
            load: function(store, records, successful, eOpts) {
                UniAppManager.app.fnCalcFormTotal(subForm.getValue('T4_1'),subForm.getValue('T6_1'));
            }
        }
    }); // End of var directMasterStore1    
    
    /**
     * 검색조건 (Search Panel)
     * @type 
     */ 
    var panelResult = Unilite.createSearchForm('resultForm', {
        region: 'north',
        layout : {type : 'uniTable', columns : 4},
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
                fieldLabel: '견적번호',
                name: 'EST_NUM',
                xtype: 'uniTextfield'
            },{
                fieldLabel: '견적일자',
                xtype: 'uniDateRangefield',
                startFieldName: 'FR_EST_DATE',
                endFieldName: 'TO_EST_DATE',
                startDate: UniDate.get('startOfMonth'),
                endDate: UniDate.get('today'),
//                allowBlank:false,
                colspan:2
            },{
                fieldLabel: '품번',
                name: 'ITEM_CODE',
                xtype: 'uniTextfield'
            },{
                fieldLabel: '비고',
                name: 'REMARK',
                xtype: 'uniTextfield'
            },
            Unilite.popup('AGENT_CUST',{ 
                    fieldLabel: '거래처',
                    valueFieldName:'CUSTOM_CODE',
                    textFieldName:'CUSTOM_NAME'
            }),{
                fieldLabel: '기안여부',
                name: 'GW_FLAG',
                xtype: 'uniCombobox',
                store:Ext.data.StoreManager.lookup("gwStatus"),
                readOnly: false
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
    
    var subForm = Unilite.createSearchForm('subForm', {
        region: 'center',
        layout : {type : 'uniTable', columns : 5, tableAttrs: {width: '99.5%'}},
        padding:'1 1 1 1',
        border:true,
        items: [{
            fieldLabel: '③제조원가(①+②)',
            name: 'T3',
            xtype: 'uniNumberfield',
            value: 0,
            readOnly: true,
            labelWidth:120
        },{
			xtype: 'container',
			layout: { type: 'uniTable', columns: 2},
			defaultType: 'uniTextfield',
          	padding: '0 0 0 0',
			items:[{
                fieldLabel: '④관리',
				name:'T4',
				xtype:'uniNumberfield',
				decimalPrecision: 0,
				format:'0,000',
            	readOnly: true
			},{
                name:'T4_1',
                xtype: 'uniTextfield',
                width: 50,
                readOnly: true,
				suffixTpl:'%'
//				listeners: {
//					change: function(field, newValue, oldValue, eOpts) {
//						UniAppManager.app.fnCalcFormTotal(newValue, subForm.getValue('T6_1'));
//					}
//				}
            }]
        },{
			xtype: 'container',
			layout: { type: 'uniTable', columns: 2},
			defaultType: 'uniTextfield',
          	padding: '0 0 0 0',
//          	colspan:3,
			items:[{
                fieldLabel: '⑥이윤',
				name:'T6',
				xtype:'uniNumberfield',
				decimalPrecision: 0,
				format:'0,000',
            	readOnly: true
			},{
                name:'T6_1',
                xtype: 'uniTextfield',
                width: 50,
                readOnly: true,
				suffixTpl:'%'
//				listeners: {
//					change: function(field, newValue, oldValue, eOpts) {
//						UniAppManager.app.fnCalcFormTotal(subForm.getValue('T4_1', newValue));
//					}
//				}
            }]
        },
        {
			xtype: 'container',
			layout: { type: 'uniTable', columns: 4},
          	padding: '0 0 0 0',
          	tdAttrs: {align: 'right'},
//      		margin: '0 10 0 50',
          	defaults:{
//          		rowspan:2
//	          	padding: '0 0 20 0'
          		labelAlign: 'top',
            	readOnly: true,
            	width:100
          		
          	},
          	rowspan:2,
			items:[{
                fieldLabel: '원가구성',
				name:'T8',
				xtype:'uniNumberfield',
				decimalPrecision: 0,
				format:'0,000',
				suffixTpl:'%'
			},{
                fieldLabel: '재료비',
				name:'T9',
				xtype:'uniNumberfield',
				decimalPrecision: 0,
				format:'0,000',
				suffixTpl:'%'
			},{
                fieldLabel: '가공비',
				name:'T10',
				xtype:'uniNumberfield',
				decimalPrecision: 0,
				format:'0,000',
				suffixTpl:'%'
			},{
                fieldLabel: '관리/이윤',
				name:'T11',
				xtype:'uniNumberfield',
				decimalPrecision: 0,
				format:'0,000',
				suffixTpl:'%'
			}]
        },{
            width: 100,
            xtype: 'button',
            text: '기안',
            tdAttrs: {align: 'right'},
            handler: function() {
                var param = panelResult.getValues();
				var selectR = masterGrid.getSelectedRecord();
                if(Ext.isEmpty(selectR)) {
                    alert('선택된 데이터가 없습니다.');
                    return false;
                }else{
                	param.DRAFT_NO = UserInfo.compCode + selectR.get('EST_NUM');
                	param.EST_NUM = selectR.get('EST_NUM');
                    if(confirm('기안 하시겠습니까?')) {
                        s_zcc200skrv_kdService.selectGwData(param, function(provider, response) {
                            if(Ext.isEmpty(provider[0]) || provider[0].GW_FLAG != '1' || provider[0].GW_FLAG != '3') {
//                                panelResult.setValue('GW_TEMP', '기안중');
                                s_zcc200skrv_kdService.makeDraftNum(param, function(provider2, response)   {
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
            }
         },
        {
            xtype: 'component',
            width: 50
        },{
            fieldLabel: '⑤소계(③+④)',
            name: 'T5',
            xtype: 'uniNumberfield',
            value: 0,
            readOnly: true
        },{
            fieldLabel: '⑦총합계(⑤+⑥)',
            name: 'T7',
            xtype: 'uniNumberfield',
            value: 0,
            readOnly: true,
            fieldStyle: 'font-weight:bold'
        }]
    });
    
    var masterGrid = Unilite.createGrid('s_zcc200skrv_kdGrid', { 
        layout : 'fit',
        region: 'north', 
        store: directMasterStore1,
        uniOpt: {
            expandLastColumn: false,
            onLoadSelectFirst : true, //조회시 첫번째 레코드 select 사용여부
            useMultipleSorting: false,
            useGroupSummary: false,
//            useContextMenu: true,
            useRowNumberer: true
//            filter: {
//                useFilter: true,
//                autoCreate: true
//            }
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
        selModel: 'rowmodel',
        columns:  [
            {dataIndex : 'COMP_CODE',                width : 100,hidden:true},
            {dataIndex : 'DIV_CODE',                 width : 100,hidden:true},
            {dataIndex : 'EST_DATE',                 width : 100},
            {dataIndex : 'EST_NUM',                  width : 100
//            	summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
//			       return Unilite.renderSummaryRow(summaryData, metaData, '', '합계');
//            	}
            },
            {dataIndex : 'CUSTOM_CODE',              width : 100},
            {dataIndex : 'CUSTOM_NAME',              width : 200},
            {dataIndex : 'ITEM_CODE',                width : 100},
            {dataIndex : 'ITEM_NAME',                width : 200},
            {dataIndex : 'CAR_TYPE',                 width : 100},
            {dataIndex : 'PROG_WORK_NAME',           width : 100},
            {dataIndex : 'CALC1',                    width : 100,summaryType:'sum'
//            	summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
//			       return Unilite.renderSummaryRow(summaryData,metaData,'<div align="right">'+Ext.util.Format.number(value, '0,000')+'</div>','<div align="right">'+Ext.util.Format.number(value, '0,000')+'</div>');
//            	}
            },
            {dataIndex : 'CALC2',                    width : 100,summaryType:'sum'
//            	summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
//			       return Unilite.renderSummaryRow(summaryData,metaData,'<div align="right">'+Ext.util.Format.number(value, '0,000')+'</div>','<div align="right">'+Ext.util.Format.number(value, '0,000')+'</div>');
//            	}
            },
            {dataIndex : 'CALC3',                    width : 100,summaryType:'sum'
//            	summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
//			       return Unilite.renderSummaryRow(summaryData,metaData,'<div align="right">'+Ext.util.Format.number(value, '0,000')+'</div>','<div align="right">'+Ext.util.Format.number(value, '0,000')+'</div>');
//            	}
            },
            {dataIndex : 'REMARK',                   width : 250},
            {dataIndex : 'DEPT_NAME',                width : 100},
            {dataIndex : 'PERSON_NAME',              width : 100},
            {dataIndex:'GW_FLAG'                               , width: 100}
        ],
        listeners: {
        	selectionchange : function( model1, selected, eOpts ) {
        		var count = masterGrid.getStore().getCount();
        		if(selected.length > 0) {
        			
        			
//        		if(count > 0) {
                    var record = selected[0];
                    
                    subForm.setValue('T4_1',record.get('T4_1'));
                    subForm.setValue('T6_1',record.get('T6_1'));
                    
                    var param = Ext.getCmp('resultForm').getValues(); 
                    var param = {
                        DIV_CODE    : record.get('DIV_CODE'),
                        EST_NUM     : record.get('EST_NUM')
                    }
                    directMasterStore2.loadStoreRecords(param);
                    directMasterStore3.loadStoreRecords(param);
                } else {
                	
            		masterGrid2.getStore().loadData({});
            		masterGrid3.getStore().loadData({});
            		
		            subForm.setValue('T3', 0);
		            subForm.setValue('T4', 0);
		            subForm.setValue('T4_1', 0);
		            subForm.setValue('T5', 0);
		            subForm.setValue('T6', 0);
		            subForm.setValue('T6_1', 0);
		            subForm.setValue('T7', 0);
		            subForm.setValue('T8', 0);
		            subForm.setValue('T9', 0);
		            subForm.setValue('T10', 0);
		            subForm.setValue('T11', 0);
                }
                
            }
        }
    });
    
    var masterGrid2 = Unilite.createGrid('s_zcc200skrv_kdGrid2', { 
        layout : 'fit',
        region:'south',
        flex: 2,
        title : '재료비',
        sortableColumns : false,  
        store: directMasterStore2,
        uniOpt: {
            useRowNumberer: false
        },
        features: [{		
			id: 'masterGridSubTotal', 
			ftype: 'uniGroupingsummary', 
			showSummaryRow: false
		},{
			id: 'masterGridTotal', 
			ftype: 'uniSummary', 
			showSummaryRow: true
		}],
        columns:  [
            {dataIndex : 'COMP_CODE',     width :100, hidden : true},
            {dataIndex : 'DIV_CODE',      width :100, hidden : true},
            {dataIndex : 'EST_NUM',       width :100, hidden : true},
            {dataIndex : 'EST_SEQ',       width :100, hidden : true},
            {dataIndex : 'GUBUN_CODE',    width :100,
            	summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
			       return Unilite.renderSummaryRow(summaryData, metaData, '', '①재료비 소계');
            	}
        	},
            {dataIndex : 'JAEGIL',        width :100},
            {dataIndex : 'STOCK_UNIT',    width :100,
                editor : {
                    xtype:'uniCombobox',
                    store:Ext.data.StoreManager.lookup('CBS_AU_B013'),
                    listeners:{
                        beforequery: function(queryPlan, eOpts) {
                            var store = queryPlan.combo.getStore();

                            store.clearFilter(true);
                            queryPlan.combo.queryFilter = null;

                            store.filterBy(function(record, id) {
                               if(record.get('value') == 'EA' || record.get('value') == 'KG' || record.get('value') == 'HT' || record.get('value') == '') {
                                  return record;
                               } else {
                                  return null;
                               }
                            });
                        }
                    }
                }
            },
            {dataIndex : 'GARO_NUM',      width :100},
            {dataIndex : 'SERO_NUM',      width :100},
            {dataIndex : 'DUGE_NUM',      width :100},
            {dataIndex : 'UNIT_Q',        width :100},
            {dataIndex : 'QTY_HH',        width :100},
            {dataIndex : 'PRICE_RATE',    width :100},
            {dataIndex : 'AMT_O',         width :100,summaryType:'sum',
            	summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
			       return Unilite.renderSummaryRow(summaryData,metaData,'<div align="right">'+Ext.util.Format.number(value, '0,000')+'</div>','<div align="right">'+Ext.util.Format.number(value, '0,000')+'</div>');
            	}
            },
            {dataIndex : 'REMARK',        width :100}
        ],
        listeners: {
            beforeedit  : function( editor, e, eOpts ) {
            
            }
        },
        setItemData: function(record, dataClear) {
        	
        }
    });
    
    var masterGrid3 = Unilite.createGrid('s_zcc200skrv_kdGrid3', { 
        layout : 'fit',
        region:'south',
        split: true,
        flex: 1,
        title : '가공비',
        sortableColumns : false,  
        store: directMasterStore3,
        uniOpt: {
            useRowNumberer: false
        },
        features: [{		
			id: 'masterGridSubTotal', 
			ftype: 'uniGroupingsummary', 
			showSummaryRow: false
		},{
			id: 'masterGridTotal', 
			ftype: 'uniSummary', 
			showSummaryRow: true
		}],
        columns:  [
            {dataIndex : 'COMP_CODE',           width :100, hidden : true},
            {dataIndex : 'DIV_CODE',            width :140, hidden : true},
            {dataIndex : 'EST_NUM',             width :150, hidden : true},
            {dataIndex : 'EST_SEQ',             width :70, hidden : true},
            {dataIndex : 'GUBUN',               width :100, hidden : true},
            {dataIndex : 'GUBUN_CODE',          width :130,
            	summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
			       return Unilite.renderSummaryRow(summaryData, metaData, '', '②가공비 소계');
            	}
        	},
            {dataIndex : 'QTY_HH',              width :100},
            {dataIndex : 'PRICE_RATE',          width :100},
            {dataIndex : 'AMT_O',               width :100,summaryType:'sum',
            	summaryRenderer:function(value, summaryData, dataIndex, metaData ) {
			       return Unilite.renderSummaryRow(summaryData,metaData,'<div align="right">'+Ext.util.Format.number(value, '0,000')+'</div>','<div align="right">'+Ext.util.Format.number(value, '0,000')+'</div>');
            	}
            },
            {dataIndex : 'REMARK',              width :120}
        ],
        listeners: {
            beforeedit  : function( editor, e, eOpts ) {
            
            }
        },
        setItemData: function(record, dataClear) {
            
        }
    });    

    Unilite.Main( {
        borderItems:[{
            region:'center',
            layout: 'border',
            border : false,
            items:[
                panelResult, masterGrid,
                {
                    region : 'north',
                    xtype : 'container',
                    layout : 'fit',
                    items : [ subForm ]
                }, {
                    region : 'center',
                    xtype : 'container',
                    layout: {type: 'hbox', align: 'stretch'},
                    flex: 1,
                    items : [ masterGrid2,  masterGrid3]
                }
            ]   
        }
        ],
        id  : 's_zcc200skrv_kdApp',
        fnInitBinding : function() {
            panelResult.setValue('DIV_CODE', UserInfo.divCode);
            UniAppManager.setToolbarButtons(['save', 'newData','deleteAll'], false);
            this.setDefault();
        },
        onQueryButtonDown : function()  {
        	if(panelResult.setAllFieldsReadOnly(true) == false){
                return false;
            }
            directMasterStore1.loadStoreRecords();
//            UniAppManager.app.fnCalcFormTotal();
            UniAppManager.setToolbarButtons(['reset'], true);
        },
        onResetButtonDown: function() {
            panelResult.setAllFieldsReadOnly(false);
            panelResult.clearForm(); 
            
            masterGrid.getStore().loadData({});
            masterGrid2.getStore().loadData({});
            masterGrid3.getStore().loadData({});
            
            this.setDefault();
        },
        setDefault: function() {
            
            subForm.setValue('T3', 0);
            subForm.setValue('T4', 0);
            subForm.setValue('T4_1', 0);
            subForm.setValue('T5', 0);
            subForm.setValue('T6', 0);
            subForm.setValue('T6_1', 0);
            subForm.setValue('T7', 0);
            subForm.setValue('T8', 0);
            subForm.setValue('T9', 0);
            subForm.setValue('T10', 0);
            subForm.setValue('T11', 0);
            
            panelResult.setValue('DIV_CODE',    UserInfo.divCode);
            panelResult.setValue('FR_EST_DATE', UniDate.get('startOfMonth'));
            panelResult.setValue('TO_EST_DATE', UniDate.get('today'));
            UniAppManager.setToolbarButtons(['save'], false);
        },
        fnCalcFormTotal: function(t4_1, t6_1) {
            var result1 = directMasterStore2.sumBy(function(record, id) {       // 합계를 가지고 값구하기
                    return true;
                },
                ['AMT_O']
            );
            var result2 = directMasterStore3.sumBy(function(record, id) {       // 합계를 가지고 값구하기
                    return true;
                },
                ['AMT_O']
            );
            
            var t1 = 0;		//재료비 합
            var t2 = 0;		//가공비 합
            var t3 = 0;		//제조원가
            var t4 = 0;		//관리
            var t5 = 0;		//이윤
            var t6 = 0;		//소계
            var t7 = 0;		//총합계
            var t8 = 0;		//원가구성
            var t9 = 0;		//재료비
            var t10 = 0;		//가공비
            var t11 = 0;		//관리/이윤
            
            t1 = result1.AMT_O;
            t2 = result2.AMT_O;
            
            t3 = t1 + t2;
            
            if(Ext.isEmpty(t4_1)){
            	t4_1 = 10;
            }
            t4 = t3 * t4_1 / 100;
            
            t5 = t3 + t4;
            
            if(Ext.isEmpty(t6_1)){
            	t6_1 = 8;
            }
            t6 = t5 * t6_1 / 100;
            
            t7 = t5 + t6;
            
            t8 = 100;
            
            if(t7 == 0){
            	t9 = 0;
            }else{
            	t9 = t1 / t7 * 100;
            }
            
            if(t7 == 0){
            	t10 = 0;
            }else{
           		t10 = t2 / t7 * 100;
            }
            
            t11 = 100 - t9 - t10;
            
            subForm.setValue('T3', t3);
            subForm.setValue('T4', t4);
            
            subForm.setValue('T4_1', t4_1);
            
            subForm.setValue('T5', t5);
            subForm.setValue('T6', t6);
            
            subForm.setValue('T6_1', t6_1);
            
            subForm.setValue('T7', t7);
            subForm.setValue('T8', t8);
            subForm.setValue('T9', t9);
            subForm.setValue('T10', t10);
            subForm.setValue('T11', t11);
            
        },
        requestApprove: function(){     //결재 요청
            var gsWin = window.open('about:blank','payviewer','width=500,height=500');

            var frm         = document.f1;
            var record      = masterGrid.getSelectedRecord();
            var compCode    = UserInfo.compCode;
            var divCode     = panelResult.getValue('DIV_CODE');
            var estNum      = record.get('EST_NUM');
            var userId      = UserInfo.userID;
            var spText      = 'EXEC omegaplus_kdg.unilite.USP_GW_S_ZCC200UKRV_KD ' + "'" + compCode + "'" + ', ' + "'" + divCode + "'" + ', ' + "'" + estNum + "'";
            var spCall      = encodeURIComponent(spText);

/* //            frm.action = '/payment/payreq.php';
            frm.action   = groupUrl + "viewMode=docuDraft" + "&prg_no=s_zcc200ukrv_kd&draft_no=" + '0' + "&sp=" + spCall;
//            frm.action   = groupUrl + "&prg_no=s_str900skrv2_kd&draft_no=" + UserInfo.compCode + inoutNum + "&sp=" + spCall + Base64.encode();
            frm.target   = "payviewer";
            frm.method   = "post";
            frm.submit(); */

            var gwurl = groupUrl + "viewMode=docuDraft" + "&prg_no=s_zcc200ukrv_kd&draft_no=" + compCode + estNum +  "&sp=" + spCall;
			UniBase.fnGw_Call(gwurl,frm);
        }
    });
}
</script>


<form id="f1" name="f1" action="" method="post" onSubmit="return false;" >
<input type="hidden" id="loginid" name="loginid" value="superadmin" />
<input type="hidden" id="fmpf" name="fmpf" value="" />
<input type="hidden" id="fmbd" name="fmbd" runat="server" />
</form>