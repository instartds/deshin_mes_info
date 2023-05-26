<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_hat500ukr_shp"  >
	<t:ExtComboStore comboType="AU" comboCode="H028" /> <!-- 급여지급방식 -->
	<t:ExtComboStore comboType="AU" comboCode="H031" /> <!-- 지급차수 --> 
	<t:ExtComboStore comboType="AU" comboCode="H011" /> <!-- 고용형태 --> 
	<t:ExtComboStore comboType="AU" comboCode="H004" /> <!-- 근무조 -->
	<t:ExtComboStore comboType="AU" comboCode="H005" /> <!-- 직위 --> 
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="H024" /> <!-- 사원구분 --> 
	<t:ExtComboStore comboType="AU" comboCode="H181" /> <!-- 사원그룹 --> 
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >

function appMain() {
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 's_hat500ukr_shpService.selectMaster1'/*,
			update: 's_hat500ukr_shpService.updateDetail',
			create: 's_hat500ukr_shpService.insertDetail',
			destroy: 's_hat500ukr_shpService.deleteDetail',
			syncAll: 's_hat500ukr_shpService.saveAll'*/
		}
	});
	
	Unilite.defineModel('s_hat500ukr_shpkrvModel', {
		fields: [  	 
			{name: '1',			text:'근무일자',			type:'string'},
	    	{name: '2',			text:'요일',				type:'string'},
			{name: '3',			text:'휴일구분',			type:'string'},
	    	{name: '4',			text:'성명',				type:'string'},
			{name: '5',			text:'사번',				type:'string'},
	    	{name: '6',			text:'급여지급방식',		type:'string'},
			{name: '7',			text:'근태구분',			type:'string'},
	    	{name: '8',			text:'출근일자',			type:'string'},
			{name: '9',			text:'출근시',			type:'string'},
	    	{name: '10',		text:'출근분',			type:'string'},
			{name: '11',		text:'퇴근일자',			type:'string'},
	    	{name: '12',		text:'퇴근시',			type:'string'},
			{name: '13',		text:'퇴근분',			type:'string'},
	    	{name: '14',		text:'근무조',			type:'string'},
			{name: '15',		text:'비고',				type:'string'}
		]
	});
	
	var directMasterStore = Unilite.createStore('s_hat500ukr_shpkrvMasterStore1',{		// 메인
			model: 's_hat500ukr_shpkrvModel',
            uniOpt : {
            	isMaster: true,		// 상위 버튼 연결 
           	 	editable: true,		// 수정 모드 사용 
            	deletable: true,	// 삭제 가능 여부 
	        	useNavi : false		// prev | newxt 버튼 사용
            },
            autoLoad: false,
            proxy: directProxy,
			loadStoreRecords: function(/*provider, response*/) {
				var param= masterForm.getValues();	
				param.MONEY_UNIT = BsaCodeInfo.gsMoneyUnit;
				/*var basisDate = provider.BASIS_YYYYMM;
				basisDate = basisDate.substring(0,4) + '.' + basisDate.substring(4,6);*/
				console.log(param);
				this.load({
					params : param
				});
			},
            saveStore: function() {				
				var inValidRecs = this.getInvalidRecords();
				console.log("inValidRecords : ", inValidRecs);
	
				var toCreate = this.getNewRecords();
	       		var toUpdate = this.getUpdatedRecords();        		
	       		var toDelete = this.getRemovedRecords();
	       		var list = [].concat(toUpdate, toCreate);
	       		console.log("inValidRecords : ", inValidRecs);
				console.log("list:", list);
				console.log("this.data.filterBy(this.filterInvalidNewRecords).items : ", this.data.filterBy(this.filterInvalidNewRecords));
				
				//1. 마스터 정보 파라미터 구성
				var paramMaster= masterForm.getValues();	//syncAll 수정
				paramMaster.MONEY_UNIT = BsaCodeInfo.gsMoneyUnit;

				
				
				if(inValidRecs.length == 0) {
					config = {
						params: [paramMaster],
						
						success: function(batch, option) {
							//2.마스터 정보(Server 측 처리 시 가공)
							/*var master = batch.operations[0].getResultSet();
							masterForm.setValue("ORDER_NUM", master.ORDER_NUM);*/
							//3.기타 처리
							masterForm.getForm().wasDirty = false;
							masterForm.resetDirtyStatus();
							console.log("set was dirty to false");
							UniAppManager.setToolbarButtons('save', false);		
						} 
					};
					this.syncAllDirect(config);
				} else {
	                masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
				}
			}
	});	// End of var directMasterStore1 
	
	var panelSearch = Unilite.createSearchPanel('searchForm', {
		title: '검색조건',		
        defaultType: 'uniSearchSubPanel',
        collapsed: UserInfo.appOption.collapseLeftSearch,//true,
        listeners: {
	        collapse: function () {
	        	panelResult.show();
	        },
	        expand: function() {
	        	panelResult.hide();
	        }
	    },
		items: [{	
			title: '기본정보', 	
			id: 'search_panel1',
   			itemId: 'search_panel1',
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',
			items: [{
					fieldLabel: '근태기간',
	 		        width: 315,
	                xtype: 'uniDateRangefield',
	                startFieldName: 'FR_INOUT_DATE',
	                endFieldName: 'TO_INOUT_DATE',
	                startDate: UniDate.get('startOfMonth'),
	                endDate: UniDate.get('today'),
	                allowBlank: false
	         },
	         Unilite.popup('Employee',{
					fieldLabel: '사원',
				  	valueFieldName:'PERSON_NUMB',
				    textFieldName:'NAME',
					validateBlank:false,
					autoPopup:true
			 }),{
                fieldLabel: '급여지급방식',
                name:'PAY_CODE', 	
                xtype: 'uniCombobox',
                comboType:'AU',
                comboCode:'H028'
            },{
                fieldLabel: '비고',
                name:'PERSON_GROUP', 	
                xtype: 'uniTextfield',
                width: 300
            },{
            	fieldLabel: ' ',
            	name: 'TAX_DIV_CODE',
				value: 'Y',
				xtype: 'checkbox',
				boxLabel: '&nbsp;일자체크'
    		}]
		}]
	});
	
	
	var panelResult = Unilite.createSearchForm('resultForm',{
    	region: 'north',
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
		hidden: !UserInfo.appOption.collapseLeftSearch,
		items: [{
					fieldLabel: '근태기간',
	 		        width: 315,
	                xtype: 'uniDateRangefield',
	                startFieldName: 'FR_INOUT_DATE',
	                endFieldName: 'TO_INOUT_DATE',
	                startDate: UniDate.get('startOfMonth'),
	                endDate: UniDate.get('today'),
	                allowBlank: false
	         },
	         Unilite.popup('Employee',{
					fieldLabel: '사원',
				  	valueFieldName:'PERSON_NUMB',
				    textFieldName:'NAME',
					validateBlank:false,
					autoPopup:true
			 }),{
                fieldLabel: '급여지급방식',
                name:'PAY_CODE', 	
                xtype: 'uniCombobox',
                comboType:'AU',
                comboCode:'H028'
            },{
                fieldLabel: '비고',
                name:'PERSON_GROUP', 	
                xtype: 'uniTextfield',
                width: 300
            },{
            	fieldLabel: ' ',
            	name: 'TAX_DIV_CODE',
				value: 'Y',
				xtype: 'checkbox',
				boxLabel: '&nbsp;일자체크'
    		}]	
    });
    
    var masterGrid = Unilite.createGrid('s_hat500ukr_shpkrvGrid1', {
    	region: 'center' ,
        layout : 'fit',
        store : directMasterStore, 
        uniOpt:{	expandLastColumn: true,
        			useRowNumberer: true,
                    useMultipleSorting: true
        },
        tbar: [{
			xtype: 'button',
			text: '엑셀참조',
           	items: [{
				itemId: 'excelBtn',
				text: '엑셀참조',
	        	handler: function() {
		        	openExcelWindow();
		        }
			}]
		}],
    	features: [{
    		id: 'masterGridSubTotal', 
    		ftype: 'uniGroupingsummary', 
    		showSummaryRow: false 
    	},{
    		id: 'masterGridTotal',
    		ftype: 'uniSummary',
    		showSummaryRow: false
    	}],
        columns:  [  
        	{dataIndex: '1', width: 73},
        	{dataIndex: '2', width: 73},
        	{dataIndex: '3', width: 73},
        	{dataIndex: '4', width: 73},
        	{dataIndex: '5', width: 73},
        	{dataIndex: '6', width: 100},
        	{dataIndex: '7', width: 73},
        	{dataIndex: '8', width: 73},
        	{dataIndex: '9', width: 73},
        	{dataIndex: '10', width: 73},
        	{dataIndex: '11', width: 73},
        	{dataIndex: '12', width: 73},
        	{dataIndex: '13', width: 73},
        	{dataIndex: '14', width: 73},
        	{dataIndex: '15', width: 250}
		] 
    }); 
    
    Unilite.Main( {
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
				masterGrid, panelResult
			]
		},
			panelSearch  	
		],
		id  : 's_hat500ukrv_shpApp',
		fnInitBinding : function() {
			UniAppManager.setToolbarButtons('reset',false);
		},
		onQueryButtonDown : function()	{			
			
		}
	});
};
</script>
