<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="bcm103ukrv"  >
		<t:ExtComboStore comboType= "BOR120"  /> 		 <!-- 사업장 -->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>
<script type="text/javascript">
  var protocol =   ("https:" == document.location.protocol)  ? "https" : "http"  ;
  if(protocol == "https")	{
	  document.write( unescape( "%3Cscript src='"+ protocol+ "://ssl.daumcdn.net/dmaps/map_js_init/postcode.v2.js' type='text/javascript' %3E %3C/script%3E")  );
  }else {
  	document.write( unescape( "%3Cscript src='"+ protocol+ "://dmaps.daum.net/map_js_init/postcode.v2.js' type='text/javascript' %3E %3C/script%3E") );
  }
</script></script><!-- Unilite.popup('ZIP',..) -->
<script type="text/javascript" >

var excelWindow; // 엑셀참조

function appMain() {     
	/**
	 *   Model 정의 
	 * @type 
	 */
	Unilite.defineModel('bcm103ukrvModel', {
	    fields: [  	  
	    	{name: 'COMP_CODE'				,text: '<t:message code="system.label.base.companycode" default="법인코드"/>'				,type: 'string'},
		    {name: 'CUSTOM_CODE'			,text: '거래처코드'				,type: 'string'},
		    {name: 'CUSTOM_NAME'			,text: '거래처명'				,type: 'string'},
		    {name: 'ZIP_CODE'				,text: '우편번호'				,type: 'string'},
		    {name: 'ADDR1'					,text: '주소1'				,type: 'string'},
		    {name: 'ADDR2'					,text: '주소2'				,type: 'string'},
		    {name: 'NEW_ZIP_CODE'			,text: '우편번호'				,type: 'string'},
		    {name: 'NEW_ADDR1'				,text: '주소1'				,type: 'string'},
		    {name: 'NEW_ADDR2'				,text: '주소2'				,type: 'string'},
		    {name: 'RESULT_CODE'			,text: '결과코드'				,type: 'string'},
		    {name: 'RESULT'					,text: '결과'					,type: 'string'}
		]
	}); //End of Unilite.defineModel('bcm103ukrvModel', {
	
	
	Unilite.defineModel('excel.bcm.sheet01', {
	    fields: [  	  
	    	{name: 'OLD_ADDR'				,text: '입력주소'				,type: 'string'},
		    {name: 'OLD_ZIP_CODE'			,text: '우편번호'				,type: 'string'},
		    {name: 'NEW_ZIP_CODE'			,text: '새우편번호'				,type: 'string'},
		    {name: 'NEW_ADDR1'				,text: '도로명'				,type: 'string'},
		    {name: 'NEW_ADDR2'				,text: '기타주소'				,type: 'string'}
		]
	});

	function openExcelWindow() {
		
			var me = this;
	        var vParam = {};
	        var appName = 'Unilite.com.excel.ExcelUploadWin';

            
            if(!excelWindow) {
            	excelWindow =  Ext.WindowMgr.get(appName);
                excelWindow = Ext.create( appName, {
                		modal: false,
                		excelConfigName: 'bcm103',
                		extParam: { 
                			/*'DIV_CODE': masterForm.getValue('DIV_CODE'),
                			'CUSTOM_CODE': masterForm.getValue('CUSTOM_CODE')*/
                		},
                        grids: [{
                        		itemId: 'grid01',
                        		title: '주소정보',                        		
                        		useCheckbox: true,
                        		model : 'excel.bcm.sheet01',
                        		readApi: 'bcm103ukrvService.selectExcelUploadSheet1',
                        		columns:[{dataIndex:'OLD_ADDR' 		,width:300   },
                        				 {text:'전환주소' , 
							        		columns: [
												{dataIndex: 'OLD_ZIP_CODE'		, width: 70},
												{dataIndex: 'NEW_ZIP_CODE'		, width: 70},
												{dataIndex: 'NEW_ADDR1'		 	, width: 300},
												{dataIndex: 'NEW_ADDR2'		 	, width: 200}
										 ]}
								]
                        }],
                        listeners: {
                            close: function() {
                                this.hide();
                            }
                        },
                        onApply:function()	{
                        	var grid = this.down('#grid01');
                			var records = grid.getSelectionModel().getSelection();       		
							Ext.each(records, function(record,i){	
						        	UniAppManager.app.onNewDataButtonDown();
						        	masterGrid.setExcelData(record.data);								        
						    }); 
							grid.getStore().remove(records);
                		}
                 });
            }
            excelWindow.center();
            excelWindow.show();
	}
	
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */			
	
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'bcm103ukrvService.selectList',
			update: 'bcm103ukrvService.updateDetail',
			create: 'bcm103ukrvService.insertDetail',
			destroy: 'bcm103ukrvService.deleteDetail',
			syncAll: 'bcm103ukrvService.saveAll'
		}
	});	
	
	
	var directMasterStore = Unilite.createStore('bcm103ukrvMasterStore',{
		model: 'bcm103ukrvModel',
		uniOpt: {
            isMaster: true,			// 상위 버튼 연결 
            editable: true,			// 수정 모드 사용 
            deletable: false,			// 삭제 가능 여부 
	        useNavi : false			// prev | next 버튼 사용
        },
        autoLoad: false,
        
        proxy: directProxy,
        
        loadStoreRecords : function()	{
			var param= Ext.getCmp('resultForm').getValues();			
			console.log( param );
			this.load({
				params : param
			});
		},
		saveStore : function(config)	{
				var inValidRecs = this.getInvalidRecords();
				console.log("inValidRecords : ", inValidRecs);
				if(inValidRecs.length == 0 )	{
					
					this.syncAllDirect(config);
				}else {
					masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
				}
			}
	});
	
	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */
/*	var panelSearch = Unilite.createSearchPanel('searchForm',{
		title: '<t:message code="system.label.base.searchconditon" default="검색조건"/>',
        defaultType: 'uniSearchSubPanel',
		items: [{	
			title: '<t:message code="system.label.base.basisinfo2" default="기본정보"/>', 	
   			itemId: 'search_panel1',
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',
		    items: [{
        		fieldLabel: '신주소 변환 파일', 
        		name:'', 
        		xtype: 'uniTextfield',
		 		allowBlank:false
            }]
		}]
    }); //End of var panelSearch = Unilite.createSearchForm('searchForm',{
	
    */
    var panelResult = Unilite.createSearchForm('resultForm',{
    	region: 'north',
		layout : {type : 'uniTable', columns : 8},
		padding:'1 1 1 1',
		border:true,
		hidden: !UserInfo.appOption.collapseLeftSearch,
		items: [{
			padding:'10 0 5 20',
			xtype:'container',
			html: '<b>[신주소 변환순서]</b>',
			style: {
				color: 'blue'				
			}},{
				margin:'10 0 5 20',
	        	xtype:'button',
	        	text:'구주소 DownLoad',
	        	width: 130,
	        	tdAttrs:{'align':'center'},
	        	handler: function()	{
	        		masterGrid.downloadExcelXml();
	        	}
			},{
				margin:'10 0 5 30',
				xtype:'container',
				html: '<b> → </b>'		
			},{
				margin:'10 0 5 40',
	        	xtype:'button',
	        	text:'신주소 변환 사이트',
	        	width: 130,
	        	tdAttrs:{'align':'center'},
	        	handler: function()	{
	        		window.open('https://www.juso.go.kr/support/AddressTransform.do', '_blank');	
	        	}
			},{
				margin:'10 0 5 50',
				xtype:'container',
				html: '<b> → </b>'		
			},{
				margin:'10 0 1 60',
				xtype:'container',
				html: '<pre>신주소 변환 파일</pre>'		
			},{
				margin:'10 0 5 80',
	        	xtype:'button',
				text: '신주소 변환',
				width: 80,
	        	handler: function() {
		        	openExcelWindow();
		        }
			}]	
    });
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    
    var masterGrid = Unilite.createGrid('bcm103ukrvGrid', {
    	layout : 'fit',
    	region:'center',
        store : directMasterStore, 
        uniOpt:{
        	expandLastColumn: true,
    		useLiveSearch: true,
			useContextMenu: true,
			useMultipleSorting: true,
    		useGroupSummary: false,
			useRowNumberer: false,
			filter: {
				useFilter: true,
				autoCreate: true
			}
        },
        columns: [        			 
			{dataIndex: 'COMP_CODE'						, width: 100 ,hidden: true}, 
			{dataIndex: 'CUSTOM_CODE'	 				, width: 80  ,locked:true},
			{dataIndex: 'CUSTOM_NAME'	 				, width: 150 ,locked:true},
			{text:'구주소' , 
        		columns: [
					{dataIndex: 'ZIP_CODE'						, width: 66}, 
					{dataIndex: 'ADDR1'			 				, width: 300},
					{dataIndex: 'ADDR2'			 				, width: 250}
			]},
			{text:'신주소' , 
        		columns: [
					{dataIndex: 'NEW_ZIP_CODE'					, width: 66
					 ,'editor' : Unilite.popup('ZIP_G',{
			  						autoPopup: true,
			  						listeners: {
					                'onSelected': {
					                    fn: function(records, type  ){
					                    	var me = this;
					                    	var grdRecord = Ext.getCmp('bcm103ukrvGrid').uniOpt.currentRecord;
					                    	grdRecord.set('NEW_ZIP_CODE',records[0]['ZIP_CODE']);
					                    	grdRecord.set('NEW_ADDR1',records[0]['ZIP_NAME']);
					                    	grdRecord.set('NEW_ADDR2',records[0]['ADDR2']);
					                    },
					                    scope: this
					                },
					                'onClear' : function(type){
					                		var me = this;
					                    	var grdRecord = Ext.getCmp('bcm103ukrvGrid').uniOpt.currentRecord;
					                    	grdRecord.set('NEW_ZIP_CODE','');
					                    	grdRecord.set('NEW_ADDR1','');
					                    	grdRecord.set('NEW_ADDR2','');
					                    	
					                }
					            }
							})
					},
					{dataIndex: 'NEW_ADDR1'		 				, width: 300},
					{dataIndex: 'NEW_ADDR2'		 				, width: 250}
			]},
			{dataIndex: 'RESULT_CODE'					, width: 66  , hidden: true}, 
			{text:'변환정보' , 
        		columns: [
					{dataIndex: 'RESULT'		 				, width: 250}
			]}
		],listeners: {
			beforeedit  : function( editor, e, eOpts ){
				if(e.record.phantom )	{
					if (UniUtils.indexOf(e.field, 
							['COMP_CODE','CUSTOM_CODE','CUSTOM_NAME','ZIP_CODE','ADDR1',
							 'ADDR2','NEW_ZIP_CODE','NEW_ADDR1','NEW_ADDR2','RESULT_CODE', 'RESULT']))
					return false;
				}else{
					if (UniUtils.indexOf(e.field, 
							['COMP_CODE','CUSTOM_CODE','CUSTOM_NAME','ZIP_CODE','ADDR1',
							 'ADDR2','NEW_ADDR1','NEW_ADDR2', 'RESULT_CODE', 'RESULT']))
					return false;
				}
        	}
		},
		setExcelData: function(record) {
			var grdRecord = masterGrid.uniOpt.currentRecord;
			//grdRecord.set('ZIP_CODE' 	 		, record['OLD_ZIP_CODE']);
			grdRecord.set('NEW_ADDR1'		    , record['NEW_ADDR1']);
			grdRecord.set('NEW_ADDR2' 			, record['NEW_ADDR2']);
		}	//End of var masterGrid = Unilite.createGrid('biv105ukrvGrid1', { 
    });	//End of   var masterGrid1 = Unilite.createGrid('bcm103ukrvGrid1', {

    Unilite.Main( {
		border: false,
		borderItems: [{
         	region:'center',
         	layout: 'border',
         	border: false,
         	items:[
           		masterGrid, panelResult
         	]	
      	}
      	//,panelSearch     
      	],
		id: 'bcm103ukrvApp',
		fnInitBinding : function() {
			UniAppManager.setToolbarButtons(['reset','newData','detail','save'],false);	
		},
		onQueryButtonDown : function() {					
				directMasterStore.loadStoreRecords();				
		},
		onSaveDataButtonDown: function (config) {
			directMasterStore.saveStore(config);	
		},
		onDetailButtonDown:function() {
			var as = Ext.getCmp('AdvanceSerch');	
			if(as.isHidden())	{
				as.show();
			}else {
				as.hide()
			}
		}
	}); //End of Unilite.Main( {
};

</script>
