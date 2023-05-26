<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_mtr901skrv_kd"  >
    <t:ExtComboStore comboType="BOR120"  />             <!-- 사업장 -->
    <t:ExtComboStore comboType="AU" comboCode="B020" /> <!--품목계정-->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >

function appMain() {
    // var searchInfoWindow; // 검색창
    
    /**
	 * Model 정의
	 * 
	 * @type
	 */
    Unilite.defineModel('S_mtr901skrv_kdModel', {  // 모델정의 - 디테일 그리드
        fields: [
            {name : 'COMP_CODE',        text : '법인코드',  type : 'string'},
            {name : 'DIV_CODE',         text : '사업장',   type : 'string', comboType : 'BOR120'},
            {name : 'ORDER_DATE',       text : '발주일',   type : 'uniDate'}, 
            {name : 'ITEM_CODE',        text : '품목코드',  type : 'string'},                    
            {name : 'ITEM_NAME',        text : '품목명',   type : 'string'},
            {name : 'SPEC',             text : '규격',    type : 'string'},
            {name : 'ORDER_UNIT_Q',          text : '발주량',   type : 'uniQty'},
            {name : 'STOCK_UNIT',       text : '단위',    type : 'string'},
            {name : 'INSTOCK_Q',        text : '입고량',   type : 'uniQty'},
            {name : 'NOT_INSTOCK_Q',    text : '미입고량',  type : 'uniQty'},
            {name : 'ORDER_NUM',        text : '발주번호',  type : 'string'},
            {name : 'ORDER_SEQ',        text : '발주순번',  type : 'string'},
            {name : 'PO_REQ_NUM',       text : '요청번호',  type : 'string'},
            {name : 'PO_REQ_SEQ',       text : '요청순번',  type : 'string'}
        ]
    });
    
   /**
	 * Store 정의(Combobox)
	 * 
	 * @type
	 */                 
    var directMasterStore = Unilite.createStore('s_mtr901skrv_kdMasterStore1', {
        model: 'S_mtr901skrv_kdModel',
        uniOpt: {
            isMaster  : false,          // 상위 버튼 연결
            editable  : false,          // 수정 모드 사용
            deletable : false,          // 삭제 가능 여부
            useNavi   : false           // prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy:{
            type: 'direct',
            api: {          
                read: 's_mtr901skrv_kdService.selectList'                    
            }
        },
        loadStoreRecords: function(){
            var param= Ext.getCmp('resultForm').getValues();            
            console.log(param);
            this.load({
                params: param
            });
        }
    });// End of var directMasterStore

    /**
	 * 검색조건 (Search Result) - 상단조건
	 * 
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
            fieldLabel: '발주일',
            xtype: 'uniDateRangefield',
            startFieldName: 'FROM_DATE',
            endFieldName: 'TO_DATE',
            startDate: UniDate.get('startOfMonth'),
            endDate: UniDate.get('today'),
            allowBlank:false
        },{
            fieldLabel: '품목계정',
            name:'ITEM_ACCOUNT',
            xtype: 'uniCombobox',
            comboType:'AU',
            comboCode:'B020'
        },
        Unilite.popup('AGENT_CUST', { 
            fieldLabel: '거래처', 
            validateBlank: false,
            colspan:2
        }),
        Unilite.popup('DIV_PUMOK',{ 
            fieldLabel: '품목코드',
            valueFieldName: 'ITEM_CODE', 
            textFieldName: 'ITEM_NAME', 
            listeners: {
                applyextparam: function(popup){                         
                     popup.setExtParam({'DIV_CODE' : panelResult.getValue('DIV_CODE')});
                }
            }
        })
        ] ,
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
                    var fields = this.getForm().getFields();
                    Ext.each(fields.items, function(item) {
                        if(Ext.isDefined(item.holdable) )   {
                            if (item.holdable == 'hold') {
                                item.setReadOnly(true); 
                            }
                        } 
                        if(item.isPopupField)   {
                            var popupFC = item.up('uniPopupField')  ;                           
                            if(popupFC.holdable == 'hold') {
                                popupFC.setReadOnly(true);
                            }
                        }
                    })  
                }
            } else {
                var fields = this.getForm().getFields();
                Ext.each(fields.items, function(item) {
                    if(Ext.isDefined(item.holdable) )   {
                        if (item.holdable == 'hold') {
                            item.setReadOnly(false);
                        }
                    } 
                    if(item.isPopupField)   {
                        var popupFC = item.up('uniPopupField')  ;   
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
	 * 
	 * @type
	 */
    var masterGrid = Unilite.createGrid('s_mtr901skrv_kdGrid1', {      // detail그리드
        layout: 'fit',
        region: 'center',
        uniOpt: {
            expandLastColumn: true,
            useRowNumberer: true,
            copiedRow: true
            
        },
        store: directMasterStore,                                                                        
        columns: [
        	{dataIndex : 'COMP_CODE',       width : 100, hidden : true},
            {dataIndex : 'DIV_CODE',        width : 100, hidden : true},
            {dataIndex : 'ORDER_DATE',      width : 90, align : 'center'},  
            {dataIndex : 'ITEM_CODE',       width : 120}, 
            {dataIndex : 'ITEM_NAME',       width : 150}, 
            {dataIndex : 'SPEC',            width : 150},
            {dataIndex : 'ORDER_UNIT_Q',         width : 110},
            {dataIndex : 'STOCK_UNIT',      width : 80, align : 'center'},
            {dataIndex : 'INSTOCK_Q',       width : 110},
            {dataIndex : 'NOT_INSTOCK_Q',   width : 110},
            {dataIndex : 'ORDER_NUM',       width : 120},
            {dataIndex : 'ORDER_SEQ',       width : 80},
            {dataIndex : 'PO_REQ_NUM',      width : 120},
            {dataIndex : 'PO_REQ_SEQ',      width : 80}
        ]
    });// End of var masterGrid
    
    Unilite.Main( {
        border: false,
        borderItems:[{
            region:'center',
            layout: 'border',
            border: false,
            items:[
                masterGrid, panelResult
            ]
        }     
        ],
        id: 's_mtr901skrv_kdApp',
        fnInitBinding: function() {
            panelResult.setValue('DIV_CODE', UserInfo.divCode);
            panelResult.setValue('TO_DATE', UniDate.get('today'));
            panelResult.setValue('FROM_DATE', UniDate.get('startOfMonth', panelResult.getValue('TO_DATE')));
            
        },
        onQueryButtonDown: function() { // 조회
            if(panelResult.setAllFieldsReadOnly(true) == false){
                return false;
            }
            directMasterStore.clearData();
            directMasterStore.loadStoreRecords();
        },
        onResetButtonDown : function() { // 초기화
            panelResult.clearForm();
//            panelResult.setAllFieldsReadOnly(false);
            masterGrid.reset();
            
            directMasterStore.clearData();
            this.fnInitBinding();
        }
    });
 
};

</script>
