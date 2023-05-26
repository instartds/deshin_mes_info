//@charset UTF-8
/**
 * 영업 모듈용 공통 함수 모음
 * @class Unilite.module.UniSales
 * @singleton
 */
Ext.define('Unilite.module.UniSales', {
	alternateClassName: 'UniSales',
	singleton: true,

	/** Excel round / roundup / rounddown 함수 
	 * roundup 과 rounddown은 ceil과 floor와 약간 다름 
	 * roundup : 0 에서 먼 수
	 * rounddown : 0 에서 가까운 수
	 * 음수 round의 경우 abs 기준 round 사용 !!! 즉 -3.5 는 -4 임.
	 * @param {number} dAmount
	 * @param {String} sUnderCalBase 1: roundup, 2:rounddown, 기타 : round
	 * @param {Integer} numDigit
	 */
	fnAmtWonCalc: function(dAmount, sUnderCalBase, numDigit) {
		var absAmt = 0, wasMinus = false;
		var numDigit = (numDigit == undefined) ? 0 : numDigit ;

		if( dAmount >= 0 ) {
			absAmt = dAmount;
		} else {
			absAmt = Math.abs(dAmount);
			wasMinus = true;
		}

		var mn = Math.pow(10,numDigit);
		switch (sUnderCalBase) {
			case  "1" :	//up : 0에서 멀어짐.
				absAmt = Math.ceil(absAmt * mn) / mn;
				break;
			case  "2" :	//cut : 0에서 가까와짐, 아래 자리수 버림.
				absAmt = Math.floor(absAmt * mn) / mn;
				break;
			default:						//round
				absAmt = Math.round(absAmt * mn) / mn;
		}
		// 음수 였다면 -1을 곱하여 복원.
		return (wasMinus) ? absAmt * (-1) : absAmt;
	},
	//20191001 세액구하는 함수 생성
	fnVatCalc: function(dAmount, sUnderCalBase, numDigit) {
		var absAmt = 0, wasMinus = false;
		var numDigit = (numDigit == undefined) ? 0 : numDigit ;

		//한국의 경우 소숫점 버림
		if(UserInfo.currency == 'KRW') {
			sUnderCalBase = '2';
			numDigit = 0;
		}

		if( dAmount >= 0 ) {
			absAmt = dAmount;
		} else {
			absAmt = Math.abs(dAmount);
			wasMinus = true;
		}

		var mn = Math.pow(10, numDigit);
		switch (sUnderCalBase) {
			case  "1" :	//up : 0에서 멀어짐.
				absAmt = Math.ceil(absAmt * mn) / mn;
				break;
			case  "2" :	//cut : 0에서 가까와짐, 아래 자리수 버림.
				absAmt = Math.floor(absAmt * mn) / mn;
				break;
			default:						//round
				absAmt = Math.round(absAmt * mn) / mn;
		}
		// 음수 였다면 -1을 곱하여 복원.
		return (wasMinus) ? absAmt * (-1) : absAmt;
	},
	fnGetPriceInfo2: function(rtnRecord, fnCallback, sType,compCode, customCode, agentType, itemCode,  
							currency, orderUnit, stockUnit, transRate, baseDate,
							qty, sWgtUnit, sVolUnit, unitWgt, unitVol, priceType, bOpt, useDefaultPrice) {
		if(!Ext.isEmpty(customCode)  && !Ext.isEmpty(itemCode)) {
			var param = {'COMP_CODE':compCode
						, 'CUSTOM_CODE':customCode
						, 'AGENT_TYPE':agentType
						, 'ITEM_CODE':itemCode
						, 'MONEY_UNIT':currency
						, 'ORDER_UNIT':orderUnit
						, 'STOCK_UNIT':stockUnit
						, 'TRANS_RATE':transRate
						, 'BASIS_DATE':baseDate
						, 'WGT_UNIT':sWgtUnit
						, 'VOL_UNIT':sWgtUnit
						, 'USE_DEFAULT_PRICE': useDefaultPrice
						};
			Ext.getBody().mask();
			salesCommonService.fnGetPriceInfo2(param, function(provider, response) {
				Ext.getBody().unmask();
				if(!Ext.isEmpty(provider)) {
					var cbParam = {
						'sType':sType,
						'qty':qty,
						'unitWgt':unitWgt,
						'unitVol':unitVol,
						'priceType':priceType,
						'rtnRecord':rtnRecord,
						'bOpt':bOpt
					}
					fnCallback.call(this, provider, cbParam);
					/*
					var dSalePrice=Unilite.nvl(provider['SALE_PRICE'],0);
					
					
					var dWgtPrice = Unilite.nvl(provider['WGT_PRICE'],0);//판매단가(중량단위)
					var dVolPrice = Unilite.nvl(provider['VOL_PRICE'],0);//판매단가(부피단위)
					
					if(sType=='I') {
						
						//단가구분별 판매단가 계산
						if(priceType == 'A') {							//단가구분(판매단위)
							dWgtPrice = (unitWgt==0) ? 0 : dSalePrice / unitWgt
							dVolPrice  = (unitVol==0) ? 0 : dSalePrice / unitVol
						}else if(priceType == 'B') {						//단가구분(중량단위)
							dSalePrice = dWgtPrice  * unitWgt
							dVolPrice  = (unitVol==0) ? 0 : dSalePrice / unitVol
						}else if(priceType == 'C') {						//단가구분(부피단위)
							dSalePrice = dVolPrice  * unitVol;
							dWgtPrice = (unitWgt==0) ? 0 : dSalePrice / unitWgt
						}else {
							dWgtPrice = (unitWgt==0) ? 0 : dSalePrice / unitWgt
							dVolPrice = (unitVol==0) ? 0 : dSalePrice / unitVol
						}
						

						//판매단가 적용
						rtnRecord.set('ORDER_P',dSalePrice);
						rtnRecord.set('ORDER_WGT_P',dWgtPrice);
						rtnRecord.set('ORDER_VOL_P',dVolPrice);
						
						rtnRecord.set('TRANS_RATE',provider['SALE_TRANS_RATE']);
						rtnRecord.set('DISCOUNT_RATE',provider['DC_RATE']);
					}
					if(orderQ > 0)	UniAppManager.app.fnOrderAmtCal(rtnRecord, "P", dSalePrice);
					*/
				}
			});
		}
	},
	fnGetPriceInfo: function(rtnRecord, fnCallback, sType,compCode, customCode, agentType, itemCode,  
							currency, orderUnit, stockUnit, transRate, baseDate, bOpt) {
		if(!Ext.isEmpty(customCode)  && !Ext.isEmpty(itemCode)) {
			var param = {'COMP_CODE':compCode
						, 'CUSTOM_CODE':customCode
						, 'AGENT_TYPE':agentType
						, 'ITEM_CODE':itemCode
						, 'MONEY_UNIT':currency
						, 'ORDER_UNIT':orderUnit
						, 'STOCK_UNIT':stockUnit
						, 'TRANS_RATE':transRate
						, 'BASIS_DATE':baseDate
						};
			Ext.getBody().mask();
			salesCommonService.fnGetPriceInfo(param, function(provider, response) {
				Ext.getBody().unmask();
				if(!Ext.isEmpty(provider)) {
					var cbParam = {
						'sType':sType,
//						'unitWgt':unitWgt,
//						'unitVol':unitVol,
//						'priceType':priceType,
						'rtnRecord':rtnRecord
//						'bOpt':bOpt
					}
					fnCallback.call(this, provider, cbParam);
				}
			});
		}
	},
	fnGetDivPriceInfo2: function(rtnRecord, fnCallback, sType,compCode, customCode, agentType, itemCode,
							currency, orderUnit, stockUnit, transRate, baseDate,
							qty, sWgtUnit, sVolUnit, unitWgt, unitVol, priceType, priceYn, bOpt) {
		if(!Ext.isEmpty(customCode)  && !Ext.isEmpty(itemCode)) {
			var param = {'COMP_CODE':compCode
						, 'CUSTOM_CODE':customCode
						, 'AGENT_TYPE':agentType
						, 'ITEM_CODE':itemCode
						, 'MONEY_UNIT':currency
						, 'ORDER_UNIT':orderUnit
						, 'STOCK_UNIT':stockUnit
						, 'TRANS_RATE':transRate
						, 'BASIS_DATE':baseDate
						, 'WGT_UNIT':sWgtUnit
						, 'VOL_UNIT':sWgtUnit
						, 'PRICE_YN':priceYn
						};
			Ext.getBody().mask();
			salesCommonService.fnGetPriceInfo2(param, function(provider, response) {
				Ext.getBody().unmask();
				if(!Ext.isEmpty(provider)) {
					var cbParam = {
						'sType':sType,
						'qty':qty,
						'unitWgt':unitWgt,
						'unitVol':unitVol,
						'priceType':priceType,
						'rtnRecord':rtnRecord,
						'bOpt':bOpt
					}
					fnCallback.call(this, provider, cbParam);
				}
			});
		}
	},
	fnGetItemInfo: function(rtnRecord, fnCallbak, sType,compCode, customCode, agentType, itemCode,
							currency, orderUnit, stockUnit, transRate, baseDate,
							qty, sWgtUnit, sVolUnit, unitWgt, unitVol, priceType,  divCode, bParam3,  whCode, useDefaultPrice,
							//20190625 재고량에 가용재고 표시여부 관련로직 추가
							showPstock) {
		var param = { 'COMP_CODE'			: compCode
					, 'CUSTOM_CODE'			: customCode
					, 'AGENT_TYPE'			: agentType
					, 'ITEM_CODE'			: itemCode
					, 'MONEY_UNIT'			: currency
					, 'ORDER_UNIT'			: orderUnit
					, 'STOCK_UNIT'			: stockUnit
					, 'TRANS_RATE'			: transRate
					, 'BASIS_DATE'			: baseDate
					, 'WGT_UNIT'			: sWgtUnit
					, 'VOL_UNIT'			: sWgtUnit
					, 'DIV_CODE'			: divCode
					, 'bParam3'				: bParam3
					, 'WH_CODE'				: whCode
					, 'USE_DEFAULT_PRICE'	: useDefaultPrice
					, 'SHOW_PSTOCK'			: showPstock
					};

		salesCommonService.getItemInfo(param, function(provider, response) {
			Ext.getBody().unmask();
			if(!Ext.isEmpty(provider)) {
				var cbParams = {
					'sType'		: sType,
					'qty'		: qty,
					'unitWgt'	: unitWgt,
					'unitVol'	: unitVol,
					'priceType'	: priceType,
					'rtnRecord'	: rtnRecord
				}
				fnCallbak.call(this, provider, cbParams);
			}
		});
	},
	fnStockQ: function(rtnRecord, fnCallbak, compCode, divCode, bParam3, itemCode,  whCode) {
		if(!Ext.isEmpty(compCode) && !Ext.isEmpty(divCode) && !Ext.isEmpty(itemCode)) {
			var param = {'COMP_CODE':compCode
						, 'DIV_CODE':divCode
						, 'bParam3':bParam3
						, 'ITEM_CODE':itemCode
						, 'WH_CODE':whCode		};
			Ext.getBody().mask();
			//salesCommonServiceImpl
			salesCommonService.fnStockQ(param, function(provider, response) {
				Ext.getBody().unmask();
				console.log(provider);
				if(!Ext.isEmpty(provider)) {
					var cbParams = {
					//	'orderQ':orderQ,
						'rtnRecord':rtnRecord
					}
					fnCallbak.call(this, provider, cbParams);
				}
			});
		}
	},
	fnGetCustCredit: function (compCode, divCode, customCode, sDate, currency, rObj, rName,  rType, rValue) {
		var param = {'COMP_CODE':compCode
					, 'DIV_CODE':divCode
					, 'CUSTOM_CODE':customCode
					, 'S_DATE':sDate
					, 'CURRENCY':currency
					};
		Ext.getBody().mask();
		salesCommonService.fnGetCRedit(param, function(provider, response) {
			Ext.getBody().unmask();
			if(!Ext.isEmpty(provider)) {
				Unilite.messageBox(Msg.sMB009);
			}else {
				this.setReturnValue(rObj, rName,  rType, provider['CREDIT']);
			}
		})
		//return r;
	},
	/** 환율구하기
	 * @param {} compCode
	 * @param {} moneyUnit
	 * @param {} sData
	 * @param {} rObj
	 * @param {} rName
	 * @param {} rType
	 * @param {} rValue
	 */
	fnExchangeRate: function(compCode, moneyUnit, sDate, rObj, rName,  rType, rValue){
		var param = {'COMP_CODE':compCode
					, 'MONEY_UNIT':moneyUnit
					, 'S_DATE':sDate
					};
		Ext.getBody().mask();
		salesCommonService.fnExchangeRate(param, function(provider, response) {
			Ext.getBody().unmask();
			if(!Ext.isEmpty(provider)) {
				this.setReturnValue(rObj, rName,  rType, 1);
			} else {
				this.setReturnValue(rObj, rName,  rType, provider['BASE_EXCHG']);
			}
		})
	},
	/**
	 *  작업장에 대한 제조처 반환 
	 */
	fnOrgCd: function(compCode, orgCdType, wkShopcd, rObj, rName,  rType, rValue) {
		var param = {'COMP_CODE':compCode
					, 'TYPE':orgCdType
					, 'TREE_CODE':wkShopcd
					};
		Ext.getBody().mask();
		salesCommonService.fnOrgCd(param, function(provider, response) {
			Ext.getBody().unmask();
			if(!Ext.isEmpty(provider)) {
				Unilite.messageBox(Msg.sMB009);
			}else {
				this.setReturnValue(rObj, rName,  rType, provider['TYPE_LEVEL']);
			}
		})
	},
	/** 사업장정보 조회 
	 */
	fnGetOrgInfo: function(compCode, divCode, callbackFuntionName) {
		var param = { 'COMP_CODE':compCode
					, 'DIV_CODE':divCode
					};
		Ext.getBody().mask();
		salesCommonService.fnGetOrgInfo(param, function(provider, response) {
			Ext.getBody().unmask();
			if(!Ext.isEmpty(provider)) {
				Unilite.messageBox(Msg.sMB009);
			}else {
				eval(callbackFuntionName+"("+provider+")");
			}
		})
	},
	/** 마감정보 
	 */
	fnCloseCheck: function(compCode, divCode, whCd , sDate) {
		var param = {'COMP_CODE':compCode
					, 'DIV_CODE':divCode
					, 'WH_CODE' :whCd
		};
		Ext.getBody().mask();
		salesCommonService.fnGetOrgInfo(param, function(provider, response) {
			Ext.getBody().unmask();
		})
	},
	setReturnValue:function(rObj, rName,  rType, rValue) {
		if("RECORD" == rType) {
			rObj.set(rName, rValue)
		}else if("FORM") {
			rObj.setValue(rName, rValue)
		} else if("ARRAY"==rType) {
			rObj[rName] = rValue;
		}
	},
	fnGetClosingInfo: function(fnCallbak, divCode, sJobType, sDate){
		var monClosing = "";
		var dayClosing = "";
		var param = { 'DIV_CODE':divCode
					, 'S_JOB_TYPE':sJobType
					, 'SALE_DATE':sDate };
		salesCommonService.getMonClosing(param, function(provider1, response) {
			if(!Ext.isEmpty(provider1)) {
				if(provider1['AR_CLOSING'] >= sDate){
					monClosing = "Y";
				}else{
					monClosing = "N";
				}
			}
			salesCommonService.getDayClosing(param, function(provider2, response) {
				if(!Ext.isEmpty(provider2)) {
					var dayClosing = provider2['JOB_CLOSING'];
					var cbParams = {
						'gsMonClosing':	monClosing,
						'gsDayClosing': dayClosing
					}
					fnCallbak.call(this,cbParams);
				}else{
					salesCommonService.getDayClosing2(param, function(provider3, response) {
						if(!Ext.isEmpty(provider3)) {
							if(provider3['JOB_CLOSING'] >= sDate){
								dayClosing = "Y";
							}else{
								dayClosing = "N";
							}
							var cbParams = {
								'gsMonClosing':	monClosing,
								'gsDayClosing': dayClosing
							}
							fnCallbak.call(this,cbParams);
						}
					});
				}
			});
		});
	},
	/** 미수잔액, 선수금잔액 구하기 
	 */
	fnGetRemainder: function(fnCallback, iFlag, divCode, customCode, moneyUnit, collDate) {
		var param = { 'I_FLAG': iFlag
					, 'DIV_CODE': divCode
					, 'CUSTOM_CODE': customCode
					, 'MONEY_UNIT': moneyUnit
					, 'COLL_DATE': collDate
					};
//		Ext.getBody().mask();
		var result1 = 0;	//미수잔액
		var result2 = 0;	//선수금잔액
		salesCommonService.getRemainderInfo1(param, function(provider1, response) {	//미수금잔액 조회
			if(!Ext.isEmpty(provider1.UN_COLL_AMT)){
				result1 = provider1.UN_COLL_AMT;
			}
			salesCommonService.getRemainderInfo2(param, function(provider2, response) {	//선수금액 조회
				if(!Ext.isEmpty(provider2.UN_PRE_COLL_AMT)){
					result2 = provider2.UN_PRE_COLL_AMT;
				}
				fnCallback.call(this, result1, result2);
			});
		});
	},
	/** 화폐에 따른 환율구하기
	 * @param {} compCode
	 * @param {} moneyUnit
	 * @param {} sData
	 * @param {} rObj
	 * @param {} rName
	 * @param {} rType
	 * @param {} rValue
	 */
	fnExchgRateO: function(compCode, moneyUnit, acDate, rObj, rName,  rType, rValue, setReturnValue){
		var param = {'COMP_CODE':compCode
					, 'MONEY_UNIT':moneyUnit
					, 'AC_DATE':acDate
		};
		var result = 0;	// 환율
		
		Ext.getBody().mask();
		salesCommonService.fnExchgRateO(param, function(provider, response)   {
			Ext.getBody().unmask();
			result = provider.BASE_EXCHG;
		});
	},
	/** 품목따른 최근단가 구하기
	 * @param {} compCode
	 * @param {} moneyUnit
	 * @param {} sData
	 * @param {} rObj
	 * @param {} rName
	 * @param {} rType
	 * @param {} rValue
	 */
	fnGetLastPriceInfo: function(compCode, moneyUnit, aplyStartDate, type, customCode,  itemCode, orderUnit){
		var param = {'COMP_CODE': compCode
					, 'MONEY_UNIT': moneyUnit
					, 'APLY_START_DATE': aplyStartDate
					, 'TYPE': type
					, 'CUSTOM_CODE': customCode
					, 'ITEM_CODE': itemCode
					, 'ORDER_UNIT': orderUnit
		};
		var result1 = 0;
		var result2 = 1;

		Ext.getBody().mask();
		salesCommonService.fnGetLastPriceInfo(param, function(provider1, response) {
			Ext.getBody().unmask();
			result1 = provider1.ITEM_P;
		});
		salesCommonService.fnGetPriceTypeInfo(param, function(provider2, response) {
			Ext.getBody().unmask();
			result2 = provider2.PRICE_TYPE;
		});
	},
	//20200611 추가: 원화금액 환율적용
	fnExchangeApply: function(moneyUnit, amt){
		var commonCodes = Ext.data.StoreManager.lookup('CBS_AU_B004').data.items;
		var basisValue;
		Ext.each(commonCodes,function(commonCode, i) {
			if(commonCode.get('value') == moneyUnit) {
				basisValue = commonCode.get('refCode7');
			}
		})
		if(Ext.isEmpty(basisValue)) {
			basisValue = 1;
		}
		var AmtWon = amt;
		AmtWon = amt / basisValue;
		return AmtWon;
	},
	//20200611 추가: 외화금액 환율적용
	fnExchangeApply2: function(moneyUnit, amt){
		var commonCodes = Ext.data.StoreManager.lookup('CBS_AU_B004').data.items;
		var basisValue;
		Ext.each(commonCodes,function(commonCode, i) {
			if(commonCode.get('value') == moneyUnit) {
				basisValue = commonCode.get('refCode7');
			}
		})
		if(Ext.isEmpty(basisValue)) {
			basisValue = 1;
		}
		var AmtFor = amt;
		AmtFor = Unilite.multiply(amt, basisValue);
		return AmtFor;
	}
});