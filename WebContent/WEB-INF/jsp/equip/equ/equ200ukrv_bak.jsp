<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="equ200ukrv"  >
   <t:ExtComboStore comboType="BOR120"  />          <!-- 사업장 -->
 
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >

var SearchInfoWindow, RefSearchWindow , otherRefSearchWindow;	
var excelWindow;
var gImportType, gNationInout ;
var gsDel = '';
var gbRetrieved='';
var isLoad = false; //로딩 플래그 화폐단위 환율 change 로드시 계속 타므로 임시로 막음
var BsaCodeInfo = {
	gsDefaultMoney  : '${gsDefaultMoney}',
	gsAutoNumber 	: '${gsAutoNumber}',
	agreePrsn		: '${agreePrsn}',
	
	gsLotNoInputMethod : '${MNG_LOT}',
	gsLotNoEssential:'${ESS_YN}',
	gsEssItemAccount:'${ESS_ACCOUNT}',
	gsOrderConfirm: '${gsOrderConfirm}'
};
        
var outDivCode = UserInfo.divCode;
var aa = 0;
var agreePrsn = '';
var agreeStatus = '';
var agreeDate = '';

function appMain() {
   
   Unilite.defineModel('equ200ukrvModel1', {
		fields: [
		
			{name: 'CONTROL_NO'		    , text: '관리번호'				, type: 'string'},
            {name: 'PRODUCT_NAME'		    , text: '품명'				, type: 'string'},
            {name: 'SPEC'		    	, text: '규격'				, type: 'string'},
            {name: 'STATE'		    	, text: ''				, type: 'string'},
            {name: 'ASSETS_NO'	    	, text: '자산번호'				, type: 'string'},
            {name: 'MAKER'		    , text: '제작처'				, type: 'string'},
            {name: 'MAKER_NAME'		    , text: '제작처명'				    , type: 'string'},
           
            {name: 'KEEPER'		    , text: '제작처'				, type: 'string'},
            {name: 'MAKE_DT'		        , text: '제작일'				    , type: 'uniDate'},
            {name: 'MAKE_O'		, text: '제작금액'			, type: 'uniUnitPrice'},
            {name: 'WEIGHT'		, text: ''			, type: 'uniUnitPrice'},
            
            {name: 'PRODT_KIND'		    , text: ''				, type: 'string'},
            {name: 'MTRL_KIND'		    , text: ''				, type: 'string'},
            {name: 'MTRL_TEXT'		    , text: ''				, type: 'string'},
            {name: 'PERSON'		    , text: ''				, type: 'string'},
            {name: 'AMEND_O'		    , text: ''				, type: 'uniUnitPrice'},
            
            {name: 'MEMO'		    , text: ''				, type: 'string'},
            {name: 'TEMPC_01'		    , text: ''				, type: 'string'},
            {name: 'TEMPC_02'		    , text: ''				, type: 'string'},
            {name: 'TEMPN_01'		    , text: ''				, type: 'uniUnitPrice'},
            {name: 'TEMPN_02'		    , text: ''				, type: 'uniUnitPrice'},
            
            {name: 'SHEET'		    , text: '관리번호'				, type: 'string'},
			{name: 'USER'		    , text: '관리번호'				, type: 'string'},
			{ name: 'IMAGE_FID',  			text: '사진FID', 		type : 'string' }, 
 			{name: '_fileChange',			text: '사진저장체크' 	,type:'string'	,editable:false}
		]
	});
	var directProxy1 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'equ200ukrvService.selectList',
			update: 'equ200ukrvService.updateDetail',
			create: 'equ200ukrvService.insertDetail',
			destroy: 'equ200ukrvService.deleteDetail',
			syncAll: 'equ200ukrvService.saveAll'
		}
	});	
   /**
    * Store 정의(Service 정의)
    * @type 
    */               
	var directMasterStore1 = Unilite.createStore('equ200ukrvMasterStore1',{
		model: 'equ200ukrvModel1',
		uniOpt: {//控制工具栏
			isMaster: true,         // 상위 버튼 연결 
			editable: true,         // 수정 모드 사용 
			deletable: true,			// 삭제 가능 여부
			allDeletable: false,      // 전체 삭제 가능 여부
			useNavi : false         // prev | newxt 버튼 사용
			
		},
		autoLoad: false,
		proxy: directProxy1,
		listeners:{
			load: function(store, records, successful, eOpts){
				
			},
           	add: function(store, records, index, eOpts) {
           		
           	},
           	update: function(store, record, operation, modifiedFieldNames, eOpts) {
           		
           	},
           	remove: function(store, record, index, isMove, eOpts) {
           		
           	}
		},
		loadStoreRecords: function() {
			var param= Ext.getCmp('searchForm').getValues();      

			console.log( param );
			this.load({
				params: param
			});
		},
		saveStore: function() {				
			var inValidRecs = this.getInvalidRecords();
			console.log("inValidRecords : ", inValidRecs);
			var toCreate = this.getNewRecords();
       		var toUpdate = this.getUpdatedRecords();        		
       		var toDelete = this.getRemovedRecords();
       		var list = [].concat(toUpdate, toCreate);
			console.log("list:", list);
			
			
			
			if(inValidRecs.length == 0) {
				
				var paramMaster= panelResult.getValues();	//syncAll 수정
				
				
				config = {
					params: [paramMaster],
					success: function(batch, option) {
						
						
						UniAppManager.setToolbarButtons('save', false);	
						if (directMasterStore1.count() == 0) {   
							UniAppManager.app.onResetButtonDown();
						}else{
							panelResult.setAllFieldsReadOnly(true);
							directMasterStore1.loadStoreRecords();	
						}
					 } 
				};
				this.syncAllDirect(config);
			} else {
                var grid = Ext.getCmp('equ200ukrvGrid1');
                grid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		}
	});//End of var directMasterStore1 = Unilite.createStore('equ200ukrvMasterStore1',{

	
	var panelSearch = Unilite.createSearchPanel('searchForm', {		 
		title: '검색조건',		
        defaultType: 'uniSearchSubPanel',
        collapsed: !UserInfo.appOption.collapseLeftSearch,
        listeners: {
//	        collapse: function () {
//	        	panelResult.show();
//	        },
//	        expand: function() {
//	        	panelResult.hide();
//	        }
	    },
	    items: [{
	        	fieldLabel: '관리번호', 
				xtype: 'uniTextfield',
				name:'CTRL_NO',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('CTRL_NO', newValue);
					}
				}
		    }
		],
		setAllFieldsReadOnly: function(b) {
				var r= true
				if(b) {
					var invalid = this.getForm().getFields().filterBy(function(field) {
																		if(field.name == 'SO_AMT' && field.getValue() == 0){
																			return false;
																		}
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
							if(Ext.isDefined(item.holdable) )	{
							 	if (item.holdable == 'hold') {
									item.setReadOnly(true); 
								}
							} 
							if(item.isPopupField)	{
								var popupFC = item.up('uniPopupField')	;							
								if(popupFC.holdable == 'hold') {
									popupFC.setReadOnly(true);
								}
							}
						})  
	   				}
		  		} else {
		  			var fields = this.getForm().getFields();
					Ext.each(fields.items, function(item) {
						if(Ext.isDefined(item.holdable) )	{
						 	if (item.holdable == 'hold') {
								item.setReadOnly(false);
							}
						} 
						if(item.isPopupField)	{
							var popupFC = item.up('uniPopupField')	;	
							if(popupFC.holdable == 'hold' ) {
								item.setReadOnly(false);
							}
						}
					})
  				}
				return r;
  			}
	});//End of var panelSearch = Unilite.createSearchForm('searchForm', {
	
	var panelResult = Unilite.createSearchForm('resultForm',{
		//hidden: !UserInfo.appOption.collapseLeftSearch,
    	region: 'north',
		layout : {type : 'uniTable', columns : 1,	rows:2, tableAttrs: { style: { width: '100%',height:'100%' } }},
		padding:'1 1 1 1',
		border:true,
		defaultType: 'container',
		
		items: [{
	        	fieldLabel: '관리번호', 
				xtype: 'uniTextfield',
				name:'CTRL_NO',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('CTRL_NO', newValue);
					}
				}
		    }
		],
			setAllFieldsReadOnly: function(b) {
				var r= true
				if(b) {
					var invalid = this.getForm().getFields().filterBy(function(field) {
																		if(field.name == 'SO_AMT' && field.getValue() == 0){
																			return false;
																		}
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
							if(Ext.isDefined(item.holdable) )	{
							 	if (item.holdable == 'hold') {
									item.setReadOnly(true); 
								}
							} 
							if(item.isPopupField)	{
								var popupFC = item.up('uniPopupField')	;							
								if(popupFC.holdable == 'hold') {
									popupFC.setReadOnly(true);
								}
							}
						})  
	   				}
		  		} else {
		  			var fields = this.getForm().getFields();
					Ext.each(fields.items, function(item) {
						if(Ext.isDefined(item.holdable) )	{
						 	if (item.holdable == 'hold') {
								item.setReadOnly(false);
							}
						} 
						if(item.isPopupField)	{
							var popupFC = item.up('uniPopupField')	;	
							if(popupFC.holdable == 'hold' ) {
								item.setReadOnly(false);
							}
						}
					})
  				}
				return r;
  			},     
        listeners: {            
           
            collapse: function () {
                panelResult.show();
            },
            expand: function() {
                panelResult.hide();
            }
        }
    });		// end of var panelResult = Unilite.createSearchForm('resultForm',{
    
      
	var masterGrid = Unilite.createGrid('equ200ukrvGrid1', {
       // for tab       
		title: '',
		layout: 'fit',
		region:'center',
	
		uniOpt: {
    		useGroupSummary: false,
    		useLiveSearch: true,
			useContextMenu: true,
			useMultipleSorting: true,
			useRowNumberer: false,
			expandLastColumn: false,
    		filter: {
				useFilter: false,
				autoCreate: false
			},
			excel: {
				useExcel      : true,			//엑셀 다운로드 사용 여부
				exportGroup   : true, 		//group 상태로 export 여부
				onlyData      : false,
				summaryExport : true
			}
        },
//        features: [{
//        	id: 'masterGridSubTotal',
//        	ftype: 'uniGroupingsummary',
//        	showSummaryRow: true 
//        	},{
//        	id: 'masterGridTotal',
//        	ftype: 'uniSummary',  
//        	showSummaryRow: true
//        	} 
//        ],
		store: directMasterStore1,
		
		columns: [
			{dataIndex: 'CONTROL_NO'		        , width: 120},
			{dataIndex: 'PRODUCT_NAME'		        , width: 120},
			{dataIndex: 'SPEC'		        , width: 120},
			
			{dataIndex:'MAKER'		,width:140	
				  ,editor : Unilite.popup('CUST_G',{						            
				    				textFieldName:'MAKER',
				    				listeners: {
						                'onSelected':  function(records, type  ){
						                    	var grdRecord = masterGrid.uniOpt.currentRecord;
						                    	grdRecord.set('MAKER',records[0]['CUSTOM_CODE']);
						                    	grdRecord.set('MAKER_NAME',records[0]['CUSTOM_NAME']);
						                }
						                ,'onClear':  function( type  ){
						                    	var grdRecord = masterGrid.uniOpt.currentRecord;
						                    	grdRecord.set('MAKER','');
						                    	grdRecord.set('MAKER_NAME','');
						                }
						            } // listeners
								}) 		
				},
				{dataIndex:'MAKER_NAME'		,width:140	
				  ,editor : Unilite.popup('CUST_G',{						            
				    				textFieldName:'MAKER_NAME',
				    				listeners: {
						                'onSelected':  function(records, type  ){
						                    	var grdRecord = masterGrid.uniOpt.currentRecord;
						                    	grdRecord.set('MAKER',records[0]['CUSTOM_CODE']);
						                    	grdRecord.set('MAKER_NAME',records[0]['CUSTOM_NAME']);
						                }
						                ,'onClear':  function( type  ){
						                    	var grdRecord = masterGrid.uniOpt.currentRecord;
						                    	grdRecord.set('MAKER','');
						                    	grdRecord.set('MAKER_NAME','');
						                }
						            } // listeners
								}) 		
				},
			
			{dataIndex: 'MAKE_DT'		        , width: 120},
			{dataIndex: 'MAKE_O'		        , width: 120},
			{dataIndex: 'ASSETS_NO'		        , width: 120},
			{dataIndex: 'SHEET'		        , width: 120,hidden:true},
			{dataIndex: 'USER'		        , width: 120,hidden:true}
			
	
		],listeners: {          	
          	selectionchangerecord:function(selected)	{
          		detailForm.setActiveRecord(selected)
				
          	},
          	onGridDblClick:function(grid, record, cellIndex, colName) {
          		if(!record.phantom) {
	      			switch(colName)	{
					case 'CONTROL_NO' :
							masterGrid.hide();
							break;		
					default:
							break;
	      			}
          		}
          	},
			hide:function()	{
				detailForm.show();
			}, 
			edit: function(editor, e) {
				var record = masterGrid.getSelectedRecord();
                detailForm.setActiveRecord(record);
            }
          } 
	});
	/**
     * 상세 Form
     */
          var itemImageForm = Unilite.createForm('equ200ImageForm' +
     		'itemImageForm', {
	    	 			 fileUpload: true,
						 url:  CPATH+'/fileman/upload.do',
						 disabled:false,
				    	 width:450,
				    	 height:500,
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
								  { xtype: 'image', id:'equ200', src:CPATH+'/resources/images/nameCard.jpg', width:400,	 overflow:'auto', colspan:2}
					             ]
					   , setImage : function (fid)	{
						    	 	var image = Ext.getCmp('equ200');
						    	 	var src = CPATH+'/resources/images/nameCard.jpg'
						    	 	if(!Ext.isEmpty(fid))	{
							         	//src = CPATH+'/fileman/download.do?fid='+fid+'&inline=Y';
							         	src= CPATH+'/fileman/view/'+fid;
						    	 	}
							        image.setSrc(src);
						    	 }
	});
    
    var detailForm = Unilite.createForm('detailForm', {
//      region:'south',
//    	weight:-100,
//    	height:400,
//    	split:true,
    	hidden: true,
    	masterGrid: masterGrid,
        autoScroll:true,
        flex:1,
        border: false,
      	layout: {type: 'uniTable', columns: 3, tableAttrs:{cellpadding:5}, tdAttrs: {valign:'top'}},
	    defaultType: 'uniFieldset',
	    defaults : { margin: '0 0 0 0'},
        uniOpt:{
        	store : directMasterStore1
        },
     	api: {
	 		 load: 'equ200ukrvService.selectListForForm'		
		},
	  
		items : [{ 	title: ''
	    			, colspan: 1
					, layout: {
					            type: 'uniTable',
					            columns: 1
					  }
					, height: 500
					, defaults : { type:'uniTextfield'},
	    items : [{
	        	fieldLabel: '관리번호', 
				xtype: 'uniTextfield',
				name:'CONTROL_NO',
				readOnly:true
				
		    },{
	        	fieldLabel: '품명', 
				xtype: 'uniTextfield',
				name:'PRODUCT_NAME'
		    },{
	        	fieldLabel: '규격', 
				xtype: 'uniTextfield',
				name:'SPEC'
		    },{
				fieldLabel: '중량',
				name: 'WEIGHT',
				decimalPrecision:0,
				xtype:'uniNumberfield'
			},{
				fieldLabel: '수량',
				name: 'MAKE_Q',
				decimalPrecision:4,
				xtype:'uniNumberfield'
			},{
				fieldLabel: '금액',
				name: 'MAKE_O',
				decimalPrecision:2,
				xtype:'uniNumberfield'
			},{
	        	fieldLabel: '상태', 
				xtype: 'uniCombobox',
				comboType:'AU',
				comboCode:'I801' ,
				name:'STATE'
		    },
		    Unilite.popup('CUST', { 
					fieldLabel: '제작처', 
					valueFieldName: 'MAKER',
			   	 	textFieldName: 'MAKER_NAME',
					listeners: {
						onSelected: {
							fn: function(records, type) {
								
	                    	},
							scope: this
						},
						onClear: function(type)	{
								
						}
					}
			}),{
	        	fieldLabel: '제작일', 
				xtype: 'uniDatefield',
				name:'MAKE_DT'
		    },{
	        	fieldLabel: '금형종류', 
				xtype: 'uniCombobox',
				comboType:'AU',
				comboCode:'I802',
				name:'PRODT_KIND'
		    },{
	        	fieldLabel: '재질', 
				xtype: 'uniCombobox',
				comboType:'AU',
				comboCode:'I803',
				name:'MTRL_KIND'
		    },{
	        	fieldLabel: '자산번호', 
				xtype: 'uniTextfield',
				name:'ASSETS_NO'
		    },Unilite.popup('CUST', { 
					fieldLabel: '보관처', 
					valueFieldName: 'KEEPER',
			   	 	textFieldName: 'KEEPER_NAME',
					listeners: {
						onSelected: {
							fn: function(records, type) {
								
	                    	},
							scope: this
						},
						onClear: function(type)	{
								
						}
					}
			}),{
	        	fieldLabel: '수정금액', 
				xtype: 'uniTextfield',
				decimalPrecision:2,
				name:'AMEND_O'
		    },{
	        	fieldLabel: '메모', 
				xtype: 'uniTextfield',
				name:'ETC_NOTE'
		    }]},{	title: ''
	    			, colspan: 2
	    			, layout: {
					            type: 'uniTable',
					            columns: 1,
					            tdAttrs: {valign:'top'}
					            
					        }
        			, defaults: {type: 'uniTextfield'}
			    	,items :[	 itemImageForm
	        					,{ name: '_fileChange',  			fieldLabel: '사진수정여부'  ,hidden:true	} 
	        				]
		    }]
		    ,loadForm: function(record)	{
   				
				itemImageForm.setImage(record.get('IMAGE_FID'));
				
			
   			}
	    });
	
	Unilite.Main( {
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
				panelResult,{region:'center',
				//layout : 'border',
				title:'',
				layout : {type:'vbox', align:'stretch'},
				flex:1,
				autoScroll:true,
				tools: [
					{
						type: 'hum-grid',					            
			            handler: function () {
			            	detailForm.hide();
			                masterGrid.show();
			            	panelResult.show();
			            	 UniAppManager.setToolbarButtons(['newData'], true);
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
			                panelResult.show();
			                detailForm.show();
			                if(masterGrid.getSelectedRecord()){
			                	var contrlNo = masterGrid.getSelectedRecord().get("CONTROL_NO");
				                panelResult.setValue("CTRL_NO",contrlNo);
				                panelSearch.setValue("CTRL_NO",contrlNo);
				                if(contrlNo){
				                	UniAppManager.app.onLoadForm();
				                }
			                }
			                UniAppManager.setToolbarButtons(['newData'], false);
			                
			            }
					}
				],
				items:[					
					masterGrid, 
					detailForm					
				]
			}
			]
		}/*,
			panelSearch*/  	
		],
		id: 'equ200ukrvApp',
		fnInitBinding: function(params) {
			
			UniAppManager.setToolbarButtons(['newData','reset'], true);
			UniAppManager.setToolbarButtons(['save','deleteAll'], false);
			
		},
        
		onQueryButtonDown: function() {  
			if(!masterGrid.hidden){
				masterGrid.getStore().loadStoreRecords();
			}else{
				UniAppManager.app.onLoadForm();
			}
	
		},
		onLoadForm: function(){
			var param= panelResult.getValues();
			detailForm.uniOpt.inLoading = true;
			Ext.getBody().mask('로딩중...','loading-indicator');
			detailForm.getForm().load({
				params: param,
				success:function()	{
					Ext.getBody().unmask();
					if(masterGrid.getSelectedRecord()){
			        	detailForm.loadForm(masterGrid.getSelectedRecord());
					}
					
					detailForm.uniOpt.inLoading = false;
				},
				failure: function(batch, option) {					 	
				 	Ext.getBody().unmask();					 
				 }
			})
		},
		onResetButtonDown: function() {
			panelSearch.clearForm();
			panelSearch.setAllFieldsReadOnly(false);
			masterGrid.reset();
			panelResult.clearForm();
			panelResult.setAllFieldsReadOnly(false);
			this.fnInitBinding();
			
		},
		
        onNewDataButtonDown: function()	{
        	
        	var seq = directMasterStore1.max('SO_SER');
        	if(!seq) seq = 1;
        	else  seq += 1;
        	var r = {
        		'SO_SER':seq
        		
        	};
        	masterGrid.createRow(r);
        },
        
        onSaveDataButtonDown: function(config) {
	        if(itemImageForm.isDirty())	{
				itemImageForm.submit({
							waitMsg: 'Uploading...',
							success: function(form, action) {
								if( action.result.success === true)	{
									masterGrid.getSelectedRecord().set('IMAGE_FID',action.result.fid);									
									directMasterStore1.saveStore(config);
									itemImageForm.setImage(action.result.fid);
									itemImageForm.clearForm();
								}
							}
					});
			}else {
        		directMasterStore1.saveStore();
			}
        },
		onDeleteDataButtonDown: function() {
			var selRow = masterGrid.getSelectedRecord();
			if(selRow.phantom === true)	{
				masterGrid.deleteSelectedRow();
			}else {
				if(selRow.get('CLOSE_FLAG') == 'Y'){
					Ext.Msg.alert('<t:message code="unilite.msg.sMB099"/>','이루 프로셰스가 진형중입니 다， 수정 및 삭제 울가능힘니다');
				}else{
					if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
							masterGrid.deleteSelectedRow();
					}
				}
		    } 
		    if(Ext.isEmpty(directMasterStore1.data.items)){
		    	gsDel = "Y";
		    }
		    
		},
         onDeleteAllButtonDown: function() {            
            
            
        }
		
	});
	Unilite.createValidator('validator01', {
		store: directMasterStore1,
		grid: masterGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
			var rv = true;
			var dPrice = record.get('PRICE');
			var dQty = record.get('QTY');
			var dExchR = record.get('EXCHANGE_RATE'); 
			var dTrnsRate = record.get('TRNS_RATE'); 
			switch(fieldName) {
				case "UNIT" :
					//fnGetPrice(null,record,callbackUnit(),newValue,fieldName); 修改為同步
					break;
					
				case "QTY" :
					if(newValue <= 0){
						rv = '<t:message code="unilite.msg.sMB076"/>';
						break;
					}
					var dSoAmt = newValue * dPrice;
					var stockUnitQ = newValue * dTrnsRate;
					record.set('SO_AMT', dSoAmt);
					record.set('STOCK_UNIT_Q',stockUnitQ);
					record.set('SO_AMT_WON',dSoAmt * dExchR);
					
					directMasterStore1.fnAmtTotal();
				break;
				case "STOCK_UNIT_Q" :
					if(newValue <= 0){
						rv = '<t:message code="unilite.msg.sMB076"/>';
						break;
					}
					var dStockUnitQ = newValue;
					dQty = dStockUnitQ / dTrnsRate;
					dQty = UniSales.fnAmtWonCalc(dQty,'1');//向上取整
					record.set('QTY', dQty);
					
					var dSoAmt = dQty * dPrice;
					var stockUnitQ = dQty * dTrnsRate;
					
					record.set('SO_AMT', dSoAmt);
					record.set('SO_AMT_WON',dSoAmt * dExchR);
					
					directMasterStore1.fnAmtTotal();
				break;
				
				case "TRNS_RATE" :
					if(newValue <= 0){
						rv = '<t:message code="unilite.msg.sMB076"/>';
						break;
					}
					dTrnsRate = newValue;
					record.set('STOCK_UNIT_Q', dQty * dTrnsRate);
					directMasterStore1.fnAmtTotal();
				break;
				
				case "PRICE" :
					dPrice = newValue;
					var dSoAmt = dQty * dPrice;
					
					record.set('SO_AMT', dSoAmt);
					record.set('SO_AMT_WON',dSoAmt * dExchR);
					directMasterStore1.fnAmtTotal();
				break;
				case "SO_AMT" :
					if(newValue <= 0){
						rv = '<t:message code="unilite.msg.sMB076"/>';
						break;
					}
					var dSoAmt = newValue;
					record.set('PRICE',dSoAmt / dQty);
					record.set('SO_AMT_WON',dSoAmt * dExchR);
					directMasterStore1.fnAmtTotal();
				break;
				case "MORE_PER_RATE" :
					if(newValue <= 0){
						rv = '<t:message code="unilite.msg.sMB076"/>';
						break;
					}
				break;
				case "LESS_PER_RATE" :
					if(newValue <= 0){
						rv = '<t:message code="unilite.msg.sMB076"/>';
						break;
					}
				break;
				case "USE_QTY" :
					if(newValue <= 0){
						rv = '<t:message code="unilite.msg.sMB076"/>';
						break;
					}
				break;
				case "DELIVERY_DATE" :
					
				break;
				case "TRNS_RATE" :
					if(newValue <= 0){
						rv = '<t:message code="unilite.msg.sMB076"/>';
						break;
					}
				break;
				case "INSPEC_FLAG" :
					
				break;
			}
			return rv;
		}
	});
	
	
							
};


</script>