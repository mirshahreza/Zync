-- =============================================
-- Author:      Mohsen Mirshahreza
-- Create date: 2026-01-18
-- Author:      Mohsen Mirshahreza
-- Description: Simple seed BaseInfor for CMS application
-- =============================================


DECLARE @ActOn DATETIME = GETDATE();
DECLARE @ActorId INT = (SELECT TOP 1 Id FROM BaseUsers ORDER BY Id);


INSERT INTO BaseInfo (CreatedBy, CreatedOn,IsActive,ParentId,Id,Title,TitleEn,TitleFa,TitleAr) VALUES (@ActorId, @ActOn, 1,   NULL,  '150',     'ContentType',      'Content Type',     N'نوع محتوي',       N'نوع المحتوى'  );
INSERT INTO BaseInfo (CreatedBy, CreatedOn,IsActive,ParentId,Id,Title,TitleEn,TitleFa,TitleAr) VALUES (@ActorId, @ActOn, 1,   '150', '150.01',  'Article',          'Article',          N'مقاله',           N'مقالة'        );
INSERT INTO BaseInfo (CreatedBy, CreatedOn,IsActive,ParentId,Id,Title,TitleEn,TitleFa,TitleAr) VALUES (@ActorId, @ActOn, 1,   '150', '150.02',  'News',             'News',             N'خبر',             N'خبر'          );
INSERT INTO BaseInfo (CreatedBy, CreatedOn,IsActive,ParentId,Id,Title,TitleEn,TitleFa,TitleAr) VALUES (@ActorId, @ActOn, 1,   '150', '150.03',  'Picture',          'Picture',          N'تصوير',           N'صورة'			);
INSERT INTO BaseInfo (CreatedBy, CreatedOn,IsActive,ParentId,Id,Title,TitleEn,TitleFa,TitleAr) VALUES (@ActorId, @ActOn, 1,   '150', '150.04',  'Video',            'Video',            N'ويديو',           N'فيديو'		);
INSERT INTO BaseInfo (CreatedBy, CreatedOn,IsActive,ParentId,Id,Title,TitleEn,TitleFa,TitleAr) VALUES (@ActorId, @ActOn, 1,   '150', '150.05',  'Pdf',              'Pdf',              N'پي دي اف',        N'بي دي إف'		);
INSERT INTO BaseInfo (CreatedBy, CreatedOn,IsActive,ParentId,Id,Title,TitleEn,TitleFa,TitleAr) VALUES (@ActorId, @ActOn, 1,   '150', '150.06',  'Word',             'Word',             N'وورد',            N'وورد'			);
INSERT INTO BaseInfo (CreatedBy, CreatedOn,IsActive,ParentId,Id,Title,TitleEn,TitleFa,TitleAr) VALUES (@ActorId, @ActOn, 1,   '150', '150.07',  'Excel',            'Excel',            N'اکسل',            N'إكسل'			);
INSERT INTO BaseInfo (CreatedBy, CreatedOn,IsActive,ParentId,Id,Title,TitleEn,TitleFa,TitleAr) VALUES (@ActorId, @ActOn, 1,   '150', '150.08',  'Text',             'Text',             N'تکست',            N'نص'			);
INSERT INTO BaseInfo (CreatedBy, CreatedOn,IsActive,ParentId,Id,Title,TitleEn,TitleFa,TitleAr) VALUES (@ActorId, @ActOn, 1,   '150', '150.09',  'Csv',              'Csv',              N'سي اس وي',        N'سي إس في'		);
INSERT INTO BaseInfo (CreatedBy, CreatedOn,IsActive,ParentId,Id,Title,TitleEn,TitleFa,TitleAr) VALUES (@ActorId, @ActOn, 1,   '150', '150.20',  'File',             'File',             N'فايل',            N'ملف'			);
INSERT INTO BaseInfo (CreatedBy, CreatedOn,IsActive,ParentId,Id,Title,TitleEn,TitleFa,TitleAr) VALUES (@ActorId, @ActOn, 1,   '150', '150.21',  'Comment',          'Comment',          N'پينوشت',          N'تعليق'		);
INSERT INTO BaseInfo (CreatedBy, CreatedOn,IsActive,ParentId,Id,Title,TitleEn,TitleFa,TitleAr) VALUES (@ActorId, @ActOn, 1,   '150', '150.22',  'ForumeTopic',      'Forume Topic',     N'موضوع گفتگو',     N'موضوع المنتدى');
INSERT INTO BaseInfo (CreatedBy, CreatedOn,IsActive,ParentId,Id,Title,TitleEn,TitleFa,TitleAr) VALUES (@ActorId, @ActOn, 1,   '150', '150.23',  'Reportage',        'Reportage',        N'گزارش',           N'تقرير'		);
INSERT INTO BaseInfo (CreatedBy, CreatedOn,IsActive,ParentId,Id,Title,TitleEn,TitleFa,TitleAr) VALUES (@ActorId, @ActOn, 1,   '150', '150.24',  'Interview',        'Interview',        N'گفتگو',           N'مقابلة'		);
INSERT INTO BaseInfo (CreatedBy, CreatedOn,IsActive,ParentId,Id,Title,TitleEn,TitleFa,TitleAr) VALUES (@ActorId, @ActOn, 1,   '150', '150.25',  'Advertisement',    'Advertisement',    N'آگهي',            N'إعلانات'		);
INSERT INTO BaseInfo (CreatedBy, CreatedOn,IsActive,ParentId,Id,Title,TitleEn,TitleFa,TitleAr) VALUES (@ActorId, @ActOn, 1,   '150', '150.26',  'RenderLayout',     'Render Layout',    N'چيدمان نمایش',    N'تخطيط العرض'  );


INSERT INTO BaseInfo (CreatedBy, CreatedOn,IsActive,ParentId,Id,Title,TitleEn,TitleFa,TitleAr) VALUES (@ActorId, @ActOn, 1,   NULL,  '151',  'CommentsPolicy',      'Comments Policy',          N'سياست پينوشتها',			N'سياسة التعليقات'          );
INSERT INTO BaseInfo (CreatedBy, CreatedOn,IsActive,ParentId,Id,Title,TitleEn,TitleFa,TitleAr) VALUES (@ActorId, @ActOn, 1,   '151', '151.1','NotAllowed',          'Not Allowed',              N'ممنوع',					N'غير مسموح به'            );
INSERT INTO BaseInfo (CreatedBy, CreatedOn,IsActive,ParentId,Id,Title,TitleEn,TitleFa,TitleAr) VALUES (@ActorId, @ActOn, 1,   '151', '151.2','AllowedAutoApprove',  'Allowed - Auto Approve',   N'مجاز - با تایید خودکار',  N'مجاز - بتأييد تلقائي'     );
INSERT INTO BaseInfo (CreatedBy, CreatedOn,IsActive,ParentId,Id,Title,TitleEn,TitleFa,TitleAr) VALUES (@ActorId, @ActOn, 1,   '151', '151.3','AllowedManualApprove','Allowed - Manual Approve', N'مجاز - با تایید دستی',    N'مجاز - بتأييد يدوي'       );

INSERT INTO BaseInfo (CreatedBy, CreatedOn,IsActive,ParentId,Id,Title,TitleEn,TitleFa,TitleAr) VALUES (@ActorId, @ActOn, 1,   NULL,  '152',     'Tags',             'Tags',                         N'تگ ها',               N'وسوم'             );
INSERT INTO BaseInfo (CreatedBy, CreatedOn,IsActive,ParentId,Id,Title,TitleEn,TitleFa,TitleAr) VALUES (@ActorId, @ActOn, 1,   '152', '152.0001','Technology',       'Technology',                   N'تکنولوژی',            N'تكنولوجيا'        );
INSERT INTO BaseInfo (CreatedBy, CreatedOn,IsActive,ParentId,Id,Title,TitleEn,TitleFa,TitleAr) VALUES (@ActorId, @ActOn, 1,   '152', '152.0002','Social',           'Social',                       N'اجتماعی',             N'اجتماعي'          );
INSERT INTO BaseInfo (CreatedBy, CreatedOn,IsActive,ParentId,Id,Title,TitleEn,TitleFa,TitleAr) VALUES (@ActorId, @ActOn, 1,   '152', '152.0003','Policy',           'Policy',                       N'سیاست',               N'سياسة'            );
INSERT INTO BaseInfo (CreatedBy, CreatedOn,IsActive,ParentId,Id,Title,TitleEn,TitleFa,TitleAr) VALUES (@ActorId, @ActOn, 1,   '152', '152.0004','Sport',            'Sport',                        N'ورزش',                N'رياضة'            );
INSERT INTO BaseInfo (CreatedBy, CreatedOn,IsActive,ParentId,Id,Title,TitleEn,TitleFa,TitleAr) VALUES (@ActorId, @ActOn, 1,   '152', '152.0005','Psychology',       'Psychology',                   N'روانشناسی',           N'علم النفس'        );
INSERT INTO BaseInfo (CreatedBy, CreatedOn,IsActive,ParentId,Id,Title,TitleEn,TitleFa,TitleAr) VALUES (@ActorId, @ActOn, 1,   '152', '152.0006','Echonomy',         'Economy',                      N'اقتصاد',              N'اقتصاد'           );
INSERT INTO BaseInfo (CreatedBy, CreatedOn,IsActive,ParentId,Id,Title,TitleEn,TitleFa,TitleAr) VALUES (@ActorId, @ActOn, 1,   '152', '152.0007','Kids',             'Kids',                         N'کودکان',              N'أطفال'            );
INSERT INTO BaseInfo (CreatedBy, CreatedOn,IsActive,ParentId,Id,Title,TitleEn,TitleFa,TitleAr) VALUES (@ActorId, @ActOn, 1,   '152', '152.0008','Adults',           'Adults',                       N'بزرگسالان',			N'بالغون'           );
INSERT INTO BaseInfo (CreatedBy, CreatedOn,IsActive,ParentId,Id,Title,TitleEn,TitleFa,TitleAr) VALUES (@ActorId, @ActOn, 1,   '152', '152.0009','Ethics',           'Ethics',                       N'اخلاق',				N'أخلاق'				);
INSERT INTO BaseInfo (CreatedBy, CreatedOn,IsActive,ParentId,Id,Title,TitleEn,TitleFa,TitleAr) VALUES (@ActorId, @ActOn, 1,   '152', '152.0010','Etiquette',        'Etiquette',                    N'آداب',                N'إتيكيت'           );
INSERT INTO BaseInfo (CreatedBy, CreatedOn,IsActive,ParentId,Id,Title,TitleEn,TitleFa,TitleAr) VALUES (@ActorId, @ActOn, 1,   '152', '152.0011','Industry',         'Industry',                     N'صنعت',                N'صناعة'            );
INSERT INTO BaseInfo (CreatedBy, CreatedOn,IsActive,ParentId,Id,Title,TitleEn,TitleFa,TitleAr) VALUES (@ActorId, @ActOn, 1,   '152', '152.0012','Car',              'Car',                          N'خودرو',               N'سيارة'            );
INSERT INTO BaseInfo (CreatedBy, CreatedOn,IsActive,ParentId,Id,Title,TitleEn,TitleFa,TitleAr) VALUES (@ActorId, @ActOn, 1,   '152', '152.0013','AI',               'Artificial Intelligence',      N'هوش مصنوعی',          N'ذكاء اصطناعي'     );
INSERT INTO BaseInfo (CreatedBy, CreatedOn,IsActive,ParentId,Id,Title,TitleEn,TitleFa,TitleAr) VALUES (@ActorId, @ActOn, 1,   '152', '152.0014','Cinema',           'Cinema',                       N'سینما',               N'سينما'            );
INSERT INTO BaseInfo (CreatedBy, CreatedOn,IsActive,ParentId,Id,Title,TitleEn,TitleFa,TitleAr) VALUES (@ActorId, @ActOn, 1,   '152', '152.0015','Music',            'Music',                        N'موزیک',               N'موسيقى'           );
INSERT INTO BaseInfo (CreatedBy, CreatedOn,IsActive,ParentId,Id,Title,TitleEn,TitleFa,TitleAr) VALUES (@ActorId, @ActOn, 1,   '152', '152.0016','Art',              'Art',                          N'هنر',                 N'فن'               );
INSERT INTO BaseInfo (CreatedBy, CreatedOn,IsActive,ParentId,Id,Title,TitleEn,TitleFa,TitleAr) VALUES (@ActorId, @ActOn, 1,   '152', '152.0017','Accidents',        'Accidents',                    N'حوادث',               N'حوادث'            );
INSERT INTO BaseInfo (CreatedBy, CreatedOn,IsActive,ParentId,Id,Title,TitleEn,TitleFa,TitleAr) VALUES (@ActorId, @ActOn, 1,   '152', '152.0018','Training',         'Training',                     N'آموزشی',              N'تدريب'            );
INSERT INTO BaseInfo (CreatedBy, CreatedOn,IsActive,ParentId,Id,Title,TitleEn,TitleFa,TitleAr) VALUES (@ActorId, @ActOn, 1,   '152', '152.0019','Scientific',       'Scientific',                   N'علمی',                N'علمي'             );
INSERT INTO BaseInfo (CreatedBy, CreatedOn,IsActive,ParentId,Id,Title,TitleEn,TitleFa,TitleAr) VALUES (@ActorId, @ActOn, 1,   '152', '152.0020','Business',         'Business',                     N'کسب و کار',           N'أعمال'            );
INSERT INTO BaseInfo (CreatedBy, CreatedOn,IsActive,ParentId,Id,Title,TitleEn,TitleFa,TitleAr) VALUES (@ActorId, @ActOn, 1,   '152', '152.0021','Animals',          'Animals',                      N'جانوران',             N'حيوانات'          );
INSERT INTO BaseInfo (CreatedBy, CreatedOn,IsActive,ParentId,Id,Title,TitleEn,TitleFa,TitleAr) VALUES (@ActorId, @ActOn, 1,   '152', '152.0022','Plants',           'Plants',                       N'گیاهان',              N'نباتات'           );
INSERT INTO BaseInfo (CreatedBy, CreatedOn,IsActive,ParentId,Id,Title,TitleEn,TitleFa,TitleAr) VALUES (@ActorId, @ActOn, 1,   '152', '152.0023','Insects',          'Insects',                      N'حشرات',               N'حشرات'            );
INSERT INTO BaseInfo (CreatedBy, CreatedOn,IsActive,ParentId,Id,Title,TitleEn,TitleFa,TitleAr) VALUES (@ActorId, @ActOn, 1,   '152', '152.0024','Aerospace',        'Aerospace',                    N'هوا و فضا',           N'فضاء وطيران'      );
INSERT INTO BaseInfo (CreatedBy, CreatedOn,IsActive,ParentId,Id,Title,TitleEn,TitleFa,TitleAr) VALUES (@ActorId, @ActOn, 1,   '152', '152.0025','Mobile',           'Mobile',                       N'موبایل',              N'جوال'             );
INSERT INTO BaseInfo (CreatedBy, CreatedOn,IsActive,ParentId,Id,Title,TitleEn,TitleFa,TitleAr) VALUES (@ActorId, @ActOn, 1,   '152', '152.0026','Computer',         'Computer',                     N'رایانه',              N'حاسوب'			);
INSERT INTO BaseInfo (CreatedBy, CreatedOn,IsActive,ParentId,Id,Title,TitleEn,TitleFa,TitleAr) VALUES (@ActorId, @ActOn, 1,   '152', '152.0027','Tablet',           'Tablet',                       N'تبلت',                N'جهاز لوحي'		);
INSERT INTO BaseInfo (CreatedBy, CreatedOn,IsActive,ParentId,Id,Title,TitleEn,TitleFa,TitleAr) VALUES (@ActorId, @ActOn, 1,   '152', '152.0028','Laptop',           'Laptop',                       N'لپ تاپ',              N'حاسوب محمول'		);
INSERT INTO BaseInfo (CreatedBy, CreatedOn,IsActive,ParentId,Id,Title,TitleEn,TitleFa,TitleAr) VALUES (@ActorId, @ActOn, 1,   '152', '152.0029','Gadget',           'Gadget',                       N'گجت',                 N'أدوات ذكية'		);
INSERT INTO BaseInfo (CreatedBy, CreatedOn,IsActive,ParentId,Id,Title,TitleEn,TitleFa,TitleAr) VALUES (@ActorId, @ActOn, 1,   '152', '152.0030','Software',         'Software',                     N'نرم افزار',           N'برمجيات'			);
INSERT INTO BaseInfo (CreatedBy, CreatedOn,IsActive,ParentId,Id,Title,TitleEn,TitleFa,TitleAr) VALUES (@ActorId, @ActOn, 1,   '152', '152.0031','Hardware',         'Hardware',                     N'سخت افزار',           N'أجهزة'			);
INSERT INTO BaseInfo (CreatedBy, CreatedOn,IsActive,ParentId,Id,Title,TitleEn,TitleFa,TitleAr) VALUES (@ActorId, @ActOn, 1,   '152', '152.0032','Robotics',         'Robotics',                     N'روبوتیکس',            N'روبوتات'			);
INSERT INTO BaseInfo (CreatedBy, CreatedOn,IsActive,ParentId,Id,Title,TitleEn,TitleFa,TitleAr) VALUES (@ActorId, @ActOn, 1,   '152', '152.0033','Crypto',           'Crypto',                       N'کریپتو',              N'عملات مشفرة'		);
INSERT INTO BaseInfo (CreatedBy, CreatedOn,IsActive,ParentId,Id,Title,TitleEn,TitleFa,TitleAr) VALUES (@ActorId, @ActOn, 1,   '152', '152.0034','HomeAppliances',   'Home Appliances',              N'لوازم خانگی',         N'أجهزة منزلية'		);
INSERT INTO BaseInfo (CreatedBy, CreatedOn,IsActive,ParentId,Id,Title,TitleEn,TitleFa,TitleAr) VALUES (@ActorId, @ActOn, 1,   '152', '152.0035','SocialNetworks',   'Social Networks',              N'شبکه های اجتماعی',    N'شبكات اجتماعية'	);
INSERT INTO BaseInfo (CreatedBy, CreatedOn,IsActive,ParentId,Id,Title,TitleEn,TitleFa,TitleAr) VALUES (@ActorId, @ActOn, 1,   '152', '152.0036','Health',           'Health',                       N'سلامت',				N'صحة'				);
INSERT INTO BaseInfo (CreatedBy, CreatedOn,IsActive,ParentId,Id,Title,TitleEn,TitleFa,TitleAr) VALUES (@ActorId, @ActOn, 1,   '152', '152.0037','Energy',           'Energy',                       N'انرژی',               N'طاقة'				);
INSERT INTO BaseInfo (CreatedBy, CreatedOn,IsActive,ParentId,Id,Title,TitleEn,TitleFa,TitleAr) VALUES (@ActorId, @ActOn, 1,   '152', '152.0038','Environment',      'Environment',                  N'محیط زیست',           N'بيئة'				);
INSERT INTO BaseInfo (CreatedBy, CreatedOn,IsActive,ParentId,Id,Title,TitleEn,TitleFa,TitleAr) VALUES (@ActorId, @ActOn, 1,   '152', '152.0039','Security',         'Security',                     N'امنیت',               N'أمن'				);
INSERT INTO BaseInfo (CreatedBy, CreatedOn,IsActive,ParentId,Id,Title,TitleEn,TitleFa,TitleAr) VALUES (@ActorId, @ActOn, 1,   '152', '152.0040','WebAndInternet',   'Web and Internet',             N'وب و اینترنت',        N'إنترنت'			);
INSERT INTO BaseInfo (CreatedBy, CreatedOn,IsActive,ParentId,Id,Title,TitleEn,TitleFa,TitleAr) VALUES (@ActorId, @ActOn, 1,   '152', '152.0041','ImageGallery',     'Image Gallery',                N'آلبوم تصاویر',        N'معرض الصور'		);
INSERT INTO BaseInfo (CreatedBy, CreatedOn,IsActive,ParentId,Id,Title,TitleEn,TitleFa,TitleAr) VALUES (@ActorId, @ActOn, 1,   '152', '152.0042','Video',            'Video',                        N'ویدیو',               N'فيديو'			);

