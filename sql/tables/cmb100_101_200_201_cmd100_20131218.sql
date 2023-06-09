USE [UNILITE5]
GO

/****** Object:  Table [uniLITE].[CMB100T]    Script Date: 18-Dec-2013 10:11:54 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [uniLITE].[CMB100T](
	[COMP_CODE] [nvarchar](8) NOT NULL,
	[CLIENT_ID] [numeric](20, 0) IDENTITY(1000000000,1) NOT NULL,
	[CLIENT_NAME] [nvarchar](20) NOT NULL,
	[CUSTOM_CODE] [nvarchar](20) NOT NULL,
	[DVRY_CUST_SEQ] [nvarchar](10) NOT NULL,
	[PROCESS_TYPE] [nvarchar](10) NOT NULL,
	[EMP_ID] [nvarchar](10) NOT NULL,
	[DEPT_NAME] [nvarchar](20) NULL,
	[RANK_NAME] [nvarchar](20) NULL,
	[DUTY_NAME] [nvarchar](20) NULL,
	[HOBBY_STR] [nvarchar](40) NULL,
	[CO_TEL_NO] [nvarchar](20) NULL,
	[MOBILE_NO] [nvarchar](20) NULL,
	[EMAIL_ADDR] [nvarchar](100) NULL,
	[RES_ADDR] [nvarchar](20) NULL,
	[JOIN_YEAR] [nvarchar](10) NULL,
	[ADVAN_DATE] [nvarchar](10) NULL,
	[BIRTH_DATE] [nvarchar](10) NULL,
	[WEDDING_DATE] [nvarchar](10) NULL,
	[WIFE_BIRTH_DATE] [nvarchar](10) NULL,
	[CHILD_BIRTH_DATE] [nvarchar](10) NULL,
	[MARRY_YN] [nvarchar](1) NOT NULL,
	[CHILD_CNT] [int] NOT NULL,
	[GIRLFRIEND_YN] [nvarchar](1) NOT NULL,
	[GIRLFRIEND_RES] [nvarchar](20) NULL,
	[FAMILY_STR] [nvarchar](40) NULL,
	[FAMILY_WITH_YN] [nvarchar](1) NOT NULL,
	[HIGH_EDUCATION] [nvarchar](20) NULL,
	[BIRTH_PLACE] [nvarchar](20) NULL,
	[NATURE_FEATURE] [nvarchar](100) NULL,
	[SCHOOL_FEAUTRE] [nvarchar](100) NULL,
	[MILITARY_SVC] [nvarchar](100) NULL,
	[DRINK_CAPA] [nvarchar](100) NULL,
	[SMOKE_YN] [nvarchar](1) NOT NULL,
	[CO_FELLOW] [nvarchar](100) NULL,
	[MOTOR_TYPE] [nvarchar](40) NULL,
	[HOUSE_TYPE] [nvarchar](40) NULL,
	[TWITTER_ID] [nvarchar](100) NULL,
	[FACEBOOK_ID] [nvarchar](100) NULL,
	[CREATE_EMP] [nvarchar](10) NOT NULL,
	[CREATE_DATE] [nvarchar](10) NOT NULL,
	[KEYWORD] [nvarchar](200) NULL,
	[REMARK] [nvarchar](1000) NULL,
	[AUTHORITY_LEVEL] [nvarchar](10) NOT NULL,
	[INSERT_DB_USER] [nvarchar](20) NOT NULL,
	[INSERT_DB_TIME] [smalldatetime] NOT NULL,
	[UPDATE_DB_USER] [nvarchar](20) NOT NULL,
	[UPDATE_DB_TIME] [smalldatetime] NOT NULL,
	[TEMPC_01] [nvarchar](30) NULL,
	[TEMPC_02] [nvarchar](30) NULL,
	[TEMPC_03] [nvarchar](30) NULL,
	[TEMPN_01] [numeric](30, 6) NULL,
	[TEMPN_02] [numeric](30, 6) NULL,
	[TEMPN_03] [numeric](30, 6) NULL,
	[CLIENT_TYPE] [nvarchar](10) NULL,
	[KNOW_MOTIVE] [nvarchar](2) NULL,
	[INTEREST_PART] [nvarchar](50) NULL,
 CONSTRAINT [CMB100T_IDX00] PRIMARY KEY CLUSTERED 
(
	[COMP_CODE] ASC,
	[CLIENT_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [uniLITE].[CMB100T] ADD  DEFAULT ('MASTER') FOR [COMP_CODE]
GO

ALTER TABLE [uniLITE].[CMB100T] ADD  DEFAULT ('N') FOR [MARRY_YN]
GO

ALTER TABLE [uniLITE].[CMB100T] ADD  DEFAULT ((0)) FOR [CHILD_CNT]
GO

ALTER TABLE [uniLITE].[CMB100T] ADD  DEFAULT ('N') FOR [GIRLFRIEND_YN]
GO

ALTER TABLE [uniLITE].[CMB100T] ADD  DEFAULT ('N') FOR [FAMILY_WITH_YN]
GO

ALTER TABLE [uniLITE].[CMB100T] ADD  DEFAULT ('N') FOR [SMOKE_YN]
GO

ALTER TABLE [uniLITE].[CMB100T] ADD  DEFAULT ('uniLITE') FOR [INSERT_DB_USER]
GO

ALTER TABLE [uniLITE].[CMB100T] ADD  DEFAULT (getdate()) FOR [INSERT_DB_TIME]
GO

ALTER TABLE [uniLITE].[CMB100T] ADD  DEFAULT ('uniLITE') FOR [UPDATE_DB_USER]
GO

ALTER TABLE [uniLITE].[CMB100T] ADD  DEFAULT (getdate()) FOR [UPDATE_DB_TIME]
GO

ALTER TABLE [uniLITE].[CMB100T] ADD  DEFAULT ((0)) FOR [TEMPN_01]
GO

ALTER TABLE [uniLITE].[CMB100T] ADD  DEFAULT ((0)) FOR [TEMPN_02]
GO

ALTER TABLE [uniLITE].[CMB100T] ADD  DEFAULT ((0)) FOR [TEMPN_03]
GO


---------------------------------------------------------

USE [UNILITE5]
GO

/****** Object:  Table [uniLITE].[CMB101T]    Script Date: 18-Dec-2013 10:12:35 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [uniLITE].[CMB101T](
	[COMP_CODE] [nvarchar](8) NOT NULL,
	[UPDATE_DATETIME] [numeric](20, 0) NOT NULL,
	[CLIENT_ID] [numeric](20, 0) NOT NULL,
	[UPDATE_EMP] [nvarchar](10) NOT NULL,
	[CLIENT_NAME] [nvarchar](20) NOT NULL,
	[CUSTOM_CODE] [nvarchar](20) NOT NULL,
	[DVRY_CUST_SEQ] [nvarchar](10) NOT NULL,
	[PROCESS_TYPE] [nvarchar](10) NOT NULL,
	[EMP_ID] [nvarchar](20) NOT NULL,
	[DEPT_NAME] [nvarchar](20) NULL,
	[RANK_NAME] [nvarchar](20) NULL,
	[DUTY_NAME] [nvarchar](20) NULL,
	[HOBBY_STR] [nvarchar](40) NULL,
	[CO_TEL_NO] [nvarchar](20) NULL,
	[MOBILE_NO] [nvarchar](20) NULL,
	[EMAIL_ADDR] [nvarchar](100) NULL,
	[RES_ADDR] [nvarchar](20) NULL,
	[JOIN_YEAR] [nvarchar](10) NULL,
	[ADVAN_DATE] [nvarchar](10) NULL,
	[BIRTH_DATE] [nvarchar](10) NULL,
	[WEDDING_DATE] [nvarchar](10) NULL,
	[WIFE_BIRTH_DATE] [nvarchar](10) NULL,
	[CHILD_BIRTH_DATE] [nvarchar](10) NULL,
	[MARRY_YN] [nvarchar](1) NOT NULL,
	[CHILD_CNT] [int] NOT NULL,
	[GIRLFRIEND_YN] [nvarchar](1) NOT NULL,
	[GIRLFRIEND_RES] [nvarchar](20) NULL,
	[FAMILY_STR] [nvarchar](40) NULL,
	[FAMILY_WITH_YN] [nvarchar](1) NOT NULL,
	[HIGH_EDUCATION] [nvarchar](20) NULL,
	[BIRTH_PLACE] [nvarchar](20) NULL,
	[NATURE_FEATURE] [nvarchar](100) NULL,
	[SCHOOL_FEAUTRE] [nvarchar](100) NULL,
	[MILITARY_SVC] [nvarchar](100) NULL,
	[DRINK_CAPA] [nvarchar](100) NULL,
	[SMOKE_YN] [nvarchar](1) NOT NULL,
	[CO_FELLOW] [nvarchar](100) NULL,
	[MOTOR_TYPE] [nvarchar](40) NULL,
	[HOUSE_TYPE] [nvarchar](40) NULL,
	[TWITTER_ID] [nvarchar](100) NULL,
	[FACEBOOK_ID] [nvarchar](100) NULL,
	[CREATE_EMP] [nvarchar](10) NOT NULL,
	[CREATE_DATE] [nvarchar](10) NOT NULL,
	[KEYWORD] [nvarchar](200) NULL,
	[REMARK] [nvarchar](1000) NULL,
	[AUTHORITY_LEVEL] [nvarchar](10) NOT NULL,
	[INSERT_DB_USER] [nvarchar](20) NOT NULL,
	[INSERT_DB_TIME] [smalldatetime] NOT NULL,
	[UPDATE_DB_USER] [nvarchar](20) NOT NULL,
	[UPDATE_DB_TIME] [smalldatetime] NOT NULL,
	[TEMPC_01] [nvarchar](30) NULL,
	[TEMPC_02] [nvarchar](30) NULL,
	[TEMPC_03] [nvarchar](30) NULL,
	[TEMPN_01] [numeric](30, 6) NULL,
	[TEMPN_02] [numeric](30, 6) NULL,
	[TEMPN_03] [numeric](30, 6) NULL,
	[CLIENT_TYPE] [nvarchar](10) NULL,
	[KNOW_MOTIVE] [nvarchar](2) NULL,
	[INTEREST_PART] [nvarchar](50) NULL,
 CONSTRAINT [CMB101T_IDX00] PRIMARY KEY NONCLUSTERED 
(
	[COMP_CODE] ASC,
	[UPDATE_DATETIME] ASC,
	[CLIENT_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [uniLITE].[CMB101T] ADD  DEFAULT ('MASTER') FOR [COMP_CODE]
GO

ALTER TABLE [uniLITE].[CMB101T] ADD  DEFAULT ('') FOR [UPDATE_DATETIME]
GO

ALTER TABLE [uniLITE].[CMB101T] ADD  DEFAULT ('N') FOR [MARRY_YN]
GO

ALTER TABLE [uniLITE].[CMB101T] ADD  DEFAULT ((0)) FOR [CHILD_CNT]
GO

ALTER TABLE [uniLITE].[CMB101T] ADD  DEFAULT ('N') FOR [GIRLFRIEND_YN]
GO

ALTER TABLE [uniLITE].[CMB101T] ADD  DEFAULT ('N') FOR [FAMILY_WITH_YN]
GO

ALTER TABLE [uniLITE].[CMB101T] ADD  DEFAULT ('N') FOR [SMOKE_YN]
GO

ALTER TABLE [uniLITE].[CMB101T] ADD  DEFAULT ('uniLITE') FOR [INSERT_DB_USER]
GO

ALTER TABLE [uniLITE].[CMB101T] ADD  DEFAULT (getdate()) FOR [INSERT_DB_TIME]
GO

ALTER TABLE [uniLITE].[CMB101T] ADD  DEFAULT ('uniLITE') FOR [UPDATE_DB_USER]
GO

ALTER TABLE [uniLITE].[CMB101T] ADD  DEFAULT (getdate()) FOR [UPDATE_DB_TIME]
GO

ALTER TABLE [uniLITE].[CMB101T] ADD  DEFAULT ((0)) FOR [TEMPN_01]
GO

ALTER TABLE [uniLITE].[CMB101T] ADD  DEFAULT ((0)) FOR [TEMPN_02]
GO

ALTER TABLE [uniLITE].[CMB101T] ADD  DEFAULT ((0)) FOR [TEMPN_03]
GO

-----------------------------------------------------
USE [UNILITE5]
GO

/****** Object:  Table [uniLITE].[CMB200T]    Script Date: 18-Dec-2013 10:10:25 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [uniLITE].[CMB200T](
	[COMP_CODE] [nvarchar](8) NOT NULL,
	[PROJECT_NO] [nvarchar](20) NOT NULL,
	[UPDATE_EMP] [nvarchar](20) NOT NULL,
	[PROJECT_NAME] [nvarchar](40) NOT NULL,
	[PROJECT_OPT] [nvarchar](10) NOT NULL,
	[START_DATE] [nvarchar](10) NOT NULL,
	[TARGET_DATE] [nvarchar](10) NOT NULL,
	[PROJECT_TYPE] [nvarchar](10) NOT NULL,
	[CLASS_LEVEL1] [nvarchar](10) NOT NULL,
	[CLASS_LEVEL2] [nvarchar](10) NOT NULL,
	[SALE_EMP] [nvarchar](10) NOT NULL,
	[DEVELOP_EMP] [nvarchar](10) NULL,
	[NATION_CODE] [nvarchar](3) NULL,
	[CUSTOM_CODE] [nvarchar](20) NOT NULL,
	[DVRY_CUST_SEQ] [nvarchar](10) NOT NULL,
	[PROCESS_TYPE] [nvarchar](20) NOT NULL,
	[IMPORTANCE_STATUS] [nvarchar](10) NOT NULL,
	[PAD_STR] [nvarchar](40) NULL,
	[SLURRY_STR] [nvarchar](40) NULL,
	[MONTH_QUANTITY] [numeric](30, 6) NOT NULL,
	[CURRENT_DD] [nvarchar](80) NULL,
	[EFFECT_STR] [nvarchar](200) NULL,
	[KEYWORD] [nvarchar](200) NULL,
	[REMARK] [nvarchar](200) NULL,
	[AUTHORITY_LEVEL] [nvarchar](10) NOT NULL,
	[INSERT_DB_USER] [nvarchar](20) NOT NULL,
	[INSERT_DB_TIME] [smalldatetime] NOT NULL,
	[UPDATE_DB_USER] [nvarchar](20) NOT NULL,
	[UPDATE_DB_TIME] [smalldatetime] NOT NULL,
	[TEMPC_01] [nvarchar](30) NULL,
	[TEMPC_02] [nvarchar](30) NULL,
	[TEMPC_03] [nvarchar](30) NULL,
	[TEMPN_01] [numeric](30, 6) NULL,
	[TEMPN_02] [numeric](30, 6) NULL,
	[TEMPN_03] [numeric](30, 6) NULL,
 CONSTRAINT [CMB200T_IDX00] PRIMARY KEY CLUSTERED 
(
	[COMP_CODE] ASC,
	[PROJECT_NO] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [uniLITE].[CMB200T] ADD  DEFAULT ('MASTER') FOR [COMP_CODE]
GO

ALTER TABLE [uniLITE].[CMB200T] ADD  DEFAULT ('') FOR [UPDATE_EMP]
GO

ALTER TABLE [uniLITE].[CMB200T] ADD  DEFAULT ('2') FOR [PROJECT_OPT]
GO

ALTER TABLE [uniLITE].[CMB200T] ADD  DEFAULT ('00') FOR [PROCESS_TYPE]
GO

ALTER TABLE [uniLITE].[CMB200T] ADD  DEFAULT ((0.0)) FOR [MONTH_QUANTITY]
GO

ALTER TABLE [uniLITE].[CMB200T] ADD  DEFAULT ('uniLITE') FOR [INSERT_DB_USER]
GO

ALTER TABLE [uniLITE].[CMB200T] ADD  DEFAULT (getdate()) FOR [INSERT_DB_TIME]
GO

ALTER TABLE [uniLITE].[CMB200T] ADD  DEFAULT ('uniLITE') FOR [UPDATE_DB_USER]
GO

ALTER TABLE [uniLITE].[CMB200T] ADD  DEFAULT (getdate()) FOR [UPDATE_DB_TIME]
GO

ALTER TABLE [uniLITE].[CMB200T] ADD  DEFAULT ((0)) FOR [TEMPN_01]
GO

ALTER TABLE [uniLITE].[CMB200T] ADD  DEFAULT ((0)) FOR [TEMPN_02]
GO

ALTER TABLE [uniLITE].[CMB200T] ADD  DEFAULT ((0)) FOR [TEMPN_03]
GO

--------------------------------------


USE [UNILITE5]
GO

/****** Object:  Table [uniLITE].[CMB201T]    Script Date: 18-Dec-2013 10:11:05 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [uniLITE].[CMB201T](
	[COMP_CODE] [nvarchar](8) NOT NULL,
	[UPDATE_DATETIME] [nvarchar](20) NOT NULL,
	[PROJECT_NO] [nvarchar](20) NOT NULL,
	[UPDATE_EMP] [nvarchar](10) NOT NULL,
	[PROJECT_NAME] [nvarchar](40) NOT NULL,
	[PROJECT_OPT] [nvarchar](10) NOT NULL,
	[START_DATE] [nvarchar](10) NOT NULL,
	[TARGET_DATE] [nvarchar](10) NOT NULL,
	[PROJECT_TYPE] [nvarchar](10) NOT NULL,
	[CLASS_LEVEL1] [nvarchar](10) NOT NULL,
	[CLASS_LEVEL2] [nvarchar](10) NOT NULL,
	[SALE_EMP] [nvarchar](10) NOT NULL,
	[DEVELOP_EMP] [nvarchar](10) NULL,
	[NATION_CODE] [nvarchar](3) NULL,
	[CUSTOM_CODE] [nvarchar](20) NOT NULL,
	[DVRY_CUST_SEQ] [nvarchar](10) NOT NULL,
	[PROCESS_TYPE] [nvarchar](20) NOT NULL,
	[IMPORTANCE_STATUS] [nvarchar](10) NOT NULL,
	[PAD_STR] [nvarchar](40) NULL,
	[SLURRY_STR] [nvarchar](40) NULL,
	[MONTH_QUANTITY] [numeric](30, 6) NOT NULL,
	[CURRENT_DD] [nvarchar](80) NULL,
	[EFFECT_STR] [nvarchar](200) NULL,
	[KEYWORD] [nvarchar](200) NULL,
	[REMARK] [nvarchar](200) NULL,
	[AUTHORITY_LEVEL] [nvarchar](10) NOT NULL,
	[INSERT_DB_USER] [nvarchar](20) NOT NULL,
	[INSERT_DB_TIME] [smalldatetime] NOT NULL,
	[UPDATE_DB_USER] [nvarchar](20) NOT NULL,
	[UPDATE_DB_TIME] [smalldatetime] NOT NULL,
	[TEMPC_01] [nvarchar](30) NULL,
	[TEMPC_02] [nvarchar](30) NULL,
	[TEMPC_03] [nvarchar](30) NULL,
	[TEMPN_01] [numeric](30, 6) NULL,
	[TEMPN_02] [numeric](30, 6) NULL,
	[TEMPN_03] [numeric](30, 6) NULL,
 CONSTRAINT [CMB201T_IDX00] PRIMARY KEY NONCLUSTERED 
(
	[COMP_CODE] ASC,
	[UPDATE_DATETIME] ASC,
	[PROJECT_NO] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [uniLITE].[CMB201T] ADD  DEFAULT ('MASTER') FOR [COMP_CODE]
GO

ALTER TABLE [uniLITE].[CMB201T] ADD  DEFAULT ('') FOR [UPDATE_DATETIME]
GO

ALTER TABLE [uniLITE].[CMB201T] ADD  DEFAULT ('00') FOR [PROCESS_TYPE]
GO

ALTER TABLE [uniLITE].[CMB201T] ADD  DEFAULT ((0.0)) FOR [MONTH_QUANTITY]
GO

ALTER TABLE [uniLITE].[CMB201T] ADD  DEFAULT ('uniLITE') FOR [INSERT_DB_USER]
GO

ALTER TABLE [uniLITE].[CMB201T] ADD  DEFAULT (getdate()) FOR [INSERT_DB_TIME]
GO

ALTER TABLE [uniLITE].[CMB201T] ADD  DEFAULT ('uniLITE') FOR [UPDATE_DB_USER]
GO

ALTER TABLE [uniLITE].[CMB201T] ADD  DEFAULT (getdate()) FOR [UPDATE_DB_TIME]
GO

ALTER TABLE [uniLITE].[CMB201T] ADD  DEFAULT ((0)) FOR [TEMPN_01]
GO

ALTER TABLE [uniLITE].[CMB201T] ADD  DEFAULT ((0)) FOR [TEMPN_02]
GO

ALTER TABLE [uniLITE].[CMB201T] ADD  DEFAULT ((0)) FOR [TEMPN_03]
GO


----------------------------------------------
USE [UNILITE5]
GO

/****** Object:  Table [uniLITE].[CMD100T]    Script Date: 18-Dec-2013 10:13:21 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [uniLITE].[CMD100T](
	[COMP_CODE] [nvarchar](8) NOT NULL,
	[DOC_NO] [nvarchar](20) NOT NULL,
	[PLAN_CLIENT] [numeric](20, 0) NULL,
	[PLAN_DATE] [nvarchar](10) NULL,
	[PLAN_END_DATE] [nvarchar](10) NULL,
	[PLAN_TARGET] [nvarchar](100) NULL,
	[PLAN_GROUP_YN] [nvarchar](1) NULL,
	[RESULT_CLIENT] [numeric](20, 0) NOT NULL,
	[RESULT_DATE] [nvarchar](10) NOT NULL,
	[CUSTOM_CODE] [nvarchar](20) NOT NULL,
	[DVRY_CUST_SEQ] [nvarchar](10) NOT NULL,
	[PROCESS_TYPE] [nvarchar](10) NOT NULL,
	[PROJECT_NO] [nvarchar](20) NOT NULL,
	[SALE_EMP] [nvarchar](10) NOT NULL,
	[SALE_ATTEND] [nvarchar](100) NULL,
	[SUMMARY_STR] [nvarchar](200) NULL,
	[CONTENT_STR] [nvarchar](1000) NULL,
	[REQ_STR] [nvarchar](50) NULL,
	[OPINION_STR] [nvarchar](200) NULL,
	[SALE_TYPE] [nvarchar](2) NOT NULL,
	[ETC_CLIENT] [nvarchar](50) NULL,
	[IMPORTANCE_STATUS] [nvarchar](10) NULL,
	[KEYWORD] [nvarchar](200) NULL,
	[REMARK] [nvarchar](1000) NULL,
	[FILE_NO] [nvarchar](20) NULL,
	[CREATE_EMP] [nvarchar](10) NOT NULL,
	[UPDATE_EMP] [nvarchar](10) NOT NULL,
	[AUTHORITY_LEVEL] [nvarchar](10) NOT NULL,
	[INSERT_DB_USER] [nvarchar](20) NOT NULL,
	[INSERT_DB_TIME] [smalldatetime] NOT NULL,
	[UPDATE_DB_USER] [nvarchar](20) NOT NULL,
	[UPDATE_DB_TIME] [smalldatetime] NOT NULL,
	[TEMPC_01] [nvarchar](30) NULL,
	[TEMPC_02] [nvarchar](30) NULL,
	[TEMPC_03] [nvarchar](30) NULL,
	[TEMPN_01] [numeric](30, 6) NULL,
	[TEMPN_02] [numeric](30, 6) NULL,
	[TEMPN_03] [numeric](30, 6) NULL,
	[RESULT_TIME] [nvarchar](8) NULL,
	[SALE_STATUS] [nvarchar](2) NOT NULL,
	[OPINION_STR2] [nvarchar](200) NULL,
	[OPINION_STR3] [nvarchar](200) NULL,
	[WRITE_EMP1] [nvarchar](20) NULL,
	[WRITE_EMP2] [nvarchar](20) NULL,
	[WRITE_EMP3] [nvarchar](20) NULL,
	[PLAN_TIME] [nvarchar](8) NULL,
 CONSTRAINT [CMD100T_IDX00] PRIMARY KEY CLUSTERED 
(
	[COMP_CODE] ASC,
	[DOC_NO] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [uniLITE].[CMD100T] ADD  DEFAULT ('MASTER') FOR [COMP_CODE]
GO

ALTER TABLE [uniLITE].[CMD100T] ADD  DEFAULT ('N') FOR [PLAN_GROUP_YN]
GO

ALTER TABLE [uniLITE].[CMD100T] ADD  DEFAULT ((0)) FOR [RESULT_CLIENT]
GO

ALTER TABLE [uniLITE].[CMD100T] ADD  DEFAULT ('') FOR [RESULT_DATE]
GO

ALTER TABLE [uniLITE].[CMD100T] ADD  DEFAULT ('') FOR [CUSTOM_CODE]
GO

ALTER TABLE [uniLITE].[CMD100T] ADD  DEFAULT ('') FOR [DVRY_CUST_SEQ]
GO

ALTER TABLE [uniLITE].[CMD100T] ADD  DEFAULT ('') FOR [PROCESS_TYPE]
GO

ALTER TABLE [uniLITE].[CMD100T] ADD  DEFAULT ('') FOR [PROJECT_NO]
GO

ALTER TABLE [uniLITE].[CMD100T] ADD  DEFAULT ('') FOR [SALE_EMP]
GO

ALTER TABLE [uniLITE].[CMD100T] ADD  DEFAULT ('S1') FOR [SALE_TYPE]
GO

ALTER TABLE [uniLITE].[CMD100T] ADD  DEFAULT ('uniLITE') FOR [INSERT_DB_USER]
GO

ALTER TABLE [uniLITE].[CMD100T] ADD  DEFAULT (getdate()) FOR [INSERT_DB_TIME]
GO

ALTER TABLE [uniLITE].[CMD100T] ADD  DEFAULT ('uniLITE') FOR [UPDATE_DB_USER]
GO

ALTER TABLE [uniLITE].[CMD100T] ADD  DEFAULT (getdate()) FOR [UPDATE_DB_TIME]
GO

ALTER TABLE [uniLITE].[CMD100T] ADD  DEFAULT ((0)) FOR [TEMPN_01]
GO

ALTER TABLE [uniLITE].[CMD100T] ADD  DEFAULT ((0)) FOR [TEMPN_02]
GO

ALTER TABLE [uniLITE].[CMD100T] ADD  DEFAULT ((0)) FOR [TEMPN_03]
GO

ALTER TABLE [uniLITE].[CMD100T] ADD  DEFAULT ('') FOR [SALE_STATUS]
GO

