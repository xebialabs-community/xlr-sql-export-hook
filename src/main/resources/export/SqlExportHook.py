#
# THIS CODE AND INFORMATION ARE PROVIDED "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESSED OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS
# FOR A PARTICULAR PURPOSE. THIS CODE AND INFORMATION ARE NOT SUPPORTED BY XEBIALABS.
#

from export.exporter import ReleaseSqlPublisher

logger.info("Starting sql export of the release %s to %s v2" % (release.id, exportHook.jdbcUrl))
logger.info(releaseJson)
publisher = ReleaseSqlPublisher(release, exportHook.jdbcUrl, exportHook.username, exportHook.password, exportHook.jdbcDriver)
publisher.publish()
logger.info("Ending sql export of the release %s v2" % release.id)
