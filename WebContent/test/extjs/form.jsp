<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="bcm100ukrv"  >
<t:ExtComboStore comboType="AU" comboCode="B015" />  <!--  거래처구분    -->  
<t:ExtComboStore comboType="AU" comboCode="B010" />  <!--  거래처구분    -->  

</t:appConfig>
<script type="text/javascript" >
var tV = {'startYear':2011, 'endYear':2012};
var lHidden = true;
var toolbar = {
	        xtype: 'toolbar',
	        dock: 'top',
	        items: [{
	            text: 'togleReadonly'
	            , handler : function() { 
					var frm = Ext.getCmp('testForm').getForm();
					var fields = frm.getFields();
					Ext.each(fields.items, function(item) {
						if(item.xtype && item.xtype=="uniRadiogroup" ){
							console.log('uniRG');
						}
						if(item.ownerCt && ( item.ownerCt.xtype=="uniRadiogroup" || item.ownerCt.xtype=="uniCheckboxgroup" )  ) {
							console.log('Radio or uniCheckboxgroup ', item.readOnly, item.ownerCt.readOnly);
						} else {
							item.setReadOnly(!item.readOnly);
						}
					});
					
//						}
//					var field = frm.findField('txtName');
//					field.setReadOnly(!field.readOnly);
//					if(field.readOnly) {
//						field.inputEl.addCls('readOnly');
//					} else {
//						field.inputEl.removeCls('readOnly');
//					}
//					
//					console.log("Togglr ", field.readOnly, " - ", field.readOnly, field.inputEl.dom.readOnly);
					
				}
	        },{
	            text: 'new( loadRecord)'
	            , handler : function() { 
	            	var rec = Ext.create ('bcm100ukrvModel');
					var frm = Ext.getCmp('testForm');
					frm.reset();
					console.log( ">>> beforeloadRecord");
					frm.loadRecord(rec);
					console.log( "<<< beforeloadRecord");
					var dat =  frm.getValues();
					console.log( "RECORD:", dat);
	            }
	        },{
	            text: 'new(setActiveRecord)'
	            , handler : function() { 
	            	var rec = Ext.create ('bcm100ukrvModel');
					var frm = Ext.getCmp('testForm');
					frm.setActiveRecord(rec);
					var dat =  frm.getValues();
					console.log( "NEW:", dat);
	            }
	       
	        },{
	            text: 'setValue'
	            , handler : function() { 
	            	var rec =  Ext.create ('bcm100ukrvModel');
					var frm = Ext.getCmp('testForm');
					frm.setValues(tV);
					frm.setValue('timein','2330');
					frm.setValue('com1','2');
					frm.setValue('rdo1','2');
					frm.setValue('rdo2','3');
					frm.setValue('chk1', ['3','4'] );
	            }
	        },{
	            text: 'setValue(ext)'
	            , handler : function() { 
	            	
					var f, frm = Ext.getCmp('testForm');
					//frm.setValues({'com1':'1'});
					//frm.setValues({'rdo1':'1'});
					//frm.setValues({'chk1':'1'});
					frm.setValues(tV);
					frm.setValue('com1','3');
					
					f=frm.getField('rdo1');
					f.setValue({'rdo1':'4'});
					frm.setValues({'rdo2':'4'});
					
					f=frm.getField('timein');
					f.setValue(UniDate.extSafeParse('1000','Hi'));
					//f.fireEvent('change', f, '10:00');
					
					f=frm.getField('chk1');
					f.setValue({'chk1[]':['2','3']});
	            }
	         },{
	            text: 'submit'
	            , handler : function() { 
					var frm = Ext.getCmp('testForm').getForm();
					var dat =  frm.getValues();
					console.log( "submit", dat);
	            }
	        },{
	            text: 'check Mandatory'
	            , handler : function() { 
					var frm = Ext.getCmp('testForm');
					var rv =  frm.checkManadatory(['startYear', 'endYear']);
					console.log( "checkManadatory", rv);
	            }
	        },{
	            text: 'reset'
	            , handler : function() { 
					var frm = Ext.getCmp('testForm');
					frm.getForm().reset(true);
					//frm.clearForm();
	            }
	        }, {
	        	text: '바로가기'
	            , handler : function() { 
					makeLink();
					//frm.clearForm();
	            }
	        },{
	            text: 'Show&Hide(uniDisplay)'
	            , handler : function() { 
					var frm = Ext.getCmp('testForm');
	            	var field = frm.getField('startYear');
	            	field.uniSetDisplayed(lHidden);
	            	lHidden = !lHidden;
	            }
	        },{
	            text: 'Show&Hide(visible)'
	            , handler : function() { 
					var frm = Ext.getCmp('testForm');
	            	var field = frm.getField('endYear');
	            	field.setVisible(lHidden);
	            	lHidden = !lHidden;
	            }
	        }
	        
	        ]
        };
	            
	            
Ext.onReady(function() {
	Unilite.defineModel('bcm100ukrvModel', {
	    fields: [ 	 {name: 'startYear' 		,text:'시작년도' 		,type:'uniYear'	,defaultValue:'2012'	,allowBlank:false}
					,{name: 'endYear' 			,text:'종료년도' 		,type:'uniYear'	,defaultValue:'2015' , comboType:'AU',comboCode:'B015' ,allowBlank: false}
					,{name: 'timein' 			,text:'Time In' 		,type:'uniTime'	,allowBlank:false, defaultValue:'0100'}
					,{name: 'un' 				,text:'uniNumber' 		,type:'uniNumber'	,defaultValue:123}
					,{name: 'uniPercent' 				,text:'uniPercent' 		,type:'uniPercent'	,defaultValue:123}
					,{name: 'un2' 				,text:'number' 			,type:'number'	}
					,{name: 'ut' 				,text:'uniTextfield' 	,type:'string'	,defaultValue:'기본'}
					,{name: 'txtName' 			,text:'텍스트' 	,type:'string'	,allowBlank:false}
					,{name: 'txtName2' 			,text:'텍스트2' 	,type:'string'	,allowBlank:false}
					,{name: 'endDate' 			,text:'endDate' 	,type:'uniDate'	,allowBlank:false}
					,{name: 'com1' 		,text:'구분' 		,type:'string'	,comboType:'AU',comboCode:'B015', defaultValue:'1'}
					,{name: 'rdo1' 		,text:'rdo1' 		,type:'string'	,comboType:'AU',comboCode:'B015', defaultValue:"2"}
					,{name: 'rdo2' 		,text:'rdo2' 		,type:'string'	,comboType:'AU',comboCode:'B015', defaultValue:'3'}
					,{name: 'chk1' 		,text:'chk1' 		,type:'string'	,comboType:'AU',comboCode:'B015'}
					],
        validations: [
            {type: 'presence', field: 'CUSTOM_CODE'}
        ]
	});//define model
	
	var testForm = Ext.create('Unilite.com.form.UniDetailForm', {
		id:'testForm',
		title: 'Time Card',
		layout: { type: 'uniTable',
				columns : 3,
				tableAttrs: {style: {width:1000}},
				tdAttrs : { style: {'border':'1px solid #f00' }}
		},
		fieldDefaults : {
			labelAlign : 'right',
			labelWidth : 90,
			labelSeparator : "",
		    validateOnChange: false,
	        autoFitErrors: true   //false  //화면 깨짐 
		}	,	
        renderTo: Ext.getBody(),
        defaults : {
        	listeners: {
        		Xchange:function(field, newValue, oldValue, eOpts) {
        			console.log("[change] new : old = ", newValue, oldValue)
        		},
        		uniOnChange:function(field, newValue, oldValue, eOpts) {
        			console.log("[uniOnChange] new : old = ", newValue, oldValue)
        		}
        	}
        },
        
        listeners: {
        	create : function() {
        		
        	},
        	afterrender : function() {
        		this.setDisabled( false );
        	},
        	dirtychange: function( form, dirty, eOpts) {
        		console.log(">>> form dirtychange dirty = " , dirty, "<<<<<");
        	}
        },
        dockedItems :[toolbar],
        items: [{
	              xtype: 'uniYearField',
	              name: 'startYear',
	              id: 'startYear',
	              fieldLabel: '시작년도',
	              // value: new Date().getFullYear()-1,
	              vtype: 'yearRange',
	              anchor: '100%',
		    	  endYearField: 'endYear',
	              validateOnChange: false,
	              validateOnBlur : false
	         },
	         {
	              xtype: 'uniYearField',
	              name: 'endYear',
	              id: 'endYear',
	              fieldLabel: '종료년도',
	              value: new Date().getFullYear(),
	              vtype: 'yearRange',
	              anchor: '100%',
		    	  startYearField: 'startYear'
	         },
	         {
	              xtype: 'uniTimefield',
	              name: 'timein',
	              fieldLabel: 'timein',
	              minValue: '6:00 AM',
	              maxValue: '8:00 PM',
	              increment: 30,
	              anchor: '100%',
	              allowBlank:false
	          },
	          {
	              xtype: 'uniNumberfield',
	              name: 'un',
	              fieldLabel: 'uniNumber',
	              value:12345.67,
	              allowBlank:false,
	              validateOnChange: false,
	              validateOnBlur : false,
	              suffixTpl:'원'
	          },
	          {
	              xtype: 'numberfield',
	              name: 'un2',
	              fieldLabel: 'number',
	              value:12345.67,
	              allowBlank:false,
	              validateOnChange: false,
	              validateOnBlur : false
	          },
	          {
	              xtype: 'uniNumberfield',
	              name: 'uniPercent',
	              decimalPrecision: 2,
	              fieldLabel: 'uniPercent',
	              value: 35.34,
	              allowBlank:false,
	              validateOnChange: false,
	              validateOnBlur : false,
	              suffixTpl:'%'
	          },
	          {
	              xtype: 'uniTextfield',
	              name: 'ut',
	              fieldLabel: 'uniTextfield',
	              value:'12345.67',
	              renderer : Ext.util.Format.numberRenderer('0,000.00'),
	              listeners: {
	              	change : function () {
	              		console.log("change");
	              	}
	              }
	          },
	          {
	              xtype: 'uniTextfield',
	              name: 'txtName',
	              fieldLabel:'텍스트',
	              allowBlank:false,
	              suffixTpl:'원'
	          },
	          {
	              xtype: 'uniTextfield',
	              name: 'txtName2',
	              readOnly:true,
	              fieldLabel:'텍스트2',
	              suffixTpl:'원'
	          },
	         {
	              xtype: 'uniDatefield',
	              name: 'endDate',
	              fieldLabel: '종료일자',
	              anchor: '100%',
	              allowBlank:true,
	              validateBlank: true,
	              validateOnBlur : true
	         }
	         ,{fieldLabel: 'com1',  name: 'com1', xtype: 'uniCombobox', comboType:'AU',comboCode:'B015' ,value:'2',allowBlank: false  } 
	         ,{fieldLabel: 'rdo1(uniRadio)',  name: 'rdo1', xtype: 'uniRadiogroup', comboType:'AU',comboCode:'B015',  allowBlank: false}
	         ,{fieldLabel: 'rdo2',   xtype: 'radiogroup', 
		        items: [
		            { boxLabel: 'V 1', name: 'rdo2', inputValue: '1' },
		            { boxLabel: 'V 2', name: 'rdo2', inputValue: '2' },
		            { boxLabel: 'V 3', name: 'rdo2', inputValue: '3' },
		            { boxLabel: 'V 4', name: 'rdo2', inputValue: '4' }
		        ]
        	 }
        	 ,{fieldLabel: 'chk1',  name: 'chk1', xtype: 'uniCheckboxgroup', width: 230, comboType:'AU',comboCode:'B015', 
        	 	value:['1','2'] , allowBlank: false}
        	 
        	
        	
        	
        	,Unilite.popup('CUST',{fieldLabel: '거래처(P0100)', id:'MANAGE_CUSTOM', valueFieldName:'CUSTOM_CODE', textFieldName:'CUSTOM_NAME', allowBlank: false })						            
			,Unilite.popup('CUST',{fieldLabel: '거래처(P0100)', id:'MANAGE_CUSTOM2', valueFieldName:'CUSTOM_CODE2', textFieldName:'CUSTOM_NAME2',
        							fieldCls :'x-form-field x-form-required-field', validateBlank : false})						            
						       			 
	         ]
	      });
	      
	      
	 Unilite.createValidator('validator01', {
		forms: {'formAX:':testForm},
		validate: function( type, fieldName, newValue, oldValue, record,  eopt) {
			var me = this;
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			switch(fieldName)  {
				case "txtName" :		// 거래처(약명)
					if(newValue == '')	{
						rv = Msg.sMB083;
					}else {
						 record.set('txtName2',newValue);
						
					}
					break;
				
			}
			return rv;
		}
	}); // validator
	
	

}) // onReady
function onQueryButtonDown() {
	var param = Ext.getCmp('searchForm').getValues();
	console.log(param);
}


	var downloadLinkDetail = Ext.create('Unilite.com.form.UniDetailFormSimple', {
	    autoScroll:true,
	    flex: 1,
	    tbar: ['->',
	        { 	xtype: 'button', 
	        	text: '닫기', 
	        	handler: function(btn, evt) {
	        		this.up('.window').close();
	        	}
	        }
        ],
		fieldDefaults: {
			readOnly: true
		},
		layout: {
	    	type:'vbox' , 
       		align: 'stretch'
	    },
		defaultType: 'displayfield',
	    items: [ 
	    	{ value: '아래와 같이 바로가기생성을 원하시면 [생성]버튼을 눌러주세요'},
			{	xtype:'container',	
				margin: '5 0 5 0',
			    layout: {
			        align: 'middle',
			        pack: 'center',
			        type: 'hbox'
			    },
				items: [
					{
						xtype: 'button', text: '생성', 
						handler: function() {        		
		        			this.up('form').getForm().load({
								//params : {'DOC_NO' : this.getValue('DOC_NO')}
							});
		        		}
					},
					{
						contentEl:'d_clip_button'
					}
				]
			},
			{xtype: 'fieldset',
				defaultType: 'displayfield',
				layout: {
			    	type:'uniTable' ,  
			    	columns: 2, 
		        	tableAttrs: {
			            style: {
			                width: '100%'
			            }
			         }
			    },
				items:[
		    		{fieldLabel: '작성자',			name: 'C_OWNER',  value: UserInfo.userName },
		    		{fieldLabel: '다운로드가능기간',name: 'C_EXPIRE_DATE',  value: moment().add(7).format('YYYY.MM.DD')},
		    		{fieldLabel: '바로가기',		name: 'URL',   value:'${controlAction}'}
	    		]
			}
	    ],	    
    	api: {
			load: 'bdc100ukrvService.makeLink'			
		}
	});
	 function makeLink(){
		   	 	var win = Ext.create('widget.window', {
		                title: '바로가기 생성',
					    modal: true,
					    closable: false,
		                header: {
		                    titlePosition: 2,
		                    titleAlign: 'left'
		                },
		                closeAction: 'hide',
		                width: 500,				                
		                height: 200,
		                layout: {
		                    type: 'fit',
		                    padding: 0
		                },		         
		                items: [downloadLinkDetail]
					})
					win.show();
					
					if(clipper == undefined) {
							clipper = new ZeroClipboard(document.getElementById('d_clip_button'));
							clipper.on( 'ready', function(event) {
								console.log( 'movie is loaded' );
								clipper.on( 'copy', function(event) {
									console.log( 'copied' );
						          	event.clipboardData.setData('text/plain',"lkasjdlasjdlkjsd");
						        } );
							});// clipper.on
							
							clipper.on( 'error', function(event) {
						        console.log( 'ZeroClipboard error of type "' + event.name + '": ' + event.message );
						        ZeroClipboard.destroy();
						     } );
					}
		   }



	
</script>
<button id="d_clip_button""><b>Copy To Clipboard...</b></button></p>
