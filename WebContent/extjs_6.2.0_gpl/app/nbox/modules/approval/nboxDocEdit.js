/**************************************************
 * Common variable
 **************************************************/
var docEditPanelWidth = 680;
var docControlPanelWidth = 620;

/**************************************************
 * combo store
 **************************************************/
/* 보안등급 */
Ext.define('nbox.secureGradeStore', {
	extend: 'Ext.data.Store',
	fields: ["CODE", 'NAME'],
	
	autoLoad: true,
	proxy: {
        type: 'direct',
        extraParams: {MASTERID: 'NA04'},
        api: { read: 'nboxCommonService.selectCommonCode' },
        reader: {
            type: 'json',
            root: 'records'
        }
	}
	
});

/* 회사문서함*/
Ext.define('nbox.cabinetMenuStore', {
	extend: 'Ext.data.Store',
	fields: ["pgmID", 'pgmName'],
	
	autoLoad: true,
	proxy: {
		type: 'direct',
    	api: { read: 'nboxDocCommonService.selectCabinetItem' },
	    reader: {
	        type: 'json',
	        root: 'records'
    	}
	}
});

/* 수신자Combo */
Ext.define('nbox.inputRcvUserModel', {
    extend: 'Ext.data.Model',
    fields: [{name: 'CODE'}]
});

Ext.define('nbox.inputRcvUserStore', {
	extend: 'Ext.data.Store',
	model: 'nbox.docEditModel'
});




/**************************************************
 * Model
 **************************************************/
//Detail Edit
Ext.define('nbox.docEditModel', {
    extend: 'Ext.data.Model',
    fields: [
    	{name: 'DocumentID'}, 
    	{name: 'CompanyID'},
    	{name: 'DraftUserID'}, 
    	{name: 'DraftUserName'},
    	{name: 'DraftDeptName'},
    	{name: 'DraftUserPos'},
    	{name: 'Subject'},
    	{name: 'Contents'},
    	{name: 'ViewContents'},
    	{name: 'DocumentNo'},
    	{name: 'DraftDate', type: 'date', dateFormat:'Y-m-d H:i:s'},
    	{name: 'MultiType'},
    	{name: 'Status'},
    	{name: 'FormID'},
    	{name: 'FormName'},
    	{name: 'Slogan1'},
    	{name: 'DraftFlag'},
    	{name: 'CurrentStatus'},
    	{name: 'CurrentSignFlag'},
    	{name: 'NextSignFlag'},
    	{name: 'NextSignedFlag'},
    	{name: 'DoubleLineFirstFlag'},
    	{name: 'SecureGrade'},
    	{name: 'CabinetID'},
    	{name: 'InnerApprovalFlag'},
    	{name: 'InputRcvUser'},
    	{name: 'InputRcvFlag'},
    	{name: 'InputRefUser'},
    	{name: 'InputRefFlag'},
    	{name: 'OpenFlag'}
    ]
});

/**************************************************
 * Store
 **************************************************/
Ext.define('nbox.docEditStore', {
	extend: 'Ext.data.Store',
	model: 'nbox.docEditModel',
	autoLoad: false,
	proxy: {
        type: 'direct',
        api: { 
        	read: 'nboxDocListService.select'
        },
        reader: {
            type: 'json',
            root: 'records'
        }
    }
});


/**************************************************
 * Define
 **************************************************/
Ext.define('nbox.docEditExpandCollapseImg', {
	extend: 'Ext.Img',
	config: {
		regItems: {}
	},
	
	title: 'Expand/Collapse',
	src: NBOX_IMAGE_PATH + 'btn_close.gif',
	
	width: 30,
	height: 23,
	
	style: {
	   	'cursor': 'pointer'
	},
	listeners: {
		el: {
			click: function() {
				var me = this;
				var nboxDocEditExpandCollapseImg = Ext.getCmp('nboxDocEditExpandCollapseImg');
				
				if (nboxDocEditExpandCollapseImg)
					nboxDocEditExpandCollapseImg.onElClick();
			}
		}
	},
	onElClick: function(){
		var me = this;
		
		var nboxDocEditExpandCollapsePanel = Ext.getCmp('nboxDocEditExpandCollapsePanel');
		
		if (me.el.dom.src.indexOf("btn_open") >= 0){
			me.setSrc(NBOX_IMAGE_PATH + 'btn_close.gif');
			nboxDocEditExpandCollapsePanel.show();
		} else {
			me.setSrc(NBOX_IMAGE_PATH + 'btn_open.gif');
			nboxDocEditExpandCollapsePanel.hide();
       	}
	}
});

Ext.define('nbox.docEditExpandCollapsePanel',{
	extend: 'Ext.panel.Panel',
	config: {
    	regItems: {}
    },
    
    layout: {
		type: 'vbox'
	},
	
	border: false,
	hidden: false,
	
	initComponent: function () {
		var me = this;

		var nboxSecureGradeStore = Ext.create('nbox.secureGradeStore', {
			id:'nboxSecureGradeStore'
		});
		var nboxCabinetMenuStore = Ext.create('nbox.cabinetMenuStore', {
			id:'nboxCabinetMenuStore'
		});
		
		var nboxDocEditInnerFlagCheckBox = Ext.create('nbox.docEditInnerFlagCheckBox', {
			id: 'nboxDocEditInnerFlagCheckBox',
			style : {
				paddingLeft: '105px'
			}
		})
		
		var docEditTempPanel1 = Ext.create('Ext.panel.Panel', { 
        	layout: {
				type: 'table' ,
				columns: 3,
				tdAttrs:{
					style: {
					 	'padding': '5px 0px 0px 0px'
				   	}
				} 
			},
			
			border: false,
			defaultType: 'textfield',
			items: [
			    nboxDocEditInnerFlagCheckBox,
				{ 
					xtype: 'combo', 
					id: 'DocEditSecureGrade',
					name:'SecureGrade',
					fieldLabel: '공개/비공개', 
					labelStyle: 'width:90px',
					store: nboxSecureGradeStore, 
					displayField:'NAME', 
					valueField: 'CODE', 
					labelAlign : 'right',
					labelClsExtra: 'required_field_label',
					allowBlank:false,
					width: 200
				}, 
				{ 
					xtype: 'combo', 
					id: 'DocEditCabinetID',
					name:'CabinetID',
					fieldLabel: '문서함', 
					labelStyle: 'width:65px',
					store: nboxCabinetMenuStore, 
					displayField:'pgmName', 
					valueField: 'pgmID', 
					labelAlign : 'right',
					labelClsExtra: 'required_field_label',
					allowBlank:false,
					width: 280
				}
			]
        });		
		
		var nboxDocEditRcvUserPanel = Ext.create('nbox.docEditRcvUserPanel', {
			id:'nboxDocEditRcvUserPanel',
			hidden : true
		});
		var nboxDocEditRefUserPanel = Ext.create('nbox.docEditRefUserPanel', {
			id:'nboxDocEditRefUserPanel',
			hidden : true
		});
		var nboxDocEditBasisPanel = Ext.create('nbox.docEditBasisPanel', {
			id: 'nboxDocEditBasisPanel'
		});
		
		me.items = [docEditTempPanel1, nboxDocEditRcvUserPanel, nboxDocEditRefUserPanel, nboxDocEditBasisPanel] ;
		me.callParent();
	},
	queryData: function(){
		var me = this;

		var nboxDocEditRcvUserPanel = Ext.getCmp('nboxDocEditRcvUserPanel');
		var nboxDocEditRefUserPanel = Ext.getCmp('nboxDocEditRefUserPanel');
		var nboxDocEditBasisPanel = Ext.getCmp('nboxDocEditBasisPanel');
		
		if (nboxDocEditRcvUserPanel)
			nboxDocEditRcvUserPanel.queryData();
		if (nboxDocEditRefUserPanel)
			nboxDocEditRefUserPanel.queryData();
		if (nboxDocEditBasisPanel)
			nboxDocEditBasisPanel.queryData();
	},
	clearData: function(){
		var me = this;

		var nboxDocEditRcvUserPanel = Ext.getCmp('nboxDocEditRcvUserPanel');
		var nboxDocEditRefUserPanel = Ext.getCmp('nboxDocEditRefUserPanel');
		var nboxDocEditBasisPanel = Ext.getCmp('nboxDocEditBasisPanel');
		
		if (nboxDocEditRcvUserPanel)
			nboxDocEditRcvUserPanel.clearData();
		if (nboxDocEditRefUserPanel)
			nboxDocEditRefUserPanel.clearData();
		if (nboxDocEditBasisPanel)
			nboxDocEditBasisPanel.clearData();
	}
});

Ext.define('nbox.docSubjectPanel',{
	extend: 'Ext.panel.Panel',
	
	config: {
    	regItems: {}
    },
    
    layout: {
		type: 'hbox'
	},    
	padding: '5px 0px 0px 0px',
	border: false,
	defaultType: 'textfield',
	width: 660,
    initComponent: function () {
    	var me = this;
    	
    	var title = { 
    			id: 'nboxDocSubjectTextfield',
    			name: 'Subject',
    			fieldLabel: '제목',
    			labelAlign : 'right',
    			labelClsExtra: 'required_field_label',
    			width: docControlPanelWidth,
    			allowBlank:false
    		};
    		
		var nboxDocEditExpandCollapseImg = Ext.create('nbox.docEditExpandCollapseImg',{
			id: 'nboxDocEditExpandCollapseImg',
			style: {
	            paddingLeft: '3px'
	        }
		});
		
		me.items = [title, nboxDocEditExpandCollapseImg	];
		
		me.callParent();
    },
    queryData: function(){
    	var me = this;
    },
    clearData: function(){
    	var me = this;
    	
    }
});

Ext.define('nbox.docInputRcvPanel',{
	extend: 'Ext.panel.Panel',
	
	config: {
    	regItems: {}
    },
    
    layout: {
		type: 'hbox'
	},    
	padding: '5px 0px 0px 0px',
	border: false,
	defaultType: 'textfield',
	width: 660,
    initComponent: function () {
    	var me = this;
    	/*
    	var nboxDocInputRcvTextfield = { 
    			id: 'nboxDocInputRcvTextfield',
    			name: 'InputRcvUser',
    			fieldLabel: '수신자입력',
    			labelAlign : 'right',
    			width: docControlPanelWidth,
    			disabled: true
    		};
    	*/
    	
    	var nboxInputRcvUserStore = Ext.create('nbox.inputRcvUserStore',{
    		id: 'nboxInputRcvUserStore'
    	});
    	
    	var nboxDocInputRcvCombo = {
	    	xtype: 'combo', 
			id: 'nboxDocInputRcvCombo',
			name:'InputRcvUser',
			fieldLabel: '수신자 입력', 
			store : nboxInputRcvUserStore,
			displayField:'CODE', 
			valueField: 'CODE', 
			labelAlign : 'right',
			width : 650
    	};
    	
    	
    	var nboxDocInputRcvFlagAddButton = Ext.create('nbox.docInputRcvFlagAddButton',{
			id: 'nboxDocInputRcvFlagAddButton',
			style: {
				marginLeft: '10px'
	        }
		});
    	
    	var nboxDocInputRcvFlagDelButton = Ext.create('nbox.docInputRcvFlagDelButton',{
			id: 'nboxDocInputRcvFlagDelButton',
			style: {
				marginLeft: '5px'
	        }
		});
    		
		
		me.items = [nboxDocInputRcvCombo, nboxDocInputRcvFlagAddButton, nboxDocInputRcvFlagDelButton];
		
		me.callParent();
    },
    queryData: function(){
    	var me = this;
    },
    clearData: function(){
    	var me = this;
    	var nboxDocInputRcvCombo = Ext.getCmp('nboxDocInputRcvCombo');
    	var comboStore = nboxDocInputRcvCombo.getStore();
    	
    	if (nboxDocInputRcvCombo){
    		comboStore.loadData([],false);
    		comboStore.commitChanges();
    	}
    },
	loadPanel: function(){
    	var me = this;
    	var nboxDocInputRcvCombo = Ext.getCmp('nboxDocInputRcvCombo');
    	var comboStore = nboxDocInputRcvCombo.getStore();
    	var tempData = null;
    	var tempArray = null;
    	
    	me.clearData();
    	
    	var nboxDocEditPanel = Ext.getCmp('nboxDocEditPanel');
    	var editPanelStore = null
    	
		if (nboxDocEditPanel)
   		{
    		editPanelStore = nboxDocEditPanel.getStore();
   			
	    	if (editPanelStore)
			{
	    		if (editPanelStore.getCount() > 0)
				{
	    			if (nboxDocInputRcvCombo)
					{
	    				tempData = editPanelStore.getAt(0).get('InputRcvUser');
                        
						if (tempData && tempData.length){
							tempArray = tempData.split(';');
							
							if (tempArray.length){
								for(var indx in tempArray) {
									comboStore.insert(0,[{'CODE':tempArray[indx]}]);
								}
								comboStore.commitChanges();
								nboxDocInputRcvCombo.setValue("");
							}
						}
	    				
					}
				}
			}
    	}
	}
});

Ext.define('nbox.docInputRefPanel',{
	extend: 'Ext.panel.Panel',
	config: {
    	regItems: {}
    },
    
    layout: {
		type: 'hbox'
	},    
	padding: '5px 0px 0px 0px',
	border: false,
	defaultType: 'textfield',
	width: 660,
    initComponent: function () {
    	var me = this;
    	
    	var nboxDocInputRefTextfield = { 
    			id: 'nboxDocInputRefTextfield',
    			name: 'InputRefUser',
    			fieldLabel: '참조자입력',
    			labelAlign : 'right',
    			width: docControlPanelWidth,
    			disabled: true
    		};
    	
    	
    	var nboxDocInputRefFlagCheckbox = Ext.create('nbox.docInputRefFlagCheckbox',{
			id: 'nboxDocInputRefFlagCheckbox',
			style: {
	            paddingLeft: '10px'
	        }
		});
    		
		
		me.items = [nboxDocInputRefTextfield, nboxDocInputRefFlagCheckbox];
		
		me.callParent();
    },
    queryData: function(){
    	var me = this;
    },
    clearData: function(){
    	var me = this;
    	var nboxDocInputRefFlagCheckbox = Ext.getCmp('nboxDocInputRefFlagCheckbox');
    	
    	if (nboxDocInputRefFlagCheckbox)
    		nboxDocInputRefFlagCheckbox.clearData();
    }
});


Ext.define('nbox.docOptionalPanel',{
	extend: 'Ext.panel.Panel',
	
	config: {
    	regItems: {}
    },
    
    layout: {
		type: 'hbox'
	},    
	padding: '5px 0px 0px 0px',
	border: false,
	width: 660,
    initComponent: function () {
    	var me = this;
    	
    	/*
    	var nboxDocEditInnerFlagCheckBox = Ext.create('nbox.docEditInnerFlagCheckBox', {
			id: 'nboxDocEditInnerFlagCheckBox',
			style : {
				paddingLeft: '120px'
			}
		})
		*/
		var nboxDocOpenFlagRadiogroup = {
            xtype      : 'radiogroup',
            id         : 'nboxDocOpenFlagRadiogroup',
            defaultType: 'radiofield',
            layout: 'hbox',
			style : {
				paddingLeft: '30px'
			},
            items: [
                {
                    boxLabel  : '비공개',
                    name      : 'OpenFlag',
                    inputValue: '0',
                    checked   : true
                }, {
                    boxLabel  : '공개',
                    name      : 'OpenFlag',
                    inputValue: '1',
                    checked   : false,
                    style : {
        				paddingLeft: '5px'
        			},
                }
            ]
        };
    		
		
		me.items = [nboxDocOpenFlagRadiogroup];
		
		me.callParent();
    },
    queryData: function(){
    	var me = this;
    },
    clearData: function(){
    	var me = this;
    }
});


Ext.define('nbox.docEditInnerFlagCheckBox',{
	extend: 'Ext.form.field.Checkbox',
	boxLabel:'내부결재',
	name: 'InnerApprovalFlag',
	inputValue: "1",
	checked   : false,
	listeners: {
		change : function(chkbox, newValue, oldValue, eOpts){ 
        	
        	var nboxDocInputRcvCombo = Ext.getCmp('nboxDocInputRcvCombo');
        	var nboxDocInputRcvFlagAddButton = Ext.getCmp('nboxDocInputRcvFlagAddButton');
        	var nboxDocInputRcvFlagDelButton = Ext.getCmp('nboxDocInputRcvFlagDelButton');
        	var comboStore = null;
        	
        	if (newValue == true){
        		if (nboxDocInputRcvCombo){
        			comboStore = nboxDocInputRcvCombo.getStore();
        			if (comboStore){
        				comboStore.loadData([],false);
        				nboxDocInputRcvCombo.setValue("내부결재");
            			comboStore.insert(0,[{'CODE':nboxDocInputRcvCombo.getValue()}]);
        				comboStore.commitChanges();
        				nboxDocInputRcvCombo.setValue("내부결재");
        				nboxDocInputRcvCombo.setDisabled(true);
        				nboxDocInputRcvFlagAddButton.setDisabled(true);
        				nboxDocInputRcvFlagDelButton.setDisabled(true);
        			}
        		}	
    		}
    		else{
    			if (nboxDocInputRcvCombo){
        			comboStore = nboxDocInputRcvCombo.getStore();
        			if (comboStore){
        				comboStore.loadData([],false);
        				comboStore.commitChanges();
        				nboxDocInputRcvCombo.setValue("");
        				nboxDocInputRcvCombo.setDisabled(false);
        				nboxDocInputRcvFlagAddButton.setDisabled(false);
        				nboxDocInputRcvFlagDelButton.setDisabled(false);
        			}
        			
        		}
    		}
        }
	},
    queryData: function(){
    	var me = this;
    },
    clearData: function(){
    	var me = this;
    	
    	me.setValue(false);
    }
});

/*
Ext.define('nbox.docInputRcvFlagCheckbox',{
	extend: 'Ext.form.field.Checkbox',
	boxLabel:'사용',
	name: 'InputRcvFlag',
	inputValue: 1,
	checked   : false,
	listeners: {
		change : function(chkbox, newValue, oldValue, eOpts){ 
        	var nboxDocInputRcvTextfield = Ext.getCmp('nboxDocInputRcvTextfield');
        	var nboxDocEditRcvUserPanel = Ext.getCmp('nboxDocEditRcvUserPanel');
        	
        	if (newValue == true){
        		if (nboxDocInputRcvTextfield){
        			nboxDocEditRcvUserPanel.clearData();
        			nboxDocInputRcvTextfield.setDisabled(false);
        			nboxDocInputRcvTextfield.focus();
        		}
        	}
        	else{
        		if (nboxDocInputRcvTextfield){
       				nboxDocInputRcvTextfield.setValue("");
       				nboxDocInputRcvTextfield.setDisabled(true);
        		}
        	}
        }
	},
    queryData: function(){
    	var me = this;
    },
    clearData: function(){
    	var me = this;
    	
    	me.setValue(false);
    }
});
*/

Ext.define('nbox.docInputRcvFlagAddButton',{
	extend : 'Ext.Button',
    text: '추가',
    handler: function() {
    	var comboStore = null;
    	var nboxDocInputRcvCombo = Ext.getCmp('nboxDocInputRcvCombo');
    	
    	if (nboxDocInputRcvCombo){
    		comboStore = nboxDocInputRcvCombo.getStore();
    		if (comboStore){
    			if (nboxDocInputRcvCombo.getValue()){
    				comboStore.insert(0,[{'CODE':nboxDocInputRcvCombo.getValue()}]);
    				comboStore.commitChanges();
    				nboxDocInputRcvCombo.setValue('');
    				nboxDocInputRcvCombo.expand();
    				nboxDocInputRcvCombo.focus();
    			}
    		}
    	}
    }

});

Ext.define('nbox.docInputRcvFlagDelButton',{
	extend : 'Ext.Button',
    text: '삭제',
    handler: function() {
    	var comboStore = null;
    	var nboxDocInputRcvCombo = Ext.getCmp('nboxDocInputRcvCombo');
    	
    	if (nboxDocInputRcvCombo){
    		comboStore = nboxDocInputRcvCombo.getStore();
    		if (comboStore){
    			if (nboxDocInputRcvCombo.getValue()){
	    			var selectedValue = nboxDocInputRcvCombo.getValue();
	    			var record = nboxDocInputRcvCombo.findRecord(nboxDocInputRcvCombo.valueField || nboxDocInputRcvCombo.displayField, selectedValue);
	    			var index = comboStore.indexOf(record);
	    			comboStore.removeAt(index);
	    			comboStore.commitChanges();
	    			nboxDocInputRcvCombo.setValue('');
					nboxDocInputRcvCombo.expand();
					nboxDocInputRcvCombo.focus();
    			}
    		}
    	}
    }

});

Ext.define('nbox.docInputRefFlagCheckbox',{
	extend: 'Ext.form.field.Checkbox',
	boxLabel:'사용',
	name: 'InputRefFlag',
	inputValue: 1,
	checked   : false,
	listeners: {
		change : function(chkbox, newValue, oldValue, eOpts){ 
			var nboxDocInputRefTextfield = Ext.getCmp('nboxDocInputRefTextfield');
			var nboxDocEditRefUserPanel = Ext.getCmp('nboxDocEditRefUserPanel');
        	
        	if (newValue == true){
        		if (nboxDocInputRefTextfield){
        			nboxDocEditRefUserPanel.clearData();
        			nboxDocInputRefTextfield.setDisabled(false);
        			nboxDocInputRefTextfield.focus();
        		}
        	}
        	else{
        		if (nboxDocInputRefTextfield){
       				nboxDocInputRefTextfield.setValue("");
       				nboxDocInputRefTextfield.setDisabled(true);
        		}
        	}
        }
	},
    queryData: function(){
    	var me = this;
    },
    clearData: function(){
    	var me = this;
    	
    	me.setValue(false);
    }
});

Ext.define('nbox.docEditFormComboPanel',{
	extend: 'Ext.panel.Panel',
	config: {
    	regItems: {}
    },
    layout:{
    	type: 'hbox'
    },
    border: false,
    padding: '5px 0px 0px 0px',
    width: 660,
    initComponent: function () {
    	var me = this;

    	var nboxDocEditFormStore = Ext.create('nbox.docEditFormStore',{
			id: 'nboxDocEditFormStore'
		});
    	var nboxDocEditFormCombo = Ext.create('nbox.docEditFormCombo',{
    		id: 'nboxDocEditFormCombo',
			store: nboxDocEditFormStore
		});
    			
		me.items = [nboxDocEditFormCombo];
		
		me.callParent();
    },
    queryData: function(){
    	var me = this;
    	var nboxDocEditFormCombo = Ext.getCmp('nboxDocEditFormCombo');
    	var nboxDocEditExpandCollapsePanel = Ext.getCmp('nboxDocEditExpandCollapsePanel');
    	
    	if (nboxDocEditFormCombo)
    		nboxDocEditFormCombo.queryData();
    	if (nboxDocEditExpandCollapsePanel)
    		nboxDocEditExpandCollapsePanel.queryData();
    },
    clearData: function(){
    	var me = this;
    	var nboxDocEditFormCombo = Ext.getCmp('nboxDocEditFormCombo');
    	
    	if (nboxDocEditFormCombo)
    		nboxDocEditFormCombo.clearData();
    }
});

Ext.define('nbox.docEditNorthPanel',{
	extend: 'Ext.panel.Panel',
	config: {
    	regItems: {}
    },
    layout: {
		type: 'vbox',
		align: 'stretch'
	},
	
	border: false,

	initComponent: function () {
		var me = this;
		
		var nboxDocEditLinePanel = Ext.create('nbox.docEditLinePanel', {
			id:'nboxDocEditLinePanel'
		});
		
		var nboxDocOptionalPanel = Ext.create('nbox.docOptionalPanel', {
			id:'nboxDocOptionalPanel',
			hidden: true
		});
		
		
    	var nboxDocEditFormComboPanel = Ext.create('nbox.docEditFormComboPanel',{
    		id: 'nboxDocEditFormComboPanel'
		});
    	
    	var nboxDocInputRcvPanel = Ext.create('nbox.docInputRcvPanel',{
    		id: 'nboxDocInputRcvPanel'
		});

    	var nboxDocInputRefPanel = Ext.create('nbox.docInputRefPanel',{
    		id: 'nboxDocInputRefPanel',
    		hidden : true    			
		});
    	
    	var nboxDocSubjectPanel = Ext.create('nbox.docSubjectPanel', {
    		id: 'nboxDocSubjectPanel'
    	});
    	
    	var nboxDocEditExpandCollapsePanel = Ext.create('nbox.docEditExpandCollapsePanel', {
    		id: 'nboxDocEditExpandCollapsePanel'
    	});
		
    	var nboxDocEditLinkDataStore = Ext.create('nbox.docEditLinkDataStore',{
    		id: 'nboxDocEditLinkDataStore'
    	});
    	
    	var nboxDocEditLinkDataPanel = Ext.create('nbox.docEditLinkDataPanel',{
    		id: 'nboxDocEditLinkDataPanel',
    		store: nboxDocEditLinkDataStore
    	});
    	
    	var nboxDocEditContentsPanel =  Ext.create('nbox.docEditContentsPanel', {
    		id: 'nboxDocEditContentsPanel'
	    });  
		
		me.items = [nboxDocEditLinePanel, nboxDocOptionalPanel, nboxDocEditFormComboPanel, 
		            nboxDocInputRcvPanel, nboxDocInputRefPanel, nboxDocSubjectPanel, 
		            nboxDocEditExpandCollapsePanel, nboxDocEditLinkDataPanel, nboxDocEditContentsPanel];
		
		me.callParent();
	},
	queryData: function(){
		var me = this;

		var nboxDocEditLinePanel = Ext.getCmp('nboxDocEditLinePanel');
		var nboxDocEditFormComboPanel = Ext.getCmp('nboxDocEditFormComboPanel');
		var nboxDocInputRcvPanel = Ext.getCmp('nboxDocInputRcvPanel');
		var nboxDocInputRefPanel = Ext.getCmp('nboxDocInputRefPanel');
		var nboxDocSubjectPanel = Ext.getCmp('nboxDocSubjectPanel');
		var nboxDocEditExpandCollapsePanel = Ext.getCmp('nboxDocEditExpandCollapsePanel');
		var nboxDocEditLinkDataPanel = Ext.getCmp('nboxDocEditLinkDataPanel');
		var nboxDocEditContentsPanel = Ext.getCmp('nboxDocEditContentsPanel');
		
		if (nboxDocEditLinePanel)
			nboxDocEditLinePanel.queryData();
		if (nboxDocEditFormComboPanel)
			nboxDocEditFormComboPanel.queryData();
		if (nboxDocInputRcvPanel)
			nboxDocInputRcvPanel.queryData();
		if (nboxDocInputRefPanel)
			nboxDocInputRefPanel.queryData();
		if (nboxDocSubjectPanel)
			nboxDocSubjectPanel.queryData();
		if (nboxDocEditExpandCollapsePanel)
			nboxDocEditExpandCollapsePanel.queryData();
		//if (nboxDocEditLinkDataPanel)
		//	nboxDocEditLinkDataPanel.queryData();
		if (nboxDocEditContentsPanel)
			nboxDocEditContentsPanel.queryData();
	},
	clearData: function(){
		var me = this;
		
		var nboxDocEditLinePanel = Ext.getCmp('nboxDocEditLinePanel');
		var nboxDocEditFormComboPanel = Ext.getCmp('nboxDocEditFormComboPanel');
		var nboxDocInputRcvPanel = Ext.getCmp('nboxDocInputRcvPanel');
		var nboxDocInputRefPanel = Ext.getCmp('nboxDocInputRefPanel');
		var nboxDocSubjectPanel = Ext.getCmp('nboxDocSubjectPanel');
		var nboxDocEditExpandCollapsePanel = Ext.getCmp('nboxDocEditExpandCollapsePanel');
		var nboxDocEditLinkDataPanel = Ext.getCmp('nboxDocEditLinkDataPanel');
		var nboxDocEditContentsPanel = Ext.getCmp('nboxDocEditContentsPanel');
		
		
		if (nboxDocEditLinePanel)
			nboxDocEditLinePanel.clearData();
		if (nboxDocEditFormComboPanel)
			nboxDocEditFormComboPanel.clearData();
		if (nboxDocInputRcvPanel)
			nboxDocInputRcvPanel.clearData();
		if (nboxDocInputRefPanel)
			nboxDocInputRefPanel.clearData();
		if (nboxDocSubjectPanel)
			nboxDocSubjectPanel.clearData();
		if (nboxDocEditExpandCollapsePanel)
			nboxDocEditExpandCollapsePanel.clearData();
		if (nboxDocEditLinkDataPanel)
			nboxDocEditLinkDataPanel.clearData();
		if (nboxDocEditContentsPanel)
			nboxDocEditContentsPanel.clearData();
	},
	loadPanel: function(){
    	var me = this;
    	var nboxDocEditContentsPanel = Ext.getCmp('nboxDocEditContentsPanel');
    	
    	if (nboxDocEditContentsPanel)
    	{
    		nboxDocEditContentsPanel.loadPanel();
    	}
    	
    	var nboxDocInputRcvPanel = Ext.getCmp('nboxDocInputRcvPanel');
    	
    	if (nboxDocInputRcvPanel){
    		nboxDocInputRcvPanel.loadPanel();
    	}		
    }
});

Ext.define('nbox.docEditSouthPanel',{
	extend: 'Ext.panel.Panel',
	config: {
		regItems: {}
	},
	
	layout: {
		type: 'fit'
	},
	
	border: false,
	
	initComponent: function () {
		var me = this;

		var nboxDocEditFilePanel = Ext.create('nbox.docEditFilePanel', {
    		id: 'nboxDocEditFilePanel'
    	});
		
		me.items = [nboxDocEditFilePanel];
		me.callParent();
	},
	queryData: function(){
		var me = this;
		var nboxDocEditFilePanel = Ext.getCmp('nboxDocEditFilePanel');
		
		if (nboxDocEditFilePanel)
			nboxDocEditFilePanel.queryData();
	},
	clearData: function(){
		var me = this;
		var nboxDocEditFilePanel = Ext.getCmp('nboxDocEditFilePanel');
		
		if (nboxDocEditFilePanel)
			nboxDocEditFilePanel.clearData();
	}
});

// Detail Edit Panel
Ext.define('nbox.docEditPanel', {
	extend: 'Ext.form.Panel',
	config: {
		store: null,
    	regItems: {}
    },
    
    layout: {
    	type: 'anchor'
    },
    
    border: false,
    flex: 1,
    width: docEditPanelWidth,
    
	api: { submit: 'nboxDocListService.save' },
	initComponent: function () {
		var me = this;

		var docEditNorthPanel = Ext.create('nbox.docEditNorthPanel',{
			id: 'nboxDocEditNorthPanel',
			region:'north',
			anchor: '100% 80%'
		})

		var docEditSouthPanel = Ext.create('nbox.docEditSouthPanel',{
			id: 'nboxDocEditSouthPanel',
			region:'south',
			anchor: '100% 20%'
		});
		
		me.items = [docEditNorthPanel, docEditSouthPanel];
		
  		me.callParent();
	},
	queryData: function(){
    	var me = this;
    	var nboxBaseApp = Ext.getCmp('nboxBaseApp');
    	var nboxDocEditNorthPanel = Ext.getCmp('nboxDocEditNorthPanel');
    	var nboxDocEditSouthPanel = Ext.getCmp('nboxDocEditSouthPanel');
    	
    	me.clearData();
    	
    	if (nboxBaseApp){
	    	switch (nboxBaseApp.getActionType()){
				case NBOX_C_CREATE:
					
					break;
				case NBOX_C_UPDATE:
					
					var store = me.getStore();
					var documentID = nboxBaseApp.getDocumentID();
					
					store.proxy.setExtraParam('DocumentID', documentID);
		   			store.load({
		       			callback: function(records, operation, success) {
		       				if (success){
		       					me.loadPanel();
		       				}
		       			}
		   			});
		   			
					break;
				default:
					break;
			}
    	}
    	
    	if (nboxDocEditNorthPanel)
    		nboxDocEditNorthPanel.queryData();
    	if (nboxDocEditSouthPanel)
    		nboxDocEditSouthPanel.queryData();
	},	
	newData: function(){
		var me = this;
		
		me.clearData();
	},
	saveData: function(){
		var me = this;
    	var documentID = null;
    	var editorContents = null;
    	var interfaceKey = null;
    	var gubun = null;
    	var formID = null;
    	var addFiles = null;
    	var delFiles = null;
    	var doclines = null;
    	var rcvusers = null;
    	var refusers = null;
    	var docbasis = null;
    	var innerApprovalFlag = null;
    	var inputRcvUsers = null;
    	var inputRcvFlag = null;
    	var inputRefUsers = null;
    	var inputRefFlag = null;
    	var OpenFlag = null;
    	
    	var nboxBaseApp = Ext.getCmp('nboxBaseApp');
    	
    	if (nboxBaseApp){
	    	interfaceKey = nboxBaseApp.getInterfaceKey();
	    	gubun = nboxBaseApp.getGubun();
	    	
	    	if (nboxBaseApp.getActionType() == NBOX_C_UPDATE)
	    		documentID = nboxBaseApp.getDocumentID();
    	}

    	var isNew = (documentID == "" || documentID == null);
    	
    	var nboxDocEditFormCombo = Ext.getCmp('nboxDocEditFormCombo');
    	if (nboxDocEditFormCombo)
    		formID = nboxDocEditFormCombo.getValue(); 
    	
    	var docEditContentsHtmlEditor = Ext.getCmp('nboxDocEditContentsPanel').items.items[0];
    	if (docEditContentsHtmlEditor.name == "nboxCkeditor" )
    		editorContents = docEditContentsHtmlEditor.getValue()    	
		
    	var nboxDocEditFilePanel = Ext.getCmp('nboxDocEditFilePanel');
    	if (nboxDocEditFilePanel){
			addFiles = nboxDocEditFilePanel.getAddFiles();
			delFiles = nboxDocEditFilePanel.getRemoveFiles();
    	}
		
		var linkdatalist = [];
		var columns = ['id','value','rawValue'];
		var nboxDocEditLinkDataPanel =  Ext.getCmp('nboxDocEditLinkDataPanel');
		if (nboxDocEditLinkDataPanel){
			Ext.each(nboxDocEditLinkDataPanel.items.items,function(item){
				linkdatalist.push(me.JSONtoString(item,columns));
			});
		}
		
		if (linkdatalist.length == 0) linkdatalist = null;
		
		var nboxDocEditLineView = Ext.getCmp('nboxDocEditLineView');
		var nboxDocEditRcvUserView = Ext.getCmp('nboxDocEditRcvUserView');
    	var nboxDocEditRefUserView = Ext.getCmp('nboxDocEditRefUserView');
    	var nboxDocEditBasisView   = Ext.getCmp('nboxDocEditBasisView');
    	
		var doclinelist = [];
		
		if (nboxDocEditLineView){
			doclines = nboxDocEditLineView.getStore().data.items;
			if (doclines){
				Ext.each(doclines,function(record){
					doclinelist.push(me.JSONtoString(record.data));
				});
			}
		}
		
		var rcvuserlist = []; 
		if (nboxDocEditRcvUserView){
			rcvusers = nboxDocEditRcvUserView.getStore().data.items;
			if (rcvusers){
				Ext.each(rcvusers,function(record){
					rcvuserlist.push(me.JSONtoString(record.data));
				});
			}
		}
		
		var nboxDocInputRcvCombo = Ext.getCmp('nboxDocInputRcvCombo');
		
		var inputRcvuserlist = [];
		if (nboxDocInputRcvCombo){
			inputRcvUsers = nboxDocInputRcvCombo.getStore().data.items;
			if (inputRcvUsers){
				Ext.each(inputRcvUsers,function(record){
					inputRcvuserlist.push(me.JSONtoString(record.data));
				});
			}
		}
		
		var refuserlist = []; 
		if (nboxDocEditRefUserView){
			refusers = nboxDocEditRefUserView.getStore().data.items;
			if (refusers){
				Ext.each(refusers,function(record){
					refuserlist.push(me.JSONtoString(record.data));
				});
			}
		}
		
		var docbasilist = []; 
		if (nboxDocEditBasisView){
			docbasis = nboxDocEditBasisView.getStore().data.items;
			if (docbasis){
				Ext.each(docbasis,function(record){
					docbasilist.push(me.JSONtoString(record.data));
				});
			}
		}
		
		
		if (addFiles.length == 0) addFiles = null;
		if (delFiles.length == 0) delFiles = null;
		
		if (doclinelist.length == 0) doclinelist = null;
		if (rcvuserlist.length == 0) rcvuserlist = null;
		if (inputRcvuserlist.length == 0) inputRcvuserlist = null;
		if (refuserlist.length == 0) refuserlist = null;
		if (docbasilist.length == 0) docbasilist = null;
		
		var param = {
			 'DocumentID'       : documentID, 
		     'FormID'           : formID, 
		     'Status'           : 'A', 
		     'EditorContents'   : editorContents,
		     'InterfaceKey'     : interfaceKey,
		     'Gubun'            : gubun,
		     'ADDFID'           : addFiles,
		     'DELFID'           : delFiles,
		     'DOCLINES'         : doclinelist,
		     'RCVUSERS'         : rcvuserlist,
		     'REFUSERS'         : refuserlist,
		     'DOCBASISS'        : docbasilist,
		     'LINKDATA'         : linkdatalist,
		     'EXPENSEADD'       : inputRcvuserlist,
		     'EXPENSEUPD'       : null,
		     'EXPENSEDEL'       : null 
		};
		
		if (me.isValid()) {
			me.submit({
               	params: param,
                   success: function(obj, action) {
                	   var nboxBaseApp = Ext.getCmp('nboxBaseApp');
                	   var nboxDocEditFilePanel = Ext.getCmp('nboxDocEditFilePanel');
                	   
                	   if (nboxBaseApp.getActionType() == NBOX_C_UPDATE){
                		   nboxDocEditFilePanel.reset();
                		   	nboxBaseApp.setActionType(NBOX_C_READ);
                		   	nboxBaseApp.formShow();
                	   }else{
                		   Ext.Msg.alert('확인', '문서가 저장되었습니다.');
	                	   me.clearData();	
                	   }
                   }
               });
        }
        else {
        	Ext.Msg.alert('확인', me.validationCheck());
        } 
        
    },
    draftData: function(){
    	var me = this;
    	var documentID = null;
    	var editorContents = null;
    	var interfaceKey = null;
    	var gubun = null;
    	var formID = null;
    	var addFiles = null;
    	var delFiles = null;
    	var doclines = null;
    	var rcvusers = null;
    	var refusers = null;
    	var docbasis = null;
    	var inputRcvUsers = null;

    	var nboxBaseApp = Ext.getCmp('nboxBaseApp');
    	
    	if (nboxBaseApp){
	    	interfaceKey = nboxBaseApp.getInterfaceKey();
	    	gubun = nboxBaseApp.getGubun();
	    	
	    	if (nboxBaseApp.getActionType() == NBOX_C_UPDATE)
	    		documentID = nboxBaseApp.getDocumentID();
    	}
    	
    	var isNew = ( documentID == "" || documentID == null);
    	
    	var nboxDocEditFormCombo = Ext.getCmp('nboxDocEditFormCombo');
    	if (nboxDocEditFormCombo)
    		formID = nboxDocEditFormCombo.getValue(); 
    	
    	var docEditContentsHtmlEditor = Ext.getCmp('nboxDocEditContentsPanel').items.items[0];
    	if (docEditContentsHtmlEditor.name == "nboxCkeditor" )
    		editorContents = docEditContentsHtmlEditor.getValue()
		
    	var nboxDocEditFilePanel = Ext.getCmp('nboxDocEditFilePanel');
    	if (nboxDocEditFilePanel) {
			addFiles = nboxDocEditFilePanel.getAddFiles();
			delFiles = nboxDocEditFilePanel.getRemoveFiles();
    	}
    	
		var linkdatalist = [];
		var columns = ['id','value','rawValue'];
		var docEditLinkDataPanel =  Ext.getCmp('nboxDocEditLinkDataPanel');
		if (docEditLinkDataPanel){
			Ext.each(docEditLinkDataPanel.items.items,function(item){
				linkdatalist.push(me.JSONtoString(item,columns));
			});
		}
		
		if (linkdatalist.length == 0) linkdatalist = null;
		
		var nboxDocEditLineView = Ext.getCmp('nboxDocEditLineView');
		var nboxDocEditRcvUserView = Ext.getCmp('nboxDocEditRcvUserView');
    	var nboxDocEditRefUserView = Ext.getCmp('nboxDocEditRefUserView');
    	var nboxDocEditBasisView   = Ext.getCmp('nboxDocEditBasisView');
    	
		var doclinelist = []; 
		if (nboxDocEditLineView){
			doclines = nboxDocEditLineView.getStore().data.items;
			if (doclines){
				Ext.each(doclines,function(record){
					doclinelist.push(me.JSONtoString(record.data));
				});
			}
		}
		
		var rcvuserlist = []; 
		if (nboxDocEditRcvUserView){
			rcvusers = nboxDocEditRcvUserView.getStore().data.items;
			if (rcvusers){
				Ext.each(rcvusers,function(record){
					rcvuserlist.push(me.JSONtoString(record.data));
				});
			}
		}
		
		var nboxDocInputRcvCombo = Ext.getCmp('nboxDocInputRcvCombo');
		
		var inputRcvuserlist = [];
		if (nboxDocInputRcvCombo){
			inputRcvUsers = nboxDocInputRcvCombo.getStore().data.items;
			if (inputRcvUsers){
				Ext.each(inputRcvUsers,function(record){
					inputRcvuserlist.push(me.JSONtoString(record.data));
				});
			}
		}
		
		var refuserlist = []; 
		if (nboxDocEditRefUserView){
			refusers = nboxDocEditRefUserView.getStore().data.items;
			if (refusers){
				Ext.each(refusers,function(record){
					refuserlist.push(me.JSONtoString(record.data));
				});
			}
		}
		
		var docbasilist = []; 
		if (nboxDocEditBasisView){
			docbasis = nboxDocEditBasisView.getStore().data.items;
			if (docbasis){
				Ext.each(docbasis,function(record){
					docbasilist.push(me.JSONtoString(record.data));
				});
			}
		}
		
		if (addFiles.length == 0) addFiles = null;
		if (delFiles.length == 0) delFiles = null;
		
		if (doclinelist.length == 1){
			Ext.Msg.alert('확인', '선택된 결재선이 존재하지 않습니다.');
			doclinelist = null;
			return;
		}
		if (rcvuserlist.length == 0) rcvuserlist = null;
		if (inputRcvuserlist.length == 0) inputRcvuserlist = null;
		if (refuserlist.length == 0) refuserlist = null;
		if (docbasilist.length == 0) docbasilist = null;
		
		var param = {
			 'DocumentID'    : documentID, 
		     'FormID'        : formID, 
		     'Status'        : 'B', 
		     'EditorContents': editorContents,
		     'InterfaceKey'  : interfaceKey,
		     'Gubun'         : gubun,
		     'ADDFID'        : addFiles,
		     'DELFID'        : delFiles,
		     'DOCLINES'      : doclinelist,
		     'RCVUSERS'      : rcvuserlist,
		     'REFUSERS'      : refuserlist,
		     'DOCBASISS'     : docbasilist,
		     'LINKDATA'      : linkdatalist,
		     'EXPENSEADD'    : inputRcvuserlist,
		     'EXPENSEUPD'    : null,
		     'EXPENSEDEL'    : null
		};
		
		if (me.isValid()) {
			me.submit({
               	params: param,
                   success: function(obj, action) {
                	   var nboxBaseApp = Ext.getCmp('nboxBaseApp');
                	   var nboxDocEditFilePanel = Ext.getCmp('nboxDocEditFilePanel');
                	   
                	   /*if (nboxBaseApp.getActionType() == NBOX_C_UPDATE){
                		   nboxDocEditFilePanel.reset();
                		   nboxBaseApp.closeData();
                	   }else{*/
                		   Ext.Msg.alert('확인', '문서가 상신되었습니다.');
	                	   me.clearData();	
                	   //}
                   }
               });
        }
        else {
        	Ext.Msg.alert('확인', me.validationCheck());
        } 
    },
    clearData: function(){
    	var me = this;
    	
    	var store = me.getStore();
    	var nboxDocEditNorthPanel = Ext.getCmp('nboxDocEditNorthPanel');
    	var nboxDocEditSouthPanel = Ext.getCmp('nboxDocEditSouthPanel');
    	
    	me.clearPanel();
    	
    	if(store)
    		store.removeAll();
    	
    	if (nboxDocEditNorthPanel)
    		nboxDocEditNorthPanel.clearData();
    	if (nboxDocEditSouthPanel)
    		nboxDocEditSouthPanel.clearData();
    },
	loadPanel: function(){
    	var me = this;
    	var nboxDocEditNorthPanel = Ext.getCmp('nboxDocEditNorthPanel');
    	var store = me.getStore();
    	var frm = me.getForm();
    	
    	if (store.getCount() > 0)
    	{
			var record = store.getAt(0);
			frm.loadRecord(record);
    	}
    	
    	if (nboxDocEditNorthPanel)
    	{
    		nboxDocEditNorthPanel.loadPanel();
    	}
    },
    clearPanel: function(){
    	var me = this;
    	var frm = me.getForm();
    	
    	if(frm.initialized){
    		frm.reset();
    	}
    },
    validationCheck: function(){
    	var me = this;
    	
    	var fields = me.getForm().getFields();
    	var result = '';
    	
    	var itemCnt = fields.getCount();
    	for(var idx=0; idx<itemCnt; idx++){
    		if(!fields.items[idx].isValid()){
    			result += fields.items[idx].getFieldLabel() + ',';
    		}
    	}
    	
    	return '[' + result.substring(0,result.length-1) + ']' + '은/는 필수입력 사항입니다.';	
    },
    getModeltoArray: function(model){
    	var me = this;
    	var resultArr = [];
    	
    	if (!model) return null;
    	
    	Ext.each(model, function(record){
    		resultArr.push(me.JSONtoString(record.data));
		});
    	
    	if (resultArr.length == 0) resultArr = null;
    	
    	return resultArr;
    },
    JSONtoString: function (object, columns) {
        var results = [];
        
        if(columns != null){
        	for(var colunmn in columns) {
	            var value = object[columns[colunmn]];
	            if (value)
	                results.push('\"' + columns[colunmn].toString() + '\": \"' + value + '\"');
	        }
        }
        else{
        	for(var property in object) {
	            var value = object[property];

				if(property.toString() == 'ExpenseDate')
	            	value = value.toISOString().slice(0,10);
				
	            if (value)
	                results.push('\"' + property.toString() + '\": \"' + value + '\"');
	        }
        }
                     
        return '{' + results.join(String.fromCharCode(11)) + '}';
    }
});	

/**************************************************
 * Create
 **************************************************/

/**************************************************
 * User Define Function
 **************************************************/	