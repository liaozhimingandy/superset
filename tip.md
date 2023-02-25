###### superset 联动配置(config.py)

```
# Feature flags
"ESCAPE_MARKDOWN_HTML": False
"DASHBOARD_NATIVE_FILTERS": True,
"DASHBOARD_CROSS_FILTERS":  True,
"DASHBOARD_NATIVE_FILTERS_SET":  True,
```

###### 汉化

```
# Setup default language
BABEL_DEFAULT_LOCALE = "zh"
```

###### 密钥修改

```
# Your App secret key. Make sure you override it on superset_config.py.
# Use a strong complex alphanumeric string and use a tool to help you generate
# a sufficiently random sequence, ex: openssl rand -base64 42"
if "SECRET_KEY" in os.environ:
    SECRET_KEY = os.environ["SECRET_KEY"]
else:
    SECRET_KEY = CHANGE_ME_SECRET_KEY
```

###### 数据库连接配置

```
# The SQLAlchemy connection string.
# SQLALCHEMY_DATABASE_URI = "sqlite:///" + os.path.join(DATA_DIR, "superset.db")
if "SQLALCHEMY_DATABASE_URI" in os.environ:
    SQLALCHEMY_DATABASE_URI = os.environ["SQLALCHEMY_DATABASE_URI"]
else:
    DATA_DIR = "sqlite:///" + os.path.join(DATA_DIR, "superset.db")
```

###### redis缓存配置

```
class CeleryConfig:  # pylint: disable=too-few-public-methods
    broker_url = "redis://redis:6379/4"
    imports = ("superset.sql_lab",)
    result_backend = "redis://redis:6379/4"
    worker_log_level = "DEBUG"

# Global async query config options.
# Requires GLOBAL_ASYNC_QUERIES feature flag to be enabled.
GLOBAL_ASYNC_QUERIES_REDIS_CONFIG = {
    "port": 6379,
    "host": "redis",
    "password": "",
    "db": 1,
    "ssl": False,
}

# Default cache for Superset objects
CACHE_CONFIG: CacheConfig = {
    'CACHE_TYPE': 'redis',
    'CACHE_DEFAULT_TIMEOUT': 60 * 60 * 1, # 一小时的缓存 即 60秒 * 60 * 1小时
    'CACHE_KEY_PREFIX': 'superset_',
    'CACHE_REDIS_URL': 'redis://redis:6379/0', #redis的地址
}

# Cache for datasource metadata and query results
DATA_CACHE_CONFIG: CacheConfig = {
    'CACHE_TYPE': 'redis',
    'CACHE_DEFAULT_TIMEOUT': 60 * 60 * 1, # 一小时的缓存 即 60秒 * 60 * 1小时
    'CACHE_KEY_PREFIX': 'superset_results',
    'CACHE_REDIS_URL': 'redis://redis:6379/1', #redis的地址

}


# Cache for dashboard filter state (`CACHE_TYPE` defaults to `SimpleCache` when
#  running in debug mode unless overridden)
FILTER_STATE_CACHE_CONFIG: CacheConfig = {
    'CACHE_TYPE': 'redis',
    'CACHE_DEFAULT_TIMEOUT': 60 * 60 * 1, # 一小时的缓存 即 60秒 * 60 * 1小时
    'CACHE_KEY_PREFIX': 'superset_filter',
     'CACHE_REDIS_URL': 'redis://redis:6379/3', #redis的地址
    "CACHE_DEFAULT_TIMEOUT": int(timedelta(days=90).total_seconds()),
    # should the timeout be reset when retrieving a cached value
    "REFRESH_TIMEOUT_ON_RETRIEVAL": True,
}
```

###### redis操作

```
# 进入redis
redis-cli
# 查看数据库大小
dbsize
# 切换数据
select 0
# 查看所有key
keys *
# 查看value
get key
```

