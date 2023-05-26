<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="cdm300skrv"  >	
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="M001" /> <!-- 발주형태 -->     
	<t:ExtComboStore comboType="AU" comboCode="B010" /> <!-- 발주형태 -->     
	<t:ExtComboStore items="${COMBO_WH_LIST}" 	  storeId="whList" /><!--창고-->
	<t:ExtComboStore items="${COMBO_WS_LIST}" 	  storeId="wsList" /> <!-- 작업장 -->
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL1}" storeId="Level1Store" />
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL2}" storeId="Level2Store" />
	<t:ExtComboStore items="${COMBO_ITEM_LEVEL3}" storeId="Level3Store" />
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >

function appMain() {
	
	Unilite.defineModel('Cdm300skrvModel', {
	    fields: [  	 
	    	{name: 'MSG_CODE',				text: '메시지',			type: 'string', comboType : 'AU', comboCode : 'CD12'},
	    	{name: 'MSG_TYPE',				text: '유형',			type: 'string', comboType : 'AU', comboCode : 'CD13'},
	    	{name: 'MSG_DESC',				text: '메시지 설명',	type: 'string'},
	    	{name: 'ACTION_MSG',			text: '조치 내역',		type: 'string'},
	    	{name: 'PRG_INFO1',				text: '관련 프로그램',  type: 'string'},
	    	{name: 'PRG_INFO2',				text: '관련 프로그램',	type: 'string'},
	    	{name: 'MSG_ID',				text: '메시지 ID',		type: 'string'}
		]
	});	
	
	var directMasterStore = Unilite.createStore('cdm300skrvMasterStore',{
		model: 'Cdm300skrvModel',
		uniOpt : {
        	isMaster  : true,
        	editable  : false,
        	deletable : false,
            useNavi   : false	
        },
        autoLoad: false,
        proxy: {
            type: 'direct',
            api: {			
                read: 'cdm300skrvService.selectList'                	
            }
        },
		loadStoreRecords : function()	{
			var param= Ext.getCmp('searchForm').getValues();
			this.load({
				params : param,
				callback : function(records,options,success){
					if(success)	{
						if(records && records.length > 0){
							var record = records[0].data;
							Ext.getCmp("TXT_MSG_DESC").setValue(record.MSG_DESC);
		    				Ext.getCmp("TXT_ACTION_MSG").setValue(record.ACTION_MSG);
		    				Ext.getCmp("TXT_PRG_INFO").setValue(record.PRG_INFO1);
						}else{
							Ext.getCmp("TXT_MSG_DESC").setValue("");
		    				Ext.getCmp("TXT_ACTION_MSG").setValue("");
		    				Ext.getCmp("TXT_PRG_INFO").setValue("");
						}
						cdm300skrvService.selectMaxSeq(param, function(provider, response){
							cdm300skrvService.selectFlag(param, function(provider1, response1){
								if(JSON.stringify(provider1) !== '[]'){
									panelSearch.setValue("UNIT_FLAG",provider1["UNIT_FLAG"]);
									panelSearch.setValue("DIST_FLAG",provider1["DIST_FLAG"]);
									panelSearch.setValue("ACNT_FLAG",provider1["ACNT_FLAG"]);
									panelSearch.setValue("DELE_FLAG",provider1["DELE_FLAG"]);
									panelSearch.setValue("APLY_FLAG",provider1["APLY_FLAG"]);
									panelSearch.setValue("COST_FLAG",provider1["COST_FLAG"]);
									
									panelResult.setValue("UNIT_FLAG",provider1["UNIT_FLAG"]);
									panelResult.setValue("DIST_FLAG",provider1["DIST_FLAG"]);
									panelResult.setValue("ACNT_FLAG",provider1["ACNT_FLAG"]);
									panelResult.setValue("DELE_FLAG",provider1["DELE_FLAG"]);
									panelResult.setValue("APLY_FLAG",provider1["APLY_FLAG"]);
									panelResult.setValue("COST_FLAG",provider1["COST_FLAG"]);
								}else{
									panelSearch.setValue("UNIT_FLAG","02");
									panelSearch.setValue("DIST_FLAG","01");
									panelSearch.setValue("ACNT_FLAG","01");
									panelSearch.setValue("DELE_FLAG","01");
									panelSearch.setValue("APLY_FLAG","01");
									panelSearch.setValue("COST_FLAG","01");
									
									panelResult.setValue("UNIT_FLAG","02");
									panelResult.setValue("DIST_FLAG","01");
									panelResult.setValue("ACNT_FLAG","01");
									panelResult.setValue("DELE_FLAG","01");
									panelResult.setValue("APLY_FLAG","01");
									panelResult.setValue("COST_FLAG","01");
								}
							});
							if(provider){
								panelResult.setValue("WORK_SEQ_TO", provider["WORK_SEQ"])
								panelSearch.setValue("WORK_SEQ_TO", provider["WORK_SEQ"])
							}else{
								panelResult.setValue("WORK_SEQ_TO", 0)
								panelSearch.setValue("WORK_SEQ_TO", 0)
							}
						});
					}
				}
			});
		}
	});
	
    var panelSearch = Unilite.createSearchPanel('searchForm', {		
		title: '검색조건',
        defaultType: 'uniSearchSubPanel',
        collapsed:true,
        width:480,
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
	        items: [{
	        	fieldLabel: '사업장',
	        	labelWidth:210,
	        	name: 'DIV_CODE',
	        	xtype: 'uniCombobox',
	        	comboType: 'BOR120',
	        	allowBlank: false,
	        	value: UserInfo.divCode,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('DIV_CODE', newValue);
					}
				}
	        },{ name: 'WORK_DATE',
	            fieldLabel: '작업년월',
	            labelWidth:210,
	            xtype: 'uniMonthfield',
	            value:UniDate.get('startOfMonth'),
	            hidden: false, 
	            allowBlank:false, 
	            maxLength: 300,
	            listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('WORK_DATE', newValue);
					}
				}
	        },{
        		fieldLabel: '작업회수',
        		name:'WORK_SEQ_FR',
        		labelWidth:210,
        		xtype:'uniNumberfield',
        		allowBlank:false, 
        		maxLength:3,
        		listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelResult.setValue('WORK_SEQ_FR', newValue);
					}
				}
        		//suffixTpl:'&nbsp;이상'
    		}, {
        		fieldLabel: '/',
        		name:'WORK_SEQ_TO',
        		xtype:'uniNumberfield',
        		labelWidth:210,
        		readOnly:true,
        		listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('WORK_SEQ_TO', newValue);
					}
				}
    		},{
	    		fieldLabel: '원가담당자',
	    		name: 'COST_PRSN', 
	    		xtype: 'uniCombobox',
	    		labelWidth:210,
				comboType: 'AU', 
				comboCode: 'CD03',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('COST_PRSN', newValue);
					}
				}
			},{
		         fieldLabel: '메시지 코드',
		         name: 'MSG_CODE', 
		         xtype: 'uniCombobox', 
		         labelWidth:210,
		         comboType: 'AU',
		         comboCode: 'CD12',
		         width: 300,
		         listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('MSG_CODE', newValue);
					}
				}
	         },{
		         fieldLabel: '유형',
		         name: 'MSG_TYPE',
		         xtype: 'uniCombobox',
		         labelWidth:210,
		         comboType: 'AU',
		         comboCode: 'CD13',
		         listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelResult.setValue('MSG_TYPE', newValue);
					}
				}
	         },{
			    xtype: 'radiogroup',
			    fieldLabel: '원가적용단가',
			    id:'UNIT_FLAG_SEARCH',
			    labelWidth:210,
			    readOnly:true,
			    items : [{
			    	boxLabel: '총평균단가',
			    	name: 'UNIT_FLAG' ,
			    	inputValue: '02',
			    	width:85
			    }, {boxLabel: '기준단가',
			    	name: 'UNIT_FLAG',
			    	inputValue: '01',
			    	width:120
			    }]
			 },{
			    xtype: 'radiogroup',
			    fieldLabel: '계정별배부방법',
			    id:'ACNT_FLAG_SEARCH',
			    labelWidth:210,
			    readOnly:true,
			    items : [{
			    	boxLabel: '계정별 배부',
			    	name: 'ACNT_FLAG' ,
			    	inputValue: '01',
			    	width:85
			    }, {boxLabel: '계정/부서별 배부',
			    	name: 'ACNT_FLAG',
			    	inputValue: '02',
			    	width:120
			    }]
			 },{
			    xtype: 'radiogroup',
			    fieldLabel: '간접비배부유형',
			    id:'DIST_FLAG_SEARCH',
			    labelWidth:210,
			    readOnly:true,
			    items : [{
			    	boxLabel: '생산량',
			    	name: 'DIST_FLAG' ,
			    	inputValue: '01',
			    	width:85
			    }, {boxLabel: '투입공수',
			    	name: 'DIST_FLAG',
			    	inputValue: '02',
			    	width:120
			    }]
			 },{
			    xtype: 'radiogroup',
			    fieldLabel: '원가계산내역관리',
			    id:'DELE_FLAG_SEARCH',
			    labelWidth:210,
			    readOnly:true,
			    items : [{
			    	boxLabel: '예',
			    	name: 'DELE_FLAG' ,
			    	inputValue: '01',
			    	width:85
			    }, {boxLabel: '아니오(이전계산내역삭제)',
			    	name: 'DELE_FLAG',
			    	inputValue: '02',
			    	width:160
			    }]
			 },{
			    xtype: 'radiogroup',
			    fieldLabel: '원가계산금액반영여부(수불정보)',
			    id:'APLY_FLAG_SEARCH',
			    labelWidth:210,
			    readOnly:true,
			    items : [{
			    	boxLabel: '반영함',
			    	name: 'APLY_FLAG' ,
			    	inputValue: '01',
			    	width:85
			    }, {boxLabel: '반영안함',
			    	name: 'APLY_FLAG',
			    	inputValue: '02',
			    	width:120
			    }]
			 },{
			    xtype: 'radiogroup',
			    fieldLabel: '원가수정여부(사업장별품목정보)',
			    id:'COST_FLAG_SEARCH',
			    labelWidth:210,
			    items : [{
			    	boxLabel: '반영함',
			    	name: 'COST_FLAG' ,
			    	inputValue: '01',
			    	width:85
			    }, {boxLabel: '반영안함',
			    	name: 'COST_FLAG',
			    	inputValue: '02',
			    	width:120
			    }]
			 }]
		}],
		setAllFieldsReadOnly: setAllFieldsReadOnly
	});
	
	var panelResult = Unilite.createSearchForm('resultForm',{
    	region: 'north',
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
		items: [{
	        	fieldLabel: '사업장',
	        	name: 'DIV_CODE',
	        	xtype: 'uniCombobox',
	        	comboType: 'BOR120',
	        	colspan:2,
	        	allowBlank: false,
	        	value: UserInfo.divCode,
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('DIV_CODE', newValue);
					}
				}
	        },{
			    xtype: 'radiogroup',
			    fieldLabel: '원가적용단가',
			    id:'UNIT_FLAG_RESULT',
			    labelWidth:210,
			    items : [{
			    	boxLabel: '총평균단가',
			    	name: 'UNIT_FLAG' ,
			    	inputValue: '02',
			    	width:85
			    }, {boxLabel: '기준단가',
			    	name: 'UNIT_FLAG',
			    	inputValue: '01',
			    	width:120
			    }]
	         },{ 
			    name: 'WORK_DATE',
	            fieldLabel: '작업년월', 
	            xtype: 'uniMonthfield',
	            colspan:2,
	            value:UniDate.get('startOfMonth'),
	            hidden: false, 
	            allowBlank:false, 
	            maxLength: 300,
	            listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('WORK_DATE', newValue);
					}
				}
	        },{
			    xtype: 'radiogroup',
			    fieldLabel: '계정별배부방법',
			    id:'ACNT_FLAG_RESULT',
			    labelWidth:210,
			    items : [{
			    	boxLabel: '계정별 배부',
			    	name: 'ACNT_FLAG' ,
			    	inputValue: '01',
			    	width:85
			    }, {boxLabel: '계정/부서별 배부 ',
			    	name: 'ACNT_FLAG',
			    	inputValue: '02',
			    	width:120
			    }]
			 },{
        		fieldLabel: '작업회수',
        		name:'WORK_SEQ_FR',
        		xtype:'uniNumberfield',
        		allowBlank:false, 
        		maxLength:3,
        		listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelSearch.setValue('WORK_SEQ_FR', newValue);
					}
				}
    		},{
        		fieldLabel: '/',
        		labelWidth:25,
        		name:'WORK_SEQ_TO',
        		xtype:'uniNumberfield',
        		readOnly:true,
        		listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('WORK_SEQ_TO', newValue);
					}
				}
    		},{
			    xtype: 'radiogroup',
			    fieldLabel: '간접비배부유형',
			    id:'DIST_FLAG_RESULT',
			    labelWidth:210,
			    items : [{
			    	boxLabel: '생산량',
			    	name: 'DIST_FLAG' ,
			    	inputValue: '01',
			    	width:85
			    }, {boxLabel: '투입공수',
			    	name: 'DIST_FLAG',
			    	inputValue: '02',
			    	width:120
			    }]
			 },{
	    		fieldLabel: '원가담당자',
	    		name: 'COST_PRSN',
	    		colspan:2,
	    		xtype: 'uniCombobox',
				comboType: 'AU', 
				comboCode: 'CD03',
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('COST_PRSN', newValue);
					}
				}
			},{
			    xtype: 'radiogroup',
			    fieldLabel: '원가계산내역관리',
			    id:'DELE_FLAG_RESULT',
			    labelWidth:210,
			    items : [{
			    	boxLabel: '예',
			    	name: 'DELE_FLAG' ,
			    	inputValue: '01',
			    	width:85
			    }, {boxLabel: '아니오(이전계산내역삭제)',
			    	name: 'DELE_FLAG',
			    	inputValue: '02',
			    	width:160
			    }]
			 },{
		         fieldLabel: '메시지 코드',
		         name: 'MSG_CODE', 
		         colspan:2,
		         xtype: 'uniCombobox', 
		         comboType: 'AU',
		         comboCode: 'CD12',
		         width: 300,
		         listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('MSG_CODE', newValue);
					}
				}
	         },{
			    xtype: 'radiogroup',
			    fieldLabel: '원가계산금액반영여부(수불정보)',
			    id:'APLY_FLAG_RESULT',
			    labelWidth:210,
			    items : [{
			    	boxLabel: '반영함',
			    	name: 'APLY_FLAG' ,
			    	inputValue: '01',
			    	width:85
			    }, {boxLabel: '반영안함',
			    	name: 'APLY_FLAG',
			    	inputValue: '02',
			    	width:120
			    }]
			 },{
		         fieldLabel: '유형',
		         name: 'MSG_TYPE',
		         colspan:2,
		         xtype: 'uniCombobox',
		         comboType: 'AU',
		         comboCode: 'CD13',
		         listeners: {
					change: function(field, newValue, oldValue, eOpts) {						
						panelSearch.setValue('MSG_TYPE', newValue);
					}
				 }
	         },{
			    xtype: 'radiogroup',
			    fieldLabel: '원가수정여부(사업장별품목정보)',
			    id:'COST_FLAG_RESULT',
			    labelWidth:210,
			    items : [{
			    	boxLabel: '반영함',
			    	name: 'COST_FLAG' ,
			    	inputValue: '01',
			    	width:85
			    }, {boxLabel: '반영안함',
			    	name: 'COST_FLAG',
			    	inputValue: '02',
			    	width:120
			    }]
			 }],
		setAllFieldsReadOnly: setAllFieldsReadOnly
    });
	
    var masterGrid = Unilite.createGrid('cdm300skrvGrid', {
        region : 'center',
        layout : 'fit',
        uniOpt: {
    		useLiveSearch      : true,
			useContextMenu     : true,
			useMultipleSorting : true,
			useRowNumberer     : false,
			expandLastColumn   : true,
			onLoadSelectFirst  : true,
    		filter: {
				useFilter: false,
				autoCreate: false
			}
        },
    	store: directMasterStore,
        columns: [  
        	{ dataIndex: 'MSG_CODE',    		width: 150},
        	{ dataIndex: 'MSG_TYPE',    		width: 100, align:'center'},
        	{ dataIndex: 'MSG_DESC',    		width: 240},
        	{ dataIndex: 'ACTION_MSG',    		width: 180},
        	{ dataIndex: 'PRG_INFO1',    		width: 250},
        	{ dataIndex: 'PRG_INFO2',    		width: 250,hidden:true},
        	{ dataIndex: 'MSG_ID',    			width: 100,hidden:true}
        ],
        listeners : {
	    	selectionchange: function( grid, selected, eOpts ) {
	    		if(selected.startCell){
	    			var record = selected.startCell.record.data;
	    			
		    		Ext.getCmp("TXT_MSG_DESC").setValue(record.MSG_DESC);
		    		Ext.getCmp("TXT_ACTION_MSG").setValue(record.ACTION_MSG);
		    		Ext.getCmp("TXT_PRG_INFO").setValue(record.PRG_INFO1);
	    		}else{
	    			
	    			Ext.getCmp("TXT_MSG_DESC").setValue("");
		    		Ext.getCmp("TXT_ACTION_MSG").setValue("");
		    		Ext.getCmp("TXT_PRG_INFO").setValue("");
	    		}
	    		
	    	}
	    }
    });
    
    var txtArea = { 	
        xtype : 'container',
        width : '30%',
		id:'txtArea',
		layout: {
        	type:'vbox',
        	align:'left'
        },
        region : 'east',
        margin : '0 5 0 5',
		items: [{
                text: '[메시지 설명]',
                xtype:'label'
            },{
                xtype:'textarea',
                name: 'TXT_MSG_DESC',
                id: 'TXT_MSG_DESC',
                readOnly:true,
                height: 192,
                width:'100%'
            },{
                text: '[조치 내역]',
                xtype:'label'
            },{
                xtype:'textarea',
                name: 'TXT_ACTION_MSG',
                id: 'TXT_ACTION_MSG',
                readOnly:true,
                height: 192,
                width:'100%'
            },{
                text: '[관련 프로그램]',
                xtype:'label'
            },{
                xtype:'textarea',
                name: 'TXT_PRG_INFO',
                id: 'TXT_PRG_INFO',
                readOnly:true,
                height: 192,
                width:'100%'
            }]
	}
    
    Unilite.Main( {
    	borderItems:[{
			region: 'center',
			layout: 'border',
			border: false,
			items:[
				masterGrid, panelResult, txtArea
			]
		},panelSearch],	
		id  : 'cdm300skrvApp',
		fnInitBinding : function() {
			panelSearch.setValue('DIV_CODE',UserInfo.divCode);
			panelResult.setValue('DIV_CODE',UserInfo.divCode);
			panelSearch.setValue('WORK_DATE',UniDate.get('startOfMonth'));
			panelResult.setValue('WORK_DATE',UniDate.get('startOfMonth'));
			panelSearch.setValue('WORK_SEQ_FR',0);
			panelResult.setValue('WORK_SEQ_FR',0);
			panelSearch.setValue('WORK_SEQ_TO',0);
			panelResult.setValue('WORK_SEQ_TO',0);
			
			panelSearch.setValue("UNIT_FLAG","02");
			panelSearch.setValue('DIST_FLAG',"01");
			panelSearch.setValue('ACNT_FLAG',"01");
			panelSearch.setValue('DELE_FLAG',"02");
			panelSearch.setValue('APLY_FLAG',"02");
			panelSearch.setValue('COST_FLAG',"02");
			
			panelResult.setValue('UNIT_FLAG',"02");
			panelResult.setValue('DIST_FLAG',"01");
			panelResult.setValue('ACNT_FLAG',"01");
			panelResult.setValue('DELE_FLAG',"02");
			panelResult.setValue('APLY_FLAG',"02");
			panelResult.setValue('COST_FLAG',"02");
			
			panelSearch.getField('UNIT_FLAG_SEARCH').setReadOnly(true);
			panelSearch.getField('DIST_FLAG_SEARCH').setReadOnly(true);
			panelSearch.getField('ACNT_FLAG_SEARCH').setReadOnly(true);
			panelSearch.getField('DELE_FLAG_SEARCH').setReadOnly(true);
			panelSearch.getField('APLY_FLAG_SEARCH').setReadOnly(true);
			panelSearch.getField('COST_FLAG_SEARCH').setReadOnly(true);
			
			panelResult.getField('UNIT_FLAG_RESULT').setReadOnly(true);
			panelResult.getField('DIST_FLAG_RESULT').setReadOnly(true);
			panelResult.getField('ACNT_FLAG_RESULT').setReadOnly(true);
			panelResult.getField('DELE_FLAG_RESULT').setReadOnly(true);
			panelResult.getField('APLY_FLAG_RESULT').setReadOnly(true);
			panelResult.getField('COST_FLAG_RESULT').setReadOnly(true);
			
			UniAppManager.setToolbarButtons('save',false);
			UniAppManager.setToolbarButtons('reset',true);
		},
		onQueryButtonDown : function(activeId)	{		
			if(!UniAppManager.app.checkForNewDetail()){
				return false;
			}else{
				masterGrid.getStore().loadStoreRecords();
			}
		},
		checkForNewDetail:function() { 			
			return panelSearch.setAllFieldsReadOnly(true);
        },
        onResetButtonDown:function() {
        	panelSearch.clearForm();
        	panelResult.clearForm();
        	masterGrid.reset();
        	masterGrid.getStore().clearData();
        	UniAppManager.app.fnInitBinding();
        }
	});
	
	function setAllFieldsReadOnly(b){
		var r= true
		if(b) {
			var invalid = this.getForm().getFields().filterBy(function(field) {
				if(field.name == 'WORK_SEQ_FR' && field.getValue() == 0){
					return false;
				}
				return !field.validate() ;
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
			}
  		} else {
			this.unmask();
		}
		return r;
	}
};
</script>