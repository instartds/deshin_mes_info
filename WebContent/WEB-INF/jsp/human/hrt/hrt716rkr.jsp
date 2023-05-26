<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="hrt716rkr"  >
		<t:ExtComboStore comboType="BOR120"  pgmId="hum930rkr" /><!-- 신고사업장 -->
		<t:ExtComboStore comboType="AU" comboCode="H028" /> <!-- 급여지급방식-->
		<t:ExtComboStore comboType="AU" comboCode="H031" /> <!-- 급여지급일구분-->
		<t:ExtComboStore comboType="AU" comboCode="A074" /> <!-- 귀속분기-->
		<t:ExtComboStore comboType="AU" comboCode="H053" opts = 'M;R'/> <!-- 정산구분 -->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>
<script type="text/javascript" >

function appMain() {
	
	var panelResult = Unilite.createSearchForm('resultForm',{
		hidden: !UserInfo.appOption.collapseLeftSearch,
    	region: 'north',
		layout : {type : 'uniTable', columns : 2},
		padding:'1 1 1 1',
		border:true,
		items: [{
				xtype: 'radiogroup',		            		
				fieldLabel: '출력선택',						            		
				id: 'optPrintGb',
				labelWidth: 90,
				items: [{
					boxLabel: '소득자보관용', 
					width: 120, 
					name: 'optPrintGb',
					inputValue: '1',
					checked: true  
				},{
					boxLabel: '발행자보관용', 
					width: 120, 
					name: 'optPrintGb',
					inputValue: '2'
				},{
					boxLabel: '발행자보고용', 
					width: 120, 
					name: 'optPrintGb',
					inputValue: '3'
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {	
						
					},
	    			onTextSpecialKey: function(elm, e){
	                   
	                }
				}
			}]
	});	
	
    var panelResult2 = Unilite.createSearchForm('resultForm2',{
		hidden: !UserInfo.appOption.collapseLeftSearch,
    	region: 'west',
		layout : {type : 'uniTable', columns : 1},
		padding:'1 1 1 1',
		
		border:true,
		items: [{
				fieldLabel: '정산구분',
				name:'RETR_TYPE', 
				xtype: 'uniCombobox',
				width:325,
		        comboType: 'AU',
		        value : 'R',
		        allowBlank: false,
				comboCode: 'H053'
		},{
				fieldLabel: '지급일',
                xtype: 'uniDateRangefield',
                startFieldName: 'FR_DATE',
                endFieldName: 'TO_DATE',
                startDate: UniDate.get('startOfMonth'),
				endDate: UniDate.get('endOfMonth'),
                allowBlank:false
		},{
			fieldLabel: '정산일',
			xtype: 'uniDatefield',
			name: 'RETR_DATE',      
			width:325,
			//value: UniDate.get('today'),                    
			readOnly: false
		},{
				fieldLabel: '신고사업장',
				name:'SECT_CODE', 
				xtype: 'uniCombobox',
				width:325,
		        multiSelect: false, 
		        typeAhead: false,
		        comboCode	: 'BILL',
		        comboType:'BOR120'
		        
		        
			},
			/* Unilite.treePopup('DEPTTREE',{
				fieldLabel: '부서',
				valueFieldName:'DEPT',
				textFieldName:'DEPT_NAME' ,
				valuesName:'DEPTS' ,
				DBvalueFieldName:'TREE_CODE',
				DBtextFieldName:'TREE_NAME',
				selectChildren:true,
				textFieldWidth:89,
				validateBlank:true,
				width:300,
				autoPopup:true,
				useLike:true
			}), */
			Unilite.popup('DEPT',{
		    	colspan: 1,
		        fieldLabel: '부서',
			    valueFieldName:'FR_DEPT_CODE',
			    textFieldName:'FR_DEPT_NAME',
		        validateBlank:false,
                listeners: {
                    onSelected: {
                        fn: function(records, type) {
                        },
                        scope: this
                    },
                    onClear: function(type) {
                        panelResult2.setValue('FR_DEPT_CODE', '');
                        panelResult2.setValue('FR_DEPT_NAME', '');
                    }
                }
		    }),
	      	Unilite.popup('DEPT',{
		        fieldLabel: '~',
		        colspan: 1,
			    valueFieldName:'TO_DEPT_CODE',
			    textFieldName:'TO_DEPT_NAME',
		        validateBlank:false,
                listeners: {
                    onSelected: {
                        fn: function(records, type) {
                        },
                        scope: this
                    },
                    onClear: function(type) {
                        panelResult2.setValue('TO_DEPT_CODE', '');
                        panelResult2.setValue('TO_DEPT_NAME', '');
                    }
                }
		    }), 
			{
				fieldLabel: '급여지급방식',
				name:'PAY_CODE', 
				xtype: 'uniCombobox',
				width:325,
		        comboType: 'AU',
				comboCode: 'H028'
				
			},{
				fieldLabel: '지급차수',
				name:'PAY_PROV_FLAG', 
				xtype: 'uniCombobox',
				width:325,
		        comboType: 'AU',
				comboCode: 'H031'
				
			},Unilite.popup('Employee',{
                fieldLabel: '사원',
                valueFieldName:'PERSON_NUMB',
                textFieldName:'NAME',
                validateBlank:false,
                allowBlank:false,
                autoPopup:true, 
                listeners: {
                    onSelected: {
                        fn: function(records, type) {
                        },
                          scope: this
                     },
                     onClear: function(type) {
                         panelResult2.setValue('PERSON_NUMB', '');
                         panelResult2.setValue('NAME', '');
                     }
                }
            }),
			{
	         	xtype:'button',
	         	text:'출    력',
	         	width:235,
	         	tdAttrs:{'align':'center', style:'padding-left:95px'},
	         	handler:function()	{
	         		
	         		if(!panelResult2.getInvalidMessage()) return; 
	         		var doc_Kind = Ext.getCmp('optPrintGb').getChecked()[0].inputValue;
	         		var params = Ext.getCmp('resultForm2').getValues();
	         		params.DOC_KIND = doc_Kind;
	         		hrt716rkrService.selectList1(params, function(provider, response){
                    	if(Ext.isEmpty(provider)){
                    	   alert('출력조건에 맞는 대상자가 없습니다.');
                    	   return false;
                    	}else{
	         		        UniAppManager.app.onPrintButtonDown();
                    	}
                    });
	         	}
         }]
	});		
	
	Unilite.Main({
	 	border: false,
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
				panelResult, panelResult2
			]	
		}		
		], 
		id: 'hrt716rkrApp',
		fnInitBinding : function(param) {
			//panelResult2.setValue('DIV_CODE',UserInfo.divCode);
			UniAppManager.setToolbarButtons(['print'], false);
			UniAppManager.setToolbarButtons(['query', 'reset', 'newData', 'save', 'detail', 'delete'], false);
			var activeSForm ;
            activeSForm = panelResult2;
            activeSForm.onLoadSelectText('PERSON_NUMB');

            if(param && param.PERSON_NUMB)  {
                panelResult2.setValue('PERSON_NUMB',param.PERSON_NUMB);

                if( param.NAME )    {
                    panelResult2.setValue('NAME',param.NAME);
                }
                if(param.RETR_TYPE) {
                    panelResult2.setValue('RETR_TYPE',param.RETR_TYPE);
                }
                if(param.RETR_DATE) {
                    panelResult2.setValue('RETR_DATE',param.RETR_DATE);
                }
                if(param.SUPP_DATE) {
                    panelResult2.setValue('FR_DATE',param.SUPP_DATE);
                }
                
            }
		},
        onPrintButtonDown: function() {

        	var doc_Kind = Ext.getCmp('optPrintGb').getChecked()[0].inputValue;
        	
	        //if(!panelResult2.getInvalidMessage()) return;   

			var form = panelFileDown;
			
			var param = Ext.getCmp('resultForm2').getValues();
			param.DOC_KIND = doc_Kind;
			
			form.submit({
                params: param,
                success:function(form, action)  {
                },
                failure: function(form, action){
                }
            });
          
	    }
	}); //End of 	Unilite.Main( {
};

	var panelFileDown = Unilite.createForm('FileDownForm', {
		url: CPATH+'/human/hrt716rkrExcelDown.do',
		colspan: 2,
		layout: {type: 'uniTable', columns: 1},
		height: 30,
		padding: '0 0 0 195',
		disabled:false,
		autoScroll: false,
		standardSubmit: true
/*		items:[{
			xtype: 'uniTextfield',
			name: 'FR_DATE'
		},{
			xtype: 'uniTextfield',
			name: 'TO_DATE'
		}]*/
	});

</script>
