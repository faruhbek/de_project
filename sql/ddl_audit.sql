CREATE TABLE [dbo].[FileCopyAudit] (
    AuditID              INT IDENTITY(1,1) PRIMARY KEY,
    FileName             NVARCHAR(200),
    FilePath             NVARCHAR(500),
    SourceURL            NVARCHAR(1000),
    DestinationPath      NVARCHAR(1000),
    FileSHA              NVARCHAR(100),
    FileSizeBytes        BIGINT,
    DataReadBytes        BIGINT,
    DataWrittenBytes     BIGINT,
    FilesRead            INT,
    FilesWritten         INT,
    ThroughputMBps       FLOAT,
    CopyDurationSec      INT,
    Status               NVARCHAR(50),
    ErrorMessage         NVARCHAR(MAX),
    IntegrationRuntime   NVARCHAR(200),
    DIUsUsed             INT,
    PipelineRunID        NVARCHAR(100),
    ActivityName         NVARCHAR(200),
    StartTimeUTC         DATETIME,
    InsertedOnUTC        DATETIME DEFAULT GETUTCDATE()
);








CREATE PROCEDURE [dbo].[InsertFileCopyAudit]
    @FileName            NVARCHAR(200),
    @FilePath            NVARCHAR(500),
    @SourceURL           NVARCHAR(1000),
    @DestinationPath     NVARCHAR(1000),
    @FileSHA             NVARCHAR(100),
    @FileSizeBytes       BIGINT,
    @DataReadBytes       BIGINT,
    @DataWrittenBytes    BIGINT,
    @FilesRead           INT,
    @FilesWritten        INT,
    @ThroughputMBps      FLOAT,
    @CopyDurationSec     INT,
    @Status              NVARCHAR(50),
    @ErrorMessage        NVARCHAR(MAX),
    @IntegrationRuntime  NVARCHAR(200),
    @DIUsUsed            INT,
    @PipelineRunID       NVARCHAR(100),
    @ActivityName        NVARCHAR(200),
    @StartTimeUTC        DATETIME
AS
BEGIN
    MERGE INTO [dbo].[FileCopyAudit] AS target
    USING (SELECT @FileName AS FileName, @ActivityName AS ActivityName) AS source
    ON target.FileName = source.FileName and target.ActivityName = source.ActivityName
    WHEN MATCHED THEN
        UPDATE SET
            FilePath = @FilePath,
            SourceURL = @SourceURL,
            DestinationPath = @DestinationPath,
            FileSHA = @FileSHA,
            FileSizeBytes = @FileSizeBytes,
            DataReadBytes = @DataReadBytes,
            DataWrittenBytes = @DataWrittenBytes,
            FilesRead = @FilesRead,
            FilesWritten = @FilesWritten,
            ThroughputMBps = @ThroughputMBps,
            CopyDurationSec = @CopyDurationSec,
            Status = @Status,
            ErrorMessage = @ErrorMessage,
            IntegrationRuntime = @IntegrationRuntime,
            DIUsUsed = @DIUsUsed,
            PipelineRunID = @PipelineRunID,
            ActivityName = @ActivityName,
            StartTimeUTC = @StartTimeUTC,
            InsertedOnUTC = GETUTCDATE()
    WHEN NOT MATCHED THEN
        INSERT (
            FileName, FilePath, SourceURL, DestinationPath, FileSHA, FileSizeBytes,
            DataReadBytes, DataWrittenBytes, FilesRead, FilesWritten, ThroughputMBps,
            CopyDurationSec, Status, ErrorMessage, IntegrationRuntime, DIUsUsed,
            PipelineRunID, ActivityName, StartTimeUTC, InsertedOnUTC
        )
        VALUES (
            @FileName, @FilePath, @SourceURL, @DestinationPath, @FileSHA, @FileSizeBytes,
            @DataReadBytes, @DataWrittenBytes, @FilesRead, @FilesWritten, @ThroughputMBps,
            @CopyDurationSec, @Status, @ErrorMessage, @IntegrationRuntime, @DIUsUsed,
            @PipelineRunID, @ActivityName, @StartTimeUTC, GETUTCDATE()
        );
END



CREATE PROCEDURE [dbo].[InsertFileCopyFailureAudit]
    @FileName           NVARCHAR(200),
    @FilePath           NVARCHAR(500),
    @SourceURL          NVARCHAR(1000),
    @DestinationPath    NVARCHAR(1000),
    @FileSHA            NVARCHAR(100),
    @FileSizeBytes      BIGINT = NULL,
    @Status             NVARCHAR(50),
    @ErrorMessage       NVARCHAR(MAX),
    @IntegrationRuntime NVARCHAR(200) = NULL,
    @PipelineRunID      NVARCHAR(100),
    @ActivityName       NVARCHAR(200),
    @StartTimeUTC       DATETIME
AS
BEGIN
    MERGE INTO [dbo].[FileCopyAudit] AS target
    USING (SELECT @FileName AS FileName, @ActivityName AS ActivityName) AS source
    ON target.FileName = source.FileName and target.ActivityName = source.ActivityName
    WHEN MATCHED THEN
        UPDATE SET
            FilePath = @FilePath,
            SourceURL = @SourceURL,
            DestinationPath = @DestinationPath,
            FileSHA = @FileSHA,
            FileSizeBytes = @FileSizeBytes,
            Status = @Status,
            ErrorMessage = @ErrorMessage,
            IntegrationRuntime = @IntegrationRuntime,
            PipelineRunID = @PipelineRunID,
            ActivityName = @ActivityName,
            StartTimeUTC = @StartTimeUTC,
            InsertedOnUTC = GETUTCDATE()
    WHEN NOT MATCHED THEN
        INSERT (
            FileName, FilePath, SourceURL, DestinationPath, FileSHA, FileSizeBytes,
            Status, ErrorMessage, IntegrationRuntime, PipelineRunID, ActivityName,
            StartTimeUTC, InsertedOnUTC
        )
        VALUES (
            @FileName, @FilePath, @SourceURL, @DestinationPath, @FileSHA, @FileSizeBytes,
            @Status, @ErrorMessage, @IntegrationRuntime, @PipelineRunID, @ActivityName,
            @StartTimeUTC, GETUTCDATE()
        );
END
