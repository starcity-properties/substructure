#!/bin/bash -ex
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1

export JAVA_OPTS=${java_opts}
export XMX="-Xmx${xmx}"
cd /datomic/"datomic-pro"

cat <<EOF >aws.properties
protocol=${protocol}
aws-dynamodb-table=${aws_dynamodb_table}
aws-dynamodb-region=${aws_dynamodb_region}
aws-transactor-role=${transactor_role}
aws-cloudwatch-region=${region}
aws-cloudwatch-dimension-value=${cloudwatch_dimension}
aws-s3-log-bucket-id=${s3_log_bucket}
host=`curl http://instance-data/latest/meta-data/local-ipv4`
alt-host=`curl http://instance-data/latest/meta-data/public-ipv4`
port=4334
memory-index-max=${memory_index_max}
memory-index-threshold=${memory_index_threshold}
object-cache-max=${object_cache_max}
license-key=${license_key}
EOF
chmod 744 aws.properties

bin/transactor aws.properties || true
echo "Transactor process stopped. Shutting down."
