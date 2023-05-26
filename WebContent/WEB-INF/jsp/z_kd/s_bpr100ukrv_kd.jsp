<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="s_bpr100ukrv_kd"  >
<t:ExtComboStore comboType="AU" comboCode="B013" /><!-- 단위 -->
<t:ExtComboStore comboType="AU" comboCode="B019" /><!-- 국내외 -->
<t:ExtComboStore comboType="AU" comboCode="B059" /><!-- 세구분 -->
<t:ExtComboStore comboType="AU" comboCode="B073" /><!-- 유효일자 -->
<t:ExtComboStore comboType="AU" comboCode="B010" /><!-- 단위 -->
<t:ExtComboStore comboType="AU" comboCode="A004" /><!-- 사용여부 -->
<t:ExtComboStore comboType="AU" comboCode="WB04" /><!-- 차종 -->
<t:ExtComboStore comboType="AU" comboCode="A020" /><!-- 예(Y)/아니오(N) -->
<t:ExtComboStore items="${COMBO_ITEM_LEVEL1}" storeId="BPR100ukrvLevel1Store" />
<t:ExtComboStore items="${COMBO_ITEM_LEVEL2}" storeId="BPR100ukrvLevel2Store" />
<t:ExtComboStore items="${COMBO_ITEM_LEVEL3}" storeId="BPR100ukrvLevel3Store" />
</t:appConfig>
<script type="text/javascript" >
var detailWin;

function appMain() {
	/**
	 * Master Model
	 */
	Unilite.defineModel('bpr100ukrvModel', {
    	fields: [
    	  		  	 { name: 'ITEM_CODE',  			text: '품목코드', 		type : 'string', allowBlank:false, isPk:true, pkGen:'user', maxLength: 20}
			  		,{ name: 'ITEM_NAME',  			text: '품목명', 		type : 'string', allowBlank: false, maxLength: 200}
			  		,{ name: 'ITEM_NAME1',  		text: '품목명1', 		type : 'string', maxLength: 200}
			  		,{ name: 'ITEM_NAME2',  		text: '품목명2', 		type : 'string', maxLength: 200}
			  		,{ name: 'SPEC',  				text: '규격', 		type : 'string', maxLength: 160}
			  		,{ name: 'STOCK_UNIT',  		text: '재고단위', 		type : 'string', allowBlank: false, comboType:'AU', comboCode:'B013', displayField: 'value' }
				    ,{ name: 'ITEM_LEVEL1',  		text: '대분류', 		type : 'string', store: Ext.data.StoreManager.lookup('BPR100ukrvLevel1Store'), child:'ITEM_LEVEL2'}
				    ,{ name: 'ITEM_LEVEL2',  		text: '중분류', 		type : 'string', store: Ext.data.StoreManager.lookup('BPR100ukrvLevel2Store'), child:'ITEM_LEVEL3'}
				    ,{ name: 'ITEM_LEVEL3',  		text: '소분류', 		type : 'string', store: Ext.data.StoreManager.lookup('BPR100ukrvLevel3Store')}
				    ,{ name: 'ITEM_GROUP',  		text: '대표모델코드',	type : 'string', maxLength: 20 }
				    ,{ name: 'ITEM_GROUP_NAME',  	text: '대표모델명', 	type : 'string', maxLength: 200}
				    ,{ name: 'ITEM_COLOR',  		text: '색상', 		type : 'string'}
				    ,{ name: 'ITEM_SIZE',  			text: '사이즈', 		type : 'string', maxLength: 50}
			  		,{ name: 'UNIT_WGT',  			text: '단위중량', 		type : 'uniQty', maxLength: 18}
			  		,{ name: 'WGT_UNIT',  			text: '중량단위', 		type : 'string', comboType:'AU', comboCode:'B013', displayField: 'value'}
			  		,{ name: 'UNIT_VOL',			text: '단위부피',		type : 'uniQty', maxLength: 18}
					,{ name: 'VOL_UNIT',			text: '부피단위',		type : 'string'}
					,{ name: 'REIM',				text: '비중',			type : 'float', maxLength: 18}
			  		,{ name: 'SPEC_NUM',  			text: '도면번호', 		type : 'string'}
			  		,{ name: 'SALE_UNIT',  			text: '판매단위', 		type : 'string', allowBlank: false, comboType:'AU', comboCode:'B013', displayField: 'value'}
			  		,{ name: 'TRNS_RATE',  			text: '판매입수', 		type : 'uniUnitPrice', defaultValue:1.00, maxLength: 12}
			  		,{ name: 'TAX_TYPE',  			text: '세구분', 		type : 'string', allowBlank: false, comboType:'AU', comboCode:'B059' , defaultValue:'1'}
			  		,{ name: 'SALE_BASIS_P',  	 	text: '판매단가', 		type : 'uniUnitPrice', defaultValue:0, maxLength: 18}
			  		,{ name: 'DOM_FORIGN',  		text: '국내외', 		type : 'string', comboType:'AU', comboCode:'B019' , defaultValue:'1'}
			  		,{ name: 'STOCK_CARE_YN',  		text: '재고관리대상', 	type : 'string', comboType:'AU', comboCode:'B010', defaultValue:'Y'}
			  		,{ name: 'TOTAL_ITEM',  		text: '집계품목코드', 	type : 'string'}
			  		,{ name: 'TOTAL_ITEM_NAME',  	text: '집계품목명', 	type : 'string'}
			  		,{ name: 'TOTAL_TRAN_RATE', 	text: '집계환산계수', 	type : 'uniUnitPrice', maxLength: 12}
			  		,{ name: 'BARCODE',  			text: '바코드', 		type : 'string', maxLength: 15}
			  		,{ name: 'HS_NO',  				text: 'HS번호', 		type : 'string'}
			  		,{ name: 'HS_NAME',  			text: 'HS명', 		type : 'string', maxLength: 60}
			  		,{ name: 'HS_UNIT',  			text: 'HS단위', 		type : 'string'}
			  		,{ name: 'ITEM_MAKER',  		text: '제조메이커', 	type : 'string',maxLength: 50}
			  		,{ name: 'ITEM_MAKER_PN',  	 	text: '메이커 Part No', type : 'string',maxLength: 50}
			  		,{ name: 'PIC_FLAG',  			text: '사진유무', 		type : 'string', comboType:'AU', comboCode:'B010',defaultValue:'N'    }
			  		,{ name: 'START_DATE',  		text: '사용시작일', 	type : 'uniDate', defaultValue:new Date(),  maxLength: 10}
			  		,{ name: 'STOP_DATE',  			text: '사용중단일', 	type : 'uniDate', maxLength: 10}
			  		,{ name: 'USE_YN',  			text: '사용유무', 		type : 'string', allowBlank: false, comboType:'AU', comboCode:'B010',defaultValue:'Y'}
			  		,{ name: 'EXCESS_RATE',  		text: '과출고허용률 ',	type : 'uniPercent', defaultValue:0.00}
			  		,{ name: 'USE_BY_DATE',  		text: '유효일자', 		type : 'string', defaultValue:'${UseByDate}'}
			  		,{ name: 'CIR_PERIOD_YN',  		text: '유효일자관리여부', type : 'string', comboType:'AU', comboCode:'B010', defaultValue:'N'}
                    ,{ name: 'TEMPC_01',            text: '자동검수예외', type : 'string', comboType:'AU', comboCode:'B010', defaultValue:'N'}
					,{ name: 'REMARK1',  			text: '비고사항1', 		type : 'string'}
			  		,{ name: 'REMARK2',  			text: '비고사항2', 		type : 'string'}
			  		,{ name: 'REMARK3',  			text: '비고사항3', 		type : 'string'}
			  		,{ name: 'SQUARE_FT',  			text: '면적(S/F)', 		type : 'int', defaultValue:0}
			  		,{ name: 'IMAGE_FID',  			text: '사진FID', 		type : 'string' }
			  		,{ name: 'CAR_TYPE',  			text: '차종', 		type : 'string', comboType:'AU', comboCode:'WB04'}
			  		,{ name: 'OEM_ITEM_CODE',  		text: '품번', 		type : 'string'}
			  		,{ name: 'AS_ITEM_CODE',  		text: 'AS코드', 		type : 'string'}
			  		,{ name: 'B_OUT_YN',    		text:'밸런스아웃여부',   type : 'string', comboType:'AU', comboCode:'A020', allowBlank:false}
			  		,{ name: 'B_OUT_DATE',  		text: '밸런스아웃일자', 	type : 'uniDate',  maxLength: 10}
			  		,{ name: 'MAKE_STOP_YN',    	text:'생산중지여부',    type : 'string', comboType:'AU', comboCode:'A020', allowBlank:false}
			  		,{ name: 'MAKE_STOP_DATE',  	text: '생산중지일자', 	type : 'uniDate',  maxLength: 10}
			  		,{name: '_fileChange',			text: '사진저장체크' 	,type:'string'	,editable:false}
			  		,{name: '_EXCEL_JOBID',  		text:'엑셀JobID' , type: 'string'}
			  		,{name: '_EXCEL_ROWNUM',  		text:'엑셀행'     , type: 'int'}
		]
	});

	/**
	 * Master Store
	 */

	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 's_bpr100ukrv_kdService.selectDetailList',
			update: 's_bpr100ukrv_kdService.updateDetail',
			create: 's_bpr100ukrv_kdService.insertDetail',
			destroy: 's_bpr100ukrv_kdService.deleteDetail',
			syncAll: 's_bpr100ukrv_kdService.saveAll'
		}
	});
	var directMasterStore = Unilite.createStore('bpr100ukrvMasterStore',{
			model: 'bpr100ukrvModel',
           	autoLoad: false,
        	uniOpt : {
            	isMaster: true,			// 상위 버튼 연결
            	editable: true,			// 수정 모드 사용
            	deletable:true,			// 삭제 가능 여부
	            useNavi : false			// prev | newxt 버튼 사용
            },
           	proxy: directProxy
			,listeners: {
	            write: function(proxy, operation){
	                if (operation.action == 'destroy') {
	                	Ext.getCmp('detailForm').reset();
	                }
            	}

        	}
        	,loadStoreRecords : function()	{
        		/*
				if(panelSearch.getValue('ITEM_CODE') == '' && panelSearch.getValue('ITEM_NAME') == '' )	{
					alert('품목명이나 품목코드를 입력하세요.');
					if(panelSearch.collapsed )	{
						panelResult.getField('ITEM_CODE').focus();
					}else {
						panelSearch.getField('ITEM_CODE').focus();
					}
					return
				}
				*/

				var param= panelSearch.getValues();

				console.log( param );
				this.load({
								params : param,
								callback : function(records, operation, success) {
									if(success)	{
									}
								}
						   }
				);

			}
			,saveStore : function(config)	{
//				var paramMaster= [];
//				var app = Ext.getCmp('bpr100ukrvApp');
				var inValidRecs = this.getInvalidRecords();
				var toCreate = this.getNewRecords();
            	var toUpdate = this.getUpdatedRecords();
            	console.log("toUpdate",toUpdate);

            	var rv = true;


				if(inValidRecs.length == 0 )	{
					for(var i=0 ; i < toCreate.length ; i++)	{
						if(toCreate[i].data['ITEM_LEVEL1']==null || toCreate[i].data['ITEM_LEVEL1']=='' ){
							toCreate[i].data["ITEM_LEVEL1"]		= "*";
						}
						if(toCreate[i].data['ITEM_LEVEL2']==null || toCreate[i].data['ITEM_LEVEL2']=='' ){
							toCreate[i].data["ITEM_LEVEL2"]		= "*";
						}
						if(toCreate[i].data['ITEM_LEVEL3']==null || toCreate[i].data['ITEM_LEVEL3']=='' ){
							toCreate[i].data["ITEM_LEVEL3"]		= "*";
						}
					}
					for(var i=0 ; i < toUpdate.length ; i++)	{
						if(toUpdate[i].data['ITEM_LEVEL1']==null || toUpdate[i].data['ITEM_LEVEL1']==''){
							toUpdate[i].data["ITEM_LEVEL1"]		= "*";
						}
						if(toUpdate[i].data['ITEM_LEVEL2']==null || toUpdate[i].data['ITEM_LEVEL2']==''){
							toUpdate[i].data["ITEM_LEVEL2"]		= "*";
						}
						if(toUpdate[i].data['ITEM_LEVEL3']==null || toUpdate[i].data['ITEM_LEVEL3']==''){
							toUpdate[i].data["ITEM_LEVEL3"]		= "*";
						}
					}
					config = {
//							params: [paramMaster],
							success: function(batch, option) {
								detailForm.resetDirtyStatus();
								UniAppManager.setToolbarButtons('save', false);
								var record = masterGrid.getSelectedRecord();
								detailForm.setActiveRecord(record);
								//수주등록  엑셀참조의 업로드 그리드 reload
								var appParams = UniAppManager.getApp().uniOpt.appParams;
									if(appParams.action == 'excelNew' && appParams.sender) {
										appParams.sender.getStore().reload();
								}
							 }
					};

//					if(config == null)	{
//						var config = {success :
//											function()	{
//												detailForm.resetDirtyStatus();
//											}
//									}
//
//					}
					this.syncAllDirect(config);
				}else {
					masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
				}
			},
			listeners:{
				update:function( store, record, operation, modifiedFieldNames, eOpts )	{
					//detailForm.setActiveRecord(record);
				}
			}
	});

	/**
	 * 검색 Form
	 */
	var sortSeqStore = Unilite.createStore('bpr100ukrvSeqStore', {
	    fields: ['text', 'value'],
		data :  [
			        {'text':'오름차순'		, 'value':'ASC'},
			        {'text':'내림차순'		, 'value':'DESC'}
	    		]
		});

	var panelSearch = Unilite.createSearchPanel('searchForm', {
		title: '검색조건',
		hidden: true,
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
	    defaults: {
			autoScroll:true
	  	},
		items: [{
			title: '기본정보',
			itemId: 'search_panel1',
			layout: {type: 'vbox', align: 'stretch'},
            items: [{
        		xtype: 'container',
        		layout: {type: 'uniTable', columns: 1},
        		items: [{
        			xtype: 'uniTextfield',
		            name: 'ITEM_CODE',
	    			fieldLabel: '품목코드' ,
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							panelResult.setValue('ITEM_CODE', newValue);
						}
					}
	    		},{
	    			xtype: 'uniTextfield',
	            	name: 'ITEM_NAME',
	            	fieldLabel: '품목명',
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							panelResult.setValue('ITEM_NAME', newValue);
						}
					}
	            }]
			}]
    	}, {
		 	title:'추가정보',
   			id: 'search_panel2',
			itemId:'search_panel2',
        	defaultType: 'uniTextfield',
        	layout: {type: 'uniTable', columns: 1},
		 	items: [{
		    	name: 'ITEM_LEVEL1',
    			fieldLabel: '대분류',
    			xtype:'uniCombobox',
                store: Ext.data.StoreManager.lookup('BPR100ukrvLevel1Store'),
                child: 'ITEM_LEVEL2'
              }, {
              	name: 'ITEM_LEVEL2',
              	fieldLabel: '중분류',
              	xtype:'uniCombobox',
                store: Ext.data.StoreManager.lookup('BPR100ukrvLevel2Store'),
                child: 'ITEM_LEVEL3'

             }, {
             	name: 'ITEM_LEVEL3',
             	fieldLabel: '소분류',
             	xtype:'uniCombobox',
                store: Ext.data.StoreManager.lookup('BPR100ukrvLevel3Store')
            }, {
            	fieldLabel: '검색항목' ,
            	name:'TXTFIND_TYPE',
            	xtype: 'uniCombobox',
            	comboType:'AU',
            	comboCode:'B052',
            	value:'01'
            }, {
            	fieldLabel: '검색어',
            	name: 'TXT_SEARCH' ,
            	xtype: 'uniTextfield'
            }, {
            	fieldLabel: '대표모델',
            	name:'ITEM_GROUP',
            	xtype: 'uniTextfield'
            }, {
	    		xtype: 'radiogroup',
	    		fieldLabel: '사용여부',
	    		items: [{
	    			boxLabel: '사용',
	    			width: 80,
	    			name: 'USE_YN',
	    			inputValue: 'Y',
	    			checked: true
	    		}, {
	    			boxLabel: '미사용',
	    			width: 80,
	    			name: 'USE_YN',
	    			inputValue: 'N'
	    		}]
	        }]
		}]
	});

	var panelResult = Unilite.createSearchForm('resultForm',{
		weight:-100,
    	region: 'north',
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
		items: [{
			name: 'ITEM_CODE',
			fieldLabel: '품목코드' ,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('ITEM_CODE', newValue);
				}
			}
		},{
        	name: 'ITEM_NAME',
        	fieldLabel: '품목명',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('ITEM_NAME', newValue);
				}
			}
        },{
                name: 'ITEM_LEVEL1',
                fieldLabel: '대분류',
                xtype:'uniCombobox',
                store: Ext.data.StoreManager.lookup('BPR100ukrvLevel1Store'),
                child: 'ITEM_LEVEL2'
              },  {
                fieldLabel: '검색항목' ,
                name:'TXTFIND_TYPE',
                xtype: 'uniCombobox',
                comboType:'AU',
                comboCode:'B052',
                value:'01'
            }, {
                fieldLabel: '검색어',
                name: 'TXT_SEARCH' ,
                xtype: 'uniTextfield'
            },{
                name: 'ITEM_LEVEL2',
                fieldLabel: '중분류',
                xtype:'uniCombobox',
                store: Ext.data.StoreManager.lookup('BPR100ukrvLevel2Store'),
                child: 'ITEM_LEVEL3'

             },{
                xtype: 'radiogroup',
                fieldLabel: '사용여부',
                items: [{
                    boxLabel: '사용',
                    width: 80,
                    name: 'USE_YN',
                    inputValue: 'Y',
                    checked: true
                }, {
                    boxLabel: '미사용',
                    width: 80,
                    name: 'USE_YN',
                    inputValue: 'N'
                }]
            }, {
                fieldLabel: '대표모델',
                name:'ITEM_GROUP',
                xtype: 'uniTextfield'
            }, {
                name: 'ITEM_LEVEL3',
                fieldLabel: '소분류',
                xtype:'uniCombobox',
                store: Ext.data.StoreManager.lookup('BPR100ukrvLevel3Store')
            } ]
    });


    /**
     * Master Grid
     */
	 var masterGrid = Unilite.createGrid('bpr100ukrvGrid', {
    	region:'center',
    	store : directMasterStore,
    	sortableColumns : false,
    	//border:false,
    	uniOpt:{
    				 expandLastColumn: true
    				,useRowNumberer: false
    				,useMultipleSorting: true
    			},
    	/* tbar: ['->',
            {
	        	text:'상세보기',
	        	handler: function() {
	        		var record = masterGrid.getSelectedRecord();
		        	if(record) {
		        		openDetailWindow(record);
		        	}
	        	}
            }
        ],*/
        columns:  [  { dataIndex: 'ITEM_CODE',  	width: 160		,isLink:true, locked: true}
			  		,{ dataIndex: 'ITEM_NAME',  	width: 140		,locked: true}
			  		,{ dataIndex: 'ITEM_NAME1',  	width: 180		,hidden:true}
			  		,{ dataIndex: 'ITEM_NAME2',  	width: 180		,hidden:true}
			  		,{ dataIndex: 'SPEC',  			width: 170		}
			  		,{ dataIndex: 'STOCK_UNIT',  	width: 120, align: 'center'		}
				    ,{ dataIndex: 'ITEM_LEVEL1',  	width: 120	,store: Ext.data.StoreManager.lookup('BPR100ukrvLevel1Store'), child:'ITEM_LEVEL2', hidden: true}
				    ,{ dataIndex: 'ITEM_LEVEL2',  	width: 120	,store: Ext.data.StoreManager.lookup('BPR100ukrvLevel2Store'), child:'ITEM_LEVEL3', hidden: true}
				    ,{ dataIndex: 'ITEM_LEVEL3',  	width: 120	,store: Ext.data.StoreManager.lookup('BPR100ukrvLevel3Store'), hidden: true}
				    ,{ dataIndex: 'ITEM_GROUP',  	width: 100, hidden: true
				    	, 'editor':  Unilite.popup('ITEM_GROUP_G',{textFieldName:'ITEM_GROUP', DBtextFieldName:'ITEM_CODE',
				    											autoPopup: true,
				    											listeners:{
				    												'onSelected': {
													                    fn: function(records, type  ){
													                    	var me = this;
													                    	var grdRecord = masterGrid.uniOpt.currentRecord;
													                    	grdRecord.set('ITEM_GROUP_NAME',records[0]['ITEM_NAME']);
													                    },
													                    scope: this
													                },
													                'onClear' : function(type){
													                		var me = this;
													                    	var grdRecord = masterGrid.uniOpt.currentRecord;
													                    	grdRecord.set('ITEM_GROUP_NAME','');
													                }
				    											}
				    										}
				    			)
				     }
				    ,{ dataIndex: 'ITEM_GROUP_NAME',width: 150, hidden: true
				    	, 'editor':  Unilite.popup('ITEM_GROUP_G',{textFieldName:'ITEM_GROUP_NAME', DBtextFieldName:'ITEM_NAME',
			    											autoPopup: true,
				    										listeners:{
				    												'onSelected': {
													                    fn: function(records, type  ){
													                    	var me = this;
													                    	var grdRecord = masterGrid.uniOpt.currentRecord;
													                    	grdRecord.set('ITEM_GROUP',records[0]['ITEM_CODE']);
													                    },
													                    scope: this
													                },
													                'onClear' : function(type){
													                		var me = this;
													                    	var grdRecord = masterGrid.uniOpt.currentRecord;
													                    	grdRecord.set('ITEM_GROUP','');
													                }
				    											}
				    		})}
				    ,{ dataIndex: 'ITEM_COLOR',  	width: 120		,hidden:true}
				    ,{ dataIndex: 'ITEM_SIZE',  	width: 120		,hidden:true}
			  		,{ dataIndex: 'UNIT_WGT',  		width: 80		,hidden: true}
			  		,{ dataIndex: 'WGT_UNIT',  		width: 80		,hidden:true}
			  		,{ dataIndex: 'UNIT_VOL',		width: 80		,hidden:true}
					,{ dataIndex: 'VOL_UNIT',		width: 80		,hidden:true}
					,{ dataIndex: 'REIM',			width: 80		,hidden:true, align: 'right', align: 'right', xtype:'numbercolumn' , format:'${REIM_PrecisionFormat}',
				   		 									editor: {  xtype: 'uniNumberfield',  decimalPrecision: '${REIM_Precision}' }
				     }
			  		,{ dataIndex: 'SPEC_NUM',  		width: 90		,hidden:true}
			  		,{ dataIndex: 'SALE_UNIT',  	width: 120, align: 'center'}
			  		,{ dataIndex: 'TRNS_RATE',  	width: 80		}
			  		,{ dataIndex: 'TAX_TYPE',  		width: 80, align: 'center'}
			  		,{ dataIndex: 'SALE_BASIS_P',  	width: 120		}
			  		,{ dataIndex: 'DOM_FORIGN',  	width: 70		,hidden:true}
			  		,{ dataIndex: 'STOCK_CARE_YN',  width: 80		,hidden:true}
			  		,{ dataIndex: 'TOTAL_ITEM',  	width: 100 		,hidden:true
			  			, 'editor':  Unilite.popup('ITEM_G',{textFieldName:'TOTAL_ITEM', DBtextFieldName:'ITEM_CODE',
			    											autoPopup: true,
			  												listeners:{
				    												'onSelected': {
													                    fn: function(records, type  ){
													                    	var me = this;
													                    	var grdRecord = masterGrid.uniOpt.currentRecord;
													                    	grdRecord.set('TOTAL_ITEM',records[0]['ITEM_CODE']);
													                    	grdRecord.set('TOTAL_ITEM_NAME',records[0]['ITEM_NAME']);
													                    },
													                    scope: this
													                },
													                'onClear' : function(type){
													                		var me = this;
													                    	var grdRecord = masterGrid.uniOpt.currentRecord;
													                    	grdRecord.set('TOTAL_ITEM','');
													                    	grdRecord.set('TOTAL_ITEM_NAME','');
													                }
				    											}
				    										})
			  		 }
			  		,{ dataIndex: 'TOTAL_ITEM_NAME',width: 150		,hidden:true
			 		, 'editor':  Unilite.popup('ITEM_G',{textFieldName:'TOTAL_ITEM_NAME', DBtextFieldName:'ITEM_NAME',
			    											autoPopup: true,
			  												listeners:{
				    												'onSelected': {
													                    fn: function(records, type  ){
													                    	var me = this;
						 								                    	var grdRecord = masterGrid.uniOpt.currentRecord;
													                    	grdRecord.set('TOTAL_ITEM',records[0]['ITEM_CODE']);
													                    	grdRecord.set('TOTAL_ITEM_NAME',records[0]['ITEM_NAME']);
													                    },
													                    scope: this
													                },
													                'onClear' : function(type){
													                		var me = this;
													                    	var grdRecord = masterGrid.uniOpt.currentRecord;
													                    	grdRecord.set('TOTAL_ITEM','');
													                    	grdRecord.set('TOTAL_ITEM_NAME','');
													                }
				    											}
			  									})
			  		 }
			  		,{ dataIndex: 'TOTAL_TRAN_RATE',width: 90		,hidden:true}
			  		,{ dataIndex: 'BARCODE',  		width: 100		,hidden:true}
			  		,{ dataIndex: 'HS_NO',  		width: 100		,hidden:true}
			  		,{ dataIndex: 'HS_NAME',  		width: 120		,hidden:true}
			  		,{ dataIndex: 'HS_UNIT',  		width: 80		,hidden:true}
			  		,{ dataIndex: 'ITEM_MAKER',  	width: 120		,hidden:true}
			  		,{ dataIndex: 'ITEM_MAKER_PN',  width: 120		,hidden:true}
			  		,{ dataIndex: 'PIC_FLAG',  		width: 70		,hidden:true}
			  		,{ dataIndex: 'START_DATE',  	width: 100		,hidden:true}
			  		,{ dataIndex: 'STOP_DATE',  	width: 100		,hidden:true}
			  		,{ dataIndex: 'USE_YN',  		width: 80		,hidden:true}
			  		,{ dataIndex: 'EXCESS_RATE',  	width: 80		,hidden:true}
			  		,{ dataIndex: 'USE_BY_DATE',  	width: 80		,hidden:true}
			  		,{ dataIndex: 'TEMPC_01',       width: 80		,hidden:true}
			  		,{ dataIndex: 'CAR_TYPE',    	width: 80		,hidden:true}
			  		,{ dataIndex: 'OEM_ITEM_CODE',  width: 80		,hidden:true}
			  		,{ dataIndex: 'AS_ITEM_CODE',   width: 80		,hidden:true}
			  		,{ dataIndex: 'B_OUT_YN',       width: 80		,hidden:true}
			  		,{ dataIndex: 'B_OUT_DATE',  	width: 100		,hidden:true}
			  		,{ dataIndex: 'MAKE_STOP_YN',   width: 80		,hidden:true}
			  		,{ dataIndex: 'MAKE_STOP_DATE', width: 100		,hidden:true}
			  		,{ dataIndex: '_EXCEL_JOBID',  width: 80		,hidden:true}
			  		,{ dataIndex: '_EXCEL_ROWNUM',  width: 80		,hidden:true}
          ] ,
          listeners: {
          	selectionchangerecord:function(selected)	{
//          		detailForm.loadForm(selected);
          		detailForm.setActiveRecord(selected)
          	},
//			celldblclick: function( tbl, td, cellIndex, record, tr, rowIndex, e, eOpts )	{
//				/*var edit = masterGrid.findPlugin('cellediting');
//				if(Ext.isDefined(edit) && edit.editing)	{
//					edit.completeEdit();
//				}*/
//				masterGrid.hide();
//			},
          	onGridDblClick:function(grid, record, cellIndex, colName) {
          		if(!record.phantom) {
	      			switch(colName)	{
					case 'ITEM_CODE' :
							masterGrid.hide();
							//detailForm.setActive(true);
							//detailForm.setActiveRecord(record);
							break;
					default:
							break;
	      			}
          		}
          	},
//			beforehide: function(grid, eOpts )	{
//				if(directMasterStore.isDirty() )	{
//					var config={
//						success:function()	{
//							masterGrid.hide();
//						}
//					};
//					UniAppManager.app.confirmSaveData(config);
//					return false;
//				}
//			},
			hide:function()	{
				detailForm.show();
			},
			show:function()	{
				/*var record = masterGrid.getSelectedRecord();
				var idx=directMasterStore.indexOf(record);
				//masterGrid.getView().refreshNode(idx);
				masterGrid.getView().refresh();
				//masterGrid.moveTo(idx,0);
*/
				/* IE의 경우 grid에서 아래로 스크롤 후 상세보기에서 되돌아 오면 grid에 빈 여백이 생김.
				 * - 상세보기에서 삭제 후 grid로 되돌아 오면 오류 발생으로 인해 제거
				var sm = masterGrid.getSelectionModel();
				var selected = sm.getLastSelected();
				var idx=directMasterStore.indexOf(selected);
				if(selected) {
					sm.select(selected);
					masterGrid.moveTo(idx,0);
				}*/
			}
          }
    });

    /**
     * 상세 Form
     */
     var itemImageForm = Unilite.createForm('lkasdf' +
     		'itemImageForm', {
	    	 			 fileUpload: true,
						 url:  CPATH+'/fileman/upload.do',
						 disabled:false,
				    	 width:450,
				    	 height:250,
				    	 //hidden: true,
	    	 			 layout: {type: 'uniTable', columns: 2},
						 items: [
        						  { xtype: 'filefield',
									buttonOnly: false,
									fieldLabel: '사진',
									hideLabel:true,
									width:350,
									name: 'fileUpload',
									buttonText: '파일선택',
									listeners: {change : function( filefield, value, eOpts )	{
															var fileExtention = value.lastIndexOf(".");
															//FIXME : 업로드 확장자 체크, 이미지파일만 upload
															if(value !='' )	{
																var record = masterGrid.getSelectedRecord();
																detailForm.setValue('_fileChange', 'true');
																//detailWin.setToolbarButtons(['saveBtn','saveCloseBtn'],true);
		                    						 			//detailWin.setToolbarButtons(['prev','next'],false);
															}
														}
									}
								  }
								  ,{ xtype: 'button', text:'올리기', margin:'0 0 0 2',
								  	 handler:function()	{
								  	 	var config = {success : function()	{
								  	 						var selRecord = masterGrid.getSelectedRecord();
                        									detailForm.loadForm(selRecord);				// 입력값 이외의 자동생성 필드가 있다면 반드시 넣어준다.
		                    						 		//detailWin.setToolbarButtons(['saveBtn','saveCloseBtn'],false);
		                    						 		//detailWin.setToolbarButtons(['prev','next'],true);
					                    			  }
			                    			}
			                        	UniAppManager.app.onSaveDataButtonDown(config);
								  	 }
								  }
								  ,
								  { xtype: 'image', id:'bpr100Image', src:CPATH+'/resources/images/nameCard.jpg', width:400,	 overflow:'auto', colspan:2}
					             ]
					   , setImage : function (fid)	{
						    	 	var image = Ext.getCmp('bpr100Image');
						    	 	var src = CPATH+'/resources/images/nameCard.jpg'
						    	 	if(!Ext.isEmpty(fid))	{
							         	//src = CPATH+'/fileman/download.do?fid='+fid+'&inline=Y';
							         	src= CPATH+'/fileman/view/'+fid;
						    	 	}
							        image.setSrc(src);
						    	 }
	});

    var detailForm = Unilite.createForm('detailForm', {
    	//region:'south',
    	//weight:-100,
    	//height:400,
    	//split:true,

    	hidden: true,
    	autoScroll: true,
    	masterGrid: masterGrid,

        padding: '0 0 0 1',
	    layout: {type: 'uniTable', columns: 3, tableAttrs:{cellpadding:5}, tdAttrs: {valign:'top'}},
	    defaultType: 'uniFieldset',
	    defaults : { margin: '0 0 0 0'},
	    items : [{
        			  title: '기본정보'
        			, defaultType: 'uniTextfield'
        			, layout: { type: 'uniTable', columns: 1}
        			, height: 480
        			, items :[	 { name: 'ITEM_CODE',  			fieldLabel: '품목코드', 	 hidden: false, allowBlank:false,maxLength: 20}
						  		,{ name: 'ITEM_NAME',  			fieldLabel: '품명', 		 hidden: false, allowBlank:false, maxLength: 200}
						  		,{ name: 'ITEM_NAME1',  		fieldLabel: '품명1' 		, maxLength: 200}
						  		,{ name: 'ITEM_NAME2',  		fieldLabel: '품명2' 		, maxLength: 200}
						  		,{ name: 'STOCK_UNIT',  		fieldLabel: '재고단위',		 xtype:'uniCombobox',	comboType:'AU', comboCode:'B013' , fieldStyle: 'text-align: center;', allowBlank:false, displayField: 'value'}
						  		,{ name: 'ITEM_LEVEL1',  		fieldLabel: '대분류' 		,xtype:'uniCombobox', store: Ext.data.StoreManager.lookup('BPR100ukrvLevel1Store'), child: 'ITEM_LEVEL2'}
						  		,{ name: 'ITEM_LEVEL2',  		fieldLabel: '중분류' 		,xtype:'uniCombobox', store: Ext.data.StoreManager.lookup('BPR100ukrvLevel2Store'), child: 'ITEM_LEVEL3'}
						  		,{ name: 'ITEM_LEVEL3',  		fieldLabel: '소분류' 		,xtype:'uniCombobox', store: Ext.data.StoreManager.lookup('BPR100ukrvLevel3Store')}
						  		, Unilite.popup('ITEM_GROUP',{fieldLabel: '대표모델', textFieldName:'ITEM_GROUP_NAME', valueFieldName:'ITEM_GROUP', valueFieldWidth:120, textFieldWidth:150, verticalMode:true})
						  		,{ name: 'START_DATE',  		fieldLabel: '사용시작일', 	xtype : 'uniDatefield', maxLength: 10}
						  		,{ name: 'STOP_DATE',  			fieldLabel: '사용중단일', 	xtype : 'uniDatefield', maxLength: 10}
						  		,{ name: 'USE_YN',  			fieldLabel: '사용여부', 	xtype:'uniRadiogroup', comboType:'AU', comboCode:'B010', width:235, allowBlank:false}
						  		,{ name: 'CAR_TYPE',  		    fieldLabel: '차종',		xtype:'uniCombobox',	comboType:'AU', comboCode:'WB04', width:235}
						  		,{ name: 'OEM_ITEM_CODE',  		fieldLabel: 'OEM코드' 	, maxLength: 20}
						  		,Unilite.popup('ITEM3', {
									fieldLabel: 'AS코드',
									maxLength: 20,
									listeners: {
												onSelected: {
													fn: function(records, type) {
														detailForm.setValue('AS_ITEM_CODE', panelSearch.getValue('ITEM_CODE'));
													},
													scope: this
												},
												onClear: function(type)	{
													detailForm.setValue('AS_ITEM_CODE', '');
												}
											}
								})
					         ]
	    		}
	    	   ,{     title: '제원(판매)정보'
        			, layout: {
					            type: 'uniTable',
					            columns: 1
					        }
        			, defaults: {type: 'uniTextfield',  labelWidth:90}
        			, height: 480
        			, items :[	 { name: 'SPEC',  				fieldLabel: '규격' 			,maxLength: 160}
							    ,{ name: 'ITEM_COLOR',  		fieldLabel: '색상' 			,maxLength: 20}
							    ,{ name: 'ITEM_SIZE',  			fieldLabel: '사이즈' 		,maxLength: 50}
							    ,{ xtype:'fieldset',
							       border:0,
							       layout:{type:'hbox', align:'stretch'},
							       margin:'0 0 0 0',
							       width:255,
							       items :[
							  		 { name: 'UNIT_WGT',  			fieldLabel: '단위중량/단위', 	xtype : 'uniNumberfield', width:170, labelWidth:80, maxLength: 18}
							  		,{ name: 'WGT_UNIT',  			hideLabel:true, fieldLabel: '중량단위', width:65,	xtype:'uniCombobox' ,comboType:'AU', fieldStyle: 'text-align: center;', comboCode:'B013', displayField: 'value'}
							    	]
							     }
						  		,{ xtype:'fieldset',
							       border:0,
							       layout:{type:'hbox', align:'stretch'},
							       margin:'0 0 0 0',
							       width:255,
							       items :[
							       			 { name: 'UNIT_VOL',			fieldLabel: '단위부피/단위',		xtype : 'uniNumberfield', width:170, labelWidth:80, maxLength: 18}
											,{ name: 'VOL_UNIT',			fieldLabel: '부피단위',		hideLabel:true, width:65 , xtype:'uniCombobox' ,comboType:'AU', fieldStyle: 'text-align: center;', comboCode:'B013', displayField: 'value'}
										  ]
						  		}
								,{ name: 'REIM',				fieldLabel: '비중',			xtype : 'uniNumberfield',	decimalPrecision:'${REIM_Precision}', maxLength: 18}
						  		,{ name: 'SPEC_NUM',  			fieldLabel: '도면번호' 		,maxLength: 20}
						  		,{ name: 'SALE_UNIT',  			fieldLabel: '판매단위', 	xtype:'uniCombobox', comboType:'AU', comboCode:'B013', fieldStyle: 'text-align: center;', allowBlank:false, displayField: 'value'}
						  		,{ name: 'TRNS_RATE',  			fieldLabel: '판매입수', 	xtype : 'uniNumberfield',decimalPrecision:2, maxLength: 12}
						  		,{ name: 'EXCESS_RATE',  		fieldLabel: '과출고허용률', xtype : 'uniNumberfield',  decimalPrecision:'2'}
						  		,{ name: 'TAX_TYPE',  			fieldLabel: '세구분', 	xtype:'uniCombobox', comboType:'AU', comboCode:'B059' , allowBlank:false}
						  		,{ name: 'SALE_BASIS_P',  	 	fieldLabel: '판매단가', 	xtype : 'uniNumberfield', maxLength: 18}
						  		,{ name: 'SQUARE_FT',  			fieldLabel: '면적(S/F)', 	xtype : 'uniNumberfield', value:0}
						  		,{ name: 'B_OUT_YN',    		fieldLabel: '밸런스아웃여부', xtype:'uniRadiogroup', width:235, comboType:'AU', comboCode:'A020', allowBlank:false,
						  			listeners: {
										change: function(combo, newValue, oldValue, eOpts) {
										/* 	if(newValue.B_OUT_YN == 'N' && detailForm.getValue('MAKE_STOP_YN').MAKE_STOP_YN == 'Y'){
												alert("생산중지여부가 Y이므로 바꿀수 없습니다");
												detailForm.setValue('B_OUT_YN', 'Y');
											} */

										}
									}
						  		}
						  		,{ name: 'B_OUT_DATE',  		fieldLabel: '밸런스아웃일자', xtype : 'uniDatefield', maxLength: 10}
								,{ name: 'MAKE_STOP_YN',    	fieldLabel: '생산중지여부',  xtype:'uniRadiogroup', width:235, comboType:'AU', comboCode:'A020', allowBlank:false,
						  			listeners: {
										change: function(combo, newValue, oldValue, eOpts) {
											/* if(newValue.MAKE_STOP_YN == 'Y' && detailForm.getValue('B_OUT_YN').B_OUT_YN == 'N'){
												alert("밸런스아웃여부가 N이므로 바꿀수 없습니다");
												detailForm.setValue('MAKE_STOP_YN', 'N');
											} */

										}
									}
								}
								,{ name: 'MAKE_STOP_DATE',  	fieldLabel: '생산중지일자',  xtype : 'uniDatefield', maxLength: 10}

        					]
	    		}
	    		,{  title: '일반정보'
	    			, layout: {
					            type: 'uniTable',
					            columns: 1
					        }
        			, defaults: {type: 'uniTextfield',  labelWidth:100}
        			, height: 480
        			,items :[	 { name: 'DOM_FORIGN',  		fieldLabel: '국내외', 		xtype:'uniCombobox', comboType:'AU', comboCode:'B019' }
						  		,{ name: 'STOCK_CARE_YN',  		fieldLabel: '재고관리대상',  xtype:'uniRadiogroup', comboType:'AU', comboCode:'B010', width:235, allowBlank:false}
						  		, Unilite.popup('DIV_PUMOK',	{fieldLabel: '집계품목', textFieldName:'TOTAL_ITEM_NAME', valueFieldName:'TOTAL_ITEM', valueFieldWidth:120, textFieldWidth:150, verticalMode:true})
						  		,{ name: 'TOTAL_TRAN_RATE', 	fieldLabel: '집계환산계수', xtype : 'uniNumberfield', maxLength: 12}
						  		,{ name: 'BARCODE',  			fieldLabel: '바코드' 		,maxLength: 15}
						  		//,{ name: 'HS_NO',  				fieldLabel: 'HS번호' 		,maxLength: 20}
						  		,Unilite.popup('HS_G', {
						  			name: 'HS_NO',  	
						  			id: 'HS_NO',
						  			fieldLabel: 'HS번호',
						  			maxLength: 20,
				                    autoPopup:true,
				                    listeners: {
				                        'onSelected': {
				                            fn: function(records, type) {
				                                console.log('records : ', records);
				                                detailForm.setValue('HS_NO', records[0]['HS_NO']);
				                                detailForm.setValue('HS_NAME', records[0]['HS_NAME']);
				                                detailForm.setValue('HS_UNIT', records[0]['HS_UNIT']);
				                                Ext.getCmp('HS_NO').blur();
				                            },
				                            scope: this
				                        },
				                        'onClear': function(type) {
				                            detailForm.setValue('HS_NO', '');
				                            detailForm.setValue('HS_NAME', '');
				                            detailForm.setValue('HS_UNIT', '');
				                        },
				                        applyextparam: function(popup){

				                        }
				                    }
				                })
				                ,Unilite.popup('HS_G', {
						  			name: 'HS_NAME',  				
						  			fieldLabel: 'HS명',
						  			maxLength: 20,
				                    autoPopup:true,
				                    listeners: {
				                        'onSelected': {
				                            fn: function(records, type) {
				                                console.log('records : ', records);
				                                detailForm.setValue('HS_NO', records[0]['HS_NO']);
				                                detailForm.setValue('HS_NAME', records[0]['HS_NAME']);
				                                detailForm.setValue('HS_UNIT', records[0]['HS_UNIT']);
				                            },
				                            scope: this
				                        },
				                        'onClear': function(type) {
				                            detailForm.setValue('HS_NO', '');
				                            detailForm.setValue('HS_NAME', '');
				                            detailForm.setValue('HS_UNIT', '');
				                        },
				                        applyextparam: function(popup){

				                        }
				                    }
				                })
						  		//,{ name: 'HS_NAME',  			fieldLabel: 'HS명' 			,maxLength: 60}
						  		,{ name: 'HS_UNIT',  			fieldLabel: 'HS단위' 		,xtype:'uniCombobox'	,comboType:'AU', fieldStyle: 'text-align: center;', comboCode:'B013', displayField: 'value'}
						  		,{ name: 'ITEM_MAKER',  		fieldLabel: '제조메이커' 	,maxLength: 50}
						  		,{ name: 'ITEM_MAKER_PN',  	 	fieldLabel: '메이커 Part No',maxLength: 50}
						  		,{ name: 'USE_BY_DATE',  		fieldLabel: '유효일자', 	value:'${UseByDate}', xtype : 'uniNumberfield'}
						  		,{ name: 'CIR_PERIOD_YN',  		fieldLabel: '유통기한관리',  xtype:'uniRadiogroup',comboType:'AU', comboCode:'B010', value:'N', width:235, allowBlank:false}
                                ,{ name: 'TEMPC_01',            fieldLabel: '자동검수예외',  xtype:'uniRadiogroup',comboType:'AU', comboCode:'B010', value:'N', width:235, allowBlank:false}
        					 ]
	    		}
	    		,{  title: '제품사진'
	    			, colspan: 3
	    			, layout: {
					            type: 'uniTable',
					            columns: 1,
					            tdAttrs: {valign:'top'}
					        }
        			, defaults: {type: 'uniTextfield'}
        			,items :[	 itemImageForm
        						,{ name: '_fileChange',  			fieldLabel: '사진수정여부'  ,hidden:true	}
        					 ]
	    		}
	    		,{  title: '비고'
	    			, colspan: 3
					, layout: {
					            type: 'uniTable',
					            columns: 1
					        }
					, defaults : { type:'uniTextfield'}
        			,items :[	 { name: 'REMARK1',  			fieldLabel: '비고사항1'  ,width:785	}
						  		,{ name: 'REMARK2',  			fieldLabel: '비고사항2'  ,width:785	}
						  		,{ name: 'REMARK3',  			fieldLabel: '비고사항3'  ,width:785	}

        					 ]
	    		}
	    	]
			,loadForm: function(record)	{
   				//selectionchangerecord에서 호출
				this.reset();
				this.setActiveRecord(record);
				//this.activeRecord = record;
	          	this.loadRecord(record);
				this.resetDirtyStatus();
				itemImageForm.setImage(record.get('IMAGE_FID'));


				/*var win = this.up('uniDetailFormWindow');
                if(win) {       // 처음 윈도열때는 윈독 존재 하지 않음.
   				     win.setToolbarButtons(['saveBtn','saveCloseBtn'],false);
                     win.setToolbarButtons(['prev','next'],true);
                }*/
   			},
   			listeners:{
   				/*
				beforehide: function(grid, eOpts )	{
					if(directMasterStore.isDirty() )	{
						var config={
							success:function()	{
								detailForm.hide();
							}
						};
						UniAppManager.app.confirmSaveData(config);
						return false;
					}
				},
				*/
				hide:function()	{
					masterGrid.show();
					if(panelSearch.getCollapsed()){		//panelSearch가 닫혀 있으면..
						panelResult.show();
					}
				}

   			}

	});

    /*
	function openDetailWindow(selRecord, isNew) {

			UniAppManager.app.confirmSaveData();

			// 추가 Record 인지 확인
			if(isNew)	{
				var r = masterGrid.createRow();
				selRecord = r[0];
			}
			// form에 data load
			detailForm.resetDirtyStatus();
			detailForm.loadForm(selRecord);

			if(!Ext.isEmpty(selRecord.get('IMAGE_FID')))	{
				//itemImageForm.hide();
				itemImageForm.setImage(selRecord.get('IMAGE_FID'));
			}
			if(!detailWin) {
				detailWin = Ext.create('widget.uniDetailFormWindow', {
	                title: '상세정보',
	                width: 880,
	                height: 500,
	                isNew: false,
	                x:0,
	                y:0,
	                items: [detailForm],

	                 onCloseButtonDown: function() {
                        this.hide();
                    },
                    onDeleteDataButtonDown: function() {
                        var record = masterGrid.getSelectedRecord();
                        var phantom = record.phantom;
                        UniAppManager.app.onDeleteDataButtonDown();
                        var config = {success :
                                    function()  {
                                        detailWin.hide();
                                    }
                            }
                        if(!phantom)    {

                                UniAppManager.app.onSaveDataButtonDown(config);

                        } else {
                            detailWin.hide();
                        }
                    },
                    onSaveDataButtonDown: function() {
                        var config = {success : function()	{

                    						 	detailWin.setToolbarButtons(['saveBtn','saveCloseBtn'],false);
                    						 	detailWin.setToolbarButtons(['prev','next'],true);
                    					}
                    	}
                        UniAppManager.app.onSaveDataButtonDown(config);
                    },
                    onSaveAndCloseButtonDown: function() {
                        if(!detailForm.isDirty())   {
                            detailWin.hide();
                        }else {
                            var config = {success :
                                        function()  {
                                            detailWin.hide();
                                        }
                                }
                            UniAppManager.app.onSaveDataButtonDown(config);
                        }
                    },
			        onPrevDataButtonDown:  function()   {
			            if(masterGrid.selectPriorRow()) {
	                        var record = masterGrid.getSelectedRecord();
	                        if(record) {
                                detailForm.loadForm(record);
	                        }
                        }
			        },
			        onNextDataButtonDown:  function()   {
			            if(masterGrid.selectNextRow()) {
                            var record = masterGrid.getSelectedRecord();
                            if(record) {
                                detailForm.loadForm(record);
                            }
                        }
			        }
				})
    		}

			detailWin.show();

    }
    */

     Unilite.Main({
      	id  : 'bpr100ukrvApp',
		borderItems : [
			panelSearch,
			panelResult,
			{	region:'center',
				//layout : 'border',
				title:'품목정보',
				layout : {type:'vbox', align:'stretch'},
				flex:1,
				autoScroll:true,
				tools: [
					{
						type: 'hum-grid',
			            handler: function () {
			            	detailForm.hide();
			            	UniAppManager.setToolbarButtons(['save'],true);
			                //masterGrid.show();
			            	//panelResult.show();
			            }
					},{

						type: 'hum-photo',
			            handler: function () {
			            	/*
			            	var edit = masterGrid.findPlugin('cellediting');
							if(edit && edit.editing)	{
								setTimeout("edit.completeEdit()", 1000);
							}
							*/
			                masterGrid.hide();
			                panelResult.hide();
			                //detailForm.show();
			            }
					}
				],
				items:[
					masterGrid,
					detailForm
				]
			}
		],
		fnInitBinding : function(params) {
			this.processParams(params);
			detailForm.setActiveRecord(null);
			UniAppManager.setToolbarButtons(['reset','newData','detail'],true);
	    },
	    onQueryButtonDown: function () {
	    	detailForm.clearForm();
			detailForm.resetDirtyStatus();
			//2017.12.11 표원상부장 요청
//            if(Ext.isEmpty(panelSearch.getValue('ITEM_CODE')) && Ext.isEmpty(panelSearch.getValue('ITEM_NAME'))){
//                alert('품목 조회 조건을 입력하세요.');
//                return false;
//            }
			masterGrid.getStore().loadStoreRecords();

		},
		onNewDataButtonDown : function()	{
			var r = {
				ITEM_CODE: '',
                B_OUT_YN: 'N',
                MAKE_STOP_YN: 'N'
	        };
			masterGrid.createRow(r);
			//openDetailWindow(null, true);
		},
		onPrevDataButtonDown:  function()	{
			masterGrid.selectPriorRow();
		},
		onNextDataButtonDown:  function()	{
			masterGrid.selectNextRow();
		},
		onSaveAsExcelButtonDown: function() {
			masterGrid.downloadExcelXml();
		},
		/**
		 *  삭제
		 */
		 onDeleteDataButtonDown: function() {
			if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {

				masterGrid.deleteSelectedRow();
//				detailForm.clearForm();

			}
		},

		checkMandatoryVal:function() {
			var bValueChk = true;
			var toCreate = directMasterStore.getNewRecords();
       		var toUpdate = directMasterStore.getUpdatedRecords();
       		var recordList = [].concat(toUpdate, toCreate);
	    	//var updateReco = directMasterStore.getUpdatedRecords();
	    	bValueChk = Ext.each(recordList, function(record,i){
	    		if (record.get('B_OUT_YN') == 'Y'){
        			if (Ext.isEmpty(record.get('B_OUT_DATE'))){
        				alert('밸런스아웃여부가 Y이면 밸런스아웃일자를 입력하셔야 합니다');
        				return false;
        			}

	        	}
				if (record.get('MAKE_STOP_YN') == 'Y'){
	        		if (Ext.isEmpty(record.get('MAKE_STOP_DATE'))){
        				alert('생산중지여부가 Y이면 생산중지일자를 입력하셔야 합니다');
        				return false;
        			}
	        	}

			});
	    	return bValueChk;
        },

		/**
		 *  저장
		 */
		onSaveDataButtonDown: function (config) {
			if(itemImageForm.isDirty())	{
				itemImageForm.submit({
							waitMsg: 'Uploading...',
							success: function(form, action) {
								if( action.result.success === true)	{
									masterGrid.getSelectedRecord().set('IMAGE_FID',action.result.fid);
									if(!UniAppManager.app.checkMandatoryVal()){
										return;
									}else{
										directMasterStore.saveStore(config);
									}
									itemImageForm.setImage(action.result.fid);
									itemImageForm.clearForm();
								}
							}
					});
			}else {
				if(!UniAppManager.app.checkMandatoryVal()){
					return;
				}else{
					directMasterStore.saveStore(config);
				}
			}
		}
		,onDetailButtonDown:function() {
				var as = Ext.getCmp('bpr100ukrvAdvanceSerch');
				if(as.isHidden())	{
					as.show();
				}else {
					as.hide()
				}
		}
		,onResetButtonDown:function() {
			panelSearch.clearForm();
			panelResult.clearForm();
			masterGrid.getStore().loadData({});
			masterGrid.reset();
			detailForm.hide();
			this.fnInitBinding(false);
		},
		processParams: function(params) {
			this.uniOpt.appParams = params;

			if(params && params.ITEM_CODE ) {
				if(params.action == 'excelNew') {	//품목 신규 등록(수주등록->엑셀참조에서 호출)
					var rec = masterGrid.createRow(
						{
							_EXCEL_JOBID: params._EXCEL_JOBID,		//SOF112T Key1
							_EXCEL_ROWNUM: params._EXCEL_ROWNUM,	//SOF112T Key2
							ITEM_CODE: params.ITEM_CODE
						}
					);

					masterGrid.hide();
			        panelResult.hide();

			        detailForm.loadForm(rec);
			        detailForm.show();

		   			UniAppManager.setToolbarButtons(['save'],true);
				} else {
					panelSearch.setValue('ITEM_CODE',params.ITEM_CODE);
					masterGrid.getStore().loadStoreRecords();
				}
			}
		},
		saveStoreEvent: function(str, newCard)	{
			var config = null;
			this.onSaveDataButtonDown(config);
		}, // end saveStoreEvent()

		rejectSave: function()	{
			var rowIndex = masterGrid.getSelectedRowIndex();
			directMasterStore.rejectChanges();
			if(masterGrid.getStore().getCount() > 0)	{
				masterGrid.select(rowIndex);
			}
			directMasterStore.onStoreActionEnable();
		} // end rejectSave()
		, confirmSaveData: function(config)	{
        	if(directMasterStore.isDirty() )	{
				if(confirm(Msg.sMB061))	{
					this.onSaveDataButtonDown(config);
				} else {
					this.rejectSave();
					detailForm.resetDirtyStatus();
					//if (detailWin.isVisible())	detailWin.hide();
				}
			}
        }
	});

	Unilite.createValidator('validator01', {
		store : directMasterStore,
		grid: masterGrid,
		forms: {'formA:':detailForm},
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;

			if(fieldName == "SALE_BASIS_P" )	{
				   //alert('SALE_BASIS_P');
					if(newValue < 0 ) {
						 rv='<t:message code="unilite.msg.sMB076" default="양수만 입력가능합니다."/>';
						 record.set('SALE_BASIS_P',oldValue);
					}
			}else if(fieldName == "START_DATE" ) {
					if(record.get('STOP_DATE') != null &&
						(newValue > record.get('STOP_DATE') ) ) {
						 rv=Msg.sMB084;
						 record.set('START_DATE',oldValue);
					}
			}else if(fieldName == "STOP_DATE")	{
					if(record.get('START_DATE') != null &&
						(newValue < record.get('START_DATE') ) ) {
						 rv=Msg.sMB084;
						 record.set('STOP_DATE',oldValue);
					}
			} else if (fieldName == "USE_BY_DATE") {
					if(newValue < 0 ) {
						 rv='<t:message code="unilite.msg.sMB076" default="양수만 입력가능합니다."/>';
						 record.set('USE_BY_DATE',oldValue);
					}
			} else if(fieldName == "UNIT_WGT" )	{
					if(newValue == '')	record.set('UNIT_WGT',oldValue);
					 var wgt = parseInt(record.get('UNIT_WGT'));
					 var vol = parseInt(record.get('UNIT_VOL'));
					 if(vol != 0)	{
					 	var reim = wgt/vol;
					 	record.set('REIM',reim);
					 }
			} else if(fieldName == "UNIT_VOL" ) {
					 if(newValue == '')	record.set('UNIT_VOL',oldValue);

					 var wgt = parseInt(record.get('UNIT_WGT'));
					 var vol = parseInt(record.get('UNIT_VOL'));
					 if(vol != 0)	{
					 	var reim = wgt/vol;
					 	record.set('REIM',reim);
					 }
			} else if(fieldName == "REIM" ) {
					//alert('REIM');
					 if(newValue == '')	record.set('REIM',oldValue);

					 var wgt = parseInt(record.get('UNIT_WGT'));
					 var reim = parseInt(record.get('REIM'));
					 if(reim != 0)	{
					 	var vol = wgt/reim;
					 	record.set('UNIT_VOL',vol);
					 }
			} else if(fieldName == "B_OUT_YN" ) {

				if(newValue.B_OUT_YN == 'N' && detailForm.getValue('MAKE_STOP_YN').MAKE_STOP_YN == 'Y'){
					alert("생산중지여부가 Y이므로 바꿀수 없습니다");
					UniAppManager.setToolbarButtons('save', false);
					return false;

				}
			} else if(fieldName == "MAKE_STOP_YN" ) {

				 if(newValue.MAKE_STOP_YN == 'Y' && detailForm.getValue('B_OUT_YN').B_OUT_YN == 'N'){

					 alert("밸런스아웃여부가 N이므로 바꿀수 없습니다");
					 UniAppManager.setToolbarButtons('save', false);
					 return false;

				 }

			}

			return rv;

		}
	}); // validator

};


</script>

