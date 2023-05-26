IF NOT EXISTS (
    SELECT TOP 1 1
    FROM SYSOBJECTS A 
      INNER JOIN SYSCOLUMNS B ON A.ID=B.ID
    WHERE A.NAME='BSA100T'
    AND B.NAME='REF_CODE10' )
BEGIN

 ALTER TABLE [BSA100T]
 ADD     REF_CODE6           NVARCHAR(50)        NULL ,                          /* 관련코드6    */                                    
   REF_CODE7           NVARCHAR(50)        NULL ,                          /* 관련코드7    */                                    
   REF_CODE8           NVARCHAR(50)        NULL ,                          /* 관련코드8    */                                    
   REF_CODE9           NVARCHAR(50)        NULL ,                          /* 관련코드9    */                                    
   REF_CODE10          NVARCHAR(50)        NULL                            /* 관련코드10   */ 
END 
GO
    

--DELETE BSA100T WHERE COMP_CODE=N'MASTER' AND MAIN_CODE=N'B241' AND SUB_CODE=N'$'
  IF NOT EXISTS (SELECT TOP 1 * FROM BSA100T WHERE COMP_CODE=N'MASTER' AND MAIN_CODE=N'B241' AND SUB_CODE=N'$')
  BEGIN
    INSERT INTO BSA100T (COMP_CODE, MAIN_CODE, SUB_CODE, 
                         CODE_NAME, CODE_NAME_EN,  CODE_NAME_CN, CODE_NAME_JP, 
                         SYSTEM_CODE_YN, 
                         REF_CODE1, REF_CODE2, REF_CODE3, REF_CODE4, REF_CODE5, 
                         REF_CODE6, REF_CODE7, REF_CODE8, REF_CODE9, REF_CODE10,
                         USE_YN, SORT_SEQ, SUB_LENGTH, UPDATE_DB_USER, UPDATE_DB_TIME)
    SELECT                          
            COMP_CODE, N'B241', N'$', 
            N'문서파일종류',  N'', N'', N'', 
            N'0', 
            N'', N'', N'', N'', N'', 
            N'', N'', N'', N'', N'',             
            N'Y', N'1', N'2', N'10093', getdate() 
    FROM BOR100T
  END


--DELETE BSA100T WHERE COMP_CODE=N'MASTER' AND MAIN_CODE=N'B241' AND SUB_CODE=N'10'
  IF NOT EXISTS (SELECT TOP 1 * FROM BSA100T WHERE COMP_CODE=N'MASTER' AND MAIN_CODE=N'B241' AND SUB_CODE=N'10')
  BEGIN
    INSERT INTO BSA100T (COMP_CODE, MAIN_CODE, SUB_CODE, 
                         CODE_NAME, CODE_NAME_EN,  CODE_NAME_CN, CODE_NAME_JP, 
                         SYSTEM_CODE_YN, 
                         REF_CODE1, REF_CODE2, REF_CODE3, REF_CODE4, REF_CODE5, 
                         REF_CODE6, REF_CODE7, REF_CODE8, REF_CODE9, REF_CODE10,
                         USE_YN, SORT_SEQ, SUB_LENGTH, UPDATE_DB_USER, UPDATE_DB_TIME)
    SELECT                          
            COMP_CODE, N'B241', N'10', 
            N'Merchandising fund',  N'', N'', N'', 
            N'0', 
            N'', N'', N'', N'', N'', 
            N'', N'', N'', N'', N'',             
            N'Y', N'1', N'2', N'10093', getdate() 
    FROM BOR100T
  END


--DELETE BSA100T WHERE COMP_CODE=N'MASTER' AND MAIN_CODE=N'B241' AND SUB_CODE=N'20'
  IF NOT EXISTS (SELECT TOP 1 * FROM BSA100T WHERE COMP_CODE=N'MASTER' AND MAIN_CODE=N'B241' AND SUB_CODE=N'20')
  BEGIN
    INSERT INTO BSA100T (COMP_CODE, MAIN_CODE, SUB_CODE, 
                         CODE_NAME, CODE_NAME_EN,  CODE_NAME_CN, CODE_NAME_JP, 
                         SYSTEM_CODE_YN, 
                         REF_CODE1, REF_CODE2, REF_CODE3, REF_CODE4, REF_CODE5, 
                         REF_CODE6, REF_CODE7, REF_CODE8, REF_CODE9, REF_CODE10,
                         USE_YN, SORT_SEQ, SUB_LENGTH, UPDATE_DB_USER, UPDATE_DB_TIME)
    SELECT                          
            COMP_CODE, N'B241', N'20', 
            N'Sales fundamental',  N'', N'', N'', 
            N'0', 
            N'', N'', N'', N'', N'', 
            N'', N'', N'', N'', N'',             
            N'Y', N'2', N'2', N'10093', getdate() 
    FROM BOR100T
  END
  
  
    ALTER TABLE BDC100T ADD CHANNEL_DEPT	NVARCHAR(8) NULL
    ALTER TABLE BDC100T ADD CHANNEL_CUSTOM	NVARCHAR(8) NULL
    ALTER TABLE BDC100T ADD FILE_TYPE		NVARCHAR(10) NULL
