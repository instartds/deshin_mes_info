USE [UNILITE5_FOREN]
GO

/****** Object:  Table [uniLITE].[BZSA200T]    Script Date: 18-Sep-2013 2:00:22 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/** ExtJS State Provider */

CREATE TABLE [uniLITE].[BZSA200T](
	[COMP_CODE] [nvarchar](8) NOT NULL DEFAULT 'MASTER',  /* �����ڵ�                                */
	[USER_ID] [nvarchar](10) NOT NULL,
	[OBJECT_ID] [nvarchar](50) NOT NULL,
	[STATE] [text] NULL,
	[UPDATE_DB_TIME] [smalldatetime] NOT NULL DEFAULT GETDATE() ,     /* ������                                     */
 CONSTRAINT [PK_BZSA200T] PRIMARY KEY CLUSTERED 
(
	[COMP_CODE] ASC,
	[USER_ID] ASC,
	[OBJECT_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO

