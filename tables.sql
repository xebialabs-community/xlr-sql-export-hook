use export_test;

CREATE TABLE `phase` (
  `id` varchar(100) NOT NULL,
  `type` varchar(100) NOT NULL,
  `releaseId` varchar(100) NOT NULL,
  `templateId` varchar(100) NOT NULL,
  `title` varchar(200) NOT NULL,
  `owner` varchar(45) DEFAULT NULL,
  `description` varchar(4000) DEFAULT NULL,
  `status` varchar(20) NOT NULL,
  `scheduledStartDate` datetime DEFAULT NULL,
  `dueDate` datetime DEFAULT NULL,
  `startDate` datetime NOT NULL,
  `endDate` datetime NOT NULL,
  `duration_seconds` int(11) NOT NULL DEFAULT '0',
  `duration_hours` int(11) NOT NULL DEFAULT '0',
  `duration_minutes` varchar(45) DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_UNIQUE` (`id`),
  KEY `start_date_idx` (`startDate`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `release` (
  `id` varchar(100) NOT NULL,
  `type` varchar(100) NOT NULL,
  `templateId` varchar(100) NOT NULL,
  `title` varchar(200) NOT NULL,
  `owner` varchar(45) DEFAULT NULL,
  `description` varchar(4000) DEFAULT NULL,
  `status` varchar(20) NOT NULL,
  `createdFromTrigger` tinyint(1) DEFAULT NULL,
  `scheduledStartDate` datetime DEFAULT NULL,
  `dueDate` datetime DEFAULT NULL,
  `startDate` datetime NOT NULL,
  `endDate` datetime NOT NULL,
  `duration_days` int(11) NOT NULL DEFAULT '0',
  `duration_hours` int(11) NOT NULL DEFAULT '0',
  `duration_minutes` varchar(45) DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_UNIQUE` (`id`),
  KEY `start_date_idx` (`startDate`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `task` (
  `id` varchar(100) NOT NULL,
  `type` varchar(100) NOT NULL,
  `releaseId` varchar(100) NOT NULL,
  `phaseId` varchar(100) NOT NULL,
  `templateId` varchar(100) NOT NULL,
  `title` varchar(200) NOT NULL,
  `owner` varchar(45) DEFAULT NULL,
  `description` varchar(4000) DEFAULT NULL,
  `status` varchar(20) NOT NULL,
  `automated` tinyint(1) DEFAULT NULL,
  `scheduledStartDate` datetime DEFAULT NULL,
  `dueDate` datetime DEFAULT NULL,
  `startDate` datetime NOT NULL,
  `endDate` datetime NOT NULL,
  `duration_days` int(11) NOT NULL DEFAULT '0',
  `duration_hours` int(11) NOT NULL DEFAULT '0',
  `duration_minutes` varchar(45) DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_UNIQUE` (`id`),
  KEY `start_date_idx` (`startDate`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `teams` (
  `id` varchar(100) NOT NULL,
  `type` varchar(100) NOT NULL,
  `releaseId` varchar(100) NOT NULL,
  `templateId` varchar(100) NOT NULL,
  `teamName` varchar(200) NOT NULL,
  `permissions` varchar(200) DEFAULT NULL,
  `members` varchar(200) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_UNIQUE` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

commit;