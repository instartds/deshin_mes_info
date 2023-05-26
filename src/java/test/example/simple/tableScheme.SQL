USE [tlab]
GO

/****** Object:  Table [dbo].[EX_BOOK_INFO]    Script Date: 1/28/2013 12:12:48 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[EX_BOOK_INFO](
	[isbn] [nchar](50) NOT NULL,
	[book_name] [nchar](50) NULL,
	[writer] [nchar](50) NULL,
	[price] [money] NULL,
	[reg_date] [date] NULL,
 CONSTRAINT [PK_EX_BOOK_INFO] PRIMARY KEY CLUSTERED 
(
	[isbn] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

