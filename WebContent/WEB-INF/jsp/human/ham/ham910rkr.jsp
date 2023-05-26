<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="ham910rkr"  >
		<t:ExtComboStore comboType="BOR120"  comboCode="BILL" /><!-- 신고사업장 -->
		<t:ExtComboStore comboType="AU" comboCode="H028" /> <!-- 급여지급방식-->
		<t:ExtComboStore comboType="AU" comboCode="H031" /> <!-- 급여지급일구분-->
		<t:ExtComboStore comboType="AU" comboCode="A074" /> <!-- 귀속분기-->
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
					boxLabel: '지급자제출용(제출집계표)', 
					width: 200, 
					name: 'optPrintGb',
					inputValue: '0',
					checked: true  
				},{
					boxLabel: '소득자보관용', 
					width: 120, 
					name: 'optPrintGb',
					inputValue: '1'
				},{
					boxLabel: '지급자보관용', 
					width: 120, 
					name: 'optPrintGb',
					inputValue: '2'
				}],
				listeners: {
					change: function(field, newValue, oldValue, eOpts) {	
						if(Ext.getCmp('optPrintGb').getChecked()[0].inputValue == '1') {
						} else {
						}
					},
	    			onTextSpecialKey: function(elm, e){
	                    if (e.getKey() == e.ENTER) {
	                    	panelResult2.getField('NAME').focus();  
	                	}
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
				fieldLabel: '귀속년도',				
				xtype: 'uniYearField',
				name: 'PAY_YYYY',
				allowBlank: false
			},{
				fieldLabel: '귀속분기',
				name: 'QUARTER_TYPE', 
				xtype: 'uniCombobox',
				comboType: 'AU',
				comboCode: 'A074',
				allowBlank: false
			},{
		 		fieldLabel: '영수년월일',
		 		xtype: 'uniDatefield',
		 		name: 'RECE_DATE',
		 		value: UniDate.get('today'),
		 		allowBlank: false
			},{
		 		fieldLabel: '지급일자',
		 		xtype: 'uniDatefield',
		 		name: 'SUPP_DATE'
			},{
				fieldLabel: '신고사업장',
				name:'BILL_DIV_CODE', 
				xtype: 'uniCombobox',
				comboType: 'BOR120',
				comboCode: 'BILL'
			},
			Unilite.treePopup('DEPTTREE',{
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
			}),{
				fieldLabel: '급여지급방식',
				name:'PAY_CODE', 
				xtype: 'uniCombobox',
		        comboType: 'AU',
				comboCode: 'H028'
			},{
				fieldLabel: '지급차수',
				name:'PAY_PROV_FLAG', 
				xtype: 'uniCombobox',
		        comboType: 'AU',
				comboCode: 'H031'
			},
			Unilite.popup('ParttimeEmployee',{
				fieldLabel: '사원',
			  	valueFieldName:'PERSON_NUMB',
			    textFieldName:'NAME',
				validateBlank:false,
				autoPopup:true,
				id : 'PERSON_NUMB', 
				listeners: {
					'onSelected': {
						fn: function(records, type) {
							panelResult2.setValue('PERSON_NUMB', records[0].PERSON_NUMB);
	                    	panelResult2.setValue('NAME', 		 records[0].NAME);
						},
						scope: this
					},
					'onClear': function(type) {
						panelResult2.setValue('PERSON_NUMB','');
                    	panelResult2.setValue('NAME','');
					},
					applyextparam: function(popup){	
						popup.setExtParam({'BASE_DT': UniDate.get('today')}); 
						popup.setExtParam({'PAY_GUBUN': '2'}); 
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
		id: 'ham910rkrApp',
		fnInitBinding : function() {
			
			UniAppManager.setToolbarButtons(['print'], false);
			UniAppManager.setToolbarButtons(['query', 'reset', 'newData', 'save', 'detail', 'delete'], false);
			
			if(UniDate.getDbDateStr(UniDate.get('today')).substring(4, 8) <= '0228'){
				panelResult2.setValue('PAY_YYYY', (new Date().getFullYear() - 1));
			}else{
				panelResult2.setValue('PAY_YYYY', new Date().getFullYear());
			}
		},
        onPrintButtonDown: function() {

        	var doc_Kind = Ext.getCmp('optPrintGb').getChecked()[0].inputValue;
        	
	        if(!panelResult2.getInvalidMessage()) return;   

	        
			var title_Doc = '';
			var prgID1    = '';
			
			if(doc_Kind == '0' ){
				title_Doc = Msg.sMH1357;  // 지급자 제출용
				//prgID1    = 'ham911rkr';
			}else if(doc_Kind == '1'){
				title_Doc = Msg.sMH1359; 	// 소득자 보관용
				//prgID1 	  = 'ham910rkr';
			}
			else if(doc_Kind == '2'){
				title_Doc = Msg.sMH1358; 	// 지급자 보관용
				//prgID1    = 'ham910rkr';
			}
			
			var param  = Ext.getCmp('resultForm').getValues();			// 상단 증명서 종류
			var param2 = Ext.getCmp('resultForm2').getValues();			// 하단 검색조건
			//var win = Ext.create('widget.PDFPrintWindow', {
	        //    url: CPATH+'/ham/ham910rkrPrint.do',
			
			 var win = Ext.create('widget.ClipReport', {
			            url: CPATH+'/human/ham910clrkr.do',
			            prgID: 'ham910rkr',
			            //extParam: param
			
	         //   prgID: prgID1,
	               extParam: {
	               	  DOC_KIND		: param.optPrintGb,		  // bParam(0) // 증명서 종류 
	               						// 지급자 제출용: 0 , 소득자 보관용 : 1, 지급자 보관용 : 2
					  PAY_YYYY      : param2.PAY_YYYY,
	                  QUARTER_TYPE	: param2.QUARTER_TYPE,
					  RECE_DATE		: param2.RECE_DATE,
					  SUPP_DATE		: param2.SUPP_DATE,
					  BILL_DIV_CODE	: param2.BILL_DIV_CODE,
					  DEPT_CODE		: param2.DEPTS,
					  PAY_CODE		: param2.PAY_CODE,
					  PAY_PROV_FLAG	: param2.PAY_PROV_FLAG,
					  PERSON_NUMB	: param2.PERSON_NUMB,
					  NAME			: param2.NAME,
	                  // 레포트로 파라미터 넘기기 매개변수 (조회와 관련 없음)
	                  SUB_TITLE		: title_Doc		// 제목
	                  
	               }
	            });
	            win.center();
	            win.show();
          
	    }
	}); //End of 	Unilite.Main( {
};

</script>
