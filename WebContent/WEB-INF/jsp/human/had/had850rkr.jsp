<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="had850rkr"  >
		<t:ExtComboStore comboType="BOR120"  pgmId="had910rkr" /><!-- 신고사업장 -->
		<t:ExtComboStore comboType="AU" comboCode="H028" /> <!-- 급여지급방식-->
		<t:ExtComboStore comboType="AU" comboCode="H031" /> <!-- 급여지급일구분-->
		<t:ExtComboStore comboType="AU" comboCode="A074" /> <!-- 귀속분기-->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>
<script type="text/javascript" >

function appMain() {
Ext.create('Ext.data.Store',{
		storeId: "retrTypeStore",
		data:[
//            {text: '중도퇴사', value: 'Y'},
//            {text: '연말정산', value: 'N'}
            {text: '계속근로', value: 'N'},
            {text: '중도퇴사', value: 'Y'}
        ]
	}); 
	/* Ext.create('Ext.data.Store',{
		storeId: "retrTypeStore",
		data:[
			{text: '중도퇴사', value: 'Y'},
			{text: '연말정산', value: 'N'}
		]
	}); */
    var panelResult = Unilite.createSearchForm('resultForm',{
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
			value:'N',
			allowBlank:false
   		},{
			fieldLabel: '정산년도',
			name: 'YEAR_YYYY',
			xtype: 'uniYearField',
			value: UniHuman.getTaxReturnYear(),
			allowBlank: false,
			width: 325
		},{
			fieldLabel:'지급년월',
			xtype:'uniDateRangefield',
			startFieldName:'PAYFRYYMM',
			endFieldName:'PAYTOYYMM',
			width:325
			//allowBlank:false
//			startDate:UniDate.get('startOfMonth'),
//			endDate:UniDate.get('today')
		},{
			fieldLabel:'퇴사일자',
			xtype:'uniDateRangefield',
			startFieldName:'FRRETIREDATE',
			endFieldName:'TORETIREDATE',
			width:325
			//allowBlank:false
//			startDate:UniDate.get('startOfMonth'),
//			endDate:UniDate.get('today')
		},{
			fieldLabel: '영수년월일',
	    	xtype: 'uniDatefield',
	    	name: 'RECE_DATE',                    
			value: UniDate.get('today'),                    
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
	         	xtype:'button',
	         	text:'출    력',
	         	width:235,
	         	tdAttrs:{'align':'center', style:'padding-left:95px'},
	         	handler:function()	{
	         		UniAppManager.app.onPrintButtonDown();
	         	}
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
	   			}
		  	} else {
  				this.unmask();
  			}
			return r;
  		}
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
		id: 'had910rkrApp',
		fnInitBinding : function() {
			
			UniAppManager.setToolbarButtons(['print'], false);
			UniAppManager.setToolbarButtons(['query', 'reset', 'newData', 'save', 'detail', 'delete'], false);
			
		},
		checkForNewDetail:function() { 			
			return panelResult.setAllFieldsReadOnly(true);
        },
        onPrintButtonDown: function() {
        	if(!UniAppManager.app.checkForNewDetail()){
				return false;
			}else{
        	
				var param = Ext.getCmp('resultForm').getValues();			// 하단 검색조건
	//			if(param.RETR_TYPE == "R"){
	//				param.IN_COME_TYPE = Msg.sMH1486;
	//				alert(Msg.sMH1486);
	//			}else if(param.RETR_TYPE == "Y" || param.RETR_TYPE == "N"){
	//				param.IN_COME_TYPE = Msg.sMH1401;
	//				alert(Msg.sMH1401);
	//			}
				
	//			var win = Ext.create('widget.PDFPrintWindow', {
	//	            url: CPATH+'/human/had850rkrPrint.do',
				if(param.YEAR_YYYY >= '2019') {
					var win = Ext.create('widget.ClipReport', {
						url: CPATH+'/human/had850clrkr2020.do',
						prgID: 'had850rkr',
						extParam: param
					});
					win.center();
					win.show();
				}
				else {
			    	var win = Ext.create('widget.CrystalReport', {
						url: CPATH+'/human/had850crkr.do',
			            prgID: 'had850rkr',
			               extParam: param
			            });
			            win.center();
			            win.show();
				}
          }
	    }
	}); //End of 	Unilite.Main( {
};

</script>
