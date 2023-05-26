<%@page language="java" contentType="application/javascript; charset=utf-8"%>
<%
// 우편번호 팝업
request.setAttribute("PKGNAME","Unilite.app.popup.ZipPopup");
%>
/**
 *   Model 정의
 * @type
 */
Unilite.defineModel('${PKGNAME}.ZipPopupModel', {
    fields: [ 	 {name: 'ZIP_CODE' 				,text:'<t:message code="system.label.common.zipcode" default="우편번호"/>' 	,type:'string'	}
				,{name: 'ZIP_NAME' 					,text:'<t:message code="system.label.common.zipname" default="지명"/>' 		,type:'string'	}
				,{name: 'ZIP_CODE1_NAME' 	,text:'<t:message code="system.label.common.do" default="시도"/>' 		,type:'string'	}
				,{name: 'ZIP_CODE2_NAME' 	,text:'<t:message code="system.label.common.gu" default="시군구"/>' 		,type:'string'	}
				,{name: 'ZIP_CODE3_NAME' 	,text:'<t:message code="system.label.common.town" default="읍면동"/>' 		,type:'string'	}
				,{name: 'ZIP_CODE5_NAME' 	,text:'<t:message code="system.label.common.lotnum" default="지번"/>' 		,type:'string'	}
				,{name: 'ZIP_CODE4_NAME' 	,text:'<t:message code="system.label.common.roadname" default="도로명"/>' 		,type:'string'	}
				,{name: 'ZIP_CODE7_NAME' 	,text:'<t:message code="system.label.common.massdelivery" default="다량배달처"/>' 	,type:'string'	}
				,{name: 'LAW_DONG' 				,text:'<t:message code="system.label.common.lawdong" default="법정동"/>' 	,type:'string'	}
				,{name: 'ADDR2' 						,text:'<t:message code="system.label.common.address2" default="주소2"/>' 		,type:'string'	}
			]
	});


/**
 * 검색조건 (Search Panel)
 * @type
 */

Ext.define('${PKGNAME}', {
    extend: 'Unilite.com.BaseJSPopupApp',
    constructor : function(config) {
        var me = this;
        if (config) {
            Ext.apply(me, config);
        }
	    /**
	     * 검색조건 (Search Panel)
	     * @type
	     */
	    var wParam = this.param;
	    /*var t1= false, t2 = false;
	    if( Ext.isDefined(wParam)) {
	        if(wParam['ADDR_TYPE'] == 'B') {
	            t1 = true;
	            t2 = false;
	        } else {
	            t1 = false;
	            t2 = true;
	        }
	    }*/
		me.data = {},
		me.uniOpt = {
			btnQueryHide:true,
	    	btnCloseHide:false
		},
		me.panelSearch = Unilite.createSearchForm('',{
		    layout : {type : 'uniTable', columns : 2},
		    items: [ /* { hideLabel:true, name: 'ADDR_TYPE',width:130, xtype: 'uniRadiogroup', comboType:'AU',comboCode:'B232', value:wParam['ADDR_TYPE'], allowBlank:false}
		    		 ,*/{ fieldLabel: '<t:message code="system.label.common.addrdetail" default="읍/면/동/도로"/>', 	name:'TXT_SEARCH', allowBlank:false,
		    		     listeners:{
		    		  		blur:function()	{
		    		  			if(me && me.panelSearch )me.panelSearch.setValue('ZIP_CODE','');
		    		  		}
		    		     }, hidden:true
		    		  }
		    		 ,{ fieldLabel: '<t:message code="system.label.common.zipcode" default="우편번호"/>', 		name:'ZIP_CODE', hidden:true}]
		});

		me.detailForm = Unilite.createForm('', {
	    layout: {type: 'uniTable', columns: 1},
	    defaultType: 'uniTextfield',
	    itemId:'ZipPopupForm',
	    disabled : false,
		items :[
					  {fieldLabel:'<t:message code="system.label.common.zipcode" default="우편번호"/>'	, name: 'ZIP_CODE'	, width:150}
					 ,{fieldLabel:'<t:message code="system.label.common.address" default="주소"/>'		, name: 'ZIP_NAME'	, width:385}
					 ,{fieldLabel:'&nbsp;'		, name: 'ADDR2'		, width:385}
				]
		});
		config.items = [
			me.panelSearch,
			{
				xtype:'component',
				tdAttrs:{height:400},
				html:'<div id="zipPopupLayer" style="width:480px;height:400px;overflow:auto;z-index:1;-webkit-overflow-scrolling:touch;margin:5px"></div>',
				listeners:{
					afterrender:function()	{
						me.zip_execDaumPostcode();
					}
				}
    		},
    		me.detailForm
		];
		me.callParent(arguments);


    },
	initComponent : function(){
    	var me  = this;


    	this.callParent();
    },
	fnInitBinding : function(param) {
			var me  = this;
			var frm = me.panelSearch;
			if(param['GBN'] == 'addr'){
				frm.setValue('TXT_SEARCH', param['ADDR']);
			}else{
				if(param['ZIP_CODE']) {
					frm.setValue('TXT_SEARCH', param['ZIP_CODE']);
				}
			}

			//if(param['ADDR']) 		frm.setValue('TXT_SEARCH', param['ADDR']);
			//if(param['ADDR_TYPE'])  frm.setValue('ADDR_TYPE', param['ADDR_TYPE']);

	},
	 onQueryButtonDown : function()	{
	 	var me = this;
	 	//var form = me.panelSearch.getForm();
	 	//if(form.isValid( ))	{
			//me._dataLoad();

			me.zip_execDaumPostcode();
	 	//}
	},
	onSubmitButtonDown : function()	{
        var me=this;
	 	var rv ;
		if(!Ext.isEmpty(me.data))	{
			me.data.ZIP_CODE 	= me.detailForm.getValue('ZIP_CODE');
			me.data.ZIP_NAME 	= me.detailForm.getValue('ZIP_NAME');
			me.data.ADDR2 		= me.detailForm.getValue('ADDR2');
		 	rv = {
				status : "OK",
				data:[me.data]
			};
		}
		me.returnData(rv);
	},
	zip_execDaumPostcode: function() {
		// 현재 scroll 위치를 저장해놓는다.
		//var currentScroll = Math.max(document.body.scrollTop, document.documentElement.scrollTop);
		var zipPopupLayer = document.getElementById('zipPopupLayer');
		var me = this;
		new daum.Postcode({
			oncomplete: function (data) {
				// 검색결과 항목을 클릭했을때 실행할 코드를 작성하는 부분.

				// 각 주소의 노출 규칙에 따라 주소를 조합한다.
				// 내려오는 변수가 값이 없는 경우엔 공백('')값을 가지므로, 이를 참고하여 분기 한다.
				var fullAddr = data.address; // 최종 주소 변수
				var extraAddr = ''; // 조합형 주소 변수

				// 기본 주소가 도로명 타입일때 조합한다.
				if (data.addressType === 'R') {
					//법정동명이 있을 경우 추가한다.
					if (data.bname !== '') {
						extraAddr += data.bname;
					}
					// 건물명이 있을 경우 추가한다.
					if (data.buildingName !== '') {
						extraAddr += (extraAddr !== '' ? ', ' + data.buildingName : data.buildingName);
					}
					// 조합형주소의 유무에 따라 양쪽에 괄호를 추가하여 최종 주소를 만든다.
					fullAddr += (extraAddr !== '' ? ' (' + extraAddr + ')' : '');
				}

				// 우편번호와 주소 및 영문주소 정보를 해당 필드에 넣는다.
				//top.parent.txtZip1.value = data.postcode1;
				//top.parent.txtZip2.value = data.postcode2;
				me.data = { 'ZIP_CODE': data.zonecode,
							'ZIP_NAME': fullAddr,
							'ZIP_CODE1_NAME': data.sido, 			//대도시/도
							'ZIP_CODE2_NAME': data.sigungu, 		//시군구
							'ZIP_CODE3_NAME': data.bname,			//읍면동
							'ZIP_CODE4_NAME': data.roadAddress,	//도로명
							'ZIP_CODE5_NAME': "", 	//건물번호본번
							'ZIP_CODE7_NAME': data.buildingName, 	//다량배달처명
							'LAW_DONG': 	 data.bname 			//법정동
				}
				me.detailForm.setValue('ZIP_CODE', 	me.data.ZIP_CODE);
				me.detailForm.setValue('ZIP_NAME', 	me.data.ZIP_NAME);

				//me.onSubmitButtonDown();

			},
			// 우편번호 찾기 화면 크기가 조정되었을때 실행할 코드를 작성하는 부분. iframe을 넣은 element의 높이값을 조정한다.
			onresize: function (size) {
				zipPopupLayer.style.height =  '400px';
				zipPopupLayer.style.width =  '480px';
			},
			width: '100%',
			height: 400
		}).embed(zipPopupLayer, {
		                        autoClose: false,
		                        q:me.panelSearch.getValue('TXT_SEARCH')
		                       });
		//zipPopupLayer.style.display = 'block';
	}

});

