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

# incomplete and not well maintained.
# 注释以下,默认只有中文
# LANGUAGES = {}
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

###### 权限设置-匿名用户访问

```
# Uncomment to setup Public role name, no authentication needed
AUTH_ROLE_PUBLIC = 'Public'

PUBLIC_ROLE_LIKE: Optional[str] = "Gamma"

# 以上config.py配置后执行init
# 再加上
all datasource access on all_datasource_access

# 删除多余的权限,测试无问题后可继续完善
delete a
from `ab_permission_view_role` a
inner join ab_permission_view b on a.permission_view_id = b.id
inner join ab_permission c on c.id = b.permission_id
where a.role_id = 2 
	and (c.name like '%json%'
	or c.name like '%menu%'
	or c.name like '%write%'
	or c.name like '%delete%'
	or c.name like '%can_copy_dash%'
	or c.name like '%create%'
	or c.name like '%edit%'
	or c.name like '%import%'
	or c.name like '%can_save_dash%'
	or c.name like '%can_share_chart%'
	or c.name like '%list%'
	or c.name like '%get%'
	or c.name like '%form%')
	
-- 细项删除
delete 
from ab_permission_view_role
where id = 927

select c.name, d.`name`, a.id
from `ab_permission_view_role` a
inner join ab_permission_view b on a.permission_view_id = b.id
inner join ab_permission c on c.id = b.permission_id
inner join ab_view_menu d on d.id = b.view_menu_id
where a.role_id = 2 
	and c.name like '%can_read%'
```

###### 权限设置-按职能

```
规则: Gamma + 自定义角色
自定义角色需添加以下权限:
database access on [连接名称]
schema access on [连接名称].[数据库名称]
datasource access on [数据库名称].[表名]
```

