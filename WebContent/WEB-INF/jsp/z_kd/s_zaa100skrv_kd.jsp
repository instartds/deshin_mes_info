<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_zaa100skrv_kd"  >
    <t:ExtComboStore comboType="BOR120"  />             <!-- 사업장 -->  
    <t:ExtComboStore comboType="AU" comboCode="A020"/> <!-- 예/아니오 -->  
    <t:ExtComboStore items="${COMBO_WH_LIST}" storeId="whList" /><!--창고-->
    <t:ExtComboStore comboType="AU" comboCode="B024"/> <!-- 입고담당 -->  
    <t:ExtComboStore comboType="AU" comboCode="P003"/> <!-- 불량유형 --> 
    <t:ExtComboStore comboType="AU" comboCode="P002"/> <!-- 특기사항 분류 --> 
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>
<script type="text/javascript" >

var SearchInfoWindow; // 검색창

var BsaCodeInfo  = {
    gsAutoType: '${gsAutoType}'
};

var outDivCode = UserInfo.divCode;
var selectedMasterGrid = 's_zaa100skrv_kdGrid'; 

function appMain() {
	
	var isAutoOrderNum = false;
    if(BsaCodeInfo.gsAutoType=='Y') {
        isAutoOrderNum = true;
    }
    
    var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{     
        api: {
            read: 's_zaa100skrv_kdService.selectList'
        }
    });
    
    var directProxy2 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{     
        api: {
            read: 's_zaa100skrv_kdService.selectList2'
        }
    });
    
    Unilite.defineModel('pbs071ukrvsModel', {
        fields: [
            {name: 'COMP_CODE'         ,text:'법인코드'         ,type : 'string'},
            {name: 'DIV_CODE'          ,text:'사업장'           ,type : 'string', comboType:'BOR120'},
            {name: 'PLAN_NUM'          ,text:'계획번호'         ,type : 'string'},
            {name: 'ITEM_CODE'         ,text:'품목코드'         ,type : 'string'},
            {name: 'ITEM_NAME'         ,text:'품목명'           ,type : 'string'},
            {name: 'SPEC'              ,text:'규격'             ,type : 'string'},
            {name: 'OEM_ITEM_CODE'     ,text:'품번'             ,type : 'string'},
            {name: 'CAR_TYPE'          ,text:'차종'             ,type : 'string'},
            {name: 'MAKE_DATE'         ,text:'양산시점'         ,type : 'uniDate'},
            {name: 'PLAN_DATE'         ,text:'계획일'           ,type : 'uniDate'},
            {name: 'REMARK'            ,text:'비고'             ,type : 'string'}
        ]                   
    });
    
    Unilite.defineModel('pbs071ukrvs2Model', {
        fields: [
            {name: 'COMP_CODE'          ,text:'법인코드'        ,type : 'string'},
            {name: 'DIV_CODE'           ,text:'사업장'          ,type : 'string', comboType:'BOR120'},
            {name: 'PLAN_NUM'           ,text:'계획번호'        ,type : 'string'},
            {name: 'SER_NO'             ,text:'순번'            ,type : 'int'},
            {name: 'PLAN_BIZ1'          ,text:'계획업무'        ,type : 'string'},
            {name: 'PLAN_BIZ2'          ,text:'세부추진업무'    ,type : 'string'},
            {name: 'PLAN_ST_DATE'       ,text:'계획시작일'      ,type : 'uniDate'},
            {name: 'PLAN_END_DATE'      ,text:'계획종료일'      ,type : 'uniDate'},
            {name: 'DEPT_CODE'          ,text:'주관부서'        ,type : 'string'},
            {name: 'DEPT_NAME'          ,text:'주관부서명'      ,type : 'string'},
            {name: 'REMARK1'            ,text:'비고1'           ,type : 'string'},
            {name: 'EXEC_ST_DATE'       ,text:'실행시작일'      ,type : 'uniDate'},
            {name: 'EXEC_END_DATE'      ,text:'실행종료일'      ,type : 'uniDate'},
            {name: 'REMARK2'            ,text:'비고2'           ,type : 'string'}
        ]                   
    });
    // 스토어
    var directMasterStore = Unilite.createStore('directMasterStore',{
            model: 'pbs071ukrvsModel',
            autoLoad: false,
            uniOpt : {
                isMaster: true,         // 상위 버튼 연결 
                editable: false,         // 수정 모드 사용 
                deletable:false,         // 삭제 가능 여부 
                useNavi : false         // prev | next 버튼 사용
            },
            proxy : directProxy,
            loadStoreRecords : function(){
                var param= panelResult.getValues();          
                console.log(param);
                this.load({
                    params : param
                });
            }
    });
    // 공정수순 스토어
    var directMasterStore2 = Unilite.createStore('directMasterStore2',{
            model: 'pbs071ukrvs2Model',
            autoLoad: false,
            uniOpt : {
                isMaster: true,         // 상위 버튼 연결 
                editable: false,         // 수정 모드 사용 
                deletable:false,         // 삭제 가능 여부 
                useNavi : false         // prev | next 버튼 사용
            },
            proxy : directProxy2,
            loadStoreRecords : function(param){
                this.load({
                    params: param
                });
            }
    });
    
    var panelResult = Unilite.createSearchForm('resultForm',{
        hidden: !UserInfo.appOption.collapseLeftSearch,
        region: 'north',
        layout : {type : 'uniTable', columns : 2},
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
                fieldLabel: '작성일자',
                xtype: 'uniDateRangefield',
                allowBlank: false,
                startFieldName: 'PLAN_DATE_FR',
                endFieldName: 'PLAN_DATE_TO',
                startDate: UniDate.get('startOfMonth'),
                endDate: UniDate.get('today')
            },
            Unilite.popup('PLAN_NUM', {
                    fieldLabel: '계획번호', 
                    valueFieldName: 'PLAN_NUM',
                    textFieldName: 'PLAN_NUM', 
                    validateBlank: false,
                    listeners: {
                        applyextparam: function(popup){                         
                            popup.setExtParam({'DIV_CODE': UserInfo.divCode});
                        }
                    }
            }),
            Unilite.popup('DIV_PUMOK', {
                    fieldLabel: '품목코드', 
                    valueFieldName: 'ITEM_CODE',
                    textFieldName: 'ITEM_NAME', 
                    validateBlank: false,
                    listeners: {
                        applyextparam: function(popup){                         
                            popup.setExtParam({'DIV_CODE': UserInfo.divCode});
                        }
                    }
            })
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
            }
    }); 
    
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    var masterGrid = Unilite.createGrid('s_zaa100skrv_kdGrid', {
        layout : 'fit',
        region:'center',
        store : directMasterStore, 
        uniOpt:{    expandLastColumn: false,
                    useRowNumberer: true,
                    useMultipleSorting: true
        },
        selModel:'rowmodel',
        features: [ 
            {id: 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false},
            {id: 'masterGridTotal',    ftype: 'uniSummary',         showSummaryRow: false} 
        ],
        columns: [
            {dataIndex: 'COMP_CODE'                ,       width: 80, hidden: true},
            {dataIndex: 'DIV_CODE'                 ,       width: 80, hidden: true},
            {dataIndex: 'PLAN_NUM'                 ,       width: 100},
            {dataIndex: 'PLAN_DATE'                ,       width: 80},
            {dataIndex: 'ITEM_CODE'                ,       width: 110},
            {dataIndex: 'ITEM_NAME'                ,       width: 190},
            {dataIndex: 'SPEC'                     ,       width: 100},
            {dataIndex: 'OEM_ITEM_CODE'            ,       width: 100},
            {dataIndex: 'CAR_TYPE'                 ,       width: 100},
            {dataIndex: 'MAKE_DATE'                ,       width: 80},
            {dataIndex: 'REMARK'                   ,       width: 200}
        ],
        listeners :{
        	selectionchange:function( model1, selected, eOpts ){
                if(selected.length > 0) {
                    var record = selected[0];
                    var param= panelResult.getValues();    
                    param.PLAN_NUM = record.get('PLAN_NUM');
                    param.COMP_CODE = record.get('COMP_CODE');
                    param.DIV_CODE = record.get('DIV_CODE');
                    directMasterStore2.loadStoreRecords(param);
                }
            }
        }
    });
    
    var masterGrid2 = Unilite.createGrid('s_zaa100skrv_kdGrid2', {
        layout : 'fit',
        region:'south',
        store : directMasterStore2, 
        uniOpt:{    expandLastColumn: true,
                    useRowNumberer: true,
                    useMultipleSorting: true
        },
        features: [ 
            {id: 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false},
            {id: 'masterGridTotal',    ftype: 'uniSummary',         showSummaryRow: false} 
        ],
        columns: [
            {dataIndex: 'COMP_CODE'           ,       width: 100, hidden: true},
            {dataIndex: 'DIV_CODE'            ,       width: 100, hidden: true},
            {dataIndex: 'PLAN_NUM'            ,       width: 100, hidden: true},
            {dataIndex: 'SER_NO'              ,       width: 80},
            {dataIndex: 'PLAN_BIZ1'           ,       width: 180},
            {dataIndex: 'PLAN_BIZ2'           ,       width: 180},
            {dataIndex: 'PLAN_ST_DATE'        ,       width: 90},
            {dataIndex: 'PLAN_END_DATE'       ,       width: 90},
            {dataIndex: 'DEPT_CODE'           ,       width: 100},
            {dataIndex: 'DEPT_NAME'           ,       width:150},
            {dataIndex: 'REMARK1'             ,       width: 200},
            {dataIndex: 'EXEC_ST_DATE'        ,       width: 90},
            {dataIndex: 'EXEC_END_DATE'       ,       width: 90},
            {dataIndex: 'REMARK2'             ,       width: 200}
        ]
    });
    
    Unilite.Main( {
        borderItems:[{
            region:'center',
            layout: 'border',
            border : false,
            items:[
                masterGrid, masterGrid2, panelResult
            ]   
        }
        ],
        id: 's_zaa100skrv_kdApp',
        fnInitBinding: function() {
            UniAppManager.setToolbarButtons(['reset', 'prev', 'next', 'newData'], false);
            this.setDefault();
        },
        onQueryButtonDown: function() {
        	var param= panelResult.getValues();
            directMasterStore.loadStoreRecords();
            if(panelResult.setAllFieldsReadOnly(true) == false){
                return false;
            }
        	
            UniAppManager.setToolbarButtons('reset', true); 
        },
        onResetButtonDown: function() {
            panelResult.clearForm();
            masterGrid.reset();
            masterGrid2.reset();
            directMasterStore.clearData();
            directMasterStore2.clearData();
            this.fnInitBinding();  
        },
        setDefault: function() {
            panelResult.setValue('DIV_CODE', UserInfo.divCode);
            panelResult.setValue('PLAN_DATE_FR',UniDate.get('startOfMonth'));
            panelResult.setValue('PLAN_DATE_TO',UniDate.get('today'));
            panelResult.getForm().wasDirty = false;                                     
            UniAppManager.setToolbarButtons('save', false); 
        }
    });
}
</script>