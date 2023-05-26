/* 문서대중소분류 샘플 데이터 */
INSERT INTO BDC000T
     ( COMP_CODE, LEVEL1, LEVEL2, LEVEL3, LEVEL_NAME, INSERT_DB_USER, INSERT_DB_TIME, UPDATE_DB_USER, UPDATE_DB_TIME )
SELECT 'MASTER' , '100' , '*'   , '*'   , '기획'    , 'UNILITE'     , GETDATE()     , 'UNILITE'     , GETDATE() UNION ALL
SELECT 'MASTER' , '100' , '110' , '*'   , '기획일반', 'UNILITE'     , GETDATE()     , 'UNILITE'     , GETDATE() UNION ALL
SELECT 'MASTER' , '100' , '110' , '111' , '기획조사', 'UNILITE'     , GETDATE()     , 'UNILITE'     , GETDATE() UNION ALL
SELECT 'MASTER' , '100' , '110' , '112' , '조직관리', 'UNILITE'     , GETDATE()     , 'UNILITE'     , GETDATE() UNION ALL
SELECT 'MASTER' , '100' , '110' , '113' , '사무관리', 'UNILITE'     , GETDATE()     , 'UNILITE'     , GETDATE() UNION ALL
SELECT 'MASTER' , '100' , '110' , '114' , '홍보관리', 'UNILITE'     , GETDATE()     , 'UNILITE'     , GETDATE() UNION ALL
SELECT 'MASTER' , '100' , '110' , '115' , '경영감사', 'UNILITE'     , GETDATE()     , 'UNILITE'     , GETDATE() UNION ALL
SELECT 'MASTER' , '100' , '120' , '*'   , '기획대외', 'UNILITE'     , GETDATE()     , 'UNILITE'     , GETDATE() UNION ALL
SELECT 'MASTER' , '100' , '120' , '121' , '투자관리', 'UNILITE'     , GETDATE()     , 'UNILITE'     , GETDATE() UNION ALL
SELECT 'MASTER' , '100' , '120' , '122' , '해외사업', 'UNILITE'     , GETDATE()     , 'UNILITE'     , GETDATE() UNION ALL
SELECT 'MASTER' , '100' , '120' , '123' , '관계회사', 'UNILITE'     , GETDATE()     , 'UNILITE'     , GETDATE() UNION ALL
SELECT 'MASTER' , '200' , '*'   , '*'   , '총무'    , 'UNILITE'     , GETDATE()     , 'UNILITE'     , GETDATE() UNION ALL
SELECT 'MASTER' , '200' , '210' , '*'   , '총무일반', 'UNILITE'     , GETDATE()     , 'UNILITE'     , GETDATE() UNION ALL
SELECT 'MASTER' , '200' , '210' , '211' , '인사관리', 'UNILITE'     , GETDATE()     , 'UNILITE'     , GETDATE() UNION ALL
SELECT 'MASTER' , '200' , '210' , '212' , '복리관리', 'UNILITE'     , GETDATE()     , 'UNILITE'     , GETDATE() UNION ALL
SELECT 'MASTER' , '200' , '210' , '213' , '서무관리', 'UNILITE'     , GETDATE()     , 'UNILITE'     , GETDATE() UNION ALL
SELECT 'MASTER' , '200' , '210' , '214' , '섭외관리', 'UNILITE'     , GETDATE()     , 'UNILITE'     , GETDATE() UNION ALL
SELECT 'MASTER' , '200' , '210' , '215' , '시설관리', 'UNILITE'     , GETDATE()     , 'UNILITE'     , GETDATE() UNION ALL
SELECT 'MASTER' , '300' , '*'   , '*'   , '경리'    , 'UNILITE'     , GETDATE()     , 'UNILITE'     , GETDATE() UNION ALL
SELECT 'MASTER' , '300' , '310' , '*'   , '경리일반', 'UNILITE'     , GETDATE()     , 'UNILITE'     , GETDATE() UNION ALL
SELECT 'MASTER' , '300' , '310' , '311' , '예산관리', 'UNILITE'     , GETDATE()     , 'UNILITE'     , GETDATE() UNION ALL
SELECT 'MASTER' , '300' , '310' , '312' , '결산관리', 'UNILITE'     , GETDATE()     , 'UNILITE'     , GETDATE() UNION ALL
SELECT 'MASTER' , '300' , '310' , '313' , '자금관리', 'UNILITE'     , GETDATE()     , 'UNILITE'     , GETDATE() UNION ALL
SELECT 'MASTER' , '300' , '310' , '314' , '원가관리', 'UNILITE'     , GETDATE()     , 'UNILITE'     , GETDATE() UNION ALL
SELECT 'MASTER' , '300' , '310' , '315' , '출납관리', 'UNILITE'     , GETDATE()     , 'UNILITE'     , GETDATE() UNION ALL
SELECT 'MASTER' , '300' , '310' , '316' , '세무관리', 'UNILITE'     , GETDATE()     , 'UNILITE'     , GETDATE() UNION ALL
SELECT 'MASTER' , '400' , '*'   , '*'   , '영업'    , 'UNILITE'     , GETDATE()     , 'UNILITE'     , GETDATE() UNION ALL
SELECT 'MASTER' , '400' , '410' , '*'   , '영업국내', 'UNILITE'     , GETDATE()     , 'UNILITE'     , GETDATE() UNION ALL
SELECT 'MASTER' , '400' , '410' , '411' , '영업관리', 'UNILITE'     , GETDATE()     , 'UNILITE'     , GETDATE() UNION ALL
SELECT 'MASTER' , '400' , '410' , '412' , '고객관리', 'UNILITE'     , GETDATE()     , 'UNILITE'     , GETDATE() UNION ALL
SELECT 'MASTER' , '400' , '420' , '*'   , '영업해외', 'UNILITE'     , GETDATE()     , 'UNILITE'     , GETDATE() UNION ALL
SELECT 'MASTER' , '400' , '420' , '421' , '수출관리', 'UNILITE'     , GETDATE()     , 'UNILITE'     , GETDATE() UNION ALL
SELECT 'MASTER' , '400' , '420' , '422' , '수입관리', 'UNILITE'     , GETDATE()     , 'UNILITE'     , GETDATE() UNION ALL
SELECT 'MASTER' , '400' , '420' , '423' , '바이어'  , 'UNILITE'     , GETDATE()     , 'UNILITE'     , GETDATE() UNION ALL
SELECT 'MASTER' , '500' , '*'   , '*'   , '생산'    , 'UNILITE'     , GETDATE()     , 'UNILITE'     , GETDATE() UNION ALL
SELECT 'MASTER' , '500' , '510' , '*'   , '생산일반', 'UNILITE'     , GETDATE()     , 'UNILITE'     , GETDATE() UNION ALL
SELECT 'MASTER' , '500' , '510' , '511' , '공정관리', 'UNILITE'     , GETDATE()     , 'UNILITE'     , GETDATE() UNION ALL
SELECT 'MASTER' , '500' , '510' , '512' , '자재관리', 'UNILITE'     , GETDATE()     , 'UNILITE'     , GETDATE() UNION ALL
SELECT 'MASTER' , '500' , '510' , '513' , '외주관리', 'UNILITE'     , GETDATE()     , 'UNILITE'     , GETDATE() UNION ALL
SELECT 'MASTER' , '500' , '510' , '514' , '설비관리', 'UNILITE'     , GETDATE()     , 'UNILITE'     , GETDATE() UNION ALL
SELECT 'MASTER' , '500' , '520' , '*'   , '연구개발', 'UNILITE'     , GETDATE()     , 'UNILITE'     , GETDATE() UNION ALL
SELECT 'MASTER' , '500' , '530' , '*'   , '품질관리', 'UNILITE'     , GETDATE()     , 'UNILITE'     , GETDATE()

/* 현재 UNILITE 에서 구현되어 있는 대,중,소 분류 콤보에 대한 기능입니다. 참조해 주세요...
   기존 품목분류에서 콤보를 만들때 사용한 쿼리입니다...
   대분류, 중분류, 소분류 값을 가지고 있다가 대분류를 선택하게 되면 중분류에 대분류에 해당하는 중분류 코드만 남겨두고 선택하도록 되어 있습니다.
   중분류를 선택할 때 대분류의 선택여부를 확인해서 값이 없으면 대분류값을 선택하라고 메시지가 나옵니다.
*/   
/* 문서 대분류 조회 쿼리 */
SELECT LEVEL1
     , LEVEL_NAME 
  FROM BDC000T 
 WHERE COMP_CODE = N'MASTER'
   AND LEVEL2    = '*'
   AND LEVEL3    = '*'

/* 문서 중분류 조회 쿼리 */
SELECT LEVEL1
     , LEVEL2
     , LEVEL_NAME
  FROM BDC000T
 WHERE COMP_CODE = N'MASTER'
   AND LEVEL2   <> '*'
   AND LEVEL3    = '*'

/* 문서 소분류 조회 쿼리 */
SELECT LEVEL1
     , LEVEL2
     , LEVEL3
     , LEVEL_NAME
  FROM BDC000T
 WHERE COMP_CODE = N'MASTER'
   AND LEVEL2   <> '*'
   AND LEVEL3   <> '*'

/* 문서명과 조인시 대중소 분류명 조회 쿼리
   문서테이블은 임시로 만들어 본 것이 때문에 만드신 컬럼으로 대체해서 참조해 주세요...
   문서테이블 DOC100T
   문서번호   DOC_NO
   문서명     DOC_NAME
   문서대분류 DOC_LEVEL1
   문서중분류 DOC_LEVEL1
   문서소분류 DOC_LEVEL1
 */
SELECT A.COMP_CODE
     , A.DOC_LEVEL1
     , M1.LEVEL_NAME         AS DOC_LEVEL1_NAME
     , A.DOC_LEVEL2
     , M1.LEVEL_NAME         AS DOC_LEVEL2_NAME
     , A.DOC_LEVEL3
     , M1.LEVEL_NAME         AS DOC_LEVEL3_NAME
     , A.DOC_NO
     , A.DOC_NAME
FROM            BDC100T A  WITH (NOLOCK)
     LEFT  JOIN BDC000T M1 WITH (NOLOCK) ON M1.COMP_CODE = A.COMP_CODE
									    AND M1.LEVEL1   <> '*'
									    AND M1.LEVEL1    = A.DOC_LEVEL1
									    AND M1.LEVEL2    = '*'
									    AND M1.LEVEL3    = '*'
     LEFT  JOIN BDC000T M2 WITH (NOLOCK) ON M2.COMP_CODE = A.COMP_CODE
									    AND M2.LEVEL1   <> '*'
									    AND M2.LEVEL1    = A.DOC_LEVEL1
									    AND M2.LEVEL2   <> '*'
									    AND M2.LEVEL2    = A.DOC_LEVEL2
									    AND M2.LEVEL3    = '*'
     LEFT  JOIN BDC000T M3 WITH (NOLOCK) ON M3.COMP_CODE = A.COMP_CODE
									    AND M3.LEVEL1   <> '*'
									    AND M3.LEVEL1    = A.DOC_LEVEL1
									    AND M3.LEVEL2   <> '*'
									    AND M3.LEVEL2    = A.DOC_LEVEL2
									    AND M3.LEVEL3   <> '*'
									    AND M3.LEVEL3    = A.DOC_LEVEL3
