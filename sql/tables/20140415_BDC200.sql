/**
 * 외부사용자용 파일 다운 로더 
 */
/****** Object:  Table [uniLITE].[BDC200T]    Script Date: 04/15/2014 18:02:17 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [uniLITE].[BDC200T](
	[REF_ID] [nvarchar](50) NOT NULL,
	[COMP_CODE] [nvarchar](8) NOT NULL,
	[DOC_NO] [nvarchar](50) NOT NULL,
	[READCNT] [int] NOT NULL,
	[EXPIRE_DATE] [smalldatetime] NOT NULL,
	[INSERT_DB_USER] [nvarchar](20) NOT NULL,
	[INSERT_DB_TIME] [smalldatetime] NOT NULL,
 CONSTRAINT [PK_BDC200T] PRIMARY KEY CLUSTERED 
(
	[REF_ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [uniLITE].[BDC200T] ADD  DEFAULT ((0)) FOR [READCNT]
GO
