FROM apache/superset:1.3.2
# Switching to root to install the required packages
USER root
# Example: installing the MySQL driver to connect to the metadata database
# if you prefer Postgres, you may want to use `psycopg2-binary` instead
RUN pip install -i http://mirrors.aliyun.com/pypi/simple/  cx_Oracle --trusted-host mirrors.aliyun.com && pip install -i http://mirrors.aliyun.com/pypi/simple/ pymssql --trusted-host mirrors.aliyun.com && pip install -i http://mirrors.aliyun.com/pypi/simple/ kylinpy --trusted-host mirrors.aliyun.com
# Example: installing a driver to connect to Redshift
# Find which driver you need based on the analytics database
# you want to connect to here:
# https://superset.apache.org/installation.html#database-dependencies
# RUN pip install sqlalchemy-redshift
# Switching back to using the `superset` user
USER superset

# 构建
# docker build --squash -t liaozhiming/superset:1.3.2.211106 . 