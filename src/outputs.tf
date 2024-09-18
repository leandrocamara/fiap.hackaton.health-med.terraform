output "dbEndpoint" {
  value = aws_db_instance.rds.endpoint
}

output "redisEndpoint" {
  value = "${aws_elasticache_replication_group.redis.primary_endpoint_address}:${aws_elasticache_replication_group.redis.port}"
}
