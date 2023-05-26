/**
 * 
 * 
 * 
 * CMS100T CMS300T 제거하기 위한 데이타 변경사항
 */


  ALTER TABLE BSA300T ADD AUTHORITY_LEVEL NVARCHAR(10) NULL;

  /* AUTHORITY_LEVEL 데이타 이관 */
	UPDATE B
	SET B.AUTHORITY_LEVEL = A.AUTHORITY_LEVEL
	FROM  BSA300T B
	INNER JOIN CMS100T A ON	A.COMP_CODE = B.COMP_CODE
						AND A.EMP_ID = B.PERSON_NUMB;
						
	/* 사번이 등록 않됨 */
	UPDATE BSA300T
	SET AUTHORITY_LEVEL='10'
	WHERE USER_ID='mwlee'  ;
	
	/* 고객카드정보에 작성자 */
	UPDATE A
     SET CREATE_EMP = B.USER_ID
    FROM            CMB100T A
         INNER JOIN BSA300T B ON B.COMP_CODE   = A.COMP_CODE
                             AND B.PERSON_NUMB = A.CREATE_EMP;

		UPDATE A
     SET UPDATE_EMP = B.USER_ID, CREATE_EMP = C.USER_ID
    FROM            CMD100T A
         INNER JOIN BSA300T B ON B.COMP_CODE   = A.COMP_CODE
                             AND B.PERSON_NUMB = A.UPDATE_EMP
		 INNER JOIN BSA300T C ON C.COMP_CODE   = A.COMP_CODE
                             AND C.PERSON_NUMB = A.CREATE_EMP;
                         
   /* 공통코드영업담당(=CB48) */
  DELETE BSA100T WHERE COMP_CODE=N'MASTER' AND MAIN_CODE=N'CB48';

  IF NOT EXISTS (SELECT TOP 1 * FROM BSA100T WHERE COMP_CODE=N'MASTER' AND MAIN_CODE=N'CB48' AND SUB_CODE=N'$')
  BEGIN
    INSERT INTO BSA100T (COMP_CODE, MAIN_CODE, SUB_CODE, 
                         CODE_NAME, CODE_NAME_EN,  CODE_NAME_CN, CODE_NAME_JP, 
                         SYSTEM_CODE_YN, 
                         REF_CODE1, REF_CODE2, REF_CODE3, REF_CODE4, REF_CODE5, 
                         REF_CODE6, REF_CODE7, REF_CODE8, REF_CODE9, REF_CODE10,
                         USE_YN, SORT_SEQ, SUB_LENGTH, UPDATE_DB_USER, UPDATE_DB_TIME)
    SELECT                          
            COMP_CODE, N'CB48', N'$', 
            N'영업담당',  N'', N'', N'', 
            N'0', 
            N'', N'', N'', N'', N'', 
            N'', N'', N'', N'', N'',             
            N'Y', N'0', N'10', N'UNILITE5', getdate() 
    FROM BOR100T
  END;

--  DELETE BSA100T WHERE COMP_CODE=N'MASTER' AND MAIN_CODE=N'CB48' AND SUB_CODE=N'01'
--  IF NOT EXISTS (SELECT TOP 1 * FROM BSA100T WHERE COMP_CODE=N'MASTER' AND MAIN_CODE=N'CB48' AND SUB_CODE=N'01')
--  BEGIN
    INSERT INTO BSA100T (COMP_CODE, MAIN_CODE, SUB_CODE, 
                         CODE_NAME, CODE_NAME_EN,  CODE_NAME_CN, CODE_NAME_JP, 
                         SYSTEM_CODE_YN, 
                         REF_CODE1, REF_CODE2, REF_CODE3, REF_CODE4, REF_CODE5, 
                         REF_CODE6, REF_CODE7, REF_CODE8, REF_CODE9, REF_CODE10,
                         USE_YN, SORT_SEQ, SUB_LENGTH, UPDATE_DB_USER, UPDATE_DB_TIME)
    SELECT                          
            COMP_CODE, N'CB48', EMP_ID,
            EMP_NAME,  N'', N'', N'', 
            N'0', 
            N'', N'', N'', N'', N'', 
            N'', N'', N'', N'', N'',             
            N'Y', N'1', N'10', N'UNILITE5', getdate() 
    FROM CMS100T
    WHERE RESPON_DUTY = 'SD'
--  END

/* 공통코드개발담당(=CB49) */
  DELETE BSA100T WHERE COMP_CODE=N'MASTER' AND MAIN_CODE=N'CB49'
  IF NOT EXISTS (SELECT TOP 1 * FROM BSA100T WHERE COMP_CODE=N'MASTER' AND MAIN_CODE=N'CB49' AND SUB_CODE=N'$')
  BEGIN
    INSERT INTO BSA100T (COMP_CODE, MAIN_CODE, SUB_CODE, 
                         CODE_NAME, CODE_NAME_EN,  CODE_NAME_CN, CODE_NAME_JP, 
                         SYSTEM_CODE_YN, 
                         REF_CODE1, REF_CODE2, REF_CODE3, REF_CODE4, REF_CODE5, 
                         REF_CODE6, REF_CODE7, REF_CODE8, REF_CODE9, REF_CODE10,
                         USE_YN, SORT_SEQ, SUB_LENGTH, UPDATE_DB_USER, UPDATE_DB_TIME)
    SELECT                          
            COMP_CODE, N'CB49', N'$', 
            N'개발담당',  N'', N'', N'', 
            N'0', 
            N'', N'', N'', N'', N'', 
            N'', N'', N'', N'', N'',             
            N'Y', N'0', N'10', N'UNILITE5', getdate() 
    FROM BOR100T
  END

--  DELETE BSA100T WHERE COMP_CODE=N'MASTER' AND MAIN_CODE=N'CB49' AND SUB_CODE=N'01'
--  IF NOT EXISTS (SELECT TOP 1 * FROM BSA100T WHERE COMP_CODE=N'MASTER' AND MAIN_CODE=N'CB49' AND SUB_CODE=N'01')
--  BEGIN
    INSERT INTO BSA100T (COMP_CODE, MAIN_CODE, SUB_CODE, 
                         CODE_NAME, CODE_NAME_EN,  CODE_NAME_CN, CODE_NAME_JP, 
                         SYSTEM_CODE_YN, 
                         REF_CODE1, REF_CODE2, REF_CODE3, REF_CODE4, REF_CODE5, 
                         REF_CODE6, REF_CODE7, REF_CODE8, REF_CODE9, REF_CODE10,
                         USE_YN, SORT_SEQ, SUB_LENGTH, UPDATE_DB_USER, UPDATE_DB_TIME)
    SELECT                          
            COMP_CODE, N'CB49', EMP_ID, 
            EMP_NAME,  N'', N'', N'', 
            N'0', 
            N'', N'', N'', N'', N'', 
            N'', N'', N'', N'', N'',             
            N'Y', N'1', N'10', N'UNILITE5', getdate() 
    FROM CMS100T
    WHERE RESPON_DUTY = 'RD';
--  END

/* 공통코드소견작성자(=CB50) */
  DELETE BSA100T WHERE COMP_CODE=N'MASTER' AND MAIN_CODE=N'CB50'
  IF NOT EXISTS (SELECT TOP 1 * FROM BSA100T WHERE COMP_CODE=N'MASTER' AND MAIN_CODE=N'CB50' AND SUB_CODE=N'$')
  BEGIN
    INSERT INTO BSA100T (COMP_CODE, MAIN_CODE, SUB_CODE, 
                         CODE_NAME, CODE_NAME_EN,  CODE_NAME_CN, CODE_NAME_JP, 
                         SYSTEM_CODE_YN, 
                         REF_CODE1, REF_CODE2, REF_CODE3, REF_CODE4, REF_CODE5, 
                         REF_CODE6, REF_CODE7, REF_CODE8, REF_CODE9, REF_CODE10,
                         USE_YN, SORT_SEQ, SUB_LENGTH, UPDATE_DB_USER, UPDATE_DB_TIME)
    SELECT                          
            COMP_CODE, N'CB50', N'$', 
            N'소견/작성자',  N'', N'', N'', 
            N'0', 
            N'', N'', N'', N'', N'', 
            N'', N'', N'', N'', N'',             
            N'Y', N'0', N'10', N'UNILITE5', getdate() 
    FROM BOR100T
  END

--  DELETE BSA100T WHERE COMP_CODE=N'MASTER' AND MAIN_CODE=N'CB50' AND SUB_CODE=N'01'
--  IF NOT EXISTS (SELECT TOP 1 * FROM BSA100T WHERE COMP_CODE=N'MASTER' AND MAIN_CODE=N'CB50' AND SUB_CODE=N'01')
--  BEGIN
    INSERT INTO BSA100T (COMP_CODE, MAIN_CODE, SUB_CODE, 
                         CODE_NAME, CODE_NAME_EN,  CODE_NAME_CN, CODE_NAME_JP, 
                         SYSTEM_CODE_YN, 
                         REF_CODE1, REF_CODE2, REF_CODE3, REF_CODE4, REF_CODE5, 
                         REF_CODE6, REF_CODE7, REF_CODE8, REF_CODE9, REF_CODE10,
                         USE_YN, SORT_SEQ, SUB_LENGTH, UPDATE_DB_USER, UPDATE_DB_TIME)
    SELECT                          
            COMP_CODE, N'CB50', EMP_ID,
            EMP_NAME,  N'', N'', N'', 
            N'0', 
            N'', N'', N'', N'', N'', 
            N'', N'', N'', N'', N'',             
            USE_YN, N'1', N'10', N'UNILITE5', getdate() 
    FROM CMS100T
--  END
			   

 
