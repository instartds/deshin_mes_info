<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="had421rkr"  >
		<t:ExtComboStore comboType="BOR120"  pgmId="had421rkr" /><!-- 신고사업장 -->
		<t:ExtComboStore comboType="AU" comboCode="H028" /> <!-- 급여지급방식-->
		<t:ExtComboStore comboType="AU" comboCode="H031" /> <!-- 급여지급일구분-->
		<t:ExtComboStore comboType="AU" comboCode="A074" /> <!-- 귀속분기-->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>
<script type="text/javascript" >

function appMain() {
	var comData = Msg.sMHC06.split('|#');
	var dataArray=[];
	comData.forEach(function(e){
	    var eComData = e.split(';');
		var tempObj={};
		tempObj.value=eComData[0];
		tempObj.text=eComData[1];
		if(tempObj.value && tempObj.text){
			dataArray.push(tempObj);
		}
		
	});
	
	 Ext.create('Ext.data.Store',{
			storeId: "retrTypeStore",
			data:dataArray
		});
    var panelResult = Unilite.createSearchForm('resultForm2',{
		hidden: !UserInfo.appOption.collapseLeftSearch,
    	region: 'west',
		layout : {type : 'uniTable', columns : 1},
		padding:'1 1 1 1',
		
		border:true,
		items: [{
   			fieldLabel: '정산구분',
   		 	name:'RETR_TYPE',
   			xtype: 'uniCombobox',
   			//sMHC08
			store: Ext.data.StoreManager.lookup('retrTypeStore'),
			width:325,
			allowBlank:false
   		},{
			fieldLabel: '정산년도',
			name: 'YEAR_YYYY',
			xtype: 'uniYearField',
			value: UniHuman.getTaxReturnYear(),
			allowBlank: false,
			width: 325
		},{
				fieldLabel: '신고사업장',
				name:'DIV_CODE', 
				xtype: 'uniCombobox',
				width:325,
		        multiSelect: false, 
		        typeAhead: false,
		        comboType:'BOR120',
		        width: 325
			},
			
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
                        panelResult.setValue('FR_DEPT_CODE', '');
                        panelResult.setValue('FR_DEPT_NAME', '');
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
                        panelResult.setValue('TO_DEPT_CODE', '');
                        panelResult.setValue('TO_DEPT_NAME', '');
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
				autoPopup:true,
				id : 'PERSON_NUMB', 
				listeners: {
					onSelected: {
                        fn: function(records, type) {
                        },
                          scope: this
                     },
                     onClear: function(type) {
                         panelResult.setValue('PERSON_NUMB', '');
                         panelResult.setValue('NAME', '');
                     },
					applyextparam: function(popup){	
						popup.setExtParam({'BASE_DT': '00000000'}); 
					}
				}
			}),
			{
			  fieldLabel: "출력옵션",
			  xtype: "radiogroup",
			  hidden:true,
			  items:[{
				  boxLabel:"이월금액 있는 경우만",
				  name:"CARRY_OVER",
				  width:161,
				  inputValue:'1'
				  
			  },{
				boxLabel:"전체",
				name:"CARRY_OVER",
				inputValue:'2',
				width:80,
				checked:true
			 }]
			},{
	         	xtype:'button',
	         	text:'출    력',
	         	width:235,
	         	tdAttrs:{'align':'center', style:'padding-left:80px'},
	         	handler:function()	{
	         		UniAppManager.app.onPrintButtonDown();
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
				panelResult
			]	
		}		
		], 
		id: 'had421rkrApp',
		fnInitBinding : function() {
			UniAppManager.setToolbarButtons(['print'], false);
			UniAppManager.setToolbarButtons(['query', 'reset', 'newData', 'save', 'detail', 'delete'], false);
		},
        onPrintButtonDown: function() {

	        if(!panelResult.getInvalidMessage()) return;   
			//var param  = Ext.getCmp('resultForm').getValues();			// 상단 증명서 종류
			var param = Ext.getCmp('resultForm2').getValues();			// 하단 검색조건
			param.TITLE = Msg.sMHT0090;
			param.DIV_NAME = panelResult.getField("DIV_CODE").getRawValue();
			/* var win = Ext.create('widget.PDFPrintWindow', {
	            url: CPATH+'/human/had421rkrPrint.do',
	            prgID: 'had421rkr',
	               extParam: param
	            }); */
	            var win = Ext.create('widget.ClipReport', {
	                url: CPATH+'/human/had421clrkr.do',
	                prgID: 'had421rkr',
	                extParam: param
	            });
	            win.center();
	            win.show();
          
	    }
	}); //End of 	Unilite.Main( {
};

</script>
