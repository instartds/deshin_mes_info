<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="mrp600skrv"  >	
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="M405" /> <!-- 메시지 코드 -->
	<t:ExtComboStore comboType="AU" comboCode="M407" /> <!-- 유형 -->	
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >

function appMain() {
	/**
	 *   Model 정의 
	 * @type 
	 */
	Unilite.defineModel('Mrp600skrvModel', {
	    fields: [  	 
	    	{name: 'MSG_CODE'		,text:'<t:message code="system.label.purchase.massage" default="메시지"/>'			         ,type:'string',comboType:'AU', comboCode:'M405'},
	    	{name: 'MSG_TYPE'		,text:'<t:message code="system.label.purchase.type3" default="유형"/>'				     ,type:'string',comboType:'AU', comboCode:'M407'},
	    	{name: 'MSG_DESC'		,text:'<t:message code="system.label.purchase.messagedesc" default="메시지 설명"/>'			     ,type:'string'},
	    	{name: 'ACTION_MSG'		,text:'<t:message code="system.label.purchase.actioncontents" default="조치내역"/>'			     ,type:'string'},
	    	{name: 'PRG_INFO1'		,text:'<t:message code="system.label.purchase.referprogram" default="관련 프로그램"/>'		     ,type:'string'},
	    	{name: 'PRG_INFO2'		,text:'<t:message code="system.label.purchase.referprogram" default="관련 프로그램"/>[프리폼]'	 ,type:'string'},
	    	{name: 'MSG_ID'			,text:'<t:message code="system.label.purchase.massage" default="메시지"/> ID'			     ,type:'string'}		   
		]
	});		// end of Unilite.defineModel('Mrp600skrvModel', {
	
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore1 = Unilite.createStore('mrp600skrvMasterStore1',{
			model: 'Mrp600skrvModel',
			uniOpt : {
            	isMaster: false,			// 상위 버튼 연결 
            	editable: false,			// 수정 모드 사용 
            	deletable:false,			// 삭제 가능 여부 
	            useNavi : false			// prev | newxt 버튼 사용
	            	//비고(*) 사용않함
            },
            autoLoad: false,
            proxy: {
                type: 'direct',
                api: {			
                	   read: 'mrp600skrvService.selectList'                	
                }
            }
			,loadStoreRecords : function()	{
				var param= Ext.getCmp('searchForm').getValues();
                param.DIV_CODE = UserInfo.divCode;			
				console.log( param );
				this.load({
					params : param
				});
				
			}			
	});		// end of var directMasterStore1 = Unilite.createStore('mrp600skrvMasterStore1',{

	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */
    var panelSearch = Unilite.createSearchPanel('searchForm', {		
		title: '<t:message code="system.label.purchase.searchconditon" default="검색조건"/>',
        defaultType: 'uniSearchSubPanel',
		items: [{	
			title: '<t:message code="system.label.purchase.basisinfo" default="기본정보"/>', 	
   			itemId: 'search_panel1',
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',
	         items: [{
	         	fieldLabel: '<t:message code="system.label.purchase.mrpcontrolnum" default="MRP 전개번호"/>'	,
	         	name: 'MRP_CONTROL_NUM', 
	         	xtype: 'uniTextfield',
	         	readOnly: true
	         },{
		         fieldLabel: '<t:message code="system.label.purchase.massage" default="메시지"/>',
		         name: 'MSG_CODE', 
		         xtype: 'uniCombobox', 
		         comboType: 'AU',
		         comboCode: 'M405',
		         width: 300
	         },{
		         fieldLabel: '<t:message code="system.label.purchase.type3" default="유형"/>',
		         name: 'MSG_TYPE',
		         xtype: 'uniCombobox',
		         comboType: 'AU',
		         comboCode: 'M407'
	         },{
		         fieldLabel: 'MRP <t:message code="system.label.purchase.charger" default="담당자"/>',
		         name: 'PLAN_PSRN_NAME', 
		         xtype: 'uniTextfield',
	         	readOnly: true
	         },{
		         fieldLabel: '<t:message code="system.label.purchase.basisdate" default="기준일"/>',
		         name: 'BASE_DATE', 
		         xtype: 'uniTextfield',
	         	readOnly: true
	         },{
		         fieldLabel: '<t:message code="system.label.purchase.confirmdate" default="확정일"/>',
		         name: 'FIRM_DATE',
		         xtype: 'uniTextfield',
	         	readOnly: true
	         },{
		         fieldLabel: '<t:message code="system.label.purchase.forecastdate" default="예시일"/>',
		         name: 'PLAN_DATE',
		         xtype: 'uniTextfield',
	         	readOnly: true
	         },{
				 fieldLabel: '<t:message code="system.label.purchase.availableinventoryapply" default="가용재고 반영"/>',
				 xtype: 'radiogroup',
				 disabled: true,
//				 id: 'EXC_STOCK_YN',
				 items : [{
					 	boxLabel : '<t:message code="system.label.purchase.yes" default="예"/>',
					 	width: 60, 
					 	name: 'EXC_STOCK_YN',
					 	inputValue: 'Y'
				 	},{
					 	boxLabel: '<t:message code="system.label.purchase.no" default="아니오"/>', 
					 	width: 60,  
					 	name: 'EXC_STOCK_YN', 
					 	inputValue: 'N',
					 	checked: true
			 	}]
			},{
				fieldLabel: '<t:message code="system.label.purchase.onhandstockapply" default="현재고 반영"/>',
				xtype: 'radiogroup',
				disabled: true,
//				id: 'STOCK_YN',
				items: [{
						boxLabel: '<t:message code="system.label.purchase.yes" default="예"/>',
						width: 60,
						name: 'STOCK_YN', 
						inputValue: 'Y'
					},{
						boxLabel: '<t:message code="system.label.purchase.no" default="아니오"/>', 
						width: 60,
						name: 'STOCK_YN',
						inputValue: 'N', 
						checked: true
					}]
			},{
				fieldLabel: '<t:message code="system.label.purchase.safetystockapply" default="안전재고 반영"/>',	
				xtype: 'radiogroup',
				disabled: true,
//				id: 'SAFE_STOCK_YN',
					items: [{
						boxLabel: '<t:message code="system.label.purchase.yes" default="예"/>', 
						width:60, 
						name: 'SAFE_STOCK_YN',
						inputValue: 'Y'
					},{
						boxLabel: '<t:message code="system.label.purchase.no" default="아니오"/>', 
						width: 60, 
						name: 'SAFE_STOCK_YN',
						inputValue: 'N', 
						checked: true
					}]
			},{
				fieldLabel: '<t:message code="system.label.purchase.receiptplannedapply" default="입고예정 반영"/>',
				xtype: 'radiogroup',
				disabled: true,
//				id: 'INSTOCK_PLAN_YN',
				items: [{
						boxLabel: '<t:message code="system.label.purchase.yes" default="예"/>', 
						width: 60, 
						name: 'INSTOCK_PLAN_YN',
						inputValue: 'Y'
					},{
						boxLabel: '<t:message code="system.label.purchase.no" default="아니오"/>',
						width: 60, 
						name: 'INSTOCK_PLAN_YN',
						inputValue: 'N',
						checked: true
					}]
			},{
				fieldLabel: '<t:message code="system.label.purchase.issueresevationapply" default="출고예정 반영"/>',
				xtype: 'radiogroup',
				disabled: true,
//				id: 'OUTSTOCK_PLAN_YN',
				items: [{
						boxLabel: '<t:message code="system.label.purchase.yes" default="예"/>',
						width:60, 
						name: 'OUTSTOCK_PLAN_YN',
						inputValue: 'Y'
					},{
						boxLabel: '<t:message code="system.label.purchase.no" default="아니오"/>', 
						width: 60, 
						name: 'OUTSTOCK_PLAN_YN',
						inputValue: 'N',
						checked: true
					}]
			},{
				fieldLabel: '<t:message code="system.label.purchase.substockapply" default="외주재고 반영"/>',
				xtype: 'radiogroup',
				disabled: true,
//				id: 'CUSTOM_STOCK_YN',
				items: [{
						boxLabel: '<t:message code="system.label.purchase.yes" default="예"/>',
						width: 60, 
						name: 'CUSTOM_STOCK_YN',
						inputValue: 'Y'
					},{
						boxLabel: '<t:message code="system.label.purchase.no" default="아니오"/>', 
						width: 60, 
						name: 'CUSTOM_STOCK_YN',
						inputValue: 'N', 
						checked: true
					}]
			},{
				fieldLabel: '<t:message code="system.label.purchase.uncertainorderapply" default="미확정오더 반영"/>',
				xtype: 'radiogroup',
				disabled: true,
//				id: 'PLAN_YN',
				items: [{
						boxLabel: '<t:message code="system.label.purchase.yes" default="예"/>', 
						width: 60,
						name: 'PLAN_YN',
						inputValue: 'Y'
					},{
						boxLabel: '<t:message code="system.label.purchase.no" default="아니오"/>', 
						width: 60,
						name: 'PLAN_YN', 
						inputValue: 'N',
						checked: true
					}]
			}]            			 
	   	}], 
        api: {
             load: 'mrp600skrvService.selectMaster'            
        }   
    });		// end of var panelSearch = Unilite.createSearchForm('searchForm',{
	
	var panelResult = Unilite.createSearchForm('resultForm',{
        	region: 'east',
        	split:true,
        	border: false,
    	    layout: {
    	    	type: 'vbox',
    	    	align: 'stretch'
    	    },
    	    width: 340,
    	    height: 800,
    	    padding: '0 0 0 0',
    	    items: [{	
        	    	xtype:'container',
        	        defaultType: 'uniTextfield',
        	        padding: '20 10 10 15',
        	        layout: {
        	        	type: 'uniTable',
        	        	columns : 1
        	        },
        	        items: [{
        	        	fieldLabel: '[<t:message code="system.label.purchase.messagedesc" default="메시지 설명"/>]',
        	        	xtype: 'textareafield', 
        	        	name: 'MSG_DESC',
        	        	labelAlign: 'top',
        	        	width: 300, 
        	        	height: 130
        	        },{
            	        fieldLabel: '[<t:message code="system.label.purchase.actioncontents" default="조치내역"/>]',
            	        xtype: 'textareafield', 
                        name: 'ACTION_MSG',
            	        labelAlign: 'top',
            	        width: 300, 
            	        height: 130
        	        },{
            	        fieldLabel: '[<t:message code="system.label.purchase.referprogram" default="관련 프로그램"/>]', 
            	        xtype: 'textareafield',
                        name: 'PRG_INFO1',
            	        labelAlign: 'top', 
            	        width: 300, 
            	        height: 130
        	        }
        	    ]}	            			 
		],
        loadForm: function(record)  {
            // window 오픈시 form에 Data load
            var count = masterGrid.getStore().getCount();
            if(count > 0) {
                this.reset();
                this.setActiveRecord(record[0] || null);   
                this.resetDirtyStatus();            
            }
        }
    });		// end of var panelResult = Unilite.createSearchForm('resultForm',{
    
    var masterGrid = Unilite.createGrid('mrp600skrvGrid1', {
    	// for tab 
    	layout: 'fit',
    	region:'center',
        features: [{
        	id : 'masterGridSubTotal', 
        	ftype: 'uniGroupingsummary', 
        	showSummaryRow: false 
        },{
        	id : 'masterGridTotal', 
        	ftype: 'uniSummary', 	 
        	showSummaryRow: false
        }],
    	store: directMasterStore1,
        uniOpt:{    expandLastColumn: false,
                    useRowNumberer: false,
                    useMultipleSorting: false,
                    onLoadSelectFirst   : true     //체크박스모델은 false로 변경
        },
    	selModel : 'rowmodel',
        columns:  [
        	{ dataIndex: 'MSG_CODE'	 	 ,     width: 200},
        	{ dataIndex: 'MSG_TYPE'	 	 ,     width: 66},
        	{ dataIndex: 'MSG_DESC'	 	 ,     width: 200},
        	{ dataIndex: 'ACTION_MSG'    ,     width: 200},
        	{ dataIndex: 'PRG_INFO1'	 ,     width: 450},
        	{ dataIndex: 'PRG_INFO2'	 ,     width: 66, hidden : true},
        	{ dataIndex: 'MSG_ID'	 	 ,     width: 66, hidden : true} 									
		],
        listeners : {
            selectionchange : function(grid, selected, eOpts) {
                   panelResult.loadForm(selected);                    
            }
        } 
    });		// end of var masterGrid = Unilite.createGrid('mrp600skrvGrid1', {  

    Unilite.Main({
    	borderItems:[ 
	 		masterGrid,
			panelSearch,
			panelResult
		],  	
		id  : 'mrp600skrvApp',
		fnInitBinding : function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
            UniAppManager.setToolbarButtons('reset',false);
		},
		onQueryButtonDown : function()	{
			var param= panelSearch.getValues();
			param.DIV_CODE = UserInfo.divCode;
            panelSearch.uniOpt.inLoading = true;
            Ext.getBody().mask('<t:message code="system.label.purchase.loading" default="로딩중..."/>','loading-indicator');
            panelSearch.getForm().load({
                params: param,
                success:function()  {
                	directMasterStore1.loadStoreRecords();
                	
                    Ext.getBody().unmask();
                    panelSearch.uniOpt.inLoading = false;
                },
                 failure: function(batch, option) {                     
                    Ext.getBody().unmask();                  
                 }
            })
			masterGrid.getStore().loadStoreRecords();				
		},
		onDetailButtonDown:function() {
			var as = Ext.getCmp('AdvanceSerch');	
			if(as.isHidden())	{
				as.show();
			}else {
				as.hide()
			}
		}
	});

};


</script>


