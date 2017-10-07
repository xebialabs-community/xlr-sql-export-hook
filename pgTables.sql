CREATE TABLE xlr_phase (
  phaseId varchar(100) NOT NULL,
  phaseType varchar(100) NOT NULL,
  releaseId varchar(100) NOT NULL,
  templateId varchar(100) NOT NULL,
  phaseTitle varchar(200) NOT NULL,
  phaseDescription varchar(4000) DEFAULT NULL,
  phaseStatus varchar(20) NOT NULL,
  phaseScheduledStartDate timestamp DEFAULT NULL,
  phaseDueDate timestamp DEFAULT NULL,
  phaseStartDate timestamp NOT NULL,
  phaseEndDate timestamp NOT NULL,
  phaseDurationSeconds integer NOT NULL DEFAULT 0,
  PRIMARY KEY (phaseId)
);

CREATE INDEX phase_start_date_idx
ON xlr_phase (phaseStartDate);

CREATE TABLE xlr_release (
  releaseId varchar(100) NOT NULL,
  releaseType varchar(100) NOT NULL,
  templateId varchar(100) NOT NULL,
  releaseTitle varchar(200) NOT NULL,
  releaseOwner varchar(45) DEFAULT NULL,
  releaseDescription varchar(4000) DEFAULT NULL,
  releaseStatus varchar(20) NOT NULL,
  createdFromTrigger boolean DEFAULT NULL,
  releaseScheduledStartDate timestamp DEFAULT NULL,
  releaseDueDate timestamp DEFAULT NULL,
  releaseStartDate timestamp NOT NULL,
  releaseEndDate timestamp NOT NULL,
  releaseDurationSeconds integer NOT NULL DEFAULT '0',
  PRIMARY KEY (releaseId)
);

CREATE INDEX release_start_date_idx
ON xlr_release (releaseStartDate);

CREATE TABLE xlr_task (
  taskId varchar(100) NOT NULL,
  taskType varchar(100) NOT NULL,
  releaseId varchar(100) NOT NULL,
  phaseId varchar(100) NOT NULL,
  templateId varchar(100) NOT NULL,
  taskTitle varchar(200) NOT NULL,
  taskOwner varchar(45) DEFAULT NULL,
  taskDescription varchar(4000) DEFAULT NULL,
  taskStatus varchar(20) NOT NULL,
  automated boolean DEFAULT NULL,
  taskScheduledStartDate timestamp DEFAULT NULL,
  taskDueDate timestamp DEFAULT NULL,
  taskStartDate timestamp NOT NULL,
  taskEndDate timestamp NOT NULL,
  taskDurationSeconds integer NOT NULL DEFAULT '0',
  PRIMARY KEY (taskId)
);

CREATE INDEX task_start_date_idx
ON xlr_task (taskStartDate);

CREATE TABLE xlr_team (
  teamId varchar(100) NOT NULL,
  teamType varchar(100) NOT NULL,
  releaseId varchar(100) NOT NULL,
  templateId varchar(100) NOT NULL,
  teamName varchar(200) NOT NULL,
  members varchar(200) DEFAULT NULL,
  PRIMARY KEY (teamId)
);

CREATE TABLE xlr_variables (
    releaseId varchar(100) NOT NULL,
    variableId varchar(100) NOT NULL,
    variableKey varchar(20) NOT NULL,
    variableLable varchar(100),
    variableDescription varchar(100),
    variableType varchar(40),
    variableValue varchar(100),
    PRIMARY KEY (variableId)
);

CREATE TABLE xlr_tags (
   releaseId varchar(100) NOT NULL,
   tagName   varchar(50) NOT NULL,
   PRIMARY KEY (releaseId)
);


CREATE sequence permissionId_seq;

CREATE TABLE xlr_permission (
  permissionId integer not null default nextval('permissionId_seq'),
  permissionName varchar(30) NOT NULL,
  PRIMARY KEY (permissionId)
);

CREATE UNIQUE INDEX permission_name_idx
ON xlr_permission (permissionName);

CREATE TABLE xlr_teamToPermissions (
  teamId varchar(100) NOT NULL,
  permissionId integer NOT NULL,
  PRIMARY KEY (teamId, permissionId)
);

CREATE INDEX team_perm_idx
ON xlr_teamToPermissions (teamId, permissionId);

CREATE INDEX perm_team_idx
ON xlr_teamToPermissions (permissionId, teamId);

CREATE sequence teamMemberId_seq;

CREATE TABLE xlr_teamMember (
  teamMemberId integer not null default nextval('teamMemberId_seq'),
  memberName varchar(100) NOT NULL,
  PRIMARY KEY (teamMemberId)
);

CREATE UNIQUE INDEX name_idx
ON xlr_teamMember (memberName);

CREATE TABLE xlr_teamToTeamMembers (
  teamId varchar(100) NOT NULL,
  teamMemberId integer NOT NULL,
  PRIMARY KEY (teamId, teamMemberId)
);

CREATE INDEX team_member_idx
ON xlr_teamToTeamMembers (teamId, teamMemberId);

CREATE INDEX member_team_idx
ON xlr_teamToTeamMembers (teamMemberId, teamId);

commit;
