<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="emi110skrv"  >
    <t:ExtComboStore comboType="BOR120"  pgmId="emi110skrv"  />             <!-- 사업장 -->  

</t:appConfig>
<script type="text/javascript" charset="UTF-8" src='<c:url value="/resources/plupload/plupload.full.js" />' >
</script>
<script type="text/javascript" >


function appMain() {
    
    var gubunStore = Unilite.createStore('gubunComboStore', {
        fields: ['text', 'value'],
        data :  [
            {'text':'A'  , 'value':'A'},
            {'text':'B'  , 'value':'B'},
            {'text':'C'  , 'value':'C'},
            {'text':'D'  , 'value':'D'},
            {'text':'E'  , 'value':'E'},
            {'text':'F'  , 'value':'F'},
            {'text':'G'  , 'value':'G'}
        ]
    });
    var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
        api: {
            read: 'emi110skrvService.selectList'
        }
    });
    
    /**
     *   Model 정의 
     * @type 
     */
    Unilite.defineModel('emi110skrvModel', {
        fields: [
            {name: 'COMP_CODE'      ,text:'법인코드'                 ,type: 'string'},
            {name: 'DIV_CODE'       ,text:'사업장'                   ,type: 'string'},
            {name: 'WH_CELL_NAME'       ,text:'cell'                   ,type: 'string'},
            {name: 'ITEM_CODE'		,text: '<t:message code="system.label.inventory.item" default="품목"/>',					type: 'string'},
			{name: 'ITEM_NAME'		,text: '<t:message code="system.label.inventory.itemname" default="품목명"/>',				type: 'string'},
			{name: 'SPEC'			,text: '<t:message code="system.label.inventory.spec" default="규격"/>',					type: 'string'},
			{name: 'STOCK_UNIT'		,text: '<t:message code="system.label.inventory.inventoryunit" default="재고단위"/>',		type: 'string'},
		    {name: 'STOCK_Q'       ,text:'현재고'                   ,type: 'uniQty'}

        ]
    }); 
    
    /**
     * Store 정의(Service 정의)
     * @type 
     */                 
    var directMasterStore = Unilite.createStore('emi110skrvMasterStore',{
        model: 'emi110skrvModel',
        uniOpt : {
            isMaster:  true,            // 상위 버튼 연결 
            editable:  false,            // 수정 모드 사용 
            deletable: false,            // 삭제 가능 여부 
            useNavi :  false            // prev | newxt 버튼 사용
        },
        autoLoad: false,
        proxy: directProxy,
        loadStoreRecords : function(param)   {   
            
            this.load({
                  params : param
            });         
        }
    });
    
    /**
     * 검색조건 (Search Panel)
     * @type 
     */ 
//    var panelResult = Unilite.createSearchForm('resultForm',{
//        region: 'north',
//        layout : {type : 'uniTable', columns : 14
////        	, tdAttrs: {style: 'border : 1px solid #ced9e7;'}
////			, tableAttrs: {width: '50%'}
//        },
//        padding:'1 1 1 1',
//        border:true,
//        items: [
//        	
//        {
//        	xtype:'component',
//        	width:30
//        
//        },	{
//        	xtype: 'button',
//        	width:100,
//        	text:'A',
//			margin:'10 0 10 0',
//            handler: function() {
//            	directMasterStore.loadStoreRecords('A');
//            }
//        },{
//        	xtype:'component',
//        	width:30
//        
//        },{
//        	xtype: 'button',
//        	text:'B',
//        	width:100,
//			margin:'10 0 10 0',
//            handler: function() {
//            	directMasterStore.loadStoreRecords('B');
//            }
//        },{
//        	xtype:'component',
//        	width:30
//        
//        },{
//        	xtype: 'button',
//        	text:'C',
//        	width:100,
//			margin:'10 0 10 0',
//            handler: function() {
//            	directMasterStore.loadStoreRecords('C');
//            }
//        },{
//        	xtype:'component',
//        	width:30
//        
//        },{
//        	xtype: 'button',
//        	text:'D',
//        	width:100,
//			margin:'10 0 10 0',
//            handler: function() {
//            	directMasterStore.loadStoreRecords('D');
//            }
//        },{
//        	xtype:'component',
//        	width:30
//        
//        },{
//        	xtype: 'button',
//        	text:'E',
//        	width:100,
//			margin:'10 0 10 0',
//            handler: function() {
//            	directMasterStore.loadStoreRecords('E');
//            }
//        },{
//        	xtype:'component',
//        	width:30
//        
//        },{
//        	xtype: 'button',
//        	text:'F',
//        	width:100,
//			margin:'10 0 10 0',
//            handler: function() {
//            	directMasterStore.loadStoreRecords('F');
//            }
//        },{
//        	xtype:'component',
//        	width:30
//        
//        },{
//        	xtype: 'button',
//        	text:'G',
//        	width:100,
//			margin:'10 0 10 0',
//            handler: function() {
//            	directMasterStore.loadStoreRecords('G');
//            }
//        }]
//    });
    var panelImage = Unilite.createSearchForm('resultForm',{
    	region: 'west',
    	width: 450,
//		layout : {type : 'vbox', columns : 1},
    	layout : {type : 'uniTable', columns : 1},
		padding:'0 0 0 0',
		margin:'0 0 0 0',
		border:true,
		items: [{
			xtype:'component',
			margin:'10 0 0 25',
			tdAttrs:{'align':'center'},
			html: '<img src="'+CPATH+'/resources/images/eis/wh_map2_KDG.jpg" width="400"">'
		},{
        	fieldLabel:' ',
        	name:'GUBUN',
        	xtype:'uniCombobox',
        	store:gubunStore
		},{
        	fieldLabel:'CELL',
        	name:'WH_CELL_CODE',
        	xtype:'uniTextfield'
		},
		Unilite.popup('DIV_PUMOK',{
            fieldLabel: '<t:message code="system.label.product.item" default="품목"/>',
            valueFieldName: 'ITEM_CODE',
            textFieldName: 'ITEM_NAME',
            listeners: {
                applyextparam: function(popup){
                    popup.setExtParam({'DIV_CODE': '01'});
                }
            }
		}),{
			fieldLabel: '재고수량',
			xtype: 'radiogroup',
			id: 'rdo',
			items: [{
				boxLabel	: '예',
				name		: 'RDO_GUBUN',
				inputValue	: '1',
				width		: 80
			},{
				boxLabel	: '아니오',
				name		: 'RDO_GUBUN',
				inputValue	: '2',
				width		: 80,
				checked: true
			}],
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					UniAppManager.app.setHiddenColumn(newValue.RDO_GUBUN);
				}
			}
		},{
        	xtype: 'button',
        	width:200,
        	text:'조회',
			margin:'10 0 10 100',
            handler: function() {
            	directMasterStore.loadStoreRecords(panelImage.getValues());
            }
        }
	]});
    var masterGrid = Unilite.createGrid('emi110skrvmasterGrid1', { 
        layout : 'fit',   
        region: 'center',                          
        store: directMasterStore,
        uniOpt: {
        	userToolbar :false,
            onLoadSelectFirst : false,
			useRowNumberer: false		//번호 컬럼 사용 여부		
        },
        selModel:'rowmodel',
        columns:  [  
        	{
				xtype: 'rownumberer', 
//				sortable:false, 
				//locked: true, 
				width: 80,
				align:'center  !important',
				resizable: true
			},
            { dataIndex: 'COMP_CODE'                                   ,           width: 80, hidden: true},
            { dataIndex: 'DIV_CODE'                                    ,           width: 80, hidden: true},
            { dataIndex: 'WH_CELL_NAME'	                               ,           width: 200},
            { dataIndex: 'ITEM_CODE'	                               ,           width: 150},
            { dataIndex: 'ITEM_NAME'	                               ,           width: 300},
            { dataIndex: 'SPEC'		                                   ,           width: 200},
            { dataIndex: 'STOCK_UNIT'                                  ,           width: 100, align:'center'},
            { dataIndex: 'STOCK_Q'		                               ,           width: 150,hidden:true}

        ] 
    });
    
    
    Unilite.Main( {
        borderItems:[{
                region:'center',
                layout: 'border',
                border: false,
                items:[
                    masterGrid, panelImage
                ]
            }   
        ],
        uniOpt:{
        	showToolbar: false
//        	forceToolbarbutton:true
        },
        id  : 'emi110skrvApp',
        fnInitBinding : function() {
//            panelResult.setValue('DIV_CODE',UserInfo.divCode);
            UniAppManager.setToolbarButtons(['save', 'newData','deleteAll'],false);
//            this.setDefault();
        },
        onQueryButtonDown : function()  {
            if(!panelResult.getInvalidMessage()) return;   //필수체크
        	directMasterStore.loadStoreRecords();
            UniAppManager.setToolbarButtons(['reset'], true);
        },
        onResetButtonDown: function() {
            panelResult.setAllFieldsReadOnly(false);
            panelResult.clearForm(); 
            directMasterStore.clearData(); 
            masterGrid.reset();
            this.setDefault();
        },
        setDefault: function() { 
            panelResult.setValue('DIV_CODE',UserInfo.divCode);
            panelResult.setValue('REQ_DATE_FR', UniDate.get('startOfMonth'));
            panelResult.setValue('REQ_DATE_TO', UniDate.get('today'));
        },
        setHiddenColumn: function(newValue) {
        	if(newValue == '1'){
                masterGrid.getColumn('STOCK_Q').setHidden(false);
            } else {
                masterGrid.getColumn('STOCK_Q').setHidden(true);
            }
        }               
    });                         
}
</script>