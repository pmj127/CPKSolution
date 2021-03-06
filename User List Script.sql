USE [CPKSolution]
GO
/****** Object:  StoredProcedure [CPK].[uspUserList]    Script Date: 2017-03-28 11:03:17 AM ******/
DROP PROCEDURE [CPK].[uspUserList]
GO
/****** Object:  StoredProcedure [CPK].[uspUserList]    Script Date: 2017-03-28 11:03:17 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Soochang Kim>
-- Create date: <March 25, 2017>
-- Description:	<>
-- =============================================
CREATE PROCEDURE [CPK].[uspUserList] 
	@PageNo INT = 1,
	@PageSize INT = 10,
	@FullName NVARCHAR(50)
AS
BEGIN
	SET NOCOUNT ON;

    SELECT COUNT(*) AS TotalRows, @PageNo AS PageNo, @PageSize AS PageSize
	FROM [CPK].[Users]
	WHERE (FullName LIKE '%'+@FullName+'%' OR @FullName IS NULL OR LEN(@FullName) = 0);

	SELECT UserID, FullName, Status, FORMAT(ModifyDate, 'MMM dd yyyy') AS ModifyDate
	FROM [CPK].[Users]
	WHERE (FullName LIKE '%'+@FullName+'%' OR @FullName IS NULL OR LEN(@FullName) = 0)
	ORDER BY UserID DESC
		OFFSET(@PageNo - 1) * @PageSize ROWS FETCH NEXT @PageSize ROWS ONLY
	OPTION (OPTIMIZE FOR(@PageNo = 1, @PageSize = 10));
END

GO
