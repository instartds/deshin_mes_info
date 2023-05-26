<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_ryt200skrv_kd"  >
    <t:ExtComboStore comboType="BOR120"  pgmId="s_ryt200skrv_kd"  />             <!-- 사업장 -->  
    <t:ExtComboStore comboType="AU" comboCode="WR01" /> <!--비율단가구분-->  
    <t:ExtComboStore comboType="AU" comboCode="WR02" /> <!--프로젝트타입-->  
    <t:ExtComboStore comboType="AU" comboCode="WR03" /> <!--작업반기-->
</t:appConfig>

<script type="text/javascript">

var BsaCodeInfo = {     //컨트롤러에서 값을 받아옴.
    gsBalanceOut:        '${gsBalanceOut}'
};

function appMain() {
    
    var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
        api: {
            read: 's_ryt200skrv_kdService.selectList'
        }
    });
    
    Unilite.defineModel('s_ryt200skrv_kdModel', {
        fields: [
            {name: 'COMP_CODE',             text: '법인코드',       type : 'string'},
            {name: 'DIV_CODE',              text: '사업장',        type : 'string', comboType : "BOR120"},
            {name: 'ITEM_CODE',             text: '품목코드',       type : 'string'},
            {name: 'ITEM_NAME',             text: '품목명',        type : 'string'},
            {name: 'OEM_ITEM_CODE',         text: '품번',          type : 'string'},
            {name: 'ITEM_GROUP',            text: '대표코드',       type : 'string'},
            {name: 'CON_FR_YYMM',           text: '개시월',        type : 'string'},
            {name: 'CON_TO_YYMM',           text: '종료월',        type : 'string'},
            {name: 'RATE_N',                text: '비율',          type : 'uniPercent'},
            {name: 'PJT_TYPE',              text: '프로젝트구분',    type : 'string', comboType : 'AU', comboCode : 'WR02'}
        ]
    }); 
    
    var directMasterStore = Unilite.createStore('s_ryt200skrv_kdMasterStore',{
        model: 's_ryt200skrv_kdModel',
        uniOpt : {
            isMaster: true,          // 상위 버튼 연결 
            editable: false,         // 수정 모드 사용 
            deletable:false,         // 삭제 가능 여부 
            useNavi : false          // prev | newxt 버튼 사용
        },
        expanded : false,
        autoLoad: false,
        proxy: directProxy,
        loadStoreRecords : function()   {   
            var param= panelResult.getValues();
            this.load({
                  params : param
            });         
        },
        listeners: {
            load:function( store, records, successful, operation, eOpts ) {

            }
        }
    });     
    
    //panelResult(검색조건)
    var panelResult = Unilite.createSearchForm('resultForm', {
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
            },
            Unilite.popup('AGENT_CUST', {
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
            }),
            	{fieldLabel: '계약일',
                name:'CON_DATE', 
                xtype: 'uniDatefield',
                allowBlank:false,
                value: UniDate.get('today')
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
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    var masterGrid = Unilite.createGrid('s_ryt200skrv_kdmasterGrid', { 
        layout : 'fit',   
        region: 'center',                          
        store: directMasterStore,
        uniOpt: {
            expandLastColumn: false,
            useMultipleSorting: true,
            useGroupSummary: false,
            useLiveSearch: true,
            useContextMenu: true,
            filter: {
                useFilter: true,
                autoCreate: true
            }
        },
        tbar: [{
            xtype: 'button',
            text: '출력',
            margin:'0 0 0 100',
            handler: function() {
                if(panelResult.setAllFieldsReadOnly(true) == false) {
                    return false;
                }
                
                var param = panelResult.getValues();
                
                param.DIV_CODE      = panelResult.getValue('DIV_CODE');
                param.CUSTOM_CODE   = panelResult.getValue('CUSTOM_CODE');
                param.CON_DATE      = panelResult.getValue('CON_DATE');
                
                var win = Ext.create('widget.CrystalReport', {
                    url: CPATH+'/z_kd/s_ryt200cskrv_kd.do',
                    prgID: 's_ryt200cskrv_kd',
                        extParam: param
                });
                win.center();
                win.show();
            } 
        }],
        columns:  [
            {dataIndex : 'COMP_CODE',       width : 120, hidden : true},
            {dataIndex : 'DIV_CODE',        width : 120},
            {dataIndex : 'ITEM_CODE',       width : 120},
            {dataIndex : 'ITEM_NAME',       width : 180},
            {dataIndex : 'OEM_ITEM_CODE',   width : 120},
            {dataIndex : 'ITEM_GROUP',      width : 120},
            {dataIndex : 'CON_FR_YYMM',     width : 80, align : 'center'},
            {dataIndex : 'CON_TO_YYMM',     width : 80, align : 'center'},
            {dataIndex : 'RATE_N',          width : 90},
            {dataIndex : 'PJT_TYPE',        width : 110}
        ],               
        listeners: {

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
        }],
        id  : 's_ryt200skrv_kdApp',
        fnInitBinding : function() {
            panelResult.clearForm(); 
            directMasterStore.clearData();
            this.setDefault();
        },
        onQueryButtonDown : function()  {
        	if(panelResult.setAllFieldsReadOnly(true) == false){
                return false;
            }
            
            directMasterStore.loadStoreRecords();
            UniAppManager.setToolbarButtons('reset', true);
        },
        onResetButtonDown: function() {
            panelResult.setAllFieldsReadOnly(false);
            masterGrid.reset();
            this.fnInitBinding();
        },
        setDefault: function() {
            panelResult.setValue('DIV_CODE', UserInfo.divCode);
            panelResult.setValue('CON_DATE', new Date());
        }
    });
};

</script>