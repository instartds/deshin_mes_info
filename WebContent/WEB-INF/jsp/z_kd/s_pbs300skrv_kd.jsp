<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_pbs300skrv_kd">
	<t:ExtComboStore comboType="BOR120" />
	<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="B014" />
	<!-- 조달구분 -->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {
	color: #333333;
	font-weight: normal;
	padding: 1px 2px;
}
</style>
<script type="text/javascript">

function appMain() {
   
    /**
	 * Model 정의
	 * 
	 * @type
	 */
    Unilite.defineModel('s_pbs300skrv_kdModel', {  // 모델정의 - 디테일 그리드
        fields: [
			{name: 'COMP_CODE'                  		,text:'법인코드'        				,type:'string'},
			{name:'LVL'											, text: 'LEVEL'						, type: 'string'},
			{name: 'ITEM_CODE'							, text: '품목코드'					, type: 'string'},
			{name: 'ITEM_NAME'							, text: '품목명'						, type: 'string'},
			{name: 'SPEC'										, text: '규격'							, type: 'string'},
			{name: 'PROG_WORK_CODE'				, text: '공정코드'					, type:'string'},
			{name: 'PROG_WORK_NAME'				, text: '공정명'						, type: 'string'},
			{name: 'CHILD_SEQ'							, text: '순번'							, type: 'string'},
			{name: 'CHILD_ITEM_CODE'				, text: '투입자재코드'				, type: 'string'},
			{name: 'CHILD_ITEM_NAME'				, text: '투입자재명'				, type: 'string'},
			{name: 'CHILD_ITEM_SPEC'				, text: '자재 규격'				, type: 'string'},
			{name: 'UNIT_Q'									, text: '소요량'						, type: 'uniQty'},
			
        ]
    });
    
   /**
	 * Store 정의(Combobox)
	 * 
	 * @type
	 */                 
    var directMasterStore1 = Unilite.createStore('s_pbs300skrv_kdMasterStore1', {
        model: 's_pbs300skrv_kdModel',
        uniOpt: {
            isMaster: true,         // 상위 버튼 연결
            editable: false,         // 수정 모드 사용
            deletable: false,        // 삭제 가능 여부
            useNavi: false          // prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy:{
            type: 'direct',
            api: {          
                   read: 's_pbs300skrv_kdService.selectList'                    
            }
        },
        loadStoreRecords: function(){
            var param= Ext.getCmp('resultForm').getValues();            
            console.log(param);
            this.load({
                params: param
            });
        }
    });// End of var directMasterStore1
    
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
                holdable: 'hold',
                value: UserInfo.divCode,            
            },
            Unilite.popup('DIV_PUMOK',{ 
                fieldLabel: '품목', 
                valueFieldName: 'ITEM_CODE',
                textFieldName: 'ITEM_NAME',
                autoPopup: true,
                allowBlank:false,
                listeners: {
                	onSelected: {
    					fn: function(records, type) {
    						panelResult.setValue('ITEM_CODE', panelResult.getValue('ITEM_CODE'));
    						panelResult.setValue('ITEM_NAME', panelResult.getValue('ITEM_NAME'));				 																							
    					},
    					scope: this
    				},
    				onClear: function(type)	{
    					panelResult.setValue('ITEM_CODE', '');
    					panelResult.setValue('ITEM_NAME', '');
    				}
                }
          }),
          {
            	fieldLabel: '법인코드',
    	  	 	name:'COMP_CODE',
    	  	 	value: UserInfo.compCode,
    	  	 	hidden:true            
            }
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
    });// End of var panelSearch
    
    /**
	 * Master Grid1 정의(Grid Panel)
	 * 
	 * @type
	 */
    var masterGrid = Unilite.createGrid('s_pbs300skrv_kdGrid1', {      // detail그리드
        layout: 'fit',
        region: 'center',
        uniOpt: {
            expandLastColumn: false,
            useRowNumberer: true,
            copiedRow: true,
            onLoadSelectFirst: true
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
        store: directMasterStore1,
        selModel: 'rowmodel',
        columns: [
        	{dataIndex: 'LVL'      							, width: 50				,align:'center'},
        	{dataIndex: 'ITEM_CODE'       				, width: 110},
        	{dataIndex: 'ITEM_NAME'       				, width: 215},
        	{dataIndex: 'SPEC'       							, width: 120},
        	{dataIndex: 'PROG_WORK_CODE'       , width: 80},
        	{dataIndex: 'PROG_WORK_NAME'      , width: 150},
        	{dataIndex: 'CHILD_SEQ'       				, width: 50				,align:'right'},
        	{dataIndex: 'CHILD_ITEM_CODE'       	, width: 110},
        	{dataIndex: 'CHILD_ITEM_NAME'       , width: 150},
			{dataIndex: 'CHILD_ITEM_SPEC'       , width: 200},
        	{dataIndex: 'UNIT_Q'      						, width: 80				,format:'0,000.000000'},
        ]
    });// End of var masterGrid
    
    Unilite.Main( {
        border: false,
        borderItems:[{
                region:'center',
                layout: 'border',
                border: false,
                items:[
                       masterGrid,panelResult,     
        ]
        }],
        id: 's_pbs300skrv_kdApp',
        setDefault: function() {
            UniAppManager.setToolbarButtons(['save'], false);
        },
        fnInitBinding: function() {          
             panelResult.setValue('DIV_CODE',UserInfo.divCode);
            UniAppManager.setToolbarButtons(['reset'], true); // 초기화버튼 활성화여부
        },
        onQueryButtonDown: function() { // 조회
            if(panelResult.getValue('ITEM_CODE') != '' && panelResult.getValue('ITEM_NAME') != ''){
            	directMasterStore1.loadStoreRecords();
            	 } else if(panelResult.getValue('ITEM_CODE') == '' && panelResult.getValue('ITEM_NAME') == ''){
            		 alert('품목 필수입력값입니다!');
            		 return false;
            }else{
            	return false;
            } 
        },
        onResetButtonDown : function() { // 초기화
            panelResult.setAllFieldsReadOnly(false);
            masterGrid.reset();
            panelResult.clearForm();
            directMasterStore1.clearData();
            this.fnInitBinding();
        }
    });
 
};

</script>


