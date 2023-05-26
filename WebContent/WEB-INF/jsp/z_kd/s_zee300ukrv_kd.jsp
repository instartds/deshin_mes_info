<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_zee300ukrv_kd"  >
    <t:ExtComboStore comboType="BOR120"  pgmId="s_zee300ukrv_kd"  />    <!-- 사업장 -->
    <t:ExtComboStore comboType="AU" comboCode="WZ10" />                 <!--장비구분-->
    <t:ExtComboStore comboType="AU" comboCode="WZ11" />                 <!--이관부서-->
    <t:ExtComboStore comboType="AU" comboCode="WZ12" />                 <!--사용-->
    <t:ExtComboStore comboType="AU" comboCode="WZ23" />                 <!--비품구분1-->
    <t:ExtComboStore comboType="AU" comboCode="WZ24" />                 <!--비품구분2-->
    <t:ExtComboStore comboType="AU" comboCode="WZ34" />                 <!--비품구분3-->
    <t:ExtComboStore comboType="AU" comboCode="B004"/>                  <!-- 화폐단위 -->
    <t:ExtComboStore items="${COMBO_QEQ_GUBUN2}" storeId="comboQeqGubun2Store" />
	<t:ExtComboStore items="${COMBO_QEQ_GUBUN3}" storeId="comboQeqGubun3Store" />
	
</t:appConfig>
<script type="text/javascript" >

var BsaCodeInfo = {     //컨트롤러에서 값을 받아옴.
    gsAutoType  :   '${gsAutoType}',
    gsMoneyUnit :   '${gsMoneyUnit}'
};

function appMain() {
    
    var groupUrl = '${groupUrl}'; //그룹웨어 호출 url
    
    var isAutoOrderNum = false;
    if(BsaCodeInfo.gsAutoType=='Y') {
        isAutoOrderNum = true;
    }
    
    var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy', {
        api: {
            read: 's_zee300ukrv_kdService.selectList',
            update: 's_zee300ukrv_kdService.updateDetail',
            create: 's_zee300ukrv_kdService.insertDetail',
            destroy: 's_zee300ukrv_kdService.deleteDetail',
            syncAll: 's_zee300ukrv_kdService.saveAll'
        }
    });
    
    /**
     *   Model 정의 
     * @type 
     */
    Unilite.defineModel('s_zee300ukrv_kdModel', {
        fields: [
            {name : 'COMP_CODE',        text : '법인코드',              type : 'string'},
            {name : 'DIV_CODE',         text : '사업자코드',             type : 'string'},
            {name : 'OEQ_CODE',         text : '비품코드',              type : 'string', allowBlank: isAutoOrderNum},
            {name : 'OEQ_GUBUN1',       text : '비품구분1',             type : 'string', comboType: 'AU', comboCode: 'WZ23', allowBlank : false},
            {name : 'OEQ_GUBUN2',       text : '비품구분2',             type : 'string', comboType: 'AU', comboCode: 'WZ24', allowBlank : false, child: 'OEQ_GUBUN3'},
            {name : 'OEQ_GUBUN3',       text : '비품구분3',             type : 'string', store: Ext.data.StoreManager.lookup('comboQeqGubun3Store'), allowBlank : false,parentNames:['OEQ_GUBUN2']}, 
            {name : 'MGM_DEPT_CODE',    text : '관리부서',              type : 'string', comboType : 'AU', comboCode : 'WZ35', allowBlank : false},
            {name : 'INS_DEPT_CODE',        text : '설치부서',          type : 'string', comboType : 'AU', comboCode : 'WZ36'},
            {name : 'OEQ_NAME',         text : '집기비품명',             type : 'string', allowBlank : false},
			{name : 'OEQ_SPEC',         text : '규격',                type : 'string'},
            {name : 'MGM_NUM',          text : '관리번호',              type : 'string'},
            {name : 'BUY_DATE',         text : '취득일자',              type : 'uniDate'},
            
            {name : 'BUY_CN',          text : '구입업체',              type : 'string'},
            
            {name : 'BUY_QTY',          text : '수량',				type: 'float', decimalPrecision: 0, format:'0,000'},
            {name : 'STOCK_UNIT',       text : '단위',                type : 'string'},
            {name : 'BUY_P',            text : '취득단가',				type: 'float', decimalPrecision: 0, format:'0,000'},
            {name : 'BUY_O',            text : '취득금액',				type: 'float', decimalPrecision: 0, format:'0,000'},
            {name : 'MGM_LOCATION',     text : '보관장소',              type : 'string'},
            {name : 'TRANS_DATE',       text : '이관일자',              type : 'uniDate'},
            {name : 'TRANS_DEPT_CODE',  text : '이관부서',              type : 'string', comboType : 'AU', comboCode : 'WZ36'},
            {name : 'USE_YN',           text : '사용',                type : 'string', comboType: 'AU', comboCode: 'WZ12'},
            {name : 'DISP_DATE',            text : '폐기일자',          type : 'uniDate'},
            {name : 'REMARK',           text : '비고',                type : 'string'}
        ]
    }); 
    
    /**
     * Store 정의(Service 정의)
     * @type 
     */                 
    var directMasterStore = Unilite.createStore('s_zee300ukrv_kdMasterStore1', {
        model: 's_zee300ukrv_kdModel',
        uniOpt : {
            isMaster:  true,            // 상위 버튼 연결 
            editable:  true,            // 수정 모드 사용 
            deletable: true,            // 삭제 가능 여부 
            useNavi :  false            // prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: directProxy,
        loadStoreRecords : function() {
            var param = panelResult.getValues();
            this.load({
                  params : param
            });         
        },
        saveStore: function() {
            var inValidRecs = this.getInvalidRecords();
            var toCreate = this.getNewRecords();
            var toUpdate = this.getUpdatedRecords();                
            var toDelete = this.getRemovedRecords();
            var list = [].concat(toUpdate, toCreate);
            
            //1. 마스터 정보 파라미터 구성
            var paramMaster = panelResult.getValues();    //syncAll 수정

            if(inValidRecs.length == 0) {
                config = {
                    params: [paramMaster],
                    success: function(batch, option) {
            			directMasterStore.loadStoreRecords();
                    } 
                };
                this.syncAllDirect(config);
            } else {
                masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
            }
        }
    }); // End of var directMasterStore1 
    
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
                allowBlank : false,
                value: UserInfo.divCode
            },{
                fieldLabel: '사용',
                name:'USE_YN',
                xtype: 'uniCombobox',
                comboType:'AU',
                comboCode:'WZ12'
            },{ 
                fieldLabel: '취득일자',
                xtype: 'uniDateRangefield',
                startFieldName: 'FR_BUY_DATE',
                endFieldName: 'TO_BUY_DATE',
                startDate: UniDate.get('startOfMonth'),
                endDate: UniDate.get('today'),
                colspan:2
            },{
                fieldLabel: '관리부서',
                name:'MGM_DEPT_CODE',
                xtype: 'uniCombobox',
                comboType:'AU',
                comboCode:'WZ35'
            },{
                fieldLabel: '설치부서',
                name:'INS_DEPT_CODE',
                xtype: 'uniCombobox',
                comboType:'AU',
                comboCode:'WZ36'
            },{
                fieldLabel: '비품구분1',
                name:'OEQ_GUBUN1',
                xtype: 'uniCombobox',
                comboType:'AU',
                comboCode:'WZ23'
            },{
                fieldLabel: '비품구분2',
                name:'OEQ_GUBUN2',
                xtype: 'uniCombobox',
                comboType:'AU',
                comboCode:'WZ24', 
                child: 'OEQ_GUBUN3'
            },{
                fieldLabel: '비품코드',
                name:'OEQ_CODE',
                xtype: 'uniTextfield',
//                readOnly: isAutoOrderNum,
                holdable: isAutoOrderNum ? 'readOnly':'hold'
            }, {
                fieldLabel: '집기비품명',
                name:'OEQ_NAME',
                xtype: 'uniTextfield'
            }, {
                fieldLabel: '보관장소',
                name:'MGM_LOCATION',
                xtype: 'uniTextfield'
            },{
                fieldLabel: '비품구분3',
                name:'OEQ_GUBUN3',
                xtype: 'uniCombobox',
                store: Ext.data.StoreManager.lookup('comboQeqGubun3Store')
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
            me.uniOpt.inLoading = false;
            me.setAllFieldsReadOnly(true);
        }
    });
    
    var masterGrid = Unilite.createGrid('s_zee300ukrv_kdmasterGrid', { 
        layout : 'fit',   
        region: 'center',                          
        store: directMasterStore,
        uniOpt: {
            expandLastColumn: false,
            useMultipleSorting: true,
            useGroupSummary: false,
            useLiveSearch: true,
            useRowNumberer: false,
			copiedRow : true,
            filter: {
                useFilter: true,
                autoCreate: true
            }
        },
        tbar: [{
                xtype : 'button',
                text:'기안',
                id: 'GW',
                handler: function() {
                    if(panelResult.setAllFieldsReadOnly(true) == false){
                        return false;
                    }
                    UniAppManager.app.requestApprove();
                }
            }
        ],
        columns:  [ 
            {dataIndex : 'COMP_CODE',           width : 130, hidden : true},
            {dataIndex : 'DIV_CODE',            width : 130, hidden : true},
            {dataIndex : 'OEQ_CODE',            width : 110},
            {dataIndex : 'OEQ_GUBUN1',          width : 100},
            {dataIndex : 'OEQ_GUBUN2',          width : 100},
            {dataIndex : 'OEQ_GUBUN3',          width : 100,
		        renderer:function(value, metaData, record, rowIndex, colIndex, store, combo) {
	                combo.store.clearFilter();
	                combo.store.filter('option', record.get('OEQ_GUBUN2'));
                }
		    },
            {dataIndex : 'MGM_DEPT_CODE',          width : 100},
            {dataIndex : 'INS_DEPT_CODE',          width : 100},
            {dataIndex : 'OEQ_NAME',            width : 130},
            {dataIndex : 'OEQ_SPEC',               width : 100},
            {dataIndex : 'MGM_NUM',                width : 100},
            {dataIndex : 'BUY_DATE',               width : 100},
            {dataIndex : 'BUY_CN',               width : 100},
            {dataIndex : 'BUY_QTY',                width : 100},
            {dataIndex : 'STOCK_UNIT',             width : 100},
            {dataIndex : 'BUY_P',                  width : 100},
            {dataIndex : 'BUY_O',                  width : 100},
            {dataIndex : 'MGM_LOCATION',           width : 100},
            {dataIndex : 'TRANS_DATE',             width : 100},
            {dataIndex : 'TRANS_DEPT_CODE',     width : 110},
            {dataIndex : 'USE_YN',              width : 60},
            {dataIndex : 'DISP_DATE',          width : 100},
            {dataIndex : 'REMARK',              width : 150}
        ],
        listeners: {
            beforeedit  : function( editor, e, eOpts ) {
                if(UniUtils.indexOf(e.field, ['COMP_CODE','DIV_CODE','OEQ_CODE', 'BUY_O'])){ 
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
                items:[{
                        region : 'center',
                        xtype : 'container',
                        layout : 'fit',
                        items : [ masterGrid ]
                    },
                    panelResult
                ]
            }
        ],
        id : 's_zee300ukrv_kdApp',
        fnInitBinding : function() {
            panelResult.setValue('DIV_CODE',UserInfo.divCode);
            UniAppManager.setToolbarButtons(['save', 'newData','deleteAll'], false);
            UniAppManager.setToolbarButtons('newData', true);
            this.setDefault();
        },
        onQueryButtonDown : function()  {
            if(panelResult.setAllFieldsReadOnly(true) == false) {
                return false;
            }
            directMasterStore.loadStoreRecords();
            UniAppManager.setToolbarButtons(['reset'], true);
        },
        onResetButtonDown: function() {
            panelResult.setAllFieldsReadOnly(false);
            panelResult.clearForm();
            masterGrid.reset();
//            Ext.getCmp('GW').setDisabled(true);
            this.setDefault();
        },
        onNewDataButtonDown: function() {       // 행추가
            var compCode    = UserInfo.compCode; 
            var divCode     = panelResult.getValue('DIV_CODE');
            var buyDate     = UniDate.get('today');
            var moneyUnit   = BsaCodeInfo.gsMoneyUnit;
            var excheRateO  = 1;
            
            var r = {
                COMP_CODE    : compCode,
                DIV_CODE     : divCode,
                BUY_DATE     : buyDate,
                MONEY_UNIT   : moneyUnit,
                EXCHG_RATE_O : excheRateO,
                USE_YN : '1'
            };
            masterGrid.createRow(r);
        },
        onDeleteDataButtonDown: function() {
            var record = masterGrid.getSelectedRecord();
            
            if(record.phantom === true) {
                masterGrid.deleteSelectedRow();
            } else {
                if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
                    masterGrid.deleteSelectedRow();
                }
            }
        },
        onSaveDataButtonDown: function () {
            directMasterStore.saveStore();
        },
        requestApprove: function(){     //결재 요청
            var gsWin = window.open('about:blank','payviewer','width=500,height=500'); 
            
            var frm         = document.f1;
            var compCode    = UserInfo.compCode;
            var divCode     = panelResult.getValue('DIV_CODE');
            var useYN       = panelResult.getValue('USE_YN');
            if(Ext.isEmpty(useYN)) {
            	useYN = '';
            }
//            var frDate      = UniDate.getDbDateStr(panelResult.getValue('FR_BUY_DATE'));
//            var toDate      = UniDate.getDbDateStr(panelResult.getValue('TO_BUY_DATE'));
//            
            if(Ext.isEmpty(panelResult.getValue('FR_BUY_DATE'))) {
                var frDate = '';
            } else {
                var frDate = UniDate.getDbDateStr(panelResult.getValue('FR_BUY_DATE'));
            }
            if(Ext.isEmpty(panelResult.getValue('TO_BUY_DATE'))) {
                var toDate = '';
            } else {
                var toDate = UniDate.getDbDateStr(panelResult.getValue('TO_BUY_DATE'));
            }
            
            if(Ext.isEmpty(panelResult.getValue('MGM_DEPT_CODE'))) {
                var mgmdeptCode = '';
            } else {
                var mgmdeptCode = panelResult.getValue('MGM_DEPT_CODE'); 
            }
            if(Ext.isEmpty(panelResult.getValue('OEQ_CODE'))) {
                var oeqCode     = '';
            } else {
                var oeqCode     = panelResult.getValue('OEQ_CODE'); 
            }
            if(Ext.isEmpty(panelResult.getValue('OEQ_NAME'))) {
                var oeqName     = '';
            } else {
                var oeqName     = panelResult.getValue('OEQ_NAME'); 
            }
            
            
            
            if(Ext.isEmpty(panelResult.getValue('INS_DEPT_CODE'))) {
                var insDeptCode     = '';
            } else {
                var insDeptCode     = panelResult.getValue('INS_DEPT_CODE'); 
            }
            if(Ext.isEmpty(panelResult.getValue('OEQ_GUBUN1'))) {
                var oeqGubun1     = '';
            } else {
                var oeqGubun1     = panelResult.getValue('OEQ_GUBUN1'); 
            }
            if(Ext.isEmpty(panelResult.getValue('OEQ_GUBUN2'))) {
                var oeqGubun2     = '';
            } else {
                var oeqGubun2     = panelResult.getValue('OEQ_GUBUN2'); 
            }
            if(Ext.isEmpty(panelResult.getValue('OEQ_GUBUN3'))) {
                var oeqGubun3     = '';
            } else {
                var oeqGubun3     = panelResult.getValue('OEQ_GUBUN3'); 
            }
            if(Ext.isEmpty(panelResult.getValue('MGM_LOCATION'))) {
                var mgmLocation     = '';
            } else {
                var mgmLocation     = panelResult.getValue('MGM_LOCATION'); 
            }
            
            var spText      = 'EXEC omegaplus_kdg.unilite.USP_GW_S_ZEE300UKRV_KD ' + "'" + compCode + "'" + ', ' + "'" + divCode + "'" + ', ' + "'" + useYN + "'" + ', ' + "'" + frDate + "'" + ', ' + "'" + toDate + "'" + ', ' + "'" + mgmdeptCode + "'" + ', ' + "'" + oeqCode + "'" + ', ' + "'" + oeqName + "'"
            																+ ', ' + "'" + insDeptCode + "'"+ ', ' + "'" + oeqGubun1 + "'"+ ', ' + "'" + oeqGubun2 + "'"+ ', ' + "'" + oeqGubun3 + "'"+ ', ' + "'" + mgmLocation + "'";
            var spCall      = encodeURIComponent(spText); 
            
/* //            frm.action = '/payment/payreq.php';
            frm.action   = groupUrl + "viewMode=docuDraft" + "&prg_no=s_zee300ukrv_kd&draft_no=" + '0' + "&sp=" + spCall;
//            frm.action   = groupUrl + "&prg_no=s_zee300ukrv_kd&draft_no=" + UserInfo.compCode + inoutNum + "&sp=" + spCall + Base64.encode();
            frm.target   = "payviewer"; 
            frm.method   = "post";
            frm.submit(); */
            
            var gwurl = groupUrl + "viewMode=docuDraft" + "&prg_no=s_zee300ukrv_kd&draft_no=" + '0' + "&sp=" + spCall;
            UniBase.fnGw_Call(gwurl,frm); 
        },
        setDefault: function() {
            directMasterStore.clearData();
            panelResult.setValue('DIV_CODE',UserInfo.divCode);
            panelResult.setValue('FR_BUY_DATE', UniDate.get('startOfMonth'));
            panelResult.setValue('TO_BUY_DATE', UniDate.get('today'));
            panelResult.getForm().wasDirty = false;
            UniAppManager.setToolbarButtons(['save'], false);
        }
    });    
    
    
    Unilite.createValidator('validator01', {
		store: directMasterStore,
		grid: masterGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
		console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			switch(fieldName) {
				case "BUY_QTY" :
					record.set('BUY_O', newValue * record.get('BUY_P'))
				break;

				case "BUY_P" :
					record.set('BUY_O', newValue * record.get('BUY_QTY'))
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