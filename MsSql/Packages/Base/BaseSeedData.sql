-- =============================================
-- Author:      Mohsen Mirshahreza
-- Create date: 2026-01-08
-- Author:      Mohsen Mirshahreza
-- Description: Simple seed data - 3 records only
-- =============================================

TRUNCATE TABLE BaseUsers; 
TRUNCATE TABLE BaseRoles; 
TRUNCATE TABLE BaseInfo; 
TRUNCATE TABLE BasePersons; 

DECLARE @ActOn DATETIME = GETDATE();

-- Password: 'P@ssw0rd' (you should change this after first login)
INSERT INTO BaseUsers (CreatedBy, CreatedOn, IsBuiltIn, UserName, Email, Mobile, Password, PasswordUpdatedBy, PasswordUpdatedOn, IsActive, LoginLocked, LoginTryFailsCount)
VALUES (0, @ActOn, 1, 'admin', 'admin@system.local', '09121234567','161EBD7D45089B3446EE4E0D86DBCF92', 0, @ActOn, 1,  0, 0);
DECLARE @ActorId INT = (SELECT TOP 1 Id FROM BaseUsers ORDER BY Id);
UPDATE BaseUsers SET CreatedBy=@ActorId;

INSERT INTO BaseRoles (CreatedBy, CreatedOn, RoleName, IsActive, Note, IsBuiltIn)
VALUES (@ActorId, @ActOn, 'Developer', 1, 'Full access', 1);

INSERT INTO BaseRoles (CreatedBy, CreatedOn, RoleName, IsActive, Note, IsBuiltIn)
VALUES (@ActorId, @ActOn, 'BackOfficer', 1, 'Admin access', 1);

INSERT INTO BaseInfo (CreatedBy, CreatedOn,IsActive,ParentId,Id,Title,TitleEn,TitleFa,TitleAr) VALUES (@ActorId, @ActOn, 1,   NULL,  '100',  'Gender',   'Gender',   N'جنسيت',   N'جنس'  );
INSERT INTO BaseInfo (CreatedBy, CreatedOn,IsActive,ParentId,Id,UiIcon,UiClass,Title,TitleEn,TitleFa,TitleAr) VALUES (@ActorId, @ActOn, 1,   '100', '100.1','fa-solid fa-fw fa-male text-navy','text-navy','Male',     'Male',     N'مرد',     N'ذکر'  );
INSERT INTO BaseInfo (CreatedBy, CreatedOn,IsActive,ParentId,Id,UiIcon,UiClass,Title,TitleEn,TitleFa,TitleAr) VALUES (@ActorId, @ActOn, 1,   '100', '100.2','fa-solid fa-fw fa-female text-pink','text-pink','Female',   'Female',   N'زن',      N'انثی' );

INSERT INTO BaseInfo (CreatedBy, CreatedOn,IsActive,ParentId,Id,Title,TitleEn,TitleFa,TitleAr) VALUES (@ActorId, @ActOn, 1,   NULL,  '101',  'RecordState',     'Record State', N'وضعيت رکورد', N'حالة السجل'       );
INSERT INTO BaseInfo (CreatedBy, CreatedOn,IsActive,ParentId,Id,UiIcon,UiClass,Title,TitleEn,TitleFa,TitleAr) VALUES (@ActorId, @ActOn, 1,   '101', '101.1','fa-solid fa-fw fa-check text-success','text-success',             'Approved',         'Approved',     N'تاييد شده',   N'مقبول'            );
INSERT INTO BaseInfo (CreatedBy, CreatedOn,IsActive,ParentId,Id,UiIcon,UiClass,Title,TitleEn,TitleFa,TitleAr) VALUES (@ActorId, @ActOn, 1,   '101', '101.2','fa-solid fa-fw fa-drafting-compass text-warning','text-warning',  'Draft',            'Draft',        N'پيشنويس',     N'مسودة'            );
INSERT INTO BaseInfo (CreatedBy, CreatedOn,IsActive,ParentId,Id,UiIcon,UiClass,Title,TitleEn,TitleFa,TitleAr) VALUES (@ActorId, @ActOn, 1,   '101', '101.3','fa-solid fa-fw fa-clock-four text-primary','text-primary',        'UnderReview',      'Under Review', N'درحال بررسي', N'قيد المراجعة'     );
INSERT INTO BaseInfo (CreatedBy, CreatedOn,IsActive,ParentId,Id,UiIcon,UiClass,Title,TitleEn,TitleFa,TitleAr) VALUES (@ActorId, @ActOn, 1,   '101', '101.4','fa-solid fa-fw fa-ban text-danger','text-danger',                'Rejected',         'Rejected',     N'رد شده',      N'مرفوض'            );

INSERT INTO BaseInfo (CreatedBy, CreatedOn,IsActive,ParentId,Id,Title,TitleEn,TitleFa,TitleAr) VALUES (@ActorId, @ActOn, 1,   NULL,  '102',  'EntityType',  'Person Type',  N'نوع شخصيت',   N'نوع الشخصية'          );
INSERT INTO BaseInfo (CreatedBy, CreatedOn,IsActive,ParentId,Id,Title,TitleEn,TitleFa,TitleAr) VALUES (@ActorId, @ActOn, 1,   '102', '102.1','Indivisual',  'Indivisual',   N'حقيقي',       N'الشخصية الحقيقية'     );
INSERT INTO BaseInfo (CreatedBy, CreatedOn,IsActive,ParentId,Id,Title,TitleEn,TitleFa,TitleAr) VALUES (@ActorId, @ActOn, 1,   '102', '102.2','Company',     'Company',      N'حقوقي',       N'الشخصية الاعتبارية'   );

INSERT INTO BaseInfo (CreatedBy, CreatedOn,IsActive,ParentId,Id,Title,TitleEn,TitleFa,TitleAr) VALUES (@ActorId, @ActOn, 1,   NULL,  '103',  'Language', 'Language', N'زبان',    N'لغة'                             );
INSERT INTO BaseInfo (CreatedBy, CreatedOn,IsActive,ParentId,Id,Title,TitleEn,TitleFa,TitleAr) VALUES (@ActorId, @ActOn, 1,   '103', '103.1','English',  'English',  N'انگليسي', N'الانجليزية'                      );
INSERT INTO BaseInfo (CreatedBy, CreatedOn,IsActive,ParentId,Id,Title,TitleEn,TitleFa,TitleAr) VALUES (@ActorId, @ActOn, 1,   '103', '103.2','Persian',  'Persian',  N'فارسي',   N'الفارسية'                        );
INSERT INTO BaseInfo (CreatedBy, CreatedOn,IsActive,ParentId,Id,Title,TitleEn,TitleFa,TitleAr) VALUES (@ActorId, @ActOn, 1,   '103', '103.3','Arabic',   'Arabic',   N'عربي',    N'العربية'                         );



INSERT INTO BasePersons (CreatedBy,CreatedOn,GenderId,EntityTypeId,RecordStateId,FirstName,LastName,Mobile,UserId) VALUES (@ActorId,@ActOn, '100.1', '102.1', '101.1', N'Admin', N'Admin', '09121234567',@ActorId);




