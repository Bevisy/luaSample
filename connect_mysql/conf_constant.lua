---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by z15085.
--- DateTime: 2019/9/5 20:10
---
local config = {}

--config.redisConfig = {
--    redis_a = {
--        host = '127.0.0.1',
--        port = 6379,
--        pass = '123456',
--        timeout = 120000,
--        database = 0,
--    },
--}

config.db = {
    prod = {
        HOST = "10.125.29.15",
        PORT = 3306,
        USER = "root",
        PASSWORD = "cloudos",
        DATABASE = "test_db",
    },
}

return config