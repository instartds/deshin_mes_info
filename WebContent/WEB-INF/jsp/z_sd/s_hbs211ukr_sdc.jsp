<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_hbs211ukr_sdc"  >
	<t:ExtComboStore comboType="AU" comboCode="H006" /> <!-- 직무명 -->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>
<script type="text/javascript" >

function appMain() {
	
	var excelWindow;
	
	/**
	 *   Model 정의 
	 * @type 
	 */
	Unilite.defineModel('s_hbs211ukr_sdcModel', {
	    fields: [  	  
	    	{name: 'COMP_CODE'   		,text: '법인코드'			,type: 'string', allowBlank: false},
		    {name: 'PAY_GRADE_YYYY'		,text: '기준년도'			,type: 'string', allowBlank: false, maxLength:4},
		    {name: 'JOB_CODE' 			,text: '직무명'			,type: 'string', allowBlank: false, comboType : 'AU', comboCode : 'H008'},
		    {name: 'WAGES_CODE' 		,text: '수당코드'			,type: 'string'},
		    {name: 'WAGES_I'  			,text: '기본급'			,type: 'uniPrice'},
		    {name: 'UPDATE_DB_USER'		,text: '<t:message code="system.label.base.updateuser" default="수정자"/>'	,type: 'string'},
		    {name: 'UPDATE_DB_TIME'		,text: '<t:message code="system.label.base.updatedate" default="수정일"/>'	,type: 'uniDate'} 
		]
	}); //End of Unilite.defineModel('bcm200ukrvModel', {
	
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 's_hbs211ukr_sdcService.selectDetailList',
			update: 's_hbs211ukr_sdcService.updateDetail',
			create: 's_hbs211ukr_sdcService.insertDetail',
			destroy: 's_hbs211ukr_sdcService.deleteDetail',
			syncAll: 's_hbs211ukr_sdcService.saveAll'
		}
	});
	
	// 엑셀업로드 window의 Grid Model
	Unilite.Excel.defineModel('excel.s_hbs211ukr_sdc.sheet01', {
		fields: [
			{name: '_EXCEL_JOBID'		, text: 'EXCEL_JOBID'														 , type: 'string'},
			{name: '_EXCEL_ROWNUM'		, text: '순번'														 		 , type: 'string'},
			{name: '_EXCEL_ERROR_MSG'	, text: '에러메시지'													 		 , type: 'string'},
			{name: 'COMP_CODE'		, text: '<t:message code="system.label.human.companycode" 	default="법인코드"/>'	 , type: 'string'},
			{name: 'PAY_GRADE_YYYY'	, text: '기준년도'	 	, type: 'string' , allowBlank: false},
			{name: 'JOB_CODE'		, text: '직무코드'	 	, type: 'string' , allowBlank: false},
			{name: 'JOB_NAME'		, text: '직무명'	 	, type: 'string'},
			{name: 'WAGES_CODE'		, text: '수당코드'		, type: 'string'},
			{name: 'WAGES_I'		, text: '기본급'		, type: 'uniPrice'}
						
		]
	});
	
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore = Unilite.createStore('s_hbs211ukr_sdcMasterStore',{
		model: 's_hbs211ukr_sdcModel',
		uniOpt: {
            isMaster: true,			// 상위 버튼 연결 
            editable: true,			// 수정 모드 사용 
            deletable: true,		// 삭제 가능 여부 
	        useNavi : false			// prev | next 버튼 사용
        },
        autoLoad: false,
		proxy: directProxy,
        loadStoreRecords : function()	{
			var param= panelSearch.getValues();
			this.load({
				params : param
			});
		},
		saveStore : function(config)	{	

			var inValidRecs = this.getInvalidRecords();
			var toCreate = this.getNewRecords();
        	var toUpdate = this.getUpdatedRecords();
        	console.log("toUpdate",toUpdate);

        	var rv = true;
   	
        	
			if(inValidRecs.length == 0 )	{					
				config = {
					success: function(batch, option) {								
//						detailForm.resetDirtyStatus();
						UniAppManager.setToolbarButtons('save', false);			
					 } 
				};
				this.syncAllDirect(config);
			}else {
				masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		},
		
        listeners : {
			load:function( store, records, successful, operation, eOpts ){
				//조회된 데이터가 있을 때, 합계 보이게 설정 변경
				var viewNormal = masterGrid.getView();
	            if (store.getCount() > 0) {
	            	UniAppManager.setToolbarButtons('deleteAll', true);
	            } else {

		        	UniAppManager.setToolbarButtons('deleteAll', false);

	            }
	        }
	    }
	});
	
	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */
	var panelSearch = Unilite.createSearchPanel('searchForm',{
		title: '<t:message code="system.label.base.searchconditon" default="검색조건"/>',
        defaultType: 'uniSearchSubPanel',
		collapsed: UserInfo.appOption.collapseLeftSearch,
        listeners: {
	        collapse: function () {
	        	panelResult.show();
	        },
	        expand: function() {
	        	panelResult.hide();
	        }
	    },
		items: [
			{
                fieldLabel: '기준년도',
                name: 'BASE_YEARS',
                xtype: 'uniYearField',
                value: new Date().getFullYear(),
                allowBlank: false,
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {                        
                        panelResult.setValue('BASE_YEARS', newValue);   
                    }
                }
             }
		]
    }); //End of var panelSearch = Unilite.createSearchForm('searchForm',{
	
    var panelResult = Unilite.createSearchForm('resultForm',{
    	region: 'north',
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
		hidden: !UserInfo.appOption.collapseLeftSearch,
		items: [
			{
                fieldLabel: '기준년도',
                name: 'BASE_YEARS',
                xtype: 'uniYearField',
                value: new Date().getFullYear(),
                allowBlank: false,
                listeners: {
                    change: function(field, newValue, oldValue, eOpts) {                        
                        panelSearch.setValue('BASE_YEARS', newValue);   
                    }
                }
             }
         ]	
    });
    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    
    var masterGrid = Unilite.createGrid('s_hbs211ukr_sdcGrid', {
    	layout : 'fit',
    	region:'center',
        store : directMasterStore, 
        uniOpt:{	expandLastColumn: true,
        			useRowNumberer: true,
                    useMultipleSorting: true
        },
        tbar  : [{
            text    : '직무급표 엑셀업로드',
            id  : 'excelBtn',
            width   : 150,
            handler : function() {
                if(!panelResult.getInvalidMessage()) return;   //필수체크
                openExcelWindow();
            }
        }],
        columns: [        			 

			{dataIndex: 'COMP_CODE' 			, width: 150 , hidden: true}, 
			{dataIndex: 'PAY_GRADE_YYYY' 		, width: 120 , align: 'center'},
			{dataIndex: 'JOB_CODE'  			, width: 250},
			{dataIndex: 'WAGES_CODE'			, width: 150 , hidden: true},
			{dataIndex: 'WAGES_I' 				, width: 150},
			{dataIndex: 'UPDATE_DB_USER'		, width: 150 , hidden: true},
			{dataIndex: 'UPDATE_DB_TIME'		, width: 150 , hidden: true}
		],
		listeners: {
			beforeedit  : function( editor, e, eOpts ) {
				if(!e.record.phantom){
					if (UniUtils.indexOf(e.field, ['PAY_GRADE_YYYY','JOB_CODE']))
					return false;
				}
				
			}
		}
    });	//End of   var masterGrid = Unilite.createGrid('bcm200ukrvGrid', {

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
		id: 's_hbs211ukr_sdcApp',
		fnInitBinding : function() {
			
			panelSearch.setValue('BASE_YEARS', new Date().getFullYear());
			panelResult.setValue('BASE_YEARS', new Date().getFullYear());
			
			UniAppManager.setToolbarButtons('newData',true);
			UniAppManager.setToolbarButtons('save',false);
		},
		onQueryButtonDown : function() {
			directMasterStore.loadStoreRecords();
		},
		onResetButtonDown: function() {       // 초기화
            panelSearch.clearForm();
            panelResult.clearForm();
            masterGrid.reset();
            directMasterStore.clearData();
            this.fnInitBinding();
        },
		onNewDataButtonDown : function(additemCode)	{        	 
        	 var r = {

        	 	COMP_CODE      : UserInfo.compCode, 
				PAY_GRADE_YYYY : panelResult.getValue('BASE_YEARS'),
				WAGES_CODE     : 'BSE'

	        };	        
			masterGrid.createRow(r);

		},
		/**
		 *  삭제
		 *	@param 
		 *	@return
		 */
		 onDeleteDataButtonDown: function() {
			if(confirm('<t:message code="system.message.base.confirm001" default="현재행을 삭제 합니다. 삭제 하시겠습니까?"/>')) {
				masterGrid.deleteSelectedRow();
			}
		},
 		onDeleteAllButtonDown : function() {
			Ext.Msg.confirm('<t:message code="system.label.human.delete" default="삭제"/>', '<t:message code="system.message.human.message043" default="전체행을 삭제 합니다. 삭제 하시겠습니까?"/>', function(btn){
				if (btn == 'yes') {
					directMasterStore.removeAll();
					UniAppManager.app.onSaveDataButtonDown();
				}
			});
		},
		/**
		 *  저장
		 *	@param 
		 *	@return
		 */
		onSaveDataButtonDown: function (config) {
//			var rtnrecord = masterGrid.getSelectedRecord();
//			if(!Ext.isEmpty(rtnrecord)){
//				if(Ext.isEmpty(rtnrecord.get('SALE_DATE'))){
//					rtnrecord.set('SALE_DATE', UniDate.get('today'))
//				}
//			}			
			directMasterStore.saveStore(config);			
		}/*,
		onDetailButtonDown:function() {
			var as = Ext.getCmp('AdvanceSerch');	
			if(as.isHidden())	{
				as.show();
			}else {
				as.hide()
			}
		}*/
	}); //End of Unilite.Main( {
	
	
	function openExcelWindow() {
	    var me = this;
        var vParam = {};

        var appName = 'Unilite.com.excel.ExcelUpload';
        
        var record = masterGrid.getSelectedRecord();
        
        if(!directMasterStore.isDirty())  {                                   //화면에 저장할 내용이 있을 경우 저장여부 확인
            //masterStore.loadData({});
        } else {
            if(confirm('저장될 내용이 있습니다. '+'\n'+'저장하시겠습니까?')){
                UniAppManager.app.onSaveDataButtonDown();
                return;
            }else {
                directMasterStore.loadData({});
            }
        }
        
        if(!excelWindow) { 
        	excelWindow = Ext.WindowMgr.get(appName);
            excelWindow = Ext.create( appName, {
				modal: false,
            	excelConfigName: 's_hbs211ukr_sdc',
        		extParam: { 
                    'PGM_ID'    : 's_hbs211ukr_sdc'
        		},
                grids: [{							//팝업창에서 가져오는 그리드
                		itemId		: 'grid01',
                		title		: '직무급표 엑셀업로드',                        		
                		useCheckbox	: false,
                		model		: 'excel.s_hbs211ukr_sdc.sheet01',
                		readApi		: 's_hbs211ukr_sdcService.selectExcelUploadSheet',
                		columns		: [	
                			{dataIndex: '_EXCEL_JOBID'		, width: 120,	hidden: true},
                			//{dataIndex: '_EXCEL_ROWNUM'  	, width: 100,	align: 'center'},
                			//{dataIndex: '_EXCEL_ERROR_MSG'  , width: 150},
							{dataIndex: 'COMP_CODE'  		, width: 120,   hidden: true},
							{dataIndex: 'PAY_GRADE_YYYY'	, width: 100,	align: 'center'},
							{dataIndex: 'JOB_CODE'			, width: 100},
							{dataIndex: 'JOB_NAME'			, width: 200},
							{dataIndex: 'WAGES_CODE'		, width: 130,   hidden: true},
							{dataIndex: 'WAGES_I'			, width: 120}
							
                		]
                	}
                ],
                listeners: {
                    close: function() {
                        this.hide();
                    }
                },
                onApply:function()	{
                	excelWindow.getEl().mask('로딩중...','loading-indicator');
                	var me		= this;
                	var grid	= this.down('#grid01');
        			var records	= grid.getStore().getAt(0);	
        			if (!Ext.isEmpty(records)) {
			        	var param	= {
			        		"_EXCEL_JOBID" : records.get('_EXCEL_JOBID')
			        	};
			        	excelUploadFlag = "Y"
			        	
			        	masterGrid.reset();
						directMasterStore.clearData();
						
						s_hbs211ukr_sdcService.selectExcelUploadSheet(param, function(provider, response){
					    	var store	= masterGrid.getStore();
					    	var records	= response.result;
					    	
					    	store.insert(0, records);
					    	console.log("response",response)
							excelWindow.getEl().unmask();
							grid.getStore().removeAll();
							me.hide();
					    });
						excelUploadFlag = "N"
		        	} else {
		        		alert (Msg.fSbMsgH0284);
		        		this.unmask();  
		        	}
        		}
			});
		}
        excelWindow.center();
        excelWindow.show();
	};
	
	
	//그리드 변경시 발생하는 로직
	Unilite.createValidator('validator01', {
		store: directMasterStore,
		grid: masterGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;

			switch(fieldName) {		
				case "PAY_GRADE_YYYY"	:							// 재평가금액
					if(isNaN(newValue)){
						rv = Msg.sMB074;	//숫자만 입력가능합니다.
						break;
					}
					if(newValue <= 0 && !Ext.isEmpty(newValue))	{
						rv=Msg.sMB076;	//양수만 입력 가능합니다.
						break;
					}
			}
			return rv;
		}
	});
};

</script>
