<%@page language="java" contentType="text/html; charset=utf-8"%> 
<t:appConfig pgmId="s_ass900ukr_KOCIS"  >
	<t:ExtComboStore comboType="BOR120"  /> 								<!-- 사업장 --> 
	<t:ExtComboStore comboType="AU" comboCode="A396" /> 					<!-- 작품구분 -->
	<t:ExtComboStore comboType="AU" comboCode="A397" /> 					<!-- 취득이유 -->
	<t:ExtComboStore comboType="AU" comboCode="A398" /> 					<!-- 가치등급분류 -->
	<t:ExtComboStore comboType="AU" comboCode="A399" /> 					<!-- 작품상태 -->
	<t:ExtComboStore items="${COMBO_DEPT_KOCIS}" storeId="deptKocis" /> 	<!--기관-->

<style type="text/css">

#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}    
</style>
</t:appConfig>
<script type="text/javascript" >


/*var BsaCodeInfo = {
	gsAutoType: '${gsAutoType}',	
	gsAccntBasicInfo : '${getAccntBasicInfo}',
	gsMoneyUnit : '${gsMoneyUnit}'
};*/

function appMain() {
	var uploadWin;
	var gsItemCode;
	var saveFlag = false;
	
	var panelSearch = Unilite.createSearchPanel('searchForm', {		
		title		: '검색조건',
        defaultType	: 'uniSearchSubPanel',
        collapsed	: true,
        listeners	: {
	        collapse: function () {
	            panelResult.show();
	        },
	        expand: function() {
	        	panelResult.hide();
	        }
        },
		items: [{	
			title		: '기본정보', 	
   			itemId		: 'search_panel1',
           	layout		: {type: 'uniTable', columns: 1},
           	defaultType	: 'uniTextfield',
		    items		: [
		    	Unilite.popup('ART_KOCIS',{
			    fieldLabel	: '작품코드',
			    allowBlank	: false,
			    labelWidth	: 140,
				listeners	: {
					onValueFieldChange: function(field, newValue){
						panelResult.setValue('ITEM_CODE', newValue);								
					},
					onTextFieldChange: function(field, newValue){
						panelResult.setValue('ITEM_NAME', newValue);				
					}
				}
		   	})]
		}]
	});
		
	var panelResult = Unilite.createSearchForm('panelResultForm', {		
    	hidden	: !UserInfo.appOption.collapseLeftSearch,
		region	: 'north',
		layout	: {type : 'uniTable', columns : 3, tdAttrs: {/*style: 'border : 1px solid #ced9e7;',*/ width: '100%'}},
		padding	: '1 1 1 1',
		border	: true,
	    items	: [
	    	Unilite.popup('ART_KOCIS',{
		    fieldLabel	: '작품코드',  
//		    validateBlank: false, 
		    allowBlank	: false,
		    labelWidth	: 140,
			listeners	: {
				onValueFieldChange: function(field, newValue){
					panelSearch.setValue('ITEM_CODE', newValue);								
				},
				onTextFieldChange: function(field, newValue){
					panelSearch.setValue('ITEM_NAME', newValue);				
				}
			}
	   	})]
	});

	
	
	/** 작품등록  Master Form
	 * 
	 * @type
	 */     
	var detailForm = Unilite.createForm('s_ass900ukrDetail', {
    	disabled	: false,
    	border		: true,
    	region		: 'center',
    	padding		: '0 1 0 1',
    	layout		: {type: 'uniTable', columns: 3, tdAttrs: {/*style: 'border : 1px solid #ced9e7;', */valign:'top'}},
    	items		: [{
	            xtype: 'component',
	            width: 10
	    	},{
	    		xtype	: 'container',
		    	layout	: {type: 'uniTable', columns: 2, tdAttrs: {class:'photo-background', valign:'bottom'}},
	        	tdAttrs	: {valign:'bottom'/*, align: 'right'*/},
	        	padding	: '3 0 0 133',
				colspan	: 2,
		    	items	: [{ 
					fieldLabel	: '작품사진',
					title		: '작품사진',
					xtype		: 'component',
		        	itemId		: 'EmpImg',
		        	width		: 130,
		        	autoEl		: {
		        		tag: 'img',
		        		src: CPATH+'/resources/images/human/noPhoto.png',
		        		cls:'photo-wrap'
		        	},
	        		listeners	: {
//	        			click : {
//	        				element:'el',
//	        				fn: function( e, t, eOpts )	{
//	        					openUploadWindow();
//	        				}
//	        			}
	        		}
	  			},{
		    		xtype	: 'container',
			    	layout	: {type: 'uniTable', columns: 1},
		        	width	: 150,
			    	items	: [{
    	  				xtype	: 'container',
			        	items	: [{
		        			xtype		: 'image',
				        	itemId		: 'photoUpload',
				     		src			: CPATH+'/resources/css/icons/s01_query.png',
			        		cls			: 'photo-search-icon ',
			        		listeners	: {
			        			click : {
			        				element	: 'el',
			        				fn		: function( e, t, eOpts )	{
			        					openUploadWindow();
			        				}
			        			}
			        		}
	        			}]
			        
    	  			},{
						xtype	: 'container',
						html	: ' 위 이미지를 클릭하여',
						style	: {
							color: 'blue'				
						}
					},{
						xtype	: 'container',
						html	: ' 사진을 등록하세요.',
						style	: {
							color: 'blue'				
						}
					},{	//사진이미지와 아래 라인을 맞추기 위한 필드
						xtype	: 'container',
						html	: '&nbsp;',
						style	: {
							color: 'blue'				
						}
					}]
	  			}]
	    	},{
			//////////////////////////////////////////////////왼쪽 화면 시작
	            xtype: 'component',
	            width: 10
	    	},{
	    	xtype	: 'container',
	    	layout	: {type: 'uniTable', columns: 1,tdAttrs: {valign:'top'}},
	    	items	: [{
			 	fieldLabel	: '작품명',
			 	xtype		: 'uniTextfield',
			 	name		: 'ITEM_NM',	
			    allowBlank	: false,
			    labelWidth	: 140,
			    width		: 375
			},
			Unilite.popup('DEPT',{
			    fieldLabel	: '기관명',
			    allowBlank	: false,
			    readOnly	: true,
		   		labelWidth	: 140,
			    width		: 375,
				listeners	: {
					onValueFieldChange: function(field, newValue){
//						detailForm.setValue('PURCHASE_DEPT_CODE', newValue);								
					},
					onTextFieldChange: function(field, newValue){
//						detailForm.setValue('PURCHASE_DEPT_NAME', newValue);				
					}
				}
			}),{
			 	fieldLabel	: '소재지',
			 	xtype		: 'uniTextfield',
			 	name		: 'ADDR',
			    labelWidth	: 140,
			    width		: 375
			},{
			 	fieldLabel	: '담당자',
			 	xtype		: 'uniTextfield',
			 	name		: 'APP_USER',	
			 	readOnly	: true,
			    labelWidth	: 140,
			    width		: 375
			},{
			 	fieldLabel	: '취득가액',
			 	xtype		: 'uniNumberfield',
			 	name		: 'ACQ_AMT_I',
			 	//금액 뒤에 KRW 주석
//				suffixTpl	: UserInfo.currency,
//			    allowBlank	: false,
			    labelWidth	: 140,
			    width		: 375,
    			listeners	: {
					change: function(combo, newValue, oldValue, eOpts) {	
						if (Ext.isEmpty(newValue) || newValue == 0) {
							detailForm.getField('EXPECT_AMT_I').setReadOnly(false);
							detailForm.getField('ESTATE_AMT_I').setReadOnly(false);
							detailForm.getField('SALES_AMT_I').setReadOnly(false);
							detailForm.setValue('SALES_AMT_I', '');
							
						} else {
							detailForm.getField('EXPECT_AMT_I').setReadOnly(true);
							detailForm.getField('ESTATE_AMT_I').setReadOnly(true);
							detailForm.getField('SALES_AMT_I').setReadOnly(true);
							detailForm.setValue('SALES_AMT_I', newValue);
						}
					}
				} 
			},{
			 	fieldLabel	: '추정가액',
			 	xtype		: 'uniNumberfield',
			 	name		: 'EXPECT_AMT_I',
			 	//금액 뒤에 KRW 주석
//				suffixTpl	: UserInfo.currency,
			    labelWidth	: 140,
			    width		: 375,
    			listeners	: {
					change: function(combo, newValue, oldValue, eOpts) {	
						if (Ext.isEmpty(newValue) || newValue == 0) {
							detailForm.getField('ACQ_AMT_I').setReadOnly(false);
							detailForm.getField('ESTATE_AMT_I').setReadOnly(false);
							detailForm.getField('SALES_AMT_I').setReadOnly(false);
							detailForm.setValue('SALES_AMT_I', '');
							
						} else {
							detailForm.getField('ACQ_AMT_I').setReadOnly(true);
							detailForm.getField('ESTATE_AMT_I').setReadOnly(true);
							detailForm.getField('SALES_AMT_I').setReadOnly(true);
							detailForm.setValue('SALES_AMT_I', newValue);
						}
					}
				} 
			},{
			 	fieldLabel	: '감정가액',
			 	xtype		: 'uniNumberfield',
			 	name		: 'ESTATE_AMT_I',
				//금액 뒤에 KRW 주석
//					suffixTpl	: UserInfo.currency,
			    labelWidth	: 140,
			    width		: 375,
    			listeners	: {	
					change: function(combo, newValue, oldValue, eOpts) {	
						if (Ext.isEmpty(newValue) || newValue == 0) {
							detailForm.getField('ACQ_AMT_I').setReadOnly(false);
							detailForm.getField('EXPECT_AMT_I').setReadOnly(false);
							detailForm.getField('SALES_AMT_I').setReadOnly(false);
							detailForm.setValue('SALES_AMT_I', '');
							
						} else {
							detailForm.getField('ACQ_AMT_I').setReadOnly(true);
							detailForm.getField('EXPECT_AMT_I').setReadOnly(true);
							detailForm.getField('SALES_AMT_I').setReadOnly(true);
							detailForm.setValue('SALES_AMT_I', newValue);
						}
					} 
    			}
			},{
	    		xtype	: 'container',
		    	layout	: {type: 'uniTable', columns: 2},
	        	tdAttrs	: {align: 'right'},
		    	items	: [{
		    		xtype		: 'uniCheckboxgroup',		            		
		    		fieldLabel	: '보험가입여부',
		    		items		: [{
		    			boxLabel		: '',
		    			name			: 'INSUR_YN',
		    			inputValue		: 'Y',
		    			uncheckedValue	: 'N'
		    		}]
		        },{
		    		xtype		: 'uniCheckboxgroup',		            		
		    		fieldLabel	: '공개여부',
		    		items		: [{
		    			boxLabel		: '',
		    			name			: 'OPEN_YN',
		    			inputValue		: 'Y',
		    			uncheckedValue	: 'N'
		    		}]
		        }]
	    	},{
			 	fieldLabel	: '특기사항',
			 	xtype		: 'uniTextfield',
			 	name		: 'REMARK',
			    labelWidth	: 140,
			    width		: 375	
			},{
			 	fieldLabel	: '작품설명',
			 	xtype		: 'textareafield',
			 	name		: 'ITEM_DESC',
			    labelWidth	: 140,
			    width		: 375,
			    height		: 78
			}]
		},{
		//////////////////////////////////////////////////오른쪽 화면 시작
	    	xtype	: 'container',
	    	layout	: {type: 'uniTable', columns: 1,tdAttrs: {valign:'top'}},
	    	items	: [{
	    			fieldLabel	: '작품구분'	,
	    			name		: 'ITEM_GBN', 
	    			xtype		: 'uniCombobox', 
	    			comboType	: 'AU',
	    			comboCode	: 'A396',	
			 		allowBlank	: false,
			    	labelWidth	: 140,
	    			listeners	: {
						change: function(combo, newValue, oldValue, eOpts) {	
						}
					} 
	    		},{
		    		xtype	: 'container',
			    	layout	: {type: 'uniTable', columns: 2},
			    	items	: [{
					 	fieldLabel	: '작가명',
					 	xtype		: 'uniTextfield',
					 	name		: 'AUTHOR',
			    		allowBlank	: false,
			    		labelWidth	: 140
					},{
					 	fieldLabel	: '호',
					 	xtype		: 'uniTextfield',
					 	name		: 'AUTHOR_HO',
			    		labelWidth	: 30,
			   			width		: 95
					}]
		    	},{
				 	fieldLabel	: '크기(cm)',
		    		xtype		: 'container',
			    	layout		: {type: 'uniTable', columns: 4},
			    	items		: [{
					 	fieldLabel	: '가로 x 세로 x 높이',
					 	xtype		: 'uniNumberfield',
					 	name		: 'X_LENGTH',
		    			labelWidth	: 140,
					 	width		: 210
					},{
					 	fieldLabel	: 'x',
					 	xtype		: 'uniNumberfield',
					 	name		: 'Y_LENGTH',
			    		labelWidth	: 10,
					 	width		: 80
					},{
					 	fieldLabel	: 'x',
					 	xtype		: 'uniNumberfield',
					 	name		: 'Z_LENGTH',
//						suffixTpl	: 'cm',
			    		labelWidth	: 10,
					 	width		: 80
					},{
					 	xtype		: 'component',
					 	html		: '(cm)'
					}]
		    	},{
				 	fieldLabel	: '게시장소',
				 	xtype		: 'uniTextfield',
				 	name		: 'ITEM_DIR',
		    		labelWidth	: 140
				},{
	    			fieldLabel	: '취득이유'	,
	    			name		: 'PURCHASE_WHY', 
	    			xtype		: 'uniCombobox', 
	    			comboType	: 'AU',
	    			comboCode	: 'A397',
			    	labelWidth	: 140,
	    			listeners	: {
						change: function(combo, newValue, oldValue, eOpts) {	
						}
					} 
	    		},{
	    			fieldLabel	: '가치등급분류'	,
	    			name		: 'VALUE_GUBUN', 
	    			xtype		: 'uniCombobox', 
	    			comboType	: 'AU',
	    			comboCode	: 'A398',
			    	labelWidth	: 140,
	    			listeners	: {
						change: function(combo, newValue, oldValue, eOpts) {	
						}
					} 
	    		},{
	    			fieldLabel	: '작품상태'	,
	    			name		: 'ITEM_STATE', 
	    			xtype		: 'uniCombobox', 
	    			comboType	: 'AU',
	    			comboCode	: 'A399',	
			    	labelWidth	: 140,
	    			listeners	: {
						change: function(combo, newValue, oldValue, eOpts) {	
						}
					} 
	    		},{
					fieldLabel	: '취득일',
				 	xtype		: 'uniDatefield',
				 	name		: 'PURCHASE_DATE',	
				 	allowBlank	: false,
			    	labelWidth	: 140,
			    	listeners	: {
			    		change: function(combo, newValue, oldValue, eOpts) {					
						}
			    	}
	    		},{
				 	fieldLabel	: '제품가액',
				 	xtype		: 'uniNumberfield',
				 	name		: 'SALES_AMT_I',
				 	//금액 뒤에 KRW 주석
//					suffixTpl	: UserInfo.currency,
			    	allowBlank	: false,
				    labelWidth	: 140,
				    width		: 375	
				}
			]
		},{
            xtype		: 'component',
            html		: '[관리점검]',
            componentCls: 'component-text_green',
            tdAttrs		: {align : 'left'},
            padding		: '0 0 0 30',
            width		: 300,
            colspan		: 3
        },{
		//////////////////////////////////////////////////아래 화면 시작
            xtype: 'component',
            width: 10
        },{
	    	xtype	: 'fieldset',
	    	layout	: {type: 'uniTable', columns: 6, tdAttrs: {valign:'top'}},
	    	padding : 10,
	    	width	: 1050,
	    	colspan	: 2,
	    	items	: [{
		            fieldLabel	: '마감년도',
		            xtype		: 'uniYearField',
		            name		: 'CLOSING_YEAR',
		            value		: new Date().getFullYear(),
		            allowBlank	: false,
			    	labelWidth	: 130,
			    	width		: 230,
					listeners	: {
						change: function(field, newValue, oldValue, eOpts) {
						}
					}
		         },{
		    		xtype	: 'component',
		    		width	: 50 
		         },{
		    		xtype		: 'uniCheckboxgroup',		            		
		    		fieldLabel	: '상반기 점검여부',
		    		items		: [{
		    			boxLabel		: '',
		    			name			: 'FIRST_CHECK_YN',
		    			inputValue		: 'Y',
		    			uncheckedValue	: 'N',
						listeners	: {
							change: function(field, newValue, oldValue, eOpts) {
								if(newValue) {
									detailForm.setValue('FIRST_CHECK_USR'	, UserInfo.userName);
									
									detailForm.getField('FIRST_CHECK_DATE').setReadOnly(false);
									detailForm.getField('FIRST_CHECK_DESC').setReadOnly(false);
									detailForm.getField('FIRST_CHECK_USR').setReadOnly(false);
									
									
								} else {
									detailForm.setValue('FIRST_CHECK_DATE'	, '');
									detailForm.setValue('FIRST_CHECK_DESC'	, '');
									detailForm.setValue('FIRST_CHECK_USR'	, '');
									
									detailForm.getField('FIRST_CHECK_DATE').setReadOnly(true);
									detailForm.getField('FIRST_CHECK_DESC').setReadOnly(true);
									detailForm.getField('FIRST_CHECK_USR').setReadOnly(true);
								}
							}
						}
		    		}]
		         },{
					fieldLabel	: '점검일자',
				 	xtype		: 'uniDatefield',
				 	name		: 'FIRST_CHECK_DATE',
			    	width		: 200,
			    	listeners	: {
			    		change: function(combo, newValue, oldValue, eOpts) {					
						}
			    	}
	    		},{
				 	fieldLabel	: '점검내용',
				 	xtype		: 'uniTextfield',
				 	name		: 'FIRST_CHECK_DESC'/*,
		    		labelWidth	: 50*/,
				 	width		: 220
				},{
				 	fieldLabel	: '점검자',
				 	xtype		: 'uniTextfield',
				 	name		: 'FIRST_CHECK_USR',
		    		labelWidth	: 70,
				 	width		: 170
				},{
		    		xtype	: 'component',
		    		colspan	: 2,
		    		width	: 250 
		         },{
		    		xtype		: 'uniCheckboxgroup',		            		
		    		fieldLabel	: '하반기 점검여부',
		    		items		: [{
		    			boxLabel		: '',
		    			name			: 'SECOND_CHECK_YN',
		    			inputValue		: 'Y',
		    			uncheckedValue	: 'N',
						listeners	: {
							change: function(field, newValue, oldValue, eOpts) {
								if(newValue) {
									detailForm.setValue('SECOND_CHECK_USR'	, UserInfo.userName);
									
									detailForm.getField('SECOND_CHECK_DATE').setReadOnly(false);
									detailForm.getField('SECOND_CHECK_DESC').setReadOnly(false);
									detailForm.getField('SECOND_CHECK_USR').setReadOnly(false);

								} else {
									detailForm.getField('SECOND_CHECK_DATE').setReadOnly(true);
									detailForm.getField('SECOND_CHECK_DESC').setReadOnly(true);
									detailForm.getField('SECOND_CHECK_USR').setReadOnly(true);

									detailForm.setValue('SECOND_CHECK_DATE'	, '');
									detailForm.setValue('SECOND_CHECK_DESC'	, '');
									detailForm.setValue('SECOND_CHECK_USR'	, '');
								}
							}
						}
		    		}]
		         },{
					fieldLabel	: '점검일자',
				 	xtype		: 'uniDatefield',
				 	name		: 'SECOND_CHECK_DATE',	
			    	width		: 200,
			    	listeners	: {
			    		change: function(combo, newValue, oldValue, eOpts) {					
						}
			    	}
	    		},{
				 	fieldLabel	: '점검내용',
				 	xtype		: 'uniTextfield',
				 	name		: 'SECOND_CHECK_DESC'/*,
		    		labelWidth	: 50*/,
				 	width		: 220
				},{
				 	fieldLabel	: '점검자',
				 	xtype		: 'uniTextfield',
				 	name		: 'SECOND_CHECK_USR',
		    		labelWidth	: 70,
				 	width		: 170
				},{
				 	fieldLabel	: 'SAVE_FLAG',
				 	xtype		: 'uniTextfield',
				 	name		: 'SAVE_FLAG',
				 	hidden		: true,
		    		labelWidth	: 70,
				 	width		: 170
				},{
				 	fieldLabel	: 'ITEM_CODE',
				 	xtype		: 'uniTextfield',
				 	name		: 'ITEM_CODE',
				 	hidden		: true,
		    		labelWidth	: 70,
				 	width		: 170
				},{
				 	fieldLabel	: 'IMAGE_DIR',
				 	xtype		: 'uniTextfield',
				 	name		: 'IMAGE_DIR',
				 	hidden		: true,
		    		labelWidth	: 70,
				 	width		: 170
				},{
				 	fieldLabel	: 'CHANGE_YN',
				 	xtype		: 'uniTextfield',
				 	name		: 'CHANGE_YN',
				 	hidden		: true,
		    		labelWidth	: 70,
				 	width		: 170
				}
			]
		}],
		listeners : {
			uniOnChange:function( basicForm, field, newValue, oldValue ) {
				console.log("onDirtyChange");
				if(basicForm.isDirty() && field.lastValue != field.originalValue /*&& field.dirty */&& saveFlag)	{
//				if(basicForm.isDirty() && newValue != field.originalValue /*&& field.dirty */&& saveFlag)	{
					UniAppManager.setToolbarButtons('save', true);
					
				}else {
					UniAppManager.setToolbarButtons('save', false);
				}
				saveFlag = true;
			},
			beforeaction:function(basicForm, action, eOpts)	{
			}/*,
			loadBasicData: function(node)	{
				if(!Ext.isEmpty(node))	{
					var data = node.getData();
					this.down('#EmpImg').getEl().dom.src=CPATH+'/uploads/employeePhoto/'+data['PERSON_NUMB'] + '?_dc=' + data['dc'];
//					this.down('#EmpImg').getEl().dom.src=CPATH+'/uploads/employeePhoto/'+data['PERSON_NUMB'] + '?_dc=' + data['dc'];

				}else {
					this.down('#EmpImg').getEl().dom.src=CPATH+'/resources/images/human/noPhoto.png';
				}
			}*/
		},
		api: {
 		 load	: 's_ass900ukrService_KOCIS.selectMaster',
		 submit	: 's_ass900ukrService_KOCIS.syncMaster'				
		},		
	    setAllFieldsReadOnly: function(b) {
			var r= true
			if(b) {
//				validateFlag = '2';
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
				}
	  		}
//	  		validateFlag = '1';
			return r;
  		}
	});

         
	var photoForm = Ext.create('Unilite.com.form.UniDetailForm',{ 
		xtype		: 'uniDetailForm',
        disabled	: false,
        fileUpload	: true,
        itemId		: 'photoForm',
        //url:  CPATH+'/uploads/employeePhoto/upload.do',
        //url:  CPATH+'/fileman/upload.do',
        api			: {
            submit	: hum100ukrService.photoUploadFile 
        },
        items		: [{ 
                xtype		: 'filefield',
                buttonOnly	: false,
                fieldLabel	: '사진',
                flex		: 1,
                name		: 'photoFile',
                buttonText	: '파일선택',
                width		: 270,
                labelWidth	: 70
              }
         ]
    });
   
	function openUploadWindow() {
		if(!uploadWin) {				
			uploadWin = Ext.create('Ext.window.Window', {
                title		: '사진등록',
			    closable	: false,
			    closeAction	: 'hide',
			    modal		: true,
			    resizable	: true,
                width		: 300,				                
                height		: 100,  
			    layout		: {
			        type	: 'fit'
			    },
			    
                items		: [ 
                	photoForm,
					{	
						xtype		: 'uniDetailForm',
			 			itemId		: 'photoForm',
			 			disabled	: false,
			 			fileUpload	: true,
			 			//url:  CPATH+'/uploads/employeePhoto/upload.do',
			 			//url:  CPATH+'/fileman/upload.do',
			 			api			: {
                            submit: s_ass900ukrService_KOCIS.photoUploadFile 
                        },
			 			items		:[{ 
    						  	xtype		: 'filefield',
								fieldLabel	: '사진',
								name		: 'photoFile',
								buttonText	: '파일선택',
								buttonOnly	: false,
								labelWidth	: 70,
								flex		: 1,
								width		: 270
				 			  }
			             ]
					}
								
				],
                listeners : {
        			 beforeshow: function( window, eOpts)	{
        			 	var dataform = detailForm.getForm();	
        			 	var config = {
        			 		success : function()	{
								uploadWin.show();	
                			}
            			}
        			 	if(!dataform.isValid())	{
        			 		var invalidFields		= [];
        			 		var invalidFieldNames	= '';
						    dataform.getFields().filterBy(function(field) {
						        if (field.validate()) return;
						        invalidFieldNames = invalidFieldNames+field.fieldLabel+',';
						        invalidFields.push(field);
						    });
							console.log("invalidFields : ", invalidFields);
        			 		alert('필수입력사항을 입력하신 후 사진을 올려주세요.'+ '\n' +'미입력항목: '+invalidFieldNames.substring(0,invalidFieldNames.length-1));
        			 		return false;
        			 		
        			 	} /*else if(UniAppManager.app._needSave())	{
        			 		UniAppManager.app.checkSave(config);
        			 		return false;
        			 	}*/
        			 },
        			 show: function( window, eOpts)	{
        			 	window.center();
        			 }
                },
                afterSuccess: function()	{
                	UniAppManager.app.onQueryButtonDown();
					this.afterSavePhoto();
                },
                afterSavePhoto: function()	{
                	var photoForm = uploadWin.down('#photoForm');
                	photoForm.clearForm();
		            uploadWin.hide();
                },
                tbar:['->',{ 	
            		xtype	: 'button', 
            		text	: '올리기',
            		handler	: function()	{
            			
	                    if(detailForm.getForm().isDirty())	{
							var param	= detailForm.getValues();	
	                    	var config	= {
	                    		success : function(form, action)	{
									var photoForm	= uploadWin.down('#photoForm').getForm();
									param.ITEM_CODE = gsItemCode;
									
									photoForm.submit({
	                    				params	: param,
										waitMsg	: 'Uploading your files...',
										success	: function(form, action)	{	
											gsItemCode = '';
											uploadWin.afterSuccess();
										}
									});
								}
                			}	
				        	UniAppManager.app.onSaveDataButtonDown(config);
				        	
	                    }else {
	                    	var photoForm = uploadWin.down('#photoForm').getForm();
							var param= detailForm.getValues();
							
							photoForm.submit({
	                    		params	: param,
								waitMsg: 'Uploading your files...',
								success: function(form, action)	{		                													
									uploadWin.afterSuccess();
								}
							});
	                    }
            		}
            	 },{ 
            	 	xtype	: 'button', 
            		text	: '닫기',
            		handler	: function()	{
            			var photoForm = uploadWin.down('#photoForm').getForm();
            			if(photoForm.isDirty())	{
            				if(confirm('사진이 변경되었습니다. 저장하시겠습니까?'))	{
            					var config = {
            						success : function()	{
	            						// TODO: fix it!!!
	            						uploadWin.afterSavePhoto();
			                    	}
	                    		}
	                        	UniAppManager.app.onSaveDataButtonDown(config);

                        	}else{
            					// TODO: fix it!!!
            					uploadWin.afterSavePhoto();
            				}
            				
            			} else {
            				uploadWin.hide();
            			}
            		}
            	}]
			});
		}
		uploadWin.show();
	}
	
	
	

    /** main app
	 */
    Unilite.Main({
		id			: 's_ass900ukrApp',
		borderItems	: [{
			region	: 'center',
			layout	: 'border',
			border	: false,
			items	: [
				detailForm, panelResult
			]	
		},
			panelSearch
		],
		
		fnInitBinding : function(params) {
			var activeSForm;
			if(!UserInfo.appOption.collapseLeftSearch)	{
				activeSForm = panelSearch;
			} else {
				activeSForm = panelResult;
			}
			activeSForm.onLoadSelectText('ITEM_CODE');
			
			this.setDefault();
			if(params) {
				this.processParams(params);
			}
		},
		
		processParams: function(params) {
//			this.uniOpt.appParams = params;			
			if(params && params.ITEM_CODE && params.ITEM_NM) {
				if(params.PGM_ID == 's_ass910skr_KOCIS'){						//미술품정보조회
					panelSearch.setValue('ITEM_CODE', params.ITEM_CODE);
					panelSearch.setValue('ITEM_NAME', params.ITEM_NM);
					panelResult.setValue('ITEM_CODE', params.ITEM_CODE);
					panelResult.setValue('ITEM_NAME', params.ITEM_NM);
				}
				UniAppManager.app.onQueryButtonDown(params);
			}
		},
		
		onQueryButtonDown:function (params) {
			if(!this.isValidSearchForm()){
				return false;
			}
			detailForm.clearForm();
			var param= panelSearch.getValues();
			if(Ext.isEmpty(params)){
				detailForm.getEl().mask('로딩중...','loading-indicator');
			}
			detailForm.getForm().load({
				params: param,
				success:function(form, action)	{					
					detailForm.getEl().unmask();
					UniAppManager.setToolbarButtons('delete', true);	
					detailForm.setValue('SAVE_FLAG', 'U');
					detailForm.setDisabled(false);
					UniAppManager.setToolbarButtons('save', false);
					if (action.result.data.IMAGE_DIR) {
						detailForm.down('#EmpImg').getEl().dom.src = CPATH + "/uploads/images/" + action.result.data.ITEM_CODE + '?_dc=' + action.result.data.CHANGE_YN;
						
					} else {
						detailForm.down('#EmpImg').getEl().dom.src = CPATH + '/resources/images/human/noPhoto.png';
					}
				},
				
				failure: function(form, action) {
                    detailForm.getEl().unmask();
					UniAppManager.app.onResetButtonDown();
					UniAppManager.setToolbarButtons('save', false);
                }
			});
		},
		
		onResetButtonDown:function() {
			panelSearch.clearForm();
			panelResult.clearForm();
			detailForm.clearForm();

			detailForm.down('#EmpImg').getEl().dom.src = CPATH + '/resources/images/human/noPhoto.png';
			
			this.fnInitBinding();
		},
		
		onDeleteDataButtonDown: function() {
			if(confirm('현재 데이터를 삭제 합니다.\n 삭제 하시겠습니까?')) {
				detailForm.setValue('SAVE_FLAG','D');
				var param = detailForm.getValues();
				detailForm.getEl().mask('로딩중...','loading-indicator');				
				detailForm.submit({
					params: param,
					success:function(comp, action)	{
						UniAppManager.setToolbarButtons('save', false);
						UniAppManager.updateStatus(Msg.sMB011);
						detailForm.getEl().unmask();
						UniAppManager.app.onResetButtonDown();
					},
					failure: function(form, action){
						detailForm.getEl().unmask();
					}
				});	
			}
		},
		
		onSaveDataButtonDown: function (config) {
			if(!detailForm.setAllFieldsReadOnly(true)){
	    		return false;
	    	}
	    	if (Ext.isEmpty(detailForm.getValue('ACQ_AMT_I')) && Ext.isEmpty(detailForm.getValue('EXPECT_AMT_I')) && Ext.isEmpty(detailForm.getValue('ESTATE_AMT_I'))){
	    		alert('취득가액, 추정가액, 감정가액 중 적어도 하나의 값을 입력해야 합니다.');
	    		return false;
	    	}
	    	//점검여부 체크에 따라 점검내용 내용 있는지 확인(필수 체크)
	    	var firstCheckYN	= detailForm.getValue('FIRST_CHECK_YN');
	    	var secondCheckYN	= detailForm.getValue('SECOND_CHECK_YN');
	    	
	    	if (firstCheckYN && Ext.isEmpty(detailForm.getValue('FIRST_CHECK_DESC'))) {
//	    		detailForm.setValue('FIRST_CHECK_YN', false);
	    		alert('상반기 점검내용을 입력하시기 바랍니다.');
	    		return false;
	    	}
	    	if (secondCheckYN && Ext.isEmpty(detailForm.getValue('SECOND_CHECK_DESC'))) {
//	    		detailForm.setValue('SECOND_CHECK_YN', false);
	    		alert('하반기 점검내용을 입력하시기 바랍니다.');
	    		return false;
	    	}
	    	
			var param= detailForm.getValues();	
			detailForm.getEl().mask('로딩중...','loading-indicator');	
			detailForm.submit({
				 params : param,
				 success : function(form, action) {
	 					detailForm.getForm().wasDirty = false;
						detailForm.resetDirtyStatus();								
	            		detailForm.getEl().unmask();
	            		detailForm.setValue('SAVE_FLAG', 'U');
	            		
	            		if(action.result.ITEM_CODE) {
		            		//저장된 값 불러와서 조회
							saveFlag = false;
	        				panelSearch.setValue('ITEM_CODE', action.result.ITEM_CODE);
							saveFlag = false;
							panelResult.setValue('ITEM_CODE', action.result.ITEM_CODE);
							saveFlag = false;
	        				panelSearch.setValue('ITEM_NAME', detailForm.getValue("ITEM_NM"));
							saveFlag = false;
							panelResult.setValue('ITEM_NAME', detailForm.getValue("ITEM_NM"));
							
							//전역변수에 생성한 item_code 입력
							gsItemCode = action.result.ITEM_CODE;
	            		}
	            		UniAppManager.app.onQueryButtonDown();
						if(Ext.isDefined(config))	{
							config.success.call(this);
						}
	            		UniAppManager.updateStatus(Msg.sMB011);// "저장되었습니다.
				},
				failure: function(form, action) {
                    detailForm.getEl().unmask();
                }	
			});
		},		
		
//		checkSave:function(config)	{
//			var me = this;
//			if( me._needSave() ) {
//				if(confirm(Msg.sMB017 + "\n" + Msg.sMB061))	{					
//					me.onSaveDataButtonDown(config);
//					return false;
//					
//				}else {
//					UniAppManager.setToolbarButtons('save',false);
//				}
//			}
//			return true;
//		},

		setDefault: function() {
			saveFlag = false;
			detailForm.setValue('SAVE_FLAG'		, 'N');								//저장flag
			saveFlag = false;
			detailForm.setValue('CLOSING_YEAR'	, new Date().getFullYear());		//마감년도
			saveFlag = false;
			detailForm.setValue('APP_USER'		, UserInfo.userName);				//담당자
			saveFlag = false;
			detailForm.setValue('DEPT_CODE'		, UserInfo.deptCode);				//기관코드
			saveFlag = false;
			detailForm.setValue('DEPT_NAME'		, UserInfo.deptName);				//기관명

			detailForm.getField('FIRST_CHECK_DATE').setReadOnly(true);
			detailForm.getField('FIRST_CHECK_DESC').setReadOnly(true);
			detailForm.getField('FIRST_CHECK_USR').setReadOnly(true);
			detailForm.getField('SECOND_CHECK_DATE').setReadOnly(true);
			detailForm.getField('SECOND_CHECK_DESC').setReadOnly(true);
			detailForm.getField('SECOND_CHECK_USR').setReadOnly(true);
			
			detailForm.getField('ACQ_AMT_I').setReadOnly(false);
			detailForm.getField('EXPECT_AMT_I').setReadOnly(false);
			
/*
			detailForm.setValue('ACQ_Q'		, 1);						//수량
//			detailForm.setValue('MONEY_UNIT', BsaCodeInfo.gsMoneyUnit);	//화폐단위
			detailForm.setValue('EXCHG_RATE_O', '1');					//환율:1
			detailForm.setValue('DPR_STS', '1');						//상각상태:정상상각
			detailForm.setValue('WASTE_SW', 'N');						//매각/폐기여부:미완료
			detailForm.setValue('DPR_STS2', 'N');						//상각완료여부:미완료
			detailForm.setValue('ACQ_DATE', UniDate.get('today'));		//취득일자
			detailForm.setValue('USE_DATE', UniDate.get('today'));		//사용일자
			detailForm.setValue('DIV_CODE'		, UserInfo.divCode);	//사업장
			detailForm.setValue('UPDATE_DB_USER', UserInfo.userID);		//입력자
			detailForm.setValue('INSERT_DB_USER', UserInfo.userID);		//담당자
			detailForm.setValue('NAME', UserInfo.userName);				//담당자명
			detailForm.getField('NAME').setReadOnly(true);
			detailForm.setValue('PRODUCE_COST'		, 0);				//제조원가비율
			detailForm.setValue('SALE_COST'			, 0);				//영업외비용비율
			detailForm.setValue('STOCK_Q'			, 0);				//재고수량

//			detailForm.setValue('AUTO_TYPE', BsaCodeInfo.gsAutoType);	//자동채번 여부		

			UniAppManager.setToolbarButtons('save'	, false);
			UniAppManager.setToolbarButtons('delete', false);
			UniAppManager.setToolbarButtons('reset'	, true);
		*/
		}
	});
 
	Unilite.createValidator('validator01', {
		forms	: {'formA:':detailForm},
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {			
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			
			var rv = true;
			
			if(newValue == oldValue){
				return true;				
			}

			switch(fieldName) {
				case "ACQ_AMT_I" :			//취득가액
					if(isNaN(newValue)){
						rv = Msg.sMB074;	//숫자만 입력가능합니다.
						alert(rv);
						break;
					}
					if(newValue < 0 && !Ext.isEmpty(newValue))	{
						rv= Msg.sMB076;		//양수만 입력 가능합니다.
						alert(rv);
						break;
					}
				break;
				
				case "EXPECT_AMT_I" :		//추정가액
					if(isNaN(newValue)){
						rv = Msg.sMB074;	//숫자만 입력가능합니다.
						alert(rv);
						break;
					}
					if(newValue < 0 && !Ext.isEmpty(newValue))	{
						rv= Msg.sMB076;		//양수만 입력 가능합니다.
						alert(rv);
						break;
					}
				break;
					
					
				case "ESTATE_AMT_I" :		//감정가액
					if(isNaN(newValue)){
						rv = Msg.sMB074;	//숫자만 입력가능합니다.
						alert(rv);
						break;
					}
					if(newValue < 0 && !Ext.isEmpty(newValue))	{
						rv= Msg.sMB076;		//양수만 입력 가능합니다.
						alert(rv);
						break;
					}
				break;
				
				case "SALES_AMT_I" :		//제품가액
					if(isNaN(newValue)){
						rv = Msg.sMB074;	//숫자만 입력가능합니다.
						alert(rv);
						break;
					}
					if(newValue < 0 && !Ext.isEmpty(newValue))	{
						rv= Msg.sMB076;		//양수만 입력 가능합니다.
						alert(rv);
						break;
					}
				break;
					
					
				case "EXPECT_AMT_I" :		//추정가액
					if(isNaN(newValue)){
						rv = Msg.sMB074;	//숫자만 입력가능합니다.
						break;
					}
					if(newValue < 0 && !Ext.isEmpty(newValue))	{
						rv=Msg.sMB076;	//양수만 입력 가능합니다.
						break;
					}
					if(newValue < 2 || newValue > 60){
						rv= '내용년수는 2~60 사이의 정수만 입력 가능합니다.';
						break;
					}
					var drbYear = '000' + detailForm.getValue('DRB_YEAR') 
					drbYear = drbYear.substring(drbYear.length-3)
				break;
				
				
				
				case "ACQ_Q" :	//취득수량
					detailForm.setValue('STOCK_Q', newValue);
				break;
			}
			return rv;
		} // validator
	});
};

</script>
