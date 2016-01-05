from mysql.exporter import ReleaseSqlPublisher

logger.info("Starting sql export of the release %s to %s v2" % (release.id, exportHook.jdbcUrl))
logger.info(releaseJson)
publisher = ReleaseSqlPublisher(release, exportHook.jdbcUrl, exportHook.username, exportHook.password, exportHook.jdbcDriver)
publisher.publish()
logger.info("Ending sql export of the release %s v2" % release.id)
