<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="bor120ukrv"  >
	<t:ExtComboStore comboType="BOR120" /><!-- 사업장    -->
	<t:ExtComboStore comboType="AU" comboCode="A004" /> 							<!-- 사용여부 -->
	<t:ExtComboStore comboType="AU" comboCode="A020" />
</t:appConfig>
<script type="text/javascript">
  var protocol =   ("https:" == document.location.protocol)  ? "https" : "http"  ;
  if(protocol == "https")	{
	  document.write( unescape( "%3Cscript src='"+ protocol+ "://ssl.daumcdn.net/dmaps/map_js_init/postcode.v2.js' type='text/javascript' %3E %3C/script%3E")  );
  }else {
  	document.write( unescape( "%3Cscript src='"+ protocol+ "://dmaps.daum.net/map_js_init/postcode.v2.js' type='text/javascript' %3E %3C/script%3E") );
  }
</script><!-- Unilite.popup('ZIP',..) -->
<script type="text/javascript" >
var detailWin;
function appMain() {

	/**
	 * Model 정의
	 * @type
	 */

	Unilite.defineModel('bor120ukrvModel', {
		// pkGen : user, system(default)
	    fields: [ 	 {name: 'DIV_CODE'					,text:'<t:message code="system.label.base.divisioncode" default="사업장코드"/>'					,type : 'string', allowBlank:false ,allowBlank:false, isPk:true, pkGen:'user'}
					,{name: 'DIV_NAME'					,text:'<t:message code="system.label.base.divisionname" default="사업장명"/>'					,type : 'string', allowBlank:false }
					,{name: 'DIV_FULL_NAME'				,text:'<t:message code="system.label.base.divfullname" default="사업장전명"/>'					,type : 'string'}
					,{name: 'COMPANY_NUM'				,text:'<t:message code="system.label.base.compnum" default="사업자등록번호"/>'						,type : 'string'}
					,{name: 'REPRE_NAME'				,text:'<t:message code="system.label.base.representativename" default="대표자명"/>'				,type : 'string'}
					,{name: 'REPRE_NO'					,text:'<t:message code="system.label.base.socialsecuritynumber" default="주민번호"/>'			,type : 'string'}
					,{name: 'REPRE_NO_EXPOS'			,text:'<t:message code="system.label.base.socialsecuritynumber" default="주민번호"/>'			,type : 'string', defaultValue:'*************'}
					,{name: 'COMP_CLASS'				,text:'<t:message code="system.label.base.businesstype" default="업종"/>'						,type : 'string'}
					,{name: 'COMP_TYPE'					,text:'<t:message code="system.label.base.businessconditions" default="업태"/>'				,type : 'string'}
					,{name: 'ZIP_CODE'					,text:'<t:message code="system.label.base.zipcode" default="우편번호"/>'						,type : 'string'}
					,{name: 'ADDR'						,text:'<t:message code="system.label.base.address" default="주소"/>'							,type : 'string'}
					,{name: 'TELEPHON'					,text:'<t:message code="system.label.base.phoneno" default="전화번호"/>'						,type : 'string'}
					,{name: 'FAX_NUM'					,text:'<t:message code="system.label.base.faxno" default="팩스번호"/>'							,type : 'string'}
					,{name: 'SAFFER_TAX'				,text:'<t:message code="system.label.base.saffertax" default="신고세무서"/>'						,type : 'string'}
					,{name: 'SAFFER_TAX_NM'				,text:'<t:message code="system.label.base.saffertaxname" default="신고세무서명"/>'				,type : 'string'}
					,{name: 'BILL_DIV_CODE'				,text:'<t:message code="system.label.base.declaredivisioncode2" default="신고사업장코드"/>'		,type : 'string', allowBlank:false }
					,{name: 'BILL_DIV_NAME'				,text:'<t:message code="system.label.base.declaredivisionname" default="신고사업장명"/>'			,type : 'string'}
					//20161024 추가 / 순서 변경
					,{name: 'HANDPHONE'					,text:'<t:message code="system.label.base.handphone" default="사업장 휴대전화"/>'					,type : 'string'}
					,{name: 'EMAIL'						,text:'<t:message code="system.label.base.businessemail" default="사업자 E-MAIL"/>'				,type : 'string'}
					,{name: 'SUB_DIV_NUM'				,text:'<t:message code="system.label.base.servantbusinessnum" default="종사업자번호"/>'			,type : 'string'}
					//20210610 추가
					,{name: 'SERVANT_COMPANY_NUM_YETA'	,text:'<t:message code="system.label.base.servantcompanynumyeta" default="종사업자번호(연말정산용)"/>',type : 'string'}
					,{name: 'HOMETAX_ID'				,text:'<t:message code="system.label.base.hometaxid" default="홈텍스ID"/>'						,type : 'string'}
					,{name: 'BANK_CODE'					,text:'<t:message code="system.label.base.bankcode" default="은행코드"/>'						,type : 'string'}
					,{name: 'BANK_NAME'					,text:'<t:message code="system.label.base.bankname" default="은행명"/>'						,type : 'string'}
					,{name: 'BANK_BOOK_NUM' 			,text:'<t:message code="system.label.base.bankaccount" default="계좌번호"/>'					,type : 'string'}
					,{name: 'TAX_NAME'					,text:'<t:message code="system.label.base.taxname" default="세무대리인 성명"/>'					,type : 'string'}
					,{name: 'TAX_NUM'					,text:'<t:message code="system.label.base.taxnum" default="세무대리인 사업자번호"/>'					,type : 'string'}
					,{name: 'TAX_TEL'					,text:'<t:message code="system.label.base.textel" default="세무대리인 전화번호"/>'					,type : 'string'}
					,{name: 'TAX_ADDR'					,text:'<t:message code="system.label.base.texaddr" default="세무대리인 주소"/>'					,type : 'string'}
					,{name: 'COMP_CODE'					,text:'<t:message code="system.label.base.companycode" default="법인코드"/>'					,type : 'string', allowBlank:false	, defaultValue:UserInfo.compCode}
					,{name: 'USE_YN'					,text:'<t:message code="system.label.base.useflag" default="사용유무"/>'						,type : 'string', allowBlank:false	, comboType:'AU'	, comboCode: 'A004'	/*, defaultValue:'Y'*/}
					,{name: 'YEAR_EVALUATION_YN'		,text:'<t:message code="system.label.base.yearevaluationyn" default="원가계산시 년누적계산여부"/>'		,type : 'string', comboType:'AU'	, comboCode: 'A020', 	defaultValue:'N'}
					
			]
	});

  	var directProxy= Ext.create('Unilite.com.data.proxy.UniDirectProxy',{
		api: {
			 read   : 'bor120ukrvService.selectList'
        	,update : 'bor120ukrvService.updateMulti'
			,create : 'bor120ukrvService.insertMulti'
			,destroy: 'bor120ukrvService.deleteMulti'
			,syncAll: 'bor120ukrvService.saveAll'
		}
	});

	/**
	 * Store 정의(Service 정의)
	 * @type
	 */
	var directMasterStore = Unilite.createStore('bor120ukrvMasterStore',{
			model: 'bor120ukrvModel',
            autoLoad: false,
            uniOpt : {
            	isMaster: true,			// 상위 버튼 연결
            	editable: true,			// 수정 모드 사용
            	deletable:true,			// 삭제 가능 여부
	            useNavi : false			// prev | next 버튼 사용
            },

            proxy: directProxy

			// Store 관련 BL 로직
            // 검색 조건을 통해 DB에서 데이타 읽어 오기
			,loadStoreRecords : function()	{
				var param= panelSearch.getValues();
				console.log( param );
				this.load({
								params : param,
								callback : function(records, operation, success) {
									if(success)	{

									}
								}
							}
				);

			}
			// 수정/추가/삭제된 내용 DB에 적용 하기
			,saveStore : function(config)	{
				var inValidRecs = this.getInvalidRecords();
				console.log("inValidRecords : ", inValidRecs);
				if(inValidRecs.length == 0 )	{
					this.syncAllDirect(config);

				}else {
					masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
				}
			}
		});

	/**
	 * 검색조건 (Search Panel)
	 * @type
	 */
	var panelSearch = Unilite.createSearchPanel('bor120ukrvSearchForm', {
		title: '<t:message code="system.label.base.searchconditon" default="검색조건"/>',
		border: false,
		defaultType: 'uniSearchSubPanel',
		collapsed: UserInfo.appOption.collapseLeftSearch,
        listeners: {
	        collapse: function () {
	        	panelResult.show();
	        },
	        expand: function() {
	        	panelResult.hide();
	        }
	    },
			items: [{
				title: '<t:message code="system.label.base.basisinfo2" default="기본정보"/>',
				itemId: 'search_panel1',
				layout: {type: 'vbox', align: 'stretch'},
	            items: [{
	        		xtype: 'container',
	        		layout: {type: 'uniTable', columns: 1},
	        		items: [{fieldLabel: '<t:message code="system.label.base.division" default="사업장"/>'			,name:'DIV_CODE', 		xtype: 'uniCombobox', comboType:'BOR120',
		        		listeners: {
							change: function(field, newValue, oldValue, eOpts) {
								panelResult.setValue('DIV_CODE', newValue);
						}
					}
				}]
			}]
		}]

    });

    var panelResult = Unilite.createSearchForm('bor120ukrvResultForm',{
		weight:-100,
    	region: 'north',
		layout : {type : 'uniTable', columns : 3},
		hidden: !UserInfo.appOption.collapseLeftSearch,
		padding:'1 1 1 1',
		border:true,
		items: [{
        		xtype: 'container',
        		layout: {type: 'uniTable', columns: 1},
        		items: [{fieldLabel: '<t:message code="system.label.base.division" default="사업장"/>'			,name:'DIV_CODE', 		xtype: 'uniCombobox', comboType:'BOR120',
	        		listeners: {
					change: function(field, newValue, oldValue, eOpts) {
						panelSearch.setValue('DIV_CODE', newValue);
					}
				}
			}]
		}]
    });

    /**
     * Master Grid 정의(Grid Panel)
     * @type
     */
    var masterGrid = Unilite.createGrid('bor120ukrvGrid', {
        layout : 'fit',
        store: directMasterStore,
		uniOpt:{
				 expandLastColumn: true
				,useRowNumberer: false
				,useMultipleSorting: true
    		},
		columns:[	 { dataIndex: 'DIV_CODE',  width: 80 ,isLink:true}
					,{ dataIndex: 'DIV_NAME',  width: 120 }
					,{ dataIndex: 'DIV_FULL_NAME',  width: 180}
					,{ dataIndex: 'COMPANY_NUM',  width: 100 }
					,{ dataIndex: 'REPRE_NAME',  width: 120 }
					,{ dataIndex: 'REPRE_NO',  width: 100, hidden : true }
					,{ dataIndex: 'REPRE_NO_EXPOS',  width: 100}
					,{ dataIndex: 'COMP_CLASS',  width: 100 }
					,{ dataIndex: 'COMP_TYPE',  width: 100 }
					,{ dataIndex: 'ZIP_CODE',  width: 70
					  ,'editor': Unilite.popup('ZIP_G',{showValue:false, textFieldName:'ZIP_CODE' ,DBtextFieldName:'ZIP_CODE',
					  											uniOpt:{recordFields:['ADDR'],
					  											grid: 'bor120ukrvGrid'},
									  							autoPopup: true,
									  							listeners: { 'onSelected': {
																                    fn: function(records, type  ){
																                    	var grdRecord = masterGrid.uniOpt.currentRecord;
							                    										grdRecord.set('ADDR', records[0]['ZIP_NAME']);
							                    										grdRecord.set('ZIP_CODE', records[0]['ZIP_CODE']);
																                    	console.log("(records[0] : ", records[0]);
																                    	//Ext.getCmp('ADDR2_F').setValue(records[0]['ADDR2']);
																                    },
																                    scope: this
																                  },
																                  'onClear' : function(type)	{
																                    	var grdRecord = masterGrid.uniOpt.currentRecord;
							                    										grdRecord.set('ADDR', '');
							                    										grdRecord.set('ZIP_CODE', '');
																                  }
			        															}
			        											})
					 }
					,{ dataIndex: 'ADDR',  width: 200 }
					,{ dataIndex: 'TELEPHON',  width: 100 }
					,{ dataIndex: 'FAX_NUM',  width: 100 }
					,{ dataIndex: 'SAFFER_TAX',  width: 100 , editable:false}
					,{ dataIndex: 'SAFFER_TAX_NM',  width: 100
						,'editor' : Unilite.popup('SAFFER_TAX_G',	{ textFieldName:'SAFFER_TAX_NM',
			  														autoPopup: true,
																	listeners: { 'onSelected': {
																                    fn: function(records, type  ){
																                    	var grdRecord = masterGrid.uniOpt.currentRecord;
							                    										grdRecord.set('SAFFER_TAX', records[0]['SUB_CODE']);
																						grdRecord.set('SAFFER_TAX_NM', records[0]['CODE_NAME']);
																                    },
																                    scope: this
																                  },
																                  'onClear' : function(type)	{
																                    	var grdRecord = masterGrid.uniOpt.currentRecord;
							                    										grdRecord.set('SAFFER_TAX', '');
							                    										grdRecord.set('SAFFER_TAX_NM', '');
																                  }
			        															}
						})
					}
					,{ dataIndex: 'BILL_DIV_CODE',  width: 120 }
					,{ dataIndex: 'BILL_DIV_NAME',  width: 100 }

					//20161024 추가 / 순서 변경
					,{ dataIndex: 'HANDPHONE',  width: 120		}
					,{ dataIndex: 'EMAIL',  width: 140		}
					,{ dataIndex: 'SUB_DIV_NUM',  width: 140 }
					//20210610 추가
					,{ dataIndex: 'SERVANT_COMPANY_NUM_YETA',  width: 200 }
					,{ dataIndex: 'HOMETAX_ID',  width: 100 }
					,{ dataIndex: 'BANK_CODE'			, width: 80,	hidden : true,
						editor: Unilite.popup('BANK_G',{
							textFieldName: 'BANK_CODE',
							DBtextFieldName: 'BANK_CODE',
			  				autoPopup: true,
							listeners:{
								'onSelected': {
			                    	fn: function(records, type  ){
			                    		var grdRecord = masterGrid.uniOpt.currentRecord;
										grdRecord.set('BANK_CODE',records[0]['BANK_CODE']);
										grdRecord.set('BANK_NAME',records[0]['BANK_NAME']);
			                    	},
		                    		scope: this
		          	   			},
								'onClear' : function(type)	{
			                  		var grdRecord = masterGrid.uniOpt.currentRecord;
									grdRecord.set('BANK_CODE','');
									grdRecord.set('BANK_NAME','');
			                  	}
							}
						})
					}
					,{ dataIndex: 'BANK_NAME'   		, width: 150,	hidden : true,
						editor: Unilite.popup('BANK_G',{
			  				autoPopup: true,
							listeners:{
								'onSelected': {
			                    	fn: function(records, type  ){
			                    		var grdRecord = masterGrid.uniOpt.currentRecord;
										grdRecord.set('BANK_CODE',records[0]['BANK_CODE']);
										grdRecord.set('BANK_NAME',records[0]['BANK_NAME']);
			                    	},
		                    		scope: this
		          	   			},
								'onClear' : function(type)	{
			                  		var grdRecord = masterGrid.uniOpt.currentRecord;
									grdRecord.set('BANK_CODE','');
									grdRecord.set('BANK_NAME','');
			                  	}
							}
						})
					}
		        	,{ dataIndex: 'BANK_BOOK_NUM'     	, width: 100,	hidden : true,
		        		editor:Unilite.popup('BANK_BOOK_G', {
							autoPopup: true,
							textFieldName:'BANK_BOOK_NAME',
							listeners:{
								scope:this,
								onSelected:function(records, type )	{
									var grdRecord = masterGrid.uniOpt.currentRecord;
									grdRecord.set('BANK_CODE', records[0].BANK_CD);
									grdRecord.set('BANK_NAME', records[0].BANK_NM);
									grdRecord.set('BANK_BOOK_NUM', records[0].DEPOSIT_NUM);

								},
								onClear:function(type)	{
									var grdRecord = masterGrid.uniOpt.currentRecord;
									grdRecord.set('BANK_BOOK_NUM', '');
								}
							}
						})
		        	}
					,{ dataIndex: 'TAX_NAME',  width: 140	 }
					,{ dataIndex: 'TAX_NUM',  width: 140	 }
					,{ dataIndex: 'TAX_TEL',  width: 120	 }
					,{ dataIndex: 'TAX_ADDR',  width: 200}
					,{ dataIndex: 'USE_YN',  width: 100}
					,{ dataIndex: 'YEAR_EVALUATION_YN',  width: 100} 
          ],

          listeners: {
          	selectionchangerecord:function(selected)	{
          		detailForm.loadForm(selected);
          	},
          	beforeedit  : function( editor, e, eOpts ) {
				if(e.field == "REPRE_NO_EXPOS")	{
					//e.grid.openCryptPopup( e.record );
					return false;
				}

			},
          	onGridDblClick:function(grid, record, cellIndex, colName) {
          		if(!record.phantom) {
	      			switch(colName)	{
					case 'DIV_CODE' :
							masterGrid.hide();
							break;
					default:
							break;
	      			}
          		}

          		if(colName =="REPRE_NO_EXPOS") {
					grid.ownerGrid.openCryptRepreNoPopup(record);
				}
          	},
          	hide:function()	{
				detailForm.show();
			}

         }
        ,openCryptRepreNoPopup:function( record )	{
		  	if(record)	{
				var params = {'REPRE_NO': record.get('REPRE_NO'), 'GUBUN_FLAG': '3', 'INPUT_YN': 'Y'}
				Unilite.popupCipherComm('grid', record, 'REPRE_NO_EXPOS', 'REPRE_NO', params);
			}

		}
    });

    /**
     * 상세 조회(Detail Form Panel)
     * @type
     */
    var detailForm = Unilite.createForm('bor120ukrvDetailForm', {
    	hidden: true,
    	autoScroll: true,
    	flex:1,
    	masterGrid: masterGrid,
        padding: '0 0 0 1',
	    layout: {type: 'uniTable', columns: 2, tableAttrs:{cellpadding:5}, tdAttrs: {valign:'top'}},
	    defaultType: 'uniFieldset',
	    defaults : { margin: '0 0 0 0'},
	    items : [{
        			  title: '<t:message code="system.label.base.basisinfo2" default="기본정보"/>'
        			, defaultType: 'uniTextfield'
        			, flex : 1
        			, rowspan : 2 
        			, layout: {
					            type: 'uniTable',
					            tableAttrs: { style: { width: '100%' } },
					            columns: 2
					}
					, defaults:{labelWidth:105}
				    , items : [	 {name: 'COMP_CODE'    		,fieldLabel: '<t:message code="system.label.base.companycode2" default="회사코드"/>', value:UserInfo.compCode, allowBlank:false , hidden:true}
				    			,{name: 'DIV_CODE'    		,fieldLabel: '<t:message code="system.label.base.divisioncode" default="사업장코드"/>',  allowBlank:false }
								,{name: 'DIV_FULL_NAME'    	,fieldLabel: '<t:message code="system.label.base.divfullname" default="사업장전명"/>'	 }
								,{name: 'DIV_NAME'    		,fieldLabel: '<t:message code="system.label.base.divisionname" default="사업장명"/>'	, allowBlank:false  }
								,{name: 'COMPANY_NUM'    	,fieldLabel: '<t:message code="system.label.base.compnum" default="사업자등록번호"/>'	 ,colspan:2, maxLength:21/*,
									 listeners : {

										blur: function(field, The, eOpts)	{
											var newValue = field.getValue().replace(/-/g,'');
											if(!Ext.isNumeric(newValue) && !Ext.isEmpty(newValue))	{
										 		Unilite.messageBox(Msg.sMB074);
										 		field.setValue(field.originalValue);
										 		return false;
										 	}

										 	var CompanyNumChRength = newValue.length;
										 	if(CompanyNumChRength != 10 && !Ext.isEmpty(newValue)){
										 		Unilite.messageBox('자릿수를 확인하십시오.');
										 		var t = field.originalValue;
										 		field.setValue(field.originalValue);
										 		return false;
										 	}
						  					if(Unilite.validate('bizno',newValue) != true && !Ext.isEmpty(newValue))	{
										 		if(!confirm(Msg.sMB173+"\n"+Msg.sMB175))	{
										 			field.setValue(field.originalValue);
										 			return false;
										 		}
										 	}
										 	if(Ext.isNumeric(newValue)) {
												var companyNum = newValue;
												var resultCompanyNum = (companyNum.substring(0,3)+ "-"+ companyNum.substring(3,5)+"-" + companyNum.substring(5,10));
												field.setValue(resultCompanyNum);
										 	}
										}
									 }*/
								}
								,{name: 'REPRE_NAME'    	,fieldLabel: '<t:message code="system.label.base.representativename" default="대표자명"/>'	 }
								,{
									fieldLabel:'<t:message code="system.label.base.residentno" default="주민등록번호"/>',
									name :'REPRE_NO_EXPOS',
									xtype: 'uniTextfield',
									readOnly:true,
									focusable:false,
									listeners:{
										afterrender:function(field)	{
											field.getEl().on('dblclick', field.onDblclick);
										}
									},
									onDblclick:function(event, elm)	{
										detailForm.openCryptRepreNoPopup();
									}
								}
								,{name: 'REPRE_NO'    		,fieldLabel: '<t:message code="system.label.base.residentno" default="주민등록번호"/>'	 ,colspan:2, hidden: true
    								/*,
									listeners : {
										blur: function(field, The, eOpts)	{
											var newValue = field.getValue().replace(/-/g,'');
											if(!Ext.isNumeric(newValue) && !Ext.isEmpty(newValue))	{
										 		Unilite.messageBox(Msg.sMB074);
										 		this.setValue('');
										 		return ;
										 	}
						  					if(Unilite.validate('residentno',newValue) != true && !Ext.isEmpty(newValue))	{
										 		if(!confirm(Msg.sMB174+"\n"+Msg.sMB176))	{
										 			field.setValue(field.originalValue);
										 			return;
										 		}
										 	}
										 	if(Ext.isNumeric(newValue)) {
												var repreNo = newValue;
												var resultRepreNo = (repreNo.substring(0,6)+ "-"+ repreNo.substring(6,13));
												field.setValue(resultRepreNo);
										 	}
										}
									}*/
								}
								,{name: 'COMP_CLASS'    	,fieldLabel: '<t:message code="system.label.base.businesstype" default="업종"/>'	}
								,{name: 'COMP_TYPE'    		,fieldLabel: '<t:message code="system.label.base.businessconditions" default="업태"/>'	}
								, Unilite.popup('ZIP',{showValue:false, textFieldName:'ZIP_CODE' , textFieldWidth: 150, DBtextFieldName:'ZIP_CODE',colspan:2,
			        						listeners: { 'onSelected': {
													fn: function(records, type  ) {
													   	detailForm.setValue('ADDR', records[0]['ZIP_NAME']);
													    console.log("(records[0] : ", records[0]);
													},
													scope: this
									            },
												'onClear' : function(type)	{
													detailForm.setValue('ADDR', '');
												}
			        						}
			        			})
								,{name: 'ADDR'    			,fieldLabel: '<t:message code="system.label.base.address" default="주소"/>'	 , width:520, colspan:2}
								,{name: 'TELEPHON'    		,fieldLabel: '<t:message code="system.label.base.phoneno" default="전화번호"/>'	 }
								,{name: 'FAX_NUM'    		,fieldLabel: '<t:message code="system.label.base.faxno" default="팩스번호"/>'	 }
								, Unilite.popup('SAFFER_TAX',{ valueFieldName:'SAFFER_TAX', textFieldName:'SAFFER_TAX_NM',  colspan:2})
								,{name: 'BILL_DIV_CODE'    	,fieldLabel: '<t:message code="system.label.base.declaredivisioncode" default="신고사업장"/>'	 ,xtype: 'uniCombobox', comboType:'BOR120',value:UserInfo.compCode , allowBlank:false}
								,{name: 'HANDPHONE'    		,fieldLabel: '<t:message code="system.label.base.handphone" default="사업장 휴대전화"/>'	 }
								,{name: 'EMAIL'    			,fieldLabel: '<t:message code="system.label.base.businessemail" default="사업자 E-MAIL"/>'	 }
				    			,{name: 'SUB_DIV_NUM'    	,fieldLabel: '<t:message code="system.label.base.servantbusinessnum" default="종사업자번호"/>'	 }
				    			//20210610 추가
				    			,{name: 'SERVANT_COMPANY_NUM_YETA'	,fieldLabel: '<t:message code="system.label.base.servantcompanynumyeta" default="종사업자번호(연말정산용)"/>'	 }
				    			,{
								    xtype: 'radiogroup',
								    fieldLabel: '<t:message code="system.label.base.photoflag" default="사진유무"/>',
								    allowBlank: false,
								    items : [{
								    	boxLabel: '<t:message code="system.label.base.yes" default="예"/>',
								    	name: 'USE_YN' ,
								    	inputValue: 'Y',
								    	width:50/*,
								    	checked: true*/
								    }, {boxLabel: '<t:message code="system.label.base.no" default="아니오"/>',
								    	name: 'USE_YN',
								    	inputValue: 'N',
								    	width:85
								    }]
								}
	    					]
	    			},

	    			{ title: '<t:message code="system.label.base.taxinfor" default="세무대리인 정보"/>'
        			, defaultType: 'uniTextfield'
        			, tdAttrs:{height :'80'}
        			, layout: {
					            type: 'uniTable',
					            tableAttrs: { 
					            	style: { width: '100%' } 
					            },
					           	columns: 2
					}
					, defaults:{labelWidth:100}
					,items:[
				    			 {name: 'TAX_NAME'    			,fieldLabel: '<t:message code="system.label.base.name" default="성명"/>'	 }
								,{name: 'TAX_NUM'    	,fieldLabel: '<t:message code="system.label.base.businessnumber" default="사업자번호"/>'	 ,colspan:2, maxLength:21/*,
									  listeners : { blur: function( field, The, eOpts )	{
									  					var newValue = field.getValue().replace(/-/g,'');
									  					if(Ext.isNumeric(newValue) != true)	{
													 		Unilite.messageBox(Msg.sMB074);
													 		field.setValue(field.originalValue);
													 		return;
													 	}
									  					if(Unilite.validate('bizno', newValue) != true)	{
													 		if(!confirm(Msg.sMB173+"\n"+Msg.sMB175))	{
													 			field.setValue(field.originalValue);
													 			return;
													 		}
													 	}
													 	if(Ext.isNumeric(newValue) == true) {
															var a = newValue;
															var i = (a.substring(0,3)+ "-"+ a.substring(3,5)+"-" + a.substring(5,10));
															field.setValue(i);
													 	}
									  			}
									  } */
								}
								,{name: 'TAX_TEL'    			,fieldLabel: '<t:message code="system.label.base.phoneno" default="전화번호"/>'	 }
								,{name: 'TAX_ADDR'    			,fieldLabel: '<t:message code="system.label.base.address" default="주소"/>'	 }
				    		]
	    		},{ title: '<t:message code="system.label.base.stockevaluationinfo" default="재고평가 정보"/>'
	    				, tdAttrs:{valign:'top'}
            			, layout: {
    					            type: 'uniTable',
    					            tableAttrs: { style: { width: '100%' } },
    					            columns: 1
    					}
    					, defaults:{labelWidth:100}
    					,items:[
    				    			 {
   									    xtype: 'radiogroup',
   									    fieldLabel: '<t:message code="system.label.base.yearevaluationyn" default="원가계산시 년누적계산여부"/>'	,
   									    labelWidth:160,
   									    items : [{
   									    	boxLabel: '<t:message code="system.label.base.yes" default="예"/>',
   									    	name: 'YEAR_EVALUATION_YN' ,
   									    	inputValue: 'Y',
   									    	width:50
   									    }, {boxLabel: '<t:message code="system.label.base.no" default="아니오"/>',
   									    	name: 'YEAR_EVALUATION_YN',
   									    	inputValue: 'N',
   									    	width:85,
   									    	checked: true
   									    }]
    								}
    				    		]
    	    		}]
	    		,loadForm: function(record)	{
   				// window 오픈시 form에 Data load
				this.reset();
				this.setActiveRecord(record || null);
				this.resetDirtyStatus();

				/*var win = this.up('uniDetailFormWindow');
                if(win) {       // 처음 윈도열때는 윈독 존재 하지 않음.
   				     win.setToolbarButtons(['saveBtn','saveCloseBtn'],false);
                     win.setToolbarButtons(['prev','next'],true);
                }*/
   			},
   			listeners:{
				beforeshow:function()	{
					var selected = masterGrid.getSelectedRecord();
					if(selected)	{
						detailForm.loadForm(selected);
					}else {
						detailForm.clearForm();
					}
				},
				hide:function()	{
					masterGrid.show();
					if(panelSearch.getCollapsed()){		//panelSearch가 닫혀 있으면..
						panelResult.show();
					}
				}
   			},

   			openCryptRepreNoPopup:function(  )	{
			var record = this;

			var params = {'REPRE_NO':this.getValue('REPRE_NO'), 'GUBUN_FLAG': '3', 'INPUT_YN': 'Y'};
			Unilite.popupCipherComm('form', record, 'REPRE_NO_EXPOS', 'REPRE_NO', params);

			}
	}); // detailForm

	/*function openDetailWindow(selRecord, isNew) {

			UniAppManager.app.confirmSaveData();

			// 추가 Record 인지 확인
			if(isNew)	{
				var r = masterGrid.createRow();
				selRecord = r[0];
			}
			// form에 data load
			detailForm.resetDirtyStatus();
			detailForm.loadForm(selRecord);

			if(!Ext.isEmpty(selRecord.get('IMAGE_FID')))	{
				//itemImageForm.hide();
				itemImageForm.setImage(selRecord.get('IMAGE_FID'));
			}
			if(!detailWin) {
				detailWin = Ext.create('widget.uniDetailFormWindow', {
	                title: '상세정보',
	                width: 880,
	                height: 500,
	                isNew: false,
	                x:0,
	                y:0,
	                items: [detailForm],

	                 onCloseButtonDown: function() {
                        this.hide();
                    },
                    onDeleteDataButtonDown: function() {
                        var record = masterGrid.getSelectedRecord();
                        var phantom = record.phantom;
                        UniAppManager.app.onDeleteDataButtonDown();
                        var config = {success :
                                    function()  {
                                        detailWin.hide();
                                    }
                            }
                        if(!phantom)    {

                                UniAppManager.app.onSaveDataButtonDown(config);

                        } else {
                            detailWin.hide();
                        }
                    },
                    onSaveAndCloseButtonDown: function() {
                        if(!detailForm.isDirty())   {
                            detailWin.hide();
                        }else {
                            var config = {success :
                                        function()  {
                                            detailWin.hide();
                                        }
                                }
                            UniAppManager.app.onSaveDataButtonDown(config);
                        }
                    },
			        onPrevDataButtonDown:  function()   {
			            if(masterGrid.selectPriorRow()) {
	                        var record = masterGrid.getSelectedRecord();
	                        if(record) {
                                detailForm.loadForm(record);
	                        }
                        }
			        },
			        onNextDataButtonDown:  function()   {
			            if(masterGrid.selectNextRow()) {
                            var record = masterGrid.getSelectedRecord();
                            if(record) {
                                detailForm.loadForm(record);
                            }
                        }
			        }
				})
    		}
			detailWin.show();
    }*/
    Unilite.Main({
      	id  : 'bop120ukrvApp',
		borderItems : [
			panelSearch,
			panelResult,
			{	region:'center',
				//layout : 'border',
				title:'<t:message code="system.label.base.companyinformation" default="사업장정보"/>',
				layout : {type:'vbox', align:'stretch'},
				flex:1,
				tools: [
					{
						type: 'hum-grid',
			            handler: function () {
			            	detailForm.hide();
			                //masterGrid.show();
			            	//panelResult.show();
			            }
					},{
						type: 'hum-photo',
			            handler: function () {
			            	/*
			            	var edit = masterGrid.findPlugin('cellediting');
							if(edit && edit.editing)	{
								setTimeout("edit.completeEdit()", 1000);
							}
							*/
			                masterGrid.hide();
			                panelResult.hide();
			                //detailForm.show();
			            }
					}
				],
				items:[
					masterGrid,
					detailForm
				]
			}
		],
		fnInitBinding : function(params) {
			UniAppManager.setToolbarButtons(['newData'],true);
			UniAppManager.setToolbarButtons(['reset'],false);
			if(params && params.DIV_CODE ) {
				if(params.isNew) {	//품목 신규 등록(수주등록->엑셀참조에서 호출)
					masterGrid.createRow({DIV_CODE: params.DIV_CODE});

					params.callBackFn.call(params.callBackScope, params);

		   			UniAppManager.setToolbarButtons(['save'],true);
				} else {
					panelSearch.setValue('DIV_CODE',params.DIV_CODE);
					masterGrid.getStore().loadStoreRecords();
				}
			}
		},
		onQueryButtonDown : function()	{
			masterGrid.getStore().loadStoreRecords();
		},
		onNewDataButtonDown : function()	{
			var r = {
				"USE_YN" : 'Y'
			}
			masterGrid.createRow(r);
			//openDetailWindow(null, true);
		},
		onPrevDataButtonDown:  function()	{
			masterGrid.selectPriorRow();
		},
		onNextDataButtonDown:  function()	{
			masterGrid.selectNextRow();
		},
		onSaveAsExcelButtonDown: function() {
			masterGrid.downloadExcelXml();
		},

		onSaveDataButtonDown: function (config) {
			directMasterStore.saveStore(config);
		},

		onDeleteDataButtonDown : function()	{
			var selRow = masterGrid.getSelectedRecord();
			if(selRow.phantom === true)	{
				masterGrid.deleteSelectedRow();

			} else if(confirm(Msg.sMB045 + "\n" + Msg.sMB062)) {					//삭제여부 확인 ("현재행을 삭제합니다. 삭제하시겠습니까?")
				masterGrid.deleteSelectedRow();
			}
		},
		onResetButtonDown:function() {
			panelSearch.reset();
			detailForm.clearForm();
			masterGrid.reset();
			directMasterStore.removeAll();
			UniAppManager.setToolbarButtons(['save','prev', 'next'],false);
		},
		onDetailButtonDown:function() {
			var as = Ext.getCmp('AdvanceSerch');
			if(as.isHidden())	{
				as.show();
			}else {
				as.hide()
			}
		},
		rejectSave: function()	{
			directMasterStore.rejectChanges();
			UniAppManager.setToolbarButtons('save',false);
		}
		, confirmSaveData: function()	{
            	if(directMasterStore.isDirty())	{
					if(confirm(Msg.sMB061))	{
						this.onSaveDataButtonDown();
					} else {
						this.rejectSave();
					}
				}
            }
	});	// Main

	Unilite.createValidator('validator01', {
				store : directMasterStore,
				grid: masterGrid,
				forms: {'formA:':detailForm},
				validate: function( type, fieldName, newValue, oldValue, record, ePanel, editor, e) {
					console.log('validate >>> ', {'type':type, 'fieldName':fieldName, 'newValue':newValue, 'oldValue':oldValue, 'record':record});
					var rv = true;

					if(fieldName == "COMPANY_NUM" ) { 		// '사업자번호'
						if(newValue) newValue = newValue.replace(/-/g,'');
					 	if(Ext.isNumeric(newValue) != true)	{
					 		rv = Msg.sMB074;
					 	}else if(Unilite.validate('bizno', newValue) != true)	{
					 		if(!Ext.isEmpty(newValue) && newValue.length != 10 ){
						 		rv = '<t:message code="system.message.base.message026" default="자릿수를 확인하십시오."/>';
						 	}else if(!confirm(Msg.sMB173+"\n"+Msg.sMB175))	{
					 			rv = false;
					 		}
					 	}
						if(Ext.isNumeric(newValue) == true) {
								var a = newValue;
								var i = (a.substring(0,3)+ "-"+ a.substring(3,5)+"-" + a.substring(5,10));
								if(type == 'grid') {
									e.cancel=true;
									record.set(fieldName, i);
								}else {
									editor.setValue(i);
								}

						}
					} else if(fieldName == "TAX_NUM") { 		// '세무대리인 사업자번호'
						if(newValue) newValue = newValue.replace(/-/g,'');
					 	if(Ext.isNumeric(newValue) != true)	{
					 		rv = Msg.sMB074;
					 	}else if(Unilite.validate('bizno', newValue) != true)	{
					 		if(!Ext.isEmpty(newValue) && newValue.length != 10 ){
						 		rv = '<t:message code="system.message.base.message026" default="자릿수를 확인하십시오."/>';
						 	}else if(!confirm(Msg.sMB173+"\n"+Msg.sMB175))	{
					 			rv = false;
					 		}
					 	}
					 	if(Ext.isNumeric(newValue) == true) {
							var a = newValue;
							var i = (a.substring(0,3)+ "-"+ a.substring(3,5)+"-" + a.substring(5,10));
							if(type == 'grid') {
								e.cancel=true;
								record.set(fieldName, i);
							}else {
								editor.setValue(i);
							}

					 	}

					} /* else if(fieldName == "REPRE_NO") {  		// '주민등록번호 : 팝업에서 체크함'
						newValue = newValue.replace(/-/g,'');
						if(Ext.isNumeric(newValue) != true)	{
					 		rv = Msg.sMB074;
					 	}else if(Unilite.validate('residentno', newValue) != true)	{
					 		if(!confirm(Msg.sMB174+"\n"+Msg.sMB176))	{
					 			rv = false;
					 		}
					 	}
					 	if(Ext.isNumeric(newValue) == true) {
							var a = newValue;
							var i = a.substring(0,6)+ "-"+ a.substring(6,13);
							if(type == 'grid') {
								e.cancel=true;
								record.set(fieldName, i);
							}else {
								editor.setValue(i);
							}

					 	}


					} */
					return rv;
				}
			}); // validator

}; // main
</script>


