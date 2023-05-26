<%@page language="java" contentType="text/html; charset=utf-8"%>
<t:appConfig pgmId="cmb100ukrv"  >
	<t:ExtComboStore comboType="AU" comboCode="CB25" />	<!-- 고객구분 -->
	<t:ExtComboStore comboType="AU" comboCode="CB45" />  <!-- 인지동기 -->
	<t:ExtComboStore comboType="AU" comboCode="B010" />  <!-- 결혼여부 -->
	<t:ExtComboStore comboType="AU" comboCode="CB48" />  <!-- 영업담당자 -->
</t:appConfig>

<script type="text/javascript" >
var	checkWin;
var detailWin;
function appMain() {
	/**
	 *   Model 정의 
	 * @type 
	 */

	Unilite.defineModel('Cmb100ukrvModel', {
	    fields: [{name: 'COMP_CODE' 		,text:'법인코드' 		,type:'string'	,maxLength: 8	,isPk:true, defaultValue:UserInfo.compCode, editable:false},
				 {name: 'CLIENT_ID' 		,text:'고객 ID' 		,type:'string'	,maxLength: 10	,isPk:true, editable:false},
				 {name: 'CLIENT_NAME' 		,text:'고객명' 		,type:'string'	,maxLength: 20	,allowBlank: false},
				 {name: 'CLIENT_TYPE' 		,text:'고객구분' 		,type:'string'	,maxLength: 20	,comboType:'AU',comboCode:'CB25' },
				 {name: 'CUSTOM_CODE' 		,text:'거래처코드' 	,type:'string'	,maxLength: 20	,allowBlank:false},
				 {name: 'CUSTOM_NAME' 		,text:'거래처명' 		,type:'string'	,allowBlank:false  },
				 {name: 'DVRY_CUST_SEQ' 	,text:'배송처코드' 	,type:'string'	,maxLength: 0	,editable:false},
				 {name: 'DVRY_CUST_NM' 		,text:'배송처명' 		,type:'string'	,maxLength: 10	},
				 {name: 'PROCESS_type' 		,text:'공정코드' 		,type:'string'	,maxLength: 0	, editable:false },
				 {name: 'PROCESS_type_NM' 	,text:'공정코드명' 	,type:'string'	,maxLength: 10	},
				 {name: 'EMP_ID' 			,text:'담당자' 		,type:'string'	,comboType:'AU',comboCode:'CB48', allowBlank:false},
				 {name: 'DEPT_NAME' 		,text:'부서명' 		,type:'string'	,maxLength: 20	},
				 {name: 'RANK_NAME' 		,text:'직급' 			,type:'string'	,maxLength: 20	},
				 {name: 'DUTY_NAME' 		,text:'직책' 			,type:'string'	,maxLength: 20	},
				 {name: 'HOBBY_STR' 		,text:'취미' 			,type:'string'	,maxLength: 40	},
				 {name: 'CO_TEL_NO' 		,text:'직장전화' 		,type:'string'	,maxLength: 20	},
				 {name: 'MOBILE_NO' 		,text:'핸드폰' 		,type:'string'	,maxLength: 20	},
				 {name: 'EMAIL_ADDR' 		,text:'E-MAIL' 		,type:'string'	,maxLength: 100	},
				 {name: 'RES_ADDR' 			,text:'거주지' 		,type:'string'	,maxLength: 20	},
				 {name: 'JOIN_YEAR' 		,text:'입사년도' 		,type:'uniDate'	},
				 {name: 'ADVAN_DATE' 		,text:'진급예정일' 	,type:'uniDate'	},
				 {name: 'BIRTH_DATE' 		,text:'생년월일' 		,type:'uniDate'	},
				 {name: 'WEDDING_DATE' 		,text:'결혼기념일' 	,type:'uniDate'	},
				 {name: 'WIFE_BIRTH_DATE' 	,text:'배우자생년월일' 	,type:'uniDate'	},
				 {name: 'CHILD_BIRTH_DATE' 	,text:'자녀생년월일' 	,type:'uniDate'	},
				 {name: 'MARRY_YN' 			,text:'결혼여부' 		,type:'string'	,comboType:'AU', comboCode:'B010',allowBlank: false, defaultValue:'N'},
				 {name: 'CHILD_CNT' 		,text:'자녀' 			,type:'int'		,allowBlank: false, defaultValue:0, minValue:0},
				 {name: 'GIRLFRIEND_YN' 	,text:'이성친구여부' 	,type:'string'	,comboType:'AU', comboCode:'B010',allowBlank: false, defaultValue:'N'},
				 {name: 'KNOW_MOTIVE' 		,text:'인지동기' 		,type:'string'	,comboType:'AU', comboCode:'CB45'},
				 {name: 'INTEREST_PART' 	,text:'관심분야' 		,type:'string'	,maxLength: 20	},
				 {name: 'GIRLFRIEND_RES' 	,text:'이성친구 거주지' ,type:'string'	,maxLength: 20	},
				 {name: 'FAMILY_STR' 		,text:'가족관계' 		,type:'string'	,maxLength: 40	},
				 {name: 'FAMILY_WITH_YN' 	,text:'가족동거여부' 	,type:'string'	,comboType:'AU',comboCode:'B010',allowBlank: false, defaultValue:'N'},
				 {name: 'HIGH_EDUCATION' 	,text:'학력' 			,type:'string'	,maxLength: 20	},
				 {name: 'BIRTH_PLACE' 		,text:'출생지' 		,type:'string'	,maxLength: 20	},
				 {name: 'NATURE_FEATURE' 	,text:'성격' 			,type:'string'	,maxLength: 100	},
				 {name: 'SCHOOL_FEAUTRE' 	,text:'출신학교/학번 ' 	,type:'string'	,maxLength: 100	} ,                 
				 {name: 'MILITARY_SVC' 		,text:'병역' 			,type:'string'	,maxLength: 100	},
				 {name: 'DRINK_CAPA' 		,text:'주량' 			,type:'string'	,maxLength: 100	},
				 {name: 'SMOKE_YN' 			,text:'흡연여부' 		,type:'string'	,comboType:'AU',comboCode:'B010' ,allowBlank: false, defaultValue:'N'},
				 {name: 'CO_FELLOW' 		,text:'친한 직장동료' 	,type:'string'	,maxLength: 100	},
				 {name: 'MOTOR_TYPE' 		,text:'차량' 			,type:'string'	,maxLength: 40	},
				 {name: 'HOUSE_TYPE' 		,text:'주택' 			,type:'string'	,maxLength: 40	},
				 {name: 'TWITTER_ID' 		,text:'Twitter' 	,type:'string'	,maxLength: 100	},
				 {name: 'FACEBOOK_ID' 		,text:'Facebook' 	,type:'string'	,maxLength: 100	},
				 {name: 'CREATE_EMP' 		,text:'작성자' 		,type:'string'	,allowBlank: false, defaultValue:UserInfo.userID, editable:false},
				 {name: 'CREATE_DATE' 		,text:'작성일' 		,type:'uniDate'	,editable:false},
				 {name: 'KEYWORD' 			,text:'키워드' 		,type:'string'	,maxLength: 100	},
				 {name: 'REMARK' 			,text:'특이사항' 		,type:'string'	,maxLength: 500	},
				 {name: 'INSERT_DB_USER' 	,text:'입력자' 		,type:'string'	,editable:false},
				 {name: 'INSERT_DB_TIME' 	,text:'입력일' 		,type:'uniDate'	,editable:false},
				 {name: 'UPDATE_DB_USER' 	,text:'수정자' 		,type:'string'	,editable:false},
				 {name: 'UPDATE_DB_TIME'	,text:'수정일' 		,type:'uniDate'	,editable:false},
				 {name: 'BUSINESSCARD_FID'	,text:'명함' 			,type:'string'	,editable:false},
				 {name: '_fileChange'		,text:'명함저장체크' 	,type:'string'	,editable:false}
					
			]
	});
	
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore = Unilite.createStore('cmb100ukrvMasterStore',{
			model: 'Cmb100ukrvModel',
			uniOpt : {
            	isMaster: true,			// 상위 버튼 연결 
            	editable: true,			// 수정 모드 사용 
            	deletable:true,			// 삭제 가능 여부 
	            useNavi : true			// prev | newxt 버튼 사용
            },
            autoLoad: false,
            proxy: {
                type: 'direct',
                api: {
                	   read: 'cmb100ukrvService.selectList'
                	,update: 'cmb100ukrvService.updateMulti'
					,create: 'cmb100ukrvService.insertMulti'
					,destroy:'cmb100ukrvService.deleteMulti'
					,syncAll:'cmb100ukrvService.syncAll'
                }
            }
            ,listeners: {
	            write: function(proxy, operation){
	                if (operation.action == 'destroy') {
	                	Ext.getCmp('cmb100ukrvDetailForm').reset();			         
	                }                
            	}
            }
			,loadStoreRecords : function()	{
				var param= Ext.getCmp('searchForm').getValues();			
				console.log( param );
				this.load({
					params : param
				});
				
			}
			,saveStore : function(config)	{				
				var inValidRecs = this.getInvalidRecords();
				console.log("inValidRecords : ", inValidRecs);
				if(inValidRecs.length == 0 )	{
					if( config == null)	{
						config = {success : function()	{
											detailForm.setActiveRecord(masterGrid.getSelectedRecord() || null); 
											//detailForm.resetDirtyStatus();
										}
								 };
					}
					this.syncAll(config);
					
				}else {
					alert(Msg.sMB083);
				}
			}
	});
	
	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */
    
	var panelSearch = Unilite.createSearchPanel('searchForm', {		
		title: '검색조건',
        defaultType: 'uniSearchSubPanel',
		items: [
            {	
				title: '기본정보', 	
	   			itemId: 'search_panel1',
	           	layout: {type: 'uniTable', columns: 1},
	           	defaultType: 'uniTextfield',
	           	defaults:{labelWidth:55},
			    items : [
                    {
				    	fieldLabel:'고객명',
				    	name:'CLIENT_NAME',
				    	xtype:'uniTextfield'				    	
				    },
					Unilite.popup('CUST',{
							fieldLabel: '거래처',
							textFieldWidth:170,
							validateBlank:false
					})
			    ]		
		}]
	});	//end panelSearch    	
    /**
     * Master Grid 정의(Grid Panel)
     * @type 
     */
    var masterGrid = Unilite.createGrid('cmb100ukrvGrid', {
        layout : 'fit',
        region : 'center',
        store : directMasterStore, 
        uniOpt:{	expandLastColumn: true,
        			useRowNumberer: true,
                    useMultipleSorting: true
        },
        tbar: [
            {
        	text:'상세보기',
        	handler: function() {
        		var record = masterGrid.getSelectedRecord();
	        	if(record) {
	        		openDetailWindow(record);
	        	}
        	}
        }],
        columns:  [     
               		 { dataIndex: 'COMP_CODE',  width: 70 , hidden: true}, // '법인코드', 
					{ dataIndex: 'CLIENT_ID', id:'CLIENT_ID_G', width: 70 , hidden: true}, // '고객 ID',
					{ dataIndex: 'CLIENT_NAME',  width: 70 },
					{ dataIndex: 'CLIENT_TYPE',  width: 120 }, // '고객구분'
					{ dataIndex: 'CUSTOM_CODE',  width: 70 , hidden: true}, // '고객업체',
					{ dataIndex: 'CUSTOM_NAME',  width: 170  , 
						'editor': Unilite.popup('CUST_G',{listeners: {
						                'onSelected': {
						                    fn: function(records, type  ){
						                    	var me = this;
						                    	var grdRecord =  Ext.getCmp('cmb100ukrvGrid').uniOpt.currentRecord;
						                    	grdRecord.set('CUSTOM_CODE',records[0]['CUSTOM_CODE']);
						                    },
						                    scope: this
						                }
						                , 'onClear':  function( type  ){
						                    	var me = this;
						                    	var grdRecord =  Ext.getCmp('cmb100ukrvGrid').uniOpt.currentRecord;
						                    	grdRecord.set('CUSTOM_CODE','');
						                    	grdRecord.set('CUSTOM_NAME','');
						                }
						            }
						          })
					}, // '고객업체',
					{ dataIndex: 'DVRY_CUST_SEQ'		,  width: 90 , hidden: true}, // '배송처',
					{ dataIndex: 'DVRY_CUST_NM'		,  width: 90 , hidden: true}, // '배송처',
					{ dataIndex: 'PROCESS_TYPE'		,  width: 90 , value:'', hidden: true}, // '공정코드',
					{ dataIndex: 'PROCESS_TYPE_NM'		,  value:'',  width: 90,    hidden: true}, // '공정코드',
					{ dataIndex: 'EMP_ID'				,  width: 100 }, // '담당자', 
					{ dataIndex: 'DEPT_NAME'			,  width: 90 }, // '부서명',
					{ dataIndex: 'RANK_NAME'			,  width: 85 },// '직급',
					{ dataIndex: 'DUTY_NAME'			,  width: 85 }, // '직책',
					{ dataIndex: 'HOBBY_STR'			,  width: 85 }, // '취미',
					{ dataIndex: 'CO_TEL_NO'			,  width: 90 }, // '직장 전화번호',
					{ dataIndex: 'MOBILE_NO'			,  width: 90 }, // '핸드폰 번호',
					{ dataIndex: 'EMAIL_ADDR'			,  width: 140 }, // 'E-MAIL 주소',
					{ dataIndex: 'RES_ADDR'			,  width: 110 }, // '거주지',
					{ dataIndex: 'JOIN_YEAR'			,  width: 85 }, // '입사년도',
					{ dataIndex: 'ADVAN_DATE'			,  width: 85 }, // '진급예정일',
					{ dataIndex: 'BIRTH_DATE'			,  width: 85 }, // '생일',
					{ dataIndex: 'WEDDING_DATE'		,  width: 85 }, // '결혼기념일',
					{ dataIndex: 'WIFE_BIRTH_DATE'		,  width: 140 }, // '배우자생일',
					{ dataIndex: 'CHILD_BIRTH_DATE'	,  width: 100 }, // '자녀생일',
					{ dataIndex: 'MARRY_YN'			,  width: 100  },  // '결혼여부',
					{ dataIndex: 'CHILD_CNT'			,  width: 70,	minValue: 0, maxValue: 20 }, // '자녀수',
					{ dataIndex: 'GIRLFRIEND_YN'		,  width: 85  }, // '이성친구여부',
					{ dataIndex: 'KNOW_MOTIVE'			,  width: 100 }, // '인지동기',
					{ dataIndex: 'INTEREST_PART'		,  width: 110 }, // '관심분야',
					{ dataIndex: 'GIRLFRIEND_RES'		,  width: 110 , hidden: true}, // '이성친구 거주지',
					{ dataIndex: 'FAMILY_STR'			,  width: 100 }, // '가족관계', 
					{ dataIndex: 'FAMILY_WITH_YN'		,  width: 85  }, // '가족동거여부',
					{ dataIndex: 'HIGH_EDUCATION'		,  width: 70 }, // '학력',
					{ dataIndex: 'BIRTH_PLACE'			,  width: 90}, // '출생지',
					{ dataIndex: 'NATURE_FEATURE'		,  width: 90 }, // '성격',
					{ dataIndex: 'SCHOOL_FEAUTRE'		,  width: 100 }, // '출신학교/학번',
					{ dataIndex: 'MILITARY_SVC'		,  width: 85 }, // '병역',
					{ dataIndex: 'DRINK_CAPA'			,  width: 90 }, // '주량',
					{ dataIndex: 'SMOKE_YN'			,  width: 100 }, // '흡연여부',
					{ dataIndex: 'CO_FELLOW'			,  width: 100 }, // '친한 직장동료'
					{ dataIndex: 'MOTOR_TYPE'			,  width: 85 }, // '차량',
					{ dataIndex: 'HOUSE_TYPE'			,  width: 85 }, // '주택',
					{ dataIndex: 'TWITTER_ID'			,  width: 110 },  // '트위터 ID',
					{ dataIndex: 'FACEBOOK_ID'			,  width: 110 },  // 'FACEBOOK ID',
					{ dataIndex: 'CREATE_EMP'			,  width: 70 , hidden: true}, // '작성자',
					{ dataIndex: 'CREATE_DATE'			,  width: 85 , hidden: true}, // '작성일',
					{ dataIndex: 'KEYWORD'				,  width: 130 }, // '키워드',
					{ dataIndex: 'REMARK'				,  width: 200}, // '비고',
					{ dataIndex: 'INSERT_DB_USER'		,  width: 70 , hidden: true}, // '입력자',
					{ dataIndex: 'INSERT_DB_TIME'		,  width: 70 , hidden: true}, // '입력일',
					{ dataIndex: 'UPDATE_DB_USER'		,  width: 70 , hidden: true}, // '수정자',
					{ dataIndex: 'UPDATE_DB_TIME'		,  width: 70 , hidden: true} // '수정일',
          ],
          listeners: {
                onGridDblClick: function(grid, record, cellIndex, colName) {
                    openDetailWindow(record);
                }
          }
    });
    
    /**
     * 상세 조회(Detail Form Panel)
     * @type 
     */
    var businessCardForm = Unilite.createForm('businessCardForm', {
	    	 			 fileUpload: true,
						 url:  CPATH+'/fileman/upload.do',
				    	 defaultType: 'uniFieldset',
				    	 disabled:false,
				    	 overflow:false,
				    	 autoScroll:false,
				    	 height: 200,
	    	 			 layout: {type: 'uniTable', columns: 2,tdAttrs: {valign:'top'}},
						 items: [ 
        						  { xtype: 'filefield',
									buttonOnly: false,
									fieldLabel: '명함 Image',
									flex:1,
									name: 'fileUpload',
									buttonText: '파일선택',
									width: 270,
									labelWidth: 70,
									listeners: {change : function( filefield, value, eOpts )	{
															var fileExtention = value.lastIndexOf(".");
															//FIXME : 업로드 확장자 체크, 이미지파일만 upload
															if(value !='' )	{
																var record = masterGrid.getSelectedRecord();
																record.set('_fileChange', 'true');
																detailWin.setToolbarButtons(['saveBtn','saveCloseBtn'],true);
			       											    
															}
														}
									}
								  }
								  ,{ xtype: 'button', text:'올리기', margin:'0 0 0 2',
								  	 handler:function()	{
								  	 	var config = {success : function()	{
								  	 						var selRecord = masterGrid.getSelectedRecord();
                        									detailForm.loadForm(selRecord);				// 입력값 이외의 자동생성 필드가 있다면 반드시 넣어준다.
		                    						 		detailWin.setToolbarButtons(['saveBtn','saveCloseBtn'],false);
		                    						 		detailWin.setToolbarButtons(['prev','next'],true);
					                    			  }
			                    			}
			                        	UniAppManager.app.onSaveDataButtonDown(config);
								  	 }								  
								  }
								  ,{ xtype: 'image', id:'cmb100ukrvBCImage', src:CPATH+'/resources/images/nameCard.jpg', width:320,	 overflow:false, colspan:2}
					             ]
					 
					   , setBusinessCard : function (fid)	{
						    	 	var image = Ext.getCmp('cmb100ukrvBCImage');
						    	 	var src = CPATH+'/resources/images/nameCard.jpg'
						    	 	if(fid!='')	{
							         	//src = CPATH+'/fileman/download.do?fid='+fid+'&inline=Y';
							         	src= CPATH+'/fileman/view/'+fid;
						    	 	}
							        image.setSrc(src);
						    	 }
					  
	});
	
    var detailForm = Unilite.createForm('cmb100ukrvDetailForm', {
	     layout: {type: 'uniTable', columns: 2,tdAttrs: {valign:'top'}},
	    defaultType: 'uniFieldset',
	    flex:1,
	    masterGrid: masterGrid,
	    items : [{ 
        			  title: '기본정보'
        			, colspan:2
        			, defaults:{type: 'uniTextfield', labelWidth:90}
        			, layout: {
					            type: 'uniTable',
					            columns: 3
					        }    			
        			, items :[	  {fieldLabel: '고객명',  		name: 'CLIENT_NAME' 	,maxLength:20	,allowBlank: false}
        						 ,{fieldLabel: '고객ID',  		name: 'CLIENT_ID' 		,maxLength:10	,hidden: true, readOnly:true}
        						 ,Unilite.popup('CUST',{fieldLabel: '거래처', colspan:2, textFieldWidth:140, valueFieldName:'CUSTOM_CODE',  textFieldName:'CUSTOM_NAME',  DBvalueFieldName: 'CUSTOM_CODE', DBtextFieldName: 'CUSTOM_NAME',allowBlank:false })        						 
        						 ,{fieldLabel: '배송처',  		name: 'DVRY_CUST_NM'	,hidden: true ,allowBlank: true , xtype: 'combobox', store: Ext.create('Ext.data.ArrayStore', { fields : ['name', 'value'],
																					                                    data   : [
																					                                        {name : '배송처',   value: '1'}
																					                                    		] })
        						   } //btnDvryCustSeq
        						 ,{fieldLabel: '고객구분',  	name: 'CLIENT_TYPE'		,xtype: 'uniCombobox', comboType:'AU',comboCode:'CB25'  } // btnClientType
        						 ,{fieldLabel: '부서',  		name: 'DEPT_NAME'		,maxLength:20	}
        						 ,{fieldLabel: '직급',  		name: 'RANK_NAME'		,maxLength:20	}
        						 ,{fieldLabel: '직책',  		name: 'DUTY_NAME'		,maxLength:20	}
        						 ,{fieldLabel: '직장전화',  	name: 'CO_TEL_NO'		,maxLength:20	}
        						 ,{fieldLabel: '핸드폰',  		name: 'MOBILE_NO'		,maxLength:20	}
        						 ,{fieldLabel: '입사년도',  	name: 'JOIN_YEAR'		,xtype:'uniDatefield'}
        						 ,{fieldLabel: '진급 예정일',  	name: 'ADVAN_DATE'		,xtype:'uniDatefield'}
        						 ,{fieldLabel: 'E_MAIL',  		name: 'EMAIL_ADDR'		,maxLength:100	}
        						 ,{fieldLabel: '담당자',  		name: 'EMP_ID'			,xtype : 'uniCombobox', allowBlank: false, comboType:'AU',comboCode:'CB48'}
        						 ,{fieldLabel: '작성일',  		name: 'CREATE_DATE'		,xtype:'uniDatefield', readOnly:true}
					         ]
	    		}
	    	   ,{   title: '가족사항'	    	   
	    	   		, colspan:2
        			, defaults:{type: 'uniTextfield', labelWidth:90}
        			, flex : 1
        			, layout: {
					            type: 'uniTable',
					            columns: 3
					        }
					 
        			, items :[	  {fieldLabel: '생년월일',  	name: 'BIRTH_DATE'		,xtype:'uniDatefield'}
        						 ,{fieldLabel: '결혼기념일',  	name: 'WEDDING_DATE'	,xtype:'uniDatefield'}
        						 ,{fieldLabel: '배우자생년월일',  name: 'WIFE_BIRTH_DATE'	,xtype:'uniDatefield'}
        						 ,{fieldLabel: '자녀생년월일',  name: 'CHILD_BIRTH_DATE',xtype:'uniDatefield'}
        						 ,{fieldLabel: '가족관계',  	name: 'FAMILY_STR'		,maxLength:40	}
        						 ,{fieldLabel: '결혼 여부',  	name:'MARRY_YN'			,xtype: 'uniRadiogroup', width: 230, comboType:'AU',comboCode:'B010', allowBlank:false }
        						 ,{fieldLabel: '가족동거 여부', 	name:'FAMILY_WITH_YN'	,xtype: 'uniRadiogroup', width: 230, comboType:'AU',comboCode:'B010', allowBlank:false   }
        						 ,{fieldLabel: '자녀',  		name: 'CHILD_CNT'		,xtype:'uniNumberfield',	suffixTpl:'&nbsp;명'
        						 	,listenersX : {blur : function (e, valid)	{
        						  							var frm = Ext.getCmp('cmb100ukrvDetailForm');
        						 							if(e.value < 0 ) {
																alert(Msg.sMB076);
																frm.setValue(e.name,e.originalValue);
															}
        						  						}
        						  				} 
        						  }
        						 ,{fieldLabel: '거주지', 		name: 'RES_ADDR'		,maxLength:20	}
        						 ,{fieldLabel: '이성친구 여부', name:'GIRLFRIEND_YN'		,xtype: 'uniRadiogroup', width: 230, comboType:'AU',comboCode:'B010', allowBlank:false }
        						 ,{fieldLabel: '관심분야',  	name: 'INTEREST_PART'	,maxLength:20}
        						 ,{fieldLabel: '인지동기',  	name: 'KNOW_MOTIVE'		,xtype : 'uniCombobox', comboType:'AU', comboCode:'CB45'}
        						
        					]
	    		},
	    		{  title: '신상정보'
	    			, colspan:2
	    			, flex : 1
        			, defaults:{type: 'uniTextfield', labelWidth:90}
        			, layout: {
					            type: 'uniTable',
					            columns: 3
					        }
        			, items :[	  {fieldLabel: '출생지',  		name: 'BIRTH_PLACE'		,maxLength:20	}
        						 ,{fieldLabel: '학력',  		name: 'HIGH_EDUCATION'	,maxLength:20	}
        						 ,{fieldLabel: '출신학교/학번', name: 'SCHOOL_FEAUTRE'	,maxLength:100	}
        						 ,{fieldLabel: '병역',  		name: 'MILITARY_SVC'	,maxLength:100	}
        						 ,{fieldLabel: '주량',  		name: 'DRINK_CAPA'		,maxLength:100	}
        						 ,{fieldLabel: '차량',  		name: 'MOTOR_TYPE'		,maxLength:40	}
        						 ,{fieldLabel: '주택',  		name: 'HOUSE_TYPE'		,maxLength:40	}
        						 ,{fieldLabel: '흡연 여부',  	name: 'SMOKE_YN'	,xtype: 'uniRadiogroup', width: 230, comboType:'AU',comboCode:'B010', allowBlank:false  }
        						 ,{fieldLabel: '성격',  		name: 'NATURE_FEATURE'	,maxLength:100	}
        						 ,{fieldLabel: '친한 직장동료', name: 'CO_FELLOW'		,maxLength:100	}
        						 ,{fieldLabel: '취미',  		name: 'HOBBY_STR'		,maxLength:40	}
        						 ,{fieldLabel: 'Facebook',  	name: 'FACEBOOK_ID'		,maxLength:100	}
        						 ,{fieldLabel: 'Twitter',  		name: 'TWITTER_ID'		,maxLength:100	}
        						 ,{fieldLabel: '명함',  		name: 'BUSINESSCARD_FID' 	, hidden:true}
        					]
	    		}
	    		,{   title: '추가사항'
	    			, defaultType: 'uniFieldset'
        			, layout: {
					            type: 'uniTable',
					            columns: 2,
					            tdAttrs: {valign:'top'}
					        }
		        	, items :[  businessCardForm
			        			,{ 
				        			 defaultType: 'textarea'
				        			, layout: {
									            type: 'uniTable',
									            columns: 1
									        }
									
									,border :0
				        			, items :[	 {fieldLabel: '특이사항',  	name: 'REMARK' , width:320	,labelWidth:50, maxLength:100, height:90	}
					    						  ,{fieldLabel: 'Keyword',  name: 'KEYWORD' , width:320	,labelWidth:50, maxLength:500, height:90	}]
					    			}
			    		
			    			]
	    		}]

				,loadForm: function(record)	{
       				// window 오픈시 form에 Data load
					this.reset();
					this.setActiveRecord(record || null);   
					this.resetDirtyStatus();
                    var win = this.up('uniDetailFormWindow');
                    if(win) {       // 처음 윈도열때는 윈독 존재 하지 않음.
       				     win.setToolbarButtons(['saveBtn','saveCloseBtn'],false);
                         win.setToolbarButtons(['prev','next'],true);
                    }
       				Ext.getCmp('businessCardForm').clearForm();
				    var fid = record.get('BUSINESSCARD_FID');
				    businessCardForm.setBusinessCard(fid);
       			}
       			, listeners : {
       				uniOnChange : function( form, field, newValue, oldValue )	{
       					var b = form.isValid();
                        this.up('uniDetailFormWindow').setToolbarButtons(['saveBtn','saveCloseBtn'],b);
                        this.up('uniDetailFormWindow').setToolbarButtons(['prev','next'],!b);   // 저장이 필요할경우 이전 다음 disable
       				}
       				
       			}
	});
	
	function openDetailWindow(selRecord, isNew) {
    		// 그리드 저장 여부 확인
    		var edit = masterGrid.findPlugin('cellediting');
			if(edit && edit.editing)	{
				setTimeout("edit.completeEdit()", 1000);
			}
			UniAppManager.app.confirmSaveData();
    		
			// 추가 Record 인지 확인			
			if(isNew)	{		
				var r = masterGrid.createRow();
				selRecord = r;
			}
			// form에 data load
			detailForm.loadForm(selRecord);
			
			
			if(!detailWin) {
				detailWin = Ext.create('widget.uniDetailFormWindow', {
	                title: '상세정보',
	                width: 800,				                
	                height: 500,
	                isNew: false,
	                x:0,
	                y:0,
	                items: [detailForm],
	                listeners : {
	                			 show:function( window, eOpts)	{
	                			 	detailForm.getField('CLIENT_NAME').focus();
	                			 }
	                },
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
                    onSaveDataButtonDown: function() {
                    	var config = {success : function()	{
                    							var selRecord = masterGrid.getSelectedRecord();
                        						detailForm.loadForm(selRecord);				// 입력값 이외의 자동생성 필드가 있다면 반드시 넣어준다.
                    						 	detailWin.setToolbarButtons(['saveBtn','saveCloseBtn'],false);
                    						 	detailWin.setToolbarButtons(['prev','next'],true);
                    					}
                    	}
                        UniAppManager.app.onSaveDataButtonDown(config);
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
				
    }

    Unilite.Main( {
		borderItems:[ 
		 		 masterGrid
				,panelSearch
		], 
		id  : 'cmb100ukrvApp',
		fnInitBinding : function() {
			this.setToolbarButtons(['newData','reset'],true);
		},
		onQueryButtonDown : function()	{
			var fileForm = businessCardForm.getForm();
			if(fileForm.isDirty())	{
				if(confirm(Msg.sMB061))	{
					UniAppManager.app.onSaveDataButtonDown();
				}
			}else {
				detailForm.clearForm();
				masterGrid.reset();
				businessCardForm.clearForm();
				
				masterGrid.getStore().loadStoreRecords();	
			}
			
		},
		onNewDataButtonDown : function()	{	
			 openDetailWindow(null, true);
		     //masterGrid.createRow();
		},		
		onSaveDataButtonDown: function (config) {
			
			var inValidRecs = masterGrid.getStore().getInvalidRecords();
			console.log("inValidRecords : ", inValidRecs);
			if(inValidRecs.length == 0 )	{				
				var fileForm = businessCardForm.getForm();
				if(fileForm.isDirty())	{
					fileForm.submit({
								waitMsg: 'Uploading...',
								success: function(form, action) {
									if( action.result.success === true)	{
										masterGrid.getSelectedRecord().set('BUSINESSCARD_FID',action.result.fid);									
										masterGrid.getStore().saveStore(config);
										businessCardForm.setBusinessCard(action.result.fid);
										businessCardForm.clearForm();
									}
								}
						});
				}else { 
					masterGrid.getStore().saveStore(config);
				}
			}else {
				masterGrid.uniSelectInvalidColumnAndAlert(inValidRecs);
			}
			
		},
		onDeleteDataButtonDown : function()	{
			if(confirm('현재행을 삭제 합니다.\n 삭제 하시겠습니까?')) {
				masterGrid.deleteSelectedRow();
			}
		},
		onPrevDataButtonDown:  function()	{
			masterGrid.selectPriorRow();
		},
		onNextDataButtonDown:  function()	{
			masterGrid.selectNextRow();
		},
		onResetButtonDown:function() {
		
			directMasterStore.removeAll()
			detailForm.clearForm();
			
			masterGrid.reset();
			businessCardForm.clearForm();
		},
		// 탭/선택데이타 이동 전 저장 함수
		saveStoreEvent: function(str, newCard)	{
			
			var edit = masterGrid.findPlugin('cellediting');
			edit.completeEdit();
			this.onSaveDataButtonDown();
		}, // end saveStoreEvent()
		
		// 탭/선택데이타 이동 전 저장 reject
		 rejectSave: function()	{
			directMasterStore.rejectChanges();
			var selected = masterGrid.getSelectedRecord();
			//detailForm.setActiveRecord(selected || null);
			UniAppManager.setToolbarButtons('save',false);
		} // end rejectSave()
		, confirmSaveData: function()	{
            	if(directMasterStore.isDirty())	{
					if(confirm(Msg.sMB061))	{
						this.onSaveDataButtonDown();
					} else {
						this.rejectSave();
					}
				}
				
            }
	});
	
	Unilite.createValidator('cmb100ukrvValidator', {
		store : directMasterStore,
		grid: masterGrid,
		forms: {'formA:':detailForm},
		validate: function( type, fieldName, newValue, oldValue, record, eopt) {

			var rv = true;
			if(fieldName=='CHILD_CNT')  {
				//case "CHILD_CNT" :		// 자녀수				
					if(newValue < 0 ) {
						rv = Msg.sMB076;
					}
				//	break;
			} else if(fieldName=='CLIENT_NAME')  {
				//case "CLIENT_NAME" :
					// 신규추가 데이타의 경우에만 동명이인 목록 보여줌.
					var isNewRecord = false;
					if(record.type == 'grid')	{
						isNewRecord = record.obj.phantom;
					}else if(record.type == 'form') {
						isNewRecord = record.obj.activeRecord.phantom;
					}
					if(isNewRecord) {
						chkWin(newValue); 
					}
					//break;
				}
			return rv;
		}
	}); // validator
	
	
	
	/**
	 * 동명이인 확인 - createValidator
	 */
	var checkedClientName= "";
	Unilite.defineModel('cmb100ukrvChkNmModel', {
	    fields: [ 	 {name: 'CLIENT_NAME' 		,text:'고객명' 			,type:'string'	}
					,{name: 'CUSTOM_NAME' 		,text:'거래처명' 		,type:'string'	,allowBlank:false  }
					,{name: 'DEPT_NAME' 		,text:'부서명' 			,type:'string'	,maxLength: 20	}
				]
	});
		
	var checkNameStore = Unilite.createStore('cmb100ukrvChkNmStore',{
			model: 'cmb100ukrvChkNmModel',
			uniOpt : {
            	isMaster: false,			// 상위 버튼 연결 
            	editable: false,			// 수정 모드 사용 
            	deletable:false,			// 삭제 가능 여부 
	            useNavi : false			// prev | newxt 버튼 사용
            },
            autoLoad: false,
            proxy: {
                type: 'direct',
                api: {
                	   read: 'cmb100ukrvService.getClientList'
                }
            }
	});
	
	var checkNameGrid = Unilite.createGrid('cmb100ukrvChkNmGrid', {
        flex:1,
    	store: checkNameStore,
    	uniOpt:{
    		expandLastColumn: false,
    		useRowNumberer:false
    	},
        columns:  [        
               		 { dataIndex: 'CLIENT_NAME',  width: 100 } 
					,{ dataIndex: 'CUSTOM_NAME', width: 185 } 
					,{ dataIndex: 'DEPT_NAME',  width: 100 }
				  ]
		});

		
	function makeCheckWin() {
    	checkWin = Ext.create('widget.window', {
				                title: '동명이인 목록',
				                header: {
				                    titlePosition: 2,
				                    titleAlign: 'left'
				                },
				                layout:'fit',
				                closable: true,
				                //closeAction: 'destroy',
				                closeAction: 'hide',
				                width: 400,				                
				                height: 200,	
				                modal : true,
				              
				                items: [ checkNameGrid]
				                ,tbar: [ {	xtype: 'tbtext', 
											text: '동명이인이 있습니다. 계속 진행하시겠습니까?',
											disabled: false
										 },
										 '->'
										 ,{	xtype: 'button',
											text: '예',											
											handler: function() {
												var selRecord = masterGrid.getSelectedRecord();
												checkedClientName = selRecord.get('CLIENT_NAME');
												checkWin.close();
											},
											disabled: false
										}, {
											xtype: 'button',
											text: '아니오',	
											handler: function() {
												var selRecord = masterGrid.getSelectedRecord();
												selRecord.set('CLIENT_NAME','');
												detailForm.setValue('CLIENT_NAME','');
												checkWin.close();
											},
											disabled: false
										} ]
							});	
	}

    function  chkWin(name)	{
    	console.log("checkNameGrid : ", checkNameGrid);
    	if(checkedClientName != name)	{
			if(!checkWin) {
				makeCheckWin();
			}
			checkNameStore.load({
				params : {CLIENT_NAME : name},
				callback : function(records, operation, success) {
					if(checkNameStore.getTotalCount() > 0 )	{
						var win = checkWin;
						win.show(Ext.getBody());
					}
				}
			});
    	}
							
							
   }

};


</script>
