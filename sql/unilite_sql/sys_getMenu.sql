--UBsa01Krv.CBsa400UKr[fnGetMenu] Query01                                                                                              
DECLARE     @COMP_CODE      NVARCHAR(08)        -- (�Է�) �����ڵ�
          , @USER_ID        NVARCHAR(10)        -- (�ʼ�) �����ID
          , @CNT            INT        --

SET     @USER_ID        = N'GOINDOLE'

-- ������� �����ڵ� ��������
SELECT  @COMP_CODE = COMP_CODE, @CNT = (SELECT COUNT(1) FROM BSA300T WITH (NOLOCK) WHERE USER_ID=A.USER_ID)
FROM    BSA300T A WITH (NOLOCK)
WHERE   USER_ID    = @USER_ID
IF @CNT > 1
    SET @COMP_CODE='MASTER'
SELECT CAST(A.PGM_DEPTH AS CHAR(01))               AS PGM_DEPTH
     , CAST('' AS CHAR(04))                        AS PGM_UNIQUE_ID
     , CAST(A.PGM_NAME AS nvarchar(30))            AS PGM_NAME
     , CAST('/pages/'                         + 
            LOWER(ISNULL(A.PGM_LOCATION, '')) + '/' +
            LOWER(A.PGM_ID) + '.htm' AS CHAR(100)) AS PGM_LOCATION
     , CAST(A.PGM_ID AS CHAR(20))                  AS PGM_ID
     , CAST(A.USE_YN AS CHAR(01))                  AS USE_YN
     , USE_POWER
     , USE_FILE
     , ISNULL(B.SHT_INFO, '')                      AS SHT_INFO
     , B.AU_LVL
     , B.USER_ID
     , B.PERSON_NUMB
     , B.DEPT_CODE
     , B.DIV_CODE
     , B.DEPT_LENGTH
     , B.BA_TOTAL_YN
     , (CASE ISNULL(B.BA_GRDFOCUS_YN,'')
             WHEN ''
                  THEN 'Y'
                  ELSE ISNULL(B.BA_GRDFOCUS_YN,'')
         END)                                      AS BA_GRDFOCUS_YN
  FROM (SELECT *
          FROM (SELECT '$' AS PGM_DEPTH
                     , B.PGM_NAME       AS PGM_NAME
                     , C.CODE_NAME AS PGM_LOCATION
                     , A.PGM_ID
                     , B.USE_YN
                     , '000000' + RIGHT(A.PGM_ARNG_SEQ + 10000, 4) AS MENU_SORT
                     , (SELECT PGM_LEVEL
                          FROM BSA500TV
                         WHERE COMP_CODE = A.COMP_CODE
                           AND USER_ID   = A.USER_ID
                           AND PGM_ID    = A.PGM_ID) AS USE_POWER
                     , (SELECT PGM_LEVEL2
                          FROM BSA500TV
                         WHERE COMP_CODE = A.COMP_CODE
                           AND USER_ID   = A.USER_ID
                           AND PGM_ID    = A.PGM_ID) AS USE_FILE
                     , B.PGM_SEQ
                  FROM BSA410T A WITH (NOLOCK) 
                       INNER JOIN BSA400T B WITH (NOLOCK) 
                                 ON A.PGM_ID    = B.PGM_ID
                                AND B.COMP_CODE = @COMP_CODE
                       LEFT OUTER JOIN BSA100T C WITH (NOLOCK) 
                                 ON C.MAIN_CODE = 'B008'
                                AND B.LOCATION  = C.SUB_CODE
                                AND B.COMP_CODE = C.COMP_CODE
                       INNER JOIN BSA500TV D ON A.PGM_ID = D.PGM_ID AND D.COMP_CODE = @COMP_CODE
                 WHERE B.USE_YN    = N'1'
               AND B.PGM_TYPE  = N'1'
                   AND A.USER_ID   = N'GOINDOLE'
                   AND D.USER_ID   = N'GOINDOLE'
                   AND B.PGM_SEQ   = (SELECT MIN(PGM_SEQ)
                                       FROM BSA400T WITH (NOLOCK) 
                                      WHERE PGM_ID    = A.PGM_ID
                                        AND USE_YN    = N'1'
                                    AND PGM_TYPE  = N'1'
                                        )
                UNION ALL
                SELECT '0'               AS PGM_DEPTH
                     , uniLITE.fnGetTxt('B0107')  AS PGM_NAME
                     , ''                AS PGM_LOCATION
                     , '0000'            AS PGM_ID
                     , '1'               AS USE_YN
                     , '00' + '00010001' AS MENU_SORT
                     , '0'               AS USE_POWER
                     , '1'               AS USE_FILE
                     , '11'              AS PGM_SEQ
                UNION ALL
                SELECT '1'              AS PGM_DEPTH
                     , CODE_NAME        AS PGM_NAME
                     , ''                AS PGM_LOCATION
                     , SUB_CODE          AS PGM_ID
                     , '1'               AS USE_YN
                     , LEFT(SUB_CODE + '0000000000', 10) AS MENU_SORT
                     , '0'               AS USE_POWER
                     , '1'               AS USE_FILE
                     , SUB_CODE          AS PGM_SEQ
                  FROM BSA100T WITH (NOLOCK) 
                 WHERE COMP_CODE = @COMP_CODE
                   AND MAIN_CODE = 'B007'
                   AND SUB_CODE <> '$'
                UNION ALL
                SELECT CONVERT(CHAR(1),PGM_LEVEL) AS PGM_DEPTH
                     , PGM_NAME         AS PGM_NAME
                     , '' AS PGM_LOCATION
                     , PGM_ID
                     , USE_YN
                     , LEFT(RIGHT(PGM_SEQ + 100, 2) + PGM_ID + '0000000000', 10) AS MENU_SORT
                     , '0' AS USE_POWER
                     , '1' AS USE_FILE
                     , PGM_SEQ
                  FROM BSA400T WITH (NOLOCK) 
                 WHERE COMP_CODE = @COMP_CODE
                   AND TYPE      = '9'
                   AND USE_YN    = '1'
               AND PGM_TYPE  = N'1'
                UNION ALL
                SELECT '@' AS PGM_DEPTH
                     , A.PGM_NAME       AS PGM_NAME
                     , C.CODE_NAME AS PGM_LOCATION
                     , A.PGM_ID
                     , (CASE B.USE_YN WHEN '1' THEN '1' ELSE '0' END) USE_YN
                     , RIGHT(A.PGM_SEQ + 100, 2) + 
                       LEFT(A.UP_PGM_DIV, 4)     +
                       RIGHT(A.PGM_ARNG_SEQ + 10000, 4) AS MENU_SORT
                     , B.PGM_LEVEL AS USE_POWER
                     , B.PGM_LEVEL2 AS USE_FILE
                     , A.PGM_SEQ
                  FROM BSA400T A WITH (NOLOCK) 
                               LEFT OUTER JOIN (SELECT DISTINCT COMP_CODE
                                                     , PGM_ID
                                                     , '1' AS USE_YN
                                                     , PGM_LEVEL
                                                     , PGM_LEVEL2
                                                  FROM (SELECT X.COMP_CODE
                                                             , X.PGM_ID
                                                             , X.PGM_LEVEL
                                                             , X.PGM_LEVEL2
                                                          FROM BSA500TV X
                                                         WHERE X.USER_ID = N'GOINDOLE') X) B
                                            ON A.COMP_CODE = B.COMP_CODE
                                           AND A.PGM_ID    = B.PGM_ID
                               LEFT OUTER JOIN BSA100T C
                                            ON C.MAIN_CODE = 'B008'
                                           AND A.COMP_CODE = C.COMP_CODE
                                           AND A.LOCATION  = C.SUB_CODE
                 WHERE A.TYPE     <> '9'
                   AND A.TYPE     <> '0'
                   AND A.TYPE     <> '5'
                   AND A.USE_YN    = '1'
               AND A.PGM_TYPE  = N'1'
                   AND A.COMP_CODE = @COMP_CODE
                UNION ALL
                SELECT '^' AS PGM_DEPTH
                     , A.PGM_NAME       AS PGM_NAME
                     , C.CODE_NAME AS PGM_LOCATION
                     , A.PGM_ID
                     , (CASE B.USE_YN WHEN '1' THEN '1' ELSE '0' END) USE_YN
                     , RIGHT(A.PGM_SEQ + 100, 2) +
                       LEFT(A.UP_PGM_DIV, 4)     +
                       RIGHT(A.PGM_ARNG_SEQ + 10000, 4) AS MENU_SORT
                     , B.PGM_LEVEL AS USE_POWER
                     , B.PGM_LEVEL2 AS USE_FILE
                     , A.PGM_SEQ
                  FROM BSA400T A WITH (NOLOCK) 
                               LEFT OUTER JOIN (SELECT DISTINCT COMP_CODE
                                                     , PGM_ID
                                                     , '1' AS USE_YN
                                                     , PGM_LEVEL
                                                     , PGM_LEVEL2
                                                  FROM (SELECT X.COMP_CODE
                                                             , X.PGM_ID
                                                             , X.PGM_LEVEL
                                                             , X.PGM_LEVEL2
                                                         FROM BSA500TV X
                                                        WHERE X.USER_ID = N'GOINDOLE') X) B
                                            ON A.COMP_CODE = B.COMP_CODE
                                           AND A.PGM_ID    = B.PGM_ID
                               LEFT OUTER JOIN BSA100T C WITH (NOLOCK) 
                                            ON C.MAIN_CODE = 'B008'
                                           AND A.COMP_CODE = C.COMP_CODE
                                           AND A.LOCATION  = C.SUB_CODE
                 WHERE A.TYPE      = '5'
                   AND A.USE_YN    = '1'
               AND A.PGM_TYPE  = N'1'
                   AND A.COMP_CODE = @COMP_CODE
                UNION ALL
                SELECT '#' AS PGM_DEPTH
                     , A.PGM_NAME       AS PGM_NAME
                     , C.CODE_NAME AS PGM_LOCATION
                     , A.PGM_ID
                     , (CASE B.USE_YN WHEN '1' THEN '1' ELSE '0' END) AS USE_YN
                     , RIGHT(A.PGM_SEQ + 100, 2) +
                       LEFT(A.UP_PGM_DIV, 4)     +
                       RIGHT(A.PGM_ARNG_SEQ + 10000, 4) AS MENU_SORT
                     , B.PGM_LEVEL AS USE_POWER
                     , B.PGM_LEVEL2 AS USE_FILE
                     , A.PGM_SEQ
                  FROM BSA400T A WITH (NOLOCK) 
                              LEFT OUTER JOIN (SELECT DISTINCT COMP_CODE
                                                    , PGM_ID
                                                    , '1' AS USE_YN
                                                    , PGM_LEVEL
                                                    , PGM_LEVEL2
                                                 FROM (SELECT X.COMP_CODE
                                                            , X.PGM_ID
                                                            , X.PGM_LEVEL
                                                            , X.PGM_LEVEL2
                                                         FROM BSA500TV X
                                                        WHERE X.USER_ID = N'GOINDOLE') X) B
                                           ON A.COMP_CODE = B.COMP_CODE
                                          AND A.PGM_ID    = B.PGM_ID
                              LEFT OUTER JOIN BSA100T C WITH (NOLOCK) 
                                           ON C.MAIN_CODE = 'B008'
                                          AND A.COMP_CODE = C.COMP_CODE
                                          AND A.LOCATION  = C.SUB_CODE
                 WHERE A.COMP_CODE = @COMP_CODE
                   AND A.TYPE     = '0'
               AND A.PGM_TYPE = N'1'
                   AND A.USE_YN   = '1'
                    ) A
         WHERE A.PGM_SEQ IN ('11','33','34','35','36','37','38','39','40','21','12','13','14','15','16','17','18','19','32')) A
        LEFT OUTER JOIN (SELECT A.AU_LVL
                              , A.USER_ID
                              , A.COMP_CODE
                              , B.PERSON_NUMB
                              , B.DEPT_CODE
                              , B.DIV_CODE
                              , A.PGM_ID
                              , SUBSTRING(B.DEPT_CODE, 1, (CASE WHEN A.AU_LVL = '2'
                                                                  OR A.AU_LVL = '3'
                                                                  OR A.AU_LVL = '4'
                                                                THEN (SELECT ISNULL(SUM(CONVERT(INT, REF_CODE1)), 0)
                                                                        FROM BSA100T WITH (NOLOCK) 
                                                                       WHERE COMP_CODE = @COMP_CODE
                                                                         AND MAIN_CODE = 'BS01'
                                                                         AND SUB_CODE <> '$'
                                                                         AND SUB_CODE <= A.AU_LVL)
                                                                ELSE '' END)) AS DEPT_LENGTH
                              , (CASE WHEN (SELECT BA_TOTAL_YN
                                              FROM BSA310T WITH (NOLOCK) 
                                             WHERE COMP_CODE = A.COMP_CODE
                                               AND USER_ID   = A.USER_ID
                                               AND PGM_ID    = A.PGM_ID) IS NULL
                                      THEN (SELECT BA_TOTAL_YN
                                              FROM BSA310T WITH (NOLOCK) 
                                             WHERE COMP_CODE = A.COMP_CODE
                                               AND USER_ID   = A.USER_ID
                                               AND PGM_ID    = '$')
                                      ELSE (SELECT BA_TOTAL_YN
                                              FROM BSA310T WITH (NOLOCK) 
                                             WHERE COMP_CODE = A.COMP_CODE
                                               AND USER_ID   = A.USER_ID
                                               AND PGM_ID    = A.PGM_ID)
                                  END) AS BA_TOTAL_YN
                              , (CASE WHEN (SELECT BA_GRDFOCUS_YN
                                              FROM BSA310T WITH (NOLOCK) 
                                             WHERE COMP_CODE = A.COMP_CODE
                                               AND USER_ID   = A.USER_ID
                                               AND PGM_ID    = A.PGM_ID) IS NULL
                                      THEN (SELECT BA_GRDFOCUS_YN
                                              FROM BSA310T WITH (NOLOCK) 
                                             WHERE COMP_CODE = A.COMP_CODE
                                               AND USER_ID   = A.USER_ID
                                               AND PGM_ID    = '$')
                                      ELSE (SELECT BA_GRDFOCUS_YN
                                              FROM BSA310T WITH (NOLOCK) 
                                             WHERE COMP_CODE = A.COMP_CODE
                                               AND USER_ID   = A.USER_ID
                                               AND PGM_ID    = A.PGM_ID)
                                  END) AS BA_GRDFOCUS_YN
                              , C.SHT_INFO
                           FROM (SELECT DISTINCT (CASE WHEN A.AUTHO_TYPE = 0
                                                         OR A.AUTHO_TYPE IS NULL
                                                         OR A.AUTHO_TYPE = ''
                                                       THEN 'N'
                                                       WHEN B.AUTHO_USER IS NULL
                                                         OR B.AUTHO_USER = ''
                                                       THEN 'N'
                                                       ELSE B.AUTHO_USER
                                                   END) AS AU_LVL
                                      , A.COMP_CODE
                                      , B.PGM_ID
                                      , B.USER_ID
                                   FROM BSA400T A WITH (NOLOCK) 
                                        INNER JOIN BSA500TV B ON A.COMP_CODE = B.COMP_CODE AND A.PGM_ID = B.PGM_ID
                                  WHERE A.COMP_CODE = @COMP_CODE
                                AND A.PGM_TYPE   = N'1'
                                    AND B.USER_ID    = N'GOINDOLE') A
                         LEFT OUTER JOIN (SELECT COMP_CODE
                                               , 'GOINDOLE' AS USER_ID
                                               , PGM_ID
                                               , SHT_INFO
                                            FROM BSA420T WITH (NOLOCK) 
                                           WHERE COMP_CODE = @COMP_CODE
                                             AND USER_ID = CASE '1' WHEN '0' THEN ''
                                                                    WHEN '1' THEN 'GOINDOLE'
                                                                             ELSE NULL
                                                            END) C
                                      ON C.USER_ID = CASE '1' WHEN '0' THEN ''
                                                              WHEN '1' THEN 'GOINDOLE'
                                                                       ELSE NULL END
                                     AND A.COMP_CODE = C.COMP_CODE
                                     AND A.PGM_ID    = C.PGM_ID
                         INNER JOIN BSA300T B WITH (NOLOCK) ON A.COMP_CODE = B.COMP_CODE
                                              AND A.USER_ID   = B.USER_ID
                      ) B
                      ON A.PGM_ID = B.PGM_ID
 ORDER BY A.MENU_SORT