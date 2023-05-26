<%@page language="java" contentType="text/html; charset=utf-8"%>
	{
		title:'<t:message code="system.label.human.calculateupdate" default="계산식등록"/>',
		border: false,
		id:'hbs020ukrTab15',
		xtype: 'container',
		scrollable:'y',
		flex: 0.2,
		layout: {type: 'uniTable', columns:1},
		items:[{
			xtype: 'uniDetailFormSimple',
			layout: {type: 'uniTable'},
			items:[{
				fieldLabel: '<t:message code="system.label.human.paybonustype" default="급/상여구분"/>',
				name: 'SUPP_TYPE',
				id: 'SUPP_TYPE',
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'H032',
				allowBlank:false,
//				value:'1',
				listeners: {
					change: function(combo, newValue, oldValue){
						var combo1 = Ext.getCmp('STD_CODE1');
						var combo2 = Ext.getCmp('STD_CODE2');
						if (combo1.getValue() != '' || combo2.getValue() != '') {
							combo1.setValue('');
							combo2.setValue('');
						}
						var param = {"SUB_CODE" : this.getValue()};
                        hbs020ukrService.findRefcode1(param, function(provider, response) {
							if(!Ext.isEmpty(provider)){
								var records = response.result;

								ref_code1 = records[0].REF_CODE1;
								Ext.getCmp('TMP_REF_CODE1').setValue(ref_code1);
							}
                        });
					}
	            } ,
	            getAltValue:function()	{
	            	var me = this;
	            	var value = this.getValue();
	            	var tmp;

	            	if( value == "2" || value == "3" || value == "4" || value == "5" || value == "6" || value == "7" || value == "8" || value == "9")	{
	            		tmp = Ext.getCmp('TMP_REF_CODE1').getValue();
	            	}
	            	else if( value == "L" || value == "M")	{
	            		tmp = 'L';
	            	}
	            	else{
	            	    tmp = value;
	            	}

	            	return tmp;
	            }
			},{
				fieldLabel: '<t:message code="system.label.human.monyearprov" default="지급"/>/<t:message code="system.label.human.dedcode" default="공제코드"/>',
				name: 'STD_CODE',
				id: 'STD_CODE1',
				xtype: 'uniCombobox',
				store: Ext.StoreManager.lookup("STD_CODE_STORE"),
				listeners: {
					beforequery:function( queryPlan, eOpts ){
                        var store = queryPlan.combo.store;
                        store.clearFilter();
                    	if(!Ext.isEmpty(Ext.getCmp('SUPP_TYPE').getValue())){
                            store.filterBy(function(record){
                            	if(Ext.getCmp('SUPP_TYPE').getValue() == '1' || Ext.getCmp('TMP_REF_CODE1').getValue() == '1'){
	                                return record.get('refCode1') == '1' || record.get('refCode1') == 'A';
                            	}else if(Ext.getCmp('SUPP_TYPE').getValue() != '1' && Ext.getCmp('SUPP_TYPE').getValue() != 'F' && Ext.getCmp('SUPP_TYPE').getValue() != 'R' && Ext.getCmp('TMP_REF_CODE1').getValue() != '1'){
                            		return record.get('refCode1') == '2' || record.get('refCode1') == 'A';
                            	}else if(Ext.getCmp('SUPP_TYPE').getValue() == 'F'){
                            		return record.get('refCode1') == 'F' || record.get('refCode1') == 'A';
                            	}else if(Ext.getCmp('SUPP_TYPE').getValue() == 'R'){
                            		return record.get('refCode1') == 'R' || record.get('refCode1') == 'A';
                            	}
                            })
                        }else{
                        	alert('급/상여구분 콤보 값을 먼저 입력해 주십시오.');
                        	return false;
                        }
                    }
				}
			}
			,{
                fieldLabel : '<t:message code="system.label.human.tmprefcode" default="임시필드"/>',
                name : 'TMP_REF_CODE1',
                id: 'TMP_REF_CODE1',
                hidden:true
            }
			]
		},{
			xtype: 'box',
   			autoEl: {tag: 'hr'},
            width: 1350
		},{
			xtype: 'uniDetailFormSimple',
			layout: {type: 'uniTable', columns:1},
			items:[{
				fieldLabel: '<t:message code="system.label.human.monyearprov" default="지급"/>/<t:message code="system.label.human.dedcode" default="공제코드"/>',
				name: 'STD_CODE',
				id: 'STD_CODE2',
				xtype: 'uniCombobox',
				store: Ext.StoreManager.lookup("STD_CODE_STORE"),
				width: 230,
				listeners: {
					beforequery:function( queryPlan, eOpts ){
                        var store = queryPlan.combo.store;
                        store.clearFilter();
                    	if(!Ext.isEmpty(Ext.getCmp('SUPP_TYPE').getValue())){
                            store.filterBy(function(record){
                            	if(Ext.getCmp('SUPP_TYPE').getValue() == '1' || Ext.getCmp('TMP_REF_CODE1').getValue() == '1'){
	                                return record.get('refCode1') == '1' || record.get('refCode1') == 'A';
                            	}else if(Ext.getCmp('SUPP_TYPE').getValue() != '1' && Ext.getCmp('SUPP_TYPE').getValue() != 'F' && Ext.getCmp('SUPP_TYPE').getValue() != 'R' && Ext.getCmp('TMP_REF_CODE1').getValue() != '1'){
                            		return record.get('refCode1') == '2' || record.get('refCode1') == 'A';
                            	}else if(Ext.getCmp('SUPP_TYPE').getValue() == 'F'){
                            		return record.get('refCode1') == 'F' || record.get('refCode1') == 'A';
                            	}else if(Ext.getCmp('SUPP_TYPE').getValue() == 'R'){
                            		return record.get('refCode1') == 'R' || record.get('refCode1') == 'A';
                            	}
                            })
                        }else{
                        	alert('급/상여구분 콤보 값을 먼저 입력해 주십시오.');
                        	return false;
                        }
                    }, focus: function(){

			        }, blur: function(){

			        },	change:function(field, newValue, oldValue)	{

					  	var chkTxt = Ext.getCmp('CHK_TXT').getValue();

						if(oldValue != newValue)	{

							Ext.getCmp('CALC_TXT').setValue('');
							Ext.getCmp('UPDATE_TXT').setValue('');
							var suppType = Ext.getCmp("SUPP_TYPE").getValue();
							var stdCode = Ext.getCmp("STD_CODE2").getValue();

							var param = {"SUPP_TYPE": suppType,"STD_CODE":newValue};
							hbs020ukrService.tab15_GetComboData4(param, function(responseText, response){

								var store01 = Ext.StoreManager.lookup('OT_KIND_STORE');

				                store01.loadData({});
				                var i=0;
								if(responseText && responseText.length > 0)	{
									objOtKind01=responseText;
									Ext.each(responseText, function(record){
										var newRecord =  Ext.create (store01.model);

										newRecord.set("OT_KIND_01",record['OT_KIND_01']);
										store01.insert(i, newRecord)
										i++;
									})
		                			UniAppManager.setToolbarButtons('newData',false);
								}else {
									objOtKind01=null;
									var newRecord =  Ext.create (store01.model);
										newRecord.set("OT_KIND_01",'');
										store01.insert(i, newRecord)
									UniAppManager.setToolbarButtons('newData',true);
								}

//		                		var value = field.getValue();
//		                		var store = field.getStore();
//		                		store.clearFilter();
//		                		var suppType = Ext.getCmp("SUPP_TYPE").getAltValue();
//		                		store.addFilter([new Ext.util.Filter({
//								    property: 'refCode1',
//		    						value   : suppType
//		                		   }
//								 )]);
//								 field.setValue(value);
								 if(field.getSelectedRecord()) {
								 	Ext.getCmp('CALC_TITLE').setValue(field.getSelectedRecord().get('text'));
								 } else {
								 	Ext.getCmp('CALC_TITLE').setValue('');
								 }

								 if(chkTxt == ''){

									 	var  otKind01Data = Ext.getCmp('OTKIND1_TXT').getValue();
										var  otKind02Data = Ext.getCmp('OTKIND2_TXT').getValue();
										otKind01Data = otKind01Data.slice(0,-1);
										otKind02Data = otKind02Data.slice(0,-1);
										var  otKind01Array = otKind01Data.split('/') ;
										var  otKind02Array = otKind02Data.split('/') ;

										var  grid = Ext.getCmp('otKindGrid');
										var  otKindStore  =  Ext.StoreManager.lookup("OT_KIND_STORE");
								  		var  records		=  otKindStore.data.items;
										var orgStore = Ext.StoreManager.lookup("OT_KIND_02_STORE");
										var comboStore ;
										if( grid.getColumns()[2].editor != null ){

											 comboStore = grid.getColumns()[2].editor.orderedTriggers[0].field.store;

										}else{

											 comboStore = grid.getColumns()[2].field.store;

										}

										var items ;
								  		Ext.each(records, function(item, i){
											items = Ext.Array.push(orgStore.data.filterBy(function(record) {return (record.get('refCode1')== item.get('OT_KIND_01') ) } ).items);
											comboStore.loadData(items);
												for(var j=0; j < otKind01Array.length; j++){
													//alert(j + '/' + item.get("OT_KIND_01") + '/' + otKind01Array[j] + '/' + otKind02Array[j] + i);
													if(item.get("OT_KIND_01") == otKind01Array[j]){

														item.set("OT_KIND_02",otKind02Array[j]);

													}
												}
										})

								 }

				             });

						}
                	}
	            }
            }]
		},{
			xtype: 'container',
			layout: {type: 'uniTable', columns:3},
			padding: '0 0 0 95',
			items:[{
				xtype: 'uniTextfield',
				name: 'CALC_TITLE',
				id: 'CALC_TITLE',
				readOnly:true
			},{
               xtype:  'displayfield',
               value:'&nbsp;&nbsp;=&nbsp;&nbsp;'
            },{
				xtype: 'textareafield',
				name: 'CALC_TXT',
				id: 'CALC_TXT',
				width: 1080,
				height:60,
				readOnly:true
			},{
				xtype: 'textareafield',
				name: 'UPDATE_TXT',
				id: 'UPDATE_TXT',
				width: 1080,
				height:60,
				readOnly:false,
				hidden: true
			},{
				xtype: 'uniTextfield',
				name: 'OTKIND1_TXT',
				id: 'OTKIND1_TXT',
				width: 100,
				height:60,
				readOnly:false,
				hidden: true
			},{
				xtype: 'uniTextfield',
				name: 'OTKIND2_TXT',
				id: 'OTKIND2_TXT',
				width: 100,
				height:60,
				readOnly:false,
				hidden: true
			},{
				xtype: 'uniTextfield',
				name: 'CHK_TXT',
				id: 'CHK_TXT',
				width: 50,
				height:60,
				readOnly:false,
				hidden: true
			}]
		},{
			xtype: 'container',
			layout: {type: 'uniTable', columns: 5},
			//padding: '0 0 0 0',
			defaults:{padding: '0 0 0 10'},
			flex: 1,
			items:[
			{
               xtype:'component',
			   html:'<font color="blue">&nbsp;▒ <t:message code="system.label.human.calculateclass" default="계산식 분류"/> ▒</font>',
               width:400
            },{
               xtype:'component',
			   html:'<font color="blue"">&nbsp;▒ <t:message code="system.label.human.duty" default="근태"/> ▒</font>',
               width:200
            },{
               xtype:'component',
			   html:'<font color="blue"">&nbsp;▒ <t:message code="system.label.human.monyearprov" default="지급"/>  ▒</font>',
               width:200
            },{
               xtype:'component',
				html:'<font color="blue"> &nbsp;▒ <t:message code="system.label.human.etc" default="기타"/>  ▒</font>',
               width:200
            },{
			   xtype:'component',
			   html:'<font color="blue">&nbsp;</font>',
               width:440,
               height:20
            },{
              xtype: 'uniGridPanel',
                  padding: '0 0 0 10',
                  width: 400,
                  height: 300,
                  itemId: 'OT_KIND',
                  id:'otKindGrid',
                  store : Unilite.createStore('OT_KIND_STORE',{
				  	model:'OT_KIND_STORE_MODEL',
		            autoLoad: false,
		            uniOpt : {
		            	isMaster: false,			// 상위 버튼 연결
		            	editable: true,			// 수정 모드 사용
		            	deletable: false,			// 삭제 가능 여부
			            useNavi : false			// prev | next 버튼 사용
		            },
				  	data:[
						{'OT_KIND_01':'', 'OT_KIND_02':''}
					],
					listeners:{
						update:function(store)	{
							store.commitChanges();
						}
					}
				  }),
                  selModel:'rowmodel',
                  uniOpt: {
                  	   userToolbar:false,
                       expandLastColumn: false,
                       useRowNumberer: true,
                       useMultipleSorting: false,
                       state: {
							useState: false,
							useStateList: false
						}
                  },
                  columns: [
                     {
		            	dataIndex: 'OT_KIND_01',
		            	width:190
		            },{
		            	flex:1,
		            	dataIndex: 'OT_KIND_02'
		            }
                  ]
                  ,listeners:{
						beforeedit: function ( editor, context, eOpts ) {

							if(context.field == 'OT_KIND_01') {
								//context.column.field.on('beforequery', this.onBeforequery01);
								context.column.field.on('change', this.onOtKindChange);
							}
							if(context.field == 'OT_KIND_02')	{
								context.column.field.on('beforequery', this.onBeforequery02);
							}
							if(objOtKind01!=null && context.field == 'OT_KIND_01'){
								return false;
							}
						}
	                },
	                onOtKindChange:function(field, newValue, oldValue)	{
                		var store01 = Ext.StoreManager.lookup('OT_KIND_STORE');
                		var grid = Ext.getCmp('otKindGrid');
                		var otKind01Record = grid.getSelectedRecord();//store01.getAt(0);
                		if(otKind01Record) otKind01Record.set("OT_KIND_02", '');
                	},
	                onBeforequery02:function( queryPlan, eOpts ) {
	                	var store = queryPlan.combo.getStore();
	            		var grid = Ext.getCmp('otKindGrid');
	            		var store01 = Ext.StoreManager.lookup('OT_KIND_STORE');
	            		var otKind01Record = grid.getSelectedRecord();//store01.getAt(0);
	            		var otKind01 = (otKind01Record) ? otKind01Record.get("OT_KIND_01"):'';
	            		var orgStore = Ext.StoreManager.lookup("OT_KIND_02_STORE");
	            		if(!Ext.isEmpty(otKind01))	{
	            			var items = Ext.Array.push(orgStore.data.filterBy(function(record) {return (record.get('refCode1')== otKind01 ) } ).items);
							store.loadData(items);
	            		}else {
	            			store.loadData(orgStore.data);
	            		}
	            		/*
	            		   store.clearFilter();
	            		   store.addFilter([new Ext.util.Filter({
						    property: 'refCode1',
							value   : otKind01
	            		   }
						)]);	*/
						//console.log(" store OT_KIND_02_STORE : ", store.getData());
	            	}
            },{
              xtype: 'uniGridPanel',
                  padding: '0 0 0 10',
                  width: 200,
                  height: 300,
                  itemId: 'grid_H0018',
                  store : hbs020ukrs15Store_H0018,
                  selModel:'rowmodel',
                  uniOpt: {
                  	   userToolbar:false,
                       expandLastColumn: false,
                       useRowNumberer: true,
                       useMultipleSorting: false,
                       state: {
							useState: false,
							useStateList: false
						}
                  },
                  columns: [
                     {dataIndex: 'GUBUN', hidden: true},
		    		 {dataIndex: 'CODE_NAME',  flex:1},
		    		 {dataIndex: 'WAGES_NAME', hidden: true},
		    		 {dataIndex: 'WAGES_CODE', hidden: true},
		    		 {dataIndex: 'TABLE_dataIndex', hidden: true},
		    		 {dataIndex: 'WHERE_COLUMN', hidden: true},
		    		 {dataIndex: 'TYPE', hidden: true},
		    		 {dataIndex: 'SELECT_SYNTAX', hidden: true},
		    		 {dataIndex: 'UNIQUE_CODE', hidden: true},
		    		 {dataIndex: 'CHOICE', hidden: true},
		    		 {dataIndex: 'SEQ', hidden: true}
                  ],
                  listeners: {
			            cellclick: function(table, td, cellIndex, record) {
			            	treatCalcArea(record.data.CODE_NAME);
			            }
		          }
            },{
               xtype: 'uniGridPanel',
                  padding: '0 0 0 10',
                  width: 200,
                  height: 300,
                  itemId: 'grid_H0019',
                  selModel:'rowmodel',
                  store : hbs020ukrs15Store_H0019,
                  uniOpt: {
                  	   userToolbar:false,
                       expandLastColumn: false,
                       useRowNumberer: true,
                       useMultipleSorting: false,
                       state: {
							useState: false,
							useStateList: false
						}
                  },
                  columns: [
                     {dataIndex: 'GUBUN', hidden: true},
		    		 {dataIndex: 'WAGES_NAME',  flex:1},
		    		 {dataIndex: 'WAGES_CODE', hidden: true},
		    		 {dataIndex: 'TABLE_dataIndex', hidden: true},
		    		 {dataIndex: 'WHERE_COLUMN', hidden: true},
		    		 {dataIndex: 'TYPE', hidden: true},
		    		 {dataIndex: 'SELECT_SYNTAX', hidden: true},
		    		 {dataIndex: 'UNIQUE_CODE', hidden: true},
		    		 {dataIndex: 'CHOICE', hidden: true},
		    		 {dataIndex: 'SEQ', hidden: true}
                  ],
                  listeners: {
			            cellclick: function(table, td, cellIndex, record) {
			            	treatCalcArea(record.data.WAGES_NAME);
			            }
		          }
            },{
               xtype: 'uniGridPanel',
                  padding: '0 0 0 10',
                  width: 200,
                  height: 300,
                  itemId: 'grid_H0020',
                  selModel:'rowmodel',
                  store : hbs020ukrs15Store_H0020,
                  uniOpt: {
                  	   userToolbar:false,
                       expandLastColumn: false,
                       useRowNumberer: true,
                       useMultipleSorting: false,
                       state: {
							useState: false,
							useStateList: false
						}
                  },
                  columns: [
                     {dataIndex: 'GUBUN', hidden: true},
		    		 {dataIndex: 'WAGES_NAME',  flex:1},
		    		 {dataIndex: 'WAGES_CODE', hidden: true},
		    		 {dataIndex: 'TABLE_dataIndex', hidden: true},
		    		 {dataIndex: 'WHERE_COLUMN', hidden: true},
		    		 {dataIndex: 'TYPE', hidden: true},
		    		 {dataIndex: 'SELECT_SYNTAX', hidden: true},
		    		 {dataIndex: 'UNIQUE_CODE', hidden: true},
		    		 {dataIndex: 'CHOICE', hidden: true},
		    		 {dataIndex: 'SEQ', hidden: true}
                  ],
                  listeners: {
			            cellclick: function(table, td, cellIndex, record) {
			            	treatCalcArea(record.data.WAGES_NAME);
			            }
		          }
            },{
				xtype: 'container',
				layout: {type: 'uniTable', columns: 1},
		        tdAttrs:{style:'vertical-align:top'},
				items:[{
		            	xtype: 'container',
		            	layout: {type: 'table', columns: 6 , tableAttrs:{style:'margin-top:0px !important'}},
		            	defaults: { xtype: 'button',  margin:'5 5 5 5'  },
						items:[
						{
							text: '7',
							width: 40,
							margin:'0 5 5 5' ,
							handler: function(btn) {
								treatCalcArea(btn.text);
							}
						},{
							text: '8',
							width: 40,
							margin:'0 5 5 5' ,
							handler: function(btn) {
								treatCalcArea(btn.text);
							}
						},{
							text: '9',
							width: 40,
							margin:'0 5 5 5' ,
							handler: function(btn) {
								treatCalcArea(btn.text);
							}
						},{
							text: '/',
							width: 40,
							margin:'0 5 5 5' ,
							handler: function(btn) {
								treatCalcArea(btn.text);
							}
						},{
							text: '(',
							width: 40,
							margin:'0 5 5 5' ,
							handler: function(btn) {
								treatCalcArea(btn.text);
							}
						},{
							text: ')',
							width: 40,
							margin:'0 5 5 5' ,
							handler: function(btn) {
								treatCalcArea(btn.text);
							}
						},{
							text: '4',
							width: 40,
							handler: function(btn) {
								treatCalcArea(btn.text);
							}
						},{
							text: '5',
							width: 40,
							handler: function(btn) {
								treatCalcArea(btn.text);
							}
						},{
							text: '6',
							width: 40,
							handler: function(btn) {
								treatCalcArea(btn.text);
							}
						},{
							text: '*',
							width: 40,
							handler: function(btn) {
								treatCalcArea(btn.text);
							}
						},{
							text: 'if',
							colspan: 2,
							width: 100,
							handler: function(btn) {
								treatCalcArea(btn.text);
							}
						},{
							text: '1',
							width: 40,
							handler: function(btn) {
								treatCalcArea(btn.text);
							}
						},{
							text: '2',
							width: 40,
							handler: function(btn) {
								treatCalcArea(btn.text);
							}
						},{
							text: '3',
							width: 40,
							handler: function(btn) {
								treatCalcArea(btn.text);
							}
						},{
							text: '-',
							width: 40,
							handler: function(btn) {
								treatCalcArea(btn.text);
							}
						},{
							text: '<t:message code="system.label.human.cancel" default="취소"/>',
							colspan: 2,
							width: 100,
							handler: function(btn) {
								treatCalcArea('delete');
							}
						},{
							text: '0',
							width: 40,
							handler: function(btn) {
								treatCalcArea(btn.text);
							}
						},{
							text: '(-)',
							width: 40,
							handler: function(btn) {
								treatCalcArea(btn.text);
							}
						},{
							text: '.',
							width: 40,
							handler: function(btn) {
								treatCalcArea(btn.text);
							}
						},{
							text: '+',
							width: 40,
							handler: function(btn) {
								treatCalcArea(btn.text);
							}
						},{
							text: '<t:message code="system.label.human.cancelall" default="전체취소"/>',
							colspan: 2,
							width: 100,
							handler: function(btn) {
								treatCalcArea('delete all');
							}
						},{
							text: ',',
							width: 40,
							handler: function(btn) {
								treatCalcArea(btn.text);
							}
						},{
							text: '>',
							width: 40,
							handler: function(btn) {
								treatCalcArea(btn.text);
							}
						},{
							text: '<',
							width: 40,
							handler: function(btn) {
								treatCalcArea(btn.text);
							}
						},{
							text: '=',
							width: 40,
							handler: function(btn) {
								treatCalcArea(btn.text);
							}
						},{
							text: '<t:message code="system.label.human.save" default="저장 "/>',
							colspan: 2,
							width: 100,
							handler: function(btn) {
								treatCalcArea('save');
							}
						}]
		            }
				]
			}]
		},{
			xtype: 'uniGridPanel',
            width:1350,
            height: 300,
            id: 'kindFullGrid',
            itemId:'uniGridPanel15',
            margin:'10 10 10 0',
            tdAttrs:{'valign':'top'},
            store : hbs020ukrs15Store,
            selModel:'rowmodel',
            uniOpt: {
            	 userToolbar:false,
                 expandLastColumn: false,
                 useRowNumberer: false,
                 useMultipleSorting: false,
                 state: {
					useState: true,
					useStateList: true
				 }
            },
            columns: [
               {dataIndex: 'SUPP_TYPE', flex: 0.2},
               {dataIndex: 'STD_CODE', flex: 0.2},
               {dataIndex: 'OT_KIND_01_NAME', flex: 0.3},
               {dataIndex: 'OT_KIND_02_NAME', flex: 0.3},
               {dataIndex: 'B', flex: 1},
               {dataIndex: 'UPDATE_TEXT', flex: 1, hidden:true},
               {dataIndex: 'OT_KIND_02_RAW', flex: 1, hidden:true},
               {dataIndex: 'OT_KIND_01_RAW', flex: 1, hidden:true}
            ],
            listeners: {
            	containerclick: function () {
           			selectedGrid = 'kindFullGrid';
           		}, select: function () {
            		selectedGrid = 'kindFullGrid';
            	}, cellclick: function(table, td, cellIndex, record) {

            				Ext.getCmp('CHK_TXT').setValue('');
							var otKind01Data = record.data.OT_KIND_01_RAW;
	  						var otKind02Data = record.data.OT_KIND_02_RAW;

							Ext.getCmp('OTKIND1_TXT').setValue(otKind01Data);
							Ext.getCmp('OTKIND2_TXT').setValue(otKind02Data);

	              	  		var combo2 = Ext.getCmp('STD_CODE2');

            				combo2.setValue( record.data.STD_CODE);
	  						var updText = record.data.UPDATE_TEXT;

            				Ext.getCmp('CALC_TXT').setValue(record.data.B);
            				Ext.getCmp('UPDATE_TXT').setValue('');
            				Ext.getCmp('UPDATE_TXT').setValue(updText.slice(0,-1));
							var  otKind01Data = Ext.getCmp('OTKIND1_TXT').getValue();
							var  otKind02Data = Ext.getCmp('OTKIND2_TXT').getValue();
							otKind01Data = otKind01Data.slice(0,-1);
							otKind02Data = otKind02Data.slice(0,-1);
							var  otKind01Array = otKind01Data.split('/') ;
							var  otKind02Array = otKind02Data.split('/') ;
							var  grid = Ext.getCmp('otKindGrid');
							var  otKindStore  =  Ext.StoreManager.lookup("OT_KIND_STORE");
					  		var  records		=  otKindStore.data.items;
					  		var orgStore = Ext.StoreManager.lookup("OT_KIND_02_STORE");
					  		var comboStore ;

							if( grid.getColumns()[2].editor != null ){

								 comboStore = grid.getColumns()[2].editor.orderedTriggers[0].field.store;

							}else{

								 comboStore = grid.getColumns()[2].field.store;

							}

							Ext.each(records, function(item, i){
								var items = Ext.Array.push(orgStore.data.filterBy(function(record) {return (record.get('refCode1')== item.get('OT_KIND_01') ) } ).items);
								comboStore.loadData(items);
									for(var j=0; j < otKind01Array.length; j++){
										//alert(j + '/' + item.get("OT_KIND_01") + '/' + otKind01Array[j] + '/' + otKind02Array[j] + i);
										if(item.get("OT_KIND_01") == otKind01Array[j]){

											item.set("OT_KIND_02",otKind02Array[j]);

										}
									}
							})

			    },
	            onGridDblClick:function(grid, record, cellIndex, colName)	{
	            	if(colName == "B")	{
	            		var BWin = Ext.getCmp("BWin");

			            if(!BWin)	{
			            		BWin = Ext.create('widget.uniDetailWindow', {
					                title: '<t:message code="system.label.human.formula" default="공식"/>',
					                width: 800,
					                height:150,
					            	id:'BWin',
					                layout: {type:'vbox', align:'stretch'},
					                bodyStyle:{
					                	'background-color':'white',
					                	'margin':'0px'
					                },
					                items: [{
						                	itemId:'formula',
						                	xtype:'component',
						                	height:'100',
						                	style:{
							                	'margin':'10px',
							                	'background-color':'white'
							                },
						                	html:'<div></div>'
					               		}
									],
					                tbar:  [
								         '->',{
											itemId : 'closeBtn',
											text: '<t:message code="system.label.human.close" default="닫기"/>',
											handler: function() {
												BWin.hide();
											},
											disabled: false
										}
								    ],
									listeners : {beforehide: function(me, eOpt)	{
													BWin.down('#formula').setHtml("<div><div>");
					                			},
					                			 beforeclose: function( panel, eOpts )	{
													BWin.down('#formula').setHtml("<div><div>");
					                			},
					                			 show: function( panel, eOpts )	{
					                			 	BWin.down('#formula').setHtml(BWin.record.get("B"));
					                			 }
					                }
								});
					    }
					    BWin.record = record;
						BWin.center();
						BWin.show();

	            	}
	            }
            }
       }]
	}