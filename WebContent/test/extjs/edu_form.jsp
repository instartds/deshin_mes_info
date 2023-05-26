<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="bcm100ukrv"  >
<t:ExtComboStore comboType="AU" comboCode="B015" />  <!--  거래처구분    -->  
<t:ExtComboStore comboType="AU" comboCode="B010" />  <!--  거래처구분    -->  

</t:appConfig>
<script type="text/javascript" >
var tV = {'startYear':2011, 'endYear':2012};
var lHidden = false;
var toolbar = {
	        xtype: 'toolbar',
	        dock: 'top',
	        items: [{
	            text: 'setValue'
	            , handler : function() { 
					var frm = Ext.getCmp('testForm');
					if(!lHidden){
						frm.setValue('RDO1','4');
						frm.setValue('RDO2','4');
						frm.setValue('COMBO','4');
					}else{
						frm.setValue('RDO1','1');
						frm.setValue('RDO2','1');
						frm.setValue('COMBO','1');
					}
					lHidden = !lHidden;
	            }
	        }, {
	            text: 'clear',
	            handler : function() { 
					var frm = Ext.getCmp('testForm');
					frm.clearForm();
	            }
	        }, {
	            text: 'setLabel',
	            handler : function() { 
					var fieldTxt1 = Ext.getCmp('uniCheckboxgroup');
					if(!lHidden){
	                    fieldTxt1.setFieldLabel('LabelTest');
					}else{
						fieldTxt1.setFieldLabel('uniCheckboxgroup');
					}					
					lHidden = !lHidden;
	               
	            }
	        }, {
	            text: 'Show&Hide(uniDisplay)'
	            , handler : function() { 
					var frm = Ext.getCmp('testForm');
	            	var field = frm.getField('TEXTBOX1');
	            	field.uniSetDisplayed(lHidden);
	            	lHidden = !lHidden;
	            }
	        }, {
	            text: 'Show&Hide(visible)'
	            , handler : function() { 
					var frm = Ext.getCmp('testForm');
	            	var field = frm.getField('TEXTBOX1');
	            	field.setVisible(lHidden);
	            	lHidden = !lHidden;
	            }
	        }, {
	            text: 'setReadOnly',
	            handler : function() { 
					var frm = Ext.getCmp('testForm');
	            	var field = frm.getField('TEXTBOX1');
	            	if(!lHidden){
	            		field.setReadOnly(lHidden);
	            	}else{
	            		field.setReadOnly(lHidden);
	            	}
	            	lHidden = !lHidden;
	            }
	        }]
        }
	            
	            
Ext.onReady(function() {
	
	var testForm = Ext.create('Unilite.com.form.UniDetailForm', {
		id:'testForm',
		title: 'Form Test',
		layout: { type: 'uniTable',
				columns : 1,
				tableAttrs: {style: {width:1000}},
				tdAttrs : { style: {'border':'1px solid #f00' }}
		},
		fieldDefaults : {
			labelAlign : 'right',
			labelSeparator : ":"
		},	
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
        	
        	afterrender : function() {
        		this.setDisabled( false );
        	},
        	dirtychange: function( form, dirty, eOpts) {
        		console.log(">>> form dirtychange dirty = " , dirty, "<<<<<");
        	}
        },
        
        dockedItems :[toolbar],
        
        defaultType: 'uniTextfield',
        items: [{
        	xtype: 'uniCheckboxgroup',
        	fieldLabel: 'uniCheckboxgroup',        	
        	id:	'uniCheckboxgroup',
        	width: 400,
        	name: 'CHECK1',
        	items: [{
        		boxLabel: '체크1',
	        	inputValue: '1',	// 쿼리로 전송되는 실제value값	        	
	        	name: 'CHECK1',		// 데이터 전송될때의  파라미터 name
	        	checked: true
	        },{
        		boxLabel: '체크2',
	        	inputValue: '2',
	        	name: 'CHECK1',
	        	checked: true
	        },{
        		boxLabel: '체크3',
	        	inputValue: '3',
	        	name: 'CHECK1'
	        },{
        		boxLabel: '체크4',
	        	inputValue: '4',
	        	name: 'CHECK1'
	        }]
	        
        }, {
        	xtype: 'uniRadiogroup',
        	fieldLabel: 'uniRadiogroup',
        	id:	'uniRadiogroup1',
        	layout: 'vbox',
	        items: [{
	        	boxLabel: '라디오1',
	        	inputValue: '1',
	        	name: 'RDO1',	        	
	        	width: 70,	        	
	        	checked: true	        	
	        }, {
	        	boxLabel: '라디오2',
	        	inputValue: '2',
	        	name: 'RDO1',	        	
	        	width: 70
	        }, {
	        	boxLabel: '라디오3',	        	
	        	inputValue: '3',
	        	name: 'RDO1',
	        	width: 70
	        }, {
	        	boxLabel: '라디오4',
	        	inputValue: '4',
	        	name: 'RDO1'
	        }
	        ]
        }, {
        	xtype: 'uniRadiogroup',
        	fieldLabel: 'uniRadiogroup',
        	id:	'uniRadiogroup2',
        	comboType: 'AU',
        	comboCode: 'B015',
        	name: 'RDO2',			//폼안에 있는 모든 라디오그룹은 name값으로 움직인다. 위의 name과 종복되지 않게 해야한다 
        	width: 400
        }, {
        	xtype: 'uniCombobox',
        	fieldLabel: 'uniCombobox',
        	name: 'COMBO',
        	id: 'uniCombobox',
        	comboType: 'AU',
        	comboCode: 'B015',        	
        	value: '1'
        }, {
			xtype : 'uniDatefield',
			fieldLabel: 'uniDatefield', 
			name: 'DATE',
			value: new Date()
		}, {			
			xtype: 'uniDateRangefield',
			fieldLabel: 'uniDateRangefield',
			startFieldName: 'ORDER_DATE_FR',
			endFieldName: 'ORDER_DATE_TO',			
			width: 335,
			startDate: UniDate.get('startOfMonth'),
			endDate: UniDate.get('today')
		}, {
			xtype: 'uniTextfield',
			fieldLabel: 'uniTextfield',
			name: 'TEXTBOX1',
			id: 'TEXTBOX1'
		}, {			
			fieldLabel: 'uniTextfield2',
			name:'TEXTBOX2'
		}, {
			xtype: 'uniNumberfield',
			fieldLabel: 'uniNumberfield',
			name:'NUMBER',
			suffixTpl:'원'
		}, {
			xtype: 'numberfield',
			fieldLabel: 'numberfield',
			name: 'UN2',			
			value:12345.67,
			allowBlank:false
		}, {
	        xtype: 'hiddenfield',
	        fieldLabel: 'hiddenfield',
	        name: 'HIDDEN_FIELD',
	        value: 'value from hidden field'
		}, {
	        xtype     : 'textareafield',
	        name      : 'TEXT_AREA_FIELD',
	        fieldLabel: 'Message',
	        anchor    : '100%'
		}, {
			xtype:'container',
			contentEl: 'contentElTest'
		}]
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
<button id="d_clip_button""><b>Copy To Clipboard...</b></button></p>"
<div id='contentElTest' class='x-hide-display' align='right' style='margin-top:2px'>
<div style='font-weight:bold; color:blue;'>※ 부가세 별도</div>

