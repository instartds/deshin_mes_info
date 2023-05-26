/**
 * 
 */
 
Ext.define('Unilite.com.openapi.UniNaverSearch', {
	//extend : "Ext.Component",
	singleton: true,
	alternateClassName: ['UniNaverSearch'],
	//popupWidth:700,
	//popupHeight:550,
	//onSuccess 	: Ext.emptyFn,
	onFailure 	: function(response) {		
					Ext.Msg.show({
					     title:'Failure ',
					     msg: response.responseText,
					     buttons: Ext.Msg.OKCANCEL,
					     icon: Ext.Msg.ERROR
					});
	},
	onError 	: function(result) {		
					Ext.Msg.show({
					     title:'Error '+result.error_code,
					     msg: '정확한 도서코드를 입력해 주세요.',
					     buttons: Ext.Msg.OKCANCEL,
					     icon: Ext.Msg.ERROR
					});
	},	
//	initComponent : function() {		
//		this.callParent()
//	},
	/**
	 *  책 기본 검색
	 *  요청 파라미터 정보
	    key string (필수)  이용 등록을 통해 받은 key 스트링을 입력합니다. 
		target string (필수) : book  서비스를 위해서는 무조건 지정해야 합니다. 
		query string (필수)  검색을 원하는 질의, UTF-8 인코딩 입니다. 
		display integer : 기본값 10, 최대 100  검색결과 출력건수를 지정합니다. 최대 100 까지 가능합니다. 
		start  integer : 기본값 1, 최대 1000  검색의 시작위치를 지정할 수 있습니다. 최대 1000 까지 가능합니다 
	 * @param {} params
	 */
	searchBook: function(params) {
		var me = this;
		
		Ext.Ajax.request({
		    url: CPATH+'/openapi/naver/book/wsSearch.do',
		    params: params,
		    success: function(response, options){
		        var result = Ext.JSON.decode(response.responseText);
				
		        if(me.isSuccess(result)) {
		        	//me.onSuccess(result);
		        	if(callback && Ext.isFunction(callback)) {
		        		callback.call(this, me, result.items, result);
		        	}
		        }else{
		        	me.onError(result);
		        }
		    },
		    failure: function(response, options) {
		    	me.onFailure(response);
		    }
		});
	},
	
	/**
	 *  책 상세 검색
	 *  요청 파라미터 정보
	    target  string (필수) : book_adv  상세검색을 위해서는 무조건 지정해야 합니다. 
		query  string (필수)  검색을 원하는 질의, UTF-8 인코딩 입니다. 
		d_titl  string  책 제목에서의 검색을 의미합니다. 
		d_auth  string  저자명에서의 검색을 의미합니다. 
		d_cont  string  목차에서의 검색을 의미합니다. 
		d_isbn  string  isbn에서의 검색을 의미합니다. 
		d_publ  string  출판사에서의 검색을 의미합니다. 
		d_dafr  integer (ex.20000203)  검색을 원하는 책의 출간 범위를 지정합니다. (시작일) 
		d_dato  integer (ex.20000203)  검색을 원하는 책의 출간 범위를 지정합니다. (종료일) 
		d_catg  integer  검색을 원하는 카테고리를 지정합니다.  
		display integer : 기본값 10, 최대 100  검색결과 출력건수를 지정합니다. 최대 100 까지 가능합니다. 
		start  integer : 기본값 1, 최대 1000  검색의 시작위치를 지정할 수 있습니다. 최대 1000 까지 가능합니다.
	 * @param {} params
	 * @param {} callback
	 */
	searchBookAdv: function(params, callback) {
		var me = this;
		
		Ext.Ajax.request({
		    url: CPATH+'/openapi/naver/book/wsSearchAdv.do',
		    params: params,
		    success: function(response, options){
		        var result = Ext.JSON.decode(response.responseText);
				
		        if(me.isSuccess(result)) {
		        	//me.onSuccess(result);
		        	if(callback && Ext.isFunction(callback)) {
		        		callback.call(this, me, result.items, result);
		        	}
		        }else{
		        	if(callback && Ext.isFunction(callback)) {
		        		callback.call(this, me, null, false);
		        	}
//		        	me.onError(result);
		        }
		    },
		    failure: function(response, options) {
		    	me.onFailure(response);
		    }
		});
	},
	
	isSuccess: function(result) {
		return Ext.isEmpty(result.error_code);
	},
	
	openLink: function(url) {
		var me = this;
		
		var width = (screen.availWidth) / 2, height = (screen.availHeight) / 2;
    	var xPos = (screen.availWidth - width) / 2;
	    var yPos = (screen.availHeight - height ) / 2 ;
		
	    var features = "titlebar=0,location=0,menubar=0,toolbar=0,scrollbars=1,status=0," +
	            "width="+width +",height="+height ;
		window.open(url, '_blank', features);

	},
	getLinkScript: function(url) {
		var me = this;
		
		var width = (screen.availWidth) / 2, height = (screen.availHeight) / 2;
    	var xPos = (screen.availWidth - width) / 2;
	    var yPos = (screen.availHeight - height ) / 2 ;
		
	    var features = "titlebar=0,location=0,menubar=0,toolbar=0,scrollbars=1,status=0," +
	            "width="+width +",height="+height ;

	    return "window.open('"+url+"', '_blank', '"+features+"')";
	}
});