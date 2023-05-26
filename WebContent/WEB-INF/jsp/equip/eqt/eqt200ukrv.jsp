<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="eqt200ukrv"  >
	<t:ExtComboStore comboType="BOR120"  /> 			<!-- 사업장 -->
	<t:ExtComboStore comboType="AU" comboCode="P001"/> <!-- 진행상태 -->
	<t:ExtComboStore comboType="AU" comboCode="B039"/> <!-- 출고방법 -->
	<t:ExtComboStore comboType="AU" comboCode="P103"/> <!-- 참조구분 -->
	<t:ExtComboStore comboType="AU" comboCode="0"/>    <!-- 창고 -->
	<t:ExtComboStore comboType="AU" comboCode="M105"/> <!-- 사급구분 -->
	<t:ExtComboStore comboType="AU" comboCode="B081"/> <!-- 대체품목여부 -->
    <t:ExtComboStore comboType="AU" comboCode="P103"/> <!-- 참조구분 -->
    <t:ExtComboStore comboType="AU" comboCode="I800" /> <!-- 장비구분 -->
    <t:ExtComboStore comboType="AU" comboCode="I812" /> <!-- 점검항목 -->
    <t:ExtComboStore comboType="AU" comboCode="I813" /> <!-- 판정기준 -->
    <t:ExtComboStore comboType="AU" comboCode="I814" /> <!-- 판정방법 -->
    <t:ExtComboStore comboType="AU" comboCode="I815" /> <!-- 판정주기 -->
</t:appConfig>
<style type="text/css">
#search_panel1 .x-panel-header-text-container-default {color: #333333;font-weight: normal;padding: 1px 2px;}
</style>
<script type="text/javascript" >

var activeGrid='eqt300ukrvGridTab';

function appMain() {
	 /**
     * 상세 Form
     */
     var ImageForm = Unilite.createForm('lkasdf' +
     		'ImageForm', {
	    	 			 fileUpload: true,
						 url:  CPATH+'/fileman/upload.do',
						 disabled:false,
				    	 width:450,
				    	 height:350,
				    	 //hidden: true,
	    	 			 layout: {type: 'uniTable', columns: 2},
						 items: [
        						  { xtype: 'filefield',
									buttonOnly: false,
									fieldLabel: '사진',
									hideLabel:true,
									width:350,
									name: 'fileUpload',
									buttonText: '파일선택',
									listeners: {change : function( filefield, value, eOpts )	{
															var fileExtention = value.lastIndexOf(".");
															var imgType = value.substring(value.lastIndexOf(".")+1,99);
															var imgName = value.substring(value.lastIndexOf("\\")+1,value.lastIndexOf("."));

															//FIXME : 업로드 확장자 체크, 이미지파일만 upload
															if(value !='' )	{
																ImageForm.setValue("IMG_TYPE",imgType);
																ImageForm.setValue("IMG_NAME",imgName);
																//detailWin.setToolbarButtons(['saveBtn','saveCloseBtn'],true);
		                    						 			//detailWin.setToolbarButtons(['prev','next'],false);
															}
														}
									}
								  }
								  ,{ xtype: 'button', text:'올리기', margin:'0 0 0 2',
								  	 handler:function()	{
								  	 	var config = {success : function()	{
		                    						 		//detailWin.setToolbarButtons(['saveBtn','saveCloseBtn'],false);
		                    						 		//detailWin.setToolbarButtons(['prev','next'],true);
					                    			  }
			                    			}
			                        	UniAppManager.app.onSaveImages(1);
								  	 }
								  }

								  ,{ xtype: 'image', id:'eqt200Image1', src:CPATH+'/resources/images/nameCard.jpg', width:400,	 overflow:'auto', colspan:2}
								  ,{ xtype: 'uniTextfield', id:'equCode1',name:'EQU_CODE',hidden:true}
								  ,{ xtype: 'uniTextfield', id:'serNo1',name:'SER_NO',hidden:true}
								  ,{ xtype: 'uniTextfield', name:'IMG_TYPE',hidden:true}
								  ,{ xtype: 'uniTextfield', name:'IMG_NAME',hidden:true}
					             ]
					   , setImage : function (fid,equCode,serNo)	{
						    	 	var image = Ext.getCmp('eqt200Image1');
						    	 	var src = CPATH+'/resources/images/nameCard.jpg'
						    	 	if(!Ext.isEmpty(fid))	{
							         	//src = CPATH+'/fileman/download.do?fid='+fid+'&inline=Y';
							         	src= CPATH+'/fileman/view/'+fid;
						    	 	}
							        image.setSrc(src);
							        if(!Ext.isEmpty(equCode))
							        ImageForm.setValue("EQU_CODE",equCode);
							        if(!Ext.isEmpty(serNo))
							        ImageForm.setValue("SER_NO",serNo);
						    	 }
	});
     /**
      * 상세 Form
      */
      var ImageForm2 = Unilite.createForm('lkasdf' +
      		'ImageForm2', {
 	    	 			 fileUpload: true,
 						 url:  CPATH+'/fileman/upload.do',
 						 disabled:false,
 				    	 width:450,
 				    	 height:350,
 				    	 //hidden: true,
 	    	 			 layout: {type: 'uniTable', columns: 2},
 						 items: [
         						  { xtype: 'filefield',
 									buttonOnly: false,
 									fieldLabel: '사진',
 									hideLabel:true,
 									width:350,
 									name: 'fileUpload',
 									buttonText: '파일선택',
 									listeners: {change : function( filefield, value, eOpts )	{
					 										var fileExtention = value.lastIndexOf(".");
															var imgType = value.substring(value.lastIndexOf(".")+1,99);
															var imgName = value.substring(value.lastIndexOf("\\")+1,value.lastIndexOf("."));

															//FIXME : 업로드 확장자 체크, 이미지파일만 upload
															if(value !='' )	{
																ImageForm2.setValue("IMG_TYPE",imgType);
																ImageForm2.setValue("IMG_NAME",imgName);
																//detailWin.setToolbarButtons(['saveBtn','saveCloseBtn'],true);
					        						 			//detailWin.setToolbarButtons(['prev','next'],false);
															}
 														}
 									}
 								  }
 								  ,{ xtype: 'button', text:'올리기', margin:'0 0 0 2',
 								  	 handler:function()	{
 								  	 	var config = {success : function()	{
 		                    						 		//detailWin.setToolbarButtons(['saveBtn','saveCloseBtn'],false);
 		                    						 		//detailWin.setToolbarButtons(['prev','next'],true);
 					                    			  }
 			                    			}
 			                        	UniAppManager.app.onSaveImages(2);
 								  	 }
 								  }
 								  ,
 								  { xtype: 'image', id:'eqt200Image2', src:CPATH+'/resources/images/nameCard.jpg', width:400,	 overflow:'auto', colspan:2}
 								 ,{ xtype: 'uniTextfield', id:'equCode2',name:'EQU_CODE',hidden:true}
								  ,{ xtype: 'uniTextfield', id:'serNo2',name:'SER_NO',hidden:true}
								  ,{ xtype: 'uniTextfield', name:'IMG_TYPE',hidden:true}
								  ,{ xtype: 'uniTextfield', name:'IMG_NAME',hidden:true}
 								  ]
 					   , setImage : function (fid,equCode,serNo)	{
 						    	 	var image = Ext.getCmp('eqt200Image2');
 						    	 	var src = CPATH+'/resources/images/nameCard.jpg'
 						    	 	if(!Ext.isEmpty(fid))	{
 							         	//src = CPATH+'/fileman/download.do?fid='+fid+'&inline=Y';
 							         	src= CPATH+'/fileman/view/'+fid;
 						    	 	}
 							        image.setSrc(src);
 							       if(!Ext.isEmpty(equCode))
							        ImageForm2.setValue("EQU_CODE",equCode);
							        if(!Ext.isEmpty(serNo))
							        ImageForm2.setValue("SER_NO",serNo);
 						    	 }
 	});

      /**
       * 상세 Form
       */
       var ImageForm3 = Unilite.createForm('lkasdf' +
       		'ImageForm3', {
  	    	 			 fileUpload: true,
  						 url:  CPATH+'/fileman/upload.do',
  						 disabled:false,
  				    	 width:450,
  				    	 height:350,
  				    	 //hidden: true,
  	    	 			 layout: {type: 'uniTable', columns: 2},
  						 items: [
          						  { xtype: 'filefield',
  									buttonOnly: false,
  									fieldLabel: '사진',
  									hideLabel:true,
  									width:350,
  									name: 'fileUpload',
  									buttonText: '파일선택',
  									listeners: {change : function( filefield, value, eOpts )	{
  															var fileExtention = value.lastIndexOf(".");
															var imgType = value.substring(value.lastIndexOf(".")+1,99);
															var imgName = value.substring(value.lastIndexOf("\\")+1,value.lastIndexOf("."));

															//FIXME : 업로드 확장자 체크, 이미지파일만 upload
															if(value !='' )	{
																ImageForm3.setValue("IMG_TYPE",imgType);
																ImageForm3.setValue("IMG_NAME",imgName);
																//detailWin.setToolbarButtons(['saveBtn','saveCloseBtn'],true);
					        						 			//detailWin.setToolbarButtons(['prev','next'],false);
															}
  														}
  									}
  								  }
  								  ,{ xtype: 'button', text:'올리기', margin:'0 0 0 2',
  								  	 handler:function()	{
  								  	 	var config = {success : function()	{
  		                    						 		//detailWin.setToolbarButtons(['saveBtn','saveCloseBtn'],false);
  		                    						 		//detailWin.setToolbarButtons(['prev','next'],true);
  					                    			  }
  			                    			}
  			                        	UniAppManager.app.onSaveImages(3);
  								  	 }
  								  }
  								  ,
  								  { xtype: 'image', id:'eqt200Image3', src:CPATH+'/resources/images/nameCard.jpg', width:400,	 overflow:'auto', colspan:2}
  								  ,{ xtype: 'uniTextfield', id:'equCode3',name:'EQU_CODE',hidden:true}
								  ,{ xtype: 'uniTextfield', id:'serNo3',name:'SER_NO',hidden:true}
								  ,{ xtype: 'uniTextfield', name:'IMG_TYPE',hidden:true}
								  ,{ xtype: 'uniTextfield', name:'IMG_NAME',hidden:true}
  								  ]
  					   			, setImage : function (fid,equCode,serNo)	{
  						    	 	var image = Ext.getCmp('eqt200Image3');
  						    	 	var src = CPATH+'/resources/images/nameCard.jpg'
  						    	 	if(!Ext.isEmpty(fid))	{
  							         	//src = CPATH+'/fileman/download.do?fid='+fid+'&inline=Y';
  							         	src= CPATH+'/fileman/view/'+fid;
  						    	 	}
  							        image.setSrc(src);
  							        if(!Ext.isEmpty(equCode))
  							        ImageForm3.setValue("EQU_CODE",equCode);
  							        if(!Ext.isEmpty(serNo))
  							        ImageForm3.setValue("SER_NO",serNo);
  						    	 }
  	});




	var directProxy = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read:		'eqt200ukrvService.selectMasterList',
			update:		'eqt200ukrvService.updateMaster',
			create:		'eqt200ukrvService.insertMaster',
			destroy:	'eqt200ukrvService.deleteMaster',
			syncAll:	'eqt200ukrvService.saveAll'
		}
	});

	var directProxy2 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read:		'eqt200ukrvService.selectMasterList2',
			update:		'eqt200ukrvService.updateMaster',
			create:		'eqt200ukrvService.insertMaster',
			destroy:	'eqt200ukrvService.deleteMaster',
			syncAll:	'eqt200ukrvService.saveAll'
		}
	});

	var directProxy3 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read:		'eqt200ukrvService.selectMasterList3',
			update:		'eqt200ukrvService.updateImage',
			create:		'eqt200ukrvService.insertImage',
			destroy:	'eqt200ukrvService.deleteImage',
			syncAll:	'eqt200ukrvService.saveAll2'
		}
	});

//----- 2023.01.30 Dongsoo Park - (설비일상점검내역 Tab추가작업) Start------- //
	var directProxy4 = Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			read:		'eqt200ukrvService.selectMasterList4',
			update:		'eqt200ukrvService.updateMaster',
			create:		'eqt200ukrvService.insertMaster4',
			destroy:	'eqt200ukrvService.deleteMaster',
			syncAll:	'eqt200ukrvService.saveAll4'
		}
	});
//----- 2023.01.30 Dongsoo Park - (설비일상점검내역 Tab추가작업) End------- //

	var panelResult = Unilite.createSearchForm('resultForm',{
    	region: 'north',
		layout : {type : 'uniTable', columns : 3},
		padding:'1 1 1 1',
		border:true,
		items: [{
			fieldLabel:'사업장',
			xtype: 'uniCombobox',
			comboType:'BOR120',
			allowBlank:false,
		    name: 'DIV_CODE',
		    value:UserInfo.divCode

    	}/*,{
			fieldLabel: '장비구분',
			name: 'EQU_CODE_TYPE',
			xtype: 'uniCombobox',
			comboType: 'AU',
			comboCode: 'I800'
		}*/
		,Unilite.popup('EQU_CODE', {
			fieldLabel: '장비번호',
			valueFieldWidth:80,
			valueFieldName: 'EQU_CODE',
	   	 	textFieldName: 'EQU_NAME',
	   	    allowBlank:false,
			listeners: {
				applyextparam: function(popup){
					popup.setExtParam({'DIV_CODE': panelResult.getValue('DIV_CODE')});
				}
			}
		})],

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
                    //  this.mask();
                    }
                } else {
                    this.unmask();
                }
                return r;
            }
	    });

	var masterForm = Unilite.createSearchForm('masterForm',{
		region: 'north',
        layout : {type : 'uniTable', columns : 1},
        padding:'1 1 1 1',
        border:true,
        autoScroll: true,
//        hidden: !UserInfo.appOption.collapseLeftSearch,
        items: [{
            xtype: 'container',
            colspan: 3,
            layout: {type: 'uniTable', columns: 5},
            items:[{
            	name:'EQU_CODE',
            	xtype: 'uniTextfield',
            	hidden : true
            },
            {
            	name:'FROM_DIV_CODE',
            	xtype: 'uniTextfield',
            	hidden : true
            },{
                fieldLabel: '장비명',
                name: 'EQU_NAME',
                xtype: 'uniTextfield',
                width:300,
                colspan:'2',
                readOnly: true,
                listeners: {
                        change: function(field, newValue, oldValue, eOpts) {
                        }
                    }
            },{
                fieldLabel: '규격',
                name: 'EQU_SPEC',
                xtype: 'uniTextfield',
                readOnly:true,
                colspan:'3',
                listeners: {
                        change: function(field, newValue, oldValue, eOpts) {
                        }
                    }
            }
            ,{
                fieldLabel: '자산번호',
                name: 'ASSETS_NO',
                xtype: 'uniTextfield',
                readOnly:true,
                colspan:'2',
                listeners: {
                        change: function(field, newValue, oldValue, eOpts) {
                        }
                    }
            }
            ,{
                fieldLabel: '제작수량',
                name: 'PRODT_Q',
                xtype: 'uniNumberfield',
                colspan:'2',
                readOnly:true,
                listeners: {
                        change: function(field, newValue, oldValue, eOpts) {
                        }
                    }
            }
            ,{
                fieldLabel: '중량',
                name: 'WEIGHT',
                xtype: 'uniNumberfield',
                //decimalPrecision:4,
                readOnly:true,
                listeners: {
                        change: function(field, newValue, oldValue, eOpts) {
                        }
                    }
            }
            ,Unilite.popup('CUST', {
				fieldLabel: '제작처',
				valueFieldName: 'CUSTOM_CODE',
		   	 	textFieldName: 'CUSTOM_NAME',
		   	 	extParam: {'CUSTOM_TYPE': ['1','2']},
		   	 	colspan:'2',
		   	 	readOnly:true,
				listeners: {
					onSelected: {
						fn: function(records, type) {
                    	},
						scope: this
					},
					onClear: function(type)	{
					}
				}
			})
            ,{
                fieldLabel: '제작일',
                name: 'PRODT_DATE',
                xtype: 'uniDatefield',
                colspan:'2',
                readOnly:true,
                listeners: {
                        change: function(field, newValue, oldValue, eOpts) {
                        }
                    }
            }
            ,{
                fieldLabel: '제작금액',
                name: 'PRODT_O',
                xtype: 'uniNumberfield',
                //decimalPrecision:6,
                readOnly:true,
                listeners: {
                        change: function(field, newValue, oldValue, eOpts) {
                        }
                    }
            }
            ,Unilite.popup('CUST', {
				fieldLabel: '보관처',
				valueFieldName: 'USE_CUSTOM_CODE',
		   	 	textFieldName: 'USE_CUSTOM_NAME',
		   	 	extParam: {'CUSTOM_TYPE': ['1','2']},
		   	 	colspan:'2',
		   	 	readOnly:true,
				listeners: {
					onSelected: {
						fn: function(records, type) {
                    	},
						scope: this
					},
					onClear: function(type)	{
					}
				}
			})
            ,{
                fieldLabel: '장비상태',
                name: 'EQU_GRADE',
                xtype: 'uniCombobox',
				comboType:'AU',
				comboCode:'I801',
				colspan:'2',
                readOnly:true,
                listeners: {
                        change: function(field, newValue, oldValue, eOpts) {
                        }
                    }
            }
            ,{
                fieldLabel: '수정금액',
                name: 'REP_O',
                xtype: 'uniNumberfield',
                //decimalPrecision:6,
                readOnly:true,
                listeners: {
                        change: function(field, newValue, oldValue, eOpts) {
                        }
                    }
            },
            {
                fieldLabel: '공정코드',
                name: 'WORK_SHOP_CODE',
                xtype: 'uniTextfield',
                readOnly:true,
                listeners: {
                        change: function(field, newValue, oldValue, eOpts) {
                        }
                    }
            },
            {
                fieldLabel: '',
                name: 'WORK_SHOP_NAME',
                xtype: 'uniTextfield',
                readOnly:true,
                listeners: {
                        change: function(field, newValue, oldValue, eOpts) {
                        }
                    }
            },
            {
                fieldLabel: '금형종류',
                name: 'EQU_TYPE',
                xtype: 'uniCombobox',
				comboType:'AU',
				comboCode:'I802',
				colspan:'2',
                readOnly:true,
                listeners: {
                        change: function(field, newValue, oldValue, eOpts) {
                        }
                    }
            }
            ,{
                xtype: 'container',
                layout: {type: 'uniTable', columns: 2},
                colspan: 2,
                items:[
                	{
                        fieldLabel: '금형재질',
                        name: 'MTRL_TYPE',
                        xtype: 'uniCombobox',
//                        xtype: 'uniTextfield',
                        comboType:'AU',
        				comboCode:'I803',
                        readOnly:true,
                        listeners: {
                                change: function(combo, newValue, oldValue, eOpts) {
//                                	masterForm.setValue('MTRL_TEXT', combo.rawValue);
                                }
                            }
                    }
                    ,{
                        name: 'MTRL_TEXT',
                        xtype: 'uniTextfield',
                        readOnly:true,
                        listeners: {
                                change: function(field, newValue, oldValue, eOpts) {
                                }
                            }
                    }
                ]
            }
            ]
        }],
        api: {
            load: 'eqt200ukrvService.selectOrderNumMaster'
        },
        listeners: {
            uniOnChange:function( basicForm, field, newValue, oldValue ) {
//                if(!oldValue) return false;
//                if(basicForm.isDirty() && newValue != oldValue && directMasterStore2.data.items[0]) {
//                    UniAppManager.setToolbarButtons('save', true);
//                }else {
//                    UniAppManager.setToolbarButtons('save', false);
//                }
//                if(Ext.isEmpty(basicForm.getField('TOT_PACKING_COUNT').getValue())){
//                    basicForm.getField('TOT_PACKING_COUNT').setValue(0);
//                }
            }
         },
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
                    var fields = this.getForm().getFields();
                    Ext.each(fields.items, function(item) {
                        if(Ext.isDefined(item.holdable) )   {
                            if (item.holdable == 'hold') {
                                item.setReadOnly(true);
                            }
                        }
                        if(item.isPopupField)   {
                            var popupFC = item.up('uniPopupField')  ;
                            if(popupFC.holdable == 'hold') {
                                popupFC.setReadOnly(true);
                            }
                        }
                    })
                }
            } else {
                var fields = this.getForm().getFields();
                Ext.each(fields.items, function(item) {
                    if(Ext.isDefined(item.holdable) )   {
                        if (item.holdable == 'hold') {
                            item.setReadOnly(false);
                        }
                    }
                    if(item.isPopupField)   {
                        var popupFC = item.up('uniPopupField')  ;
                        if(popupFC.holdable == 'hold' ) {
                            item.setReadOnly(false);
                        }
                    }
                })
            }
            return r;
        },
        setLoadRecord: function(record) {
            var me = this;
            me.uniOpt.inLoading=false;
//          me.setAllFieldsReadOnly(true);
        },
        loadForm: function(record)  {
//                this.reset();
            this.setActiveRecord(record || null);
            this.resetDirtyStatus();
        }
    });


	/**Model 정의
	 * @type
	 */
//----- 2023.01.30 Dongsoo Park - (설비일상점검내역 Tab추가작업) Start------- //
	Unilite.defineModel('eqt300ukrvMasterModel', {
	    fields: [
			{name: 'DIV_CODE'         	,text: '사업장코드'				,type:'string',allowBlank: false},
			{name: 'WORK_SHOP_CODE'     ,text: '공정코드'				,type:'string',allowBlank: false},
			{name: 'SEQ'         		,text: '순번'				    ,type:'int',allowBlank: false},
			{name: 'EQU_CODE_TYPE'		,text: '장비구분'				,type:'string', allowBlank:false,comboType:'AU', comboCode:'I800' },
			{name: 'EQU_CODE'        	,text: '장비(금형)번호'			,type:'string',allowBlank: false},
			{name: 'CHECKHISTNO'        ,text: '점검항목'				,type:'string',comboType:'AU', comboCode:'I812'},
			{name: 'CHECKNOTE'         	,text: '점검내용'				,type:'string'},
			{name: 'WORKDATE'         	,text: '점검일자'				,type:'uniDate'},
			{name: 'RESULTS_STD'        ,text: '판정기준'				,type:'string',comboType:'AU', comboCode:'I813'},
			{name: 'RESULTS_METHOD'     ,text: '판정방법'				,type:'string',comboType:'AU', comboCode:'I814'},
			{name: 'RESULTS_ROUTINE'    ,text: '판정주기'				,type:'string',comboType:'AU', comboCode:'I815'},
			{name: 'PRESSUREVALUE'    	,text: '압력'					,type:'string'},
			{name: 'INTERFACEFLAG'    	,text: '인터페이스FLAG'			,type:'string'},
			{name: 'INTERFACETIME'    	,text: '인터페이스시간'			,type:'string'},
			{name: 'WORKHISTORYNO'    	,text: '작업지시번호'				,type:'string'}

		]
	});
//----- 2023.01.30 Dongsoo Park - (설비일상점검내역 Tab추가작업) End------- //

	Unilite.defineModel('eqt200ukrvMasterModel', {
	    fields: [
			{name: 'DIV_CODE'         	,text: '사업장코드'				,type:'string',allowBlank: false},
			{name: 'EQU_CODE'        	,text: '장비(금형)번호'			,type:'string',allowBlank: false},
			{name: 'TRANS_DATE'        	,text: '이관일자'				,type:'uniDate',allowBlank: false},
			{name: 'TRANS_SEQ'        	,text: '이관순번'				,type:'int',allowBlank: false},
			{name: 'FROM_DIV_CODE'      ,text: '이전사업장'				,type:'string'},
			{name: 'TRANS_REASON'       ,text: '이관사유'				,type:'string',allowBlank: false},
			{name: 'USE_CUSTOM_CODE'    ,text: '최종 보관처코드'			,type:'string',allowBlank: false},
			{name: 'USE_CUSTOM_NAME'    ,text: '보관처명'				,type:'string',allowBlank: false}
		]
	});

	Unilite.defineModel('eqt200ukrvDetailModel', {
	    fields: [
	    	{name: 'DIV_CODE'        	,text: '사업장코드'			    ,type:'string',allowBlank: false},
			{name: 'EQU_CODE'       	,text: '장비(금형)번호'			,type:'string',allowBlank: false},
			{name: 'REP_DATE'       	,text: '수리일자'				,type:'uniDate',allowBlank: false},
			{name: 'REP_SEQ'       		,text: '수리순번'				,type:'int',allowBlank: false},
			{name: 'PARTS_CODE'       	,text: '장비부품코드'				,type:'string'},
			{name: 'DEF_CODE'       	,text: '고장코드'				,type:'string'},
			{name: 'DEF_REASON'       	,text: '고장원인'				,type:'string'},
			{name: 'REP_CODE'       	,text: '수리코드'				,type:'string'},
			{name: 'REP_YN'       		,text: '수리여부'				,type:'string'},
			{name: 'REP_AMT'       		,text: '수리금액'				,type:'uniPrice'},
			{name: 'REP_COMP'       	,text: '수리업체'				,type:'string'},
			{name: 'REP_COMP_NAME'      ,text: '수리업명'				,type:'string'},
			{name: 'REP_PRSN'       	,text: '수리담당자'				,type:'string'}
		]
	});

/*	Unilite.defineModel('eqt200ukrvImagelModel', {
	    fields: [
	    	{name: 'DIV_CODE'        	,text: '사업장코드'			    ,type:'string'},
			{name: 'EQU_CODE'       	,text: '장비(금형)번호'			,type:'string'},
			{name: 'CTRL_TYPE'       	,text: ''				,type:'string'},
			{name: 'SER_NO'       		,text: ''				,type:'string'},
			{name: 'IMAGE_FID'       	,text: ''				,type:'string'},
			{name: 'IMG_TYPE'       	,text: ''				,type:'string'},
			{name: 'IMG_NAME'       	,text: ''				,type:'string'}
		]
	});*/

	var MasterStore = Unilite.createStore('eqt200ukrvMasterStore', {
		model: 'eqt200ukrvMasterModel',
		autoLoad: false,
		uniOpt: {
			isMaster:	true,			// 상위 버튼 연결
			editable:	true,			// 수정 모드 사용
			deletable:	true,			// 삭제 가능 여부
			useNavi:	false			// prev | next 버튼 사용
		},
		proxy: directProxy,
		loadStoreRecords: function() {
			var param= panelResult.getValues();
			console.log(param);
			this.load({
					params : param,
					callback : function(records,options,success)	{
						if(success)	{
								UniAppManager.setToolbarButtons(['delete', 'newData'], true);
						}
					}
				}
			);
		},
		listeners: {
           	load: function(store, records, successful, eOpts) {


           	}/*,
           	add: function(store, records, index, eOpts) {
           	},
           	update: function(store, record, operation, modifiedFieldNames, eOpts) {
           	},
           	remove: function(store, record, index, isMove, eOpts) {
           	}*/
		},
		// 수정/추가/삭제된 내용 DB에 적용 하기
		saveStore: function() {
			var inValidRecs = this.getInvalidRecords();
			console.log("inValidRecords : ", inValidRecs);
			var toCreate = this.getNewRecords();
       		var toUpdate = this.getUpdatedRecords();
       		var toDelete = this.getRemovedRecords();
       		//insert, update로 새로운 배열 생성(concat)
       		var list = [].concat(toUpdate, toCreate);
			console.log("list:", list);

			var equCode = masterForm.getValue('EQU_CODE');
			//
			Ext.each(list, function(record, index) {
				if(record.data['EQU_CODE'] != equCode) {
					record.set('EQU_CODE', equCode);
				}
			})
			console.log("this.data.filterBy(this.filterInvalidNewRecords).items : ", this.data.filterBy(this.filterInvalidNewRecords));


			var paramMaster= masterForm.getValues();	//syncAll 수정
			paramMaster.TYPE='A'; //模具移动
			if(inValidRecs.length == 0) {
			/*if(config==null) {
			//syncAll 수정
				config = {
						success: function() {
										detailForm.getForm().wasDirty = false;
										detailForm.resetDirtyStatus();
										console.log("set was dirty to false");
										UniAppManager.setToolbarButtons('save', false);
								   }
						  };
				}
					this.syncAll(config);*/
				config = {
						params: [paramMaster],
						success: function(batch, option) {
							panelResult.getForm().wasDirty = false;
							panelResult.resetDirtyStatus();
							console.log("set was dirty to false");
							UniAppManager.setToolbarButtons('save', false);
						 }
				};
				this.syncAllDirect(config);
			} else {
                var grid = Ext.getCmp('eqt200ukrvGrid');
                grid.uniSelectInvalidColumnAndAlert(inValidRecs);
				// alert(Msg.sMB083);
			}
		}
	});

//----- 2023.01.30 Dongsoo Park - (설비일상점검내역 Tab추가작업) Start------- //

 var MasterStore3 = Unilite.createStore('eqt300ukrvMasterStore', {
	    model: 'eqt300ukrvMasterModel',
		autoLoad: false,
		uniOpt: {
			isMaster:	true,			// 상위 버튼 연결
			editable:	true,			// 수정 모드 사용
			deletable:	true,			// 삭제 가능 여부
			useNavi:	false			// prev | next 버튼 사용
		},

		proxy: directProxy4,
		loadStoreRecords: function(){
			var param= panelResult.getValues();
			this.load({
				params : param,
				callback : function(records,options,success)	{
					if(success)	{
							UniAppManager.setToolbarButtons(['delete', 'newData'], true);
					}
				}
			});
     	},

     	saveStore: function() {
			var inValidRecs = this.getInvalidRecords();
			console.log("inValidRecords : ", inValidRecs);

			var toCreate = this.getNewRecords();
       		var toUpdate = this.getUpdatedRecords();
       		var toDelete = this.getRemovedRecords();
       		var list = [].concat(toUpdate, toCreate);
			console.log("list:", list);

			var equCode = panelResult.getValue('EQU_CODE');
			Ext.each(list, function(record, index) {
				if(record.data['EQU_CODE'] != equCode) {
					record.set('EQU_CODE', equCode);
				}
			})
			console.log("this.data.filterBy(this.filterInvalidNewRecords).items : ", this.data.filterBy(this.filterInvalidNewRecords));

			var paramMaster= masterForm.getValues();	//syncAll 수정
			paramMaster.TYPE='C'; //模具维修
			if(inValidRecs.length == 0) {
				config = {
					params: [paramMaster],
					success: function(batch, option) {
						panelResult.getForm().wasDirty = false;
						panelResult.resetDirtyStatus();
						console.log("set was dirty to false");
						//alert('여기까지 디버그!!!.');
						UniAppManager.app.onQueryButtonDown();
						UniAppManager.setToolbarButtons('save', false);
					 }
				};
				this.syncAllDirect(config);
			} else {
                var grid = Ext.getCmp('eqt300ukrvGrid');
                grid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		}
	});

	var MasterGrid3 = Unilite.createGrid('eqt300ukrvGrid', {
	    	layout: 'fit',
	        region:'center',
	        uniOpt: {
				expandLastColumn:	false,
				useRowNumberer:		false
	        },
	    	store: MasterStore3,
	    	features: [ {id : 'MasterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false },
	           	{id : 'MasterGridTotal', 	ftype: 'uniSummary', 	  showSummaryRow: false} ],
	        columns: [
	   			{dataIndex: 'DIV_CODE'        	 	, width: 110, 	hidden: false,comboType:'BOR120'},
	   			{dataIndex: 'SEQ'           		, width: 80, align: 'center' },
	   			{dataIndex: 'WORK_SHOP_CODE'     	, width: 110},
	   			{dataIndex: 'EQU_CODE_TYPE'         , width: 110, 	hidden: false,comboType:'I800'},
	   			{dataIndex: 'EQU_CODE'     			, width: 110},
	   			{dataIndex: 'CHECKHISTNO'     		, width: 110, 	hidden: false,comboType:'I812'},
	   			{dataIndex: 'CHECKNOTE'     		, width: 110},
	   			{dataIndex: 'WORKDATE'     			, width: 110},
	   			{dataIndex: 'RESULTS_STD'         	, width: 110,	hidden: false,comboType:'I813'},
	   			{dataIndex: 'RESULTS_METHOD'     	, width: 110,	hidden: false,comboType:'I814'},
	   			{dataIndex: 'RESULTS_ROUTINE'     	, width: 110,	hidden: false,comboType:'I815'},
	   			{dataIndex: 'PRESSUREVALUE'     	, width: 110},
	   			{dataIndex: 'INTERFACEFLAG'     	, width: 110},
	   			{dataIndex: 'INTERFACETIME'     	, width: 110},
	   			{dataIndex: 'WORKHISTORYNO'     	, width: 110}
			],
			listeners: {
	/*			beforeedit현재는 필요 없음(masterStore에서 uniOpt에 editable:	false처리 해 놓았음	*/
	  			beforeedit: function( editor, e, eOpts ) {
					if (UniUtils.indexOf(e.field,
						['DIV_CODE','WORK_SHOP_CODE','WORKDATE']))
					return false;
	        	}
	  			}
		});
//----- 2023.01.30 Dongsoo Park - (설비일상점검내역 Tab추가작업) End------- //

    var MasterGrid = Unilite.createGrid('eqt200ukrvGrid', {
    	layout: 'fit',
        region:'center',
        uniOpt: {
			expandLastColumn:	false,
			useRowNumberer:		false
        },
    	store: MasterStore,
    	features: [ {id : 'MasterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false },
           	{id : 'MasterGridTotal', 	ftype: 'uniSummary', 	  showSummaryRow: false} ],
        columns: [
        	{dataIndex: 'DIV_CODE'        	 	, width: 110		, hidden: true,comboType:'BOR120'},
			{dataIndex: 'EQU_CODE'     			, width: 110,hidden:true},
			{dataIndex: 'TRANS_SEQ'       		, width: 80,align: 'center'},
			{dataIndex: 'TRANS_DATE'       		, width: 110},
			{dataIndex: 'USE_CUSTOM_CODE'		, width: 110 ,align: 'center',
				   editor: Unilite.popup('CUST_G',
				   		{listeners:{
				   			'onSelected': {
			                    fn: function(records, type  ){
			                    var grdRecord = Ext.getCmp('eqt200ukrvGrid').uniOpt.currentRecord;
			                    grdRecord.set('USE_CUSTOM_CODE',records[0]['CUSTOM_CODE']);
			                    grdRecord.set('USE_CUSTOM_NAME',records[0]['CUSTOM_NAME']);
			                    },
			                    scope: this
			                  },
			                'onClear' : function(type)	{
		                  		var grdRecord = Ext.getCmp('eqt200ukrvGrid').uniOpt.currentRecord;
		                  		grdRecord.set('USE_CUSTOM_CODE', '');
		                  		grdRecord.set('USE_CUSTOM_NAME', '');
			                  }
							}
						} )
				  },
				  {dataIndex: 'USE_CUSTOM_NAME'		, width: 200 ,
					   editor: Unilite.popup('CUST_G',
					   		{listeners:{
					   			'onSelected': {
				                    fn: function(records, type  ){
				                    var grdRecord = Ext.getCmp('eqt200ukrvGrid').uniOpt.currentRecord;
				                    grdRecord.set('USE_CUSTOM_CODE',records[0]['CUSTOM_CODE']);
				                    grdRecord.set('USE_CUSTOM_NAME',records[0]['CUSTOM_NAME']);
				                    },
				                    scope: this
				                  },
				                'onClear' : function(type)	{
			                  		var grdRecord = Ext.getCmp('eqt200ukrvGrid').uniOpt.currentRecord;
			                  		grdRecord.set('USE_CUSTOM_CODE', '');
			                  		grdRecord.set('USE_CUSTOM_NAME', '');
				                  }
								}
							} )
					  },
			{dataIndex: 'FROM_DIV_CODE'       	, width: 110,comboType:'BOR120',hidden:true},
			{dataIndex: 'TRANS_REASON'       	, width: 300}
		],
		listeners: {
/*			beforeedit현재는 필요 없음(masterStore에서 uniOpt에 editable:	false처리 해 놓았음	*/
  			beforeedit: function( editor, e, eOpts ) {
				if (UniUtils.indexOf(e.field,
					['DIV_CODE','TRANS_SEQ','EQU_CODE']))
				return false;

        	}

  			}
	});

    var MasterStore2 = Unilite.createStore('eqt200ukrvMasterStore2', {
		model: 'eqt200ukrvDetailModel',
		autoLoad: false,
		uniOpt: {
			isMaster:	true,			// 상위 버튼 연결
			editable:	true,			// 수정 모드 사용
			deletable:	true,			// 삭제 가능 여부
			useNavi:	false			// prev | next 버튼 사용
		},
		proxy: directProxy2,
		loadStoreRecords: function(){
			var param= panelResult.getValues();
			this.load({
				params : param,
				callback : function(records,options,success)	{
					if(success)	{
							UniAppManager.setToolbarButtons(['delete', 'newData'], true);
					}
				}
			});
     	},

		saveStore: function() {
			var inValidRecs = this.getInvalidRecords();
			console.log("inValidRecords : ", inValidRecs);

			var toCreate = this.getNewRecords();
       		var toUpdate = this.getUpdatedRecords();
       		var toDelete = this.getRemovedRecords();
       		var list = [].concat(toUpdate, toCreate);
			console.log("list:", list);

			var equCode = panelResult.getValue('EQU_CODE');
			Ext.each(list, function(record, index) {
				if(record.data['EQU_CODE'] != equCode) {
					record.set('EQU_CODE', equCode);
				}
			})
			console.log("this.data.filterBy(this.filterInvalidNewRecords).items : ", this.data.filterBy(this.filterInvalidNewRecords));

			var paramMaster= masterForm.getValues();	//syncAll 수정
			paramMaster.TYPE='B'; //模具维修
			if(inValidRecs.length == 0) {
				config = {
					params: [paramMaster],
					success: function(batch, option) {
						panelResult.getForm().wasDirty = false;
						panelResult.resetDirtyStatus();
						console.log("set was dirty to false");
						UniAppManager.app.onQueryButtonDown();
						UniAppManager.setToolbarButtons('save', false);
					 }
				};
				this.syncAllDirect(config);
			} else {
                var grid = Ext.getCmp('eqt200ukrvGrid2');
                grid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
		}
	});

    var MasterGrid2 = Unilite.createGrid('eqt200ukrvGrid2', {
    	layout: 'fit',
        region:'south',
        uniOpt: {
			expandLastColumn: false,
			useRowNumberer: false
        },
    	store: MasterStore2,
    	features: [ {id : 'MasterGridSubTotal', ftype: 'uniGroupingsummary', showSummaryRow: false },
    	           	{id : 'MasterGridTotal', 	ftype: 'uniSummary', 	  showSummaryRow: false} ],
        columns: [
			{dataIndex: 'DIV_CODE'           	, width: 113 , hidden: true,comboType:'BOR120'},
			{dataIndex: 'EQU_CODE'           	, width: 113 , hidden: true},
			{dataIndex: 'REP_SEQ'           	, width: 80, align: 'center' },
			{dataIndex: 'REP_DATE'           	, width: 113 },
			{dataIndex: 'PARTS_CODE'           	, width: 113 , hidden: true},
			{dataIndex: 'DEF_CODE'           	, width: 113 , hidden: true},
			{dataIndex: 'REP_CODE'           	, width: 113 , hidden: true},
			{dataIndex: 'REP_YN'           		, width: 113 , hidden: true},

			{ dataIndex: 'REP_COMP'		,width: 100,
				'editor' : Unilite.popup('CUST_G',{
					textFieldName:'REP_COMP',
					//DBtextFieldName:'REP_COMP',
					extParam:{"CUSTOM_TYPE":['1','2','3']},
					autoPopup:true,
					listeners: {
						'onSelected':  function(records, type  ){
								var grdRecord = Ext.getCmp('eqt200ukrvGrid2').uniOpt.currentRecord;
								grdRecord.set('REP_COMP_NAME',records[0]['CUSTOM_NAME']);
								grdRecord.set('REP_COMP',records[0]['CUSTOM_CODE']);

						},
						'onClear':  function( type  ){
								var grdRecord = Ext.getCmp('eqt200ukrvGrid2').uniOpt.currentRecord;
								grdRecord.set('REP_COMP_NAME','');
								grdRecord.set('REP_COMP','');

						}
					} // listeners
				})
			 },
			{ dataIndex: 'REP_COMP_NAME'		,width: 150 ,
				'editor' : Unilite.popup('CUST_G',{
					textFieldName:'REP_COMP_NAME',
					extParam:{"CUSTOM_TYPE":['1','2','3']},
					autoPopup:true,
					listeners: {
						'onSelected':  function(records, type  ){
								var grdRecord = Ext.getCmp('eqt200ukrvGrid2').uniOpt.currentRecord;
								grdRecord.set('REP_COMP_NAME',records[0]['CUSTOM_NAME']);
								grdRecord.set('REP_COMP',records[0]['CUSTOM_CODE']);


						},
						'onClear':  function( type  ){
								var grdRecord = Ext.getCmp('eqt200ukrvGrid2').uniOpt.currentRecord;
								grdRecord.set('REP_COMP_NAME','');
								grdRecord.set('REP_COMP','');


						}
					} // listeners
				})
			 },

/*			{dataIndex: 'REP_COMP'		, width: 80 , align: 'center',
				   editor: Unilite.popup('CUST_G',
				   		{listeners:{
				   			'onSelected': {
			                    fn: function(records, type  ){
			                    var grdRecord = Ext.getCmp('eqt200ukrvGrid2').uniOpt.currentRecord;
			                    grdRecord.set('REP_COMP',records[0]['CUSTOM_CODE']);
			                    grdRecord.set('REP_COMP_NAME',records[0]['CUSTOM_NAME']);
			                    },
			                    scope: this
			                  },
			                'onClear' : function(type)	{
		                  		var grdRecord = Ext.getCmp('eqt200ukrvGrid').uniOpt.currentRecord;
		                  		grdRecord.set('REP_COMP', '');
		                  		grdRecord.set('REP_COMP_NAME', '');
			                  }
							}
						} )
				  },
		      {dataIndex: 'REP_COMP_NAME'		, width: 150 ,
			   editor: Unilite.popup('CUST_G',
			   		{listeners:{
			   			'onSelected': {
		                    fn: function(records, type  ){
		                    var grdRecord = Ext.getCmp('eqt200ukrvGrid2').uniOpt.currentRecord;
		                    grdRecord.set('REP_COMP',records[0]['CUSTOM_CODE']);
		                    grdRecord.set('REP_COMP_NAME',records[0]['CUSTOM_NAME']);
		                    },
		                    scope: this
		                  },
		                'onClear' : function(type)	{
	                  		var grdRecord = Ext.getCmp('eqt200ukrvGrid').uniOpt.currentRecord;
	                  		grdRecord.set('REP_COMP', '');
	                  		grdRecord.set('REP_COMP_NAME', '');
		                  }
						}
					} )
			  },*/

			{dataIndex: 'REP_AMT'           	, width: 113 },
			{dataIndex: 'DEF_REASON'           	, width: 300 },
			{dataIndex: 'REP_PRSN'           	, width: 113 , hidden: true}

		],
		listeners: {
			beforeedit  : function( editor, e, eOpts ){
				if (UniUtils.indexOf(e.field,
						['DIV_CODE','REP_SEQ','EQU_CODE']))
					return false;
			}
       	}
	});


	Unilite.defineModel('imageViewModel', {
	    fields: [
	    	{name: 'IMAGE_FID'		, text:'이미지id'	, type: 'string'},
	    	{name: 'IMG_TYPE'		, text:'이미지타입'	, type: 'string'},
	    	{name: 'IMG_NAME'		, text:'이미지명'	, type: 'string'}
		]
	});
	var imageViewStore = Unilite.createStore('imageViewStore', {
		model: 'imageViewModel',
		autoLoad: false,
		uniOpt: {
			isMaster:	false,			// 상위 버튼 연결
			editable:	false,			// 수정 모드 사용
			deletable:	false,			// 삭제 가능 여부
			useNavi:	false			// prev | next 버튼 사용
		},
		proxy: {
            type: 'direct',
            api: {
            	   read : 'eqt200ukrvService.imagesList'
            }
        },
		loadStoreRecords: function() {
			var param= panelResult.getValues();
			if(Ext.isEmpty(masterForm.getValue('EQU_GRADE'))){
				param.CTRL_TYPE = '';
			}else{
				param.CTRL_TYPE = masterForm.getValue('EQU_GRADE');
			}
			this.load({
				params : param
//				callback : function(records,options,success)	{
//					if(success)	{
//							UniAppManager.setToolbarButtons(['delete', 'newData'], true);
//					}
//				}
			});
		},
		listeners: {
           	load: function(store, records, successful, eOpts) {


           	}/*,
           	add: function(store, records, index, eOpts) {
           	},
           	update: function(store, record, operation, modifiedFieldNames, eOpts) {
           	},
           	remove: function(store, record, index, isMove, eOpts) {
           	}*/
		}
	});

	var itemImageForm = Unilite.createForm('eqt200ImageForm' +'itemImageForm', {
		region: 'north',
		fileUpload: true,
 //url:  CPATH+'/fileman/upload.do',
		api:{ submit: eqt200ukrvService.uploadPhoto},
		disabled:false,
//		border:true,
//		layout: {type: 'uniTable', columns: 1},
	        layout: {type: 'vbox', align:'stretch'},
		items: [{
			xtype:'uniFieldset',
			layout: {
	            type: 'uniTable',
	            columns: 2,
	            tdAttrs: {valign:'top'}
	        },
	        padding: '5 5 5 5',
			width:430,
//            height:250,
	        items :[{
				xtype: 'filefield',
				buttonOnly: false,
				fieldLabel: '사진',
				hideLabel:true,
				width:350,
				name: 'fileUpload',
				buttonText: '파일선택',
				listeners: {
					change : function( filefield, value, eOpts )	{
						itemImageForm.setValue('_fileChange', 'true');
					}
				}
			},{
				xtype: 'button',
				text:'사진저장',
				margin:'0 0 0 2',
				handler:function()	{
					if(Ext.isEmpty(masterForm.getValue('EQU_CODE')))	{
						alert('장비(금형)번호가 없습니다. 저장 후 사진을 올려주세요.');
						return;
					}
					itemImageForm.submit( {
						params :{
	 						'DIV_CODE':panelResult.getValue('DIV_CODE'),
	 						'EQU_CODE':masterForm.getValue('EQU_CODE'),
	 						'CTRL_TYPE': masterForm.getValue('EQU_GRADE')
	 					},
						success : function(){
//							var selRecord = masterGrid.getSelectedRecord();
//							UniAppManager.app.onQueryButtonDown();
							UniAppManager.app.onQueryButtonDown();
						}
		    		});
				}
			},{
				name: '_fileChange',
				fieldLabel: '사진수정여부',
				hidden:true
			}/*,{
				xtype: 'image',
				id:'eqt200',
				src:CPATH+'/resources/images/nameCard.jpg',
				width:415,
				overflow:'auto',
				colspan:2
			}*/]
		}/*,{
				xtype: 'image',
				id:'eqt2002',
				src:'C:\OmegaPlus\upload/default/EquipmentPhoto/MASTER0100-X-999A531.png',
				overflow:'auto',
				width:415
			}*//*{
			xtype:'uniFieldset',
	        layout: {type: 'vbox', align:'stretch'},
	        padding: '5 5 5 5',
			width:1000,
            height:300,
	        items :[imagesView

	        ]
		}*/]
		/*setImage : function (fid)	{
			var image = Ext.getCmp('eqt200');
			var src = CPATH+'/resources/images/nameCard.jpg';
			if(!Ext.isEmpty(fid))	{
	         	src= CPATH+'/equit/eqtPhoto/'+fid;
		 	}
			image.setSrc(src);
		}*/
	});

//    var imagesViewport = Ext.create('Ext.container.Viewport', {
//		layout:  {	type: 'hbox', pack: 'start', align: 'stretch' },
//		  items:[imagesView]
//	})
    var imagesView = Ext.create('Ext.view.View', {
		tpl: ['<tpl for=".">'+

        		'<div class="thumb-wrap"><img src="'+ CPATH+'/equit/eqtPhoto/{IMAGE_FID}.{IMG_TYPE}" height= "200" width="400"></div>'+
         	  '</tpl>'
         	  ],
//        itemSelector: 'div.data-source ',
//		height:320,
		width:1000,
        flex:1,
        store: imageViewStore,
        frame:true,
		trackOver: true,
		itemSelector: 'div.thumb-wrap',
        overItemCls: 'x-item-over',
        scrollable:true

	/*	tpl: [
//			'<tpl for=".">',
////                '<div class="thumb-wrap">',
//                    '<div class="x-view-item-focused x-item-selected"><img src="'+CPATH+'/equit/equPhoto/{IMG_NAME}" width="100"></div>',
//
////                '</div>',
//            '</tpl>'
////            '<div class="x-clear"></div>'
		'<tpl for=".">' +
                '<div class="thumb-wrap"><table><tbody>' +
                    '<tr><td>Name</td><td class="patient-name">{IMG_NAME}</td></tr>' +
                '</tbody></table></div>' +
             '</tpl>'


//
//		'<tpl for=".">',
//                '<div class="thumb-wrap">',
////                    '<div class="thumb"><img src="C:/OmegaPlus/upload/default/EquipmentPhoto/{IMG_NAME}" title="테스트1" width="100"></div>',
//                '<div class="thumb"><img src="C:/OmegaPlus/upload/default/EquipmentPhoto/{IMG_NAME}" title="테스트1" width="100"></div>',
//// '<div class="thumb"><img src="'+CPATH+'/uploads/employeePhoto/S201710003" title="{NAME:htmlEncode}" width="100"></div>',
//                '</div>',
//            '</tpl>',
//            '<div class="x-clear"></div>'
		],
//		height:320,width:500,

        frame:true,
//		border:true,
//		autoScroll:true,
		trackOver: true,
		itemSelector: 'div.thumb-wrap',
//		selectedItemCls : 'consulting-portlet',
		overItemCls: 'x-item-over',
        store: imageViewStore
//        margin:'1 1 1 1'
	*/
	});


    var tab = Unilite.createTabPanel('tabPanel',{
        activeTab: 0,
        region: 'center',
        items: [
//----- 2023.01.30 Dongsoo Park - (설비일상점검내역 Tab추가작업) Start------- //
/**        {
              title: '일상점검내역'
             ,xtype:'container'
             ,layout:{type:'vbox', align:'stretch'}
             ,items:[MasterGrid3]
             ,id: 'eqt300ukrvGridTab'
 		},  **/
//----- 2023.01.30 Dongsoo Park - (설비일상점검내역 Tab추가작업) End------- //
         {
              title: '장비이동현황'
             ,xtype:'container'
             ,layout:{type:'vbox', align:'stretch'}
             ,items:[MasterGrid]
             ,id: 'eqt200ukrvGridTab'
        },{
              title: '수리변경내역'		//20210917 수정: 수정 -> 수리
             ,xtype:'container'
             ,layout:{type:'vbox', align:'stretch'}
             ,items:[MasterGrid2]
             ,id: 'eqt200ukrvGridTab2'
        } ,{
            title: '사진참조'
            ,xtype:'container'
            ,layout:{type:'vbox', align:'stretch'}
            ,items:[itemImageForm,
            {
			xtype:'uniFieldset',
	        layout: {type: 'vbox', align:'stretch'},
	        padding: '5 5 5 5',
	        flex:1,
			width:1000,
//            height:300,
	        items :[imagesView

	        ]}
            ]
            ,id: 'eqt200ukrvGridTab3'
       }


           /* ,{
               title: '图片'
                   ,xtype:'container'
                   ,hidden:true
                   ,layout:{type:'vbox', align:'stretch'}
                   ,items:[MasterGrid3]
                   ,id: 'eqt200ukrvGridTab4'
                  } */],
        listeners:  {
            tabChange:  function ( tabPanel, newCard, oldCard, eOpts )  {
            	activeGrid=newCard.id;
            	if(panelResult.setAllFieldsReadOnly(true) == false)   // 필수값을 체크
    			{
            		return false;
    			}else{
    				if(activeGrid=="eqt200ukrvGridTab"){
	            		MasterStore.loadStoreRecords();
	            	}else if(activeGrid=="eqt200ukrvGridTab2")
	            	{
	            		MasterStore2.loadStoreRecords();
	            	}else if(activeGrid=="eqt200ukrvGridTab3")
	            	{

	            		imageViewStore.loadStoreRecords();
	            		/*MasterStore3.loadStoreRecords();
	            		UniAppManager.setToolbarButtons('delete',false);
                        UniAppManager.setToolbarButtons('newData',false);*/
	            	}else if(activeGrid=="eqt300ukrvGridTab"){
	            		MasterStore3.loadStoreRecords();
	            	}

    			}
            }
        }
    });
    Unilite.Main({
		id: 'eqt200ukrvApp',
		borderItems:[{
			region:'center',
			layout: 'border',
			border: false,
			items:[
				panelResult ,masterForm,tab
			]
		}
		],
		fnInitBinding: function(params) {
			UniAppManager.setToolbarButtons(['reset', 'prev', 'next'], true);
			panelResult.setValue("DIV_CODE",UserInfo.divCode);
		},
		onQueryButtonDown: function() {
			if(panelResult.setAllFieldsReadOnly(true) == false)   // 필수값을 체크
			{
        		return false;
			}else{
				var param= panelResult.getValues();
                masterForm.uniOpt.inLoading=true;
                Ext.getBody().mask('로딩중...','loading-indicator');
                masterForm.getForm().load({
                    params: param,
                    success:function(actionform, action)    {
                        panelResult.setValue("EQU_CODE",action.result.data.EQU_CODE);
                        masterForm.uniOpt.inLoading=false;
                       if(activeGrid=="eqt200ukrvGridTab")
            			{
                        	MasterStore.loadStoreRecords();
            			}else if(activeGrid=="eqt200ukrvGridTab2")
            			{
            				MasterStore2.loadStoreRecords();
            			}else if(activeGrid=="eqt200ukrvGridTab3")
            			{
            				imageViewStore.loadStoreRecords();
//            				UniAppManager.app.onQueryImages();
            			}else if(activeGrid=="eqt300ukrvGridTab")
	           			{
            			    MasterStore3.loadStoreRecords();
	           			}

                        UniAppManager.setToolbarButtons('delete',true);
                        UniAppManager.setToolbarButtons('newData',true);
                        Ext.getBody().unmask();
                    },
                     failure: function(batch, option) {
                    	UniAppManager.setToolbarButtons('delete',false);
                        UniAppManager.setToolbarButtons('newData',false);
                        console.log("option:",option);
                        masterForm.uniOpt.inLoading=false;
                        Ext.getBody().unmask();
                     }
                });

			}
		},
		onPrevDataButtonDown:  function()   {
            var param= panelResult.getValues();
            	param.page="prev";
                masterForm.uniOpt.inLoading=true;
                Ext.getBody().mask('로딩중...','loading-indicator');
                masterForm.getForm().load({
                    params: param,
                    success:function(actionform, action)    {
                        panelResult.setValue("EQU_CODE",action.result.data.EQU_CODE);
                        masterForm.uniOpt.inLoading=false;
                        if(activeGrid=="eqt200ukrvGridTab")
            			{
                        	MasterStore.loadStoreRecords();
            			}else if(activeGrid=="eqt200ukrvGridTab2")
            			{
            				MasterStore2.loadStoreRecords();
            			}else if(activeGrid=="eqt200ukrvGridTab3")
            			{
//            				UniAppManager.app.onQueryImages();
            			}else if(activeGrid=="eqt300ukrvGridTab")
            			{
                        	MasterStore3.loadStoreRecords();
            			}

                        UniAppManager.setToolbarButtons('deleteAll',true);
//                        Ext.getCmp("btn_3").enable();
                        Ext.getBody().unmask();
                    },
                     failure: function(batch, option) {
                        console.log("option:",option);
                        Ext.Msg.alert("확인",'<t:message code="unilite.msg.sMS035"  default="자료의 처음입니다" />');
                        //UniAppManager.app.onResetButtonDown();
                        masterForm.uniOpt.inLoading=false;
                        Ext.getBody().unmask();
                     }
                });
            console.log("param:",param);

            UniAppManager.setToolbarButtons('excel',true);
        },
        onNextDataButtonDown:  function()   {
            var param= panelResult.getValues();
            	param.page="next";
                masterForm.uniOpt.inLoading=true;
                Ext.getBody().mask('로딩중...','loading-indicator');
                masterForm.getForm().load({
                    params: param,
                    success:function(actionform, action)    {
                        panelResult.setValue("EQU_CODE",action.result.data.EQU_CODE);
                        masterForm.uniOpt.inLoading=false;
                       if(activeGrid=="eqt200ukrvGridTab")
            			{
                        	MasterStore.loadStoreRecords();
            			}else if(activeGrid=="eqt200ukrvGridTab2")
            			{
            				MasterStore2.loadStoreRecords();
            			}else if(activeGrid=="eqt200ukrvGridTab3")
            			{
//            				UniAppManager.app.onQueryImages();
            			}else if(activeGrid=="eqt300ukrvGridTab")
            			{
                        	MasterStore3.loadStoreRecords();
            			}

                        UniAppManager.setToolbarButtons('deleteAll',true);
//                        Ext.getCmp("btn_3").enable();
                        Ext.getBody().unmask();
                    },
                     failure: function(batch, option) {
                        console.log("option:",option);
                        Ext.Msg.alert("확인",'<t:message code="unilite.msg.sMS036"  default="자료의 마지막입니다" />');
                        masterForm.uniOpt.inLoading=false;
                        Ext.getBody().unmask();
                     }
                });
            console.log("param:",param);

            UniAppManager.setToolbarButtons('excel',true);
        },
		onResetButtonDown: function() {
			panelResult.clearForm();
            masterForm.clearForm();
            MasterGrid.getStore().loadData({});
            MasterGrid2.getStore().loadData({});
            MasterGrid3.getStore().loadData({});
            itemImageForm.clearForm();
            imageViewStore.loadData({});

            UniAppManager.setToolbarButtons('save', false);
            UniAppManager.setToolbarButtons('deleteAll', false);
            UniAppManager.setToolbarButtons('delete', false);
            UniAppManager.setToolbarButtons('newData', false);
			this.fnInitBinding();
		},
		onNewDataButtonDown: function()	{
		 if(activeGrid=="eqt300ukrvGridTab"){
				var seq = MasterStore3.max('SEQ');
   	           	 if(!seq) seq = 1;
   	           	 else  seq += 1;
           		var r={
           			DIV_CODE:panelResult.getValue("DIV_CODE")
           			,SEQ:seq
           			,EQU_CODE:masterForm.getValue("EQU_CODE")
           			,WORKDATE:new Date()
           			,WORK_SHOP_CODE:masterForm.getValue("WORK_SHOP_CODE")
       				,CHECKHISTNO:''
       				,CHECKNOTE:''
       				,RESULTS_STD:''
       				,RESULTS_METHOD:''
       				,RESULTS_ROUTINE:''
           		};
           		MasterGrid3.createRow(r);
        	}else if(activeGrid=="eqt200ukrvGridTab"){
				var seq = MasterStore.max('TRANS_SEQ');
	           	 if(!seq) seq = 1;
	           	 else  seq += 1;
        		var r={
        			DIV_CODE:panelResult.getValue("DIV_CODE")
        			,TRANS_SEQ:seq
        			,EQU_CODE:masterForm.getValue("EQU_CODE")
        			,TRANS_DATE:new Date()
        			,FROM_DIV_CODE:panelResult.getValue("DIV_CODE")
        			,TRANS_REASON:''
        			,USE_CUSTOM_CODE:''
        		};
        		MasterGrid.createRow(r);
        	}else if(activeGrid=="eqt200ukrvGridTab2")
        	{
        		var seq = MasterStore2.max('REP_SEQ');
	           	 if(!seq) seq = 1;
	           	 else  seq += 1;
	       		var r={
	       			DIV_CODE:panelResult.getValue("DIV_CODE")
	       			,EQU_CODE:masterForm.getValue("EQU_CODE")
	       			,REP_SEQ:seq
	       			,REP_DATE:new Date()
	       			,PARTS_CODE:''
	       			,DEF_CODE:''
	       			,DEF_REASON:''
	       			,REP_CODE:''
	       			,REP_YN:''
	       			,REP_AMT:''
	       			,REP_COMP:''
	       			,REP_PRSN:''
	       		};
	       		MasterGrid2.createRow(r);
        	}else if(activeGrid=="eqt200ukrvGridTab3")
        	{
        		//MasterStore3.loadStoreRecords();
        	}
		},
		onDeleteDataButtonDown: function() {
			var selRow = MasterGrid.getSelectedRecord();

			if(activeGrid=="eqt200ukrvGridTab")
			{
				selRow= MasterGrid.getSelectedRecord();
			}else if(activeGrid=="eqt200ukrvGridTab2")
			{
				selRow= MasterGrid2.getSelectedRecord();
			}else if(activeGrid=="eqt200ukrvGridTab3")
			{
				//selRow= MasterGrid3.getSelectedRecord();
			}else if(activeGrid=="eqt300ukrvGridTab")
			{
				selRow= MasterGrid3.getSelectedRecord();
			}

			if(selRow.phantom === true) {
				MasterGrid.getSelectedRecord();
				MasterGrid2.getSelectedRecord();
				MasterGrid3.getSelectedRecord();
            }else if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
            	MasterGrid.deleteSelectedRow();
				MasterGrid2.deleteSelectedRow();
				MasterGrid3.deleteSelectedRow();
            }
			UniAppManager.setToolbarButtons('save', true);
		},
		onSaveDataButtonDown: function() {

	//		Ext.Msg.alert("확인",'여기까지123.....');

			if(activeGrid=="eqt200ukrvGridTab")
			{
			 	MasterStore.saveStore();
			}else if(activeGrid=="eqt200ukrvGridTab2")
			{
				MasterStore2.saveStore();
			}else if(activeGrid=="eqt200ukrvGridTab3")
			{
//				MasterStore3.saveStore();
			}else if(activeGrid=="eqt300ukrvGridTab")
			{
				MasterStore3.saveStore();
			}
		}
	});


	Unilite.createValidator('validator', {   		//  Grid 2 createValidator
		store: MasterStore2,
		grid: MasterGrid2,
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {
			console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
			var rv = true;
			if(record.get('OUTSTOCK_REQ_Q') > 0){
                alert('출고요청된 수량이 있어 수정이 불가능합니다.');
                return false;
            }
			switch(fieldName) {
				case "UNIT_Q" : // "원단위량"
					if(newValue < 0 ){
						rv='<t:message code="unilite.msg.sMP570"/>';
						//0보다 큰수만 입력가능합니다.
					break;
					}
					record.set('ALLOCK_Q', newValue * MasterGrid.getSelectedRecord().get('WKORD_Q'))
				break;
			}
			return rv;
		}
	});
}
</script>
