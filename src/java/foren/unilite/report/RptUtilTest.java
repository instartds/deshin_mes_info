package foren.unilite.report;

import java.text.DecimalFormat;
import java.util.FormatterClosedException;
import java.math.*;
import java.lang.*;

import net.sf.jasperreports.engine.JRDefaultScriptlet;

public class RptUtilTest {

		/**
		 * 정수형으로 들어온 입력값을  문자열로 바꿔 리턴한다.
		 * @param number 숫자 입력값
		 * @return
		 * @throws Exception 
		 * @throws FormulaException
		 */
		public String getHangul(int number) throws Exception {
			return getHangul(Integer.toString(number));
		}

		/**
		 * 숫자를 한글로 변환하는 메서드
		 * @param number 숫자 입력값
		 * @return 한글로 변환된 수
		 * @throws Exception 
		 * @throws FormulaException
		 */
		public String getHangul(String number) throws Exception {
			// 결과값을 저장하는 변수
			StringBuffer result = new StringBuffer();
			// 한글 숫자를 담은 배열
			String[] hangulNum = { "", "일", "이", "삼", "사", "오", "육", "칠", "팔", "구" };
			// 음수 일 경우 음수 부호를 담는 변수
			String minus = "";
			// 숫자의 길이를 담는 변수
			int numLength = number.length();
			 // 값을 자릿수에 맞게 다시 집어 넣기 위한 변수
			int[] numArray = new int[16];

			if (numLength > 16) {
				throw new Exception("자릿수가 초과했습니다");
			}

			// 입력값을 자리에 맞게 배열에 배치한다.
			for (int index = (numArray.length - numLength); index < numArray.length; index++) {
				int numPoint = index - (numArray.length - numLength);
				
				String num = String.valueOf(number.charAt(numPoint));
				if(num.equals("-")){
					minus = "-";
				} else {
					numArray[index] = Integer.parseInt(num);
				}
			}

			// 배열을 4자리씩 확인하면서 한글로 변환하는 메서드
			for (int index = 0; index < 4; index++) {
				int unit = (index * 4);

				if (numArray[unit] + numArray[unit + 1] + numArray[unit + 2] + numArray[unit + 3] > 0) {
					if (numArray[unit] > 0) {
						result.append(hangulNum[numArray[unit]]).append("천");
					}
					if (numArray[unit + 1] > 0) {
						result.append(hangulNum[numArray[unit + 1]]).append("백");
					}
					if (numArray[unit + 2] > 0) {
						result.append(hangulNum[numArray[unit + 2]]).append("십");
					}
					if (numArray[unit + 3] > 0) {
						result.append(hangulNum[numArray[unit + 3]]);
					}

					switch (index) {
					case 0:
						result.append("조");
						break;
					case 1:
						result.append("억");
						break;
					case 2:
						result.append("만");
						break;
					}
				}
			}		
			return minus+result.toString();
		}
}