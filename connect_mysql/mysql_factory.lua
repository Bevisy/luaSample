---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by z15085.
--- DateTime: 2019/9/5 19:33
---

local mysql = require("resty.mysql")

local mysql_pool = {}

--[[
    先从连接池获取连接，如果没有再建立连接。
    返回：
        false: 出错信息
        true: 数据库连接
--]]

function mysql_pool:get_connect(cfg)
    if ngx.ctx[mysql_pool] then
        return true, ngx.ctx[mysql_pool]
    end

    local client, errmsg = mysql:new()
    if not client then
        return false, "mysql.socket_failed: " .. (errmsg or "nil")
    end

    client:set_timeout(10000) -- TODO 单位???

    local options = {
        host = cfg.db.prod.HOST,
        port = cfg.db.prod.PORT,
        user = cfg.db.prod.USER,
        password = cfg.db.prod.PASSWORD,
        database = cfg.db.prod.DATABASE
    }

    local result, errmsg, errno, sqlstate = client:connect(options)
    if not result then
        return false, "mysql.cant_connect: " .. (errmsg or "nil") .. ", errno:" .. (errno or "nil") ..
                ", sql_state:" .. (sqlstate or "nil")
    end

    local query = "SET NAMES " .. "utf8"
    local result, errmsg, errno, sqlstate = client:query(query)
    if not result then
        return false, "mysql.query_failed: " .. (errmsg or "nil") .. ", errno:" .. (errno or "nil") ..
                ", sql_state:" .. (sqlstate or "nil")
    end

    ngx.ctx[mysql_pool] = client

    -- 测试，验证连接池重复使用情况
    --[[    local count, err = client:get_reused_times()
        ngx.say("mysql_pool used times: " .. count)]]

    return true, ngx.ctx[mysql_pool]
end

--[[
    把连接返回连接池
    使用 set_keepalive 代替 close() 将开启连接池特性，可以为每个nginx工作进程指定连接最大空间，和连接池最大连接数
]]
function mysql_pool:close()
    if ngx.ctx[mysql_pool] then
        -- 连接池机制，不调用 close 而是 keepalive 下次会继续直接使用
        -- lua_code_cache 为 on 时才生效
        -- 60000 : pool_max_idle_time
        -- 100 : connections
        ngx.ctx[mysql_pool]:set_keepalive(60000, 100)
        -- 调用了 set_keepalive，不能直接在此调用 query，否则会报错
        ngx.ctx[mysql_pool] = nil
    end
end

--[[
    查询
    有结果数据集时，返回数据集
    无数据数据集时，返回查询影响
    返回：
        false, 出错信息, sqlstate结构.
        true, 结果集， sqlstate结构.
]]
function mysql_pool:query(sql, flag)
    local ret, client = self:get_connect(flag)
    ngx.log(ngx.DEBUG, "query-- ", ret)
    if not ret then
        return false, client, nil
    end

    local result, errmsg, errno, sqlstate = client:query(sql)

    while errmsg == "again" do
        result, errmsg, errno, sqlstate = client:read_result()
    end

    self:close()

    if not result then
        errmsg = "mysql.query_failed:" .. (errno or "nil") .. (errmsg or "nil")
        return false, errmsg, sqlstate
    end

    return true, result, sqlstate
end

return mysql_pool