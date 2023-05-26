<%@page language="java" contentType="text/html; charset=utf-8"%>
    <t:appConfig pgmId="s_biv121rkrv_kd"  >
    <t:ExtComboStore comboType="BOR120" pgmId="s_biv121rkrv_kd"/>               <!-- 사업장 -->
    <t:ExtComboStore comboType="AU" comboCode="B020" />                         <!-- 품목계정 -->
    <t:ExtComboStore items="${COMBO_WH_LIST}"       storeId="whList" />         <!-- 창고-->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >

function appMain() {

	var panelResult = Unilite.createSearchForm('resultForm', {
    	region: 'center',
		layout : {type : 'uniTable', columns : 1},
		padding:'1 1 1 1',
		border:true,
		items: [{	    
	    	fieldLabel: '사업장',
	    	name:'DIV_CODE',
	    	xtype: 'uniCombobox', 
	    	comboType:'BOR120', 
	    	allowBlank:false,
	    	value: UserInfo.divCode,
            colspan:2
    	},{
            fieldLabel: '창고',
            name:'WH_CODE',
            xtype: 'uniCombobox',
            store: Ext.data.StoreManager.lookup('whList'),
            allowBlank: false,
            colspan:2
        },{
			fieldLabel: '품목계정',
			name:'ITEM_ACCOUNT',
			xtype: 'uniCombobox',
			comboType:'AU',
			comboCode:'B020',
            allowBlank: false,
            colspan:2
		},{
            xtype:'uniDatefield',           //필드 타입
            fieldLabel: '재고조사기준일',
            name: 'DATE1',             //Query mapping name
            value: UniDate.get('today'),    //화면 open시 Default되어 보여질 값
            allowBlank:false,
            colspan:2
        },{
            xtype:'uniDatefield',           //필드 타입
            fieldLabel: '재고조사일자',
            name: 'DATE2',             //Query mapping name
            value: UniDate.get('today'),    //화면 open시 Default되어 보여질 값
            allowBlank:false,
            colspan:2
        },{
			xtype: 'radiogroup',
			fieldLabel:'양식',
			items: [{
				boxLabel: '양식', 
				name: 'STYLE_CODE',
				inputValue: '1', 
				width:90,
				checked: true  
			},{
				boxLabel : '빈양식', 
				name: 'STYLE_CODE',
				inputValue: '2', 
				width:100
			}],
			listeners: {
                change: function(field, newValue, oldValue, eOpts) {
                	if(newValue.STYLE_CODE == "1"){
                		panelResult.setValue('START_NUM',0);
                		panelResult.setValue('PAGE_Q',0);
                        panelResult.getField('START_NUM').setConfig('readOnly',true);  
                        panelResult.getField('PAGE_Q').setConfig('readOnly',true);  
                	}else if(newValue.STYLE_CODE == "2"){
                		panelResult.getField('START_NUM').setConfig('readOnly',false);  
                        panelResult.getField('PAGE_Q').setConfig('readOnly',false);  
                	}
                }
            }
		},{					
			fieldLabel: '시작번호',
			name:'START_NUM',
			readOnly : true,
			value: 0,
			xtype: 'uniNumberfield',
			listeners: {
				blur: function(field, newValue, oldValue, eOpts) {
					if(field.lastValue == 0){
						return false;
					}else if( ( field.lastValue - 1 ) % 6 != 0 &&  field.lastValue != 1){
						alert('시작번호를 정상적으로 입력해주세요.(1장에 6개 출력이므로 6의배수+1)');
						panelResult.setValue('START_NUM',0);
						panelResult.setValue('PAGE_Q',0);
					}
				}
			}
		},{					
			fieldLabel: '장수',
			name:'PAGE_Q',
			value: 0,
			readOnly : true,
			xtype: 'uniNumberfield',
			listeners: {
				change: function(field, newValue, oldValue, eOpts) {		
					
				}
			}
		},
        
        //Print Button
        {
            xtype:'button',           //필드 타입
            text: '출력',
            margin: '8 0 0 94',
            width: 153,
            handler : function() {
            	if( panelResult.getValues().STYLE_CODE == '2' && ( panelResult.getValue('START_NUM') - 1 ) % 6 != 0 &&  panelResult.getValue('START_NUM') != 1){
					alert('시작번호를 정상적으로 입력해주세요.(1장에 6개 출력이므로 6의배수+1)');
					panelResult.setValue('START_NUM',0);
					panelResult.setValue('PAGE_Q',0);
					return false;
				}else  if(panelResult.getValues().STYLE_CODE == '1'){
            	   UniAppManager.app.onPrintButtonDown();  
               }else if(panelResult.getValues().STYLE_CODE == '2'){
            	   UniAppManager.app.onNoStylePrintButtonDown();  
               }
            }
        },/* {
            xtype:'button',           //필드 타입
            text: '빈양식출력',
            margin: '0 0 2 30',
//                margin: '0 0 0 0',
            width: 80,            
            handler : function() {
            	
                if(Ext.isEmpty(panelResult.getValue('DATE1')) || Ext.isEmpty(panelResult.getValue('DATE1'))) {
                	alert('재고조사기준일 / 재고조사일자는 필수 입력 항목입니다.');
                	return false;
                }
                
                panelResult.setValue('EMPTY_YN', 'Y');
                var param = panelResult.getValues();
                
                var win = Ext.create('widget.CrystalReport', {
                    url: CPATH+'/z_kd/s_biv121crkrv_kd.do',
                    prgID: 's_biv121crkrv_kd',
                        extParam: param
                    });
                    win.center();
                    win.show();	
            }
        }, */{     
            fieldLabel: '빈양식여부',
            name:'EMPTY_YN',
            xtype: 'uniTextfield',
            hidden : true
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
        }
    });		

    Unilite.Main({
    	borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
				panelResult
			]
		}	
		],	
		id  : 's_biv121rkrv_kdApp',
		fnInitBinding : function() {
			panelResult.setValue('DIV_CODE', UserInfo.divCode);
            panelResult.setValue('DATE1', Ext.Date.format(new Date(), 'Y') + "0101");
            panelResult.setValue('DATE2', Ext.Date.format(new Date(), 'Y') + "1231");
			UniAppManager.setToolbarButtons('print', false);
			UniAppManager.setToolbarButtons('query', false);
		},
		onResetButtonDown: function() {
			panelResult.clearForm();
			this.fnInitBinding();
		},
        onPrintButtonDown: function() {
            if(this.onFormValidate()) {
                var param = panelResult.getValues();
                
                var win = Ext.create('widget.CrystalReport', {
                    url: CPATH+'/z_kd/s_biv121crkrv_kd.do',
                    prgID: 's_biv121crkrv_kd',
                        extParam: param
                    });
                    win.center();
                    win.show();
            }
        },
        onPrintButtonDown: function() {
        	if(!this.isValidSearchForm()){
				return false;
			}
        	
        	panelResult.setValue('EMPTY_YN', 'N');
            var param = panelResult.getValues();
            
            var win = Ext.create('widget.CrystalReport', {
                url: CPATH+'/z_kd/s_biv121crkrv_kd.do',
                prgID: 's_biv121crkrv_kd',
                    extParam: param
            });
            
            win.center();
            win.show();
	    },
	    onNoStylePrintButtonDown: function() {
        	if(!this.isValidSearchForm()){
				return false;
			}
        	
       	  	panelResult.setValue('EMPTY_YN', 'Y');
            var param = panelResult.getValues();
            var win = Ext.create('widget.CrystalReport', {
                 url: CPATH+'/z_kd/s_biv121crkrv_kd.do',
                 prgID: 's_biv121crkrv_kd',
                     extParam: param
                 });
                 win.center();
                 win.show();	
	    },
	    
	    
	    onFormValidate: function() {
	    	var r= true
	        var invalid = panelResult.getForm().getFields().filterBy(
	     		function(field) {
					return !field.validate();
				}
		    );
   	
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
			}
			return r;
	    }
	});
};

</script>