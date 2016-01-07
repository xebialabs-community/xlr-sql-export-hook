from java.sql import DriverManager
from java.lang import Class
from java.sql import Timestamp

import sys
import re
from org.joda.time.format import ISODateTimeFormat
from org.joda.time import DateTime, Duration


class ObjectView(object):
    def __init__(self, d):
        self.__dict__ = d

class NamedPreparedStatement(object):

    def __init__(self, connection, named_statement):
        self._conn = connection
        self._named_statement = named_statement
        indexed_statement = named_statement
        name_regex = re.compile('(:[A-za-z]*)')
        self._tokens = name_regex.findall(named_statement)
        for t in self._tokens:
            indexed_statement = indexed_statement.replace(t, '?')
        self._prepared_statement = connection.prepareStatement(indexed_statement)

    def _token_index(self, name):
        if not name.startswith(":"):
            name = ":" + name
        try:
            return  self._tokens.index(name)
        except ValueError as e:
            err_msg = "Failed to find named parameter [%s] in sql statement [%s].\nKnown tokens are %s" % (name, self._named_statement, self._tokens)
            raise Exception(err_msg)

    def setString(self, name, val):
        index = self._token_index(name)
        if isinstance(val, list):
            val = ','.join(val)
        self._prepared_statement.setString(index+1, str(val))

    def setBoolean(self, name, val):
        index = self._token_index(name)
        self._prepared_statement.setBoolean(index+1, val)

    def setInt(self, name, val):
        index = self._token_index(name)
        self._prepared_statement.setInt(index+1, val)

    def setTimestamp(self, name, val):
        index = self._token_index(name)
        self._prepared_statement.setTimestamp(index+1, val)

    def execute(self):
        #print "Executing sql statement [%s]" % self._prepared_statement.toString()
        self._prepared_statement.execute()
        self._prepared_statement.close()


class ReleaseSqlPublisher(object):

    ISO_DATE_TIME_FORMAT = ISODateTimeFormat.dateTimeParser()
    RELEASE_PREP_STATEMENT = "INSERT INTO `release` (releaseId, releaseType, templateId, releaseTitle, releaseOwner, releaseDescription, releaseStatus, createdFromTrigger, releaseScheduledStartDate, releaseDueDate, releaseStartDate, releaseEndDate, releaseDurationSeconds) VALUES (:id, :type, :templateId, :title, :owner, :description, :status, :createdFromTrigger, :scheduledStartDate, :dueDate, :startDate, :endDate, :durationSeconds)"
    PHASE_PREP_STATEMENT = "INSERT INTO `phase` (phaseId, phaseType, releaseId, templateId, phaseTitle, phaseDescription, phaseStatus, phaseScheduledStartDate, phaseDueDate, phaseStartDate, phaseEndDate, phaseDurationSeconds) VALUES (:id, :type, :releaseId, :templateId, :title, :description, :status, :scheduledStartDate, :dueDate, :startDate, :endDate, :durationSeconds)"
    TASK_PREP_STATEMENT = "INSERT INTO `task` (taskId, taskType, releaseId, phaseId, templateId, taskTitle, taskOwner, taskDescription, taskStatus, automated, taskScheduledStartDate, taskDueDate, taskStartDate, taskEndDate, taskDurationSeconds) VALUES (:id, :type, :releaseId, :phaseId, :templateId, :title, :owner, :description, :status, :automated, :scheduledStartDate, :dueDate, :startDate, :endDate, :durationSeconds)"
    TEAM_PREP_STATEMENT = "INSERT INTO `team` (teamId, teamType, releaseId, templateId, teamName, members) VALUES (:id ,:type, :releaseId, :templateId, :teamName, :members)"
    PERMISSION_PREP_STATEMENT = "INSERT IGNORE INTO `permission` SET `permissionName` = :name"
    TEAM_PERM_PREP_STATEMENT = "INSERT INTO `teamToPermissions` (teamId, permissionId) SELECT :id, permissionId FROM permission WHERE permissionName = :permName"
    TEAM_MEMBER_PREP_STATEMENT = "INSERT IGNORE INTO `teamMember` SET `memberName` = :name"
    TEAM_TO_MEMBER_PREP_STATEMENT = "INSERT INTO `teamToTeamMembers` (teamId, teamMemberId) SELECT :id, teamMemberId FROM teamMember WHERE memberName = :memberName"



    def __init__(self, release, db_url, username, password, jdbc_driver):
        self.jdbc_driver = jdbc_driver
        self.password = password
        self.username = username
        self.db_url = db_url
        Class.forName(jdbc_driver)
        self._conn = DriverManager.getConnection(db_url, username, password)
        wrapped_release = self.wrap_dict_as_obj(release)
        self.release = wrapped_release
        self.release_id = self.convert_id(wrapped_release.id)
        if "originTemplateId" in release and release['originTemplateId'] is not None:
            self.template_id = self.convert_id(wrapped_release.originTemplateId)
        else:
            self.template_id = "No Template"

    def _named_prepare_statement(self, statement):
        return NamedPreparedStatement(self._conn, statement)

    def convert_date(self, d):
        if d is not None:
            if isinstance(d, basestring):
                return Timestamp(ReleaseSqlPublisher.ISO_DATE_TIME_FORMAT.parseDateTime(d).getMillis())
            else:
                return Timestamp(DateTime(d).getMillis())
        return None

    def wrap_dict_as_obj(self, ci):
        if isinstance(ci, dict):
            return ObjectView(ci)
        return ci

    def convert_id(self, jcr_id):
        if jcr_id is not None and jcr_id.startswith("Applications/"):
            return jcr_id[13:].replace('/', '-')
        raise Exception("Invalid JCR id : %s" % jcr_id)

    def execute_statement(self, statement):
        try:
            statement.execute()
        except Exception, e:
            logger.error('Could not push release into SQL DB', e)
            raise e

    def create_base(self, ci, statement):
        ps = self._named_prepare_statement(statement)
        ps.setString("id", self.convert_id(ci.id))
        ps.setString("type", str(ci.type))
        if str(ci.type) != "xlrelease.Release":
            ps.setString("releaseId", self.release_id)
        ps.setString("templateId", self.template_id)
        return ps

    def create_duration_fields(self, target, start_date, end_date):
        period = Duration(DateTime(start_date).getMillis(), DateTime(end_date).getMillis())
        target.setInt("durationSeconds", period.getStandardSeconds())

    def copy_dates(self, ci, target):
        if hasattr(ci, "scheduledStartDate"):
            target.setTimestamp("scheduledStartDate", self.convert_date(ci.scheduledStartDate))
        else:
            target.setTimestamp("scheduledStartDate", None)
        if hasattr(ci, "dueDate"):
            target.setTimestamp("dueDate", self.convert_date(ci.dueDate))
        else:
            target.setTimestamp("dueDate", None)
        target.setTimestamp("startDate", self.convert_date(ci.startDate))
        target.setTimestamp("endDate", self.convert_date(ci.endDate))
        self.create_duration_fields(target, ci.startDate, ci.endDate)

    def copy_common(self, ci, target):
        target.setString("title", ci.title)
        if ci.type != "xlrelease.Phase":
            if hasattr(ci, "owner"):
                target.setString("owner", ci.owner)
            else:
                target.setString("owner", "")
        if hasattr(ci, "description"):
            target.setString("description", ci.description)
        else:
            target.setString("description", "")
        target.setString("status", str(ci.status))

    def publish_teams(self, teams):
        if not teams:
            return
        for t in teams:
            t = self.wrap_dict_as_obj(t)
            target = self.create_base(t, ReleaseSqlPublisher.TEAM_PREP_STATEMENT)
            target.setString('teamName', t.teamName)
            target.setString('members', t.members)
            teamId = self.convert_id(t.id)
            self.publish_team_members(t.members, teamId)
            self.publish_permission(t.permissions, teamId)
            self.execute_statement(target)

    def publish_team_members(self, teamMembers, teamId):
        for member in teamMembers:
            st = self._named_prepare_statement(ReleaseSqlPublisher.TEAM_MEMBER_PREP_STATEMENT)
            st.setString("name", member)
            self.execute_statement(st)
            self.link_teamt_to_team_member(teamId, member)

    def link_teamt_to_team_member(self, teamId, member):
        st = self._named_prepare_statement(ReleaseSqlPublisher.TEAM_TO_MEMBER_PREP_STATEMENT)
        st.setString("id", teamId)
        st.setString("memberName", member)
        self.execute_statement(st)

    def publish_permission(self, permissions, teamId):
        for perm in permissions:
            st = self._named_prepare_statement(ReleaseSqlPublisher.PERMISSION_PREP_STATEMENT)
            st.setString("name", perm)
            self.execute_statement(st)
            self.link_team_to_perm(teamId, perm)

    def link_team_to_perm(self, teamId, permName):
        st = self._named_prepare_statement(ReleaseSqlPublisher.TEAM_PERM_PREP_STATEMENT)
        st.setString("id", teamId)
        st.setString("permName", permName)
        self.execute_statement(st)

    def publish_tasks(self, tasks, phase_id):
        for t in tasks:
            t = self.wrap_dict_as_obj(t)
            if str(t.type) == "xlrelease.ParallelGroup":
                self.publish_tasks(t.tasks, phase_id)
            else:
                target = self.create_base(t, ReleaseSqlPublisher.TASK_PREP_STATEMENT)
                target.setString('phaseId', phase_id)
                self.copy_common(t, target)
                self.copy_dates(t, target)
                target.setBoolean('automated', False)
                if str(t.type) == "xlrelease.CustomScriptTask":
                    target.setString('type', str(t.pythonScript.type))
                    target.setBoolean('automated', True)
                elif str(t.type) == "xlrelease.DeployitTask" or str(t.type) == "xlrelease.ScriptTask":
                    target.setBoolean('automated', True)
                self.execute_statement(target)

    def publish_phases(self, phases):
        for p in phases:
            p = self.wrap_dict_as_obj(p)
            target = self.create_base(p, ReleaseSqlPublisher.PHASE_PREP_STATEMENT)
            self.copy_common(p, target)
            self.copy_dates(p, target)
            self.execute_statement(target)
            self.publish_tasks(p.tasks, self.convert_id(p.id))

    def publish_release(self):
        r = self.release
        target = self.create_base(r, ReleaseSqlPublisher.RELEASE_PREP_STATEMENT)
        self.copy_common(r, target)
        self.copy_dates(r, target)
        if hasattr(target, "createdFromTrigger"):
            target.setBoolean("createdFromTrigger", r.createdFromTrigger)
        else:
            target.setBoolean("createdFromTrigger", False)
        self.execute_statement(target)
        self.publish_teams(r.teams)
        self.publish_phases(r.phases)

    def publish(self):
        try:
            self.publish_release()
        except Exception as e:
            raise e
