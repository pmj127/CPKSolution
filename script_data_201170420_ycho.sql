USE [CPKSolution]
GO

delete [CPK].[ChildGroup];
delete [CPK].[Group];
delete [CPK].[ReportGroup];
delete [CPK].[UserGroup];

INSERT [CPK].[ChildGroup] ([GroupID], [ChildGroupID]) VALUES (1, 4)
INSERT [CPK].[ChildGroup] ([GroupID], [ChildGroupID]) VALUES (1, 6)
INSERT [CPK].[ChildGroup] ([GroupID], [ChildGroupID]) VALUES (1, 11)
INSERT [CPK].[ChildGroup] ([GroupID], [ChildGroupID]) VALUES (1, 17)
INSERT [CPK].[ChildGroup] ([GroupID], [ChildGroupID]) VALUES (1, 24)
INSERT [CPK].[ChildGroup] ([GroupID], [ChildGroupID]) VALUES (1, 26)
INSERT [CPK].[ChildGroup] ([GroupID], [ChildGroupID]) VALUES (1, 29)
INSERT [CPK].[ChildGroup] ([GroupID], [ChildGroupID]) VALUES (4, 5)
INSERT [CPK].[ChildGroup] ([GroupID], [ChildGroupID]) VALUES (6, 7)
INSERT [CPK].[ChildGroup] ([GroupID], [ChildGroupID]) VALUES (7, 8)
INSERT [CPK].[ChildGroup] ([GroupID], [ChildGroupID]) VALUES (7, 9)
INSERT [CPK].[ChildGroup] ([GroupID], [ChildGroupID]) VALUES (7, 10)
INSERT [CPK].[ChildGroup] ([GroupID], [ChildGroupID]) VALUES (11, 12)
INSERT [CPK].[ChildGroup] ([GroupID], [ChildGroupID]) VALUES (11, 13)
INSERT [CPK].[ChildGroup] ([GroupID], [ChildGroupID]) VALUES (11, 14)
INSERT [CPK].[ChildGroup] ([GroupID], [ChildGroupID]) VALUES (11, 15)
INSERT [CPK].[ChildGroup] ([GroupID], [ChildGroupID]) VALUES (11, 16)
INSERT [CPK].[ChildGroup] ([GroupID], [ChildGroupID]) VALUES (17, 18)
INSERT [CPK].[ChildGroup] ([GroupID], [ChildGroupID]) VALUES (17, 22)
INSERT [CPK].[ChildGroup] ([GroupID], [ChildGroupID]) VALUES (17, 23)
INSERT [CPK].[ChildGroup] ([GroupID], [ChildGroupID]) VALUES (18, 19)
INSERT [CPK].[ChildGroup] ([GroupID], [ChildGroupID]) VALUES (18, 20)
INSERT [CPK].[ChildGroup] ([GroupID], [ChildGroupID]) VALUES (18, 21)
INSERT [CPK].[ChildGroup] ([GroupID], [ChildGroupID]) VALUES (24, 25)
INSERT [CPK].[ChildGroup] ([GroupID], [ChildGroupID]) VALUES (26, 27)
INSERT [CPK].[ChildGroup] ([GroupID], [ChildGroupID]) VALUES (26, 28)
INSERT [CPK].[ChildGroup] ([GroupID], [ChildGroupID]) VALUES (29, 30)
INSERT [CPK].[ChildGroup] ([GroupID], [ChildGroupID]) VALUES (30, 31)
INSERT [CPK].[ChildGroup] ([GroupID], [ChildGroupID]) VALUES (30, 32)
INSERT [CPK].[Group] ([GroupID], [GroupName], [Description], [IsActive], [ModifyDate]) VALUES (1, N'Employee', N'Employee', N'TRUE', CAST(N'2017-04-01 12:12:00.000' AS DateTime))
INSERT [CPK].[Group] ([GroupID], [GroupName], [Description], [IsActive], [ModifyDate]) VALUES (2, N'Vendors', N'Vendors', N'TRUE', CAST(N'2017-04-02 12:12:00.000' AS DateTime))
INSERT [CPK].[Group] ([GroupID], [GroupName], [Description], [IsActive], [ModifyDate]) VALUES (3, N'Customers', N'Customers', N'TRUE', CAST(N'2017-04-03 12:12:00.000' AS DateTime))
INSERT [CPK].[Group] ([GroupID], [GroupName], [Description], [IsActive], [ModifyDate]) VALUES (4, N'Sales Dept', N'Sales Dept', N'TRUE', CAST(N'2017-04-01 12:12:00.000' AS DateTime))
INSERT [CPK].[Group] ([GroupID], [GroupName], [Description], [IsActive], [ModifyDate]) VALUES (5, N'Sales Section', N'Sales Section', N'TRUE', CAST(N'2017-04-02 12:12:00.000' AS DateTime))
INSERT [CPK].[Group] ([GroupID], [GroupName], [Description], [IsActive], [ModifyDate]) VALUES (6, N'Quality Control Dept', N'Quality Control Dept', N'TRUE', CAST(N'2017-04-03 12:12:00.000' AS DateTime))
INSERT [CPK].[Group] ([GroupID], [GroupName], [Description], [IsActive], [ModifyDate]) VALUES (7, N'Quality Control Section', N'Quality Control Section', N'TRUE', CAST(N'2017-04-04 12:12:00.000' AS DateTime))
INSERT [CPK].[Group] ([GroupID], [GroupName], [Description], [IsActive], [ModifyDate]) VALUES (8, N'Quality Engineering', N'Quality Engineering', N'TRUE', CAST(N'2017-04-05 12:12:00.000' AS DateTime))
INSERT [CPK].[Group] ([GroupID], [GroupName], [Description], [IsActive], [ModifyDate]) VALUES (9, N'Manufacturing Process', N'Manufacturing Process', N'TRUE', CAST(N'2017-04-06 12:12:00.000' AS DateTime))
INSERT [CPK].[Group] ([GroupID], [GroupName], [Description], [IsActive], [ModifyDate]) VALUES (10, N'Torsion Testing', N'Torsion Testing', N'TRUE', CAST(N'2017-04-07 12:12:00.000' AS DateTime))
INSERT [CPK].[Group] ([GroupID], [GroupName], [Description], [IsActive], [ModifyDate]) VALUES (11, N'Administration Dept', N'Administration Dept', N'TRUE', CAST(N'2017-04-08 12:12:00.000' AS DateTime))
INSERT [CPK].[Group] ([GroupID], [GroupName], [Description], [IsActive], [ModifyDate]) VALUES (12, N'Document Control Center', N'Document Control Center', N'TRUE', CAST(N'2017-04-09 12:12:00.000' AS DateTime))
INSERT [CPK].[Group] ([GroupID], [GroupName], [Description], [IsActive], [ModifyDate]) VALUES (13, N'General Affairs', N'General Affairs', N'TRUE', CAST(N'2017-04-10 12:12:00.000' AS DateTime))
INSERT [CPK].[Group] ([GroupID], [GroupName], [Description], [IsActive], [ModifyDate]) VALUES (14, N'Personnel', N'Personnel', N'TRUE', CAST(N'2017-04-11 12:12:00.000' AS DateTime))
INSERT [CPK].[Group] ([GroupID], [GroupName], [Description], [IsActive], [ModifyDate]) VALUES (15, N'Business', N'Business', N'TRUE', CAST(N'2017-04-12 12:12:00.000' AS DateTime))
INSERT [CPK].[Group] ([GroupID], [GroupName], [Description], [IsActive], [ModifyDate]) VALUES (16, N'Financial Affairs', N'Financial Affairs', N'TRUE', CAST(N'2017-04-13 12:12:00.000' AS DateTime))
INSERT [CPK].[Group] ([GroupID], [GroupName], [Description], [IsActive], [ModifyDate]) VALUES (17, N'Material Dept', N'Material Dept', N'TRUE', CAST(N'2017-04-14 12:12:00.000' AS DateTime))
INSERT [CPK].[Group] ([GroupID], [GroupName], [Description], [IsActive], [ModifyDate]) VALUES (18, N'Business Managemnt Section', N'Business Managemnt Section', N'TRUE', CAST(N'2017-04-15 12:12:00.000' AS DateTime))
INSERT [CPK].[Group] ([GroupID], [GroupName], [Description], [IsActive], [ModifyDate]) VALUES (19, N'Steel Materials', N'Steel Materials', N'TRUE', CAST(N'2017-04-16 12:12:00.000' AS DateTime))
INSERT [CPK].[Group] ([GroupID], [GroupName], [Description], [IsActive], [ModifyDate]) VALUES (20, N'Finished Products', N'Finished Products', N'TRUE', CAST(N'2017-04-17 12:12:00.000' AS DateTime))
INSERT [CPK].[Group] ([GroupID], [GroupName], [Description], [IsActive], [ModifyDate]) VALUES (21, N'Semi-Finished Products', N'Semi-Finished Products', N'TRUE', CAST(N'2017-04-18 12:12:00.000' AS DateTime))
INSERT [CPK].[Group] ([GroupID], [GroupName], [Description], [IsActive], [ModifyDate]) VALUES (22, N'Procurement Section', N'Procurement Section', N'TRUE', CAST(N'2017-04-19 12:12:00.000' AS DateTime))
INSERT [CPK].[Group] ([GroupID], [GroupName], [Description], [IsActive], [ModifyDate]) VALUES (23, N'Depository', N'Depository', N'TRUE', CAST(N'2017-04-20 12:12:00.000' AS DateTime))
INSERT [CPK].[Group] ([GroupID], [GroupName], [Description], [IsActive], [ModifyDate]) VALUES (24, N'R&D Dept', N'R&D Dept', N'TRUE', CAST(N'2017-04-21 12:12:00.000' AS DateTime))
INSERT [CPK].[Group] ([GroupID], [GroupName], [Description], [IsActive], [ModifyDate]) VALUES (25, N'R&D Section', N'R&D Section', N'TRUE', CAST(N'2017-04-22 12:12:00.000' AS DateTime))
INSERT [CPK].[Group] ([GroupID], [GroupName], [Description], [IsActive], [ModifyDate]) VALUES (26, N'Assembly Dept', N'Assembly Dept', N'TRUE', CAST(N'2017-04-23 12:12:00.000' AS DateTime))
INSERT [CPK].[Group] ([GroupID], [GroupName], [Description], [IsActive], [ModifyDate]) VALUES (27, N'Assembly Section', N'Assembly Section', N'TRUE', CAST(N'2017-04-24 12:12:00.000' AS DateTime))
INSERT [CPK].[Group] ([GroupID], [GroupName], [Description], [IsActive], [ModifyDate]) VALUES (28, N'Production Management', N'Production Management', N'TRUE', CAST(N'2017-04-25 12:12:00.000' AS DateTime))
INSERT [CPK].[Group] ([GroupID], [GroupName], [Description], [IsActive], [ModifyDate]) VALUES (29, N'Press Dept', N'Press Dept', N'TRUE', CAST(N'2017-04-26 12:12:00.000' AS DateTime))
INSERT [CPK].[Group] ([GroupID], [GroupName], [Description], [IsActive], [ModifyDate]) VALUES (30, N'Press Section', N'Press Section', N'TRUE', CAST(N'2017-04-27 12:12:00.000' AS DateTime))
INSERT [CPK].[Group] ([GroupID], [GroupName], [Description], [IsActive], [ModifyDate]) VALUES (31, N'Molding Maintenance', N'Molding Maintenance', N'TRUE', CAST(N'2017-04-28 12:12:00.000' AS DateTime))
INSERT [CPK].[Group] ([GroupID], [GroupName], [Description], [IsActive], [ModifyDate]) VALUES (32, N'Quality Control', N'Quality Control', N'TRUE', CAST(N'2017-04-29 12:12:00.000' AS DateTime))
INSERT [CPK].[ReportGroup] ([GroupID], [ReportID], [ModifyDate]) VALUES (2, 1, CAST(N'2017-04-20 22:36:50.187' AS DateTime))
INSERT [CPK].[ReportGroup] ([GroupID], [ReportID], [ModifyDate]) VALUES (2, 95096, CAST(N'2017-04-20 22:36:50.187' AS DateTime))
INSERT [CPK].[ReportGroup] ([GroupID], [ReportID], [ModifyDate]) VALUES (3, 1, CAST(N'2017-04-20 22:37:18.113' AS DateTime))
INSERT [CPK].[ReportGroup] ([GroupID], [ReportID], [ModifyDate]) VALUES (3, 4, CAST(N'2017-04-20 22:37:18.113' AS DateTime))
INSERT [CPK].[ReportGroup] ([GroupID], [ReportID], [ModifyDate]) VALUES (3, 95096, CAST(N'2017-04-20 22:37:18.113' AS DateTime))
INSERT [CPK].[ReportGroup] ([GroupID], [ReportID], [ModifyDate]) VALUES (4, 1, CAST(N'2017-04-11 13:02:04.957' AS DateTime))
INSERT [CPK].[ReportGroup] ([GroupID], [ReportID], [ModifyDate]) VALUES (4, 4, CAST(N'2017-04-20 15:28:08.140' AS DateTime))
INSERT [CPK].[ReportGroup] ([GroupID], [ReportID], [ModifyDate]) VALUES (4, 5, CAST(N'2017-04-11 13:02:07.470' AS DateTime))
INSERT [CPK].[ReportGroup] ([GroupID], [ReportID], [ModifyDate]) VALUES (4, 95096, CAST(N'2017-04-20 15:28:08.137' AS DateTime))
INSERT [CPK].[ReportGroup] ([GroupID], [ReportID], [ModifyDate]) VALUES (5, 1, CAST(N'2017-04-02 00:00:00.000' AS DateTime))
INSERT [CPK].[ReportGroup] ([GroupID], [ReportID], [ModifyDate]) VALUES (5, 5, CAST(N'2017-04-11 01:05:58.260' AS DateTime))
INSERT [CPK].[ReportGroup] ([GroupID], [ReportID], [ModifyDate]) VALUES (6, 1, CAST(N'2017-04-11 13:03:39.810' AS DateTime))
INSERT [CPK].[ReportGroup] ([GroupID], [ReportID], [ModifyDate]) VALUES (6, 4, CAST(N'2017-04-11 13:02:31.720' AS DateTime))
INSERT [CPK].[ReportGroup] ([GroupID], [ReportID], [ModifyDate]) VALUES (6, 5, CAST(N'2017-04-11 13:02:34.480' AS DateTime))
INSERT [CPK].[ReportGroup] ([GroupID], [ReportID], [ModifyDate]) VALUES (7, 1, CAST(N'2017-04-11 13:03:37.280' AS DateTime))
INSERT [CPK].[ReportGroup] ([GroupID], [ReportID], [ModifyDate]) VALUES (7, 4, CAST(N'2017-04-11 13:02:20.440' AS DateTime))
INSERT [CPK].[ReportGroup] ([GroupID], [ReportID], [ModifyDate]) VALUES (7, 5, CAST(N'2017-04-11 13:02:24.433' AS DateTime))
INSERT [CPK].[ReportGroup] ([GroupID], [ReportID], [ModifyDate]) VALUES (8, 4, CAST(N'2017-04-11 01:01:13.327' AS DateTime))
INSERT [CPK].[ReportGroup] ([GroupID], [ReportID], [ModifyDate]) VALUES (8, 5, CAST(N'2017-04-01 00:00:00.000' AS DateTime))
INSERT [CPK].[ReportGroup] ([GroupID], [ReportID], [ModifyDate]) VALUES (9, 1, CAST(N'2017-04-11 13:03:28.830' AS DateTime))
INSERT [CPK].[ReportGroup] ([GroupID], [ReportID], [ModifyDate]) VALUES (10, 1, CAST(N'2017-04-19 01:42:27.110' AS DateTime))
INSERT [CPK].[ReportGroup] ([GroupID], [ReportID], [ModifyDate]) VALUES (12, 5, CAST(N'2017-04-19 15:54:23.287' AS DateTime))
INSERT [CPK].[ReportGroup] ([GroupID], [ReportID], [ModifyDate]) VALUES (25, 1, CAST(N'2017-04-19 13:59:26.870' AS DateTime))
INSERT [CPK].[ReportGroup] ([GroupID], [ReportID], [ModifyDate]) VALUES (25, 4, CAST(N'2017-04-19 13:59:26.870' AS DateTime))
INSERT [CPK].[UserGroup] ([GroupID], [UserID], [modifyDate]) VALUES (2, N'CPKUser2', CAST(N'2017-04-20 22:36:39.160' AS DateTime))
INSERT [CPK].[UserGroup] ([GroupID], [UserID], [modifyDate]) VALUES (3, N'CPKUser3', CAST(N'2017-04-20 22:37:08.760' AS DateTime))
INSERT [CPK].[UserGroup] ([GroupID], [UserID], [modifyDate]) VALUES (4, N'CPKAdmin', CAST(N'2017-04-11 13:23:33.270' AS DateTime))
INSERT [CPK].[UserGroup] ([GroupID], [UserID], [modifyDate]) VALUES (4, N'CPKUser1', CAST(N'2017-04-11 13:24:04.580' AS DateTime))
INSERT [CPK].[UserGroup] ([GroupID], [UserID], [modifyDate]) VALUES (4, N'CPKUser2', CAST(N'2017-04-11 13:24:14.290' AS DateTime))
INSERT [CPK].[UserGroup] ([GroupID], [UserID], [modifyDate]) VALUES (5, N'CPKAdmin', CAST(N'2017-04-11 01:03:19.510' AS DateTime))
INSERT [CPK].[UserGroup] ([GroupID], [UserID], [modifyDate]) VALUES (5, N'CPKUser1', CAST(N'2017-04-11 01:03:32.300' AS DateTime))
INSERT [CPK].[UserGroup] ([GroupID], [UserID], [modifyDate]) VALUES (6, N'CPKAdmin', CAST(N'2017-04-11 13:23:43.923' AS DateTime))
INSERT [CPK].[UserGroup] ([GroupID], [UserID], [modifyDate]) VALUES (6, N'CPKUser2', CAST(N'2017-04-11 13:34:08.103' AS DateTime))
INSERT [CPK].[UserGroup] ([GroupID], [UserID], [modifyDate]) VALUES (6, N'CPKUser3', CAST(N'2017-04-11 13:24:33.610' AS DateTime))
INSERT [CPK].[UserGroup] ([GroupID], [UserID], [modifyDate]) VALUES (7, N'CPKAdmin', CAST(N'2017-04-11 13:23:49.400' AS DateTime))
INSERT [CPK].[UserGroup] ([GroupID], [UserID], [modifyDate]) VALUES (7, N'CPKUser2', CAST(N'2017-04-11 13:25:23.153' AS DateTime))
INSERT [CPK].[UserGroup] ([GroupID], [UserID], [modifyDate]) VALUES (7, N'CPKUser3', CAST(N'2017-04-11 13:24:22.733' AS DateTime))
INSERT [CPK].[UserGroup] ([GroupID], [UserID], [modifyDate]) VALUES (8, N'CPKAdmin', CAST(N'2017-04-11 01:03:50.683' AS DateTime))
INSERT [CPK].[UserGroup] ([GroupID], [UserID], [modifyDate]) VALUES (8, N'CPKUser3', CAST(N'2017-04-11 01:04:00.917' AS DateTime))
INSERT [CPK].[UserGroup] ([GroupID], [UserID], [modifyDate]) VALUES (9, N'CPKUser2', CAST(N'2017-04-11 13:34:28.877' AS DateTime))
INSERT [CPK].[UserGroup] ([GroupID], [UserID], [modifyDate]) VALUES (10, N'CPKUser1', CAST(N'2017-04-19 01:42:16.813' AS DateTime))
INSERT [CPK].[UserGroup] ([GroupID], [UserID], [modifyDate]) VALUES (12, N'CPKUser1', CAST(N'2017-04-19 15:56:50.453' AS DateTime))
INSERT [CPK].[UserGroup] ([GroupID], [UserID], [modifyDate]) VALUES (12, N'CPKUser3', CAST(N'2017-04-19 15:56:50.450' AS DateTime))
INSERT [CPK].[UserGroup] ([GroupID], [UserID], [modifyDate]) VALUES (25, N'CPKAdmin', CAST(N'2017-04-19 13:59:36.310' AS DateTime))
INSERT [CPK].[UserGroup] ([GroupID], [UserID], [modifyDate]) VALUES (25, N'CPKUser1', CAST(N'2017-04-19 13:59:36.310' AS DateTime))
INSERT [CPK].[UserGroup] ([GroupID], [UserID], [modifyDate]) VALUES (25, N'CPKUser3', CAST(N'2017-04-19 13:59:36.310' AS DateTime))
