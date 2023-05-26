<%@page language="java" contentType="text/html; charset=utf-8"%>
	{
		title:'계산식등록',
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
				fieldLabel: '급/상여구분',
				name: 'SUPP_TYPE',
				id: 'SUPP_TYPE', 
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'H032',
				allowBlank:false,
				value:'1',
				listeners: {
	              select: function(combo, records){
	              	  var combo1 = Ext.getCmp('STD_CODE1');
	              	  var combo2 = Ext.getCmp('STD_CODE2');
	              	  // data clear
	              	  combo1.getStore().removeAll();
              	  	  combo2.getStore().removeAll();
              	  	  if (combo1.getValue() != '' || combo2.getValue() != '') {
              	  	  	  combo1.setValue('');
              	  	  	  combo2.setValue('');
              	  	  }
/* 	              	  if ((records[0].data.value != 'L') && (records[0].data.value != 'M')) { 
	              	  	  hbs020ukrs15ComboStore.load( {params: { comboCode: records[0].data.value }} );	              	  	  
	              	  	  combo1.bindStore(hbs020ukrs15ComboStore);
	              	  	  combo2.bindStore(hbs020ukrs15ComboStore);
 	              	  }  
 	              	  else { 
 	              	  	  // L,M  Do something?? 
 						  console.log('L or G selected'); 
 	              	  } */
	              }
	            }      
			},{
				fieldLabel: '지급/공제코드',
				name: 'STD_CODE',
				id: 'STD_CODE1',
				xtype: 'uniCombobox'
			}]			
		},{
			xtype: 'box',
   			autoEl: {tag: 'hr'},
            width: 1350
		},{
			xtype: 'uniDetailFormSimple',
			items:[{
				fieldLabel: '지급/공제코드',
				name: 'STD_CODE',
				id: 'STD_CODE2',
				xtype: 'uniCombobox',
				width: 230,
				listeners: {
	              select: function(combo, records){
		              Ext.getCmp('CALC_TITLE').setValue(records[0].data.text);
		              Ext.getCmp('CALC_TXT').setValue('');
		              hbs020ukrs15ComboStore2.loadStoreRecords();
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
				xtype: 'uniTextfield',
				name: 'CALC_TXT',
				id: 'CALC_TXT',
				width: 1080,		        					
				readOnly:true
			}]			
		}/*,{
			xtype: 'container',
			layout: {type: 'table', columns:4},
			padding: '10 0 0 0',
			items:[{
               xtype:  'displayfield', 
               value:"<font color='blue'>▒ 계산식분류  ▒</font>",
               //padding: '0 0 0 180',
               width: 120
            },{
               xtype:  'displayfield', 
               value:"<font color='blue'>▒ 근태  ▒</font>",
               //padding: '0 0 0 270',
               width: 80
            },{
               xtype:  'displayfield', 
               value:"<font color='blue'>▒ 지급  ▒</font>",
               //padding: '0 0 0 220',
               width: 80
            },{
               xtype:  'displayfield', 
               value:"<font color='blue'>▒ 기타  ▒</font>",
               //padding: '0 0 0 220',
               width: 80
            }]			
		}*/,{
			xtype: 'container',
			layout: {type: 'uniTable', columns: 4},
			//padding: '0 0 0 0',
			defaults:{padding: '0 0 0 10'},
			flex: 1,
			items:[
			{
               //xtype:  'displayfield', 
               //value:"<font color='blue'>▒ 계산식분류  ▒</font>",
			   xtype:'component',
			   html:"<font color='blue'>&nbsp;▒ 계산식분류  ▒</font>",
               width:440,
               height:20
            },{
               //xtype:  'displayfield', 
               //value:"<font color='blue'>▒ 근태  ▒</font>",
               xtype:'component',
			   html:"<font color='blue'>&nbsp;▒ 근태 ▒</font>",
               width:300
            },{
               //xtype:  'displayfield', 
               //value:"<font color='blue'>▒ 지급  ▒</font>",
               xtype:'component',
			   html:"<font color='blue'>&nbsp;▒ 지급  ▒</font>",
               width:300
            },{
               //xtype:  'displayfield', 
               //value:"<font color='blue'>▒ 기타  ▒</font>",
               xtype:'component',
				html:"<font color='blue'> &nbsp;▒ 기타  ▒</font>",
               width:300
            },{
				xtype: 'container',
				layout: {type: 'uniTable', columns: 1},
				
				items:[
					{
	                  xtype: 'uniGridPanel',
	                  width: 440,
	                  height: 210,
	                  id: 'kindGrid',
	                  margin:'0 0 0 0',
	                  tdAttrs:{'valign':'top'},
	                  store : hbs020ukrs15ComboStore2,
	                  selModel:'rowmodel',
	                  uniOpt: {
                  	   	   userToolbar:false,
	                       expandLastColumn: false,
	                       useRowNumberer: false,
	                       useMultipleSorting: false,
	                       state: {
								useState: false,
								useStateList: false
							}
	                  },            
	                  columns: [
	                  	 {dataIndex: 'OT_KIND_01', hidden: true},
	                     {dataIndex: 'OT_KIND_01_NAME', flex: 0.4, editor:
                            {
                                xtype: 'combobox',
                                store: 'hbs020ukrs15ComboStore3',
                                displayField : 'OT_KIND_01_NAME',
                                valueField : 'OT_KIND_01',
                                hiddenName: 'OT_KIND_01',
                                lazyRender: true,
                                listeners: {
                                	blur: function(me) {
                                		console.log(me);
                                		var grid = Ext.getCmp('kindGrid');
                                		var selectedRecord = grid.getSelectionModel().getSelection()[0];
										var row = grid.store.indexOf(selectedRecord);
                                		searchField[row] = me.displayTplData[0].OT_KIND_01;
//                                 		hbs020ukrs15ComboStore4.loadStoreRecords(searchField); 
                                	}
                                }
                            },
                            renderer: function(value) {
                            	var regExp = /[ㄱ-ㅎ|ㅏ-ㅣ|가-힣]/;
                            	if (regExp.test(value)) return value;
                            	
							    var record = hbs020ukrs15ComboStore3.findRecord('OT_KIND_01', value);
							    if (record == null || record == undefined ) {
									return '';
								} else {
									return record.data.OT_KIND_01_NAME
								}
							}
	                     },
	                     {dataIndex: 'OT_KIND_02', hidden: true},
	                     {dataIndex: 'OT_KIND_02_NAME', flex: 1, editor:
                            {
                                xtype: 'combobox',
                                store: Unilite.createStore('hbs020ukrs15ComboStore4',{
		                            autoLoad: false,
							        fields: [
							                {name: 'SUB_CODE', type : 'string'}, 
								    		{name: 'CODE_NAME', type : 'string'} 
							                ],
							        uniOpt : {
							        	isMaster: false,			// 상위 버튼 연결 
							        	editable: false,			// 수정 모드 사용 
							        	deletable:false,			// 삭제 가능 여부 
							         	useNavi : false			// prev | next 버튼 사용
							        },
							        proxy: {
//<!-- 							            type: 'direct', -->
//<!-- 							            api: { -->
//<!-- 							            	   read : 'hbs020ukrService.tab15_GetComboData3' -->
//<!-- 							            } -->
											type: 'ajax', 
            								url: CPATH+'/human/hbs020ukrGetComboData3.do'//,
//<!--             								extraParams:{SEARCH_FIELD : searchField} -->
							        }
		                        }),
//<!--                                 store: 'hbs020ukrs15ComboStore4', -->
                                lazyRender: true,
                                displayField : 'CODE_NAME',
                                valueField : 'SUB_CODE',
                                hiddenName: 'SUB_CODE',
                                hiddenValue: 'SUB_CODE',
						        listeners: {
					        		focus: function(combo) {
//<!-- 					        				combo.getStore().getProxy().setUrl(CPATH+'/human/hbs020ukrGetComboData3.do?SEARCH_FIELD='+searchField); -->
											var grid = Ext.getCmp('kindGrid');
	                                		var selectedRecord = grid.getSelectionModel().getSelection()[0];
											var row = grid.store.indexOf(selectedRecord);
											combo.getStore().getProxy().url = CPATH+'/human/hbs020ukrGetComboData3.do?SEARCH_FIELD='+searchField[row];
											combo.getStore().load();
					        		}			        		
					        	}
                            },
                            renderer: function (value) {
                            	var record = Ext.getStore('hbs020ukrs15ComboStore4').findRecord('SUB_CODE', value);
								if (record == null || record == undefined ) {
									return '';
								} else {
									return record.data.CODE_NAME
								}
                            }
	                     }
	                  ],
	                  listeners: {
	                  	containerclick: function () {
                  			selectedGrid = 'kindGrid';
                  		}, select: function () {
	                  		selectedGrid = 'kindGrid';
	                  	}
	                  }                  
		            },{
		            	xtype: 'container',
		            	layout: {type: 'table', columns: 6},
		            	defaults: { xtype: 'button' },		            	
						items:[
						{
							text: '7',
							width: 40,
							margin: '0 0 0 20',
							handler: function(btn) {
								treatCalcArea(btn.text);
							}
						},{
							text: '8',
							width: 40,
							margin: '0 0 0 20',
							handler: function(btn) {
								treatCalcArea(btn.text);
							}
						},{
							text: '9',
							width: 40,
							margin: '0 0 0 20',
							handler: function(btn) {
								treatCalcArea(btn.text);
							}
						},{
							text: '/',
							width: 40,
							margin: '0 0 0 20',
							handler: function(btn) {
								treatCalcArea(btn.text);
							}
						},{
							text: '(',
							width: 40,
							margin: '0 0 0 20',
							handler: function(btn) {
								treatCalcArea(btn.text);
							}
						},{
							text: ')',
							width: 40,	
							margin: '0 0 0 20',
							handler: function(btn) {
								treatCalcArea(btn.text);
							}
						},{
							text: '4',
							width: 40,
							margin: '0 0 0 20',
							handler: function(btn) {
								treatCalcArea(btn.text);
							}
						},{
							text: '5',
							width: 40,
							margin: '0 0 0 20',
							handler: function(btn) {
								treatCalcArea(btn.text);
							}
						},{
							text: '6',
							width: 40,
							margin: '0 0 0 20',
							handler: function(btn) {
								treatCalcArea(btn.text);
							}
						},{
							text: '*',
							width: 40,
							margin: '0 0 0 20',
							handler: function(btn) {
								treatCalcArea(btn.text);
							}
						},{
							text: '취&nbsp;&nbsp;&nbsp;&nbsp;소',
							colspan: 2,
							width: 100,
							margin: '0 0 0 20',
							handler: function(btn) {
								treatCalcArea('delete');
							}
						},{
							text: '1',
							width: 40,
							margin: '0 0 0 20',
							handler: function(btn) {
								treatCalcArea(btn.text);
							}
						},{
							text: '2',
							width: 40,
							margin: '0 0 0 20',
							handler: function(btn) {
								treatCalcArea(btn.text);
							}
						},{
							text: '3',
							width: 40,
							margin: '0 0 0 20',
							handler: function(btn) {
								treatCalcArea(btn.text);
							}
						},{
							text: '-',
							width: 40,
							margin: '0 0 0 20',
							handler: function(btn) {
								treatCalcArea(btn.text);
							}
						},{
							text: '전체취소',
							colspan: 2,
							width: 100,
							margin: '0 0 0 20',
							handler: function(btn) {
								treatCalcArea('delete all');
							}
						},{
							text: '0',
							width: 40,
							margin: '0 0 0 20',
							handler: function(btn) {
								treatCalcArea(btn.text);
							}
						},{
							text: '(-)',
							width: 40,
							margin: '0 0 0 20',
							handler: function(btn) {
								treatCalcArea(btn.text);
							}
						},{
							text: '.',
							width: 40,
							margin: '0 0 0 20',
							handler: function(btn) {
								treatCalcArea(btn.text);
							}
						},{
							text: '+',
							width: 40,
							margin: '0 0 0 20',
							handler: function(btn) {
								treatCalcArea(btn.text);
							}
						},{
							text: '저&nbsp;&nbsp;&nbsp;&nbsp;장',
							colspan: 2,
							width: 100,
							margin: '0 0 0 20',
							handler: function(btn) {
								treatCalcArea('save');
							}
						}]
		            }
				]
			},{
              xtype: 'uniGridPanel',
                  padding: '0 0 0 10',
                  width: 300,
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
                  width: 300,
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
                  width: 300,
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
            }]			
		},{
			xtype: 'uniGridPanel',
            width:1350,
            height: 300,
            id: 'kindFullGrid',
            margin:'0 0 10 0',
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
               {dataIndex: 'OT_KIND_01', flex: 0.3},
               {dataIndex: 'OT_KIND_02', flex: 0.3},
               {dataIndex: 'B', flex: 1}              
            ],
            listeners: {
            	containerclick: function () {
           			selectedGrid = 'kindFullGrid';
           		}, select: function () {
            		selectedGrid = 'kindFullGrid';
            	}
            }                 
       }]
	}