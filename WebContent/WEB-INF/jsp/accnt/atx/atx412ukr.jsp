<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="atx412ukr"  >
	<t:ExtComboStore comboType="BOR120"  /> 				<!-- 사업장 -->   
	<t:ExtComboStore comboType="AU" comboCode="T001" /> 	<!-- 무역구분 -->      
	<t:ExtComboStore comboType="AU" comboCode="A030" /> 	<!-- 지상지하 -->
	<t:ExtComboStore comboType="AU" comboCode="T071" /> 	<!-- 진행구분(수입) -->

<style type="text/css">

#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>	
</t:appConfig>
<script type="text/javascript" >

function appMain() {
	
	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read: 'atx412ukrService.selectMaster',
			update: 'atx412ukrService.updateDetail',
			create: 'atx412ukrService.insertDetail',
			destroy: 'atx412ukrService.deleteDetail',
			syncAll: 'atx412ukrService.saveAll'
		}
	});
	
	/**
	 *   Model 정의 
	 * @type 
	 */
	Unilite.defineModel('Atx412ukrModel', {
	    fields: [
	    	{name: 'COMP_CODE'        	,text: 'COMP_CODE' 			,type: 'string'},
	    	{name: 'BILL_DIV_CODE'	   	,text: '신고사업장' 			,type: 'string', allowBlank: false, xtype: 'uniCombobox', comboType: 'BOR120'},
	    	{name: 'BUILD_CODE'	   		,text: '부동산코드' 			,type: 'string', allowBlank: false, maxLength: 8},
	    	{name: 'BUILD_NAME'	   		,text: '부동산명' 				,type: 'string', allowBlank: false},
	    	{name: 'DONG'			   	,text: '동' 					,type: 'string'},
	    	{name: 'UP_UNDER'		   	,text: '지하/지상' 			,type: 'string', allowBlank: false, comboType: 'AU', comboCode: 'A030'},
	    	{name: 'UP_FLOOR'		   	,text: '층' 					,type: 'string', allowBlank: false},
	    	{name: 'HOUSE'			   	,text: '호수' 				,type: 'string'},
	    	{name: 'HOUSE_CNT'        	,text: '호실수' 				,type: 'string'},
	    	{name: 'AREA' 		   	  	,text: '면적' 				,type: 'string'}
		]
	});
	
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var MasterStore = Unilite.createStore('atx412ukrMasterStore',{
			model: 'Atx412ukrModel',
			uniOpt : {
            	isMaster: true,			// 상위 버튼 연결
            	editable: true,			// 수정 모드 사용 
            	deletable:true,			// 삭제 가능 여부 
	            useNavi : false			// prev | newxt 버튼 사용
            },
            autoLoad: false,
            proxy: directProxy
			,loadStoreRecords : function()	{
				var param= Ext.getCmp('searchForm').getValues();			
				console.log( param );
				this.load({
					params : param
				});
				
			}
			,saveStore : function(config)	{	
				var inValidRecs = this.getInvalidRecords();
				var toCreate = this.getNewRecords();
            	var toUpdate = this.getUpdatedRecords();
            	console.log("toUpdate",toUpdate);

            	var rv = true;
       	
            	if(inValidRecs.length == 0 )	{										
					config = {
						success: function(batch, option) {								
							panelResult.resetDirtyStatus();
							UniAppManager.setToolbarButtons('save', false);			
						 } 
					};					
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
	var panelSearch = Unilite.createSearchPanel('searchForm', {		
		title: '검색조건',
        defaultType: 'uniSearchSubPanel',
        collapsed:true,
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
   			itemId: 'search_panel1',
           	layout: {type: 'uniTable', columns: 1},
           	defaultType: 'uniTextfield',
		    items : [{					
				fieldLabel: '신고사업장',
				name:'DIV_CODE',	
				xtype: 'uniCombobox',
				comboType:'BOR120' ,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('DIV_CODE', newValue);
					}
				} 
			},
    		Unilite.popup('REALTY',{
			fieldLabel: '부동산',
		    valueFieldName:'REALTY_CODE',
		    textFieldName:'REALTY_NAME',
		    validateBlank:false,
        	listeners: {
				onSelected: {
				fn: function(records, type) {
					console.log('records : ', records);
					panelResult.setValue('REALTY_CODE', panelSearch.getValue('REALTY_CODE'));
					panelResult.setValue('REALTY_NAME', panelSearch.getValue('REALTY_NAME'));	
            	},
				scope: this
				},
				onClear: function(type)	{
					panelSearch.setValue('REALTY_CODE', '');
					panelSearch.setValue('REALTY_NAME', '');
					panelResult.setValue('REALTY_CODE', '');
					panelResult.setValue('REALTY_NAME', '');
				},
				applyextparam: function(popup){							
					popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
				}
			}		        
		    })]		
		}],
		
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
		      		//this.mask();
		      		var fields = this.getForm().getFields();
		      		Ext.each(fields.items, function(item) {
		       			if(Ext.isDefined(item.holdable) ) {
		         			if (item.holdable == 'hold') {
		         				item.setReadOnly(true); 
		        			}
		       			} 
		       			if(item.isPopupField) {
		        			var popupFC = item.up('uniPopupField') ;       
		        			if(popupFC.holdable == 'hold') {
		         				popupFC.setReadOnly(true);
		        			}
		       			}
		      		})
		       	}
		    } else {
		    	//this.unmask();
		       	var fields = this.getForm().getFields();
		     	Ext.each(fields.items, function(item) {
		      		if(Ext.isDefined(item.holdable) ) {
		        		if (item.holdable == 'hold') {
		        			item.setReadOnly(false);
		       			}
		      		} 
		      		if(item.isPopupField) {
		       			var popupFC = item.up('uniPopupField') ; 
		       			if(popupFC.holdable == 'hold' ) {
		        			item.setReadOnly(false);
		      			}
		      		}
		     	})
		    }
		    return r;
		},
		setLoadRecord: function(record) {
			var me = this;   
		   	me.uniOpt.inLoading=false;
		    me.setAllFieldsReadOnly(true);
		}
	});
	
	var panelResult = Unilite.createSearchForm('panelResultForm', {		
    	hidden: !UserInfo.appOption.collapseLeftSearch,
		region: 'north',
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
	    items :[{
    		fieldLabel: '신고사업장',
			name:'DIV_CODE',	
			xtype: 'uniCombobox',
			comboType:'BOR120' ,
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {						
					panelSearch.setValue('DIV_CODE', newValue);
				}
			} 
		},
			Unilite.popup('REALTY',{
			fieldLabel: '부동산',
		    valueFieldName:'REALTY_CODE',
		    textFieldName:'REALTY_NAME',
		    validateBlank:false,
        	listeners: {
				onSelected: {
				fn: function(records, type) {
					console.log('records : ', records);
					panelSearch.setValue('REALTY_CODE', panelResult.getValue('REALTY_CODE'));
					panelSearch.setValue('REALTY_NAME', panelResult.getValue('REALTY_NAME'));	
            	},
				scope: this
				},
				onClear: function(type)	{
					panelResult.setValue('REALTY_CODE', '');
					panelResult.setValue('REALTY_NAME', '');
					panelSearch.setValue('REALTY_CODE', '');
					panelSearch.setValue('REALTY_NAME', '');
				},
				applyextparam: function(popup){							
					popup.setExtParam({'DIV_CODE': panelSearch.getValue('DIV_CODE')});
				}
			}		        
		    })
		],
		
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
		      		//this.mask();
		      		var fields = this.getForm().getFields();
		      		Ext.each(fields.items, function(item) {
		       			if(Ext.isDefined(item.holdable) ) {
		         			if (item.holdable == 'hold') {
		         				item.setReadOnly(true); 
		        			}
		       			} 
		       			if(item.isPopupField) {
		        			var popupFC = item.up('uniPopupField') ;       
		        			if(popupFC.holdable == 'hold') {
		         				popupFC.setReadOnly(true);
		        			}
		       			}
		      		})
		       	}
		    } else {
		    	//this.unmask();
		       	var fields = this.getForm().getFields();
		     	Ext.each(fields.items, function(item) {
		      		if(Ext.isDefined(item.holdable) ) {
		        		if (item.holdable == 'hold') {
		        			item.setReadOnly(false);
		       			}
		      		} 
		      		if(item.isPopupField) {
		       			var popupFC = item.up('uniPopupField') ; 
		       			if(popupFC.holdable == 'hold' ) {
		        			item.setReadOnly(false);
		      			}
		      		}
		     	})
		    }
		    return r;
		},
		setLoadRecord: function(record) {
			var me = this;   
		   	me.uniOpt.inLoading=false;
		    me.setAllFieldsReadOnly(true);
		}
	});

    /**
     * Master Grid1 정의(Grid Panel)
     * @type 
     */
    var masterGrid = Unilite.createGrid('atx412ukrGrid', {
    	// for tab    	
        layout : 'fit',
        region:'center',
        uniOpt:{	expandLastColumn: true,
        			useRowNumberer: true,
                    useMultipleSorting: true
        },
    	store: MasterStore,
    	features: [ {id : 'masterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false },
    	           	{id : 'masterGridTotal', 	ftype: 'uniSummary', 	  showSummaryRow: false} ],
        columns:  [        
        	{ dataIndex: 'COMP_CODE'        , 			width: 66, hidden: true},
            { dataIndex: 'BILL_DIV_CODE'	, 			width: 133},
            { dataIndex: 'BUILD_CODE'	    , 			width: 106},
            { dataIndex: 'BUILD_NAME'	    , 			width: 200},
            {text: '부동산정보',
          		columns: [
          			{ dataIndex: 'DONG'			, 			width: 80},
            		{ dataIndex: 'UP_UNDER'		, 			width: 80},
            		{ dataIndex: 'UP_FLOOR'		, 			width: 80},
            		{ dataIndex: 'HOUSE'		,			width: 93},
         			{ dataIndex: 'HOUSE_CNT'    , 			width: 80},
            		{ dataIndex: 'AREA' 		, 			width: 80}
            	]
            },
            { dataIndex: 'INSERT_DB_USER'   , 			width: 66, hidden: true},
            { dataIndex: 'INSERT_DB_TIME'   , 			width: 66, hidden: true},
            { dataIndex: 'UPDATE_DB_USER'   , 			width: 66, hidden: true},
            { dataIndex: 'UPDATE_DB_TIME'   , 			width: 66, hidden: true}   		
        ] ,
		listeners: {
        	beforeedit: function( editor, e, eOpts ) {
        		if(e.record.phantom == false) {
        		 	if(UniUtils.indexOf(e.field, ['BUILD_CODE']))
				   	{
						return false;
      				} else {
      					return true;
      				}
        		} else {
        			if(UniUtils.indexOf(e.field))
				   	{
						return true;
      				}
        		}
        	} 	
        }
    });   
	
	
    Unilite.Main( {
		borderItems:[{
			border: false,
			region:'center',
			layout: 'border',
			items:[
				masterGrid, panelResult
			]	
		}		
		, panelSearch
		],
		id  : 'atx412ukrApp',
		fnInitBinding : function() {
			UniAppManager.setToolbarButtons('detail',false);
			UniAppManager.setToolbarButtons('reset',false);
		},
		
		onQueryButtonDown : function()	{			
			if(panelSearch.setAllFieldsReadOnly(true) == false){
				return false;
			}
			if(panelResult.setAllFieldsReadOnly(true) == false){
				return false;
			}
			MasterStore.loadStoreRecords();
			UniAppManager.setToolbarButtons('newData', true); 
		},
		
		onNewDataButtonDown: function()	{		// 행추가
			//if(containerclick(masterGrid)) {
				var compCode    	=	UserInfo.compCode;   
				var billDivCode 	=	panelSearch.getValue('DIV_CODE');
				var buildCode	   	=	'';
				var buildName	   	=	'';
				var dong			=	'';
				var upUnder			=	'';
				var upFloor			=	'';
				var house			=	'';
				var houseCnt     	=	'1';
				var area 		  	= 	'0';
				
				var r = {
					COMP_CODE    	:	compCode,    
					BILL_DIV_CODE	:	billDivCode, 
					BUILD_CODE	 	:	buildCode,	
					BUILD_NAME	 	:	buildName,	
					DONG			:	dong,		
					UP_UNDER		:	upUnder,		
					UP_FLOOR		:	upFloor,		
					HOUSE			:	house,		
					HOUSE_CNT    	:	houseCnt,   
					AREA 		 	:	area 		
				};
				masterGrid.createRow(r);
		},
		
		onDeleteDataButtonDown: function() {
			if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
				masterGrid.deleteSelectedRow();
			}
		},
		
		/*confirmSaveData: function(config)	{	// 저장하기전 원복 시키는 작업
			if(confirm(Msg.sMB061))	{
				this.onSaveDataButtonDown(config);
			} else {
				//this.rejectSave();
			}
		},*/
		
		onSaveDataButtonDown: function(config) {	// 저장 버튼
			MasterStore.saveStore();
		},
		
		onDetailButtonDown:function() {
			var as = Ext.getCmp('AdvanceSerch');	
			if(as.isHidden())	{
				as.show();
			} else {
				as.hide()
			}
		}
	});


Unilite.createValidator('validator01', {
		store: MasterStore,
		grid: masterGrid,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			switch(fieldName) {
				case "HOUSE_CNT" :
					if(newValue <= 0) {
						rv= Msg.sMB076;		
						break;
					}
				break;
				
				case "AREA" :
					if(newValue <= 0) {
						rv= Msg.sMB076;		
						break;
					}
				break;
			}
			return rv;
		}
	});
};
		
</script>