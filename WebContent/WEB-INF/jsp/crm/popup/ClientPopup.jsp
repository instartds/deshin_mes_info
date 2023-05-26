<%@page language="java" contentType="text/html; charset=utf-8"%>
<%

/**
* 고객정보 팝업 
*/

%>
<t:appConfig pgmId="crm.pop.ClientPopup"  >
	<t:ExtComboStore comboType="AU" comboCode="B010" />
	<t:ExtComboStore comboType="AU" comboCode="CB48" /><!-- 영업담당자 -->
</t:appConfig>
<script type="text/javascript" >
function appMain() {

	/**
	 *   Model 정의 
	 * @type 
	 */
	Unilite.defineModel('ClientPopupModel', {
	    fields: [ 	 { name: 'CLIENT_ID'		,text: '고객 ID'		,type:'string'	} 
					,{ name: 'CLIENT_NAME'		,text: '고객명'			,type:'string'	} 
					,{ name: 'CUSTOM_CODE'		,text: '고객거래처코드'	,type:'string'	} 
					,{ name: 'CUSTOM_NAME'		,text: '고객거래처'		,type:'string'	} 
					,{ name: 'DVRY_CUST_SEQ'	,text: '배송처코드'		,type:'string'	} 
					,{ name: 'DVRY_CUST_NM'		,text: '배송처'			,type:'string'	} 
					,{ name: 'PROCESS_TYPE'		,text: '공정코드'		,type:'string'	} 
					,{ name: 'EMP_ID'			,text: '담당자'			,type:'string'	, comboType:'AU', comboCode:'CB48'} 
					,{ name: 'DEPT_NAME'		,text: '부서명'			,type:'string'	} 
					,{ name: 'RANK_NAME'		,text: '직급'			,type:'string'	} 
					,{ name: 'DUTY_NAME'		,text: '직책'			,type:'string'	} 
					,{ name: 'HOBBY_STR'		,text: '취미'			,type:'string'	} 
					,{ name: 'CO_TEL_NO'		,text: '직장 전화번호'	,type:'string'	} 
					,{ name: 'MOBILE_NO'		,text: '핸드폰 번호'	,type:'string'	} 
					,{ name: 'EMAIL_ADDR'		,text: 'E-MAIL 주소'	,type:'string'	} 
					,{ name: 'RES_ADDR'			,text: '거주지'			,type:'string'	} 
					,{ name: 'JOIN_YEAR'		,text: '입사년도'		,type:'date'	} 
					,{ name: 'ADVAN_DATE'		,text: '진급예정일'		,type:'date'	} 
					,{ name: 'BIRTH_DATE'		,text: '생일'			,type:'date'	} 
					,{ name: 'WEDDING_DATE'		,text: '결혼기념일'		,type:'date'	} 
					,{ name: 'WIFE_BIRTH_DATE'	,text: '부인생일'		,type:'date'	} 
					,{ name: 'CHILD_BIRTH_DATE'	,text: '자녀생일'		,type:'string'	} 
					,{ name: 'MARRY_YN'			,text: '결혼여부'		,type:'string'	, comboType:'AU', comboCode:'B010'} 
					,{ name: 'CHILD_CNT'		,text: '자녀수'			,type:'number'	} 
					,{ name: 'GIRLFRIEND_YN'	,text: '여자친구여부'	,type:'string'	, comboType:'AU',comboCode:'B010' } 
					,{ name: 'GIRLFRIEND_RES'	,text: '여자친구 거주지',type:'string'	} 
					,{ name: 'FAMILY_STR'		,text: '가족관계'		,type:'string'	} 
					,{ name: 'FAMILY_WITH_YN'	,text: '가족동거여부'	,type:'string'	, comboType:'AU', comboCode:'B010'} 
					,{ name: 'HIGH_EDUCATION'	,text: '학력'			,type:'string'	} 
					,{ name: 'BIRTH_PLACE'		,text: '출생지'			,type:'string'	} 
					,{ name: 'NATURE_FEATURE'	,text: '성격'			,type:'string'	} 
					,{ name: 'SCHOOL_FEAUTRE'	,text: '출신학교/학번'	,type:'string'	} 
					,{ name: 'MILITARY_SVC'		,text: '병역'			,type:'string'	} 
					,{ name: 'DRINK_CAPA'		,text: '주량'			,type:'string'	} 
					,{ name: 'SMOKE_YN'			,text: '흡연여부'		,type:'string'	, comboType:'AU', comboCode:'B010'} 
					,{ name: 'CO_FELLOW'		,text: '친한 직장동료'	,type:'string'	} 
					,{ name: 'MOTOR_TYPE'		,text: '차량'			,type:'string'	} 
					,{ name: 'HOUSE_TYPE'		,text: '주택'			,type:'string'	} 
					,{ name: 'TWITTER_ID'		,text: '트위터 ID'		,type:'string'	} 
					,{ name: 'FACEBOOK_ID'		,text: 'FACEBOOK ID'	,type:'string'	} 
					,{ name: 'CREATE_EMP'		,text: '작성자'			,type:'string'	} 
					,{ name: 'CREATE_DATE'		,text: '작성일'			,type:'string'	} 
					,{ name: 'KEYWORD'			,text: '키워드'			,type:'string'	} 
					,{ name: 'REMARK'			,text: '비고'			,type:'string'	} 		
					
			]
	});
	
  
	
	/**
	 * Store 정의(Service 정의)
	 * @type 
	 */					
	var directMasterStore = Unilite.createStore('clientPopupMasterStore',{
			model: 'ClientPopupModel',
            autoLoad: false,
            proxy: {
                type: 'direct',
                api: {
                	read: 'cmPopupService.clientPopup'
                }
            }
	});
	
	/**
	 * 검색조건 (Search Panel)
	 * @type 
	 */
	var wParam = window.dialogArguments;
	var t1= false, t2 = false;
	if( Ext.isDefined(wParam)) {
		if(wParam['TYPE'] == 'VALUE') {
			t1 = true;
			t2 = false;
			
		} else {
			t1 = false;
			t2 = true;
			
		}
	}
	var panelSearch = Unilite.createSearchForm('clientPopupSearchForm',{
        layout : {type : 'table', columns : 3},
        width:'100%',
        items: [ { fieldLabel: '거래처', 	name:'CUSTOM_TXT'	, id:'CUSTOM_TYPE'}
    			 //,{ fieldLabel: '배송처', 	name:'DVRY_CUST_TXT', id:'DVRY_CUST_TXT'}
    			 //,{ fieldLabel: '공정', 	name:'PROCESS_TEXT'	, id:'PROCESS_TEXT'}
    			 ,{ fieldLabel: '전화번호', name:'TEL_TXT'		, colspan:2, id:'TEL_TXT'}
    			 ,{ fieldLabel: '조회조건', name:'TXT_SEARCH'	, id:'TXT_SEARCH',  colspan:2}
    			 ,{ fieldLabel: ' ', hideLabel : false,
    			 	xtype: 'radiogroup', width: 230, id:'rdoRadio',
    			 	items:[	{inputValue: '1', boxLabel:'코드순', name: 'RDO', checked: t1},
    			 			{inputValue: '2', boxLabel:'이름순',  name: 'RDO', checked: t2} ]
    			 }			   
		        
		]
    });  
	
    /**
     * Master Grid 정의(Grid Panel)
     * @type 
     */
    var masterGrid = Unilite.createGrid('clientPopupGrid', {
    	store: directMasterStore,
    	uniOpt:{
    				 expandLastColumn: false
    				,useRowNumberer: false
    			},
        columns:  [        
               		 { dataIndex: 'CLIENT_ID'		,width: 90  	}
					,{ dataIndex: 'CLIENT_NAME'		,width: 140  	}
					,{ dataIndex: 'CUSTOM_CODE'		,width: 100  	}//,hidden:true}
					,{ dataIndex: 'CUSTOM_NAME'		,width: 170  	}//,hidden:true}
					,{ dataIndex: 'DVRY_CUST_SEQ'	,width: 90  	,hidden:true}
					,{ dataIndex: 'DVRY_CUST_NM'	,width: 100  	,hidden:true}
					,{ dataIndex: 'PROCESS_TYPE'	,width: 90  	,hidden:true}
					,{ dataIndex: 'EMP_ID'			,width: 90  	,hidden:true}
					,{ dataIndex: 'DEPT_NAME'		,width: 100  	,hidden:true}
					,{ dataIndex: 'RANK_NAME'		,width: 90  	,hidden:true}
					,{ dataIndex: 'DUTY_NAME'		,width: 90  	,hidden:true}
					,{ dataIndex: 'HOBBY_STR'		,width: 90  	,hidden:true}
					,{ dataIndex: 'CO_TEL_NO'		,width: 100  	,hidden:true}
					,{ dataIndex: 'MOBILE_NO'		,width: 100  	,hidden:true}
					,{ dataIndex: 'EMAIL_ADDR'		,width: 200  	,hidden:true}
					,{ dataIndex: 'RES_ADDR'		,width: 120  	,hidden:true}
					,{ dataIndex: 'JOIN_YEAR'		,width: 90  	,hidden:true}
					,{ dataIndex: 'ADVAN_DATE'		,width: 90  	,hidden:true}
					,{ dataIndex: 'BIRTH_DATE'		,width: 90 		,hidden:true}
					,{ dataIndex: 'WEDDING_DATE'	,width: 90 		,hidden:true}
					,{ dataIndex: 'WIFE_BIRTH_DATE'	,width: 90 		,hidden:true}
					,{ dataIndex: 'CHILD_BIRTH_DATE',width: 90 		,hidden:true}
					,{ dataIndex: 'MARRY_YN'		,width: 80  	,hidden:true}
					,{ dataIndex: 'CHILD_CNT'		,width: 80  	,hidden:true}
					,{ dataIndex: 'GIRLFRIEND_YN'	,width: 90  	,hidden:true}
					,{ dataIndex: 'GIRLFRIEND_RES'	,width: 120 	,hidden:true}
					,{ dataIndex: 'FAMILY_STR'		,width: 80  	,hidden:true}
					,{ dataIndex: 'FAMILY_WITH_YN'	,width: 90 		,hidden:true}
					,{ dataIndex: 'HIGH_EDUCATION'	,width: 80 		,hidden:true}
					,{ dataIndex: 'BIRTH_PLACE'		,width: 100  	,hidden:true}
					,{ dataIndex: 'NATURE_FEATURE'	,width: 100 	,hidden:true}
					,{ dataIndex: 'SCHOOL_FEAUTRE'	,width: 110 	,hidden:true}                
					,{ dataIndex: 'MILITARY_SVC'	,width: 90  	,hidden:true}
					,{ dataIndex: 'DRINK_CAPA'		,width: 90  	,hidden:true}
					,{ dataIndex: 'SMOKE_YN'		,width: 80  	,hidden:true}
					,{ dataIndex: 'CO_FELLOW'		,width: 140  	,hidden:true}
					,{ dataIndex: 'MOTOR_TYPE'		,width: 90  	,hidden:true}
					,{ dataIndex: 'HOUSE_TYPE'		,width: 90  	,hidden:true}
					,{ dataIndex: 'TWITTER_ID'		,width: 120  	,hidden:true}
					,{ dataIndex: 'FACEBOOK_ID'		,width: 120  	,hidden:true}
					,{ dataIndex: 'CREATE_EMP'		,width: 80  	,hidden:true}
					,{ dataIndex: 'CREATE_DATE'		,width: 90  	,hidden:true}
					,{ dataIndex: 'KEYWORD'			,width: 140  	,hidden:true}
					,{ dataIndex: 'REMARK'			,width: 150 , flex:1 } 
			
          ] ,
          listeners: {
	          onGridDblClick:function(grid, record, cellIndex, colName) {
		          	var rv = {
						status : "OK",
						data:[record.raw]
					};
					window.returnValue = rv;
					window.close();
	          }
          } //listeners
    });
    
    
 	Unilite.PopupMain({
		items: [panelSearch, 	masterGrid],
		id: 'clientPopupApp',
		fnInitBinding: function() {
			var param = window.dialogArguments;
			var frm= Ext.getCmp('clientPopupSearchForm');
			
			if(param['TYPE'] == 'VALUE') {
				frm.setValue('TXT_SEARCH',param['CLIENT_ID']);
			} else {
				frm.setValue('TXT_SEARCH',param['CLIENT_NAME']);
			}
			
			this._dataLoad();
		},
		 onQueryButtonDown : function()	{
			this._dataLoad();
		},
		onSubmitButtonDown : function()	{
			var selectRecord = masterGrid.getSelectedRecord();
		 	var rv = {
				status : "OK",
				data:[selectRecord.raw]
			};
			window.returnValue = rv;
			window.close();
		},
		_dataLoad : function() {
			var me = this;
			var param= Ext.getCmp('clientPopupSearchForm').getValues();
			console.log( param );
			me.isLoading = true;
			masterGrid.getStore().load({
				params : param,
				callback:function()	{
					me.isLoading = false;
				}
			});
		}
	});

};


</script>
