USE [hsvsor2f_ticket]
GO
/****** Object:  Table [ticket].[Tickets]    Script Date: 24-07-2025 13:54:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ticket].[Tickets](
	[TicketID] [int] IDENTITY(1,1) NOT NULL,
	[RaisedByUserName] [nvarchar](100) NULL,
	[RaisedByUserEmail] [nvarchar](100) NULL,
	[TicketType] [nvarchar](50) NULL,
	[Status] [nvarchar](50) NULL,
	[CreatedDate] [datetime] NULL,
	[DeliveryDate] [datetime] NULL,
	[Assigned] [bit] NULL,
	[AssignedToUserID] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[TicketID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [ticket].[Users]    Script Date: 24-07-2025 13:54:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ticket].[Users](
	[UserID] [int] IDENTITY(1,1) NOT NULL,
	[UserName] [nvarchar](100) NOT NULL,
	[Email] [nvarchar](150) NOT NULL,
	[PasswordHash] [nvarchar](255) NOT NULL,
	[Role] [nvarchar](50) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[UserID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [ticket].[Tickets] ON 

INSERT [ticket].[Tickets] ([TicketID], [RaisedByUserName], [RaisedByUserEmail], [TicketType], [Status], [CreatedDate], [DeliveryDate], [Assigned], [AssignedToUserID]) VALUES (1, N'khushbu', N'test@gmail.com', N'Admin Issue', N'Open', CAST(N'2025-07-24T06:53:34.273' AS DateTime), CAST(N'2025-07-31T00:00:00.000' AS DateTime), 1, 8)
INSERT [ticket].[Tickets] ([TicketID], [RaisedByUserName], [RaisedByUserEmail], [TicketType], [Status], [CreatedDate], [DeliveryDate], [Assigned], [AssignedToUserID]) VALUES (2, N'test', N'test@gmail.com', N'Billing Issue', N'Closed', CAST(N'2025-07-24T06:54:30.813' AS DateTime), CAST(N'2025-07-31T00:00:00.000' AS DateTime), 1, 8)
INSERT [ticket].[Tickets] ([TicketID], [RaisedByUserName], [RaisedByUserEmail], [TicketType], [Status], [CreatedDate], [DeliveryDate], [Assigned], [AssignedToUserID]) VALUES (3, N'Isha', N'abc@example.com', N'Technical Issue', N'Work-in-progress', CAST(N'2025-07-24T06:54:40.897' AS DateTime), NULL, 0, NULL)
INSERT [ticket].[Tickets] ([TicketID], [RaisedByUserName], [RaisedByUserEmail], [TicketType], [Status], [CreatedDate], [DeliveryDate], [Assigned], [AssignedToUserID]) VALUES (4, N'Sahil', N'Sahil@gmail.com', N'Technical Issue', N'Resolved', CAST(N'2025-07-24T06:54:55.937' AS DateTime), NULL, 0, NULL)
INSERT [ticket].[Tickets] ([TicketID], [RaisedByUserName], [RaisedByUserEmail], [TicketType], [Status], [CreatedDate], [DeliveryDate], [Assigned], [AssignedToUserID]) VALUES (5, N'Khushbu', N'abc@example.com', N'Admin Issue', N'Open', CAST(N'2025-07-24T06:55:06.703' AS DateTime), CAST(N'2025-07-31T00:00:00.000' AS DateTime), 1, 9)
INSERT [ticket].[Tickets] ([TicketID], [RaisedByUserName], [RaisedByUserEmail], [TicketType], [Status], [CreatedDate], [DeliveryDate], [Assigned], [AssignedToUserID]) VALUES (6, N'khush', N'sawkhushbu55@gmail.com', N'Admin Issue', N'Closed', CAST(N'2025-07-24T06:55:17.827' AS DateTime), NULL, 0, NULL)
INSERT [ticket].[Tickets] ([TicketID], [RaisedByUserName], [RaisedByUserEmail], [TicketType], [Status], [CreatedDate], [DeliveryDate], [Assigned], [AssignedToUserID]) VALUES (7, N'Isha', N'abc@example.com', N'Billing Issue', N'Resolved', CAST(N'2025-07-24T06:55:27.200' AS DateTime), NULL, 0, NULL)
INSERT [ticket].[Tickets] ([TicketID], [RaisedByUserName], [RaisedByUserEmail], [TicketType], [Status], [CreatedDate], [DeliveryDate], [Assigned], [AssignedToUserID]) VALUES (8, N'khushbu', N'test@gmail.com', N'Admin Issue', N'Open', CAST(N'2025-07-24T07:31:02.817' AS DateTime), NULL, 0, NULL)
SET IDENTITY_INSERT [ticket].[Tickets] OFF
GO
SET IDENTITY_INSERT [ticket].[Users] ON 

INSERT [ticket].[Users] ([UserID], [UserName], [Email], [PasswordHash], [Role]) VALUES (7, N'Khushbu', N'khushbusaw76@gmail.com', N'test123', N'admin')
INSERT [ticket].[Users] ([UserID], [UserName], [Email], [PasswordHash], [Role]) VALUES (8, N'Sahil', N'sawkhushbu55@gmail.com', N'abc123', N'user')
INSERT [ticket].[Users] ([UserID], [UserName], [Email], [PasswordHash], [Role]) VALUES (9, N'test', N'test@gmail.com', N'test123', N'user')
INSERT [ticket].[Users] ([UserID], [UserName], [Email], [PasswordHash], [Role]) VALUES (10, N'xyz', N'xyz@gmail.com', N'xyz123', N'user')
INSERT [ticket].[Users] ([UserID], [UserName], [Email], [PasswordHash], [Role]) VALUES (11, N'Isha', N'isha@gmail.com', N'isha123', N'user')
SET IDENTITY_INSERT [ticket].[Users] OFF
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__Users__A9D10534C64DD64E]    Script Date: 24-07-2025 13:54:14 ******/
ALTER TABLE [ticket].[Users] ADD UNIQUE NONCLUSTERED 
(
	[Email] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [ticket].[Tickets] ADD  DEFAULT ('Open') FOR [Status]
GO
ALTER TABLE [ticket].[Tickets] ADD  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [ticket].[Tickets] ADD  DEFAULT ((0)) FOR [Assigned]
GO
ALTER TABLE [ticket].[Tickets]  WITH CHECK ADD  CONSTRAINT [FK_Tickets_Users] FOREIGN KEY([AssignedToUserID])
REFERENCES [ticket].[Users] ([UserID])
GO
ALTER TABLE [ticket].[Tickets] CHECK CONSTRAINT [FK_Tickets_Users]
GO
