<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_pmr928rkrv_kd"  >
    <t:ExtComboStore comboType="BOR120"  pgmId="s_pmr928rkrv_kd"  />        <!-- 사업장 -->
    <t:ExtComboStore comboType="AU" comboCode="WZ31" />                     <!--구분-->
    <t:ExtComboStore comboType="AU" comboCode="B020" />                     <!-- 품목계정 -->
</t:appConfig>
<script type="text/javascript" >
var checkedCount = 0;   // 체크된 레코드

function appMain() {

    var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy', {
        api: {
            read: 's_pmr928rkrv_kdService.selectList'
        }
    });

    /**
     *   Model 정의
     * @type
     */
    Unilite.defineModel('s_pmr928rkrv_kdModel', {
        fields: [
            {name : 'COMP_CODE',            text : '법인코드',          type : 'string'},
            {name : 'DIV_CODE',             text : '사업장',           type : 'string', comboType:'BOR120'},
            {name : 'INOUT_SEQ',            text : '순번',            type : 'int'},
            {name : 'ITEM_CODE',            text : '품목코드',          type : 'string'},
            {name : 'ITEM_NAME',            text : '품목명',           type : 'string'},
            {name : 'SPEC',        text : '품번',            type : 'string'},
            {name : 'LOT_NO',               text : 'LOT번호',         type : 'string'},
            {name : 'GOOD_INSPEC_Q',        text : '검사실적량',        type : 'uniQty'},
            {name : 'NOT_INSTOCK_Q',        text : '미입고량',          type : 'uniQty'},
            {name : 'INSTOCK_Q',            text : '입고량',           type : 'uniQty'},
            {name : 'PRODT_NUM',            text : '생산실적번호',       type : 'string'},
            {name : 'WKORD_NUM',            text : '작업지시번호',       type : 'string'},
            {name : 'INSPEC_NUM',           text : '검사번호',          type : 'string'},
            {name : 'CHECK_YN',         text : '체크여부',      type : 'string'},
            
            {name : 'REMARK',         text : '비고',      type : 'string'}
        ]
    });

    /**
     * Store 정의(Service 정의)
     * @type
     */
    var directMasterStore = Unilite.createStore('s_pmr928rkrv_kdMasterStore1',{
        model: 's_pmr928rkrv_kdModel',
        uniOpt : {
            isMaster:  false,            // 상위 버튼 연결
            editable:  true,            // 수정 모드 사용
            deletable: false,            // 삭제 가능 여부
            useNavi :  false            // prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: directProxy,
        loadStoreRecords : function()   {
            var param = panelResult.getValues();
            this.load({
                  params : param
            });
        }
    }); // End of var directMasterStore1

    var panelResult = Unilite.createSearchForm('resultForm',{
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
                fieldLabel: '품목계정',
                name: 'ITEM_ACCOUNT',
                xtype: 'uniCombobox',
                allowBlank:true,
                comboType: 'AU',
                comboCode: 'B020'
            },{
                fieldLabel: '구분',
                name: 'GUBUN',
                xtype: 'uniCombobox',
                allowBlank:true,
                hidden:true,
                comboType: 'AU',
                comboCode: 'WZ31'
            },{
                fieldLabel: '기간',
                xtype: 'uniDateRangefield',
                startFieldName: 'FR_DATE',
                endFieldName: 'TO_DATE',
                startDate: UniDate.get('startOfMonth'),
                endDate: UniDate.get('today'),
                allowBlank:false,
                colspan : 2
            },{
                fieldLabel: '레코드(HIDDEN)',
                name:'COUNT',
                xtype: 'uniNumberfield',
                hidden: true
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

    var masterGrid = Unilite.createGrid('s_pmr928rkrv_kdmasterGrid', {
        layout : 'fit',
        region: 'center',
        store: directMasterStore,
        selModel: 'rowmodel',
        uniOpt: {
            expandLastColumn: false,
            useMultipleSorting: true,
            useGroupSummary: false,
            useLiveSearch: true,
            useContextMenu: true,
            useRowNumberer: true,
            onLoadSelectFirst   : false, //조회시 첫번째 레코드 select 사용여부
            filter: {
                useFilter: true,
                autoCreate: true
            }
        },
        tbar: [{
                xtype : 'button',
                id: 'printBtn',
                text:'출력',
                handler: function() {
                    var masterRecord = masterGrid.getSelectedRecord();
                    var count = masterGrid.getStore().getCount();
                    var param = panelResult.getValues();
					var lineSeq = '';
					if(count == 0) {
                        alert('출력할 항목을 선택 후 출력하십시오.');
                        return false;
                    }

                    Ext.each(directMasterStore.data.items, function(record, index) {
                    	if(record.data.CHECK_YN == 'Y'){
                    	 	if(index == 0) {
                        		lineSeq = record.get('BASIS_NUM') + record.get('INSPEC_NUM') + record.get('INSPEC_SEQ')
                        	}else {
                        	    lineSeq = lineSeq + ',' + record.get('BASIS_NUM') + record.get('INSPEC_NUM') + record.get('INSPEC_SEQ')
                        	}
                        	
                        	if(!Ext.isEmpty(record.get('REMARK'))){
                        		lineSeq = lineSeq + '|' + record.get('REMARK');
                        	}
                    	}
                    });

                    
					console.log(lineSeq);
                    param.PRODT_NUM   = masterRecord.get('PRODT_NUM');
                    param.INSPEC_NUM  = masterRecord.get('INSPEC_NUM');
                    param.LINE_SEQ = lineSeq;
                    
                    param["USER_LANG"] = UserInfo.userLang;
					param["PGM_ID"]= PGM_ID;
					param["MAIN_CODE"] = 'P010';//생산용 공통 코드
					
					var win = null;
					win = Ext.create('widget.ClipReport', {
						url: CPATH+'/z_kd/s_pmr928clrkrv_kd.do',
						prgID: 's_pmr928rkrv_kd',
						extParam: param
					});
					
                    win.center();
                    win.show();
                }
            }
        ],
     	selModel : Ext.create('Ext.selection.CheckboxModel', { checkOnly : true, toggleOnClick:false,
            listeners: {
                select: function(grid, selectRecord, index, rowIndex, eOpts ) {
                   // UniAppManager.setToolbarButtons(['save'], false);
       		       checkedCount = checkedCount + 1;
                    panelResult.setValue('COUNT', checkedCount);

                    selectRecord.set('CHECK_YN', 'Y');

                    if(panelResult.getValue('COUNT') > 0) {
                        Ext.getCmp('printBtn').setDisabled(false);
                    } else {
                        Ext.getCmp('printBtn').setDisabled(true);
                    }
                },
                deselect:  function(grid, selectRecord, index, eOpts ) {
                    //UniAppManager.setToolbarButtons(['save'], false);
               		 checkedCount = checkedCount - 1;
                    panelResult.setValue('COUNT', checkedCount);

                    selectRecord.set('CHECK_YN', '');

                    if(panelResult.getValue('COUNT') > 0) {
                        Ext.getCmp('printBtn').setDisabled(false);
                    } else {
                        Ext.getCmp('printBtn').setDisabled(true);
                    }
                }
            }
        }),
        columns:  [
            {dataIndex : 'COMP_CODE',           width : 120, hidden : true},
            {dataIndex : 'DIV_CODE',            width : 120, hidden : true},
            {dataIndex : 'INOUT_SEQ',           width : 100, hidden : true},
            {dataIndex : 'ITEM_CODE',           width : 120},
            {dataIndex : 'ITEM_NAME',           width : 140},
            {dataIndex : 'SPEC',       width : 130},
            {dataIndex : 'LOT_NO',              width : 130},
            {dataIndex : 'GOOD_INSPEC_Q',       width : 110},
            {dataIndex : 'NOT_INSTOCK_Q',       width : 110},
            {dataIndex : 'INSTOCK_Q',           width : 110},
            {dataIndex : 'PRODT_NUM',           width : 120, hidden : true},
            {dataIndex : 'WKORD_NUM',           width : 120, hidden : true},
            {dataIndex : 'INSPEC_NUM',          width : 120, hidden : true},
            {dataIndex : 'CHECK_YN',        	width : 100, hidden : true},
            
            {dataIndex : 'REMARK',           width : 200}
        ],
		
		listeners: {
	        beforeedit  : function( editor, e, eOpts ) {
				if(UniUtils.indexOf(e.field, ['REMARK'])){
					return true;
				}else{
					return false;
				}
        	}
		}
        
    });

    Unilite.Main( {
        borderItems:[{
            region:'center',
            layout: 'border',
            border: false,
            items:[
                masterGrid, panelResult
            ]
        }
        ],
        id  : 's_pmr928rkrv_kdApp',
        fnInitBinding : function() {
            this.setDefault();
        },
        onQueryButtonDown : function()  {
        	if(panelResult.setAllFieldsReadOnly(true) == false){
                return false;
            } else {
                directMasterStore.loadStoreRecords();
                UniAppManager.setToolbarButtons(['reset'], true);
            }
        },
        onResetButtonDown: function() {
            panelResult.setAllFieldsReadOnly(false);
            panelResult.clearForm();
            directMasterStore.clearData();
            masterGrid.reset();
            this.setDefault();
        },
        setDefault: function() {
        	
            UniAppManager.setToolbarButtons(['save', 'newData', 'deleteAll'], false);
            panelResult.setValue('DIV_CODE', UserInfo.divCode);
            panelResult.setValue('FR_DATE', UniDate.get('startOfMonth'));
            panelResult.setValue('TO_DATE', UniDate.get('today'));
            panelResult.setValue('ITEM_ACCOUNT', '10');
            Ext.getCmp('printBtn').setDisabled(true);  
        }
    });
}
</script>