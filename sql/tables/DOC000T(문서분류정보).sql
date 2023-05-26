/*
uniLITE �����з�����
*/

BEGIN TRAN
SET NOCOUNT ON
BEGIN
    DECLARE     @ColLength       INTEGER,
                @UpdateDBUser    NVARCHAR(20)

    SET @ColLength    = 300
    SET @UpdateDBUser = N'uniLITE'

    IF EXISTS (SELECT NAME FROM SYSOBJECTS WHERE id = OBJECT_ID(@UpdateDBUser + N'.' + N'BDC000T_TMP') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
        DROP TABLE UNILITE.BDC000T_TMP

    IF EXISTS (SELECT NAME FROM SYSOBJECTS WHERE id = OBJECT_ID(@UpdateDBUser + N'.' + N'BDC000T') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
    BEGIN
         SELECT * INTO UNILITE.BDC000T_TMP FROM UNILITE.BDC000T

    
        IF @@ERROR <> 0
        BEGIN
            ROLLBACK

            RAISERROR('1. �ӽ� ���̺� ���� ����', 16, 1)
            GOTO END_LABEL
        END
    

        DROP TABLE UNILITE.BDC000T

        IF @@ERROR <> 0
        BEGIN
            ROLLBACK
    
            RAISERROR('2. ���̺� ���� ����', 16, 1)
            GOTO END_LABEL
        END
    END

    /************************************************************************************************************************/
    /*        TABLE NAME    :      uniLITE �����з�����(BDC000T)                                                            */
    /************************************************************************************************************************/
    CREATE TABLE uniLITE.BDC000T
    (
    /************************************************************************************************************************/
    --  Primary Key
        COMP_CODE			NVARCHAR(08)	NOT NULL DEFAULT 'MASTER' ,		/* �����ڵ�										*/
        LEVEL1              NVARCHAR(20)    NOT NULL DEFAULT '100' ,        /* ��з�                                       */
        LEVEL2              NVARCHAR(20)    NOT NULL DEFAULT '*' ,          /* �ߺз�                                       */
        LEVEL3              NVARCHAR(20)    NOT NULL DEFAULT '*' ,          /* �Һз�                                       */

    /************************************************************************************************************************/
    --  �з�����
        LEVEL_NAME          NVARCHAR(50)    NOT NULL ,                      /* �з���                                       */
        USE_YN              NVARCHAR(01)    NOT NULL DEFAULT 'Y' ,          /* ��뿩��                                     */

    /************************************************************************************************************************/
    --  ����
        INSERT_DB_USER      NVARCHAR(20)    NOT NULL DEFAULT 'uniLITE' ,    /* �Է���                                       */
        INSERT_DB_TIME      SMALLDATETIME   NOT NULL DEFAULT GETDATE() ,    /* �Է���                                       */
        UPDATE_DB_USER      NVARCHAR(20)    NOT NULL DEFAULT 'uniLITE' ,    /* ������                                       */
        UPDATE_DB_TIME      SMALLDATETIME   NOT NULL DEFAULT GETDATE() ,    /* ������                                       */
        TEMPC_01            NVARCHAR(30)        NULL ,                      /* �����÷�                                     */
        TEMPC_02            NVARCHAR(30)        NULL ,                      /* �����÷�                                     */
        TEMPC_03            NVARCHAR(30)        NULL ,                      /* �����÷�                                     */
        TEMPN_01            NUMERIC(30, 6)      NULL DEFAULT 0 ,            /* �����÷�                                     */
        TEMPN_02            NUMERIC(30, 6)      NULL DEFAULT 0 ,            /* �����÷�                                     */
        TEMPN_03            NUMERIC(30, 6)      NULL DEFAULT 0 ,            /* �����÷�                                     */

    /************************************************************************************************************************/
        CONSTRAINT BDC000T_IDX00 PRIMARY KEY CLUSTERED 
        (
            COMP_CODE ASC
          , LEVEL1 ASC
          , LEVEL2 ASC
          , LEVEL3 ASC
        )
    )
    /************************************************************************************************************************/
    /*        END OF TABLE                                                                                                  */
    /************************************************************************************************************************/

    DECLARE          @InsString        VARCHAR(4000),
                     @ColString        VARCHAR(4000),
                     @ColName          VARCHAR(50),
                     @TmpColLen        INTEGER


    SET @ColString = ''
    SET @TmpColLen = 0

    DECLARE CUR_BDC000T CURSOR FOR
        SELECT A.column_name
        FROM              INFORMATION_SCHEMA.COLUMNS  A  WITH (NOLOCK)
               INNER JOIN INFORMATION_SCHEMA.COLUMNS  B  WITH (NOLOCK) ON B.table_name    = 'BDC000T'
                                                                      AND B.column_name   = A.column_name
                                                                      AND B.table_schema  = A.table_schema
                                                                      AND B.table_catalog = A.table_catalog
               LEFT  JOIN syscomments                 C  WITH (NOLOCK) ON C.id            = OBJECT_ID('uniLITE' + '.' + B.table_name)
                                                                      AND C.number        = B.ordinal_position
                                                                      AND C.texttype      = 2
        WHERE  A.table_name    = 'BDC000T_TMP'
        AND    A.table_catalog = DB_NAME()
        AND    A.table_schema  = 'uniLITE'
        AND    C.text          IS NULL
        ORDER BY A.ordinal_position


    OPEN CUR_BDC000T
    FETCH NEXT FROM CUR_BDC000T INTO @ColName

    WHILE (@@FETCH_STATUS = 0)
    BEGIN
        IF @TmpColLen > @ColLength
        BEGIN
            SET @ColString = @ColString + CHAR(13) + SPACE(LEN('         SELECT  ') * 2)

            SET @TmpColLen = 0
        END

        SET @ColString = @ColString + LOWER(@ColName) + ', '

        SET @TmpColLen = @TmpColLen + LEN(@ColName)

        FETCH NEXT FROM CUR_BDC000T INTO @ColName
    END
    CLOSE CUR_BDC000T
    DEALLOCATE CUR_BDC000T
        
    IF LEN(@ColString) > 0
    BEGIN
        SET @ColString = SUBSTRING(@ColString, 1, LEN(@ColString) - 1)
    
        SET @InsString = ' INSERT ' + @UpdateDBUser + '.' + 'BDC000T( ' + @ColString + ' )' + CHAR(13) +
                         '         SELECT  ' + @ColString + CHAR(13) +
                         '           FROM  ' + @UpdateDBUser + '.' + 'BDC000T_TMP'
    
--        PRINT @InsString
    
        EXECUTE ( @InsString )
        
        IF (SELECT COUNT(1) FROM UNILITE.BDC000T) <> (SELECT COUNT(1) FROM UNILITE.BDC000T_TMP)
        BEGIN
            ROLLBACK
    
            RAISERROR('3. �ӽ� ���̺� -> �ű� ���̺� ���� ����', 16, 1)
            GOTO END_LABEL
        END

        DROP TABLE UNILITE.BDC000T_TMP

        IF @@ERROR <> 0
        BEGIN
            ROLLBACK
    
            RAISERROR('4. �ӽ� ���̺� ���� ����', 16, 1)
            GOTO END_LABEL
        END
    END

    CREATE INDEX BDC000T_IDX01 ON BDC000T(COMP_CODE, LEVEL2, LEVEL3) INCLUDE(LEVEL1, LEVEL_NAME)

---------------------------------------------------------------------------------------------------------------------
    PRINT    '!!!!!  ����  !!!!!'

    COMMIT

END_LABEL:
    SET NOCOUNT OFF

END
