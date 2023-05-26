	/**************************************************
	 * Common variable
	 **************************************************/
	//local  variable


	/**************************************************
	 * Common Code
	 **************************************************/
	
	/**************************************************
	 * Model
	 **************************************************/
	// MyInfo
	Ext.define('nbox.userInfoModel', {
	    extend: 'Ext.data.Model',
	    fields: [
			{name: 'GROUP_NAME'},	             
	    	{name: 'COMP_CODE'},
	    	{name: 'COMP_NAME'},
	    	{name: 'USER_ID'}, 
	    	{name: 'USER_NAME'},
	    	{name: 'PASSWORD'},
	    	{name: 'PASSWORDCONFIRM'},
	    	{name: 'DEPT_CODE'},
	    	{name: 'DEPT_NAME'},
	    	{name: 'GRADE_LEVEL'},
	    	{name: 'GRADE_LEVEL_NAME'},
	    	{name: 'GROUP_CODE'},
	    	{name: 'JOIN_DATE'},
	    	{name: 'RETR_DATE'},
	    	{name: 'POST_CODE'},
	    	{name: 'POST_NAME'},
	    	{name: 'ABIL_CODE'},
	    	{name: 'ABIL_NAME'},
	    	{name: 'BIRTH_DATE'},
	    	{name: 'SOLAR_YN'},
	    	{name: 'SOLAR_YN_NAME'},
	    	{name: 'SEX_CODE'},
	    	{name: 'SEX_CODE_NAME'},
	    	{name: 'MARRY_YN'},
	    	{name: 'MARRY_YN_NAME'},
	    	{name: 'ZIP_CODE'},
	    	{name: 'KOR_ADDR'},
	    	{name: 'EMAIL_ADDR'},
	    	{name: 'EXT_NO'},
	    	{name: 'TELEPHONE'},
	    	{name: 'PHONE'},
	    	{name: 'SELF_INTROE'}
	    ]
	});
	
	// Sign Image
	Ext.define('nbox.userInfoSignModel', {
	    extend: 'Ext.data.Model',
	    fields: [
			{name: 'FID'},	             
	    	{name: 'UserID'}
	    ]
	});
	
	// Photo Image
	Ext.define('nbox.userInfoPhotoModel', {
	    extend: 'Ext.data.Model',
	    fields: [
			{name: 'FID'},	             
	    	{name: 'UserID'}
	    ]
	});	


	/**************************************************
	 * Store
	 **************************************************/
	Ext.define('nbox.userInfoStore', {
		extend: 'Ext.data.Store',
		model: 'nbox.userInfoModel',
		autoLoad: false,
		config: {
			regItems: {}
		},
		proxy: {
            type: 'direct',
            api: { 
            	read: 'nboxMyInfoService.get'
            },
            reader: {
	            type: 'json',
	            root: 'records'
	        }
        }
	});
	
	//Sign Image
	var userInfoSignStore = Ext.create('Ext.data.Store', {
		model: 'nbox.userInfoSignModel',
		autoLoad: false,
		config: {
			regItems: {}
		},
		proxy: {
            type: 'direct',
            api: { 
            	read: 'nboxUserSignService.select'
            },
            reader: {
	            type: 'json',
	            root: 'records'
	        }
        }
	});
	
	//Photo Image
	var userInfoPhotoStore = Ext.create('Ext.data.Store', {
		model: 'nbox.userInfoPhotoModel',
		autoLoad: false,
		config: {
			regItems: {}
		},
		proxy: {
            type: 'direct',
            api: { 
            	read: 'nboxUserPhotoService.select'
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
	// Picture Panel
	Ext.define('nbox.photoPanel', {
		extend: 'Ext.form.Panel',
		config: {
			regItems: {}
		},
		layout: {
			type: 'vbox',
		},
		height: 250,
		border: false,
		initComponent: function () {
			var me = this;
			
			me.items = [
				{ 
					xtype:'component',
					itemId: 'Photo',
					style: {
						'margin': '40px 0px 10px 40px',
	        			'border' : '1px solid #C0C0C0'
					},
					autoEl: {
						tag: 'img',
						width : 120, height: 150,
					}
				}/*,
				{
	    			xtype:'button',
	    			tooltip : 'Upload',
	    			text: 'Upload',
	                width: 150, height: 26,
	                style: {
						'margin': '0px 0px 0px 25px'
					},
	                handler: function() { 
	                	me.openUploadPopup();
	                }
				} */    
			];
			
			me.callParent(); 
		},
		queryData: function(){
			var me = this;
			var store = me.getRegItems()['StoreData'];
			
			me.clearData();
			
			alert(userInfoPopupWin.getRegItems()['USER_ID']);
			store.proxy.setExtraParam('USER_ID', userInfoPopupWin.getRegItems()['USER_ID']);
			store.load({
       			callback: function(records, operation, success) {
       				if (success){
       					me.loadPanel();
       				}
       			}
   			});
		},
		clearData: function(){
			var me = this;
	    	
	    	me.clearPanel();
		},
		loadPanel: function(){
			var me = this;
        	var store = me.getRegItems()['StoreData'];
        	
        	if (store.getCount() > 0)
        	{
				var record = store.getAt(0);
				var fid = 'blank';
				if(record)
					fid = record.data.FID;
				
				me.items.get('Photo').getEl().dom.src = CPATH+'/nboxfile/myinfophoto/'+ fid;
        	}
        },
        clearPanel: function(){
        	var me = this;
        	var frm = me.getForm();
        	var store = me.getRegItems()['StoreData'];
    		
        	store.removeAll();
			frm.reset();
        }
	});
	
	// leftPanel
	Ext.define('nbox.userInfoLeftPanel', {
		extend: 'Ext.panel.Panel',
		config: {
			regItems: {}
		},
		border:false,
		layout: {
			type: 'vbox'
		},
		style: {
			'border-right': '1px solid #C0C0C0'
		},
		width: 200,
		initComponent: function () {
	    	var me = this;
	    	
	    	var photoPanel = Ext.create('nbox.photoPanel', {});	  
	    	
	    	me.getRegItems()['PhotoPanel'] = photoPanel;
	    	photoPanel.getRegItems()['ParentContainer'] = me;
	    	photoPanel.getRegItems()['StoreData'] = userInfoPhotoStore;
	    	
	    	me.items = [photoPanel];
	    	
	    	me.callParent(); 
		},
		queryData: function(){
			var me = this;
			
			var photoPanel = me.getRegItems()['PhotoPanel']
			
			photoPanel.queryData();
		}
	});	
	
	// rightPanel
	Ext.define('nbox.userInfoRightPanel', {
		extend: 'Ext.form.Panel',
		config: {
			regItems: {}
		},
		border:false,
		layout: {
			type: 'vbox'
		},
		flex: 1,
		
		initComponent: function () {
	    	var me = this;
	    	
	    	var myInfoAPanel = Ext.create('Ext.panel.Panel', { 
	    		id: 'infoA',
	        	layout: {
					type: 'table',
					columns: 2,
					tdAttrs:{
						style: {
						 	'padding': '3px 3px 0px 3px'
					   	}
					}
				},
				style: {
					'padding': '10px 0px 0px 0px',
        			'border-bottom': '1px solid #C0C0C0'
				},
				border: false,
				height: 50,
				defaultType: 'displayfield',
				items: [
					{ 
						xtype: 'displayfield',
						name: 'USER_ID',
						fieldLabel: '사용자ID',
						labelAlign : 'right',
						labelClsExtra: 'field_label',
						width: 300
					},
					{ 
						xtype: 'displayfield',
						name: 'USER_NAME',
						fieldLabel: '이름',
						labelAlign : 'right',
						labelClsExtra: 'field_label',
						width: 300
					}
				]
	        });
	    	
			var zipcode = Ext.create('Ext.panel.Panel', { 
				layout: {
					type: 'hbox',
					style: {
					 'padding': '3px 3px 2px 3px'
				   	}
				},
				colspan:2,
				border: false,
				defaultType: 'displayfield',
				items:[
					{ 
						id: 'ZIP_CODE',
						name: 'ZIP_CODE',
						fieldLabel: '우편번호',
						labelAlign : 'right',
						labelClsExtra: 'field_label',
						width: 300 - 27,
						style: { 'padding': '0px 0px 0px 0px' }
					}]
			});
	    	
	    	var myInfoBPanel = Ext.create('Ext.panel.Panel', { 
	        	layout: {
					type: 'table',
					columns: 2,
					tdAttrs:{
						style: {
							'padding': '3px 3px 0px 3px'
					   	}
					}
				},
				style: {
					'padding': '10px 0px 0px 0px',
        			'border-bottom': '1px solid #C0C0C0'
				},
				border: false,
				height: 135,
				defaultType: 'displayfield',
				items: [
					{
					    name: 'BIRTH_DATE',
					    format: 'Y-m-d', 
					    fieldLabel: '생년월일',
					    labelAlign : 'right',
						labelClsExtra: 'field_label',
						width: 300,
					},
					{ 
						name:'SOLAR_YN_NAME',
						fieldLabel: '음양구분', 
						labelAlign : 'right',
						labelClsExtra: 'field_label',
						width: 300
					}, 
					{ 
						name:'SEX_CODE_NAME',
						fieldLabel: '성별', 
						labelAlign : 'right',
						labelClsExtra: 'field_label',
						width: 300
					}, 
					{ 
						name:'MARRY_YN_NAME',
						fieldLabel: '결혼여부', 
						labelAlign : 'right',
						labelClsExtra: 'field_label',
						width: 300
					},
					zipcode,
					{ 
						id: 'KOR_ADDR',
						name: 'KOR_ADDR',
						fieldLabel: '주소',
						labelAlign : 'right',
						labelClsExtra: 'field_label',
						width: 607,
						colspan: 2,
						padding: '5 0 0 0'
					}
				]
	        });
	    	
	    	var myInfoCPanel = Ext.create('Ext.panel.Panel', { 
	        	layout: {
					type: 'table',
					columns: 2,
					tdAttrs:{
						style: {
						 'padding': '3px 3px 0px 3px'
					   	}
					}
				},
				style: {
					'padding': '10px 0px 0px 0px',
        			'border-bottom': '1px solid #C0C0C0'
				},
				border: false,
				height: 80,
				defaultType: 'displayfield',
				items: [
					{ 
						name: 'PHONE',
						fieldLabel: '휴대폰',
						labelAlign : 'right',
						labelClsExtra: 'field_label',
						width: 300
					},
					{ 
						name: 'EMAIL_ADDR',
						fieldLabel: '이메일',
						labelAlign : 'right',
						labelClsExtra: 'field_label',
						width: 300
					},
					{ 
						name: 'TELEPHONE',
						fieldLabel: '전화번호',
						labelAlign : 'right',
						labelClsExtra: 'field_label',
						width: 300
					},
					{ 
						name: 'EXT_NO',
						fieldLabel: '내선번호',
						labelAlign : 'right',
						labelClsExtra: 'field_label',
						width: 300
					}
				]
	        });
	    	
	    	var myInfoDPanel = Ext.create('Ext.panel.Panel', { 
	        	layout: {
					type: 'table',
					columns: 2,
					tdAttrs:{
						style: {
						 'padding': '3px 3px 0px 3px'
					   	}
					}
				},
				style: {
					'padding': '10px 0px 0px 0px',
        			'border-bottom': '1px solid #C0C0C0'
				},
				border: false,
				height: 110,
				defaultType: 'displayfield',
				items: [
					{ 
						name: 'GROUP_NAME',
						fieldLabel: '그룹',
						labelAlign : 'right',
						labelClsExtra: 'field_label',
						width: 300,
						colspan: 2
					},
					{ 
						name: 'COMP_NAME',
						fieldLabel: '회사',
						labelAlign : 'right',
						labelClsExtra: 'field_label',
						width: 300
					},
					{ 
						name: 'DEPT_NAME',
						fieldLabel: '부서',
						labelAlign : 'right',
						labelClsExtra: 'field_label',
						width: 300
					},
					{ 
						name: 'POST_NAME',
						fieldLabel: '직위',
						labelAlign : 'right',
						labelClsExtra: 'field_label',
						width: 300
					},
					{ 
						name: 'ABIL_NAME',
						fieldLabel: '직책',
						labelAlign : 'right',
						labelClsExtra: 'field_label',
						width: 300
					},
					
				]
	        });
	    	
	    	var myInfoEPanel = Ext.create('Ext.panel.Panel', { 
	        	layout: {
					type: 'table',
					columns: 2,
					tdAttrs:{
						style: {
						 'padding': '3px 3px 0px 3px'
					   	}
					}
				},
				style: {
					'padding': '10px 0px 0px 0px',
        			'border-bottom': '1px solid #C0C0C0'
				},
				border: false,
				height: 50,
				defaultType: 'displayfield',
				items: [
					{ 
						name: 'GRADE_LEVEL_NAME',
						fieldLabel: '보안등급',
						labelAlign : 'right',
						labelClsExtra: 'field_label',
						width: 300
					},
					{ 
						name: 'blank',
						fieldLabel: '',
						labelAlign : 'right',
						labelClsExtra: 'field_label',
						width: 300
					}
				]
	        });
	    	
	    	
	    	var myInfoFPanel = Ext.create('Ext.panel.Panel', { 
	        	layout: {
					type: 'table',
					columns: 2,
					tdAttrs:{
						style: {
						 'padding': '3px 3px 0px 3px'
					   	}
					}
				},
				style: {
					'padding': '10px 0px 0px 0px',
        			'border-bottom': '1px solid #C0C0C0'
				},
				border: false,
				height: 50,
				defaultType: 'displayfield',
				items: [
					{ 
						name: 'JOIN_DATE',
						fieldLabel: '입사일',
						labelAlign : 'right',
						labelClsExtra: 'field_label',
						width: 300
					},
					{ 
						name: 'RETR_DATE',
						fieldLabel: '퇴사일',
						labelAlign : 'right',
						labelClsExtra: 'field_label',
						width: 300
					}
				]
	        });
	    	
	    	
	    	var selfIntroePanel = Ext.create('Ext.panel.Panel', {
	    		layout: {
					type: 'fit'
				},
	        	width: 612,
	        	flex: 1,
	        	border: false,
	        	padding : '10px 3px 10px 3px',
				items: [
					{ xtype: 'displayfield',
					  fieldLabel: '자기소개',
					  labelAlign : 'right',
					  labelClsExtra: 'field_label',
					  name: 'SELF_INTROE',
					  autoScroll: true 
			        }
		    	]
			});
	    	
	    	me.items = [ myInfoAPanel, 
	    	             myInfoBPanel, 
	    	             myInfoCPanel,
	    	             myInfoDPanel,
	    	             myInfoEPanel,
	    	             myInfoFPanel,
	    	             selfIntroePanel];
	    	
	    	me.callParent(); 
		},
		queryData: function(){
			var me = this;
			var store = me.getRegItems()['StoreData'];
			
			me.clearData();
			
			store.proxy.setExtraParam('USER_ID', userInfoPopupWin.getRegItems()['USER_ID']);
			store.load({
       			callback: function(records, operation, success) {
       				if (success){
       					me.loadData();
       				}
       			}
   			});
		},
		clearData: function(){
			var me = this;
	    	
	    	me.clearPanel();
		},
		loadData: function(){
			var me = this;
        	var store = me.getRegItems()['StoreData'];
        	var frm = me.getForm();
        	
        	if (store.getCount() > 0)
        	{
				var record = store.getAt(0);
				frm.loadRecord(record);
        	}
        },
        clearPanel: function(){
        	var me = this;
        	var frm = me.getForm();
        	var store = me.getRegItems()['StoreData'];
    		
        	store.removeAll();
			frm.reset();
        }
	});	
	
	// contentPanel
	Ext.define('nbox.userInfoContentsPanel', {
		extend: 'Ext.panel.Panel',
		config: {
			regItems: {}
		},
		border:false,
		flex:1,
		layout: {
	        type: 'hbox',
	        align: 'stretch'
	    },
		initComponent: function () {
	    	var me = this;
	    	
	    	var userInfoLeftPanel = Ext.create('nbox.userInfoLeftPanel',{});
	    	
	    	var userInfoStore = Ext.create('nbox.userInfoStore',{});
	    	var userInfoRightPanel = Ext.create('nbox.userInfoRightPanel',{
	    		store: userInfoStore
	    	});
	    			
			me.getRegItems()['UserInfoLeftPanel'] = userInfoLeftPanel;
			userInfoLeftPanel.getRegItems()['ParentContainer'] = me;
			
			me.getRegItems()['UserInfoRightPanel'] = userInfoRightPanel;
			userInfoRightPanel.getRegItems()['ParentContainer'] = me;
			
			userInfoRightPanel.getRegItems()['StoreData'] = userInfoStore;
			
			me.items = [userInfoLeftPanel, userInfoRightPanel];
			
	        me.callParent(); 
	    },
	    queryData: function(){
	    	var me = this;
	    	
	    	userInfoLeftPanel = me.getRegItems()['UserInfoLeftPanel'];
	    	userInfoRightPanel = me.getRegItems()['UserInfoRightPanel'];
	    	
	    	userInfoLeftPanel.queryData();
	    	userInfoRightPanel.queryData();
	    }
	});	
	
	
	
	
	
	
	