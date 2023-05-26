<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="bpr100ukrv"  >
<t:ExtComboStore comboType="AU" comboCode="B013" /><!-- 단위 -->
<t:ExtComboStore comboType="AU" comboCode="B019" /><!-- 국내외 -->
<t:ExtComboStore comboType="AU" comboCode="B059" /><!-- 세구분 -->
<t:ExtComboStore comboType="AU" comboCode="B073" /><!-- 유효일자 -->
<t:ExtComboStore comboType="AU" comboCode="B010" /><!-- 단위 -->
<t:ExtComboStore comboType="AU" comboCode="A004" /><!-- 사용여부 -->
<t:ExtComboStore comboType="AU" comboCode="B702" /><!-- 제품사진 -->
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
	//인증서 이미지 등록에 사용되는 변수 선언
    var uploadWin;              //인증서 업로드 윈도우
    var photoWin;               //인증서 이미지 보여줄 윈도우
    var fid = '';               //인증서 ID
    var gsNeedPhotoSave = false;


	Unilite.defineModel('bpr100ukrvModel', {
    	fields: [
    	  		  	 { name: 'ITEM_CODE',  			text: '<t:message code="system.label.base.itemcode" default="품목코드"/>', 		type : 'string', allowBlank:false, isPk:true, pkGen:'user',maxLength: 20}
			  		,{ name: 'ITEM_NAME',  			text: '<t:message code="system.label.base.itemname" default="품목명"/>', 		type : 'string', allowBlank: false, maxLength: 100}
			  		,{ name: 'ITEM_NAME1',  		text: '<t:message code="system.label.base.itemname" default="품목명"/>1', 		type : 'string', maxLength: 100}
			  		,{ name: 'ITEM_NAME2',  		text: '<t:message code="system.label.base.itemname" default="품목명"/>2', 		type : 'string', maxLength: 100}
			  		,{ name: 'SPEC',  				text: '<t:message code="system.label.base.spec" default="규격"/>', 		type : 'string', maxLength: 160}
			  		,{ name: 'STOCK_UNIT',  		text: '<t:message code="system.label.base.inventoryunit" default="재고단위"/>', 		type : 'string', allowBlank: false, comboType:'AU', comboCode:'B013', displayField: 'value' }
				    ,{ name: 'ITEM_LEVEL1',  		text: '<t:message code="system.label.base.majorgroup" default="대분류"/>', 		type : 'string', store: Ext.data.StoreManager.lookup('BPR100ukrvLevel1Store'), child:'ITEM_LEVEL2'}
				    ,{ name: 'ITEM_LEVEL2',  		text: '<t:message code="system.label.base.middlegroup" default="중분류"/>', 		type : 'string', store: Ext.data.StoreManager.lookup('BPR100ukrvLevel2Store'), child:'ITEM_LEVEL3'}
				    ,{ name: 'ITEM_LEVEL3',  		text: '<t:message code="system.label.base.minorgroup" default="소분류"/>', 		type : 'string', store: Ext.data.StoreManager.lookup('BPR100ukrvLevel3Store')}
				    ,{ name: 'ITEM_GROUP',  		text: '<t:message code="system.label.base.repmodelcode" default="대표모델코드"/>',	type : 'string', maxLength: 20 }
				    ,{ name: 'ITEM_GROUP_NAME',  	text: '<t:message code="system.label.base.repmodelname" default="대표모델명"/>', 	type : 'string', maxLength: 100}
				    ,{ name: 'ITEM_COLOR',  		text: '<t:message code="system.label.base.color" default="색상"/>', 		type : 'string', comboType:'AU', comboCode:'B145'}
				    ,{ name: 'ITEM_SIZE',  			text: '<t:message code="system.label.base.size" default="사이즈"/>', 		type : 'string', maxLength: 50}
			  		,{ name: 'UNIT_WGT',  			text: '<t:message code="system.label.base.unitweight" default="단위중량"/>', 		type : 'uniQty', maxLength: 18}
			  		,{ name: 'WGT_UNIT',  			text: '<t:message code="system.label.base.weightunit" default="중량단위"/>', 		type : 'string', comboType:'AU', comboCode:'B013', displayField: 'value'}
			  		,{ name: 'UNIT_VOL',			text: '<t:message code="system.label.base.unitvolumn" default="단위부피"/>',		type : 'uniQty', maxLength: 18}
					,{ name: 'VOL_UNIT',			text: '<t:message code="system.label.base.volumnunit" default="부피단위"/>',		type : 'string'}
					,{ name: 'REIM',				text: '<t:message code="system.label.base.gravity" default="비중"/>',			type : 'float', maxLength: 18}
			  		,{ name: 'SPEC_NUM',  			text: '<t:message code="system.label.base.drawingnumber" default="도면번호"/>', 		type : 'string'}
			  		,{ name: 'SALE_UNIT',  			text: '<t:message code="system.label.base.salesunit" default="판매단위"/>', 		type : 'string', allowBlank: false, comboType:'AU', comboCode:'B013', displayField: 'value'}
			  		,{ name: 'TRNS_RATE',  			text: '<t:message code="system.label.base.salespackednumber" default="판매입수"/>', 		type : 'uniUnitPrice', defaultValue:1.00, maxLength: 12}
			  		,{ name: 'TAX_TYPE',  			text: '<t:message code="system.label.base.taxtype" default="세구분"/>', 		type : 'string', allowBlank: false, comboType:'AU', comboCode:'B059' , defaultValue:'1'}
			  		,{ name: 'SALE_BASIS_P',  	 	text: '<t:message code="system.label.base.sellingprice" default="판매단가"/>', 		type : 'uniUnitPrice', defaultValue:0, maxLength: 18}
			  		,{ name: 'DOM_FORIGN',  		text: '<t:message code="system.label.base.domesticoverseas" default="국내외"/>', 		type : 'string', comboType:'AU', comboCode:'B019' , defaultValue:'1'}
			  		,{ name: 'STOCK_CARE_YN',  		text: '<t:message code="system.label.base.inventorymanageobject" default="재고관리대상"/>', 	type : 'string', comboType:'AU', comboCode:'B010', defaultValue:'Y'}
			  		,{ name: 'TOTAL_ITEM',  		text: '<t:message code="system.label.base.summaryitemcode" default="집계품목코드"/>', 	type : 'string'}
			  		,{ name: 'TOTAL_ITEM_NAME',  	text: '<t:message code="system.label.base.summaryitemname" default="집계품목명"/>', 	type : 'string'}
			  		,{ name: 'TOTAL_TRAN_RATE', 	text: '<t:message code="system.label.base.summaryexchangefactor" default="집계환산계수"/>', 	type : 'uniUnitPrice', maxLength: 12}
			  		,{ name: 'BARCODE',  			text: '<t:message code="system.label.base.barcode" default="바코드"/>', 		type : 'string', maxLength: 15}
			  		,{ name: 'SMALL_BOX_BARCODE',  			text: '소박스', 		type : 'string', maxLength: 15}
			  		,{ name: 'BIG_BOX_BARCODE',  			text: '대박스', 		type : 'string', maxLength: 15}
			  		,{ name: 'HS_NO',  				text: '<t:message code="system.label.base.hsnumber" default="HS번호"/>', 		type : 'string'}
			  		,{ name: 'HS_NAME',  			text: '<t:message code="system.label.base.hsname" default="HS명"/>', 		type : 'string', maxLength: 60}
			  		,{ name: 'HS_UNIT',  			text: '<t:message code="system.label.base.hsunit" default="HS단위"/>', 		type : 'string'}
			  		,{ name: 'ITEM_MAKER',  		text: '<t:message code="system.label.base.mfgmaker" default="제조메이커"/>', 	type : 'string',maxLength: 50}
			  		,{ name: 'ITEM_MAKER_PN',  	 	text: '<t:message code="system.label.base.makerpartno" default="메이커 PART NO"/>', type : 'string',maxLength: 50}
			  		,{ name: 'PIC_FLAG',  			text: '<t:message code="system.label.base.photoflag" default="사진유무"/>', 		type : 'string', comboType:'AU', comboCode:'B010',defaultValue:'N'    }
			  		,{ name: 'START_DATE',  		text: '<t:message code="system.label.base.usestartdate" default="사용시작일"/>', 	type : 'uniDate', defaultValue:new Date(),  maxLength: 10, editable:false}
			  		,{ name: 'STOP_DATE',  			text: '<t:message code="system.label.base.usestopdate" default="사용중단일"/>', 	type : 'uniDate', maxLength: 10}
			  		,{ name: 'USE_YN',  			text: '<t:message code="system.label.base.photoflag" default="사진유무"/>', 		type : 'string', allowBlank: false, allowBlank: false, comboType:'AU', comboCode:'B010',defaultValue:'Y'}
			  		,{ name: 'EXCESS_RATE',  		text: '<t:message code="system.label.base.overissuerate" default="과출고허용율"/>',	type : 'uniPercent', defaultValue:0.00}
			  		,{ name: 'EXPIRATION_DAY',  	text: '유효기간',                                                           		type : 'int'}
			  		,{ name: 'CIR_PERIOD_YN',  		text: '<t:message code="system.label.base.availabledateyn" default="유효일 관리여부"/>', type : 'string', comboType:'AU', comboCode:'B010', defaultValue:'N'}
					,{ name: 'REMARK1',  			text: '<t:message code="system.label.base.remarks" default="비고"/>1', 		type : 'string'}
			  		,{ name: 'REMARK2',  			text: '<t:message code="system.label.base.remarks" default="비고"/>2', 		type : 'string'}
			  		,{ name: 'REMARK3',  			text: '<t:message code="system.label.base.remarks" default="비고"/>3', 		type : 'string'}
			  		,{ name: 'SQUARE_FT',  			text: '<t:message code="system.label.base.area" default="면적"/>(S/F)', 		type : 'int', defaultValue:0}
			  		,{ name: 'IMAGE_FID',  			text: '사진FID', 		type : 'string' }
			  		,{name: '_fileChange',			text: '사진저장체크' 	,type:'string'	,editable:false}
			  		,{name: '_EXCEL_JOBID',  		text: '엑셀JobID' , type: 'string'}
			  		,{name: '_EXCEL_ROWNUM',  		text: '엑셀행' , type: 'int'}
		]
	});

	/**
	 * Master Store
	 */

	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'bpr100ukrvService.selectDetailList',
			update: 'bpr100ukrvService.updateDetail',
			create: 'bpr100ukrvService.insertDetail',
			destroy: 'bpr100ukrvService.deleteDetail',
			syncAll: 'bpr100ukrvService.saveAll'
		}
	});

	//품목 정보 관련 파일 업로드
    var itemInfoProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
        api: {
            read    : 'bpr300ukrvService.getItemInfo',
            update  : 'bpr300ukrvService.itemInfoUpdate',
            create  : 'bpr300ukrvService.itemInfoInsert',
            destroy : 'bpr300ukrvService.itemInfoDelete',
            syncAll : 'bpr300ukrvService.saveAll2'
        }
    });

	var directMasterStore = Unilite.createStore('bpr100ukrvMasterStore',{
			model: 'bpr100ukrvModel',
           	autoLoad: false,
        	uniOpt : {
            	isMaster: true,			// 상위 버튼 연결
            	editable: true,			// 수정 모드 사용
            	deletable:true,			// 삭제 가능 여부
	            useNavi : false			// prev | next 버튼 사용
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
					Unilite.messageBox('품목명이나 품목코드를 입력하세요.');
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
					if(masterGrid.isVisible())	{
						detailForm.setActiveRecord(record);
					}
				}
			}
	});

	/**
	 * 검색 Form
	 */
	var sortSeqStore = Unilite.createStore('bpr100ukrvSeqStore', {
	    fields: ['text', 'value'],
		data :  [
			        {'text':'<t:message code="system.label.base.ascending" default="오름차순"/>'		, 'value':'ASC'},
			        {'text':'<t:message code="system.label.base.descending" default="내림차순"/>'		, 'value':'DESC'}
	    		]
		});

	var panelSearch = Unilite.createSearchPanel('searchForm', {
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
		items: [{
			title: '<t:message code="system.label.base.basisinfo2" default="기본정보"/>',
			itemId: 'search_panel1',
			layout: {type: 'vbox', align: 'stretch'},
            items: [{
        		xtype: 'container',
        		layout: {type: 'uniTable', columns: 1},
        		items: [{
        			xtype: 'uniTextfield',
		            name: 'ITEM_CODE',
	    			fieldLabel: '<t:message code="system.label.base.itemcode" default="품목코드"/>' ,
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							panelResult.setValue('ITEM_CODE', newValue);
						}
					}
	    		},{
	    			xtype: 'uniTextfield',
	            	name: 'ITEM_NAME',
	            	fieldLabel: '<t:message code="system.label.base.itemname" default="품목명"/>',
					listeners: {
						change: function(field, newValue, oldValue, eOpts) {
							panelResult.setValue('ITEM_NAME', newValue);
						}
					}
	            }]
			}]
    	}, {
		 	title:'<t:message code="system.label.base.additionalinfo" default="추가정보"/>',
   			id: 'search_panel2',
			itemId:'search_panel2',
        	defaultType: 'uniTextfield',
        	layout: {type: 'uniTable', columns: 1},
		 	items: [{
		    	name: 'ITEM_LEVEL1',
    			fieldLabel: '<t:message code="system.label.base.majorgroup" default="대분류"/>',
    			xtype:'uniCombobox',
                store: Ext.data.StoreManager.lookup('BPR100ukrvLevel1Store'),
                child: 'ITEM_LEVEL2'
              }, {
              	name: 'ITEM_LEVEL2',
              	fieldLabel: '<t:message code="system.label.base.middlegroup" default="중분류"/>',
              	xtype:'uniCombobox',
                store: Ext.data.StoreManager.lookup('BPR100ukrvLevel2Store'),
                child: 'ITEM_LEVEL3'

             }, {
             	name: 'ITEM_LEVEL3',
             	fieldLabel: '<t:message code="system.label.base.minorgroup" default="소분류"/>',
             	xtype:'uniCombobox',
                store: Ext.data.StoreManager.lookup('BPR100ukrvLevel3Store')
            }, {
            	fieldLabel: '<t:message code="system.label.base.searchitem" default="검색항목"/>' ,
            	name:'TXTFIND_TYPE',
            	xtype: 'uniCombobox',
            	comboType:'AU',
            	comboCode:'B052',
            	value:'01'
            }, {
            	fieldLabel: '<t:message code="system.label.base.searchword" default="검색어"/>',
            	name: 'TXT_SEARCH' ,
            	xtype: 'uniTextfield'
            }, {
            	fieldLabel: '<t:message code="system.label.base.repmodel" default="대표모델"/>',
            	name:'ITEM_GROUP',
            	xtype: 'uniTextfield'
            }, {
	    		xtype: 'radiogroup',
	    		fieldLabel: '<t:message code="system.label.base.useyn" default="사용여부"/>',
	    		items: [{
	    			boxLabel: '<t:message code="system.label.base.use" default="사용"/>',
	    			width: 80,
	    			name: 'USE_YN',
	    			inputValue: 'Y',
	    			checked: true
	    		}, {
	    			boxLabel: '<t:message code="system.label.base.unused" default="미사용"/>',
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
			fieldLabel: '<t:message code="system.label.base.itemcode" default="품목코드"/>' ,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('ITEM_CODE', newValue);
				}
			}
		},{
        	name: 'ITEM_NAME',
        	fieldLabel: '<t:message code="system.label.base.itemname" default="품목명"/>',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {
					panelSearch.setValue('ITEM_NAME', newValue);
				}
			}
        }]
    });


    /**
     * Master Grid
     */
	 var masterGrid = Unilite.createGrid('bpr100ukrvGrid', {
    	region:'center',
    	store : directMasterStore,
//    	sortableColumns : false,
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
	    columns:  [  { dataIndex: 'ITEM_CODE',  	width: 160		,isLink:true/*, locked: true*/}
			  		,{ dataIndex: 'ITEM_NAME',  	width: 140		/*,locked: true*/}
			  		,{ dataIndex: 'ITEM_NAME1',  	width: 180		,hidden:true}
			  		,{ dataIndex: 'ITEM_NAME2',  	width: 180		,hidden:true}
			  		,{ dataIndex: 'SPEC',  			width: 170		}
			  		,{ dataIndex: 'STOCK_UNIT',  	width: 120, align: 'center'		}
				    ,{ dataIndex: 'ITEM_LEVEL1',  	width: 120	/*,store: Ext.data.StoreManager.lookup('BPR100ukrvLevel1Store'), child:'ITEM_LEVEL2'*/}
				    ,{ dataIndex: 'ITEM_LEVEL2',  	width: 120	/*,store: Ext.data.StoreManager.lookup('BPR100ukrvLevel2Store'), child:'ITEM_LEVEL3'*/}
				    ,{ dataIndex: 'ITEM_LEVEL3',  	width: 120	/*,store: Ext.data.StoreManager.lookup('BPR100ukrvLevel3Store')*/}
				    ,{ dataIndex: 'ITEM_GROUP',  	width: 100, hidden: true
				    	, 'editor':  Unilite.popup('ITEM_G',{textFieldName:'ITEM_GROUP', DBtextFieldName:'ITEM_CODE',
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
				    	, 'editor':  Unilite.popup('ITEM_G',{textFieldName:'ITEM_GROUP_NAME', DBtextFieldName:'ITEM_NAME',
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
			  		,{ dataIndex: 'SMALL_BOX_BARCODE',  		width: 100		,hidden:true}
			  		,{ dataIndex: 'BIG_BOX_BARCODE',  		width: 100		,hidden:true}
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
			  		,{ dataIndex: 'CIR_PERIOD_YN',  width: 80		,hidden:true}
			  		,{ dataIndex: '_EXCEL_JOBID',  width: 80		,hidden:true}
			  		,{ dataIndex: '_EXCEL_ROWNUM',  width: 80		,hidden:true}
          ] ,
          listeners: {
/*          	selectionchangerecord:function(selected)	{
//          		detailForm.loadForm(selected);
          		detailForm.setActiveRecord(selected)
          		console.log("masterGrid selectionchangerecord. selected:"+ selected);*/
          	selectionchangerecord:function(selected)	{
          		selectRecordCode = selected.data.ITEM_CODE;
          		detailForm.setActiveRecord(selected);
          		//itemImageForm.setImage(selected.get('IMAGE_FID'));


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
							itemInfoStore.loadStoreRecords(record.data.ITEM_CODE);
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
    //품목 정보 관련 파일업로드
    Unilite.defineModel('itemInfoModel', {
        fields: [
            {name: 'COMP_CODE'          ,text: '<t:message code="system.label.base.companycode" default="법인코드"/>'           ,type: 'string'},
            {name: 'ITEM_CODE'          ,text: '<t:message code="system.label.base.itemcode" default="품목코드"/>'          ,type: 'string'},
            //공통코드 생성 (B702 - 01:제품사진, 02:도면, 03:승인원)
            {name: 'FILE_TYPE'          ,text: '<t:message code="system.label.base.classfication" default="구분"/>'               ,type: 'string'     , allowBlank: false     , comboType: 'AU'   , comboCode: 'B702'},
            {name: 'MANAGE_NO'          ,text: '<t:message code="system.label.base.manageno" default="관리번호"/>'          ,type: 'string'     , allowBlank: false},
            {name: 'REMARK'             ,text: '<t:message code="system.label.base.remarks" default="비고"/>'             ,type: 'string'},
            {name: 'CERT_FILE'          ,text: '<t:message code="system.label.base.filename" default="파일명"/>'           ,type: 'string'},
            {name: 'FILE_ID'            ,text: '<t:message code="system.label.base.savedfilename" default="저장된 파일명"/>'      ,type: 'string'},
            {name: 'FILE_PATH'          ,text: '<t:message code="system.label.base.savedfilepath" default="저장된 파일경로"/>'     ,type: 'string'},
            {name: 'FILE_EXT'           ,text: '<t:message code="system.label.base.savedfileextension" default="저장된 파일확장자"/>'       ,type: 'string'}
        ]
    });
    var itemInfoStore = Unilite.createStore('itemInfoStore',{
        model   : 'itemInfoModel',
        autoLoad: false,
        uniOpt  : {
            isMaster    : false,        // 상위 버튼 연결
            editable    : true,         // 수정 모드 사용
            deletable   : true,         // 삭제 가능 여부
            useNavi     : false         // prev | next 버튼 사용
        },

        proxy: itemInfoProxy,

        loadStoreRecords : function(itemCOde){
            var param= Ext.getCmp('resultForm').getValues();
            param.ITEM_CODE = itemCOde

            console.log( param );
            this.load({
                params : param
            });
        },

        saveStore : function(config) {
            var inValidRecs = this.getInvalidRecords();
            console.log("inValidRecords : ", inValidRecs);
            if(inValidRecs.length == 0 )     {
                config = {
                    success : function(batch, option) {
                        if(gsNeedPhotoSave){
                            fnPhotoSave();
                        }
                    }
                };
                this.syncAllDirect(config);
            }else {
                itemInfoGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
            }
        },

        listeners: {
            update:function( store, record, operation, modifiedFieldNames, eOpts ){
            },
            metachange:function( store, meta, eOpts ){
            }
        },

        _onStoreUpdate: function (store, eOpt) {
            console.log("Store data updated save btn enabled !");
            this.setToolbarButtons('sub_save4', true);
        }, // onStoreUpdate

        _onStoreLoad: function ( store, records, successful, eOpts ) {
            console.log("onStoreLoad");
            if (records) {
                this.setToolbarButtons('sub_save4', false);
            }
        },
        _onStoreDataChanged: function( store, eOpts ) {
            console.log("_onStoreDataChanged store.count() : ", store.count());
            if(store.count() == 0){
                this.setToolbarButtons(['sub_delete4'], false);
                Ext.apply(this.uniOpt.state, {'btn':{'sub_delete4':false}});
            }else {
                if(this.uniOpt.deletable)   {
                    this.setToolbarButtons(['sub_delete4'], true);
                    Ext.apply(this.uniOpt.state, {'btn':{'sub_delete4':true}});
                }
            }
            if(store.isDirty()) {
                this.setToolbarButtons(['sub_save4'], true);
            }else {
                this.setToolbarButtons(['sub_save4'], false);
            }
        },

        setToolbarButtons: function( btnName, state)     {
            var toolbar = itemInfoGrid.getDockedItems('toolbar[dock="top"]');
            var obj = toolbar[0].getComponent(btnName);
            if(obj) {
                (state) ? obj.enable():obj.disable();
            }
        }
    });
    var itemInfoGrid = Unilite.createGrid('itemInfoGrid', {
        store   : itemInfoStore,
        border  : true,
        height  : 180,
        width   : 865,
        padding : '0 0 5 0',
        sortableColumns : false,
        excelTitle: '<t:message code="system.label.base.referfile" default="관련파일"/>',
        uniOpt  :{
            onLoadSelectFirst   : false,
            expandLastColumn    : false,
            useRowNumberer      : true,
            useMultipleSorting  : false
//          enterKeyCreateRow: true                         //마스터 그리드 추가기능 삭제
        },
        dockedItems : [{
            xtype   : 'toolbar',
            dock    : 'top',
            items   : [{
                xtype   : 'uniBaseButton',
                text    : '<t:message code="system.label.base.inquiry" default="조회"/>',
                tooltip : '<t:message code="system.label.base.inquiry" default="조회"/>',
                iconCls : 'icon-query',
                width   : 26,
                height  : 26,
                itemId  : 'sub_query4',
                handler: function() {
                    //if( me._needSave()) {
                    var toolbar = itemInfoGrid.getDockedItems('toolbar[dock="top"]');
                    var needSave= !toolbar[0].getComponent('sub_save4').isDisabled();
                    var record  = masterGrid.getSelectedRecord();
                    if (needSave) {
                        Ext.Msg.show({
                            title   : '<t:message code="system.label.base.confirm" default="확인"/>',
                            msg     : Msg.sMB017 + "\n" + Msg.sMB061,
                            buttons : Ext.Msg.YESNOCANCEL,
                            icon    : Ext.Msg.QUESTION,
                            fn      : function(res) {
                                //console.log(res);
                                if (res === 'yes' ) {
                                    var saveTask =Ext.create('Ext.util.DelayedTask', function(){
                                        itemInfoStore.saveStore();
                                    });
                                    saveTask.delay(500);
                                } else if(res === 'no') {
                                        itemInfoStore.loadStoreRecords(record.get('ITEM_CODE'));
                                }
                            }
                        });
                    } else {
                        itemInfoStore.loadStoreRecords(record.get('ITEM_CODE'));
                    }
                }
            },{
                xtype   : 'uniBaseButton',
                text    : '<t:message code="system.label.base.reset" default="신규"/>',
                tooltip : '<t:message code="system.label.base.reset2" default="초기화"/>',
                iconCls : 'icon-reset',
                width   : 26,
                height  : 26,
                itemId  : 'sub_reset4',
                handler: function() {
                    var toolbar = itemInfoGrid.getDockedItems('toolbar[dock="top"]');
                    var needSave= !toolbar[0].getComponent('sub_save4').isDisabled();
                    if(needSave) {
                            Ext.Msg.show({
                                title:'<t:message code="system.label.base.confirm" default="확인"/>',
                                msg: Msg.sMB017 + "\n" + Msg.sMB061,
                                buttons: Ext.Msg.YESNOCANCEL,
                                icon: Ext.Msg.QUESTION,
                                fn: function(res) {
                                    console.log(res);
                                    if (res === 'yes' ) {
                                            var saveTask =Ext.create('Ext.util.DelayedTask', function(){
                                                itemInfoStore.saveStore();
                                            });
                                            saveTask.delay(500);
                                    } else if(res === 'no') {
                                            itemInfoGrid.reset();
                                            itemInfoStore.clearData();
                                            itemInfoStore.setToolbarButtons('sub_save4', false);
                                            itemInfoStore.setToolbarButtons('sub_delete4', false);
                                    }
                                }
                            });
                    } else {
                            itemInfoGrid.reset();
                            itemInfoStore.clearData();
                            itemInfoStore.setToolbarButtons('sub_save4', false);
                            itemInfoStore.setToolbarButtons('sub_delete4', false);
                    }
                }
            },{
                xtype   : 'uniBaseButton',
                text    : '<t:message code="system.label.base.add" default="추가"/>',
                tooltip : '<t:message code="system.label.base.add" default="추가"/>',
                iconCls : 'icon-new',
                width   : 26,
                height  : 26,
                itemId  : 'sub_newData4',
                handler: function() {
                    var record      = masterGrid.getSelectedRecord();
                    var compCode    = UserInfo.compCode;
                    var itemCode    = record.get('ITEM_CODE');
                    var r = {
                        COMP_CODE       :   compCode,
                        ITEM_CODE       :   itemCode
                    };
                    itemInfoGrid.createRow(r);
                }
            },{
                xtype       : 'uniBaseButton',
                text        : '<t:message code="system.label.base.delete" default="삭제"/>',
                tooltip     : '<t:message code="system.label.base.delete" default="삭제"/>',
                iconCls     : 'icon-delete',
                disabled    : true,
                width       : 26,
                height      : 26,
                itemId      : 'sub_delete4',
                handler : function() {
                    var selRow = itemInfoGrid.getSelectedRecord();
                    if(!Ext.isEmpty(selRow)) {
                        if(selRow.phantom === true) {
                            itemInfoGrid.deleteSelectedRow();
                        }else if(confirm('<t:message code="system.message.base.confirm001" default="현재행을 삭제 합니다. 삭제 하시겠습니까?"/>')) {
                            itemInfoGrid.deleteSelectedRow();
                        }
                    } else {
                        Unilite.messageBox(Msg.sMA0256);
                        return false;
                    }
                }
            },{
                xtype       : 'uniBaseButton',
                text        : '<t:message code="system.label.base.save" default="저장 "/>',
                tooltip     : '<t:message code="system.label.base.save" default="저장 "/>',
                iconCls     : 'icon-save',
                disabled    : true,
                width       : 26,
                height      : 26,
                itemId      : 'sub_save4',
                handler : function() {
                    var inValidRecs = itemInfoStore.getInvalidRecords();
                    if(inValidRecs.length == 0 )     {
                        var saveTask =Ext.create('Ext.util.DelayedTask', function(){
                            itemInfoStore.saveStore();
                        });
                        saveTask.delay(500);
                    } else {
                        itemInfoGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
                    }
                }
            }]
        }],

        columns:[
                { dataIndex : 'COMP_CODE'           , width: 80     ,hidden:true},
                { dataIndex : 'ITEM_CODE'           , width: 80     ,hidden:true},
                { dataIndex : 'FILE_TYPE'           , width: 100 },
                { dataIndex : 'MANAGE_NO'           , width: 150},
                { text      : '<t:message code="system.label.base.item" default="품목"/> <t:message code="system.label.base.relatedfile" default="관련파일"/>',
                    columns:[
                        { dataIndex : 'CERT_FILE'   , width: 230        , align: 'center'   ,
                            renderer: function (val, meta, record) {
                                if (!Ext.isEmpty(record.data.CERT_FILE)) {
                                	 if(record.data.FILE_EXT == 'jpg' || record.data.FILE_EXT == 'png' || record.data.FILE_EXT == 'bmp' || record.data.FILE_EXT == 'pdf'){
   									  		return '<font color = "blue" >' + val + '</font>';
   								 	 }else{
	   									  var fileName = record.data.FILE_ID + '.' +  record.data.FILE_EXT;
	   									  var originFile = record.data.CERT_FILE;
	   									  var selItemCode = record.data.ITEM_CODE;
	   									  var manageNo = record.data.MANAGE_NO;
	   									  return  '<A href="'+ CHOST + CPATH + '/fileman/downloadItemFile/' + PGM_ID + '/' + selItemCode + '/' + manageNo  +'">' + val + '</A>';
   								  	}
                                } else {
                                    return '';
                                }
                            }
                        },{
                            text        : '',
                            dataIndex   : 'REG_IMG',
                            xtype       : 'actioncolumn',
                            align       : 'center',
                            padding     : '-2 0 2 0',
                            width       : 30,
                            items       : [{
                                icon    : CPATH+'/resources/css/theme_01/barcodetest.png',
                                handler : function(grid, rowIndex, colIndex, item, e, record) {
                                    itemInfoGrid.getSelectionModel().select(record);
                                    openUploadWindow();
                                }
                            }]
                        }
                    ]
                },
                { dataIndex : 'REMARK'              , flex: 1   , minWidth: 30}/*,
                {
                  text      : '등록 버튼으로 구현 한 것',
                  align : 'center',
                  width : 50,
                  renderer  : function(value, meta, record) {
                        var id = Ext.id();
                        Ext.defer(function(){
                            new Ext.Button({
                                text    : '등록',
                                margin  : '-2 0 2 0',
                                handler : function(btn, e) {
                                    itemInfoGrid.getSelectionModel().select(record);
                                    openUploadWindow();
                                }
                            }).render(document.body, id);
                        },50);
                        return Ext.String.format('<div id="{0}"></div>', id);
                    }
                }*/
        ],

        listeners: {
            beforeedit: function( editor, e, eOpts ) {
                if(!e.record.phantom) {                 //
                    if (UniUtils.indexOf(e.field, ['FILE_TYPE', 'MANAGE_NO', 'CERT_FILE'])){
                        return false;
                    }

                } else {
                    if (UniUtils.indexOf(e.field, ['CERT_FILE'])){
                        return false;
                    }
                }
            },
            select: function(grid, selectRecord, index, rowIndex, eOpts ){
            },
            cellclick: function( view, td, cellIndex, record, tr, rowIndex, e, eOpts ) {
                if(cellIndex == 5 && !Ext.isEmpty(record.get('CERT_FILE'))) {
                    fid = record.data.FILE_ID
                    var fileExtension   = record.get('CERT_FILE').lastIndexOf( "." );
                    var fileExt         = record.get('CERT_FILE').substring( fileExtension + 1 );

                    if(fileExt == 'pdf') {
                        var win = Ext.create('widget.CrystalReport', {
                            url     : CPATH+'/fileman/downloadItemInfoImage/' + fid,
                            prgID   : 'bpr100ukrv'
                        });
                        win.center();
                        win.show();

                    } else if(fileExt == 'jpg' || fileExt == 'png' || fileExt == 'bmp') {
						openPhotoWindow();
					} else {

					}
                }
            }
        }
    });

    var photoForm = Ext.create('Unilite.com.form.UniDetailForm',{
        xtype       : 'uniDetailForm',
        disabled    : false,
        fileUpload  : true,
        itemId      : 'photoForm',
        api         : {
            submit  : bpr100ukrvService.photoUploadFile
        },
        items       : [{
                xtype       : 'filefield',
                buttonOnly  : false,
                fieldLabel  : '<t:message code="system.label.base.photo" default="사진"/>',
                flex        : 1,
                name        : 'photoFile',
                id          : 'photoFile',
                buttonText  : '<t:message code="system.label.base.selectfile" default="파일선택"/>',
                width       : 270,
                labelWidth  : 70
            }
        ]
    });

    //미리보기 관련 윈도우
    function openPhotoWindow() {
        photoWin = Ext.create('widget.uniDetailWindow', {
            title       : '<t:message code="system.label.base.preview" default="미리보기"/>',
            modal       : true,
            resizable   : true,
            closable    : false,
            width       : '80%',
            height      : '100%',
            layout      : {
                type    : 'fit'
            },
            closeAction : 'destroy',
            items       : [{
                xtype       : 'uniDetailForm',
                itemId      : 'downForm',
                url         : CPATH + "/fileman/downloadItemInfoImage/" + fid,
                layout      : {type: 'uniTable', columns:'1'},
                standardSubmit: true,
                disabled    : false,
                autoScroll  : true,
                items       : [{
                    xtype   : 'image',
                    itemId  : 'photView',
                    autoEl  : {
                        tag: 'img',
                        src: CPATH+'/resources/images/human/noPhoto.png'
                    }
                }]
            }],
            listeners : {
                beforeshow: function( window, eOpts)    {
                    window.down('#photView').setSrc(CPATH+'/fileman/downloadItemInfoImage/' + fid);
                },
                show: function( window, eOpts)  {
                    window.center();
                }
            },
            tbar:['->',{
                xtype   : 'button',
                text    : '<t:message code="system.label.base.download" default="다운로드"/>',
                handler : function() {
                    photoWin.down('#downForm').submit({
                        success:function(comp, action)  {
                            Ext.getBody().unmask();
                        },
                        failure: function(form, action){
                            Ext.getBody().unmask();
                        }
                    });
                }
            },{
                xtype   : 'button',
                text    : '<t:message code="system.label.base.close" default="닫기"/>',
                handler : function()    {
                    photoWin.down('#downForm').clearForm();
                    photoWin.close();
                    photoWin.hide();
                }
            }]
        });
        photoWin.show();
    }
    function fnPhotoSave() {                //이미지 등록
        //조건에 맞는 내용은 적용 되는 로직
        var record      = itemInfoGrid.getSelectedRecord();
        var photoForm   = uploadWin.down('#photoForm').getForm();
        var param       = {
            ITEM_CODE   : record.data.ITEM_CODE,
            MANAGE_NO   : record.data.MANAGE_NO,
            FILE_TYPE   : record.data.FILE_TYPE
        }

        photoForm.submit({
            params  : param,
            waitMsg : 'Uploading your files...',
            success : function(form, action)    {
                uploadWin.afterSuccess();
                gsNeedPhotoSave = false;
            }
        });
    }
    function openUploadWindow() {
        if(!uploadWin) {
            uploadWin = Ext.create('Ext.window.Window', {
                title       : '<t:message code="system.label.base.file" default="파일"/> <t:message code="system.label.base.entry" default="등록"/>',
                closable    : false,
                closeAction : 'hide',
                modal       : true,
                resizable   : true,
                width       : 300,
                height      : 100,
                layout      : {
                    type    : 'fit'
                },
                items       : [
                    photoForm,
                    {
                        xtype       : 'uniDetailForm',
                        itemId      : 'photoForm',
                        disabled    : false,
                        fileUpload  : true,
                        api         : {
                            submit: bpr100ukrvService.photoUploadFile
                        },
                        items       :[{
                            xtype       : 'filefield',
                            fieldLabel  : '<t:message code="system.label.base.file" default="파일"/>',
                            name        : 'photoFile',
                            buttonText  : '<t:message code="system.label.base.selectfile" default="파일선택"/>',
                            buttonOnly  : false,
                            labelWidth  : 70,
                            flex        : 1,
                            width       : 270
                        }]
                    }
                ],
                listeners : {
                    beforeshow: function( window, eOpts)    {
                        var toolbar = itemInfoGrid.getDockedItems('toolbar[dock="top"]');
                        var needSave= !toolbar[0].getComponent('sub_save4').isDisabled();
                        var record  = itemInfoGrid.getSelectedRecord();

                        if (needSave) {
                            if(Ext.isEmpty(record.data.FILE_TYPE) || Ext.isEmpty(record.data.MANAGE_NO)){
                                Unilite.messageBox('<t:message code="system.message.human.message002" default="필수입력사항을 입력하신 후 사진을 올려주세요."/>');
                                return false;
                            }
                        } else {
                            if (Ext.isEmpty(record)) {
                                Unilite.messageBox('<t:message code="system.message.base.message004" default="품목 관련 정보를 입력하신 후, 사진을 업로드 하시기 바랍니다."/>');
                                return false;
                            }
                        }
                    },
                    show: function( window, eOpts)  {
                        window.center();
                    }
                },
                afterSuccess: function()    {
                    var record  = masterGrid.getSelectedRecord();
                    itemInfoStore.loadStoreRecords(record.get('ITEM_CODE'));
                    this.afterSavePhoto();
                },
                afterSavePhoto: function()  {
                    var photoForm = uploadWin.down('#photoForm');
                    photoForm.clearForm();
                    uploadWin.hide();
                },
                tbar:['->',{
                    xtype   : 'button',
                    text    : '<t:message code="system.label.base.upload" default="올리기"/>',
                    handler : function()    {
                        var photoForm   = uploadWin.down('#photoForm');
                        var toolbar     = itemInfoGrid.getDockedItems('toolbar[dock="top"]');
                        var needSave    = !toolbar[0].getComponent('sub_save4').isDisabled();

                        if (Ext.isEmpty(photoForm.getValue('photoFile'))) {
                            Unilite.messageBox('<t:message code="system.message.base.message002" default="업로드 할 파일을 선택하십시오."/>');
                            return false;
                        }

                        //jpg파일만 등록 가능
                        var filePath        = photoForm.getValue('photoFile');
                        var fileExtension   = filePath.lastIndexOf( "." );
                        var fileExt         = filePath.substring( fileExtension + 1 );

                       /*  if(fileExt != 'jpg' && fileExt != 'png' && fileExt != 'bmp' && fileExt != 'pdf') {
                            Unilite.messageBox('<t:message code="system.message.base.message001" default="이미지 파일(jpg, png, bmp) 또는 pdf파일만 업로드 할 수 있습니다."/>');
                            return false;
                        } */


                        if(needSave)    {
                            gsNeedPhotoSave = needSave;
                            itemInfoStore.saveStore();

                        } else {
                            fnPhotoSave();
                        }
                    }
                },{
                    xtype   : 'button',
                    text    : '<t:message code="system.label.base.close" default="닫기"/>',
                    handler : function()    {
//                      var photoForm = uploadWin.down('#photoForm').getForm();
//                      if(photoForm.isDirty()) {
//                          if(confirm('사진이 변경되었습니다. 저장하시겠습니까?'))   {
//                              var config = {
//                                  success : function()    {
//                                      // TODO: fix it!!!
//                                      uploadWin.afterSavePhoto();
//                                  }
//                              }
//                              UniAppManager.app.onSaveDataButtonDown(config);
//
//                          }else{
                                // TODO: fix it!!!
                                uploadWin.afterSavePhoto();
//                          }
//
//                      } else {
                            uploadWin.hide();
//                      }
                    }
                }]
            });
        }
        uploadWin.show();
    }

    function openPhotoWindow() {
        photoWin = Ext.create('widget.uniDetailWindow', {
            title       : '<t:message code="system.label.base.preview" default="미리보기"/>',
            modal       : true,
            resizable   : true,
            closable    : false,
            width       : '80%',
            height      : '100%',
            layout      : {
                type    : 'fit'
            },
            closeAction : 'destroy',
            items       : [{
                xtype       : 'uniDetailForm',
                itemId      : 'downForm',
                url         : CPATH + "/fileman/downloadItemInfoImage/" + fid,
                layout      : {type: 'uniTable', columns:'1'},
                standardSubmit: true,
                disabled    : false,
                autoScroll  : true,
                items       : [{
                    xtype   : 'image',
                    itemId  : 'photView',
                    autoEl  : {
                        tag: 'img',
                        src: CPATH+'/resources/images/human/noPhoto.png'
                    }
                }]
            }],
            listeners : {
                beforeshow: function( window, eOpts)    {
                    window.down('#photView').setSrc(CPATH+'/fileman/downloadItemInfoImage/' + fid);
                },
                show: function( window, eOpts)  {
                    window.center();
                }
            },
            tbar:['->',{
                xtype   : 'button',
                text    : '<t:message code="system.label.base.download" default="다운로드"/>',
                handler : function() {
                    photoWin.down('#downForm').submit({
                        success:function(comp, action)  {
                            Ext.getBody().unmask();
                        },
                        failure: function(form, action){
                            Ext.getBody().unmask();
                        }
                    });
                }
            },{
                xtype   : 'button',
                text    : '<t:message code="system.label.base.close" default="닫기"/>',
                handler : function()    {
                    photoWin.down('#downForm').clearForm();
                    photoWin.close();
                    photoWin.hide();
                }
            }]
        });
        photoWin.show();
    }



//    /**
//     * 상세 Form
//     */
//     var itemImageForm = Unilite.createForm('lkasdf' +
//     		'itemImageForm', {
//	    	 			 fileUpload: true,
//						 url:  CPATH+'/fileman/upload.do',
//						 disabled:false,
//				    	 width:450,
//				    	 height:250,
//				    	 //hidden: true,
//	    	 			 layout: {type: 'uniTable', columns: 2},
//						 items: [
//        						  { xtype: 'filefield',
//									buttonOnly: false,
//									fieldLabel: '<t:message code="system.label.base.photo" default="사진"/>',
//									hideLabel:true,
//									width:350,
//									name: 'fileUpload',
//									buttonText: '<t:message code="system.label.base.selectfile" default="파일선택"/>',
//									listeners: {change : function( filefield, value, eOpts )	{
//															var fileExtention = value.lastIndexOf(".");
//															//FIXME : 업로드 확장자 체크, 이미지파일만 upload
//															if(value !='' )	{
//																var record = masterGrid.getSelectedRecord();
//																detailForm.setValue('_fileChange', 'true');
//																//detailWin.setToolbarButtons(['saveBtn','saveCloseBtn'],true);
//		                    						 			//detailWin.setToolbarButtons(['prev','next'],false);
//															}
//														}
//									}
//								  }
//								  ,{ xtype: 'button', text:'<t:message code="system.label.base.upload" default="올리기"/>', margin:'0 0 0 2',
//								  	 handler:function()	{
//								  	 	var config = {success : function()	{
//								  	 						var selRecord = masterGrid.getSelectedRecord();
//                        									detailForm.loadForm(selRecord);				// 입력값 이외의 자동생성 필드가 있다면 반드시 넣어준다.
//		                    						 		//detailWin.setToolbarButtons(['saveBtn','saveCloseBtn'],false);
//		                    						 		//detailWin.setToolbarButtons(['prev','next'],true);
//					                    			  }
//			                    			}
//			                        	UniAppManager.app.onSaveDataButtonDown(config);
//								  	 }
//								  }
//								  ,
//								  { xtype: 'image', id:'bpr100Image', src:CPATH+'/resources/images/nameCard.jpg', width:400,	 overflow:'auto', colspan:2}
//					             ]
//					   , setImage : function (fid)	{
//						    	 	var image = Ext.getCmp('bpr100Image');
//						    	 	var src = CPATH+'/resources/images/nameCard.jpg'
//						    	 	if(!Ext.isEmpty(fid))	{
//							         	//src = CPATH+'/fileman/download.do?fid='+fid+'&inline=Y';
//							         	src= CPATH+'/fileman/view/'+fid;
//						    	 	}
//							        image.setSrc(src);
//						    	 }
//	});

    var detailForm = Unilite.createForm('detailForm', {
    	//region:'south',
    	//weight:-100,
    	//height:400,
    	//split:true,

    	hidden: true,
    	autoScroll: true,
    	flex:1,
    	masterGrid: masterGrid,
        padding: '0 0 0 1',
	    layout: {type: 'uniTable', columns: 3, tableAttrs:{cellpadding:5}, tdAttrs: {valign:'top'}},
	    defaultType: 'uniFieldset',
	    defaults : { margin: '0 0 0 0'},
	    items : [{ 	title: '<t:message code="system.label.base.basisinfo2" default="기본정보"/>'
	    			, colspan: 3
					, layout: {
					            type: 'uniTable',
					            columns: 1
					        }
					, height: 160
					, defaults : { type:'uniTextfield'}
        			, items :[	 { name: 'ITEM_CODE',  			fieldLabel: '<t:message code="system.label.base.itemcode" default="품목코드"/>', 	 hidden: false, editable:true, allowBlank:false,maxLength: 20, width:300}
						  		,{ name: 'ITEM_NAME',  			fieldLabel: '<t:message code="system.label.base.itemname2" default="품명"/>', 		 hidden: false, allowBlank:false, maxLength: 200, width:400}
						  		,{ name: 'ITEM_NAME1',  		fieldLabel: '<t:message code="system.label.base.itemname2" default="품명"/>1' 		, maxLength: 200, width:400}
						  		,{ name: 'ITEM_NAME2',  		fieldLabel: '<t:message code="system.label.base.itemname2" default="품명"/>2' 		, maxLength: 200, width:785}
						  		,{ name: 'SPEC',  				fieldLabel: '<t:message code="system.label.base.spec" default="규격"/>' 			,maxLength: 160, width:785}
					         ]
	    		}
	    	   ,{  	title: '<t:message code="system.label.base.iteminfo" default="품목정보"/>'
        			, defaultType: 'uniTextfield'
        			, layout: { type: 'uniTable', columns: 1}
        			, height: 420
        			, items :[	 { name: 'STOCK_UNIT',  		fieldLabel: '<t:message code="system.label.base.inventoryunit" default="재고단위"/>',		 xtype:'uniCombobox',	comboType:'AU', comboCode:'B013', displayField: 'value', allowBlank:false}
						  		,{ name: 'ITEM_LEVEL1',  		fieldLabel: '<t:message code="system.label.base.majorgroup" default="대분류"/>' 		,xtype:'uniCombobox', store: Ext.data.StoreManager.lookup('BPR100ukrvLevel1Store'), child: 'ITEM_LEVEL2'}
						  		,{ name: 'ITEM_LEVEL2',  		fieldLabel: '<t:message code="system.label.base.middlegroup" default="중분류"/>' 		,xtype:'uniCombobox', store: Ext.data.StoreManager.lookup('BPR100ukrvLevel2Store'), child: 'ITEM_LEVEL3'}
						  		,{ name: 'ITEM_LEVEL3',  		fieldLabel: '<t:message code="system.label.base.minorgroup" default="소분류"/>' 		,xtype:'uniCombobox', store: Ext.data.StoreManager.lookup('BPR100ukrvLevel3Store')}
						  		, Unilite.popup('ITEM',{fieldLabel: '<t:message code="system.label.base.repmodel" default="대표모델"/>', textFieldName:'ITEM_GROUP_NAME', valueFieldName:'ITEM_GROUP', valueFieldWidth:120, textFieldWidth:150, verticalMode:true})
						  		,{ name: 'START_DATE',  		fieldLabel: '<t:message code="system.label.base.usestartdate" default="사용시작일"/>', 	xtype : 'uniDatefield', maxLength: 10, readOnly:true}
						  		,{ name: 'STOP_DATE',  			fieldLabel: '<t:message code="system.label.base.usestopdate" default="사용중단일"/>', 	xtype : 'uniDatefield', maxLength: 10}
						  		,{ name: 'USE_YN',  			fieldLabel: '<t:message code="system.label.base.useyn" default="사용여부"/>', 	xtype:'uniRadiogroup', comboType:'AU', comboCode:'B010', width:235, allowBlank:false}
					         ]
	    		}
	    	   ,{   title: '<t:message code="system.label.base.datasellinginfo" default="제원(판매)정보"/>'
        			, layout: {
					            type: 'uniTable',
					            columns: 1
					        }
        			, defaults: {type: 'uniTextfield',  labelWidth:90}
        			, height: 420
        			, items :[	 
        						{ name: 'ITEM_COLOR',			fieldLabel: '<t:message code="system.label.base.color" default="색상"/>',		 xtype:'uniCombobox' ,comboType:'AU', comboCode:'B145'}
							    ,{ name: 'ITEM_SIZE',  			fieldLabel: '<t:message code="system.label.base.size" default="사이즈"/>' 		,maxLength: 50}
							    ,{ xtype:'fieldset',
							       border:0,
							       layout:{type:'hbox', align:'stretch'},
							       margin:'0 0 0 0',
							       width:255,
							       items :[
							  		 { name: 'UNIT_WGT',  			fieldLabel: '<t:message code="system.label.base.unitweight" default="단위중량"/>/<t:message code="system.label.base.unit" default="단위"/>', 	xtype : 'uniNumberfield', decimalPrecision:2, width:170, labelWidth:80, maxLength: 18}
							  		,{ name: 'WGT_UNIT',  			hideLabel:true, fieldLabel: '<t:message code="system.label.base.weightunit" default="중량단위"/>', width:65,	xtype:'uniCombobox' ,comboType:'AU', comboCode:'B013', displayField: 'value'}
							    	]
							     }
						  		,{ xtype:'fieldset',
							       border:0,
							       layout:{type:'hbox', align:'stretch'},
							       margin:'0 0 0 0',
							       width:255,
							       items :[
							       			 { name: 'UNIT_VOL',			fieldLabel: '<t:message code="system.label.base.unitvolumn" default="단위부피"/>/<t:message code="system.label.base.unit" default="단위"/>',		xtype : 'uniNumberfield', decimalPrecision:2, width:170, labelWidth:80, maxLength: 18}
											,{ name: 'VOL_UNIT',			fieldLabel: '<t:message code="system.label.base.volumnunit" default="부피단위"/>',		hideLabel:true, width:65 , xtype:'uniCombobox' ,comboType:'AU', comboCode:'B013', displayField: 'value'}
										  ]
						  		}
								,{ name: 'REIM',				fieldLabel: '<t:message code="system.label.base.gravity" default="비중"/>',			xtype : 'uniNumberfield',	decimalPrecision:'${REIM_Precision}', maxLength: 18}
						  		,{ name: 'SPEC_NUM',  			fieldLabel: '<t:message code="system.label.base.drawingnumber" default="도면번호"/>' 		,maxLength: 20}
						  		,{ name: 'SALE_UNIT',  			fieldLabel: '<t:message code="system.label.base.salesunit" default="판매단위"/>', 	xtype:'uniCombobox', comboType:'AU', comboCode:'B013', displayField: 'value', allowBlank:false}
						  		,{ name: 'TRNS_RATE',  			fieldLabel: '<t:message code="system.label.base.salespackednumber" default="판매입수"/>', 	xtype : 'uniNumberfield',decimalPrecision:2, maxLength: 12}
						  		,{ name: 'EXCESS_RATE',  		fieldLabel: '<t:message code="system.label.base.overissuerate" default="과출고허용율"/>', xtype : 'uniNumberfield',  decimalPrecision:'2'}
						  		,{ name: 'TAX_TYPE',  			fieldLabel: '<t:message code="system.label.base.taxtype" default="세구분"/>', 		xtype:'uniCombobox', comboType:'AU', comboCode:'B059' , allowBlank:false}
						  		,{ name: 'SALE_BASIS_P',  	 	fieldLabel: '<t:message code="system.label.base.sellingprice" default="판매단가"/>', 	xtype : 'uniNumberfield', maxLength: 18}
						  		,{ name: 'SQUARE_FT',  			fieldLabel: '면적(S/F)', 	xtype : 'uniNumberfield', value:0}


        					]
	    		}
	    		,{  title: '<t:message code="system.label.base.generalinfo" default="일반정보"/>'
	    			, layout: {
					            type: 'uniTable',
					            columns: 1
					        }
        			, defaults: {type: 'uniTextfield',  labelWidth:100}
        			, height: 420
        			,items :[	 { name: 'DOM_FORIGN',  		fieldLabel: '<t:message code="system.label.base.domesticoverseas" default="국내외"/>', 		xtype:'uniCombobox', comboType:'AU', comboCode:'B019' }
						  		,{ name: 'STOCK_CARE_YN',  		fieldLabel: '<t:message code="system.label.base.inventorymanageobject" default="재고관리대상"/>',  xtype:'uniRadiogroup', comboType:'AU', comboCode:'B010', width:235, allowBlank:false}
						  		, Unilite.popup('ITEM',	{fieldLabel: '<t:message code="system.label.base.summaryitemcode2" default="집계품목"/>', textFieldName:'TOTAL_ITEM_NAME', valueFieldName:'TOTAL_ITEM', valueFieldWidth:120, textFieldWidth:150, verticalMode:true})
						  		,{ name: 'TOTAL_TRAN_RATE', 	fieldLabel: '<t:message code="system.label.base.summaryexchangefactor" default="집계환산계수"/>', xtype : 'uniNumberfield', maxLength: 12}
						  		,{ name: 'BARCODE',  			fieldLabel: '<t:message code="system.label.base.barcode" default="바코드"/>' 		,maxLength: 15}
						  		,{ name: 'BIG_BOX_BARCODE',  			fieldLabel: '대박스' 		,maxLength: 20}
						  		,{ name: 'SMALL_BOX_BARCODE',  			fieldLabel: '소박스' 		,maxLength: 20}
						  		,{ name: 'HS_NO',  				fieldLabel: '<t:message code="system.label.base.hsnumber" default="HS번호"/>' 		,maxLength: 20}
						  		,{ name: 'HS_NAME',  			fieldLabel: '<t:message code="system.label.base.hsname" default="HS명"/>' 			,maxLength: 60}
						  		,{ name: 'HS_UNIT',  			fieldLabel: '<t:message code="system.label.base.hsunit" default="HS단위"/>' 		,xtype:'uniCombobox'	,comboType:'AU', comboCode:'B013', displayField: 'value'}
						  		,{ name: 'ITEM_MAKER',  		fieldLabel: '<t:message code="system.label.base.mfgmaker" default="제조메이커"/>' 	,maxLength: 50}
						  		,{ name: 'ITEM_MAKER_PN',  	 	fieldLabel: '<t:message code="system.label.base.makerpartno" default="메이커 PART NO"/>',maxLength: 50}
						  		,{ name: 'EXPIRATION_DAY',      fieldLabel: '유효기간', xtype: 'uniNumberfield',type: 'int',suffixTpl: '<t:message code="system.label.base.avg" default="개월"/>'}
						  		,{ name: 'CIR_PERIOD_YN',  		fieldLabel: '<t:message code="system.label.base.expiredateyn" default="유통기한관리"/>',  xtype:'uniRadiogroup',comboType:'AU', comboCode:'B010', value:'N', width:235, allowBlank:false}
        					 ]
	    		},{  title: '<t:message code="system.label.base.productphoto" default="제품사진"/>'
	    			, colspan: 3
	    			, layout: {
					            type: 'uniTable',
					            columns: 1,
					            tdAttrs: {valign:'top'}
					        }
        			, defaults: {type: 'uniTextfield'}
        			,items :[	 itemInfoGrid
        						//,{ name: '_fileChange',  			fieldLabel: '사진수정여부'  ,hidden:true	}
        					 ]
	    		}
	    		,{  title: '<t:message code="system.label.base.remarks" default="비고"/>'
	    			, colspan: 3
					, layout: {
					            type: 'uniTable',
					            columns: 1
					        }
					, defaults : { type:'uniTextfield'}
        			,items :[	 { name: 'REMARK1',  			fieldLabel: '<t:message code="system.label.base.remarks" default="비고"/>1'  ,width:785	}
						  		,{ name: 'REMARK2',  			fieldLabel: '<t:message code="system.label.base.remarks" default="비고"/>2'  ,width:785	}
						  		,{ name: 'REMARK3',  			fieldLabel: '<t:message code="system.label.base.remarks" default="비고"/>3'  ,width:785	}

        					 ]
	    		}
	    	]
			,loadForm: function(record)	{
   				// window 오픈시 form에 Data load
//				this.reset();
//				this.setActiveRecord(record || null);
//				this.resetDirtyStatus();
				//itemImageForm.setImage(record.get('IMAGE_FID'));

				/*var win = this.up('uniDetailFormWindow');
                if(win) {       // 처음 윈도열때는 윈독 존재 하지 않음.
   				     win.setToolbarButtons(['saveBtn','saveCloseBtn'],false);
                     win.setToolbarButtons(['prev','next'],true);
                }*/
   			},
   			listeners:{
//				beforehide: function(grid, eOpts )	{
//					if(directMasterStore.isDirty() )	{
//						var config={
//							success:function()	{
//								detailForm.hide();
//							}
//						};
//						UniAppManager.app.confirmSaveData(config);
//						return false;
//					}
//				},
				hide:function()	{
					masterGrid.show();
					if(panelSearch.getCollapsed()){		//panelSearch가 닫혀 있으면..
						panelResult.show();
					}
				}

   			}

	});

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

//			if(!Ext.isEmpty(selRecord.get('IMAGE_FID')))	{
//				//itemImageForm.hide();
//				//itemImageForm.setImage(selRecord.get('IMAGE_FID'));
//			}
			if(!detailWin) {
				detailWin = Ext.create('widget.uniDetailFormWindow', {
	                title: '<t:message code="system.label.base.detailinformation" default="상세정보"/>',
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
                   /* onSaveDataButtonDown: function() {
                        var config = {success : function()	{

                    						 	detailWin.setToolbarButtons(['saveBtn','saveCloseBtn'],false);
                    						 	detailWin.setToolbarButtons(['prev','next'],true);
                    					}
                    	}
                        UniAppManager.app.onSaveDataButtonDown(config);
                    },*/
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


     Unilite.Main({
      	id  : 'bpr100ukrvApp',
		borderItems : [
			panelSearch,
			panelResult,
			{	region:'center',
				//layout : 'border',
				title:'<t:message code="system.label.base.iteminfo" default="품목정보"/>',
				layout : {type:'vbox', align:'stretch'},
				flex:1,
				tools: [
				   {
						type: 'hum-grid',
			            handler: function () {
			            	detailForm.hide();
			                //masterGrid.show();
			            	//panelResult.show();
			            }
					},{

						type: 'hum-photo',
			            handler: function () {
			            	masterGrid.hide();
			                panelResult.hide();
			                //detailForm.show();
			            }
					},
					{
						xtype: 'button',
			            itemId:'procTool',
			            margin:'0 0 0 10',
			            text: '<t:message code="system.label.base.referprogram" default="관련화면"/>',
			            width: 70,
			            menu: Ext.create('Ext.menu.Menu', {
			                items: [
			                {
			                    itemId: 'issueLinkBtn',
			                    text: '<t:message code="system.label.base.manufacturebomentry" default="제조BOM등록"/>',
			                    handler: function() {
			                    	var record = masterGrid.getSelectedRecord();

			                    	if(!Ext.isEmpty(record)){
    			                        var params = {
    			                        	'PGM_ID' : 'bpr100ukrv',
    			                            'ITEM_CODE' : record.get('ITEM_CODE'),
                                            'ITEM_NAME' : record.get('ITEM_NAME')
    			                        }
				                        var rec = {data : {prgID : 'bpr560ukrv', 'text':''}};
				                        parent.openTab(rec, '/base/bpr560ukrv.do', params);
				                    }
			                    }
			                }, {
			                    itemId: 'itemLinkBtn',
			                    text: '<t:message code="system.label.base.divisioniteminfoentry" default="사업장별 품목정보등록"/>',
			                    handler: function() {
			                    	var record = masterGrid.getSelectedRecord();

                                    if(!Ext.isEmpty(record)){
    			                        var params = {
    			                            'PGM_ID' : 'bpr100ukrv',
                                            'ITEM_CODE' : record.get('ITEM_CODE')
    			                        }
    			                        var rec = {data : {prgID : 'bpr250ukrv', 'text':''}};
    			                        parent.openTab(rec, '/base/bpr250ukrv.do', params);
                                    }
			                    }
			                }]
			            })
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

			UniAppManager.setToolbarButtons(['reset','newData','detail'],true);

	    },
	    onQueryButtonDown: function () {
//	    	detailForm.clearForm();
//			detailForm.resetDirtyStatus();
			masterGrid.getStore().loadStoreRecords();

		},
		onNewDataButtonDown : function()	{
			var r = {
				ITEM_CODE: ''
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
		 *	@param
		 *	@return
		 */
		 onDeleteDataButtonDown: function() {
		 	var selRow = masterGrid.getSelectedRecord();
            if(selRow.phantom != true) {
				if(confirm('<t:message code="system.message.base.confirm001" default="현재행을 삭제 합니다. 삭제 하시겠습니까?"/>')) {
					masterGrid.deleteSelectedRow();
				}
			}else {
				masterGrid.deleteSelectedRow();
            }
		},
		/**
		 *  저장
		 *	@param
		 *	@return
		 */
		onSaveDataButtonDown: function (config) {
//			if(itemImageForm.isDirty())	{
//				itemImageForm.submit({
//							waitMsg: 'Uploading...',
//							success: function(form, action) {
//								if( action.result.success === true)	{
//									masterGrid.getSelectedRecord().set('IMAGE_FID',action.result.fid);
//									directMasterStore.saveStore(config);
//									itemImageForm.setImage(action.result.fid);
//									itemImageForm.clearForm();
//								}
//							}
//					});
//			}else {
				directMasterStore.saveStore(config);
			//}
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
			this.fnInitBinding();
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
					panelResult.setValue('ITEM_CODE',params.ITEM_CODE);
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
			} else if (fieldName == "EXPIRATION_DAY") {
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
					 if(newValue == '')	record.set('REIM',oldValue);

					 var wgt = parseInt(record.get('UNIT_WGT'));
					 var reim = parseInt(record.get('REIM'));
					 if(reim != 0)	{
					 	var vol = wgt/reim;
					 	record.set('UNIT_VOL',vol);
					 }

			}
			return rv;
		}
	}); // validator

};


</script>

