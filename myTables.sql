CREATE TABLE `xlr_phase` (
  `phaseId` varchar(100) NOT NULL,
  `phaseType` varchar(100) NOT NULL,
  `releaseId` varchar(100) NOT NULL,
  `templateId` varchar(100) NOT NULL,
  `phaseTitle` varchar(200) NOT NULL,
  `phaseDescription` varchar(4000) DEFAULT NULL,
  `phaseStatus` varchar(20) NOT NULL,
  `phaseScheduledStartDate` datetime DEFAULT NULL,
  `phaseDueDate` datetime DEFAULT NULL,
  `phaseStartDate` datetime NOT NULL,
  `phaseEndDate` datetime NOT NULL,
  `phaseDurationSeconds` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`phaseId`),
  KEY `start_date_idx` (`phaseStartDate`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `xlr_variables` (
    `releaseId` varchar(100) NOT NULL,
    `variableId` varchar(100) NOT NULL,
    `variableKey` varchar(20) NOT NULL,
    `variableLable` varchar(100),
    `variableDescription` varchar(100),
    `variableType` varchar(40),
    `variableValue` varchar(100),
    PRIMARY KEY (`variableId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `xlr_tags` (
   `releaseId` varchar(100) NOT NULL,
   `tagName`   varchar(50) NOT NULL,
   PRIMARY KEY (`releaseId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `xlr_release` (
  `releaseId` varchar(100) NOT NULL,
  `releaseType` varchar(100) NOT NULL,
  `templateId` varchar(100) NOT NULL,
  `releaseTitle` varchar(200) NOT NULL,
  `releaseOwner` varchar(45) DEFAULT NULL,
  `releaseDescription` varchar(4000) DEFAULT NULL,
  `releaseStatus` varchar(20) NOT NULL,
  `createdFromTrigger` tinyint(1) DEFAULT NULL,
  `releaseScheduledStartDate` datetime DEFAULT NULL,
  `releaseDueDate` datetime DEFAULT NULL,
  `releaseStartDate` datetime NOT NULL,
  `releaseEndDate` datetime NOT NULL,
  `releaseDurationSeconds` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`releaseId`),
  KEY `start_date_idx` (`releaseStartDate`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `xlr_task` (
  `taskId` varchar(100) NOT NULL,
  `taskType` varchar(100) NOT NULL,
  `releaseId` varchar(100) NOT NULL,
  `phaseId` varchar(100) NOT NULL,
  `templateId` varchar(100) NOT NULL,
  `taskTitle` varchar(200) NOT NULL,
  `taskOwner` varchar(45) DEFAULT NULL,
  `taskDescription` varchar(4000) DEFAULT NULL,
  `taskStatus` varchar(20) NOT NULL,
  `automated` tinyint(1) DEFAULT NULL,
  `taskScheduledStartDate` datetime DEFAULT NULL,
  `taskDueDate` datetime DEFAULT NULL,
  `taskStartDate` datetime NOT NULL,
  `taskEndDate` datetime NOT NULL,
  `taskDurationSeconds` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`taskId`),
  KEY `start_date_idx` (`taskStartDate`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `xlr_team` (
  `teamId` varchar(100) NOT NULL,
  `teamType` varchar(100) NOT NULL,
  `releaseId` varchar(100) NOT NULL,
  `templateId` varchar(100) NOT NULL,
  `teamName` varchar(200) NOT NULL,
  `members` varchar(200) DEFAULT NULL,
  PRIMARY KEY (`teamId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `xlr_permission` (
  `permissionId` int(11) NOT NULL AUTO_INCREMENT,
  `permissionName` varchar(30) NOT NULL,
  PRIMARY KEY (`permissionId`),
  UNIQUE KEY `name_idx` (`permissionName`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `xlr_teamToPermissions` (
  `teamId` varchar(100) NOT NULL,
  `permissionId` int(11) NOT NULL,
  PRIMARY KEY (`teamId`, `permissionId`),
  KEY `team_perm_idx` (`teamId`, `permissionId`),
  KEY `perm_team_idx` (`permissionId`, `teamId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `xlr_teamMember` (
  `teamMemberId` int(11) NOT NULL AUTO_INCREMENT,
  `memberName` varchar(100) NOT NULL,
  PRIMARY KEY (`teamMemberId`),
  UNIQUE KEY `name_idx` (`memberName`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `xlr_teamToTeamMembers` (
  `teamId` varchar(100) NOT NULL,
  `teamMemberId` int(11) NOT NULL,
  PRIMARY KEY (`teamId`, `teamMemberId`),
  KEY `team_member_idx` (`teamId`, `teamMemberId`),
  KEY `member_team_idx` (`teamMemberId`, `teamId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

commit;
